using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Client_Cart : Page
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
            LoadCartItems(currentUser.UserID);
        }
    }

    private void LoadCartItems(int userId)
    {
        try
        {
            List<CartItem> cartItems = BusinessLogic.GetCartItems(userId);
            
            if (cartItems.Count > 0)
            {
                rptCartItems.DataSource = cartItems;
                rptCartItems.DataBind();
                rptCartItems.Visible = true;
                pnlEmptyCart.Visible = false;
                
                totalItems.InnerText = cartItems.Count.ToString();
                btnRequestQuotation.Enabled = true;
            }
            else
            {
                rptCartItems.Visible = false;
                pnlEmptyCart.Visible = true;
                totalItems.InnerText = "0";
                btnRequestQuotation.Enabled = false;
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading cart items: " + ex.Message, "danger");
        }
    }

    protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            try
            {
                User currentUser = (User)Session["User"];
                int productId = Convert.ToInt32(e.CommandArgument);
                
                bool success = BusinessLogic.RemoveFromCart(currentUser.UserID, productId);
                
                if (success)
                {
                    ShowMessage("Item removed from cart successfully!", "success");
                    LoadCartItems(currentUser.UserID);
                }
                else
                {
                    ShowMessage("Failed to remove item from cart.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error removing item: " + ex.Message, "danger");
            }
        }
    }

    protected void btnRequestQuotation_Click(object sender, EventArgs e)
    {
        try
        {
            User currentUser = (User)Session["User"];
            List<CartItem> cartItems = BusinessLogic.GetCartItems(currentUser.UserID);
            
            if (cartItems.Count == 0)
            {
                ShowMessage("Your cart is empty. Add some items first.", "warning");
                return;
            }

            // Create quotation
            string quotationNumber = BusinessLogic.GenerateQuotationNumber();
            
            string insertQuotationQuery = @"
                INSERT INTO Quotations (UserID, QuotationNumber, Status, Notes)
                OUTPUT INSERTED.QuotationID
                VALUES (@UserID, @QuotationNumber, 'Pending', 'Quotation requested from cart')";

            var quotationParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@UserID", currentUser.UserID),
                new System.Data.SqlClient.SqlParameter("@QuotationNumber", quotationNumber)
            };

            object quotationIdObj = DatabaseHelper.ExecuteScalar(insertQuotationQuery, quotationParams);
            int quotationId = Convert.ToInt32(quotationIdObj);

            // Add quotation items
            foreach (CartItem item in cartItems)
            {
                string insertItemQuery = @"
                    INSERT INTO QuotationItems (QuotationID, ProductID, RequestedQuantity)
                    VALUES (@QuotationID, @ProductID, @RequestedQuantity)";

                var itemParams = new System.Data.SqlClient.SqlParameter[] {
                    new System.Data.SqlClient.SqlParameter("@QuotationID", quotationId),
                    new System.Data.SqlClient.SqlParameter("@ProductID", item.ProductID),
                    new System.Data.SqlClient.SqlParameter("@RequestedQuantity", item.Quantity)
                };

                DatabaseHelper.ExecuteNonQuery(insertItemQuery, itemParams);
            }

            // Clear cart after creating quotation
            string clearCartQuery = "DELETE FROM ShoppingCart WHERE UserID = @UserID";
            var clearParams = new System.Data.SqlClient.SqlParameter[] {
                new System.Data.SqlClient.SqlParameter("@UserID", currentUser.UserID)
            };
            DatabaseHelper.ExecuteNonQuery(clearCartQuery, clearParams);

            // Redirect to quotations page
            Response.Redirect("Quotations.aspx?success=1&quotation=" + quotationNumber);
        }
        catch (Exception ex)
        {
            ShowMessage("Error creating quotation: " + ex.Message, "danger");
        }
    }

    private void ShowMessage(string message, string type)
    {
        lblMessage.Text = message;
        pnlMessage.CssClass = $"alert alert-{type} alert-dismissible fade show";
        pnlMessage.Visible = true;
    }
}