# Docker Infrastructure Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the Docker infrastructure plugin

**Scope**: Complete containerization setup for frontend and backend applications with development orchestration

**Overview**: Step-by-step instructions for AI agents to install and configure Docker infrastructure
    including multi-stage Dockerfiles for frontend (Node.js/React) and backend (Python/FastAPI),
    docker-compose orchestration with hot-reload development, volume mounts, networking, health checks,
    and production-ready optimizations.

**Dependencies**: Docker, Docker Compose, language plugins (Python/TypeScript)

**Exports**: Complete Docker infrastructure with multi-stage builds and orchestration

**Related**: Infrastructure plugin for containerized development

**Implementation**: Multi-stage Docker pattern with development orchestration

---

## Prerequisites

Before installing this plugin, ensure:
- ✅ Git repository is initialized
- ✅ foundation/ai-folder plugin is installed (agents.md and .ai/ exist)
- ✅ Docker Engine installed (docker --version)
- ✅ Docker Compose installed (docker compose version)
- ✅ At least one language plugin installed (Python and/or TypeScript)

## Installation Steps

### Step 1: Gather Project Information

Ask the user (or detect from existing setup):

1. **Project Type**:
   - Backend only (Python/FastAPI)
   - Frontend only (TypeScript/React)
   - Full-stack (both backend + frontend)
   - Default: **Full-stack**

