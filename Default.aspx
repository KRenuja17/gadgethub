<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="hero-title">
                <i class="fas fa-mobile-alt me-3"></i>
                Welcome to The Gadget Hub
            </h1>
            <p class="hero-subtitle">
                Discover the latest gadgets and electronics from trusted distributors
            </p>
        </div>
    </section>

    <div class="container">
        <!-- Search Section -->
        <div class="search-section">
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

        <!-- Banner Carousel -->
        <div id="bannerCarousel" class="carousel slide mb-5" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="0" class="active"></button>
                <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="1"></button>
                <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="2"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg?auto=compress&cs=tinysrgb&w=1200&h=400&fit=crop" 
                         class="d-block w-100" alt="Latest Smartphones">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>Latest Smartphones</h5>
                        <p>Discover the newest iPhone and Android devices with cutting-edge technology.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="https://images.pexels.com/photos/18105/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1200&h=400&fit=crop" 
                         class="d-block w-100" alt="Powerful Laptops">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>Powerful Laptops</h5>
                        <p>High-performance laptops for work, gaming, and creative projects.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="https://images.pexels.com/photos/1334597/pexels-photo-1334597.jpeg?auto=compress&cs=tinysrgb&w=1200&h=400&fit=crop" 
                         class="d-block w-100" alt="Smart Accessories">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>Smart Accessories</h5>
                        <p>Complete your setup with the latest accessories and wearables.</p>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>

        <!-- Products Section -->
        <div class="row mb-4">
            <div class="col-12">
                <h2 class="text-center mb-4">
                    <i class="fas fa-star me-2 text-warning"></i>
                    Featured Products
                </h2>
            </div>
        </div>

        <!-- Product Grid -->
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

        <!-- Features Section -->
        <div class="row mt-5 mb-4">
            <div class="col-md-4 text-center mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <i class="fas fa-shipping-fast fa-3x text-primary mb-3"></i>
                        <h5>Fast Delivery</h5>
                        <p class="text-muted">Quick delivery from multiple distributors across the region.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 text-center mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <i class="fas fa-shield-alt fa-3x text-success mb-3"></i>
                        <h5>Quality Assured</h5>
                        <p class="text-muted">All products are verified and come with manufacturer warranty.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 text-center mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <i class="fas fa-headset fa-3x text-info mb-3"></i>
                        <h5>24/7 Support</h5>
                        <p class="text-muted">Round-the-clock customer support for all your queries.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        // Add to cart functionality
        function addToCart(productId, productName) {
            <% if (Session["User"] != null) { %>
                // User is logged in, proceed with AJAX call
                $.ajax({
                    type: "POST",
                    url: "Default.aspx/AddToCart",
                    data: JSON.stringify({ productId: productId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response.d) {
                            // Show success message
                            showAlert('success', productName + ' added to cart successfully!');
                            // Update cart count
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
                // User not logged in, redirect to login
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
            
            // Auto dismiss after 3 seconds
            setTimeout(function() {
                $('.alert').alert('close');
            }, 3000);
        }

        function updateCartCount() {
            // This would typically be an AJAX call to get updated cart count
            // For now, we'll just increment the visible count
            const cartBadge = document.querySelector('#cartCount');
            if (cartBadge) {
                const currentCount = parseInt(cartBadge.textContent) || 0;
                cartBadge.textContent = currentCount + 1;
            }
        }
    </script>
</asp:Content>