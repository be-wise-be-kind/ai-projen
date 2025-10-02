# React + Python Full-Stack Application Plugin

**Purpose**: Provides complete full-stack web application starter with React TypeScript frontend and Python FastAPI backend

**Scope**: Production-ready web applications with modern frontend, scalable backend, database integration, and complete Docker orchestration

**Overview**: This meta-plugin orchestrates multiple language and infrastructure plugins to create a complete
    full-stack web application. It provides a React 18 + TypeScript + Vite frontend, FastAPI + SQLAlchemy backend,
    PostgreSQL database, Docker Compose orchestration, CI/CD pipeline, AWS deployment infrastructure, and
    comprehensive documentation. The application includes authentication patterns, API client with error handling,
    hot reload for both frontend and backend, health checks, logging, and testing infrastructure. Designed for
    developers building modern web applications with strong typing, excellent developer experience, and
    production-ready patterns.

**Dependencies**: foundation/ai-folder, languages/python, languages/typescript, infrastructure/containerization/docker, infrastructure/ci-cd/github-actions, infrastructure/iac/terraform-aws, standards plugins

**Exports**: Complete full-stack application with backend API, frontend SPA, database, Docker orchestration, CI/CD pipeline, deployment infrastructure, and comprehensive how-to guides

**Related**: Python plugin (plugins/languages/python/), TypeScript plugin (plugins/languages/typescript/), Docker plugin (plugins/infrastructure/containerization/docker/)

**Implementation**: Meta-plugin pattern that composes language and infrastructure plugins with application-specific starter code, configuration, and documentation

---

## What You Get

This plugin provides a complete, production-ready full-stack web application:

### Backend (Python + FastAPI)
- **FastAPI REST API** with automatic OpenAPI documentation
- **SQLAlchemy ORM** with PostgreSQL database integration
- **Pydantic models** for request/response validation
- **Alembic migrations** for database schema management
- **JWT authentication** patterns with secure password handling
- **CORS configuration** for frontend-backend communication
- **Health check endpoint** for monitoring
- **Error handling middleware** with structured logging
- **pytest test suite** with coverage reporting
- **Type hints** throughout with mypy validation

### Frontend (React + TypeScript + Vite)
- **React 18** with TypeScript and strict mode
- **Vite** for fast development and optimized builds
- **React Router** for client-side routing
- **API client** with error handling and retry logic
- **Component library** structure with examples
- **Type-safe** API interfaces generated from backend
- **State management** patterns (Context API ready)
- **Vitest** for component and unit testing
- **ESLint + Prettier** for code quality
- **Hot Module Replacement (HMR)** for instant updates

### Infrastructure
- **Docker Compose** orchestration for all services
- **Multi-stage Dockerfiles** for dev, test, and production
- **PostgreSQL 15** database with persistent volume
- **Hot reload** for both frontend and backend
- **Nginx** reverse proxy (optional)
- **GitHub Actions** CI/CD pipeline
- **Terraform** infrastructure as code for AWS
- **Health checks** and logging for all services

### Documentation & Guides
- **Architecture documentation** explaining full-stack design
- **API-Frontend integration guide** for communication patterns
- **4 comprehensive how-to guides**:
  - How to add an API endpoint
  - How to add a frontend page
  - How to connect frontend to API
  - How to deploy the full-stack app
- **Code generation templates** for common patterns
- **Complete README** for the generated application

## Technology Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **Backend** | Python | 3.11+ | Application runtime |
| | FastAPI | 0.104+ | Web framework |
| | SQLAlchemy | 2.0+ | ORM |
| | Pydantic | 2.0+ | Data validation |
| | Alembic | 1.12+ | Database migrations |
| | pytest | 7.4+ | Testing |
| **Frontend** | TypeScript | 5.0+ | Type-safe JavaScript |
| | React | 18.2+ | UI library |
| | Vite | 5.0+ | Build tool |
| | React Router | 6.20+ | Routing |
| | Vitest | 1.0+ | Testing |
| **Database** | PostgreSQL | 15+ | Relational database |
| **Infrastructure** | Docker | 20.10+ | Containerization |
| | Docker Compose | 2.0+ | Orchestration |
| | GitHub Actions | - | CI/CD |
| | Terraform | 1.5+ | IaC |
| | AWS ECS | - | Container hosting |

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Python 3.11+ installed
- Node.js 18+ installed
- Git repository initialized

### Installation

Follow the installation instructions in `AGENT_INSTRUCTIONS.md`:

1. Install all required plugin dependencies
2. Copy application starter code
3. Configure environment variables
4. Build and start containers

### Start Development

