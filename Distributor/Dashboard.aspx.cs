using System;
using System.Data;
using System.Web.UI;

public partial class Distributor_Dashboard : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is logged in and is a distributor
        if (Session["User"] == null)
        {
            Response.Redirect("../Login.aspx");
            return;
        }

        User currentUser = (User)Session["User"];
        if (currentUser.UserType != "Distributor" || !currentUser.DistributorID.HasValue)
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
            // Set company name
            lblCompanyName.Text = user.CompanyName ?? "Distributor";

            // Load dashboard statistics
            LoadDashboardStats(user.DistributorID.Value);

            // Load recent activity
            LoadRecentQuotations(user.DistributorID.Value);
            LoadRecentOrders(user.DistributorID.Value);
        }
        catch (Exception ex)
        {
            Response.Write("<script>console.error('Dashboard load error: " + ex.Message + "');</script>");
        }
    }

    private void LoadDashboardStats(int distributorId)
    {
        try
        {
            // Product count
            string productQuery = "SELECT COUNT(*) FROM DistributorProducts WHERE DistributorID = @DistributorID AND IsAvailable = 1";
            var productParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@DistributorID", distributorId)
            };
            object productResult = DatabaseHelper.ExecuteScalar(productQuery, productParams);
            productCount.InnerText = productResult?.ToString() ?? "0";

            // Pending quotations count
            string quotationQuery = @"
                SELECT COUNT(DISTINCT q.QuotationID) 
                FROM Quotations q
                INNER JOIN QuotationItems qi ON q.QuotationID = qi.QuotationID
                LEFT JOIN QuotationResponses qr ON q.QuotationID = qr.QuotationID AND qr.DistributorID = @DistributorID
                WHERE q.Status = 'Pending' AND qr.ResponseID IS NULL";
            var quotationParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@DistributorID", distributorId)
            };
            object quotationResult = DatabaseHelper.ExecuteScalar(quotationQuery, quotationParams);
            pendingQuotations.InnerText = quotationResult?.ToString() ?? "0";

            // Total orders count
            string orderQuery = "SELECT COUNT(*) FROM OrderItems WHERE DistributorID = @DistributorID";
            var orderParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@DistributorID", distributorId)
            };
            object orderResult = DatabaseHelper.ExecuteScalar(orderQuery, orderParams);
            totalOrders.InnerText = orderResult?.ToString() ?? "0";

            // Total earnings
            string earningsQuery = @"
                SELECT ISNULL(SUM(oi.TotalPrice), 0) 
                FROM OrderItems oi
                INNER JOIN Orders o ON oi.OrderID = o.OrderID
                WHERE oi.DistributorID = @DistributorID AND o.Status != 'Cancelled'";
            var earningsParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@DistributorID", distributorId)
            };
            object earningsResult = DatabaseHelper.ExecuteScalar(earningsQuery, earningsParams);
            decimal earnings = Convert.ToDecimal(earningsResult ?? 0);
            totalEarnings.InnerText = "$" + earnings.ToString("F2");
        }
        catch (Exception ex)
        {
            // Set default values on error
            productCount.InnerText = "0";
            pendingQuotations.InnerText = "0";
            totalOrders.InnerText = "0";
            totalEarnings.InnerText = "$0.00";
        }
    }

    private void LoadRecentQuotations(int distributorId)
    {
        try
        {
            string query = @"
                SELECT TOP 5 q.QuotationID, q.QuotationNumber, q.RequestDate, q.Status
                FROM Quotations q
                INNER JOIN QuotationItems qi ON q.QuotationID = qi.QuotationID
                INNER JOIN DistributorProducts dp ON qi.ProductID = dp.ProductID AND dp.DistributorID = @DistributorID
                GROUP BY q.QuotationID, q.QuotationNumber, q.RequestDate, q.Status
                ORDER BY q.RequestDate DESC";

            var parameters = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@DistributorID", distributorId)
            };

            DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);
            gvRecentQuotations.DataSource = dt;
            gvRecentQuotations.DataBind();
        }
        catch (Exception ex)
        {
            gvRecentQuotations.DataSource = null;
            gvRecentQuotations.DataBind();
        }
    }

    private void LoadRecentOrders(int distributorId)
    {
        try
        {
            string query = @"
                SELECT TOP 5 o.OrderNumber, o.OrderDate, oi.TotalPrice, oi.Status
                FROM OrderItems oi
                INNER JOIN Orders o ON oi.OrderID = o.OrderID
                WHERE oi.DistributorID = @DistributorID
                ORDER BY o.OrderDate DESC";

            var parameters = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@DistributorID", distributorId)
            };

            DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);
            gvRecentOrders.DataSource = dt;
            gvRecentOrders.DataBind();
        }
        catch (Exception ex)
        {
            gvRecentOrders.DataSource = null;
            gvRecentOrders.DataBind();
        }
    }

    protected string GetQuotationStatusColor(string status)
    {
        switch (status?.ToLower())
        {
            case "pending":
                return "warning";
            case "responded":
                return "info";
            case "partially responded":
                return "primary";
            case "closed":
                return "success";
            default:
                return "secondary";
        }
    }

    protected string GetOrderStatusColor(string status)
    {
        switch (status?.ToLower())
        {
            case "pending":
                return "warning";
            case "processing":
                return "primary";
            case "shipped":
                return "info";
            case "delivered":
                return "success";
            default:
                return "secondary";
        }
    }
}