# Full-Stack Application Architecture

**Purpose**: Comprehensive architecture documentation for React + Python full-stack application

**Scope**: System design, component interaction, data flow, and architectural decisions for the complete full-stack application

**Overview**: Detailed explanation of the full-stack application architecture including frontend React SPA,
    backend FastAPI REST API, PostgreSQL database, Docker orchestration, and AWS deployment infrastructure.
    Covers component responsibilities, communication patterns, data flow, authentication, error handling,
    deployment topology, and scaling considerations. Provides architectural context for developers working
    on any part of the application stack.

**Dependencies**: React, FastAPI, PostgreSQL, Docker, AWS ECS

**Exports**: Architectural patterns, design decisions, and system topology documentation

**Related**: API-Frontend Integration (api-frontend-integration.md), How-to guides in .ai/howtos/fullstack/

**Implementation**: Three-tier architecture with SPA frontend, RESTful API backend, and relational database

---

## Architecture Overview

The full-stack application follows a modern three-tier architecture with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client Browser                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           React SPA (TypeScript + Vite)                    │  │
│  │  • Component-based UI                                      │  │
│  │  • React Router for navigation                             │  │
│  │  • Type-safe API client                                    │  │
│  │  • State management (Context API)                          │  │
│  └───────────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │ HTTPS/REST
                            │ JSON payloads
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Backend Server (Docker)                       │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           FastAPI Application (Python)                     │  │
│  │  • RESTful API endpoints                                   │  │
│  │  • Pydantic request/response validation                    │  │
│  │  • JWT authentication                                      │  │
│  │  • SQLAlchemy ORM                                          │  │
│  │  • Business logic layer                                    │  │
│  └───────────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │ SQL
                            │ Connection pool
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Database Server (Docker)                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              PostgreSQL 15                                 │  │
│  │  • Relational data storage                                 │  │
│  │  • ACID transactions                                       │  │
│  │  • Persistent volume                                       │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## System Components

### Frontend Layer (React + TypeScript + Vite)

**Technology Stack**:
- React 18.2+ with TypeScript
- Vite for build tooling and development server
- React Router for client-side routing
- Axios for HTTP requests

**Responsibilities**:
- Render user interface components
- Handle user interactions and form submissions
- Manage client-side state and navigation
- Communicate with backend API
- Display data and handle loading/error states
- Client-side validation and UX feedback

**Key Components**:

```typescript
src/
├── main.tsx              // Application entry point, React root
├── App.tsx               // Root component with routing
├── api/
│   └── client.ts         // Centralized API client with auth
├── components/
│   ├── Health.tsx        // Example: Health check display
│   └── [other].tsx       // Reusable UI components
├── pages/
│   ├── Home.tsx          // Page components with routing
│   └── [other].tsx       // Additional pages
├── types/
│   └── api.ts            // TypeScript types for API responses
├── hooks/
│   └── useAuth.tsx       // Custom hooks (authentication, etc.)
└── context/
    └── AuthContext.tsx   // Global state management
```

**Design Patterns**:
- **Component Composition**: Small, reusable components
- **Container/Presentational**: Separation of logic and display
- **Custom Hooks**: Reusable stateful logic
- **Context API**: Global state (auth, theme, etc.)
- **Error Boundaries**: Graceful error handling

### Backend Layer (FastAPI + Python)

**Technology Stack**:
- Python 3.11+ with type hints
- FastAPI for web framework
- SQLAlchemy 2.0+ for ORM
- Pydantic for data validation
- Alembic for database migrations
- pytest for testing

**Responsibilities**:
- Expose RESTful API endpoints
- Validate and sanitize incoming requests
- Implement business logic
- Manage database transactions
- Handle authentication and authorization
- Generate OpenAPI documentation
- Log requests and errors

**Key Components**:

```python
backend/src/
├── main.py               // FastAPI app, CORS, middleware
├── config.py             // Environment config, settings
├── routers/
│   ├── health.py         // Health check endpoint
│   ├── auth.py           // Authentication endpoints
│   └── [resources].py    // Resource-specific routers
├── models/
│   ├── user.py           // SQLAlchemy models
│   └── [entities].py     // Database models
├── schemas/
│   ├── user.py           // Pydantic schemas
│   └── [entities].py     // Request/response models
├── services/
│   ├── auth.py           // Business logic services
│   └── [domain].py       // Domain-specific logic
├── database/
│   ├── session.py        // Database session management
│   └── base.py           // SQLAlchemy base
└── middleware/
    ├── logging.py        // Request logging
    └── errors.py         // Error handling
```

**Design Patterns**:
- **Router Pattern**: Organize endpoints by resource
- **Service Layer**: Separate business logic from routes
- **Repository Pattern**: Database access abstraction
- **Dependency Injection**: FastAPI dependencies for DB, auth
- **Middleware Chain**: Cross-cutting concerns (logging, CORS, errors)

### Database Layer (PostgreSQL)

**Technology**: PostgreSQL 15+

