# How-To: Create Multi-Stage Dockerfile

**Purpose**: Build optimized Docker images with separate stages for development, testing, and production

**Scope**: Creating multi-stage Dockerfiles with dev, lint, test, and prod targets

**Prerequisites**:
- Docker installed
- Basic understanding of Dockerfiles
- Application with dependency management (Poetry, npm, etc.)

**Estimated Time**: 30-45 minutes

**Difficulty**: Intermediate

---

## Overview

Multi-stage Docker builds allow you to:
- Reduce production image size by 50-70%
- Optimize build caching for faster rebuilds
- Separate development and production dependencies
- Create specialized images for linting and testing

This guide shows you how to create a multi-stage Dockerfile with four targets: `base`, `dev`, `test`, and `prod`.

---

## Steps

### Step 1: Create the Base Stage

The base stage contains only production dependencies. All other stages build from this foundation.

**Python Example**:
```dockerfile
# Purpose: Multi-stage Docker build with shared base layer
# Scope: Development, testing, and production environments
# Implementation: Shared base with specialized stages

FROM python:3.11-slim AS base

WORKDIR /app

# Install dependency manager
RUN pip install --no-cache-dir poetry==1.7.1

# Copy dependency files FIRST (optimize caching)
COPY pyproject.toml poetry.lock* ./

# Install ONLY production dependencies
RUN poetry config virtualenvs.create false && \
    poetry install --only main --no-interaction --no-ansi --no-root

# Create non-root user
RUN useradd -m -u 1000 appuser
```

**Node/TypeScript Example**:
```dockerfile
FROM node:20-alpine AS base

WORKDIR /app

# Copy package files FIRST (optimize caching)
COPY package*.json ./

# Install ONLY production dependencies
RUN npm ci --only=production
```

**Key Points**:
- Pin specific versions (`python:3.11-slim`, `node:20-alpine`)
- Copy dependency files before code (optimize caching)
- Install only production deps in base
- Create non-root user for security

### Step 2: Create the Development Stage

The dev stage includes all dependencies and enables hot reload.

**Python Example**:
```dockerfile
FROM base AS dev

# Install all dependencies (including dev)
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

# Development server with hot reload
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

**Node/TypeScript Example**:
```dockerfile
FROM base AS dependencies

# Install ALL dependencies
RUN npm ci

# Copy source code
COPY . .

FROM dependencies AS dev

EXPOSE 5173

# Vite dev server with HMR
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
```

### Step 3: Create the Test Stage

The test stage includes testing tools and runs tests.

**Python Example**:
```dockerfile
FROM base AS test

# Install all dependencies (including test)
RUN poetry install --no-interaction --no-ansi --no-root

# Copy application code and tests
COPY app ./app
COPY src ./src
COPY tests ./tests

# Create test user
RUN useradd -m -u 1002 tester && \
    mkdir -p /app/.pytest_cache && \
    chown -R tester:tester /app

USER tester

WORKDIR /app

# Set cache and coverage directories
ENV PYTEST_CACHE_DIR=/app/.pytest_cache
ENV COVERAGE_FILE=/tmp/.coverage

# Run tests with coverage
CMD ["pytest", "tests/", "--cov=app", "--cov=src", "-v"]
```

**Node/TypeScript Example**:
```dockerfile
FROM dependencies AS test

ENV NODE_ENV=test
ENV CI=true

# Run tests with coverage
CMD ["npm", "run", "test:coverage"]
```

### Step 4: Create the Production Stage

The prod stage is minimal - only runtime dependencies and code.

**Python Example**:
```dockerfile
FROM base AS prod

# Copy ONLY application code (no tests, no dev tools)
COPY app ./app
COPY src ./src

# Set ownership
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Production server (no reload)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Node/TypeScript with Nginx**:
```dockerfile
FROM dependencies AS builder

ARG BUILD_TIMESTAMP=unknown
ENV VITE_BUILD_TIMESTAMP=$BUILD_TIMESTAMP

# Build production bundle
RUN npm run build

FROM nginx:alpine AS prod

# Copy built assets
COPY --from=builder /app/dist /usr/share/nginx/html

# Configure nginx for SPA
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Step 5: Build Different Targets

Build specific stages as needed:

```bash
# Development image
docker build --target dev -t myapp:dev .

# Test image
docker build --target test -t myapp:test .

# Production image
docker build --target prod -t myapp:prod .

# All stages (for CI)
docker build --target dev -t myapp:dev . && \
docker build --target test -t myapp:test . && \
docker build --target prod -t myapp:prod .
```

### Step 6: Compare Image Sizes

Verify your optimization worked:

```bash
docker images | grep myapp

