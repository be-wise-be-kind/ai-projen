# Docker Infrastructure Plugin

Complete containerization solution for frontend and backend applications with multi-stage builds and development orchestration.

## Overview

The Docker infrastructure plugin provides production-ready containerization for modern web applications. It implements multi-stage Docker builds optimized for development, linting, testing, and production environments, along with docker-compose orchestration for seamless local development.

**Key Features**:
- Multi-stage Dockerfiles for backend (Python) and frontend (React/TypeScript)
- Development orchestration with docker-compose
- Hot-reload support for instant code updates
- Optimized layer caching for fast builds
- Separate stages for dev, lint, test, and production
- Health checks for all services
- Volume mounts for live development
- Network configuration for service communication

## What This Plugin Provides

### Dockerfiles

**Backend (Python/FastAPI)**:
- `base`: Shared foundation with Poetry and production dependencies
- `dev`: Development environment with hot reload (uvicorn --reload)
- `lint`: Linting tools (Ruff, MyPy, Bandit, Pylint, etc.)
- `test`: Testing environment with pytest and coverage
- `prod`: Minimal production image (~50% smaller than dev)

**Frontend (React/Vite)**:
- `base`: Shared foundation with production dependencies
- `dependencies`: Full dev dependencies
- `dev`: Vite dev server with Hot Module Replacement (HMR)
- `lint`: ESLint, Prettier, TypeScript checking
- `test`: Vitest testing environment
- `builder`: Production build creation
- `prod`: Nginx serving optimized static build

### Docker Compose Orchestration

**Development Configuration**:
- Backend and frontend services with hot reload
- Volume mounts for instant code updates
- Shared network for inter-service communication
- Health checks for service reliability
- Environment variable configuration
- Automatic restart policies

**Additional Services** (optional):
- PostgreSQL database
- Redis cache
- Message queues
- Any other containerized dependencies

### Configuration Files

- `.dockerignore`: Build optimization (excludes node_modules, cache, etc.)
- `.env.example`: Environment variable template
- `docker-compose.yml`: Development orchestration
- Makefile targets: Common Docker operations

## Installation

### Prerequisites

- Docker Engine 20.10+
- Docker Compose V2+
- At least one language plugin (Python or TypeScript)

### Quick Install

Point an AI agent to `AGENT_INSTRUCTIONS.md` for automated installation, or follow these manual steps:

1. **Create directory structure**:
   ```bash
   mkdir -p .docker/dockerfiles
   ```

2. **Copy Dockerfiles**:
   ```bash
   # Backend
   cp plugins/infrastructure/docker/templates/Dockerfile.backend .docker/dockerfiles/

   # Frontend
   cp plugins/infrastructure/docker/templates/Dockerfile.frontend .docker/dockerfiles/
   ```

3. **Copy docker-compose.yml**:
   ```bash
   cp plugins/infrastructure/docker/templates/docker-compose.yml ./
   ```

4. **Copy .dockerignore**:
   ```bash
   cp plugins/infrastructure/docker/templates/.dockerignore ./
   ```

5. **Add Makefile targets**:
   ```bash
   cat plugins/infrastructure/docker/templates/makefile-docker.mk >> Makefile
   ```

6. **Build and start**:
   ```bash
   make docker-build
   make docker-up
   ```

## Usage

### Development Workflow

**Start development environment**:
```bash
make docker-up
```

This starts all services with:
- Hot reload enabled
- Volume mounts for instant updates
- All services networked together
- Logs streaming to console

**View logs**:
```bash
make docker-logs
# or specific service
docker compose logs -f backend-dev
```

**Execute commands in containers**:
```bash
# Backend shell
make docker-shell-backend
# or
docker compose exec backend-dev /bin/bash

# Frontend shell
make docker-shell-frontend
# or
docker compose exec frontend-dev /bin/sh
```

**Stop development environment**:
```bash
make docker-down
```

### Building Images

**Build all images**:
```bash
make docker-build
```

**Build specific target**:
```bash
# Backend dev image
docker build --target dev -t app-backend:dev -f .docker/dockerfiles/Dockerfile.backend .

# Backend production image
docker build --target prod -t app-backend:prod -f .docker/dockerfiles/Dockerfile.backend .

# Frontend dev image
docker build --target dev -t app-frontend:dev -f .docker/dockerfiles/Dockerfile.frontend .

# Frontend production image
docker build --target prod -t app-frontend:prod -f .docker/dockerfiles/Dockerfile.frontend .
```

### Testing in Docker

**Run backend tests**:
```bash
docker compose run --rm backend-test
```

**Run frontend tests**:
```bash
docker compose run --rm frontend-test
```

**Run linting**:
```bash
docker compose run --rm backend-lint make lint-python
docker compose run --rm frontend-lint npm run lint
```

### Production Deployment

**Build production images**:
```bash
docker build --target prod -t app-backend:latest -f .docker/dockerfiles/Dockerfile.backend .
docker build --target prod -t app-frontend:latest -f .docker/dockerfiles/Dockerfile.frontend .
```

