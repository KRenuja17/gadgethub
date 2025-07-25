<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Admin_Dashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-4">
        <!-- Welcome Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card bg-dark text-white">
                    <div class="card-body text-center py-4">
                        <h2><i class="fas fa-user-shield me-3"></i>Admin Dashboard</h2>
                        <p class="mb-0">Manage distributors, monitor orders, and view system analytics</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Stats -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="dashboard-card">
                    <i class="fas fa-store fa-2x mb-2"></i>
                    <h4 id="distributorCount" runat="server">0</h4>
                    <p>Active Distributors</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card success">
                    <i class="fas fa-box fa-2x mb-2"></i>
                    <h4 id="totalOrders" runat="server">0</h4>
                    <p>Total Orders</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card warning">
                    <i class="fas fa-users fa-2x mb-2"></i>
                    <h4 id="totalClients" runat="server">0</h4>
                    <p>Registered Clients</p>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="dashboard-card info">
                    <i class="fas fa-dollar-sign fa-2x mb-2"></i>
                    <h4 id="totalRevenue" runat="server">$0</h4>
                    <p>Total Revenue</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <h4><i class="fas fa-bolt me-2"></i>Quick Actions</h4>
                <div class="row">
                    <div class="col-md-3 mb-2">
                        <a href="CreateDistributor.aspx" class="btn btn-outline-primary w-100">
                            <i class="fas fa-plus me-2"></i>Create Distributor
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="ManageDistributors.aspx" class="btn btn-outline-success w-100">
                            <i class="fas fa-store me-2"></i>Manage Distributors
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="OrderReports.aspx" class="btn btn-outline-warning w-100">
                            <i class="fas fa-chart-bar me-2"></i>Order Reports
                        </a>
                    </div>
                    <div class="col-md-3 mb-2">
                        <a href="SystemLogs.aspx" class="btn btn-outline-info w-100">
                            <i class="fas fa-list-alt me-2"></i>System Logs
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Distributor Earnings Summary -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-chart-line me-2"></i>Distributor Earnings Summary</h5>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvDistributorEarnings" runat="server" CssClass="table table-striped" 
                                      AutoGenerateColumns="false" EmptyDataText="No distributor data found.">
                            <Columns>
                                <asp:BoundField DataField="CompanyName" HeaderText="Distributor" />
                                <asp:BoundField DataField="TotalOrders" HeaderText="Total Orders" />
                                <asp:BoundField DataField="TotalEarnings" HeaderText="Total Earnings" DataFormatString="${0:F2}" />
                                <asp:BoundField DataField="AverageOrderValue" HeaderText="Avg Order Value" DataFormatString="${0:F2}" />
                                <asp:TemplateField HeaderText="Performance">
                                    <ItemTemplate>
                                        <div class="progress" style="height: 20px;">
                                            <div class="progress-bar bg-success" role="progressbar" 
                                                 style="width: <%# GetPerformancePercentage(Eval("TotalEarnings")) %>%">
                                                <%# GetPerformancePercentage(Eval("TotalEarnings")) %>%
                                            </div>
                                        </div>
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