# Expected output:
# myapp  prod  200MB  (minimal)
# myapp  test  500MB  (includes test tools)
# myapp  dev   600MB  (includes dev tools)
```

Production should be **50-70% smaller** than development.

---

## Advanced: Add Lint Stage

For comprehensive quality checks, add a lint stage:

**Python Example**:
```dockerfile
FROM base AS lint

# Install all dependencies including linting tools
RUN poetry install --no-interaction --no-ansi --no-root

# Install system tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    shellcheck git && \
    rm -rf /var/lib/apt/lists/*

# Create linting user
RUN useradd -m -u 1001 linter && \
    mkdir -p /workspace && \
    chown -R linter:linter /workspace

USER linter
WORKDIR /workspace

# Keep running for make targets
CMD ["tail", "-f", "/dev/null"]
```

Build and use:
```bash
docker build --target lint -t myapp:lint .
docker run --rm -v $(pwd):/workspace myapp:lint make lint-all
```

---

## Best Practices

### 1. Order Layers by Change Frequency

```dockerfile
# 1. Base image (rarely changes)
FROM python:3.11-slim AS base

# 2. System dependencies (rarely changes)
RUN apt-get update && ...

# 3. Dependency files (changes occasionally)
COPY pyproject.toml poetry.lock ./

# 4. Install dependencies (changes occasionally)
RUN poetry install --only main

# 5. Application code (changes frequently)
COPY app ./app
```

### 2. Minimize Production Image

**Include**:
- Application code
- Production dependencies
- Runtime environment

**Exclude**:
- Development dependencies
- Testing tools
- Build tools
- Documentation
- .git directory

### 3. Use .dockerignore

```
# .dockerignore
node_modules/
__pycache__/
*.pyc
.git/
.env
tests/
*.md
.coverage
```

### 4. Non-Root User in Production

```dockerfile
# Create user in base stage
RUN useradd -m -u 1000 appuser

# Use in production stage
USER appuser
```

---

## Common Patterns

### Pattern: Shared Dependencies Stage

For complex builds, create a dependencies stage:

```dockerfile
FROM base AS dependencies
RUN npm ci  # Install ALL dependencies

FROM dependencies AS dev
# Dev tools already available

FROM dependencies AS test
# Test tools already available
```

### Pattern: Build Arguments

Pass build-time variables:

```dockerfile
ARG BUILD_VERSION=unknown
ARG BUILD_TIMESTAMP=unknown

ENV APP_VERSION=$BUILD_VERSION

RUN echo "Building version $BUILD_VERSION at $BUILD_TIMESTAMP"
```

Build with:
```bash
docker build \
  --build-arg BUILD_VERSION=1.2.3 \
  --build-arg BUILD_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --target prod -t myapp:1.2.3 .
```

---

## Verification

Check your multi-stage Dockerfile:

- [ ] Base stage has only production dependencies
- [ ] Dev stage includes all dependencies and hot reload
- [ ] Test stage runs tests successfully
- [ ] Prod stage is minimal (50-70% smaller than dev)
- [ ] All stages use non-root user
- [ ] Health checks configured where appropriate
- [ ] Layer caching optimized (dependencies before code)
- [ ] .dockerignore configured

Test each stage:

```bash
# Test dev stage
docker build --target dev -t myapp:dev .
docker run -p 8000:8000 myapp:dev

# Test test stage
docker build --target test -t myapp:test .
docker run --rm myapp:test

# Test prod stage
docker build --target prod -t myapp:prod .
docker run -p 8000:8000 myapp:prod

# Compare sizes
docker images | grep myapp
```

---

## Common Issues

### Issue: Build is slow

**Solutions**:
- Ensure dependency files copied before code
- Use .dockerignore to exclude unnecessary files
- Enable BuildKit: `export DOCKER_BUILDKIT=1`
- Use smaller base images (alpine, slim)

### Issue: Production image too large

**Solutions**:
- Verify prod stage doesn't install dev dependencies
- Use multi-stage to exclude build artifacts
- Use alpine or slim base images
- Remove unnecessary files in final stage

### Issue: Layer caching not working

**Solutions**:
- Order Dockerfile instructions from least to most frequently changed
- Don't COPY entire directory before installing dependencies
- Use specific COPY commands instead of `COPY . .` early

---

## Next Steps

After creating your multi-stage Dockerfile:

1. Add to docker-compose.yml with target specification
2. Create Makefile targets for building different stages
3. Configure CI/CD to build and push images
4. Add lint stage for code quality
5. Document image sizes and build times

---

## Related Documentation

- [Docker Standards](../standards/DOCKER_STANDARDS.md)
- [How to Add a Service](how-to-add-a-service.md)
- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)

---

**Last Updated**: 2025-10-01
**Difficulty**: Intermediate
**Estimated Time**: 30-45 minutes
