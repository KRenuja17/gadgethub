using System;
using System.Data;
using System.Web.UI;

public partial class Client_Dashboard : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is logged in and is a client
        if (Session["User"] == null)
        {
            Response.Redirect("../Login.aspx");
            return;
        }

        User currentUser = (User)Session["User"];
        if (currentUser.UserType != "Client")
        {
            Response.Redirect("../Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadDashboardData(currentUser);
        }
    }

    private void LoadDashboardData(User user)
    {
        try
        {
            // Set user name
            lblUserName.Text = user.FirstName + " " + user.LastName;

            // Load dashboard statistics
            LoadDashboardStats(user.UserID);

            // Load recent orders
            LoadRecentOrders(user.UserID);
        }
        catch (Exception ex)
        {
            // Log error
            Response.Write("<script>console.error('Dashboard load error: " + ex.Message + "');</script>");
        }
    }

    private void LoadDashboardStats(int userId)
    {
        try
        {
            // Cart items count
            var cartItems = BusinessLogic.GetCartItems(userId);
            cartCount.InnerText = cartItems.Count.ToString();

            // Quotations count
            string quotationQuery = "SELECT COUNT(*) FROM Quotations WHERE UserID = @UserID AND Status != 'Closed'";
            var quotationParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@UserID", userId)
            };
            object quotationResult = DatabaseHelper.ExecuteScalar(quotationQuery, quotationParams);
            quotationCount.InnerText = quotationResult?.ToString() ?? "0";

            // Total orders count
            string orderQuery = "SELECT COUNT(*) FROM Orders WHERE UserID = @UserID";
            var orderParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@UserID", userId)
            };
            object orderResult = DatabaseHelper.ExecuteScalar(orderQuery, orderParams);
            orderCount.InnerText = orderResult?.ToString() ?? "0";

            // Delivered orders count
            string deliveredQuery = "SELECT COUNT(*) FROM Orders WHERE UserID = @UserID AND Status = 'Delivered'";
            var deliveredParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@UserID", userId)
            };
            object deliveredResult = DatabaseHelper.ExecuteScalar(deliveredQuery, deliveredParams);
            deliveredCount.InnerText = deliveredResult?.ToString() ?? "0";
        }
        catch (Exception ex)
        {
            // Set default values on error
            cartCount.InnerText = "0";
            quotationCount.InnerText = "0";
            orderCount.InnerText = "0";
            deliveredCount.InnerText = "0";
        }
    }

    private void LoadRecentOrders(int userId)
    {
        try
        {
            string query = @"
                SELECT TOP 5 OrderID, OrderNumber, OrderDate, TotalAmount, Status
                FROM Orders 
                WHERE UserID = @UserID 
                ORDER BY OrderDate DESC";

            var parameters = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@UserID", userId)
            };

            DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);
            gvRecentOrders.DataSource = dt;
            gvRecentOrders.DataBind();
        }
        catch (Exception ex)
        {
            // Handle error
            gvRecentOrders.DataSource = null;
            gvRecentOrders.DataBind();
        }
    }

    protected string GetStatusColor(string status)
    {
        switch (status?.ToLower())
        {
            case "placed":
                return "primary";
            case "processing":
                return "warning";
            case "shipped":
                return "info";
            case "delivered":
                return "success";
            case "cancelled":
                return "danger";
            default:
                return "secondary";
        }
    }
}