2. **Backend Configuration** (if backend present):
   - Framework: FastAPI, Flask, Django
   - Port: Default **8000**
   - Source directory: Default **app/** or **src/**

3. **Frontend Configuration** (if frontend present):
   - Framework: React (Vite), Next.js, Vue
   - Port: Default **5173** (Vite) or **3000** (Next.js)
   - Source directory: Default **frontend/**

4. **Environment Variables**:
   - Project name: Default from git repo name
   - Branch name: Default **main**

### Step 2: Create Directory Structure

Create the Docker directory structure:

```bash
mkdir -p .docker/dockerfiles
mkdir -p .docker/compose
```

### Step 3: Install Backend Dockerfile (if backend present)

**If Python backend detected**:

1. Copy the backend Dockerfile:
   ```bash
   cp plugins/infrastructure/docker/templates/Dockerfile.backend .docker/dockerfiles/Dockerfile.backend
   ```

2. **Customize based on project structure**:
   - If source is in `app/`, template is ready
   - If source is in `src/`, update COPY commands
   - Adjust framework-specific CMD in dev/prod stages

3. **Verify multi-stage targets**:
   - `base`: Shared foundation with Poetry and production deps
   - `dev`: Development with hot reload
   - `lint`: All linting tools
   - `test`: Test execution environment
   - `prod`: Minimal production runtime

### Step 4: Install Frontend Dockerfile (if frontend present)

**If TypeScript/React frontend detected**:

1. Copy the frontend Dockerfile:
   ```bash
   cp plugins/infrastructure/docker/templates/Dockerfile.frontend .docker/dockerfiles/Dockerfile.frontend
   ```

2. **Customize based on frontend framework**:
   - **Vite (React)**: Template is ready (port 5173)
   - **Next.js**: Change port to 3000, adjust build command
   - **Vue**: Adjust dev command and port as needed

3. **Verify multi-stage targets**:
   - `base`: Shared foundation with production deps
   - `dependencies`: Full dependencies for dev/lint/test
   - `dev`: Vite dev server with HMR
   - `lint`: Code quality tools
   - `test`: Vitest testing environment
   - `builder`: Production build creation
   - `prod`: Nginx serving optimized build

### Step 5: Create Docker Compose Configuration

**For development orchestration**:

1. Copy the appropriate compose file:

   **Full-stack** (backend + frontend):
   ```bash
   cp plugins/infrastructure/docker/templates/docker-compose.yml ./docker-compose.yml
   ```

   **Backend only**:
   ```bash
   cp plugins/infrastructure/docker/templates/docker-compose.backend.yml ./docker-compose.yml
   ```

   **Frontend only**:
   ```bash
   cp plugins/infrastructure/docker/templates/docker-compose.frontend.yml ./docker-compose.yml
   ```

2. **Customize the compose file**:
   - Update `PROJECT_NAME` if different
   - Adjust volume mount paths to match project structure
   - Update ports if using non-standard values
   - Add additional services (database, Redis, etc.) if needed

3. **Key features configured**:
   - Volume mounts for hot reload
   - Shared network for service communication
   - Health checks for services
   - Restart policies
   - Environment variable support

### Step 6: Create .dockerignore

Create `.dockerignore` to optimize builds:

```bash
cp plugins/infrastructure/docker/templates/.dockerignore ./.dockerignore
```

This excludes:
- Node modules (reinstalled in container)
- Python cache files
- Git files
- IDE settings
- Build artifacts
- Test coverage reports
- Environment files with secrets

### Step 7: Create Environment File Template

Create `.env.example` for environment variable documentation:

```bash
# Copy if doesn't exist
if [ ! -f .env.example ]; then
  cp plugins/infrastructure/docker/templates/.env.example ./.env.example
fi
```

Update with project-specific variables:
- `PROJECT_NAME`: Your project name
- `BACKEND_PORT`: Backend port (default: 8000)
- `FRONTEND_PORT`: Frontend port (default: 5173)
- `BRANCH_NAME`: Git branch (for container naming)

### Step 8: Update Makefile

Add Docker targets to Makefile:

**Option A**: Include the Docker Makefile
```makefile
# At the top of Makefile
-include Makefile.docker
```

Then copy:
```bash
cp plugins/infrastructure/docker/templates/makefile-docker.mk ./Makefile.docker
```

**Option B**: Append targets directly
```bash
cat plugins/infrastructure/docker/templates/makefile-docker.mk >> Makefile
```

**Available targets**:
- `make docker-build`: Build all Docker images
- `make docker-up`: Start development environment
- `make docker-down`: Stop all containers
- `make docker-logs`: View container logs
- `make docker-shell-backend`: Shell into backend container
- `make docker-shell-frontend`: Shell into frontend container
- `make docker-clean`: Remove containers and volumes
- `make docker-rebuild`: Clean rebuild of all images

### Step 9: Extend agents.md

Add Docker-specific guidelines to agents.md:

1. Read agents.md
2. Find the `### INFRASTRUCTURE_GUIDELINES` section
3. Insert between `<!-- BEGIN_INFRASTRUCTURE_GUIDELINES -->` and `<!-- END_INFRASTRUCTURE_GUIDELINES -->` markers:

```markdown
#### Docker Containerization
- **Development**: All development should happen in Docker containers for consistency
- **Hot Reload**: Volume mounts enable instant code updates without rebuilds
- **Multi-stage Builds**: Separate stages for dev, lint, test, and production
- **Service Orchestration**: docker-compose manages all services with networking
- **Health Checks**: All services have health checks for reliability

**Build Images**: `make docker-build` (builds all multi-stage targets)
**Start Dev**: `make docker-up` (starts all services with hot reload)
**View Logs**: `make docker-logs` (tail all service logs)
**Execute Commands**: `make docker-shell-backend` or `make docker-shell-frontend`
**Stop Services**: `make docker-down` (graceful shutdown)
**Clean Up**: `make docker-clean` (removes containers and volumes)

**Multi-Stage Targets**:
- `dev`: Development with hot reload and debug tools
- `lint`: Dedicated linting environment with all tools
- `test`: Test execution with coverage support
- `prod`: Minimal production image (~50% smaller)

**Best Practices**:
- Build backend with: `docker build --target dev -t app-backend:dev -f .docker/dockerfiles/Dockerfile.backend .`
- Build frontend with: `docker build --target dev -t app-frontend:dev -f .docker/dockerfiles/Dockerfile.frontend .`
- Use docker-compose for development: `docker compose up`
- Run tests in container: `docker compose run backend-test`
- Check logs: `docker compose logs -f backend-dev`
```

Or copy from template:
```bash
cat plugins/infrastructure/docker/templates/agents-md-extension.txt
# Then insert content into agents.md between markers
```

### Step 10: Add .ai Documentation

Create `.ai/docs/DOCKER_STANDARDS.md`:

```bash
mkdir -p .ai/docs
cp plugins/infrastructure/docker/standards/DOCKER_STANDARDS.md .ai/docs/DOCKER_STANDARDS.md
```

Update `.ai/index.yaml` to reference this documentation:

```yaml
documentation:
  infrastructure:
    - path: docs/DOCKER_STANDARDS.md
      title: Docker Infrastructure Standards
      description: Multi-stage builds, orchestration, and containerization best practices
```

### Step 11: Verify Installation

Run verification commands:

```bash
# 1. Verify Docker is installed
docker --version
docker compose version

# 2. Verify files exist
ls -la .docker/dockerfiles/
ls -la docker-compose.yml
ls -la .dockerignore

# 3. Build Docker images
make docker-build

# 4. Start development environment
make docker-up

# 5. Check services are running
docker compose ps

# 6. View logs
make docker-logs

# 7. Stop services
make docker-down
```

### Step 12: Test Hot Reload

**Backend hot reload test** (if backend present):
1. Start services: `make docker-up`
2. Make a change to backend code
3. Verify auto-reload in logs: `docker compose logs -f backend-dev`
4. Test endpoint still works

**Frontend hot reload test** (if frontend present):
1. Services should still be running
2. Make a change to frontend code
3. Verify HMR update in browser console
4. Verify change appears instantly in browser

## Post-Installation

After successful installation, inform the user:

**Installed Components**:
- ✅ **Multi-stage Dockerfiles**: Optimized builds for dev, lint, test, prod
- ✅ **Docker Compose**: Development orchestration with hot reload
- ✅ **Volume Mounts**: Live code updates without rebuilds
- ✅ **Networking**: Services can communicate via service names
- ✅ **Health Checks**: Automatic service health monitoring
- ✅ **.dockerignore**: Build optimization and security

**Available Make Targets**:
```bash
make docker-build          # Build all Docker images
make docker-up             # Start development environment
make docker-down           # Stop all services
make docker-logs           # View service logs
make docker-shell-backend  # Shell into backend container
make docker-shell-frontend # Shell into frontend container
make docker-clean          # Remove containers and volumes
make docker-rebuild        # Clean rebuild
```

**Next Steps**:
1. Run `make docker-build` to build all images
2. Run `make docker-up` to start development
3. Review `.ai/docs/DOCKER_STANDARDS.md` for best practices
4. Add database/Redis services to docker-compose.yml if needed
5. Configure CI/CD to use Docker for testing and deployment

## Integration with Other Plugins

### With Python Plugin
- Backend Dockerfile uses Python plugin's multi-stage pattern
- Includes Ruff, MyPy, Bandit, pytest in lint/test stages
- Poetry dependency management
- Volume mounts for hot reload with uvicorn

### With TypeScript Plugin
- Frontend Dockerfile uses Node.js for React/Vite
- Includes ESLint, Prettier, Vitest in lint/test stages
- npm dependency management
- HMR (Hot Module Replacement) for instant updates

### With CI/CD Plugin
GitHub Actions can use Docker for CI:

```yaml
# .github/workflows/test.yml
- name: Build and test in Docker
  run: |
    docker compose build
    docker compose run backend-test
    docker compose run frontend-test
```

### Adding Database Service

To add PostgreSQL to docker-compose.yml:

```yaml
services:
  postgres:
    image: postgres:15-alpine
    container_name: ${PROJECT_NAME:-app}-postgres-${BRANCH_NAME:-main}
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
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres-data:
```

### Adding Redis Service

To add Redis for caching/sessions:

```yaml
services:
  redis:
    image: redis:7-alpine
    container_name: ${PROJECT_NAME:-app}-redis-${BRANCH_NAME:-main}
    ports:
      - "${REDIS_PORT:-6379}:6379"
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
```

## Troubleshooting

### Issue: Docker daemon not running
**Solution**: Start Docker Desktop or Docker service:
```bash
# Linux
sudo systemctl start docker

# macOS/Windows
# Start Docker Desktop application
```

### Issue: Port already in use
**Solution**: Change ports in .env or docker-compose.yml:
```bash
# .env
BACKEND_PORT=8001  # Instead of 8000
FRONTEND_PORT=5174 # Instead of 5173
```

### Issue: Container can't see code changes
**Solution**: Verify volume mounts in docker-compose.yml match your project structure

### Issue: Permission denied errors
**Solution**: Dockerfiles create non-root users. Ensure host files are readable:
```bash
# Fix permissions
chmod -R 755 app/
chmod -R 755 frontend/
```

### Issue: Slow builds
**Solution**:
- Check .dockerignore excludes node_modules and __pycache__
- Use BuildKit: `export DOCKER_BUILDKIT=1`
- Layer caching is optimized in multi-stage builds

## Standalone Usage

This plugin works standalone without orchestrator:

1. Copy this plugin directory to your project
2. Follow steps 1-12 above manually
3. Validate with step 11

## Success Criteria

Installation is successful when:
- ✅ Docker and Docker Compose installed
- ✅ Dockerfiles created in `.docker/dockerfiles/`
- ✅ docker-compose.yml created and configured
- ✅ .dockerignore created
- ✅ Makefile targets work
- ✅ `make docker-build` succeeds
- ✅ `make docker-up` starts services
- ✅ Hot reload works for backend and/or frontend
- ✅ Services can communicate via network
- ✅ agents.md updated with Docker guidelines
- ✅ `.ai/docs/DOCKER_STANDARDS.md` exists

---

**Note**: This plugin provides production-ready Docker infrastructure based on multi-stage
build patterns and configurations extracted from the durable-code-test reference implementation.
