# API Testing Guide with cURL Examples

## Base URL
```
http://localhost:8080/api
```

---

## 📋 Authentication Endpoints (Public)

### 1. Register a New User

**Request:**
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "password123",
    "fullName": "John Doe",
    "roles": ["ROLE_USER"]
  }'
```

**Success Response (201):**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "fullName": "John Doe",
  "roles": ["ROLE_USER"],
  "enabled": true,
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T10:00:00"
}
```

### 2. Login (Get JWT Token)

**Request:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "password123"
  }'
```

**Success Response (200):**
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqb2huX2RvZSIsInJvbGVzIjoiUk9MRV9VU0VSIiwiaWF0IjoxNjA5NDU5MjAwLCJleHAiOjE2MDk1NDU2MDB9.xxxxx",
  "type": "Bearer",
  "id": 0,
  "username": "john_doe",
  "email": "",
  "roles": ["ROLE_USER"]
}
```

**Save the token for subsequent requests!**

---

## 📦 Category Endpoints (Authenticated)

### 3. Create Category (MANAGER/ADMIN)

**Request:**
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Electronics",
    "description": "Electronic devices and accessories"
  }'
```

**Success Response (201):**
```json
{
  "id": 1,
  "name": "Electronics",
  "description": "Electronic devices and accessories",
  "productCount": 0,
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T10:00:00"
}
```

### 4. Get All Categories

**Request:**
```bash
curl -X GET http://localhost:8080/api/categories \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
[
  {
    "id": 1,
    "name": "Electronics",
    "description": "Electronic devices and accessories",
    "productCount": 5,
    "createdAt": "2025-01-01T10:00:00",
    "updatedAt": "2025-01-01T10:00:00"
  },
  {
    "id": 2,
    "name": "Furniture",
    "description": "Office furniture",
    "productCount": 3,
    "createdAt": "2025-01-01T11:00:00",
    "updatedAt": "2025-01-01T11:00:00"
  }
]
```

### 5. Get Category by ID

**Request:**
```bash
curl -X GET http://localhost:8080/api/categories/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
{
  "id": 1,
  "name": "Electronics",
  "description": "Electronic devices and accessories",
  "productCount": 5,
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T10:00:00"
}
```

### 6. Update Category (MANAGER/ADMIN)

**Request:**
```bash
curl -X PUT http://localhost:8080/api/categories/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Updated Electronics",
    "description": "Updated description for electronic devices"
  }'
```

**Success Response (200):**
```json
{
  "id": 1,
  "name": "Updated Electronics",
  "description": "Updated description for electronic devices",
  "productCount": 5,
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T12:00:00"
}
```

### 7. Delete Category (ADMIN only)

**Request:**
```bash
curl -X DELETE http://localhost:8080/api/categories/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (204 No Content)**

---

## 🛒 Product Endpoints (Authenticated)

### 8. Create Product (MANAGER/ADMIN)

**Request:**
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "sku": "LAPTOP-001",
    "name": "Dell Laptop",
    "description": "High-performance laptop for professionals",
    "price": 999.99,
    "quantity": 50,
    "reorderLevel": 10,
    "categoryId": 1,
    "status": "ACTIVE"
  }'
