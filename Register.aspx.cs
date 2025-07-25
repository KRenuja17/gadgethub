using System;
using System.Web.UI;

public partial class Register : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // If user is already logged in, redirect to dashboard
        if (Session["User"] != null)
        {
            Response.Redirect("Default.aspx");
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        try
        {
            // Validate form data
            if (!Page.IsValid)
            {
                return;
            }

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string email = txtEmail.Text.Trim();
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();

            // Additional validation
            if (password.Length < 6)
            {
                ShowMessage("Password must be at least 6 characters long.", "danger");
                return;
            }

            // Check if username already exists
            if (IsUsernameExists(username))
            {
                ShowMessage("Username already exists. Please choose a different username.", "danger");
                return;
            }

            // Check if email already exists
            if (IsEmailExists(email))
            {
                ShowMessage("Email address already registered. Please use a different email.", "danger");
                return;
            }

            // Register the user
            bool success = BusinessLogic.RegisterUser(username, password, email, firstName, lastName, phone, address);

            if (success)
            {
                ShowMessage("Account created successfully! You can now login with your credentials.", "success");
                
                // Clear form
                ClearForm();
                
                // Log successful registration
                LogActivity(null, "User Registration", $"New user registered: {username} ({email})");
                
                // Redirect to login page after 3 seconds
                Response.AddHeader("REFRESH", "3;URL=Login.aspx");
            }
            else
            {
                ShowMessage("Registration failed. Please try again.", "danger");
            }
        }
        catch (Exception ex)
        {
            ShowMessage("An error occurred during registration. Please try again.", "danger");
            
            // Log error
            LogActivity(null, "Registration Error", $"Registration error: {ex.Message}");
        }
    }

    private bool IsUsernameExists(string username)
    {
        try
        {
            string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
            System.Data.SqlClient.SqlParameter[] parameters = {
                new System.Data.SqlClient.SqlParameter("@Username", username)
            };

            object result = DatabaseHelper.ExecuteScalar(query, parameters);
            return Convert.ToInt32(result) > 0;
        }
        catch
        {
            return false;
        }
    }

    private bool IsEmailExists(string email)
    {
        try
        {
            string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
            System.Data.SqlClient.SqlParameter[] parameters = {
                new System.Data.SqlClient.SqlParameter("@Email", email)
            };

            object result = DatabaseHelper.ExecuteScalar(query, parameters);
            return Convert.ToInt32(result) > 0;
        }
        catch
        {
            return false;
        }
    }

    private void ShowMessage(string message, string type)
    {
        lblMessage.Text = message;
        pnlMessage.CssClass = $"alert alert-{type} alert-dismissible fade show";
        pnlMessage.Visible = true;
    }

    private void ClearForm()
    {
        txtUsername.Text = "";
        txtPassword.Text = "";
        txtConfirmPassword.Text = "";
        txtEmail.Text = "";
        txtFirstName.Text = "";
        txtLastName.Text = "";
        txtPhone.Text = "";
        txtAddress.Text = "";
        chkTerms.Checked = false;
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