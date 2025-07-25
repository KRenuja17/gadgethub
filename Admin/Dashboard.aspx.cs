using System;
using System.Data;
using System.Web.UI;

public partial class Admin_Dashboard : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is logged in and is an admin
        if (Session["User"] == null)
        {
            Response.Redirect("../Login.aspx");
            return;
        }

        User currentUser = (User)Session["User"];
        if (currentUser.UserType != "Admin")
        {
            Response.Redirect("../Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadDashboardData();
        }
    }

    private void LoadDashboardData()
    {
        try
        {
            LoadDashboardStats();
            LoadDistributorEarnings();
        }
        catch (Exception ex)
        {
            Response.Write("<script>console.error('Dashboard load error: " + ex.Message + "');</script>");
        }
    }

    private void LoadDashboardStats()
    {
        try
        {
            // Active distributors count
            string distributorQuery = "SELECT COUNT(*) FROM Distributors WHERE IsApproved = 1";
            object distributorResult = DatabaseHelper.ExecuteScalar(distributorQuery);
            distributorCount.InnerText = distributorResult?.ToString() ?? "0";

            // Total orders count
            string orderQuery = "SELECT COUNT(*) FROM Orders";
            object orderResult = DatabaseHelper.ExecuteScalar(orderQuery);
            totalOrders.InnerText = orderResult?.ToString() ?? "0";

            // Total clients count
            string clientQuery = "SELECT COUNT(*) FROM Users u INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID WHERE ut.TypeName = 'Client'";
            object clientResult = DatabaseHelper.ExecuteScalar(clientQuery);
            totalClients.InnerText = clientResult?.ToString() ?? "0";

            // Total revenue
            string revenueQuery = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders WHERE Status != 'Cancelled'";
            object revenueResult = DatabaseHelper.ExecuteScalar(revenueQuery);
            decimal revenue = Convert.ToDecimal(revenueResult ?? 0);
            totalRevenue.InnerText = "$" + revenue.ToString("F2");
        }
        catch (Exception ex)
        {
            // Set default values on error
            distributorCount.InnerText = "0";
            totalOrders.InnerText = "0";
            totalClients.InnerText = "0";
            totalRevenue.InnerText = "$0.00";
        }
    }

    private void LoadDistributorEarnings()
    {
        try
        {
            string query = @"
                SELECT 
                    d.CompanyName,
                    ISNULL(COUNT(DISTINCT o.OrderID), 0) AS TotalOrders,
                    ISNULL(SUM(oi.TotalPrice), 0) AS TotalEarnings,
                    ISNULL(AVG(oi.TotalPrice), 0) AS AverageOrderValue
                FROM Distributors d
                LEFT JOIN OrderItems oi ON d.DistributorID = oi.DistributorID
                LEFT JOIN Orders o ON oi.OrderID = o.OrderID AND o.Status != 'Cancelled'
                WHERE d.IsApproved = 1
                GROUP BY d.DistributorID, d.CompanyName
                ORDER BY TotalEarnings DESC";

            DataTable dt = DatabaseHelper.ExecuteQuery(query);
            gvDistributorEarnings.DataSource = dt;
            gvDistributorEarnings.DataBind();
        }
        catch (Exception ex)
        {
            gvDistributorEarnings.DataSource = null;
            gvDistributorEarnings.DataBind();
        }
    }

    protected string GetPerformancePercentage(object earnings)
    {
        try
        {
            decimal earningsValue = Convert.ToDecimal(earnings ?? 0);
            
            // Get max earnings for percentage calculation
            string maxQuery = @"
                SELECT ISNULL(MAX(TotalEarnings), 1) FROM (
                    SELECT ISNULL(SUM(oi.TotalPrice), 0) AS TotalEarnings
                    FROM Distributors d
                    LEFT JOIN OrderItems oi ON d.DistributorID = oi.DistributorID
                    LEFT JOIN Orders o ON oi.OrderID = o.OrderID AND o.Status != 'Cancelled'
                    WHERE d.IsApproved = 1
                    GROUP BY d.DistributorID
                ) AS EarningsData";
            
            object maxResult = DatabaseHelper.ExecuteScalar(maxQuery);
            decimal maxEarnings = Convert.ToDecimal(maxResult ?? 1);
            
            if (maxEarnings == 0) maxEarnings = 1; // Avoid division by zero
            
            decimal percentage = (earningsValue / maxEarnings) * 100;
            return Math.Round(percentage, 0).ToString();
        }
        catch
        {
            return "0";
        }
    }
}