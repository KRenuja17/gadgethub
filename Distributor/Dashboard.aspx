<%@ Page Title="Distributor Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Distributor_Dashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-4">
        <!-- Welcome Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card bg-success text-white">
                    <div class="card-body text-center py-4">
                        <h2><i class="fas fa-store me-3"></i>Welcome, <asp:Label ID="lblCompanyName" runat="server"></asp:Label>!</h2>
                        <p class="mb-0">Manage your products, respond to quotations, and track orders</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Stats -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="dashboard-card">
                    <i class="fas fa-box fa-2x mb-2"></i>
                    <h4 id="productCount" runat="server">0</h4>
                    <p>My Products</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card success">
                    <i class="fas fa-file-invoice fa-2x mb-2"></i>
                    <h4 id="pendingQuotations" runat="server">0</h4>
                    <p>Pending Quotations</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card warning">
                    <i class="fas fa-shopping-cart fa-2x mb-2"></i>
                    <h4 id="totalOrders" runat="server">0</h4>
                    <p>Total Orders</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card info">
                    <i class="fas fa-dollar-sign fa-2x mb-2"></i>
                    <h4 id="totalEarnings" runat="server">$0</h4>
                    <p>Total Earnings</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <h4><i class="fas fa-bolt me-2"></i>Quick Actions</h4>
                <div class="row">
                    <div class="col-md-3 mb-2">
                        <a href="AddProduct.aspx" class="btn btn-outline-primary w-100">
                            <i class="fas fa-plus me-2"></i>Add Product
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="ManageProducts.aspx" class="btn btn-outline-success w-100">
                            <i class="fas fa-box me-2"></i>Manage Products
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="Quotations.aspx" class="btn btn-outline-warning w-100">
                            <i class="fas fa-file-invoice me-2"></i>View Quotations
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="Orders.aspx" class="btn btn-outline-info w-100">
                            <i class="fas fa-truck me-2"></i>My Orders
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-clock me-2"></i>Recent Quotations</h5>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvRecentQuotations" runat="server" CssClass="table table-sm" 
                                      AutoGenerateColumns="false" EmptyDataText="No recent quotations found.">
                            <Columns>
                                <asp:BoundField DataField="QuotationNumber" HeaderText="Quotation #" />
                                <asp:BoundField DataField="RequestDate" HeaderText="Date" DataFormatString="{0:MMM dd}" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class="badge bg-<%# GetQuotationStatusColor(Eval("Status").ToString()) %>">
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <a href="QuotationDetails.aspx?id=<%# Eval("QuotationID") %>" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-truck me-2"></i>Recent Orders</h5>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvRecentOrders" runat="server" CssClass="table table-sm" 
                                      AutoGenerateColumns="false" EmptyDataText="No recent orders found.">
                            <Columns>
                                <asp:BoundField DataField="OrderNumber" HeaderText="Order #" />
                                <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:MMM dd}" />
                                <asp:BoundField DataField="TotalPrice" HeaderText="Amount" DataFormatString="${0:F2}" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class="badge bg-<%# GetOrderStatusColor(Eval("Status").ToString()) %>">
                                            <%# Eval("Status") %>
                                        </span>
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