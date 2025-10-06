# Quick Start Guide

## Prerequisites
- Java 17+ installed
- Maven 3.8+ installed
- Docker and Docker Compose (for easy database setup)

## Option 1: Quick Start with Docker (Recommended)

### 1. Start PostgreSQL with Docker Compose
```bash
docker-compose up -d
```

This will start:
- PostgreSQL on port 5432
- pgAdmin on port 5050 (access at http://localhost:5050)

### 2. Build and Run the Application
```bash
# Build the project
mvn clean install

# Run the application
mvn spring-boot:run
```

The application will be available at `http://localhost:8080/api`

### 3. Test the Setup

#### Register a new user:
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "email": "admin@inventory.com",
    "password": "admin123",
    "fullName": "System Admin",
    "roles": ["ROLE_ADMIN"]
  }'
```

#### Login:
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

Save the JWT token from the response!

#### Create a Category:
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Electronics",
    "description": "Electronic devices"
  }'
```

#### Create a Product:
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
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
```

## Option 2: Manual PostgreSQL Setup

### 1. Install and Start PostgreSQL

```bash
# macOS (using Homebrew)
brew install postgresql@15
brew services start postgresql@15

# Ubuntu/Debian
sudo apt-get install postgresql-15
sudo systemctl start postgresql
```

### 2. Create Database

```bash
psql -U postgres
CREATE DATABASE inventory_db;
\q
```

### 3. Update Application Configuration

Edit `src/main/resources/application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/inventory_db
    username: your_username
    password: your_password
```

### 4. Build and Run
```bash
mvn clean install
mvn spring-boot:run
```

## Import Postman Collection

Import the `postman_collection.json` file into Postman for easy API testing.

## Access pgAdmin (if using Docker)

1. Open http://localhost:5050
2. Login with:
   - Email: admin@inventory.com
   - Password: admin
3. Add new server:
   - Host: postgres
   - Port: 5432
   - Database: inventory_db
   - Username: postgres
   - Password: postgres

## Stopping the Application

### Stop Spring Boot Application
Press `Ctrl+C` in the terminal

### Stop Docker Containers
```bash
docker-compose down

# To remove volumes as well (this will delete all data)
docker-compose down -v
```

## Troubleshooting

### Port 5432 already in use
Stop any existing PostgreSQL instance:
```bash
# macOS
brew services stop postgresql

# Linux
sudo systemctl stop postgresql
```

### Port 8080 already in use
Change the server port in `application.yml`:
```yaml
server:
  port: 8081
```

### Database connection errors
Verify PostgreSQL is running:
```bash
docker ps  # if using Docker
# or
pg_isready -U postgres  # if installed locally
```

## Next Steps

1. Read the full [README.md](README.md) for detailed API documentation
2. Import the Postman collection for API testing
3. Customize the application for your needs
4. Add more features from the roadmap

## Default Roles

The application automatically creates three roles:
- **ROLE_USER**: Read-only access to products and categories
- **ROLE_MANAGER**: Can create and update products and categories
- **ROLE_ADMIN**: Full access including user management

## Security Note

⚠️ **Important**: Change the JWT secret and database credentials before deploying to production!

Edit in `application.yml`:
```yaml
jwt:
  secret: your-256-bit-secret-key-here
  
spring:
  datasource:
    password: your-secure-password
```
