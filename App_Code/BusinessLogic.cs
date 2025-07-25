using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// Business logic layer for The Gadget Hub
/// </summary>
public class BusinessLogic
{
    // User Authentication
    public static User AuthenticateUser(string username, string password)
    {
        string query = @"
            SELECT u.UserID, u.Username, u.Email, u.FirstName, u.LastName, u.PhoneNumber, u.Address,
                   ut.TypeName AS UserType, d.DistributorID, d.CompanyName, u.IsActive, u.CreatedDate
            FROM Users u
            INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
            LEFT JOIN Distributors d ON u.UserID = d.UserID
            WHERE u.Username = @Username AND u.Password = @Password AND u.IsActive = 1";

        SqlParameter[] parameters = {
            new SqlParameter("@Username", username),
            new SqlParameter("@Password", password)
        };

        DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);
        
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            return new User
            {
                UserID = Convert.ToInt32(row["UserID"]),
                Username = row["Username"].ToString(),
                Email = row["Email"].ToString(),
                FirstName = row["FirstName"].ToString(),
                LastName = row["LastName"].ToString(),
                PhoneNumber = row["PhoneNumber"]?.ToString(),
                Address = row["Address"]?.ToString(),
                UserType = row["UserType"].ToString(),
                DistributorID = row["DistributorID"] == DBNull.Value ? null : (int?)Convert.ToInt32(row["DistributorID"]),
                CompanyName = row["CompanyName"]?.ToString(),
                IsActive = Convert.ToBoolean(row["IsActive"]),
                CreatedDate = Convert.ToDateTime(row["CreatedDate"])
            };
        }
        return null;
    }

    // Register new user
    public static bool RegisterUser(string username, string password, string email, string firstName, string lastName, string phone, string address)
    {
        try
        {
            string query = @"
                INSERT INTO Users (Username, Password, Email, FirstName, LastName, PhoneNumber, Address, UserTypeID)
                VALUES (@Username, @Password, @Email, @FirstName, @LastName, @Phone, @Address, 2)"; // UserTypeID = 2 for Client

            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", password),
                new SqlParameter("@Email", email),
                new SqlParameter("@FirstName", firstName),
                new SqlParameter("@LastName", lastName),
                new SqlParameter("@Phone", phone ?? (object)DBNull.Value),
                new SqlParameter("@Address", address ?? (object)DBNull.Value)
            };

            int result = DatabaseHelper.ExecuteNonQuery(query, parameters);
            return result > 0;
        }
        catch
        {
            return false;
        }
    }

    // Get all categories
    public static List<Category> GetCategories()
    {
        string query = "SELECT CategoryID, CategoryName, Description, IsActive FROM Categories WHERE IsActive = 1 ORDER BY CategoryName";
        DataTable dt = DatabaseHelper.ExecuteQuery(query);
        
        List<Category> categories = new List<Category>();
        foreach (DataRow row in dt.Rows)
        {
            categories.Add(new Category
            {
                CategoryID = Convert.ToInt32(row["CategoryID"]),
                CategoryName = row["CategoryName"].ToString(),
                Description = row["Description"]?.ToString(),
                IsActive = Convert.ToBoolean(row["IsActive"])
            });
        }
        return categories;
    }

    // Get products with pagination
    public static List<Product> GetProducts(int? categoryId = null, string searchTerm = null, int pageNumber = 1, int pageSize = 9)
    {
        string query = @"
            SELECT p.ProductID, p.ProductName, c.CategoryName, p.Description, p.ImageURL, p.Brand,
                   MIN(dp.Price) AS MinPrice, MAX(dp.Price) AS MaxPrice, COUNT(dp.DistributorID) AS DistributorCount
            FROM Products p
            INNER JOIN Categories c ON p.CategoryID = c.CategoryID
            LEFT JOIN DistributorProducts dp ON p.ProductID = dp.ProductID AND dp.IsAvailable = 1
            WHERE p.IsActive = 1";

        List<SqlParameter> parameters = new List<SqlParameter>();

        if (categoryId.HasValue)
        {
            query += " AND p.CategoryID = @CategoryID";
            parameters.Add(new SqlParameter("@CategoryID", categoryId.Value));
        }

        if (!string.IsNullOrEmpty(searchTerm))
        {
            query += " AND (p.ProductName LIKE @SearchTerm OR p.Description LIKE @SearchTerm OR p.Brand LIKE @SearchTerm)";
            parameters.Add(new SqlParameter("@SearchTerm", "%" + searchTerm + "%"));
        }

        query += @"
            GROUP BY p.ProductID, p.ProductName, c.CategoryName, p.Description, p.ImageURL, p.Brand
            ORDER BY p.ProductName
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

        int offset = (pageNumber - 1) * pageSize;
        parameters.Add(new SqlParameter("@Offset", offset));
        parameters.Add(new SqlParameter("@PageSize", pageSize));

        DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters.ToArray());
        
        List<Product> products = new List<Product>();
        foreach (DataRow row in dt.Rows)
        {
            products.Add(new Product
            {
                ProductID = Convert.ToInt32(row["ProductID"]),
                ProductName = row["ProductName"].ToString(),
                CategoryName = row["CategoryName"].ToString(),
                Description = row["Description"]?.ToString(),
                ImageURL = row["ImageURL"]?.ToString(),
                Brand = row["Brand"]?.ToString(),
                MinPrice = row["MinPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(row["MinPrice"]),
                MaxPrice = row["MaxPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(row["MaxPrice"]),
                DistributorCount = Convert.ToInt32(row["DistributorCount"])
            });
        }
        return products;
    }

    // Add item to cart
    public static bool AddToCart(int userId, int productId, int quantity = 1)
    {
        try
        {
            // Check if item already exists in cart
            string checkQuery = "SELECT CartID, Quantity FROM ShoppingCart WHERE UserID = @UserID AND ProductID = @ProductID";
            SqlParameter[] checkParams = {
                new SqlParameter("@UserID", userId),
                new SqlParameter("@ProductID", productId)
            };

            DataTable dt = DatabaseHelper.ExecuteQuery(checkQuery, checkParams);
            
            if (dt.Rows.Count > 0)
            {
                // Update existing item
                int existingQuantity = Convert.ToInt32(dt.Rows[0]["Quantity"]);
                string updateQuery = "UPDATE ShoppingCart SET Quantity = @Quantity WHERE UserID = @UserID AND ProductID = @ProductID";
                SqlParameter[] updateParams = {
                    new SqlParameter("@Quantity", existingQuantity + quantity),
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@ProductID", productId)
                };
                return DatabaseHelper.ExecuteNonQuery(updateQuery, updateParams) > 0;
            }
            else
            {
                // Add new item
                string insertQuery = "INSERT INTO ShoppingCart (UserID, ProductID, Quantity) VALUES (@UserID, @ProductID, @Quantity)";
                SqlParameter[] insertParams = {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@ProductID", productId),
                    new SqlParameter("@Quantity", quantity)
                };
                return DatabaseHelper.ExecuteNonQuery(insertQuery, insertParams) > 0;
            }
        }
        catch
        {
            return false;
        }
    }

    // Get cart items for user
    public static List<CartItem> GetCartItems(int userId)
    {
        string query = @"
            SELECT sc.CartID, sc.UserID, sc.ProductID, p.ProductName, p.ImageURL, p.Brand, sc.Quantity, sc.AddedDate
            FROM ShoppingCart sc
            INNER JOIN Products p ON sc.ProductID = p.ProductID
            WHERE sc.UserID = @UserID
            ORDER BY sc.AddedDate DESC";

        SqlParameter[] parameters = {
            new SqlParameter("@UserID", userId)
        };

        DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);
        
        List<CartItem> cartItems = new List<CartItem>();
        foreach (DataRow row in dt.Rows)
        {
            cartItems.Add(new CartItem
            {
                CartID = Convert.ToInt32(row["CartID"]),
                UserID = Convert.ToInt32(row["UserID"]),
                ProductID = Convert.ToInt32(row["ProductID"]),
                ProductName = row["ProductName"].ToString(),
                ImageURL = row["ImageURL"]?.ToString(),
                Brand = row["Brand"]?.ToString(),
                Quantity = Convert.ToInt32(row["Quantity"]),
                AddedDate = Convert.ToDateTime(row["AddedDate"])
            });
        }
        return cartItems;
    }

    // Remove item from cart
    public static bool RemoveFromCart(int userId, int productId)
    {
        string query = "DELETE FROM ShoppingCart WHERE UserID = @UserID AND ProductID = @ProductID";
        SqlParameter[] parameters = {
            new SqlParameter("@UserID", userId),
            new SqlParameter("@ProductID", productId)
        };

        return DatabaseHelper.ExecuteNonQuery(query, parameters) > 0;
    }

    // Generate quotation number
    public static string GenerateQuotationNumber()
    {
        return "QUO" + DateTime.Now.ToString("yyyyMMddHHmmss");
    }

    // Generate order number
    public static string GenerateOrderNumber()
    {
        return "ORD" + DateTime.Now.ToString("yyyyMMddHHmmss");
    }
}