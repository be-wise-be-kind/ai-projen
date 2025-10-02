# Docker Infrastructure Standards

**Purpose**: Best practices and standards for Docker containerization

**Scope**: Multi-stage Docker builds, orchestration, security, and performance optimization

**Overview**: Comprehensive standards for implementing Docker infrastructure in modern web applications.
    Covers multi-stage build patterns, development orchestration, security best practices, performance
    optimization, and production deployment strategies. Based on industry best practices and real-world
    patterns from production applications.

**Dependencies**: Docker 20.10+, Docker Compose V2+

**Related**: AGENT_INSTRUCTIONS.md for installation, README.md for usage

**Implementation**: Standards and guidelines for containerized development

---

## Core Principles

### 1. Multi-Stage Builds are Mandatory

Every Dockerfile MUST use multi-stage builds with separate targets:

**Required Stages**:
- `base`: Shared foundation with production dependencies only
- `dev`: Development environment with hot reload
- `lint`: Linting tools (optional but recommended)
- `test`: Testing environment (optional but recommended)
- `prod`: Minimal production runtime

**Benefits**:
- Reduces production image size by 50-70%
- Optimizes layer caching for faster builds
- Separates development and production dependencies
- Enables parallel builds for different environments

### 2. Development First, Production Ready

Docker setup MUST support both:
- **Development**: Hot reload, debugging tools, verbose logging
- **Production**: Minimal size, security hardening, optimized performance

### 3. Security by Default

All containers MUST:
- Run as non-root user
- Use minimal base images (slim, alpine)
- Exclude secrets from images (.dockerignore)
- Implement health checks
- Keep base images updated

### 4. Performance Optimized

All Dockerfiles MUST:
- Leverage layer caching (COPY package files before code)
- Use .dockerignore to reduce build context
- Minimize layers with multi-command RUN statements
- Use BuildKit for parallel builds

---

## Dockerfile Standards

### File Header Requirements

Every Dockerfile MUST start with a header comment:

```dockerfile
# Purpose: [What this Dockerfile does]
# Scope: [What environments it supports]
# Overview: [Brief description of build strategy]
# Dependencies: [Required tools and versions]
# Exports: [Available build targets]
# Interfaces: [Exposed ports and endpoints]
# Related: [Related files]
# Implementation: [Build pattern used]
```

### Base Stage Standards

```dockerfile
FROM python:3.11-slim AS base  # Pin specific versions, use slim/alpine

WORKDIR /app

# Install dependency manager
RUN pip install --no-cache-dir poetry==1.7.1

# Copy ONLY dependency files (leverage caching)
COPY pyproject.toml poetry.lock* ./

# Install ONLY production dependencies
RUN poetry config virtualenvs.create false && \
    poetry install --only main --no-interaction --no-ansi --no-root

# Create non-root user for security
RUN useradd -m -u 1000 appuser
```

**Requirements**:
- ✅ Pin specific image versions
- ✅ Use slim or alpine variants
- ✅ Copy dependency files before code
- ✅ Install only production deps in base
- ✅ Create non-root user
- ✅ Use --no-cache-dir for pip installs
- ✅ Minimize layers

### Development Stage Standards

```dockerfile
FROM base AS dev

# Install all dependencies including dev
RUN poetry install --no-interaction --no-ansi --no-root

# Copy application code
COPY app ./app
COPY src ./src

# Set ownership
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Dev server with hot reload
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

**Requirements**:
- ✅ Install dev dependencies
- ✅ Copy all application code
- ✅ Run as non-root user
- ✅ Expose ports
- ✅ Include health check
- ✅ Enable hot reload for dev server

### Production Stage Standards

```dockerfile
FROM base AS prod

# Copy ONLY application code (no tests, no dev tools)
COPY app ./app
COPY src ./src

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Production server (no reload)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Requirements**:
- ✅ Minimal image (no dev tools, no tests)
- ✅ Run as non-root user
- ✅ Health check configured
- ✅ Production-ready server config
- ✅ No debug flags or reload

---

## docker-compose.yml Standards

### File Header Requirements

Every docker-compose.yml MUST start with a header comment:

```yaml
# Purpose: [What this compose file orchestrates]
# Scope: [Development/Testing/Production]
# Overview: [Services and configuration]
# Dependencies: [Required files]
# Exports: [Available services]
# Interfaces: [Exposed ports]
# Implementation: [Orchestration pattern]
```

### Service Configuration Standards

