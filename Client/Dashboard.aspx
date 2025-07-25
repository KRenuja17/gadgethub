<%@ Page Title="Client Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Client_Dashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-4">
        <!-- Welcome Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center py-4">
                        <h2><i class="fas fa-user-circle me-3"></i>Welcome, <asp:Label ID="lblUserName" runat="server"></asp:Label>!</h2>
                        <p class="mb-0">Manage your orders, cart, and quotations from your personal dashboard</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Stats -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="dashboard-card">
                    <i class="fas fa-shopping-cart fa-2x mb-2"></i>
                    <h4 id="cartCount" runat="server">0</h4>
                    <p>Items in Cart</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card success">
                    <i class="fas fa-file-invoice fa-2x mb-2"></i>
                    <h4 id="quotationCount" runat="server">0</h4>
                    <p>Active Quotations</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card warning">
                    <i class="fas fa-box fa-2x mb-2"></i>
                    <h4 id="orderCount" runat="server">0</h4>
                    <p>Total Orders</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card info">
                    <i class="fas fa-truck fa-2x mb-2"></i>
                    <h4 id="deliveredCount" runat="server">0</h4>
                    <p>Delivered Orders</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <h4><i class="fas fa-bolt me-2"></i>Quick Actions</h4>
                <div class="row">
                    <div class="col-md-3 mb-2">
                        <a href="../Products.aspx" class="btn btn-outline-primary w-100">
                            <i class="fas fa-search me-2"></i>Browse Products
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="Cart.aspx" class="btn btn-outline-success w-100">
                            <i class="fas fa-shopping-cart me-2"></i>View Cart
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="Quotations.aspx" class="btn btn-outline-warning w-100">
                            <i class="fas fa-file-invoice me-2"></i>My Quotations
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="Orders.aspx" class="btn btn-outline-info w-100">
                            <i class="fas fa-box me-2"></i>My Orders
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-history me-2"></i>Recent Orders</h5>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvRecentOrders" runat="server" CssClass="table table-striped" 
                                      AutoGenerateColumns="false" EmptyDataText="No recent orders found.">
                            <Columns>
                                <asp:BoundField DataField="OrderNumber" HeaderText="Order #" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="${0:F2}" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class="badge bg-<%# GetStatusColor(Eval("Status").ToString()) %>">
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <a href="OrderDetails.aspx?id=<%# Eval("OrderID") %>" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>