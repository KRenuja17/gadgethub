<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg">
                    <div class="card-header text-center">
                        <h3><i class="fas fa-sign-in-alt me-2"></i>Login to Your Account</h3>
                    </div>
                    <div class="card-body p-4">
                        
                        <!-- Alert Messages -->
                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show">
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </asp:Panel>

                        <!-- Login Form -->
                        <div class="mb-3">
                            <label for="txtUsername" class="form-label">
                                <i class="fas fa-user me-2"></i>Username
                            </label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                                         placeholder="Enter your username" required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                                                      ControlToValidate="txtUsername" 
                                                      ErrorMessage="Username is required" 
                                                      CssClass="text-danger small" 
                                                      Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="mb-3">
                            <label for="txtPassword" class="form-label">
                                <i class="fas fa-lock me-2"></i>Password
                            </label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                                         CssClass="form-control" placeholder="Enter your password" 
                                         required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                                      ControlToValidate="txtPassword" 
                                                      ErrorMessage="Password is required" 
                                                      CssClass="text-danger small" 
                                                      Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="mb-3 form-check">
                            <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label" for="chkRememberMe">
                                Remember me
                            </label>
                        </div>

                        <div class="d-grid">
                            <asp:Button ID="btnLogin" runat="server" Text="Login" 
                                       CssClass="btn btn-primary btn-lg" OnClick="btnLogin_Click" />
                        </div>

                        <hr class="my-4">

                        <div class="text-center">
                            <p class="mb-0">Don't have an account? 
                                <a href="Register.aspx" class="text-decoration-none">
                                    <strong>Register here</strong>
                                </a>
                            </p>
                        </div>

                        <!-- Demo Accounts -->
                        <div class="mt-4">
                            <h6 class="text-muted text-center mb-3">Demo Accounts</h6>
                            <div class="row text-center">
                                <div class="col-6">
                                    <small class="text-muted d-block">Admin</small>
                                    <code class="small">admin / admin123</code>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted d-block">Distributor</small>
                                    <code class="small">techworld / tech123</code>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>