```yaml
services:
  backend-dev:
    build:
      context: .  # Use project root as context
      dockerfile: .docker/dockerfiles/Dockerfile.backend
      target: dev  # Specify target stage
    container_name: ${PROJECT_NAME:-app}-backend-${BRANCH_NAME:-main}-dev
    ports:
      - "${BACKEND_PORT:-8000}:8000"  # Use env vars with defaults
    environment:
      - ENV=development
      - PYTHONUNBUFFERED=1  # For Python: unbuffered output
    volumes:
      # Mount source code for hot reload
      - ./app:/app/app
      # Exclude cache directories
      - /app/__pycache__
    networks:
      - app-network
    restart: unless-stopped  # Auto-restart unless explicitly stopped
    healthcheck:
      test: ["CMD-SHELL", "...health check command..."]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

**Requirements**:
- ✅ Use build context at project root
- ✅ Specify target stage explicitly
- ✅ Use descriptive container names with variables
- ✅ Use environment variables with defaults
- ✅ Mount source for hot reload
- ✅ Exclude cache/temp directories from mounts
- ✅ Configure networks
- ✅ Set restart policy
- ✅ Include health checks

### Volume Mount Standards

**Backend (Python)**:
```yaml
volumes:
  - ./app:/app/app          # Application code
  - ./src:/app/src          # Source code
  - ./tests:/app/tests      # Tests
  - /app/__pycache__        # Exclude Python cache
```

**Frontend (Node)**:
```yaml
volumes:
  - ./frontend:/app         # All frontend code
  - /app/node_modules       # Exclude node_modules (use container's)
```

**Requirements**:
- ✅ Mount source directories for hot reload
- ✅ Exclude dependency directories (they're in the image)
- ✅ Exclude cache/build directories
- ✅ Use absolute paths in container

---

## .dockerignore Standards

### Required Exclusions

Every .dockerignore MUST exclude:

```
# Version control
.git
.github

# Dependencies (reinstalled in container)
node_modules/
__pycache__/
*.pyc

# Environment files (may contain secrets)
.env
.env.*

# Build artifacts
dist/
build/
*.egg-info/

# IDE files
.vscode/
.idea/
*.swp

# OS files
.DS_Store
Thumbs.db

# Documentation
*.md

# Test artifacts
.coverage
htmlcov/
.pytest_cache/

# Docker files (avoid recursion)
.docker/
docker-compose*.yml
Dockerfile*
.dockerignore
```

**Requirements**:
- ✅ Exclude all development dependencies
- ✅ Exclude environment files with secrets
- ✅ Exclude IDE and OS files
- ✅ Exclude test artifacts
- ✅ Exclude Docker files themselves

---

## Security Standards

### 1. Non-Root User Requirement

**MANDATORY**: All containers MUST run as non-root user

```dockerfile
# Create non-root user
RUN useradd -m -u 1000 appuser

# Set ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser
```

### 2. Secret Management

**NEVER** include secrets in Docker images:

```dockerfile
# ❌ WRONG - hardcoded secret
ENV SECRET_KEY=my-secret-key

# ✅ CORRECT - secret from environment
ENV SECRET_KEY=${SECRET_KEY}
```

**Use .dockerignore**:
```
.env
.env.*
*.pem
*.key
credentials.json
```

### 3. Base Image Security

**Requirements**:
- Use official images only
- Pin specific versions (no `latest` tag)
- Use minimal variants (slim, alpine)
- Scan images for vulnerabilities

```dockerfile
# ✅ CORRECT
FROM python:3.11-slim AS base

# ❌ WRONG
FROM python AS base  # No version pinning
```

### 4. Minimal Production Images

Production images MUST contain only:
- Application code
- Production dependencies
- Runtime environment
- Health check utilities

**Do NOT include**:
- Development dependencies
- Testing tools
- Build tools (unless runtime-required)
- Documentation
- Source maps (unless needed)

---

## Performance Standards

### 1. Layer Caching Optimization

**Order operations by change frequency**:

```dockerfile
# 1. Base image (rarely changes)
FROM python:3.11-slim AS base

# 2. System dependencies (rarely changes)
RUN apt-get update && apt-get install -y ...

# 3. Dependency files (changes occasionally)
COPY pyproject.toml poetry.lock ./

# 4. Install dependencies (changes occasionally)
RUN poetry install --only main

# 5. Application code (changes frequently)
COPY app ./app
```

### 2. Build Context Minimization

**Use .dockerignore aggressively**:
- Reduces build context upload time
- Prevents unnecessary file copying
- Improves build cache effectiveness

**Target**: Build context should be <100MB for most apps

### 3. Multi-Stage Build Benefits

**Size Reduction**:
- Base image with all build tools: ~1GB
- Production image with only runtime: ~200MB
- **Savings**: 80% reduction

**Build Speed**:
- Parallel builds of different stages
- Better cache utilization
- Reduced network transfer for pushes

---

## Health Check Standards

### Backend Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1
```

**Requirements**:
- ✅ interval: 30s (how often to check)
- ✅ timeout: 3s (time allowed for check)
- ✅ start_period: 5s+ (startup grace period)
- ✅ retries: 3 (failures before unhealthy)

### Frontend Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1
```

### Health Check Endpoints

Backend applications SHOULD implement `/health` endpoint:

```python
@app.get("/health")
async def health():
    return {"status": "healthy", "version": "1.0.0"}
```

---

## Development Standards

### Hot Reload Configuration

**Backend (Python with uvicorn)**:
```dockerfile
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

```yaml
volumes:
  - ./app:/app/app  # Mount source for hot reload
```

**Frontend (Vite)**:
```dockerfile
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
```

