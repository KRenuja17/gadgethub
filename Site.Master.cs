using System;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Update cart count if user is logged in
        if (Session["User"] != null)
        {
            User currentUser = (User)Session["User"];
            var cartItems = BusinessLogic.GetCartItems(currentUser.UserID);
            cartCount.InnerText = cartItems.Count.ToString();
        }
    }
}