**Responsibilities**:
- Persist application data
- Enforce data integrity and constraints
- Provide transactional guarantees
- Support complex queries and joins
- Scale with indexes and query optimization

**Schema Design**:
- Normalized relational schema
- Foreign key constraints for referential integrity
- Indexes on frequently queried columns
- Timestamps (created_at, updated_at) on all tables
- Soft deletes where appropriate

**Migration Management**:
- Alembic for schema versioning
- Version-controlled migration files
- Rollback capabilities
- Automated migration generation from model changes

## Data Flow

### Request Flow (Frontend → Backend → Database)

```
1. User Action
   └─> React Component Event Handler
       └─> API Client (src/api/client.ts)
           └─> HTTP Request (Axios)
               ├─> Add JWT token (if authenticated)
               ├─> Add headers (Content-Type, etc.)
               └─> Send to backend

2. Backend Reception
   └─> FastAPI Router (routers/*.py)
       ├─> CORS Middleware (verify origin)
       ├─> Logging Middleware (log request)
       ├─> Authentication Middleware (verify JWT)
       └─> Route Handler Function
           ├─> Validate Request (Pydantic schema)
           ├─> Call Service Layer (services/*.py)
           │   └─> Business Logic
           │       └─> Database Access (SQLAlchemy)
           │           └─> SQL Query
           │               └─> PostgreSQL
           ├─> Format Response (Pydantic schema)
           └─> Return JSON

3. Response Flow
   └─> HTTP Response
       └─> API Client (src/api/client.ts)
           ├─> Handle Errors (try/catch)
           ├─> Parse JSON
           └─> Return to Component
               └─> Update State
                   └─> Re-render UI
```

### Authentication Flow

```
1. Login Request
   Frontend                    Backend                     Database
   --------                    -------                     --------
   POST /auth/login
   {username, password}   -->  Validate credentials   -->  SELECT user
                          <--  Hash comparison
                               Generate JWT token
                          <--  Return {access_token}
   Store token in memory
   (or localStorage)

2. Authenticated Request
   Frontend                    Backend                     Database
   --------                    -------                     --------
   GET /api/users/me
   Authorization: Bearer JWT --> Verify JWT signature
                               Extract user_id
                          -->  SELECT user WHERE id=...
                          <--  Return user data
   <--  {user_data}
   Render user profile
```

### Error Flow

```
Error Occurs
└─> Database Error / Business Logic Error / Validation Error
    └─> Service Layer (raises exception)
        └─> FastAPI Error Handler Middleware
            ├─> Log error with stack trace
            ├─> Format error response
            │   {
            │     "error": "error_code",
            │     "message": "User-friendly message",
            │     "details": {...}
            │   }
            └─> Return HTTP error status
                └─> Frontend API Client
                    ├─> Catch error in try/catch
                    ├─> Display error to user
                    │   (toast notification, error page, etc.)
                    └─> Log to browser console
```

## Communication Patterns

### RESTful API Design

All backend endpoints follow REST principles:

```
Resource: Users
GET    /api/users        # List users (paginated)
POST   /api/users        # Create user
GET    /api/users/{id}   # Get user by ID
PUT    /api/users/{id}   # Update user (full)
PATCH  /api/users/{id}   # Update user (partial)
DELETE /api/users/{id}   # Delete user
```

### Request/Response Format

**Request**:
```json
POST /api/users
Content-Type: application/json
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJ...

{
  "username": "john_doe",
  "email": "john@example.com",
  "full_name": "John Doe"
}
```

**Successful Response**:
```json
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 123,
  "username": "john_doe",
  "email": "john@example.com",
  "full_name": "John Doe",
  "created_at": "2025-10-02T12:34:56Z",
  "updated_at": "2025-10-02T12:34:56Z"
}
```

**Error Response**:
```json
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "VALIDATION_ERROR",
  "message": "Invalid input data",
  "details": {
    "email": ["Invalid email format"]
  }
}
```

### CORS Configuration

Backend allows frontend origin for cross-origin requests:

```python
# backend/src/config.py
CORS_ORIGINS = [
    "http://localhost:5173",  # Vite dev server
    "http://localhost:3000",  # Alternative frontend port
    "https://yourdomain.com"  # Production domain
]
```

## Docker Architecture

### Local Development Environment

```yaml
# docker-compose.fullstack.yml
services:
  backend:
    build: ./backend
    ports: ["8000:8000"]
    volumes:
      - ./backend/src:/app/src  # Hot reload
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app_db
    depends_on:
      - db

  frontend:
    build: ./frontend
    ports: ["5173:5173"]
    volumes:
      - ./frontend/src:/app/src  # Hot reload (HMR)
    environment:
      - VITE_API_URL=http://localhost:8000

  db:
    image: postgres:15
    ports: ["5432:5432"]
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=app_db
```

### Container Communication

- **Frontend → Backend**: Via exposed port `http://backend:8000` (Docker network) or `http://localhost:8000` (browser)
- **Backend → Database**: Via Docker network `postgresql://db:5432`
- **Volume Mounts**: Enable hot reload without rebuilding containers

