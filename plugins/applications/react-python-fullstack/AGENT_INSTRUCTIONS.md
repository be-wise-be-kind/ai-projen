# React + Python Full-Stack Application - Agent Instructions

**Purpose**: Installation instructions for AI agents to set up React + Python full-stack application

**Scope**: Complete installation of full-stack web application with React frontend, FastAPI backend, PostgreSQL database, and Docker orchestration

**Overview**: Step-by-step instructions for installing a production-ready full-stack web application.
    This meta-plugin orchestrates the installation of foundation, Python, TypeScript, Docker, CI/CD,
    infrastructure, and standards plugins, then adds a complete starter application with React frontend,
    FastAPI backend, PostgreSQL database, and comprehensive Docker orchestration for local development
    and production deployment.

**Prerequisites**: Empty or existing repository with git initialized

---

## What This Application Provides

**Use Case**: Production-ready full-stack web applications with modern TypeScript frontend and scalable Python backend

**Technology Stack**:
- **Backend**: Python 3.11+ with FastAPI, SQLAlchemy, Pydantic, Alembic
- **Frontend**: React 18 with TypeScript, Vite, React Router
- **Database**: PostgreSQL 15+ with SQLAlchemy ORM
- **Infrastructure**: Docker, Docker Compose, Nginx (optional reverse proxy)
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Deployment**: AWS ECS + ALB via Terraform

**What Gets Installed**:
- Complete FastAPI backend with health endpoint, CORS, authentication patterns
- Complete React frontend with routing, API client, component structure
- PostgreSQL database with migration support
- Docker Compose orchestration for all services
- Hot reload for both frontend and backend
- Comprehensive test suites for both layers
- CI/CD pipeline for automated testing and deployment
- AWS infrastructure as code with Terraform
- Security scanning and pre-commit hooks
- Complete documentation and how-to guides

## Installation Steps

### Prerequisites Check

Before installation, verify:

```bash
# Check git repository exists
test -d .git && echo "✅ Git repository" || echo "❌ Run: git init"

# Check Python installed
python --version && echo "✅ Python" || echo "❌ Install Python 3.11+"

# Check Node.js installed
node --version && echo "✅ Node.js" || echo "❌ Install Node.js 18+"

# Check Docker running
docker ps > /dev/null 2>&1 && echo "✅ Docker running" || echo "❌ Start Docker"

# Check Docker Compose installed
docker compose version && echo "✅ Docker Compose" || echo "❌ Install Docker Compose"
```

### Phase 1: Foundation Setup

**1. Install foundation/ai-folder plugin**

Follow: `plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md`

Creates `.ai/` directory structure for AI navigation.

**Validation**:
```bash
test -d .ai && echo "✅ .ai folder created" || echo "❌ Foundation plugin failed"
```

### Phase 2: Language Plugin Installation

**2. Install languages/python plugin**

Follow: `plugins/languages/python/core/AGENT_INSTRUCTIONS.md`

Installs Python with FastAPI, SQLAlchemy, pytest, ruff, mypy, bandit.

**Options**:
- Framework: FastAPI
- ORM: SQLAlchemy
- Testing: pytest
- Linter: ruff
- Type checker: mypy
- Security: bandit

**Validation**:
```bash
test -f pyproject.toml && echo "✅ Python configured" || echo "❌ Python plugin failed"
```

**2.5. Verify and Install Comprehensive Python Tooling**

Check that comprehensive tooling is present in backend/pyproject.toml, and add if missing:

```bash
cd backend

# Check if comprehensive tooling is already present
if ! grep -q "pylint" pyproject.toml || ! grep -q "radon" pyproject.toml; then
  echo "Adding comprehensive Python tooling..."
  poetry add --group dev \
    pylint \
    flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify \
    radon xenon \
    safety pip-audit
else
  echo "✅ Comprehensive Python tooling already present"
fi
```

**Validation**:
```bash
cd backend
poetry run pylint --version
poetry run flake8 --version
poetry run radon --version
poetry run xenon --version
poetry run safety --version
poetry run pip-audit --version
```

**3. Install languages/typescript plugin**

Follow: `plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md`

Installs TypeScript with React, Vite, ESLint, Prettier, Vitest.

**Options**:
- Framework: React 18
- Bundler: Vite
- Linter: ESLint
- Formatter: Prettier
- Testing: Vitest
- Type checking: TypeScript strict mode

**Validation**:
```bash
test -f tsconfig.json && echo "✅ TypeScript configured" || echo "❌ TypeScript plugin failed"
```

**3.5. Verify and Install Comprehensive TypeScript Tooling**

