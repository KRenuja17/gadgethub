using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.Services;
using System.Text;

public partial class Products : Page
{
    private int currentPage = 1;
    private const int pageSize = 9;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();
            LoadProducts();
        }
    }

    private void LoadCategories()
    {
        try
        {
            List<Category> categories = BusinessLogic.GetCategories();
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem("All Categories", ""));
            
            foreach (Category category in categories)
            {
                ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem(category.CategoryName, category.CategoryID.ToString()));
            }
        }
        catch (Exception ex)
        {
            Response.Write("<script>console.error('Error loading categories: " + ex.Message + "');</script>");
        }
    }

    private void LoadProducts()
    {
        try
        {
            if (ViewState["CurrentPage"] != null)
            {
                currentPage = (int)ViewState["CurrentPage"];
            }

            int? categoryId = null;
            if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                categoryId = Convert.ToInt32(ddlCategory.SelectedValue);
            }

            string searchTerm = txtSearch.Text.Trim();
            if (string.IsNullOrEmpty(searchTerm))
            {
                searchTerm = null;
            }

            List<Product> products = BusinessLogic.GetProducts(categoryId, searchTerm, currentPage, pageSize);
            
            StringBuilder html = new StringBuilder();
            
            if (products.Count == 0)
            {
                html.Append("<div class='col-12 text-center py-5'>");
                html.Append("<i class='fas fa-search fa-3x text-muted mb-3'></i>");
                html.Append("<h4 class='text-muted'>No products found</h4>");
                html.Append("<p class='text-muted'>Try adjusting your search criteria or browse all categories.</p>");
                html.Append("</div>");
            }
            else
            {
                foreach (Product product in products)
                {
                    html.Append("<div class='col-lg-4 col-md-6 mb-4'>");
                    html.Append("  <div class='product-card'>");
                    
                    // Product Image
                    html.Append("    <div class='product-image'>");
                    if (!string.IsNullOrEmpty(product.ImageURL))
                    {
                        html.Append($"      <img src='{product.ImageURL}' alt='{product.ProductName}' />");
                    }
                    else
                    {
                        html.Append("      <i class='fas fa-mobile-alt placeholder-icon'></i>");
                    }
                    html.Append("    </div>");
                    
                    // Product Info
                    html.Append("    <div class='product-info'>");
                    html.Append($"      <div class='product-brand'>{product.Brand}</div>");
                    html.Append($"      <h5 class='product-title'>{product.ProductName}</h5>");
                    html.Append($"      <p class='product-description'>{product.Description}</p>");
                    
                    // Price Range
                    if (product.MinPrice > 0)
                    {
                        if (product.MinPrice == product.MaxPrice)
                        {
                            html.Append($"      <div class='price-range'>${product.MinPrice:F2}</div>");
                        }
                        else
                        {
                            html.Append($"      <div class='price-range'>${product.MinPrice:F2} - ${product.MaxPrice:F2}</div>");
                        }
                    }
                    else
                    {
                        html.Append("      <div class='price-range text-muted'>Price on request</div>");
                    }
                    
                    // Distributor Count
                    html.Append($"      <small class='text-muted'><i class='fas fa-store me-1'></i>{product.DistributorCount} distributor(s)</small>");
                    
                    // Add to Cart Button
                    html.Append("      <div class='mt-3'>");
                    html.Append($"        <button type='button' class='btn btn-primary w-100' onclick='addToCart({product.ProductID}, \"{product.ProductName}\")'>");
                    html.Append("          <i class='fas fa-cart-plus me-2'></i>Add to Cart");
                    html.Append("        </button>");
                    html.Append("      </div>");
                    
                    html.Append("    </div>");
                    html.Append("  </div>");
                    html.Append("</div>");
                }
            }
            
            productGrid.InnerHtml = html.ToString();
            UpdatePagination(products.Count);
        }
        catch (Exception ex)
        {
            productGrid.InnerHtml = $"<div class='col-12'><div class='alert alert-danger'>Error loading products: {ex.Message}</div></div>";
        }
    }

    private void UpdatePagination(int productCount)
    {
        currentPage.InnerText = ViewState["CurrentPage"]?.ToString() ?? "1";
        
        if (ViewState["CurrentPage"] == null || (int)ViewState["CurrentPage"] <= 1)
        {
            prevPage.Visible = false;
        }
        else
        {
            prevPage.Visible = true;
        }
        
        if (productCount < pageSize)
        {
            nextPage.Visible = false;
        }
        else
        {
            nextPage.Visible = true;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["CurrentPage"] = 1;
        LoadProducts();
    }

    protected void lnkPrevious_Click(object sender, EventArgs e)
    {
        int page = ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1;
        if (page > 1)
        {
            ViewState["CurrentPage"] = page - 1;
            LoadProducts();
        }
    }

    protected void lnkNext_Click(object sender, EventArgs e)
    {
        int page = ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1;
        ViewState["CurrentPage"] = page + 1;
        LoadProducts();
    }

    [WebMethod]
    public static bool AddToCart(int productId)
    {
        try
        {
            if (System.Web.HttpContext.Current.Session["User"] != null)
            {
                User currentUser = (User)System.Web.HttpContext.Current.Session["User"];
                return BusinessLogic.AddToCart(currentUser.UserID, productId);
            }
            return false;
        }
        catch
        {
            return false;
        }
    }
}