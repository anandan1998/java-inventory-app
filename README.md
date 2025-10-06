# Inventory Management System

A comprehensive backend application built with **Java 17**, **Spring Boot 3.2**, and **PostgreSQL** for managing inventory operations with role-based authentication and asynchronous processing.

## 🚀 Features

### Core Functionality
- **CRUD Operations**: Complete Create, Read, Update, Delete operations for Products, Categories, and Users
- **RESTful APIs**: Well-structured REST endpoints following best practices
- **JPA/Hibernate**: Database persistence with optimized queries
- **PostgreSQL Integration**: Robust relational database management

### Security & Authentication
- **JWT-based Authentication**: Secure token-based authentication
- **Role-Based Access Control**: Three user roles (USER, MANAGER, ADMIN) with different permissions
- **Password Encryption**: BCrypt password hashing
- **Spring Security**: Comprehensive security configuration

### Advanced Features
- **Asynchronous Processing**: Non-blocking operations for notifications and reports
- **Low Stock Alerts**: Automatic notifications when inventory falls below reorder level
- **Search & Filter**: Advanced product search by name, description, or category
- **Global Exception Handling**: Consistent error responses across the application
- **Input Validation**: Bean validation for all DTOs

### Clean Code Principles
- **Modular Service Layer**: Separation of concerns with service, repository, and controller layers
- **Design Patterns**: Repository pattern, DTO pattern, and dependency injection
- **Logging**: Structured logging with SLF4J and Logback
- **Transaction Management**: Proper @Transactional annotations

## 📋 Prerequisites

- **Java 17** or higher
- **Maven 3.8+**
- **PostgreSQL 12+**
- **Git**

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd java-inventory-project
```

### 2. Configure PostgreSQL Database

Create a PostgreSQL database:

```sql
CREATE DATABASE inventory_db;
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE inventory_db TO postgres;
```

### 3. Configure Application Properties

Update `src/main/resources/application.yml` with your database credentials:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/inventory_db
    username: postgres
    password: postgres
```

### 4. Initialize Database with Roles

Run this SQL to create initial roles:

```sql
INSERT INTO roles (name, description) VALUES 
('ROLE_USER', 'Standard user with read access'),
('ROLE_MANAGER', 'Manager with read/write access'),
('ROLE_ADMIN', 'Administrator with full access');
```

### 5. Build and Run

```bash
# Build the project
mvn clean install

# Run the application
mvn spring-boot:run
```

The application will start on `http://localhost:8080/api`

## 📚 API Documentation

### Authentication Endpoints

#### Register a New User
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "securepass123",
  "fullName": "John Doe",
  "roles": ["ROLE_USER"]
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "john_doe",
  "password": "securepass123"
}

Response:
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "roles": ["ROLE_USER"]
}
```

### Category Endpoints

#### Create Category
```http
POST /api/categories
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Electronics",
  "description": "Electronic devices and accessories"
}
```

#### Get All Categories
```http
GET /api/categories
Authorization: Bearer <token>
```

#### Get Category by ID
```http
GET /api/categories/{id}
Authorization: Bearer <token>
```

#### Update Category
```http
PUT /api/categories/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Electronics",
  "description": "Updated description"
}
```

#### Delete Category
```http
DELETE /api/categories/{id}
Authorization: Bearer <token>
```

### Product Endpoints

#### Create Product
```http
POST /api/products
Authorization: Bearer <token>
Content-Type: application/json

{
  "sku": "LAPTOP-001",
  "name": "Dell Laptop",
  "description": "High-performance laptop",
  "price": 999.99,
  "quantity": 50,
  "reorderLevel": 10,
  "categoryId": 1,
  "status": "ACTIVE"
}
```

#### Get All Products
```http
GET /api/products
Authorization: Bearer <token>
```

#### Get Product by ID
```http
GET /api/products/{id}
Authorization: Bearer <token>
```

#### Search Products
```http
GET /api/products/search?keyword=laptop
Authorization: Bearer <token>
```

#### Get Products by Category
```http
GET /api/products/category/{categoryId}
Authorization: Bearer <token>
```

#### Get Low Stock Products
```http
GET /api/products/low-stock
Authorization: Bearer <token>
```

#### Update Product
```http
PUT /api/products/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "sku": "LAPTOP-001",
  "name": "Dell Laptop Pro",
  "description": "Updated description",
  "price": 1099.99,
  "quantity": 45,
  "reorderLevel": 10,
  "categoryId": 1,
  "status": "ACTIVE"
}
```

#### Update Stock Quantity
```http
PATCH /api/products/{id}/stock?quantity=30
Authorization: Bearer <token>
```

#### Delete Product
```http
DELETE /api/products/{id}
Authorization: Bearer <token>
```

### User Management Endpoints (Admin Only)

#### Create User
```http
POST /api/users
Authorization: Bearer <token>
Content-Type: application/json