Check that comprehensive tooling is present in frontend/package.json, and add if missing:

```bash
cd frontend

# Check if comprehensive tooling is already present
if ! grep -q "@playwright/test" package.json || ! grep -q "eslint-plugin-jsx-a11y" package.json; then
  echo "Adding comprehensive TypeScript tooling..."
  npm install --save-dev \
    @playwright/test \
    @testing-library/react \
    @testing-library/jest-dom \
    @testing-library/user-event \
    eslint-plugin-jsx-a11y \
    eslint-plugin-react-hooks \
    eslint-plugin-import \
    eslint-plugin-complexity \
    vitest @vitest/ui happy-dom \
    @vitest/coverage-v8
else
  echo "✅ Comprehensive TypeScript tooling already present"
fi
```

**Validation**:
```bash
cd frontend
npx playwright --version
npx vitest --version
npm ls eslint-plugin-jsx-a11y
npm ls @testing-library/react
```

### Phase 3: Infrastructure Plugin Installation

**4. Install infrastructure/containerization/docker plugin**

Follow: `plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md`

**Options**:
- Services: [backend, frontend, database]
- Compose: yes
- Multi-stage: yes

Creates Docker containerization for full-stack application.

**Validation**:
```bash
test -f docker-compose.yml && echo "✅ Docker configured" || echo "❌ Docker plugin failed"
```

**5. Install infrastructure/ci-cd/github-actions plugin**

Follow: `plugins/infrastructure/ci-cd/github-actions/AGENT_INSTRUCTIONS.md`

**Options**:
- Workflows: [test, lint, build, deploy]
- Matrix: yes (Python 3.11, 3.12; Node 18, 20)
- Docker: yes

Creates CI/CD pipeline for full-stack application.

**Validation**:
```bash
test -d .github/workflows && echo "✅ CI/CD configured" || echo "❌ CI/CD plugin failed"
```

**6. Install infrastructure/iac/terraform-aws plugin**

Follow: `plugins/infrastructure/iac/terraform-aws/AGENT_INSTRUCTIONS.md`

**Options**:
- Resources: [ECS, ALB, RDS, VPC]
- Application: fullstack
- Database: PostgreSQL

Creates AWS infrastructure as code for deployment.

**Validation**:
```bash
test -d terraform && echo "✅ Terraform configured" || echo "❌ Terraform plugin failed"
```

### Phase 4: Standards Plugin Installation

**7. Install standards/security plugin**

Follow: `plugins/standards/security/AGENT_INSTRUCTIONS.md`

**Options**:
- Scanning: [secrets, dependencies, containers]
- Tools: [gitleaks, trivy, bandit, safety]

**Validation**:
```bash
test -f .gitignore && grep -q "secrets" .gitignore && echo "✅ Security configured" || echo "❌ Security plugin failed"
```

**8. Install standards/documentation plugin**

Follow: `plugins/standards/documentation/AGENT_INSTRUCTIONS.md`

**Options**:
- Headers: yes
- README sections: standard

**Validation**:
```bash
test -f .ai/docs/file-headers.md && echo "✅ Documentation configured" || echo "❌ Documentation plugin failed"
```

**9. Install standards/pre-commit-hooks plugin**

Follow: `plugins/standards/pre-commit-hooks/AGENT_INSTRUCTIONS.md`

**Options**:
- Hooks: [format, lint, secrets, trailing-whitespace, type-check]

**Validation**:
```bash
test -f .pre-commit-config.yaml && echo "✅ Pre-commit configured" || echo "❌ Pre-commit plugin failed"
```

### Phase 5: Application-Specific Installation

**10. Copy Backend Starter Code**

Copy backend application from `plugins/applications/react-python-fullstack/project-content/backend/`:

```bash
# Copy backend configuration with comprehensive tooling
cp plugins/applications/react-python-fullstack/project-content/backend/pyproject.toml.template ./backend/pyproject.toml

# Copy backend source
cp -r plugins/applications/react-python-fullstack/project-content/backend/src ./backend/
cp -r plugins/applications/react-python-fullstack/project-content/backend/tests ./backend/

# Process templates (replace .template extension)
for file in backend/src/**/*.template backend/tests/**/*.template; do
  if [ -f "$file" ]; then
    mv "$file" "${file%.template}"
  fi
done
```

**11. Copy Frontend Starter Code**

Copy frontend application from `plugins/applications/react-python-fullstack/project-content/frontend/`:

