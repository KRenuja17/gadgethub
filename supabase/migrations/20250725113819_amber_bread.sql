-- =============================================
-- The Gadget Hub - Complete Database Schema
-- CSE5013 Student Project
-- =============================================

CREATE DATABASE GadgetHub;
GO

USE GadgetHub;
GO

-- =============================================
-- 1. USER ROLES AND AUTHENTICATION
-- =============================================

-- User Types Table
CREATE TABLE UserTypes (
    UserTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(200),
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

-- Users Table (for Clients, Admin, Distributors)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL, -- Should be hashed in real application
    Email NVARCHAR(100) UNIQUE,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(500),
    UserTypeID INT NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    LastLoginDate DATETIME2,
    FOREIGN KEY (UserTypeID) REFERENCES UserTypes(UserTypeID)
);

-- =============================================
-- 2. DISTRIBUTOR MANAGEMENT
-- =============================================

-- Distributors Table
CREATE TABLE Distributors (
    DistributorID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CompanyName NVARCHAR(100) NOT NULL,
    BusinessLicense NVARCHAR(100),
    ContactPerson NVARCHAR(100),
    BusinessAddress NVARCHAR(500),
    TaxNumber NVARCHAR(50),
    IsApproved BIT DEFAULT 0,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- =============================================
-- 3. PRODUCT MANAGEMENT
-- =============================================

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(300),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

-- Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    Description NVARCHAR(1000),
    ImageURL NVARCHAR(500),
    Brand NVARCHAR(100),
    Model NVARCHAR(100),
    Specifications NVARCHAR(2000),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Distributor Products (Products offered by each distributor with their prices)
CREATE TABLE DistributorProducts (
    DistributorProductID INT IDENTITY(1,1) PRIMARY KEY,
    DistributorID INT NOT NULL,
    ProductID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    QuantityInStock INT DEFAULT 0,
    IsAvailable BIT DEFAULT 1,
    LastUpdated DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (DistributorID) REFERENCES Distributors(DistributorID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    UNIQUE(DistributorID, ProductID)
);

-- =============================================
-- 4. SHOPPING CART
-- =============================================

-- Shopping Cart
CREATE TABLE ShoppingCart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    AddedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    UNIQUE(UserID, ProductID)
);

-- =============================================
-- 5. QUOTATION SYSTEM
-- =============================================

-- Quotations
CREATE TABLE Quotations (
    QuotationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    QuotationNumber NVARCHAR(50) NOT NULL UNIQUE,
    RequestDate DATETIME2 DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT 'Pending', -- Pending, Responded, Partially Responded, Closed
    Notes NVARCHAR(1000),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Quotation Items
CREATE TABLE QuotationItems (
    QuotationItemID INT IDENTITY(1,1) PRIMARY KEY,
    QuotationID INT NOT NULL,
    ProductID INT NOT NULL,
    RequestedQuantity INT NOT NULL,
    FOREIGN KEY (QuotationID) REFERENCES Quotations(QuotationID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Quotation Responses from Distributors
CREATE TABLE QuotationResponses (
    ResponseID INT IDENTITY(1,1) PRIMARY KEY,
    QuotationID INT NOT NULL,
    DistributorID INT NOT NULL,
    ProductID INT NOT NULL,
    QuotedPrice DECIMAL(10,2),
    AvailableQuantity INT,
    DeliveryDays INT,
    IsAvailable BIT DEFAULT 1,
    ResponseDate DATETIME2 DEFAULT GETDATE(),
    Notes NVARCHAR(500),
    FOREIGN KEY (QuotationID) REFERENCES Quotations(QuotationID),
    FOREIGN KEY (DistributorID) REFERENCES Distributors(DistributorID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- =============================================
-- 6. ORDER MANAGEMENT
-- =============================================

-- Orders
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    OrderNumber NVARCHAR(50) NOT NULL UNIQUE,
    OrderDate DATETIME2 DEFAULT GETDATE(),
    TotalAmount DECIMAL(12,2) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Placed', -- Placed, Processing, Shipped, Delivered, Cancelled
    ShippingAddress NVARCHAR(500),
    ContactPhone NVARCHAR(20),
    ContactName NVARCHAR(100),
    DeliveryDate DATETIME2,
    Notes NVARCHAR(1000),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Order Items
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    DistributorID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending', -- Pending, Processing, Shipped, Delivered
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (DistributorID) REFERENCES Distributors(DistributorID)
);

-- =============================================
-- 7. SYSTEM LOGS AND AUDIT
-- =============================================

-- Activity Logs
CREATE TABLE ActivityLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    Activity NVARCHAR(200) NOT NULL,
    Details NVARCHAR(1000),
    IPAddress NVARCHAR(50),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- =============================================
-- 8. INSERT INITIAL DATA
-- =============================================

-- Insert User Types
INSERT INTO UserTypes (TypeName, Description) VALUES 
('Admin', 'System Administrator'),
('Client', 'Regular Customer'),
('Distributor', 'Product Distributor');

-- Insert Admin User
INSERT INTO Users (Username, Password, Email, FirstName, LastName, UserTypeID) VALUES 
('admin', 'admin123', 'admin@gadgethub.com', 'System', 'Administrator', 1);

-- Insert Distributors
INSERT INTO Users (Username, Password, Email, FirstName, LastName, UserTypeID) VALUES 
('techworld', 'tech123', 'contact@techworld.com', 'Tech', 'World', 3),
('electrocom', 'elec123', 'info@electrocom.com', 'Electro', 'Com', 3),
('gadgetcentral', 'gadget123', 'sales@gadgetcentral.com', 'Gadget', 'Central', 3);

-- Insert Distributor Companies
INSERT INTO Distributors (UserID, CompanyName, ContactPerson, BusinessAddress, IsApproved) VALUES 
(2, 'TechWorld Solutions', 'John Smith', '123 Tech Street, Silicon Valley', 1),
(3, 'ElectroCom Ltd', 'Sarah Johnson', '456 Electronic Ave, Tech City', 1),
(4, 'Gadget Central Inc', 'Mike Brown', '789 Gadget Blvd, Innovation Hub', 1);

-- Insert Categories
INSERT INTO Categories (CategoryName, Description) VALUES 
('Phone', 'Mobile phones and smartphones'),
('Tablet', 'Tablets and iPad devices'),
('Laptop', 'Laptops and notebooks'),
('Desktop', 'Desktop computers and workstations'),
('Accessories', 'Phone and computer accessories'),
('Smart Watch', 'Wearable smart devices'),
('Gaming', 'Gaming consoles and accessories'),
('Audio', 'Headphones, speakers, and audio devices');

-- Insert Sample Products
INSERT INTO Products (ProductName, CategoryID, Description, Brand, Model, Specifications) VALUES 
('iPhone 15 Pro', 1, 'Latest iPhone with A17 Pro chip', 'Apple', 'iPhone 15 Pro', '128GB, 6.1" Display, 48MP Camera'),
('Samsung Galaxy S24', 1, 'Premium Android smartphone', 'Samsung', 'Galaxy S24', '256GB, 6.2" AMOLED, 50MP Camera'),
('iPad Air', 2, 'Powerful and versatile tablet', 'Apple', 'iPad Air', '10.9" Display, M1 Chip, 64GB'),
('MacBook Air M2', 3, 'Lightweight laptop with M2 chip', 'Apple', 'MacBook Air', '13.6" Display, 8GB RAM, 256GB SSD'),
('Dell XPS 13', 3, 'Premium ultrabook', 'Dell', 'XPS 13', '13.4" FHD+, Intel i7, 16GB RAM, 512GB SSD'),
('AirPods Pro', 5, 'Wireless earbuds with ANC', 'Apple', 'AirPods Pro', 'Active Noise Cancellation, Spatial Audio'),
('Apple Watch Series 9', 6, 'Advanced smartwatch', 'Apple', 'Watch Series 9', '45mm, GPS, Health Tracking'),
('Gaming Keyboard', 7, 'Mechanical gaming keyboard', 'Razer', 'BlackWidow V3', 'RGB Backlit, Mechanical Switches');

-- Insert Sample Distributor Products with Prices
INSERT INTO DistributorProducts (DistributorID, ProductID, Price, QuantityInStock) VALUES 
-- TechWorld (DistributorID = 1)
(1, 1, 999.99, 50), -- iPhone 15 Pro
(1, 2, 899.99, 30), -- Samsung Galaxy S24
(1, 3, 599.99, 25), -- iPad Air
(1, 4, 1199.99, 20), -- MacBook Air M2
-- ElectroCom (DistributorID = 2)
(2, 1, 989.99, 40), -- iPhone 15 Pro
(2, 2, 879.99, 35), -- Samsung Galaxy S24
(2, 5, 1099.99, 15), -- Dell XPS 13
(2, 6, 249.99, 60), -- AirPods Pro
-- Gadget Central (DistributorID = 3)
(3, 1, 1009.99, 45), -- iPhone 15 Pro
(3, 3, 589.99, 30), -- iPad Air
(3, 7, 399.99, 25), -- Apple Watch Series 9
(3, 8, 129.99, 40); -- Gaming Keyboard

-- =============================================
-- 9. USEFUL VIEWS FOR REPORTING
-- =============================================

-- View for Product Catalog with Distributor Info
CREATE VIEW vw_ProductCatalog AS
SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.Description,
    p.ImageURL,
    p.Brand,
    p.Model,
    d.CompanyName AS DistributorName,
    dp.Price,
    dp.QuantityInStock,
    dp.IsAvailable
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN DistributorProducts dp ON p.ProductID = dp.ProductID
INNER JOIN Distributors d ON dp.DistributorID = d.DistributorID
WHERE p.IsActive = 1 AND dp.IsAvailable = 1;

-- View for Order Summary
CREATE VIEW vw_OrderSummary AS
SELECT 
    o.OrderID,
    o.OrderNumber,
    o.OrderDate,
    u.FirstName + ' ' + u.LastName AS CustomerName,
    o.TotalAmount,
    o.Status,
    COUNT(oi.OrderItemID) AS TotalItems
FROM Orders o
INNER JOIN Users u ON o.UserID = u.UserID
LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID, o.OrderNumber, o.OrderDate, u.FirstName, u.LastName, o.TotalAmount, o.Status;

-- View for Distributor Earnings
CREATE VIEW vw_DistributorEarnings AS
SELECT 
    d.DistributorID,
    d.CompanyName,
    COUNT(DISTINCT oi.OrderID) AS TotalOrders,
    SUM(oi.TotalPrice) AS TotalEarnings,
    AVG(oi.TotalPrice) AS AverageOrderValue
FROM Distributors d
LEFT JOIN OrderItems oi ON d.DistributorID = oi.DistributorID
LEFT JOIN Orders o ON oi.OrderID = o.OrderID
WHERE o.Status != 'Cancelled'
GROUP BY d.DistributorID, d.CompanyName;

-- =============================================
-- 10. STORED PROCEDURES
-- =============================================

-- Procedure to get products by category with pagination
CREATE PROCEDURE sp_GetProductsByCategory
    @CategoryID INT = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 9
AS
BEGIN
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        p.ProductID,
        p.ProductName,
        c.CategoryName,
        p.Description,
        p.ImageURL,
        p.Brand,
        MIN(dp.Price) AS MinPrice,
        MAX(dp.Price) AS MaxPrice,
        COUNT(dp.DistributorID) AS DistributorCount
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    LEFT JOIN DistributorProducts dp ON p.ProductID = dp.ProductID AND dp.IsAvailable = 1
    WHERE p.IsActive = 1 
        AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
    GROUP BY p.ProductID, p.ProductName, c.CategoryName, p.Description, p.ImageURL, p.Brand
    ORDER BY p.ProductName
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- Procedure to authenticate user
CREATE PROCEDURE sp_AuthenticateUser
    @Username NVARCHAR(50),
    @Password NVARCHAR(255)
AS
BEGIN
    SELECT 
        u.UserID,
        u.Username,
        u.Email,
        u.FirstName,
        u.LastName,
        ut.TypeName AS UserType,
        d.DistributorID,
        d.CompanyName
    FROM Users u
    INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
    LEFT JOIN Distributors d ON u.UserID = d.UserID
    WHERE u.Username = @Username 
        AND u.Password = @Password 
        AND u.IsActive = 1;
        
    -- Update last login date
    UPDATE Users 
    SET LastLoginDate = GETDATE() 
    WHERE Username = @Username AND Password = @Password;
END;
GO

-- =============================================
-- DATABASE SETUP COMPLETE
-- =============================================

PRINT 'GadgetHub Database created successfully!';
PRINT 'Initial data inserted including:';
PRINT '- Admin user (admin/admin123)';
PRINT '- 3 Distributors (techworld/tech123, electrocom/elec123, gadgetcentral/gadget123)';
PRINT '- 8 Product categories';
PRINT '- Sample products with distributor pricing';
PRINT '';
PRINT 'Database is ready for your ASP.NET Web Forms application!';