{
  "username": "new_user",
  "email": "user@example.com",
  "password": "password123",
  "fullName": "New User",
  "roles": ["ROLE_USER"]
}
```

#### Get All Users
```http
GET /api/users
Authorization: Bearer <token>
```

#### Get User by ID
```http
GET /api/users/{id}
Authorization: Bearer <token>
```

#### Update User
```http
PUT /api/users/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "email": "updated@example.com",
  "fullName": "Updated Name",
  "password": "newpassword123"
}
```

#### Delete User
```http
DELETE /api/users/{id}
Authorization: Bearer <token>
```

## 🔐 Role-Based Access Control

| Endpoint | USER | MANAGER | ADMIN |
|----------|------|---------|-------|
| View Products/Categories | ✅ | ✅ | ✅ |
| Create/Update Products | ❌ | ✅ | ✅ |
| Delete Products | ❌ | ❌ | ✅ |
| View Low Stock | ❌ | ✅ | ✅ |
| Manage Users | ❌ | ❌ | ✅ |

## 🏗️ Project Structure

```
src/main/java/com/inventory/
├── InventoryManagementSystemApplication.java
├── config/
│   └── AsyncConfig.java
├── controller/
│   ├── AuthController.java
│   ├── CategoryController.java
│   ├── ProductController.java
│   └── UserController.java
├── dto/
│   ├── CategoryRequest.java
│   ├── CategoryResponse.java
│   ├── JwtResponse.java
│   ├── LoginRequest.java
│   ├── ProductRequest.java
│   ├── ProductResponse.java
│   ├── UserRequest.java
│   └── UserResponse.java
├── exception/
│   ├── DuplicateResourceException.java
│   ├── ErrorResponse.java
│   ├── GlobalExceptionHandler.java
│   └── ResourceNotFoundException.java
├── model/
│   ├── Category.java
│   ├── Product.java
│   ├── Role.java
│   └── User.java
├── repository/
│   ├── CategoryRepository.java
│   ├── ProductRepository.java
│   ├── RoleRepository.java
│   └── UserRepository.java
├── security/
│   ├── CustomUserDetailsService.java
│   ├── JwtAuthenticationEntryPoint.java
│   ├── JwtAuthenticationFilter.java
│   ├── JwtTokenProvider.java
│   └── SecurityConfig.java
└── service/
    ├── CategoryService.java
    ├── NotificationService.java
    ├── ProductService.java
    └── UserService.java
```

## 🎯 Design Patterns Used

1. **Repository Pattern**: Data access abstraction
2. **DTO Pattern**: Data transfer between layers
3. **Dependency Injection**: Loose coupling between components
4. **Builder Pattern**: Used in JWT token creation
5. **Strategy Pattern**: Different authentication strategies
6. **Singleton Pattern**: Spring beans

## 🔄 Asynchronous Processing

The system includes async processing for:
- **Low Stock Alerts**: Notifies when products reach reorder level
- **Inventory Reports**: Generates reports without blocking main thread
- **Product Updates**: Processes updates asynchronously

## 🧪 Testing

```bash
# Run all tests
mvn test

# Run with coverage
mvn clean test jacoco:report
```

## 📊 Database Schema

### Main Tables
- **users**: User accounts and credentials
- **roles**: User roles (USER, MANAGER, ADMIN)
- **user_roles**: Many-to-many relationship between users and roles
- **categories**: Product categories
- **products**: Inventory products with stock information

## 🚀 Future Enhancements

- [ ] Add pagination and sorting for list endpoints
- [ ] Implement product variants and attributes
- [ ] Add supplier management
- [ ] Implement order processing
- [ ] Add real-time notifications with WebSocket
- [ ] Implement data caching with Redis
- [ ] Add comprehensive unit and integration tests
- [ ] Implement API rate limiting
- [ ] Add Swagger/OpenAPI documentation
- [ ] Implement audit logging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 👤 Author

**Anantha Pathmanabhan R**
- LinkedIn: [Your LinkedIn Profile]
- GitHub: [@your-github-username]

## 🙏 Acknowledgments

- Spring Boot Documentation
- Baeldung Spring Security Tutorials
- PostgreSQL Documentation

---

**Note**: Remember to change default passwords and JWT secret before deploying to production!