```bash
# Copy frontend configuration with comprehensive tooling
cp plugins/applications/react-python-fullstack/project-content/frontend/package.json.template ./frontend/package.json

# Copy frontend source
cp -r plugins/applications/react-python-fullstack/project-content/frontend/src ./frontend/

# Process templates
for file in frontend/src/**/*.template; do
  if [ -f "$file" ]; then
    mv "$file" "${file%.template}"
  fi
done
```

**12. Copy Production Makefile**

Copy production-ready Makefile with comprehensive quality gates:

```bash
cp plugins/applications/react-python-fullstack/project-content/Makefile.template ./Makefile
```

**Validation**:
```bash
make help

# Should show composite targets:
# - lint-backend (fast)
# - lint-backend-all (comprehensive)
# - lint-backend-security
# - lint-backend-complexity
# - lint-backend-full (everything)
# - lint-frontend (fast)
# - lint-frontend-all (comprehensive)
# - lint-frontend-security
# - lint-frontend-full (everything)
# - lint-all (both stacks, comprehensive)
# - lint-full (ALL 15+ tools)
# - test-all (all tests)
```

**13. Copy Docker Orchestration**

```bash
# Copy fullstack docker-compose
cp plugins/applications/react-python-fullstack/project-content/docker-compose.fullstack.yml.template ./docker-compose.fullstack.yml

# Merge with existing docker-compose.yml or replace
# (Agent decision based on existing configuration)
```

**13. Copy Application Documentation**

Copy files from `plugins/applications/react-python-fullstack/ai-content/` to `.ai/`:

```bash
# Copy architecture documentation
cp plugins/applications/react-python-fullstack/ai-content/docs/*.md .ai/docs/

# Copy application-specific how-tos
mkdir -p .ai/howtos/fullstack
cp plugins/applications/react-python-fullstack/ai-content/howtos/*.md .ai/howtos/fullstack/

# Copy application templates
mkdir -p .ai/templates/fullstack
cp plugins/applications/react-python-fullstack/ai-content/templates/*.template .ai/templates/fullstack/
```

**14. Configure Application**

Create environment files:

```bash
# Backend environment
cat > backend/.env << 'EOF'
# Database
DATABASE_URL=postgresql://postgres:postgres@db:5432/app_db

# API
API_HOST=0.0.0.0
API_PORT=8000
API_RELOAD=true

# CORS
CORS_ORIGINS=http://localhost:5173,http://localhost:3000

# Security
SECRET_KEY=change-me-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Logging
LOG_LEVEL=INFO
EOF

# Frontend environment
cat > frontend/.env << 'EOF'
VITE_API_URL=http://localhost:8000
VITE_API_TIMEOUT=30000
EOF
```

**15. Install Dependencies**

```bash
# Install backend dependencies
docker-compose run --rm backend poetry install

# Install frontend dependencies
docker-compose run --rm frontend npm install
```

**16. Update .ai/index.yaml**

Add application entry to `.ai/index.yaml`:

```yaml
application:
  type: web
  stack:
    backend: Python + FastAPI
    frontend: React + TypeScript + Vite
    database: PostgreSQL
    infrastructure: Docker + AWS ECS
  architecture: .ai/docs/fullstack-architecture.md
  integration: .ai/docs/api-frontend-integration.md
  howtos: .ai/howtos/fullstack/
  templates: .ai/templates/fullstack/
```

### Phase 7: Optional Terraform Deployment (Optional)

**IMPORTANT**: This phase is OPTIONAL. Ask the user if they want to deploy to AWS using Terraform.

```bash
echo ""
echo "=========================================="
echo "   Optional: Terraform Deployment Setup  "
echo "=========================================="
echo ""
echo "Would you like to set up AWS deployment infrastructure using Terraform?"
echo ""
echo "This will add:"
echo "  - Terraform workspaces (bootstrap, base) for multi-environment deployment"
echo "  - AWS infrastructure (VPC, ECR, ECS, ALB, RDS)"
echo "  - Makefile.infra for Docker-based Terraform operations"
echo "  - Complete deployment documentation and how-tos"
echo ""
read -p "Deploy to AWS with Terraform? (yes/no): " TERRAFORM_CHOICE

if [ "$TERRAFORM_CHOICE" = "yes" ]; then
  echo "Installing Terraform deployment infrastructure..."
else
  echo "Skipping Terraform deployment. You can add it later if needed."
  echo "Infrastructure setup complete without Terraform."
fi
```

**If user chooses "yes", proceed with Terraform installation:**

**17. Copy Terraform Infrastructure**

Copy Terraform configuration from plugin:

