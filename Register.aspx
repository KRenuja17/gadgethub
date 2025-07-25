<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-lg">
                    <div class="card-header text-center">
                        <h3><i class="fas fa-user-plus me-2"></i>Create Your Account</h3>
                    </div>
                    <div class="card-body p-4">
                        
                        <!-- Alert Messages -->
                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible fade show">
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </asp:Panel>

                        <!-- Registration Form -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="txtFirstName" class="form-label">
                                    <i class="fas fa-user me-2"></i>First Name *
                                </label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" 
                                             placeholder="Enter first name" required="true"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                                                          ControlToValidate="txtFirstName" 
                                                          ErrorMessage="First name is required" 
                                                          CssClass="text-danger small" 
                                                          Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="txtLastName" class="form-label">
                                    <i class="fas fa-user me-2"></i>Last Name *
                                </label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" 
                                             placeholder="Enter last name" required="true"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                                                          ControlToValidate="txtLastName" 
                                                          ErrorMessage="Last name is required" 
                                                          CssClass="text-danger small" 
                                                          Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="txtUsername" class="form-label">
                                <i class="fas fa-at me-2"></i>Username *
                            </label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                                         placeholder="Choose a username" required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                                                      ControlToValidate="txtUsername" 
                                                      ErrorMessage="Username is required" 
                                                      CssClass="text-danger small" 
                                                      Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="mb-3">
                            <label for="txtEmail" class="form-label">
                                <i class="fas fa-envelope me-2"></i>Email Address *
                            </label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" 
                                         CssClass="form-control" placeholder="Enter email address" 
                                         required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                                      ControlToValidate="txtEmail" 
                                                      ErrorMessage="Email is required" 
                                                      CssClass="text-danger small" 
                                                      Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                                          ControlToValidate="txtEmail" 
                                                          ErrorMessage="Please enter a valid email address" 
                                                          ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" 
                                                          CssClass="text-danger small" 
                                                          Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>

                        <div class="mb-3">
                            <label for="txtPhone" class="form-label">
                                <i class="fas fa-phone me-2"></i>Phone Number
                            </label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" 
                                         placeholder="Enter phone number (optional)"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label for="txtPassword" class="form-label">
                                <i class="fas fa-lock me-2"></i>Password *
                            </label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                                         CssClass="form-control" placeholder="Create a password" 
                                         required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                                      ControlToValidate="txtPassword" 
                                                      ErrorMessage="Password is required" 
                                                      CssClass="text-danger small" 
                                                      Display="Dynamic"></asp:RequiredFieldValidator>
                            <small class="text-muted">Password should be at least 6 characters long</small>
                        </div>

                        <div class="mb-3">
                            <label for="txtConfirmPassword" class="form-label">
                                <i class="fas fa-lock me-2"></i>Confirm Password *
                            </label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" 
                                         CssClass="form-control" placeholder="Confirm your password" 
                                         required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                                                      ControlToValidate="txtConfirmPassword" 
                                                      ErrorMessage="Please confirm your password" 
                                                      CssClass="text-danger small" 
                                                      Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cvPassword" runat="server" 
                                                ControlToValidate="txtConfirmPassword" 
                                                ControlToCompare="txtPassword" 
                                                ErrorMessage="Passwords do not match" 
                                                CssClass="text-danger small" 
                                                Display="Dynamic"></asp:CompareValidator>
                        </div>

                        <div class="mb-3">
                            <label for="txtAddress" class="form-label">
                                <i class="fas fa-map-marker-alt me-2"></i>Address
                            </label>
                            <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" 
                                         Rows="3" CssClass="form-control" 
                                         placeholder="Enter your address (optional)"></asp:TextBox>
                        </div>

                        <div class="mb-3 form-check">
                            <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" required="true" />
                            <label class="form-check-label" for="chkTerms">
                                I agree to the <a href="#" class="text-decoration-none">Terms and Conditions</a> *
                            </label>
                            <asp:RequiredFieldValidator ID="rfvTerms" runat="server" 
                                                      ControlToValidate="chkTerms" 
                                                      ErrorMessage="You must agree to the terms and conditions" 
                                                      CssClass="text-danger small d-block" 
                                                      Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="d-grid">
                            <asp:Button ID="btnRegister" runat="server" Text="Create Account" 
                                       CssClass="btn btn-primary btn-lg" OnClick="btnRegister_Click" />
                        </div>

                        <hr class="my-4">

                        <div class="text-center">
                            <p class="mb-0">Already have an account? 
                                <a href="Login.aspx" class="text-decoration-none">
                                    <strong>Login here</strong>
                                </a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>