```bash
# Build containers
docker-compose build

# Start all services
docker-compose up

# Backend runs on: http://localhost:8000
# Frontend runs on: http://localhost:5173
# API docs at: http://localhost:8000/docs
```

### Run Tests

```bash
# Backend tests
docker-compose run backend pytest

# Frontend tests
docker-compose run frontend npm test

# Coverage reports
docker-compose run backend pytest --cov
docker-compose run frontend npm run test:coverage
```

### Development Workflow

1. **Edit Backend Code**: Changes automatically reload via uvicorn
2. **Edit Frontend Code**: Changes instantly update via Vite HMR
3. **Add API Endpoint**: Follow `.ai/howtos/fullstack/how-to-add-api-endpoint.md`
4. **Add Frontend Page**: Follow `.ai/howtos/fullstack/how-to-add-frontend-page.md`
5. **Connect Frontend to API**: Follow `.ai/howtos/fullstack/how-to-connect-frontend-to-api.md`

## Project Structure

```
your-project/
├── backend/
│   ├── src/
│   │   ├── __init__.py
│   │   ├── main.py              # FastAPI application entry point
│   │   ├── config.py            # Configuration and environment variables
│   │   ├── routers/
│   │   │   ├── __init__.py
│   │   │   └── health.py        # Health check endpoint
│   │   └── models/              # SQLAlchemy models (add your own)
│   ├── tests/
│   │   ├── __init__.py
│   │   └── test_health.py       # Example test
│   ├── alembic/                 # Database migrations
│   ├── pyproject.toml           # Python dependencies
│   └── .env                     # Backend environment variables
│
├── frontend/
│   ├── src/
│   │   ├── main.tsx             # React application entry point
│   │   ├── App.tsx              # Root component
│   │   ├── api/
│   │   │   └── client.ts        # API client with error handling
│   │   ├── components/
│   │   │   └── Health.tsx       # Example health check component
│   │   ├── pages/
│   │   │   └── Home.tsx         # Home page example
│   │   └── types/               # TypeScript type definitions
│   ├── public/                  # Static assets
│   ├── index.html               # HTML entry point
│   ├── package.json             # Frontend dependencies
│   ├── tsconfig.json            # TypeScript configuration
│   ├── vite.config.ts           # Vite configuration
│   └── .env                     # Frontend environment variables
│
├── docker-compose.fullstack.yml # Multi-container orchestration
├── .github/
│   └── workflows/               # CI/CD pipelines
├── terraform/                   # AWS infrastructure as code
└── .ai/
    ├── docs/
    │   ├── fullstack-architecture.md      # Architecture guide
    │   └── api-frontend-integration.md    # Integration patterns
    ├── howtos/fullstack/
    │   ├── README.md
    │   ├── how-to-add-api-endpoint.md
    │   ├── how-to-add-frontend-page.md
    │   ├── how-to-connect-frontend-to-api.md
    │   └── how-to-deploy-fullstack-app.md
    └── templates/fullstack/
        ├── api-router.py.template
        ├── react-component.tsx.template
        └── api-client.ts.template
```

## Features

### Authentication & Security
- JWT token-based authentication pattern
- Secure password hashing with bcrypt
- CORS configuration for frontend-backend communication
- Secret scanning with gitleaks
- Dependency vulnerability scanning
- SQL injection prevention via SQLAlchemy ORM

### Developer Experience
- Hot reload for both frontend and backend
- Type safety throughout (Python type hints + TypeScript)
- Automatic API documentation (FastAPI OpenAPI)
- Pre-commit hooks for code quality
- Comprehensive error handling and logging
- Docker-based development (no local dependencies)

### Production Ready
- Multi-stage Docker builds for optimization
- Health check endpoints for monitoring
- Database migrations with Alembic
- Environment-based configuration
- CI/CD pipeline with automated testing
- AWS deployment with Terraform
- Logging and monitoring infrastructure

### Testing
- Backend: pytest with coverage, fixtures, async support
- Frontend: Vitest with React Testing Library
- Integration tests between frontend and backend
- CI/CD automated testing on every commit

## How-To Guides

Complete how-to guides are provided in `.ai/howtos/fullstack/`:

1. **[How to Add an API Endpoint](ai-content/howtos/how-to-add-api-endpoint.md)**
   - Create FastAPI router
   - Define Pydantic models
   - Add database operations
   - Write tests
   - Document with OpenAPI

2. **[How to Add a Frontend Page](ai-content/howtos/how-to-add-frontend-page.md)**
   - Create React component
   - Add routing
   - Implement state management
   - Add tests
   - Style with CSS modules

