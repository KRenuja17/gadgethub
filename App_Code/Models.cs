using System;
using System.Collections.Generic;

/// <summary>
/// Data models for The Gadget Hub
/// </summary>

public class User
{
    public int UserID { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string PhoneNumber { get; set; }
    public string Address { get; set; }
    public string UserType { get; set; }
    public int? DistributorID { get; set; }
    public string CompanyName { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedDate { get; set; }
}

public class Product
{
    public int ProductID { get; set; }
    public string ProductName { get; set; }
    public int CategoryID { get; set; }
    public string CategoryName { get; set; }
    public string Description { get; set; }
    public string ImageURL { get; set; }
    public string Brand { get; set; }
    public string Model { get; set; }
    public string Specifications { get; set; }
    public decimal MinPrice { get; set; }
    public decimal MaxPrice { get; set; }
    public int DistributorCount { get; set; }
    public bool IsActive { get; set; }
}

public class Category
{
    public int CategoryID { get; set; }
    public string CategoryName { get; set; }
    public string Description { get; set; }
    public bool IsActive { get; set; }
}

public class CartItem
{
    public int CartID { get; set; }
    public int UserID { get; set; }
    public int ProductID { get; set; }
    public string ProductName { get; set; }
    public string ImageURL { get; set; }
    public string Brand { get; set; }
    public int Quantity { get; set; }
    public DateTime AddedDate { get; set; }
}

public class Quotation
{
    public int QuotationID { get; set; }
    public int UserID { get; set; }
    public string QuotationNumber { get; set; }
    public DateTime RequestDate { get; set; }
    public string Status { get; set; }
    public string Notes { get; set; }
    public List<QuotationItem> Items { get; set; }
    public List<QuotationResponse> Responses { get; set; }
}

public class QuotationItem
{
    public int QuotationItemID { get; set; }
    public int QuotationID { get; set; }
    public int ProductID { get; set; }
    public string ProductName { get; set; }
    public int RequestedQuantity { get; set; }
}

public class QuotationResponse
{
    public int ResponseID { get; set; }
    public int QuotationID { get; set; }
    public int DistributorID { get; set; }
    public string DistributorName { get; set; }
    public int ProductID { get; set; }
    public string ProductName { get; set; }
    public decimal? QuotedPrice { get; set; }
    public int? AvailableQuantity { get; set; }
    public int? DeliveryDays { get; set; }
    public bool IsAvailable { get; set; }
    public DateTime ResponseDate { get; set; }
    public string Notes { get; set; }
}

public class Order
{
    public int OrderID { get; set; }
    public int UserID { get; set; }
    public string OrderNumber { get; set; }
    public DateTime OrderDate { get; set; }
    public decimal TotalAmount { get; set; }
    public string Status { get; set; }
    public string ShippingAddress { get; set; }
    public string ContactPhone { get; set; }
    public string ContactName { get; set; }
    public DateTime? DeliveryDate { get; set; }
    public string Notes { get; set; }
    public List<OrderItem> Items { get; set; }
}

public class OrderItem
{
    public int OrderItemID { get; set; }
    public int OrderID { get; set; }
    public int ProductID { get; set; }
    public string ProductName { get; set; }
    public int DistributorID { get; set; }
    public string DistributorName { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice { get; set; }
    public string Status { get; set; }
}