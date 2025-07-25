<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Client_Cart" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h2><i class="fas fa-shopping-cart me-3"></i>My Shopping Cart</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="../Default.aspx">Home</a></li>
                        <li class="breadcrumb-item"><a href="Dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active">Cart</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Alert Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </asp:Panel>

        <!-- Cart Items -->
        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-list me-2"></i>Cart Items</h5>
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                            <HeaderTemplate>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Quantity</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="product-image me-3" style="width: 60px; height: 60px; background: #f8f9fa; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                <%# !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? 
                                                    "<img src='" + Eval("ImageURL") + "' style='max-width: 100%; max-height: 100%; border-radius: 4px;' />" : 
                                                    "<i class='fas fa-mobile-alt text-muted'></i>" %>
                                            </div>
                                            <div>
                                                <h6 class="mb-1"><%# Eval("ProductName") %></h6>
                                                <small class="text-muted"><%# Eval("Brand") %></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="input-group" style="width: 120px;">
                                            <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control text-center" 
                                                         Text='<%# Eval("Quantity") %>' TextMode="Number" min="1" />
                                        </div>
                                    </td>
                                    <td>
                                        <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn btn-sm btn-outline-danger" 
                                                        CommandName="Remove" CommandArgument='<%# Eval("ProductID") %>'
                                                        OnClientClick="return confirm('Remove this item from cart?');">
                                            <i class="fas fa-trash"></i> Remove
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                        </tbody>
                                    </table>
                                </div>
                            </FooterTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false" CssClass="text-center py-5">
                            <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">Your cart is empty</h4>
                            <p class="text-muted">Add some products to get started!</p>
                            <a href="../Products.aspx" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>Browse Products
                            </a>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <!-- Cart Summary -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-calculator me-2"></i>Cart Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between">
                                <span>Total Items:</span>
                                <strong id="totalItems" runat="server">0</strong>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="d-grid gap-2">
                            <asp:Button ID="btnRequestQuotation" runat="server" Text="Request Quotation" 
                                       CssClass="btn btn-primary" OnClick="btnRequestQuotation_Click" />
                            <a href="../Products.aspx" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Continue Shopping
                            </a>
                        </div>
                        
                        <div class="mt-3">
                            <small class="text-muted">
                                <i class="fas fa-info-circle me-1"></i>
                                Request quotation to get prices from distributors
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>