<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Products.aspx.cs" Inherits="Products" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h2><i class="fas fa-th-large me-3"></i>All Products</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="Default.aspx">Home</a></li>
                        <li class="breadcrumb-item active">Products</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Search and Filter Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row align-items-end">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-search me-2"></i>Search Products
                                </label>
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" 
                                             placeholder="Search for products, brands, or models..."></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-filter me-2"></i>Category
                                </label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="" Text="All Categories"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnSearch" runat="server" Text="Search" 
                                           CssClass="btn btn-primary w-100" OnClick="btnSearch_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="row" id="productGrid" runat="server">
            <!-- Products will be loaded here -->
        </div>

        <!-- Pagination -->
        <div class="row mt-4">
            <div class="col-12 d-flex justify-content-center">
                <nav>
                    <ul class="pagination">
                        <li class="page-item" id="prevPage" runat="server">
                            <asp:LinkButton ID="lnkPrevious" runat="server" CssClass="page-link" OnClick="lnkPrevious_Click">
                                <i class="fas fa-chevron-left me-1"></i>Previous
                            </asp:LinkButton>
                        </li>
                        <li class="page-item active">
                            <span class="page-link" id="currentPage" runat="server">1</span>
                        </li>
                        <li class="page-item" id="nextPage" runat="server">
                            <asp:LinkButton ID="lnkNext" runat="server" CssClass="page-link" OnClick="lnkNext_Click">
                                Next<i class="fas fa-chevron-right ms-1"></i>
                            </asp:LinkButton>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        // Add to cart functionality (same as Default.aspx)
        function addToCart(productId, productName) {
            <% if (Session["User"] != null) { %>
                $.ajax({
                    type: "POST",
                    url: "Products.aspx/AddToCart",
                    data: JSON.stringify({ productId: productId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response.d) {
                            showAlert('success', productName + ' added to cart successfully!');
                            updateCartCount();
                        } else {
                            showAlert('danger', 'Failed to add item to cart. Please try again.');
                        }
                    },
                    error: function() {
                        showAlert('danger', 'An error occurred. Please try again.');
                    }
                });
            <% } else { %>
                showAlert('warning', 'Please login to add items to cart.');
                setTimeout(function() {
                    window.location.href = 'Login.aspx';
                }, 2000);
            <% } %>
        }

        function showAlert(type, message) {
            const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show position-fixed" 
                     style="top: 20px; right: 20px; z-index: 9999; min-width: 300px;">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>`;
            
            $('body').append(alertHtml);
            
            setTimeout(function() {
                $('.alert').alert('close');
            }, 3000);
        }

        function updateCartCount() {
            const cartBadge = document.querySelector('#cartCount');
            if (cartBadge) {
                const currentCount = parseInt(cartBadge.textContent) || 0;
                cartBadge.textContent = currentCount + 1;
            }
        }
    </script>
</asp:Content>