```bash
# Create infrastructure directory
mkdir -p infra/terraform

# Copy all Terraform workspaces
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/workspaces ./infra/terraform/
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/modules ./infra/terraform/
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/shared ./infra/terraform/
cp -r plugins/applications/react-python-fullstack/project-content/infra/terraform/backend-config ./infra/terraform/

# Copy infrastructure Makefile
cp plugins/applications/react-python-fullstack/project-content/infra/Makefile.infra.template ./infra/Makefile.infra
```

**18. Copy Terraform Documentation**

Copy Terraform how-tos and documentation:

```bash
# Copy Terraform how-tos
mkdir -p .ai/howtos/react-python-fullstack
cp plugins/applications/react-python-fullstack/ai-content/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md .ai/howtos/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/howtos/react-python-fullstack/how-to-deploy-to-aws.md .ai/howtos/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/howtos/react-python-fullstack/how-to-setup-terraform-workspaces.md .ai/howtos/react-python-fullstack/

# Copy Terraform documentation
mkdir -p .ai/docs/react-python-fullstack
cp plugins/applications/react-python-fullstack/ai-content/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md .ai/docs/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/docs/react-python-fullstack/DEPLOYMENT_GUIDE.md .ai/docs/react-python-fullstack/
cp plugins/applications/react-python-fullstack/ai-content/docs/react-python-fullstack/INFRASTRUCTURE_PRINCIPLES.md .ai/docs/react-python-fullstack/
```

**19. Update .ai/index.yaml for Terraform**

If Terraform was installed, add Terraform entries to `.ai/index.yaml`:

```yaml
infrastructure:
  terraform:
    location: infra/terraform/
    workspaces:
      - bootstrap (S3 backend, DynamoDB, GitHub OIDC)
      - base (VPC, ECR, ALB, security groups)
    modules:
      - ecs-service (Fargate deployment with auto-scaling)
      - rds (PostgreSQL with backups)
    makefile: infra/Makefile.infra
    howtos:
      - .ai/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md
      - .ai/howtos/react-python-fullstack/how-to-deploy-to-aws.md
      - .ai/howtos/react-python-fullstack/how-to-setup-terraform-workspaces.md
    docs:
      - .ai/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md
      - .ai/docs/react-python-fullstack/DEPLOYMENT_GUIDE.md
      - .ai/docs/react-python-fullstack/INFRASTRUCTURE_PRINCIPLES.md
```

**20. Display Terraform Next Steps**

If Terraform was installed, display next steps:

```bash
if [ "$TERRAFORM_CHOICE" = "yes" ]; then
  echo ""
  echo "✅ Terraform deployment infrastructure installed!"
  echo ""
  echo "📝 Next Steps for AWS Deployment:"
  echo "  1. Configure AWS credentials: aws configure"
  echo "  2. Bootstrap Terraform backend:"
  echo "     cd infra && make -f Makefile.infra infra-bootstrap"
  echo "  3. Initialize dev environment:"
  echo "     make -f Makefile.infra infra-init ENV=dev"
  echo "  4. Plan infrastructure:"
  echo "     make -f Makefile.infra infra-plan ENV=dev"
  echo "  5. Apply infrastructure:"
  echo "     make -f Makefile.infra infra-apply ENV=dev"
  echo ""
  echo "📖 Documentation:"
  echo "  - How to manage Terraform: .ai/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md"
  echo "  - How to deploy to AWS: .ai/howtos/react-python-fullstack/how-to-deploy-to-aws.md"
  echo "  - Architecture guide: .ai/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md"
  echo ""
fi
```

**Validation**:

If Terraform was installed:
```bash
# Verify Terraform files
test -d infra/terraform/workspaces/bootstrap && echo "✅ Bootstrap workspace present" || echo "❌ Missing bootstrap"
test -d infra/terraform/workspaces/base && echo "✅ Base workspace present" || echo "❌ Missing base"
test -d infra/terraform/modules/ecs-service && echo "✅ ECS module present" || echo "❌ Missing ECS module"
test -f infra/Makefile.infra && echo "✅ Infrastructure Makefile present" || echo "❌ Missing Makefile.infra"

# Verify documentation
test -f .ai/howtos/react-python-fullstack/how-to-manage-terraform-infrastructure.md && echo "✅ Terraform how-tos present" || echo "❌ Missing how-tos"
test -f .ai/docs/react-python-fullstack/TERRAFORM_ARCHITECTURE.md && echo "✅ Terraform docs present" || echo "❌ Missing docs"

# Show Terraform help
cd infra && make -f Makefile.infra help
```

If Terraform was skipped:
```bash
echo "✅ Terraform deployment skipped - installation complete without AWS infrastructure"
```