## Deployment Architecture (AWS)

### Production Topology

```
Internet
    │
    ▼
┌─────────────────────┐
│   Route 53 (DNS)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  CloudFront (CDN)   │  ◄── Frontend static files (S3)
│  (Optional)         │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Application Load   │
│  Balancer (ALB)     │
└──────────┬──────────┘
           │
    ┌──────┴──────┐
    │             │
    ▼             ▼
┌────────┐   ┌────────┐
│ ECS    │   │ ECS    │
│ Task 1 │   │ Task 2 │  ◄── Backend containers (auto-scaling)
└───┬────┘   └───┬────┘
    │            │
    └──────┬─────┘
           │
           ▼
┌─────────────────────┐
│   RDS PostgreSQL    │  ◄── Database (Multi-AZ)
│   (Private Subnet)  │
└─────────────────────┘
```

### AWS Resources (Terraform)

- **VPC**: Isolated network with public and private subnets
- **ECS Cluster**: Container orchestration for backend
- **ECS Service**: Auto-scaling backend tasks
- **ALB**: Load balancing and SSL termination
- **RDS**: Managed PostgreSQL database
- **S3**: Static frontend hosting
- **CloudFront**: CDN for frontend assets (optional)
- **ECR**: Docker image registry
- **CloudWatch**: Logging and monitoring
- **Secrets Manager**: Database credentials and API keys

## Security Architecture

### Authentication & Authorization

- **JWT Tokens**: Stateless authentication
- **Token Expiry**: Short-lived access tokens (30 minutes)
- **Password Hashing**: bcrypt with salt
- **HTTPS Only**: TLS encryption in transit
- **Environment Variables**: Secrets never in code

### API Security

- **CORS**: Whitelist trusted origins
- **Rate Limiting**: Prevent abuse (optional middleware)
- **Input Validation**: Pydantic schemas validate all inputs
- **SQL Injection Prevention**: SQLAlchemy ORM (parameterized queries)
- **XSS Prevention**: React escapes output by default

### Infrastructure Security

- **Private Subnets**: Database not exposed to internet
- **Security Groups**: Firewall rules for each service
- **IAM Roles**: Least privilege access
- **Secrets Manager**: Encrypted secret storage
- **Container Scanning**: Trivy scans for vulnerabilities

## Scalability Considerations

### Horizontal Scaling

- **Backend**: ECS auto-scaling based on CPU/memory
- **Database**: Read replicas for read-heavy workloads
- **Frontend**: CDN distribution for global users

### Vertical Scaling

- **Backend**: Increase container resources (CPU/RAM)
- **Database**: Larger RDS instance types

### Caching Strategy

- **Browser Caching**: Static assets with cache headers
- **API Caching**: Redis for frequently accessed data (future)
- **Database Caching**: SQLAlchemy query cache

## Monitoring & Observability

### Logging

- **Backend**: Structured JSON logs to stdout → CloudWatch
- **Frontend**: Browser console + error tracking service
- **Database**: PostgreSQL logs for slow queries

### Metrics

- **Application**: Request latency, error rates
- **Infrastructure**: CPU, memory, disk usage
- **Database**: Connection pool, query performance

### Health Checks

- **Backend**: `GET /health` endpoint
- **Database**: Connection test in health check
- **Frontend**: Static file availability

## Development Workflow

### Local Development

1. Edit code (frontend or backend)
2. Hot reload automatically updates running container
3. Test changes in browser
4. Run tests: `docker-compose run backend pytest`
5. Commit changes (pre-commit hooks run linting)

### Deployment Workflow

1. Push to GitHub (triggers CI/CD)
2. GitHub Actions runs tests and builds containers
3. Push Docker images to ECR
4. Terraform updates ECS task definitions
5. ECS deploys new containers with rolling update
6. ALB health checks verify new containers
7. Old containers drained and terminated

## Architectural Decisions

### Why FastAPI?
- Automatic OpenAPI documentation
- Type hints and validation with Pydantic
- High performance (async support)
- Modern Python patterns

### Why React + Vite?
- Vite provides extremely fast HMR
- React has large ecosystem and community
- TypeScript ensures type safety
- Component-based architecture is maintainable

### Why PostgreSQL?
- ACID transactions for data integrity
- Rich feature set (JSON, full-text search)
- Excellent SQLAlchemy support
- Proven reliability and performance

### Why Docker?
- Consistent dev/prod environments
- Isolated dependencies
- Easy local development
- Cloud-agnostic deployment

### Why AWS ECS (not Kubernetes)?
- Simpler than Kubernetes for small-medium apps
- Tight AWS integration
- Lower operational overhead
- Cost-effective for this scale

## Future Architecture Enhancements

### Near-term
- Redis caching layer
- Celery background jobs
- WebSocket support for real-time features
- GraphQL API option

### Long-term
- Microservices architecture (if needed)
- Event-driven patterns with SQS/SNS
- Multi-region deployment
- Kubernetes migration (if scale requires)

---

This architecture provides a solid foundation for production web applications with room to grow as requirements evolve.
