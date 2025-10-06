# System Architecture

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Client Applications                      │
│              (Postman, Web App, Mobile App)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP/HTTPS
                              │ REST API Calls
                              │
┌─────────────────────────────▼─────────────────────────────────┐
│                      API Gateway Layer                         │
│                    (Spring Boot Application)                   │
│                     Port: 8080 (default)                       │
└────────────────────────────────────────────────────────────────┘
                              │
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Controller   │    │ Controller   │    │ Controller   │
│   Layer      │    │   Layer      │    │   Layer      │
│              │    │              │    │              │
│ - Auth       │    │ - Product    │    │ - Category   │
│ - User       │    │              │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
        │                     │                     │
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Security Filter │
                    │     (JWT)        │
                    └──────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Service    │    │   Service    │    │   Service    │
│    Layer     │    │    Layer     │    │    Layer     │
│              │    │              │    │              │
│ - UserSvc    │    │ - ProductSvc │    │ - CategorySvc│
│ - NotifSvc   │    │              │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
        │                     │                     │
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Repository      │
                    │    Layer         │
                    │  (JPA/Hibernate) │
                    └──────────────────┘
                              │
                              │ JDBC
                              │
                              ▼
                    ┌──────────────────┐
                    │   PostgreSQL     │
                    │    Database      │
                    │   Port: 5432     │
                    └──────────────────┘
```

## Component Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    Spring Boot Application                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              Presentation Layer                         │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │    │
│  │  │    Auth      │  │   Product    │  │   Category   │ │    │
│  │  │  Controller  │  │  Controller  │  │  Controller  │ │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘ │    │
│  │  ┌──────────────┐                                      │    │
│  │  │    User      │      @RestController                 │    │
│  │  │  Controller  │      @RequestMapping                 │    │
│  │  └──────────────┘      @PreAuthorize                   │    │
│  └────────────────────────────────────────────────────────┘    │
│                              │                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │           Cross-Cutting Concerns                       │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │    │
│  │  │    JWT       │  │   Global     │  │  Validation  │ │    │
│  │  │    Filter    │  │  Exception   │  │   Handler    │ │    │
│  │  │              │  │   Handler    │  │              │ │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘ │    │
│  └────────────────────────────────────────────────────────┘    │
│                              │                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │               Business Layer                           │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │    │
│  │  │   Product    │  │  Category    │  │    User      │ │    │
│  │  │   Service    │  │   Service    │  │   Service    │ │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘ │    │
│  │  ┌──────────────┐                                      │    │
│  │  │ Notification │      @Service                        │    │
│  │  │   Service    │      @Transactional                  │    │
│  │  │   (@Async)   │      @Async                          │    │
│  │  └──────────────┘                                      │    │
│  └────────────────────────────────────────────────────────┘    │
│                              │                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │            Data Access Layer                           │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │    │
│  │  │   Product    │  │  Category    │  │    User      │ │    │
│  │  │  Repository  │  │  Repository  │  │  Repository  │ │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘ │    │
│  │  ┌──────────────┐                                      │    │
│  │  │    Role      │      @Repository                     │    │
│  │  │  Repository  │      extends JpaRepository           │    │
│  │  └──────────────┘                                      │    │
│  └────────────────────────────────────────────────────────┘    │
│                              │                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              Domain Model Layer                        │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │    │
│  │  │   Product    │  │  Category    │  │    User      │ │    │
│  │  │   Entity     │  │   Entity     │  │   Entity     │ │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘ │    │
│  │  ┌──────────────┐                                      │    │
│  │  │    Role      │      @Entity                         │    │
│  │  │   Entity     │      JPA Annotations                 │    │
│  │  └──────────────┘                                      │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                      ┌──────────────┐
                      │  PostgreSQL  │
                      │   Database   │
                      └──────────────┘
```

## Security Flow

```
┌──────────────┐
│   Client     │
│  Application │
└──────┬───────┘
       │
       │ 1. POST /api/auth/login
       │    { username, password }
       ▼
┌─────────────────────────┐
│   Auth Controller       │
└──────┬──────────────────┘
       │
       │ 2. Authenticate
       ▼
┌─────────────────────────┐
│  Authentication         │
│  Manager                │
└──────┬──────────────────┘
       │
       │ 3. Load User
       ▼
┌─────────────────────────┐
│  UserDetailsService     │
└──────┬──────────────────┘
       │
       │ 4. Verify Password
       ▼
┌─────────────────────────┐
│  Password Encoder       │
│  (BCrypt)               │
└──────┬──────────────────┘
       │
       │ 5. Generate Token
       ▼
┌─────────────────────────┐
│  JWT Token Provider     │
└──────┬──────────────────┘
       │
       │ 6. Return JWT Token
       ▼
┌──────────────┐
│   Client     │
│  Stores JWT  │
└──────┬───────┘
       │
       │ 7. Subsequent Requests
       │    Authorization: Bearer <token>
       ▼
┌─────────────────────────┐
│  JWT Auth Filter        │
└──────┬──────────────────┘
       │
       │ 8. Validate Token
       ▼
┌─────────────────────────┐
│  JWT Token Provider     │
└──────┬──────────────────┘
       │
       │ 9. Set Authentication
       ▼
┌─────────────────────────┐
│  Security Context       │
└──────┬──────────────────┘
       │
       │ 10. Check Permissions
       ▼
┌─────────────────────────┐
│  @PreAuthorize          │
│  Role Check             │
└──────┬──────────────────┘
       │
       │ 11. Access Granted/Denied
       ▼
┌─────────────────────────┐
│  Controller Method      │
└─────────────────────────┘
```

## Data Flow Example: Create Product

