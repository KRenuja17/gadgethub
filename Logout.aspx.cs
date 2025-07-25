using System;
using System.Web.UI;

public partial class Logout : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Log logout activity
        if (Session["User"] != null)
        {
            User currentUser = (User)Session["User"];
            LogActivity(currentUser.UserID, "User Logout", $"User {currentUser.Username} logged out");
        }

        // Clear all session data
        Session.Clear();
        Session.Abandon();

        // Redirect to home page
        Response.Redirect("Default.aspx");
    }

    private void LogActivity(int userId, string activity, string details)
    {
        try
        {
            string query = @"
                INSERT INTO ActivityLogs (UserID, Activity, Details, IPAddress)
                VALUES (@UserID, @Activity, @Details, @IPAddress)";

            System.Data.SqlClient.SqlParameter[] parameters = {
                new System.Data.SqlClient.SqlParameter("@UserID", userId),
                new System.Data.SqlClient.SqlParameter("@Activity", activity),
                new System.Data.SqlClient.SqlParameter("@Details", details),
                new System.Data.SqlClient.SqlParameter("@IPAddress", Request.UserHostAddress)
            };

            DatabaseHelper.ExecuteNonQuery(query, parameters);
        }
        catch
        {
            // Ignore logging errors
        }
    }
}