**Push to registry**:
```bash
docker tag app-backend:latest registry.example.com/app-backend:latest
docker push registry.example.com/app-backend:latest

docker tag app-frontend:latest registry.example.com/app-frontend:latest
docker push registry.example.com/app-frontend:latest
```

## Configuration

### Environment Variables

Create a `.env` file from the template:
```bash
cp .env.example .env
```

**Common variables**:
```env
PROJECT_NAME=myapp
BRANCH_NAME=main
BACKEND_PORT=8000
FRONTEND_PORT=5173
DB_HOST=postgres
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=myapp_db
REDIS_HOST=redis
REDIS_PORT=6379
```

### Customizing Dockerfiles

**Backend customization**:
- Adjust Python version in `FROM python:3.11-slim`
- Update Poetry version if needed
- Modify source paths in COPY commands
- Change framework command (FastAPI/Flask/Django)

**Frontend customization**:
- Adjust Node version in `FROM node:20-alpine`
- Change dev server port
- Update build commands for different frameworks
- Modify nginx configuration for production

### Adding Services

**Add PostgreSQL**:
```yaml
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
      POSTGRES_DB: ${DB_NAME:-app_db}
    ports:
      - "${DB_PORT:-5432}:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network

volumes:
  postgres-data:
```

**Add Redis**:
```yaml
services:
  redis:
    image: redis:7-alpine
    ports:
      - "${REDIS_PORT:-6379}:6379"
    networks:
      - app-network
```

## Best Practices

### Development
- ✓ Always develop in Docker containers for consistency
- ✓ Use volume mounts for hot reload (never rebuild for code changes)
- ✓ Check logs when debugging: `docker compose logs -f`
- ✓ Use health checks to ensure dependencies are ready
- ✓ Keep containers running with `restart: unless-stopped`

### Building
- ✓ Use multi-stage builds to minimize image size
- ✓ Optimize layer caching (COPY package files before code)
- ✓ Use .dockerignore to exclude unnecessary files
- ✓ Pin specific versions (Python 3.11, Node 20, etc.)
- ✓ Use slim/alpine base images when possible

### Security
- ✓ Run as non-root user in containers
- ✓ Don't include secrets in images (use environment variables)
- ✓ Use .dockerignore to exclude .env files
- ✓ Scan images for vulnerabilities
- ✓ Keep base images updated

### Production
- ✓ Use separate prod stage with minimal dependencies
- ✓ Remove dev tools from production images
- ✓ Use health checks for container orchestration
- ✓ Implement proper logging (stdout/stderr)
- ✓ Set resource limits in production environments

## Troubleshooting

### Port Already in Use
Change ports in `.env` or `docker-compose.yml`:
```env
BACKEND_PORT=8001
FRONTEND_PORT=5174
```

### Hot Reload Not Working
- Verify volume mounts match your project structure
- Check file permissions (containers run as non-root user)
- Ensure framework's dev server watches mounted volumes

### Build Failures
- Clear Docker cache: `make docker-clean && make docker-rebuild`
- Check .dockerignore isn't excluding required files
- Verify paths in Dockerfile COPY commands

### Permission Denied
- Dockerfiles use non-root users (appuser, linter, tester)
- Ensure host files are readable: `chmod -R 755 app/`

### Slow Performance
- Use Docker Desktop with VirtioFS (Mac) or WSL2 (Windows)
- Exclude node_modules and __pycache__ in .dockerignore
- Consider using named volumes for dependencies

## Integration

### With Python Plugin
- Uses Python plugin's multi-stage Dockerfile pattern
- Includes all Python linting/testing tools
- Poetry dependency management
- Hot reload with uvicorn

### With TypeScript Plugin
- Uses Node.js for React/Vite development
- Includes ESLint, Prettier, Vitest
- npm dependency management
- HMR for instant updates

### With CI/CD Plugin
```yaml
# .github/workflows/test.yml
- name: Test in Docker
  run: |
    make docker-build
    docker compose run backend-test
    docker compose run frontend-test
```

## Documentation

- [AGENT_INSTRUCTIONS.md](AGENT_INSTRUCTIONS.md) - AI agent installation guide
- [docker-standards.md](standards/docker-standards.md) - Docker best practices
- [How-To Guides](howtos/) - Step-by-step guides for common tasks

## Templates

Located in `templates/`:
- `Dockerfile.backend` - Python backend multi-stage build
- `Dockerfile.frontend` - React frontend multi-stage build
- `docker-compose.yml` - Full-stack orchestration
- `docker-compose.backend.yml` - Backend-only orchestration
- `docker-compose.frontend.yml` - Frontend-only orchestration
- `.dockerignore` - Build optimization
- `.env.example` - Environment variable template
- `makefile-docker.mk` - Docker make targets

## Contributing

To improve this plugin:
1. Follow the multi-stage pattern
2. Test all targets (dev, lint, test, prod)
3. Optimize layer caching
4. Update documentation
5. Add examples for new frameworks

## Version

**Plugin Version**: 1.0.0
**Docker Version**: 20.10+
**Docker Compose**: V2+
**Maintained By**: ai-projen framework

## License

Part of the ai-projen framework - MIT License