```yaml
volumes:
  - ./frontend:/app
  - /app/node_modules  # Exclude node_modules
```

### Development vs Production

**Development**:
- Hot reload enabled
- Debug logging
- Development dependencies installed
- Source maps enabled
- Verbose error messages

**Production**:
- No hot reload
- Minimal logging
- Only production dependencies
- Optimized builds
- Generic error messages

---

## Networking Standards

### Service Communication

Services in the same docker-compose network communicate via service name:

```yaml
# Backend URL from frontend
VITE_API_URL=http://backend-dev:8000

# Database URL from backend
DATABASE_URL=postgresql://user:pass@postgres:5432/db
```

**Requirements**:
- ✅ Use service names, not localhost
- ✅ Use internal ports, not published ports
- ✅ Create explicit networks

### Network Configuration

```yaml
networks:
  app-network:
    driver: bridge
```

**Requirements**:
- ✅ Use descriptive network names
- ✅ Use bridge driver for local dev
- ✅ Isolate services with multiple networks if needed

---

## Makefile Integration Standards

### Required Targets

Makefile MUST provide these Docker targets:

```makefile
docker-build         # Build all images
docker-up            # Start services
docker-down          # Stop services
docker-logs          # View logs
docker-shell-backend # Shell into backend
docker-shell-frontend# Shell into frontend
docker-clean         # Cleanup
docker-rebuild       # Clean rebuild
```

### Target Conventions

- Prefix all Docker targets with `docker-`
- Provide help text with `##` comments
- Use `.PHONY` for all targets
- Include both verbose and quiet options

---

## Production Deployment Standards

### Building Production Images

```bash
# Build production images
docker build --target prod -t myapp/backend:1.0.0 -f .docker/dockerfiles/Dockerfile.backend .
docker build --target prod -t myapp/frontend:1.0.0 -f .docker/dockerfiles/Dockerfile.frontend .

# Tag for registry
docker tag myapp/backend:1.0.0 registry.example.com/myapp/backend:1.0.0
docker tag myapp/frontend:1.0.0 registry.example.com/myapp/frontend:1.0.0

# Push to registry
docker push registry.example.com/myapp/backend:1.0.0
docker push registry.example.com/myapp/frontend:1.0.0
```

### Production docker-compose

**Do NOT use docker-compose for production**. Use:
- Kubernetes
- ECS
- Docker Swarm
- Cloud Run
- Other orchestration platforms

docker-compose is for **development only**.

---

## Common Patterns

### Pattern: Python Backend with Poetry

```dockerfile
FROM python:3.11-slim AS base
WORKDIR /app
RUN pip install --no-cache-dir poetry==1.7.1
COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.create false && \
    poetry install --only main --no-interaction --no-ansi --no-root
```

### Pattern: Node Frontend with npm

```dockerfile
FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
```

### Pattern: Frontend Production with Nginx

```dockerfile
FROM nginx:alpine AS prod
COPY --from=builder /app/dist /usr/share/nginx/html
RUN echo 'server { ... SPA routing config ... }' > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## Testing Standards

### Running Tests in Docker

```bash
# Build test image
docker build --target test -t myapp/backend:test -f Dockerfile.backend .

# Run tests
docker run --rm myapp/backend:test

# Or with docker-compose
docker compose run --rm backend-test
```

### Test Stage Requirements

```dockerfile
FROM base AS test
RUN poetry install --no-interaction  # All deps including test
COPY app ./app
COPY tests ./tests
USER tester
CMD ["pytest", "tests/", "--cov=app", "-v"]
```

**Requirements**:
- ✅ Install all dependencies (including test)
- ✅ Copy application code and tests
- ✅ Run as non-root user
- ✅ Generate coverage reports
- ✅ Exit with proper status code

---

## Troubleshooting Standards

### Common Issues and Solutions

**Issue**: Hot reload not working
- Check volume mounts match your directory structure
- Verify permissions (containers run as non-root)
- Ensure dev server is configured for hot reload

**Issue**: Build failures
- Clear Docker cache: `docker builder prune -a`
- Check .dockerignore isn't excluding required files
- Verify all COPY paths are correct

**Issue**: Slow builds
- Optimize .dockerignore
- Use BuildKit: `export DOCKER_BUILDKIT=1`
- Check layer caching order

**Issue**: Container can't connect to database
- Use service name, not localhost
- Check network configuration
- Wait for database to be ready (healthcheck)

---

## Checklist for New Projects

When implementing Docker infrastructure:

- [ ] Multi-stage Dockerfiles for each component
- [ ] Separate dev, lint, test, prod stages
- [ ] docker-compose.yml with hot reload
- [ ] .dockerignore configured
- [ ] .env.example template
- [ ] Makefile targets for common operations
- [ ] Health checks on all services
- [ ] Non-root users in all containers
- [ ] No secrets in images
- [ ] Layer caching optimized
- [ ] Documentation updated

---

**Version**: 1.0.0
**Last Updated**: 2025-10-01
**Maintained By**: ai-projen framework