3. **[How to Connect Frontend to API](ai-content/howtos/how-to-connect-frontend-to-api.md)**
   - Use API client
   - Handle errors
   - Manage loading states
   - Type-safe requests
   - Cache responses

4. **[How to Deploy Full-Stack App](ai-content/howtos/how-to-deploy-fullstack-app.md)**
   - Configure AWS infrastructure
   - Set up CI/CD pipeline
   - Deploy with Terraform
   - Configure monitoring
   - Manage secrets

## Documentation

### Architecture
- **[Full-Stack Architecture](ai-content/docs/fullstack-architecture.md)**: Complete system design, component interaction, data flow, and architectural decisions
- **[API-Frontend Integration](ai-content/docs/api-frontend-integration.md)**: Communication patterns, error handling, authentication, and API client design

### Code Templates
- **api-router.py.template**: FastAPI router module for new endpoints
- **react-component.tsx.template**: React component with TypeScript
- **api-client.ts.template**: Frontend API client for new endpoints

## Common Commands

```bash
# Development
docker-compose up                    # Start all services
docker-compose up -d                 # Start in background
docker-compose logs -f backend       # Follow backend logs
docker-compose logs -f frontend      # Follow frontend logs

# Testing
docker-compose run backend pytest                      # Run backend tests
docker-compose run backend pytest --cov               # With coverage
docker-compose run frontend npm test                  # Run frontend tests
docker-compose run frontend npm run test:coverage     # With coverage

# Linting & Formatting
docker-compose run backend ruff check                 # Lint backend
docker-compose run backend ruff format                # Format backend
docker-compose run frontend npm run lint              # Lint frontend
docker-compose run frontend npm run format            # Format frontend

# Database
docker-compose run backend alembic upgrade head       # Run migrations
docker-compose run backend alembic revision --autogenerate -m "msg"  # Create migration
docker-compose exec db psql -U postgres -d app_db    # Access database

# Debugging
docker-compose run backend python -m pdb src/main.py  # Debug backend
docker-compose exec backend bash                      # Backend shell
docker-compose exec frontend sh                       # Frontend shell

# Cleanup
docker-compose down                  # Stop all services
docker-compose down -v              # Stop and remove volumes
docker-compose build --no-cache     # Rebuild without cache
```

## Customization

### Change Backend Port
Edit `docker-compose.fullstack.yml` and `backend/.env`:
```yaml
services:
  backend:
    ports:
      - "8080:8000"  # Change 8080 to your port
```

### Change Frontend Port
Edit `docker-compose.fullstack.yml` and `vite.config.ts`:
```yaml
services:
  frontend:
    ports:
      - "3000:5173"  # Change 3000 to your port
```

### Add Database Model
1. Create model in `backend/src/models/`
2. Generate migration: `docker-compose run backend alembic revision --autogenerate -m "add model"`
3. Run migration: `docker-compose run backend alembic upgrade head`

### Add Frontend Library
```bash
docker-compose run frontend npm install <package>
```

### Add Backend Dependency
```bash
docker-compose run backend poetry add <package>
```

## Troubleshooting

### Services Won't Start
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up
```

### Database Connection Issues
```bash
# Check database is running
docker-compose ps

# Restart database
docker-compose restart db

# Check connection string in backend/.env
cat backend/.env | grep DATABASE_URL
```

### Frontend Can't Connect to Backend
- Check CORS settings in `backend/src/config.py`
- Verify `VITE_API_URL` in `frontend/.env`
- Check backend is accessible: `curl http://localhost:8000/health`

### Hot Reload Not Working
- Check volume mounts in `docker-compose.fullstack.yml`
- Restart containers: `docker-compose restart`
- Check file permissions

## Plugin Dependencies

This meta-plugin requires:

1. **foundation/ai-folder** - AI documentation structure
2. **languages/python** - Python tooling and standards
3. **languages/typescript** - TypeScript tooling and standards
4. **infrastructure/containerization/docker** - Containerization
5. **infrastructure/ci-cd/github-actions** - CI/CD pipeline
6. **infrastructure/iac/terraform-aws** - AWS infrastructure
7. **standards/security** - Security scanning
8. **standards/documentation** - Documentation standards
9. **standards/pre-commit-hooks** - Git hooks

## Contributing

Improvements to the starter application are welcome:
- Enhanced authentication patterns
- Additional example components
- More comprehensive tests
- Better error handling
- Performance optimizations

## License

MIT License - See repository root for details

## Support

- **Documentation**: See `.ai/docs/` and `.ai/howtos/fullstack/`
- **Plugin Issues**: Check individual plugin READMEs
- **Application Issues**: Consult how-to guides and architecture docs

---

**Start building your full-stack application today with modern, production-ready patterns!**