```
Client Request
     │
     │ POST /api/products
     │ Authorization: Bearer <JWT>
     │ Body: ProductRequest DTO
     │
     ▼
┌─────────────────┐
│ JWT Filter      │ ← Validates token
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Product         │ ← @PreAuthorize("hasRole('MANAGER')")
│ Controller      │
└────────┬────────┘
         │
         │ @Valid ProductRequest
         ▼
┌─────────────────┐
│ Validation      │ ← Bean Validation
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Product         │ ← Business Logic
│ Service         │   - Check duplicate SKU
└────────┬────────┘   - Validate category
         │            - Map DTO to Entity
         ▼
┌─────────────────┐
│ Category        │ ← Verify category exists
│ Repository      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Product         │ ← Save product
│ Repository      │   @Transactional
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ JPA/Hibernate   │ ← ORM Layer
└────────┬────────┘
         │
         │ INSERT SQL
         ▼
┌─────────────────┐
│ PostgreSQL      │
│ Database        │
└────────┬────────┘
         │
         │ Returns saved entity
         ▼
┌─────────────────┐
│ Product         │ ← Map Entity to Response DTO
│ Service         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Product         │ ← HTTP 201 Created
│ Controller      │   Response: ProductResponse DTO
└────────┬────────┘
         │
         ▼
Client Response
```

## Asynchronous Processing Flow

```
┌─────────────────┐
│ Product Service │
│ updateStock()   │
└────────┬────────┘
         │
         │ if (quantity <= reorderLevel)
         ▼
┌─────────────────┐
│ Notification    │ ← @Async method
│ Service         │
└────────┬────────┘
         │
         │ Non-blocking call
         ├───────────────────┐
         │                   │
         │ Main Thread       │ Async Thread
         │ Continues         │
         ▼                   ▼
┌─────────────────┐  ┌─────────────────┐
│ Return Response │  │ Process         │
│ to Client       │  │ Notification    │
└─────────────────┘  │ - Log Alert     │
                     │ - Send Email    │
                     │   (simulated)   │
                     └─────────────────┘
```

## Exception Handling Flow

```
┌─────────────────┐
│ Any Layer       │
│ throws Exception│
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│ Global Exception Handler        │
│ @RestControllerAdvice           │
└────────┬────────────────────────┘
         │
         ├─────────────┬──────────────┬────────────────┐
         │             │              │                │
         ▼             ▼              ▼                ▼
┌──────────────┐ ┌──────────┐ ┌──────────┐  ┌────────────┐
│ Resource     │ │Duplicate │ │Validation│  │   Other    │
│ NotFound     │ │Resource  │ │Exception │  │ Exceptions │
│ 404          │ │ 409      │ │ 400      │  │   500      │
└──────────────┘ └──────────┘ └──────────┘  └────────────┘
         │             │              │                │
         └─────────────┴──────────────┴────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  ErrorResponse   │
                    │  - timestamp     │
                    │  - status        │
                    │  - error         │
                    │  - message       │
                    │  - path          │
                    └──────┬───────────┘
                           │
                           ▼
                      Client Response
                      (Structured Error)
```

## Database Entity Relationships

```
┌─────────────┐         ┌─────────────┐
│   Product   │ N     1 │  Category   │
│─────────────│◄────────┤─────────────│
│ id          │         │ id          │
│ sku         │         │ name        │
│ name        │         │ description │
│ price       │         └─────────────┘
│ quantity    │
│ category_id │
│ status      │
└─────────────┘

┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│    User     │ N     N │  user_roles │ N     1 │    Role     │
│─────────────│◄────────┤─────────────├────────►│─────────────│
│ id          │         │ user_id     │         │ id          │
│ username    │         │ role_id     │         │ name        │
│ email       │         └─────────────┘         │ description │
│ password    │                                 └─────────────┘
│ full_name   │
│ enabled     │
└─────────────┘
```

## Technology Stack Layers

```
┌────────────────────────────────────────────────┐
│            Client Layer                         │
│  • Postman / Web Browser / Mobile App          │
└────────────────────────────────────────────────┘
                      │
┌────────────────────────────────────────────────┐
│         Presentation Layer                      │
│  • Spring MVC / REST Controllers                │
│  • JSON Serialization (Jackson)                 │
└────────────────────────────────────────────────┘
                      │
┌────────────────────────────────────────────────┐
│           Security Layer                        │
│  • Spring Security                              │
│  • JWT Authentication                           │
│  • Role-Based Authorization                     │
└────────────────────────────────────────────────┘
                      │
┌────────────────────────────────────────────────┐
│          Business Layer                         │
│  • Service Classes                              │
│  • Business Logic                               │
│  • Async Processing                             │
└────────────────────────────────────────────────┘
                      │
┌────────────────────────────────────────────────┐
│        Persistence Layer                        │
│  • Spring Data JPA                              │
│  • Hibernate ORM                                │
│  • Repository Pattern                           │
└────────────────────────────────────────────────┘
                      │
┌────────────────────────────────────────────────┐
│          Database Layer                         │
│  • PostgreSQL                                   │
│  • JDBC Driver                                  │
└────────────────────────────────────────────────┘
```

---

**Key Design Principles Applied:**

1. **Separation of Concerns** - Each layer has distinct responsibility
2. **Dependency Injection** - Loose coupling via Spring IoC
3. **Single Responsibility** - Each class has one job
4. **Open/Closed Principle** - Open for extension, closed for modification
5. **DRY (Don't Repeat Yourself)** - Reusable components
6. **Interface Segregation** - Repository interfaces
7. **Dependency Inversion** - Depend on abstractions