```

**Success Response (201):**
```json
{
  "id": 1,
  "sku": "LAPTOP-001",
  "name": "Dell Laptop",
  "description": "High-performance laptop for professionals",
  "price": 999.99,
  "quantity": 50,
  "reorderLevel": 10,
  "categoryId": 1,
  "categoryName": "Electronics",
  "status": "ACTIVE",
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T10:00:00"
}
```

### 9. Get All Products

**Request:**
```bash
curl -X GET http://localhost:8080/api/products \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
[
  {
    "id": 1,
    "sku": "LAPTOP-001",
    "name": "Dell Laptop",
    "description": "High-performance laptop",
    "price": 999.99,
    "quantity": 50,
    "reorderLevel": 10,
    "categoryId": 1,
    "categoryName": "Electronics",
    "status": "ACTIVE",
    "createdAt": "2025-01-01T10:00:00",
    "updatedAt": "2025-01-01T10:00:00"
  }
]
```

### 10. Get Product by ID

**Request:**
```bash
curl -X GET http://localhost:8080/api/products/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
{
  "id": 1,
  "sku": "LAPTOP-001",
  "name": "Dell Laptop",
  "description": "High-performance laptop",
  "price": 999.99,
  "quantity": 50,
  "reorderLevel": 10,
  "categoryId": 1,
  "categoryName": "Electronics",
  "status": "ACTIVE",
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T10:00:00"
}
```

### 11. Search Products

**Request:**
```bash
curl -X GET "http://localhost:8080/api/products/search?keyword=laptop" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
[
  {
    "id": 1,
    "sku": "LAPTOP-001",
    "name": "Dell Laptop",
    "description": "High-performance laptop",
    "price": 999.99,
    "quantity": 50,
    "reorderLevel": 10,
    "categoryId": 1,
    "categoryName": "Electronics",
    "status": "ACTIVE",
    "createdAt": "2025-01-01T10:00:00",
    "updatedAt": "2025-01-01T10:00:00"
  }
]
```

### 12. Get Products by Category

**Request:**
```bash
curl -X GET http://localhost:8080/api/products/category/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
[
  {
    "id": 1,
    "sku": "LAPTOP-001",
    "name": "Dell Laptop",
    "description": "High-performance laptop",
    "price": 999.99,
    "quantity": 50,
    "reorderLevel": 10,
    "categoryId": 1,
    "categoryName": "Electronics",
    "status": "ACTIVE",
    "createdAt": "2025-01-01T10:00:00",
    "updatedAt": "2025-01-01T10:00:00"
  }
]
```

### 13. Get Low Stock Products (MANAGER/ADMIN)

**Request:**
```bash
curl -X GET http://localhost:8080/api/products/low-stock \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
[
  {
    "id": 2,
    "sku": "MOUSE-001",
    "name": "Wireless Mouse",
    "description": "Ergonomic wireless mouse",
    "price": 29.99,
    "quantity": 8,
    "reorderLevel": 20,
    "categoryId": 1,
    "categoryName": "Electronics",
    "status": "LOW_STOCK",
    "createdAt": "2025-01-01T10:00:00",
    "updatedAt": "2025-01-01T10:00:00"
  }
]
```

### 14. Update Product (MANAGER/ADMIN)

**Request:**
```bash
curl -X PUT http://localhost:8080/api/products/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "sku": "LAPTOP-001",
    "name": "Dell Laptop Pro",
    "description": "Updated high-performance laptop",
    "price": 1099.99,
    "quantity": 45,
    "reorderLevel": 10,
    "categoryId": 1,
    "status": "ACTIVE"
  }'
```

**Success Response (200):**
```json
{
  "id": 1,
  "sku": "LAPTOP-001",
  "name": "Dell Laptop Pro",
  "description": "Updated high-performance laptop",
  "price": 1099.99,
  "quantity": 45,
  "reorderLevel": 10,
  "categoryId": 1,
  "categoryName": "Electronics",
  "status": "ACTIVE",
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T12:00:00"
}
```

### 15. Update Stock Quantity (MANAGER/ADMIN)

**Request:**
```bash
curl -X PATCH "http://localhost:8080/api/products/1/stock?quantity=30" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
{
  "id": 1,
  "sku": "LAPTOP-001",
  "name": "Dell Laptop Pro",
  "description": "Updated high-performance laptop",
  "price": 1099.99,
  "quantity": 30,
  "reorderLevel": 10,
  "categoryId": 1,
  "categoryName": "Electronics",
  "status": "ACTIVE",
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T13:00:00"
}
```

### 16. Delete Product (ADMIN only)

**Request:**
```bash
curl -X DELETE http://localhost:8080/api/products/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (204 No Content)**

---

## 👥 User Management Endpoints (ADMIN only)

### 17. Create User

**Request:**
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "username": "jane_smith",
    "email": "jane@example.com",
    "password": "password123",
    "fullName": "Jane Smith",
    "roles": ["ROLE_MANAGER"]
  }'
```

**Success Response (201):**
```json
{
  "id": 2,
  "username": "jane_smith",
  "email": "jane@example.com",
  "fullName": "Jane Smith",
  "roles": ["ROLE_MANAGER"],
  "enabled": true,
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T10:00:00"
}
```

### 18. Get All Users

**Request:**
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
[
  {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "roles": ["ROLE_USER"],
    "enabled": true,
    "createdAt": "2025-01-01T10:00:00",
    "updatedAt": "2025-01-01T10:00:00"
  },
  {
    "id": 2,
    "username": "jane_smith",
    "email": "jane@example.com",
    "fullName": "Jane Smith",
    "roles": ["ROLE_MANAGER"],
    "enabled": true,
    "createdAt": "2025-01-01T11:00:00",
    "updatedAt": "2025-01-01T11:00:00"
  }
]
```

