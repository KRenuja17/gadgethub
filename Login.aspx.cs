using System;
using System.Web.UI;

public partial class Login : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // If user is already logged in, redirect to appropriate dashboard
        if (Session["User"] != null)
        {
            User currentUser = (User)Session["User"];
            RedirectToDashboard(currentUser.UserType);
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        try
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowMessage("Please enter both username and password.", "danger");
                return;
            }

            // Authenticate user
            User user = BusinessLogic.AuthenticateUser(username, password);

            if (user != null)
            {
                // Store user in session
                Session["User"] = user;
                Session["UserType"] = user.UserType;
                Session["UserID"] = user.UserID;

                // Log successful login
                LogActivity(user.UserID, "User Login", $"User {username} logged in successfully");

                // Redirect based on user type
                RedirectToDashboard(user.UserType);
            }
            else
            {
                ShowMessage("Invalid username or password. Please try again.", "danger");
                
                // Log failed login attempt
                LogActivity(null, "Failed Login", $"Failed login attempt for username: {username}");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("An error occurred during login. Please try again.", "danger");
            
            // Log error
            LogActivity(null, "Login Error", $"Login error: {ex.Message}");
        }
    }

    private void RedirectToDashboard(string userType)
    {
        switch (userType.ToLower())
        {
            case "admin":
                Response.Redirect("Admin/Dashboard.aspx");
                break;
            case "distributor":
                Response.Redirect("Distributor/Dashboard.aspx");
                break;
            case "client":
            default:
                Response.Redirect("Client/Dashboard.aspx");
                break;
        }
    }

    private void ShowMessage(string message, string type)
    {
        lblMessage.Text = message;
        pnlMessage.CssClass = $"alert alert-{type} alert-dismissible fade show";
        pnlMessage.Visible = true;
    }

    private void LogActivity(int? userId, string activity, string details)
    {
        try
        {
            string query = @"
                INSERT INTO ActivityLogs (UserID, Activity, Details, IPAddress)
                VALUES (@UserID, @Activity, @Details, @IPAddress)";

            System.Data.SqlClient.SqlParameter[] parameters = {
                new System.Data.SqlClient.SqlParameter("@UserID", userId ?? (object)DBNull.Value),
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