## Post-Installation

### Initial Setup

```bash
# Build containers
docker-compose build

# Start database and run migrations
docker-compose up -d db
docker-compose run backend alembic upgrade head

# Run development environment
docker-compose up

# In another terminal, run tests
docker-compose run backend pytest
docker-compose run frontend npm test

# Run linting
docker-compose run backend ruff check
docker-compose run frontend npm run lint
```

### Validation

Run complete validation:

```bash
# Check all files created
test -d backend/src && echo "✅ Backend source" || echo "❌ Missing backend/src/"
test -d backend/tests && echo "✅ Backend tests" || echo "❌ Missing backend/tests/"
test -d frontend/src && echo "✅ Frontend source" || echo "❌ Missing frontend/src/"
test -f docker-compose.fullstack.yml && echo "✅ Docker compose" || echo "❌ Missing docker-compose.fullstack.yml"
test -d .github/workflows && echo "✅ CI/CD workflows" || echo "❌ Missing .github/workflows/"
test -f .ai/howtos/fullstack/README.md && echo "✅ Application how-tos" || echo "❌ Missing how-tos"

# Check services running
docker-compose ps | grep -q "backend.*Up" && echo "✅ Backend running" || echo "❌ Backend not running"
docker-compose ps | grep -q "frontend.*Up" && echo "✅ Frontend running" || echo "❌ Frontend not running"
docker-compose ps | grep -q "db.*Up" && echo "✅ Database running" || echo "❌ Database not running"

# Check health endpoints
curl -f http://localhost:8000/health && echo "✅ Backend health check" || echo "❌ Backend health check failed"
curl -f http://localhost:5173 && echo "✅ Frontend accessible" || echo "❌ Frontend not accessible"

# Check API documentation
curl -f http://localhost:8000/docs && echo "✅ API docs accessible" || echo "❌ API docs not accessible"
```

## Success Criteria

- [x] All plugin dependencies installed successfully
- [x] Backend FastAPI application running with health endpoint
- [x] Frontend React application running and accessible
- [x] PostgreSQL database running and accepting connections
- [x] Backend and frontend can communicate via API
- [x] Hot reload working for both backend and frontend
- [x] Tests pass for both backend and frontend
- [x] Linting passes for both backend and frontend
- [x] CI/CD pipeline configured with GitHub Actions
- [x] Terraform infrastructure code created
- [x] Application-specific how-tos available in .ai/howtos/fullstack/
- [x] Security standards applied (secrets scanning, dependency checking)
- [x] Documentation standards applied (file headers)
- [x] Pre-commit hooks installed and working

## Next Steps

1. **Read Application How-Tos**: Check `.ai/howtos/fullstack/` for guides
2. **Explore API Documentation**: Visit `http://localhost:8000/docs` for interactive API docs
3. **Customize Backend**: Add database models, API endpoints, business logic
4. **Customize Frontend**: Add pages, components, state management
5. **Add Features**: Follow how-tos to add API endpoints, frontend pages, and integrate them
6. **Deploy**: Follow deployment guide in `.ai/howtos/fullstack/how-to-deploy-fullstack-app.md`

## Common Issues

### Issue: Plugin dependency failed
**Solution**: Install failed plugin manually following its AGENT_INSTRUCTIONS.md

### Issue: Docker containers won't start
**Solution**:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up
```

### Issue: Backend tests failing
**Solution**: Check that PostgreSQL is running and migrations are applied
```bash
docker-compose up -d db
docker-compose run backend alembic upgrade head
docker-compose run backend pytest
```

### Issue: Frontend can't connect to backend
**Solution**: Check CORS configuration in `backend/src/config.py` and `frontend/.env`
```bash
# Verify backend CORS_ORIGINS includes frontend URL
grep CORS_ORIGINS backend/.env

# Verify frontend API URL points to backend
grep VITE_API_URL frontend/.env
```

### Issue: Hot reload not working
**Solution**: Check volume mounts in docker-compose.yml
```bash
docker-compose down
docker-compose up --force-recreate
```

## Application-Specific Notes

- **Backend runs on**: `http://localhost:8000`
- **Frontend runs on**: `http://localhost:5173`
- **API documentation**: `http://localhost:8000/docs`
- **Database port**: `5432` (mapped from container)
- **Backend hot reload**: Uses uvicorn `--reload` flag with volume mount
- **Frontend hot reload**: Uses Vite HMR with volume mount
- **Database persistence**: Uses Docker volume `postgres_data`

---

**Remember**: This is a starter application with production-ready patterns. Customize it for your needs. All underlying plugins can be configured independently.