### 19. Get User by ID

**Request:**
```bash
curl -X GET http://localhost:8080/api/users/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (200):**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "fullName": "John Doe",
  "roles": ["ROLE_USER"],
  "enabled": true,
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T10:00:00"
}
```

### 20. Update User

**Request:**
```bash
curl -X PUT http://localhost:8080/api/users/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "email": "john.doe@example.com",
    "fullName": "John Updated Doe",
    "password": "newpassword123"
  }'
```

**Success Response (200):**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john.doe@example.com",
  "fullName": "John Updated Doe",
  "roles": ["ROLE_USER"],
  "enabled": true,
  "createdAt": "2025-01-01T10:00:00",
  "updatedAt": "2025-01-01T14:00:00"
}
```

### 21. Delete User

**Request:**
```bash
curl -X DELETE http://localhost:8080/api/users/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Success Response (204 No Content)**

---

## ❌ Error Responses

### 400 Bad Request (Validation Error)
```json
{
  "timestamp": "2025-01-01T10:00:00",
  "status": 400,
  "error": "Validation Failed",
  "message": "Invalid input data",
  "path": "/api/products",
  "validationErrors": {
    "sku": "SKU is required",
    "price": "Price must be greater than 0"
  }
}
```

### 401 Unauthorized
```json
{
  "status": 401,
  "error": "Unauthorized",
  "message": "Full authentication is required to access this resource",
  "path": "/api/products"
}
```

### 403 Forbidden
```json
{
  "timestamp": "2025-01-01T10:00:00",
  "status": 403,
  "error": "Forbidden",
  "message": "You don't have permission to access this resource",
  "path": "/api/users"
}
```

### 404 Not Found
```json
{
  "timestamp": "2025-01-01T10:00:00",
  "status": 404,
  "error": "Not Found",
  "message": "Product not found with id: 999",
  "path": "/api/products/999"
}
```

### 409 Conflict (Duplicate)
```json
{
  "timestamp": "2025-01-01T10:00:00",
  "status": 409,
  "error": "Conflict",
  "message": "Product with SKU LAPTOP-001 already exists",
  "path": "/api/products"
}
```

### 500 Internal Server Error
```json
{
  "timestamp": "2025-01-01T10:00:00",
  "status": 500,
  "error": "Internal Server Error",
  "message": "An unexpected error occurred",
  "path": "/api/products"
}
```

---

## 📝 Testing Script

Save this as `test_api.sh` for quick testing:

```bash
#!/bin/bash

BASE_URL="http://localhost:8080/api"

# 1. Register user
echo "=== Registering User ==="
curl -X POST $BASE_URL/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "test123",
    "fullName": "Test User",
    "roles": ["ROLE_ADMIN"]
  }'
echo -e "\n"

# 2. Login and get token
echo "=== Logging In ==="
TOKEN=$(curl -s -X POST $BASE_URL/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "test123"
  }' | jq -r '.token')
echo "Token: $TOKEN"
echo -e "\n"

# 3. Create Category
echo "=== Creating Category ==="
curl -X POST $BASE_URL/categories \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Electronics",
    "description": "Electronic devices"
  }'
echo -e "\n"

# 4. Create Product
echo "=== Creating Product ==="
curl -X POST $BASE_URL/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "sku": "LAPTOP-001",
    "name": "Dell Laptop",
    "description": "High-performance laptop",
    "price": 999.99,
    "quantity": 50,
    "reorderLevel": 10,
    "categoryId": 1,
    "status": "ACTIVE"
  }'
echo -e "\n"

# 5. Get All Products
echo "=== Getting All Products ==="
curl -X GET $BASE_URL/products \
  -H "Authorization: Bearer $TOKEN"
echo -e "\n"
```

Make it executable:
```bash
chmod +x test_api.sh
./test_api.sh
```

---

## 🔐 Authorization Header Format

For all authenticated endpoints, include the JWT token in the header:

```
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ...
```

**Note:** Replace `YOUR_JWT_TOKEN` with the actual token received from the login endpoint.

---

## 📚 Additional Resources

- Full API documentation: See [README.md](README.md)
- Postman Collection: Import [postman_collection.json](postman_collection.json)
- Quick Start: See [QUICKSTART.md](QUICKSTART.md)
- Architecture: See [ARCHITECTURE.md](ARCHITECTURE.md)
