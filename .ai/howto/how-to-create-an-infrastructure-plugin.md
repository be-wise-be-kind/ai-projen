# How to Create an Infrastructure Plugin

**Purpose**: Step-by-step guide for creating new infrastructure plugins for ai-projen

**Scope**: Complete workflow from template copying to PR submission for infrastructure tooling (containerization, CI/CD, IaC)

**Overview**: Comprehensive, actionable guide for developers who want to add infrastructure support to ai-projen.
    Covers containerization (Docker, Podman), CI/CD (GitHub Actions, GitLab CI), and Infrastructure-as-Code
    (Terraform, Pulumi, CloudFormation). Uses Docker, GitHub Actions, and Terraform/AWS as reference implementations.

**Dependencies**: foundation/ai-folder plugin, PLUGIN_MANIFEST.yaml, language plugins (optional integration)

**Exports**: Knowledge for creating Docker, Kubernetes, GitHub Actions, GitLab CI, Terraform, Pulumi, or any infrastructure plugin

**Related**: PLUGIN_ARCHITECTURE.md for structure requirements, _template/ for boilerplate, how-to-create-a-language-plugin.md

**Implementation**: Template-based plugin creation with infrastructure-specific patterns

---

## Overview

### What is an Infrastructure Plugin?

An infrastructure plugin provides infrastructure-as-code and deployment tooling including:
- **Containerization** - Container orchestration (Docker, Podman, Kubernetes)
- **CI/CD** - Continuous Integration and Deployment (GitHub Actions, GitLab CI, Jenkins, CircleCI)
- **Infrastructure-as-Code** - Cloud resource provisioning (Terraform, Pulumi, CloudFormation, CDK)
- **Monitoring** - Observability and metrics (Prometheus, Grafana, DataDog)
- **Secrets Management** - Secret handling (Vault, AWS Secrets Manager, Doppler)

### Why Create an Infrastructure Plugin?

Infrastructure plugins enable:
- **Reproducible Environments** - Infrastructure defined as code
- **Multi-Environment Support** - Dev, staging, production configurations
- **Integration with Language Plugins** - Builds on language runtimes
- **AI Agent Compatibility** - Clear deployment instructions
- **Standalone Functionality** - Works without orchestrator
- **Battle-Tested Configurations** - Production-ready infrastructure patterns

### Architecture Philosophy

Each infrastructure plugin must:
1. **Work Standalone** - Install and function without orchestrator
2. **Compose with Language Plugins** - Detect and integrate with Python, TypeScript, etc.
3. **Support Multiple Environments** - Dev, test, staging, production
4. **Document Clearly** - Provide AGENT_INSTRUCTIONS.md for AI agents
5. **Follow Conventions** - Use consistent naming and structure patterns
6. **Be Idempotent** - Repeated application produces same result
7. **Handle State** - Manage infrastructure state properly (especially IaC)

---

## Infrastructure Plugin Categories

### 1. Containerization Plugins

**Location**: `plugins/infrastructure/containerization/<tool>/`

**Purpose**: Package applications in portable containers

**Examples**:
- **Docker** - Industry standard containerization
- **Podman** - Daemonless container engine
- **Kubernetes** - Container orchestration

**Key Components**:
- Container image definitions (Dockerfile, Containerfile)
- Orchestration configs (docker-compose.yml, k8s manifests)
- Multi-stage builds (dev, lint, test, prod)
- Network and volume configuration
- Health checks and logging

### 2. CI/CD Plugins

**Location**: `plugins/infrastructure/ci-cd/<tool>/`

**Purpose**: Automate building, testing, and deployment

**Examples**:
- **GitHub Actions** - GitHub-native CI/CD
- **GitLab CI** - GitLab-native pipelines
- **Jenkins** - Self-hosted automation server
- **CircleCI** - Cloud-based CI/CD

**Key Components**:
- Workflow definitions (.github/workflows/, .gitlab-ci.yml)
- Job configurations (lint, test, build, deploy)
- Matrix strategies (multiple versions, platforms)
- Secrets management
- Artifact publishing

### 3. Infrastructure-as-Code (IaC) Plugins

**Location**: `plugins/infrastructure/iac/<tool>/providers/<provider>/`

**Purpose**: Provision and manage cloud infrastructure

**Examples**:
- **Terraform/AWS** - AWS infrastructure with Terraform
- **Terraform/GCP** - GCP infrastructure with Terraform
- **Pulumi** - Infrastructure with programming languages
- **CloudFormation** - AWS-native IaC

**Key Components**:
- Resource definitions (main.tf, stacks)
- Variable configurations
- State management (backends)
- Workspace patterns
- Module organization

### 4. Monitoring Plugins

**Location**: `plugins/infrastructure/monitoring/<tool>/`

**Purpose**: Observability, metrics, and alerting

**Examples**:
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **DataDog** - Full-stack monitoring
- **New Relic** - Application performance monitoring

---

## Prerequisites

Before creating an infrastructure plugin, ensure you have:

### Technical Requirements
- ✅ **Git repository** - ai-projen cloned locally
- ✅ **Infrastructure tool installed** - Docker, Terraform, etc. for testing
- ✅ **Cloud provider access** - (for IaC) AWS, GCP, Azure account for testing
- ✅ **CI/CD platform access** - GitHub, GitLab, etc. for testing workflows

### Knowledge Requirements
- ✅ **Tool expertise** - Deep understanding of the infrastructure tool
- ✅ **Best practices** - Industry-standard patterns and configurations
- ✅ **Security awareness** - Secrets handling, least privilege, state security
- ✅ **Multi-environment patterns** - Dev, staging, production separation

### Framework Familiarity
- ✅ Read `PLUGIN_ARCHITECTURE.md` - Understand plugin structure
- ✅ Read `PLUGIN_MANIFEST.yaml` - See existing plugin definitions
- ✅ Review `plugins/infrastructure/<category>/_template/` - Understand template structure
- ✅ Check existing infrastructure plugins - See reference implementations

---

## Step-by-Step Guide

### Step 1: Choose Your Plugin Category

Determine which infrastructure category your plugin belongs to:

```bash
# Containerization (Docker, Podman, Kubernetes)
cd plugins/infrastructure/containerization/

# CI/CD (GitHub Actions, GitLab CI, Jenkins)
cd plugins/infrastructure/ci-cd/

# IaC (Terraform, Pulumi, CloudFormation)
cd plugins/infrastructure/iac/

# Monitoring (Prometheus, Grafana, DataDog)
cd plugins/infrastructure/monitoring/
```

### Step 2: Copy the Appropriate Template

```bash
cd /home/stevejackson/Projects/ai-projen

# For containerization tools
cp -r plugins/infrastructure/containerization/_template/ plugins/infrastructure/containerization/<tool-name>/

# For CI/CD tools
cp -r plugins/infrastructure/ci-cd/_template/ plugins/infrastructure/ci-cd/<tool-name>/

# For IaC tools (note: includes provider subdirectory)
cp -r plugins/infrastructure/iac/_template/ plugins/infrastructure/iac/<tool-name>/
# Then create provider-specific subdirectories
mkdir -p plugins/infrastructure/iac/<tool-name>/providers/<provider-name>/

# Example: Terraform with Azure
cp -r plugins/infrastructure/iac/_template/ plugins/infrastructure/iac/terraform/
mkdir -p plugins/infrastructure/iac/terraform/providers/azure/
```

**Naming Convention**:
- Use lowercase tool name: `docker`, `github-actions`, `terraform`
- Use hyphens for multi-word names: `gitlab-ci`, `circle-ci`
- For IaC, add provider subdirectory: `terraform/providers/aws/`

### Step 3: Understand Infrastructure-Specific Concerns

Infrastructure plugins have unique considerations:

#### Composability with Language Plugins

Infrastructure plugins should detect and integrate with language plugins:

```markdown
## Language Detection

Check which language plugins are installed:

1. **Python detected** (pyproject.toml exists):
   - Use Python base image (python:3.11-slim)
   - Copy pyproject.toml and poetry.lock
   - Run `poetry install`

2. **TypeScript detected** (package.json exists):
   - Use Node base image (node:20-alpine)
   - Copy package.json and package-lock.json
   - Run `npm ci`

3. **Multiple languages** (full-stack):
   - Create separate containers for frontend/backend
   - Configure networking between services
```

#### Environment Variable Management

```markdown
## Environment Configuration

Create environment-specific configuration:

**Development** (.env.dev):
```
DEBUG=true
LOG_LEVEL=debug
DATABASE_URL=postgresql://localhost:5432/dev_db
```

**Staging** (.env.staging):
```
DEBUG=false
LOG_LEVEL=info
DATABASE_URL=${DATABASE_URL}  # From secrets manager
```

**Production** (.env.prod):
```
DEBUG=false
LOG_LEVEL=warn
DATABASE_URL=${DATABASE_URL}  # From secrets manager
ENABLE_MONITORING=true
```
```

#### Secrets Handling

```markdown
## Secrets Management

NEVER commit secrets to version control:

1. **Local Development**: Use .env files (gitignored)
2. **CI/CD**: Use platform secrets (GitHub Secrets, GitLab Variables)
3. **Production**: Use secrets manager (AWS Secrets Manager, Vault)

**Example .gitignore additions**:
```
.env
.env.local
.env.*.local
terraform.tfstate
terraform.tfstate.backup
.terraform/
```
```

#### State Management (for IaC)

```markdown
## State Management

Infrastructure state must be managed carefully:

**Backend Configuration** (Terraform example):
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

**State Locking**:
- Use remote state with locking (S3 + DynamoDB, Terraform Cloud)
- Never commit state files
- Document state location in README
```

#### Idempotency

```markdown
## Idempotency

Infrastructure operations must be repeatable:

**Docker**:
- Use multi-stage builds for caching
- Pin base image versions: `FROM python:3.11.6-slim`
- Use .dockerignore to exclude unnecessary files

**CI/CD**:
- Use cache actions for dependencies
- Make jobs idempotent (can rerun safely)

**IaC**:
- Use proper resource lifecycle (create_before_destroy)
- Implement proper depends_on chains
- Use data sources for existing resources
```

---

## Plugin Structure Examples

### Containerization Plugin Structure (Docker)

```
plugins/infrastructure/containerization/docker/
├── AGENT_INSTRUCTIONS.md          # Installation instructions
├── README.md                       # Human-readable documentation
├── howtos/                         # Task-specific guides
│   ├── README.md
│   ├── how-to-add-a-service.md
│   ├── how-to-create-multi-stage-dockerfile.md
│   └── how-to-add-volume.md
├── templates/                      # Infrastructure templates
│   ├── Dockerfile.python          # Python container template
│   ├── Dockerfile.typescript      # TypeScript container template
│   ├── docker-compose.dev.yml     # Development orchestration
│   ├── docker-compose.prod.yml    # Production orchestration
│   ├── .dockerignore              # Ignore patterns
│   ├── makefile-docker.mk         # Make targets
│   └── agents-md-snippet.md       # agents.md extension
└── standards/                      # Best practices docs
    └── docker-standards.md
```

### CI/CD Plugin Structure (GitHub Actions)

```
plugins/infrastructure/ci-cd/github-actions/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── howtos/
│   ├── README.md
│   ├── how-to-add-workflow.md
│   ├── how-to-setup-deploy.md
│   └── how-to-use-secrets.md
├── templates/
│   ├── workflows/
│   │   ├── lint.yml               # Linting workflow
│   │   ├── test.yml               # Testing workflow
│   │   ├── build.yml              # Build workflow
│   │   └── deploy.yml             # Deployment workflow
│   ├── makefile-ci.mk
│   └── agents-md-snippet.md
└── standards/
    └── CICD_STANDARDS.md
```

### IaC Plugin Structure (Terraform/AWS)

```
plugins/infrastructure/iac/terraform/providers/aws/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── howtos/
│   ├── README.md
│   ├── how-to-add-workspace.md
│   ├── how-to-deploy-infrastructure.md
│   └── how-to-manage-state.md
├── templates/
│   ├── workspaces/                # Terraform workspaces
│   │   ├── base/                  # VPC, networking
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── README.md
│   │   └── runtime/               # ECS, ALB, services
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── README.md
│   ├── backend-config/            # State backend configs
│   │   ├── base-dev.hcl
│   │   ├── base-prod.hcl
│   │   ├── runtime-dev.hcl
│   │   └── runtime-prod.hcl
│   ├── shared/                    # Shared modules
│   │   └── variables.tf
│   ├── makefile-terraform.mk
│   └── agents-md-snippet.md
└── standards/
    └── TERRAFORM_AWS_STANDARDS.md
```

---

## Detailed Examples

### Example 1: Containerization Plugin (Docker)

#### AGENT_INSTRUCTIONS.md

```markdown
# Docker Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install Docker containerization support

**Scope**: Docker-based development, linting, testing, and production environments

**Overview**: Step-by-step instructions for adding Docker support to a project, including
    multi-stage Dockerfiles, docker-compose orchestration, and integration with language plugins.

**Dependencies**: foundation/ai-folder plugin, Docker installed

---

## Prerequisites

- ✅ Git repository initialized
- ✅ foundation/ai-folder plugin installed
- ✅ Docker and Docker Compose installed
- ✅ At least one language plugin installed (Python, TypeScript, etc.)

## Installation Steps

### Step 1: Detect Language Plugins

Check which language plugins are installed:

```bash
# Python detected
if [ -f pyproject.toml ] || [ -f requirements.txt ]; then
    LANG_PYTHON=true
fi

# TypeScript detected
if [ -f package.json ]; then
    LANG_TYPESCRIPT=true
fi
```

### Step 2: Create Dockerfiles

Copy appropriate Dockerfile templates:

**For Python projects**:
```bash
cp plugins/infrastructure/containerization/docker/templates/Dockerfile.python ./Dockerfile
```

**For TypeScript projects**:
```bash
cp plugins/infrastructure/containerization/docker/templates/Dockerfile.typescript ./Dockerfile
```

**For full-stack projects** (Python backend + TypeScript frontend):
```bash
mkdir -p .docker/dockerfiles
cp plugins/infrastructure/containerization/docker/templates/Dockerfile.python .docker/dockerfiles/backend.Dockerfile
cp plugins/infrastructure/containerization/docker/templates/Dockerfile.typescript .docker/dockerfiles/frontend.Dockerfile
```

### Step 3: Create docker-compose Configuration

**Single service**:
```bash
cp plugins/infrastructure/containerization/docker/templates/docker-compose.dev.yml ./docker-compose.yml
```

**Multi-service** (full-stack):
```bash
cp plugins/infrastructure/containerization/docker/templates/docker-compose.dev.yml ./docker-compose.dev.yml
cp plugins/infrastructure/containerization/docker/templates/docker-compose.prod.yml ./docker-compose.prod.yml
```

### Step 4: Create .dockerignore

```bash
cp plugins/infrastructure/containerization/docker/templates/.dockerignore ./.dockerignore
```

### Step 5: Add Makefile Targets

Append Docker targets to Makefile:

```bash
cat plugins/infrastructure/containerization/docker/templates/makefile-docker.mk >> Makefile
```

### Step 6: Extend agents.md

Add Docker commands section to agents.md between `### INFRASTRUCTURE_COMMANDS` markers.

### Step 7: Validate Installation

```bash
# Build containers
make docker-build

# Start services
make docker-up

# Verify running
docker compose ps

# View logs
make docker-logs

# Stop services
make docker-down
```

## Success Criteria

- ✅ Dockerfile(s) created with multi-stage builds
- ✅ docker-compose.yml configured for all services
- ✅ .dockerignore prevents unnecessary file copying
- ✅ Makefile has docker-build, docker-up, docker-down, docker-logs targets
- ✅ agents.md updated with Docker commands
- ✅ Containers build successfully
- ✅ Services start and communicate properly
```

#### Template: Dockerfile.python

```dockerfile
# Multi-stage Dockerfile for Python applications
# Optimized for ai-projen Docker-first development philosophy

# =============================================================================
# Base Stage - Shared dependencies
# =============================================================================
FROM python:3.11-slim AS base

WORKDIR /app

# Install Poetry
RUN pip install --no-cache-dir poetry==1.7.1

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Install only production dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --only main --no-interaction --no-ansi

# =============================================================================
# Development Stage - Hot reload, dev dependencies
# =============================================================================
FROM base AS dev

# Install all dependencies including dev
RUN poetry install --no-interaction --no-ansi

# Copy application code
COPY . .

# Expose development port
EXPOSE 8000

# Development server with hot reload
CMD ["poetry", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# =============================================================================
# Lint Stage - All linting tools
# =============================================================================
FROM base AS lint

# Install dev dependencies for linting
RUN poetry install --no-interaction --no-ansi

# Install additional linting tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    shellcheck \
    && rm -rf /var/lib/apt/lists/*

# Keep container running for make targets
CMD ["tail", "-f", "/dev/null"]

# =============================================================================
# Test Stage - Testing environment
# =============================================================================
FROM base AS test

# Install all dependencies
RUN poetry install --no-interaction --no-ansi

# Copy application code
COPY . .

# Run tests
CMD ["poetry", "run", "pytest", "--cov=app", "--cov-report=term-missing"]

# =============================================================================
# Production Stage - Minimal runtime
# =============================================================================
FROM python:3.11-slim AS prod

WORKDIR /app

# Install only Poetry for dependency management
RUN pip install --no-cache-dir poetry==1.7.1

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Install production dependencies only
RUN poetry config virtualenvs.create false \
    && poetry install --only main --no-interaction --no-ansi --no-root

# Copy only application code
COPY app ./app

# Create non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose production port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')"

# Production server
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

#### Template: docker-compose.dev.yml

```yaml
# Docker Compose configuration for development
# Full-stack application with hot reload

version: '3.8'

services:
  # Backend service (Python/FastAPI)
  backend-dev:
    build:
      context: .
      dockerfile: Dockerfile
      target: dev
    container_name: ${PROJECT_NAME:-myapp}-backend-dev
    ports:
      - "${BACKEND_PORT:-8000}:8000"
    volumes:
      - ./app:/app/app  # Hot reload for application code
      - ./tests:/app/tests
    environment:
      - DEBUG=true
      - LOG_LEVEL=debug
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/${DB_NAME:-myapp}
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis
    networks:
      - app-network
    restart: unless-stopped

  # Frontend service (TypeScript/React)
  frontend-dev:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      target: dev
    container_name: ${PROJECT_NAME:-myapp}-frontend-dev
    ports:
      - "${FRONTEND_PORT:-3000}:3000"
    volumes:
      - ./frontend/src:/app/src  # Hot reload for source code
      - ./frontend/public:/app/public
    environment:
      - NODE_ENV=development
      - VITE_API_URL=http://localhost:${BACKEND_PORT:-8000}
    networks:
      - app-network
    restart: unless-stopped

  # PostgreSQL database
  db:
    image: postgres:15-alpine
    container_name: ${PROJECT_NAME:-myapp}-db
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=${DB_NAME:-myapp}
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis cache
  redis:
    image: redis:7-alpine
    container_name: ${PROJECT_NAME:-myapp}-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  # Linting service (long-running for make targets)
  linter:
    build:
      context: .
      dockerfile: Dockerfile
      target: lint
    container_name: ${PROJECT_NAME:-myapp}-linter
    volumes:
      - .:/workspace
    working_dir: /workspace
    networks:
      - app-network
    profiles:
      - lint

networks:
  app-network:
    driver: bridge

volumes:
  db-data:
  redis-data:
```

#### Template: makefile-docker.mk

```makefile
# Docker Development Targets
# Include in main Makefile or use directly

.PHONY: docker-build docker-up docker-down docker-logs docker-clean docker-rebuild
.PHONY: docker-shell docker-exec docker-ps docker-lint

# Build all containers
docker-build:
	@echo "Building Docker containers..."
	@docker compose build

# Start all services
docker-up:
	@echo "Starting Docker services..."
	@docker compose up -d
	@echo "✓ Services started. Run 'make docker-logs' to view logs."

# Stop all services
docker-down:
	@echo "Stopping Docker services..."
	@docker compose down

# View logs
docker-logs:
	@docker compose logs -f

# View logs for specific service
docker-logs-%:
	@docker compose logs -f $*

# Clean up containers, volumes, and images
docker-clean:
	@echo "Cleaning Docker resources..."
	@docker compose down -v --remove-orphans
	@docker system prune -f

# Rebuild containers from scratch
docker-rebuild: docker-clean docker-build

# Shell into backend container
docker-shell:
	@docker compose exec backend-dev /bin/bash

# Shell into specific service
docker-shell-%:
	@docker compose exec $* /bin/bash

# Execute command in backend container
docker-exec:
	@docker compose exec backend-dev $(CMD)

# Show running containers
docker-ps:
	@docker compose ps

# Run linting in dedicated container
docker-lint:
	@docker compose --profile lint up -d linter
	@docker compose exec linter make lint-all
	@docker compose --profile lint down

# Run tests in container
docker-test:
	@docker compose run --rm backend-dev poetry run pytest

# Database migrations
docker-migrate:
	@docker compose exec backend-dev poetry run alembic upgrade head

# Create database migration
docker-migration:
	@docker compose exec backend-dev poetry run alembic revision --autogenerate -m "$(MSG)"

# Access database CLI
docker-db:
	@docker compose exec db psql -U postgres -d myapp

# Monitor resource usage
docker-stats:
	@docker stats $(shell docker compose ps -q)
```

---

### Example 2: CI/CD Plugin (GitHub Actions)

#### Template: workflows/lint.yml

```yaml
name: Lint

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint-python:
    if: hashFiles('pyproject.toml') != ''
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install Poetry
        run: |
          curl -sSL https://install.python-poetry.org | python3 -
          echo "$HOME/.local/bin" >> $GITHUB_PATH

      - name: Cache Poetry dependencies
        uses: actions/cache@v3
        with:
          path: ~/.cache/pypoetry
          key: ${{ runner.os }}-poetry-${{ hashFiles('**/poetry.lock') }}

      - name: Install dependencies
        run: poetry install

      - name: Lint with Ruff
        run: poetry run ruff check .

      - name: Check formatting with Black
        run: poetry run black --check .

      - name: Type check with mypy
        run: poetry run mypy .

  lint-typescript:
    if: hashFiles('package.json') != ''
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint with ESLint
        run: npm run lint

      - name: Check formatting with Prettier
        run: npm run format:check

  lint-docker:
    if: hashFiles('Dockerfile') != ''
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Lint Dockerfile with Hadolint
        uses: hadolint/hadolint-action@v3.1.0
        with:
          dockerfile: Dockerfile

  lint-terraform:
    if: hashFiles('**/*.tf') != ''
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Format Check
        run: terraform fmt -check -recursive

      - name: Terraform Validate
        run: |
          cd infra/terraform/workspaces/base
          terraform init -backend=false
          terraform validate
```

---

### Example 3: IaC Plugin (Terraform/AWS)

#### Template: workspaces/base/main.tf

```hcl
# Base Infrastructure Workspace
# VPC, Subnets, Security Groups, IAM Roles

terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration loaded from backend-config/*.hcl
  # Usage: terraform init -backend-config=../../backend-config/base-dev.hcl
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Workspace   = "base"
    }
  }
}

# =============================================================================
# VPC and Networking
# =============================================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = var.environment == "dev" ? true : false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# =============================================================================
# Security Groups
# =============================================================================

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-${var.environment}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow traffic from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-tasks-sg"
  }
}

# =============================================================================
# IAM Roles
# =============================================================================

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-${var.environment}-ecs-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
```

#### Template: workspaces/base/variables.tf

```hcl
# Base Workspace Variables

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
```

#### Template: backend-config/base-dev.hcl

```hcl
# Backend configuration for base workspace - dev environment
# Usage: terraform init -backend-config=../../backend-config/base-dev.hcl

bucket         = "myproject-terraform-state"
key            = "dev/base/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "myproject-terraform-locks"
```

---

## Integration Points

### 1. Makefile Integration

Infrastructure plugins provide Make targets:

**Containerization Pattern**:
```makefile
.PHONY: docker-build docker-up docker-down docker-logs

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down

docker-logs:
	docker compose logs -f
```

**CI/CD Pattern**:
```makefile
.PHONY: ci-lint ci-test ci-build ci-deploy

ci-lint:
	gh workflow run lint.yml

ci-test:
	gh workflow run test.yml

ci-build:
	gh workflow run build.yml
```

**IaC Pattern**:
```makefile
.PHONY: infra-init infra-plan infra-apply infra-destroy

infra-init:
	cd infra/terraform/workspaces/base && \
	terraform init -backend-config=../../backend-config/base-$(ENV).hcl

infra-plan:
	cd infra/terraform/workspaces/base && \
	terraform plan -var-file=../../shared/$(ENV).tfvars

infra-apply:
	cd infra/terraform/workspaces/base && \
	terraform apply -var-file=../../shared/$(ENV).tfvars
```

### 2. agents.md Extension

Add infrastructure commands section:

```markdown
### Infrastructure Commands

#### Docker

**Build and start services**:
```bash
make docker-up
```

**View logs**:
```bash
make docker-logs
```

**Stop services**:
```bash
make docker-down
```

#### Terraform/AWS

**Initialize infrastructure**:
```bash
ENV=dev make infra-init
```

**Preview changes**:
```bash
ENV=dev make infra-plan
```

**Apply infrastructure**:
```bash
ENV=dev make infra-apply
```
```

### 3. Language Plugin Integration

Infrastructure plugins should detect and integrate with language plugins:

**Example: Docker detecting Python**:
```dockerfile
# Detect pyproject.toml -> Use Poetry
FROM python:3.11-slim AS base
RUN pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry install --only main
```

**Example: GitHub Actions detecting TypeScript**:
```yaml
jobs:
  lint:
    steps:
      - name: Check for TypeScript
        id: check-ts
        run: |
          if [ -f "package.json" ]; then
            echo "typescript=true" >> $GITHUB_OUTPUT
          fi

      - name: Lint TypeScript
        if: steps.check-ts.outputs.typescript == 'true'
        run: npm run lint
```

### 4. Environment-Specific Configuration

Support multiple environments:

**Docker**: Use docker-compose.dev.yml, docker-compose.prod.yml

**CI/CD**: Use environment-specific secrets and variables

**IaC**: Use workspace pattern and environment-specific tfvars

---

## Best Practices

### Do's

✅ **Support multiple environments** - Dev, staging, production configurations

✅ **Be idempotent** - Repeated application produces same result

✅ **Document state management** - Explain where state is stored (for IaC)

✅ **Handle secrets properly** - Never commit secrets, use environment variables

✅ **Integrate with language plugins** - Detect and adapt to project languages

✅ **Provide health checks** - Include container health checks, infrastructure validation

✅ **Use consistent naming** - Follow target naming patterns (docker-*, ci-*, infra-*)

✅ **Include how-tos** - Provide task-specific guides for common operations

✅ **Pin versions** - Lock infrastructure tool versions for reproducibility

✅ **Support graceful degradation** - Provide fallbacks for missing tools

### Don'ts

❌ **Don't commit secrets** - Never put credentials in version control

❌ **Don't assume tool availability** - Check for Docker, Terraform, etc. before use

❌ **Don't hardcode values** - Use variables for all environment-specific settings

❌ **Don't skip state management** - Always configure remote state for IaC

❌ **Don't ignore networking** - Document how services communicate

❌ **Don't forget cleanup** - Provide targets to destroy/clean infrastructure

❌ **Don't use latest tags** - Pin specific versions (python:3.11.6, not python:latest)

❌ **Don't skip health checks** - Always include readiness/liveness checks

❌ **Don't overcomplicate** - Start simple, add complexity as needed

❌ **Don't break composability** - Ensure plugin works with other infrastructure plugins

---

## Testing Your Plugin

### Standalone Testing

```bash
# 1. Create test directory
mkdir -p /tmp/test-<plugin>
cd /tmp/test-<plugin>

# 2. Initialize git
git init

# 3. Install foundation plugin
# (Copy .ai/ structure, create AGENTS.md)

# 4. Install a language plugin (Python or TypeScript)
# Follow language plugin AGENT_INSTRUCTIONS.md

# 5. Install your infrastructure plugin
# Follow your AGENT_INSTRUCTIONS.md step-by-step

# 6. Verify files created
ls -la  # Check infrastructure files present

# 7. Test infrastructure commands
make docker-build  # For containerization
make ci-lint       # For CI/CD
make infra-plan    # For IaC

# 8. Verify integration
grep "<Your Tool>" AGENTS.md  # Should show infrastructure section
```

### Integration Testing

```bash
# Test with multiple plugins
1. Install Python plugin
2. Install Docker plugin
3. Verify Dockerfile includes Python
4. Build and run container
5. Test application works in container

# Test multi-environment
1. Configure dev environment
2. Configure prod environment
3. Verify differences (debug flags, resources, etc.)
4. Test deployment to each environment
```

### State and Cleanup Testing

For IaC plugins:

```bash
# Test state management
1. Initialize with backend
2. Create infrastructure
3. Verify state stored remotely
4. Modify infrastructure
5. Verify state updates
6. Destroy infrastructure
7. Verify state shows no resources
```

---

## Real Examples to Reference

### Docker Plugin (PR9)

**Status**: To be implemented

**Location**: `plugins/infrastructure/containerization/docker/`

**Key Features**:
- Multi-stage Dockerfiles (dev, lint, test, prod)
- docker-compose for multi-service orchestration
- Integration with Python and TypeScript
- Volume mounts for hot reload
- Health checks and logging

### GitHub Actions Plugin (PR10)

**Status**: To be implemented

**Location**: `plugins/infrastructure/ci-cd/github-actions/`

**Key Features**:
- Complete CI/CD pipeline (lint, test, build, deploy)
- Matrix strategies for multiple versions
- Integration with Docker for builds
- Secrets management patterns
- Artifact publishing

### Terraform/AWS Plugin (PR11)

**Status**: To be implemented

**Location**: `plugins/infrastructure/iac/terraform/providers/aws/`

**Key Features**:
- Workspace pattern (base, runtime)
- Remote state with S3 + DynamoDB
- Multi-environment support (dev, staging, prod)
- VPC/networking in base workspace
- ECS/ALB in runtime workspace

---

## Common Patterns

### Pattern 1: Multi-Environment Configuration

All infrastructure plugins should support multiple environments:

```markdown
## Environment Structure

**Development**:
- Debug enabled
- Hot reload
- Local databases
- Verbose logging

**Staging**:
- Production-like setup
- Integration testing
- Managed services
- Standard logging

**Production**:
- Optimized for performance
- Auto-scaling
- Managed services
- Error-level logging
```

### Pattern 2: State Management (IaC)

```markdown
## State Backend

**Local State** (development only):
```hcl
# No backend configuration
terraform {
  # State stored in terraform.tfstate locally
}
```

**Remote State** (staging, production):
```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```
```

### Pattern 3: Secrets Management

```markdown
## Secrets Handling

**Development**: .env files (gitignored)

**CI/CD**: Platform secrets
- GitHub: Repository Secrets
- GitLab: CI/CD Variables
- CircleCI: Project Environment Variables

**Production**: Secrets Manager
- AWS: AWS Secrets Manager
- GCP: Secret Manager
- Azure: Key Vault
```

### Pattern 4: Health Checks

```markdown
## Health Checks

**Docker**:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD curl -f http://localhost:8000/health || exit 1
```

**Kubernetes**:
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8000
  initialDelaySeconds: 30
  periodSeconds: 10
```

**Terraform (ALB)**:
```hcl
health_check {
  path                = "/health"
  healthy_threshold   = 2
  unhealthy_threshold = 10
  timeout             = 5
  interval            = 30
}
```
```

---

## Troubleshooting

### Issue: Container won't start

**Symptom**: `docker compose up` fails or container exits immediately

**Solution**:
1. Check logs: `docker compose logs <service>`
2. Verify Dockerfile syntax
3. Check for missing dependencies
4. Ensure CMD/ENTRYPOINT is correct
5. Test build stage: `docker build --target dev .`

### Issue: Services can't communicate

**Symptom**: Frontend can't reach backend API

**Solution**:
1. Verify services on same network in docker-compose.yml
2. Use service names for internal communication (not localhost)
3. Check port mappings
4. Verify firewall/security group rules (cloud)

### Issue: Terraform state locked

**Symptom**: `Error acquiring the state lock`

**Solution**:
```bash
# Check lock in DynamoDB
aws dynamodb get-item \
  --table-name terraform-locks \
  --key '{"LockID": {"S": "bucket/key"}}'

# Force unlock (use with caution!)
terraform force-unlock <lock-id>
```

### Issue: CI/CD workflow not triggering

**Symptom**: Push doesn't trigger GitHub Actions

**Solution**:
1. Check workflow `on:` configuration
2. Verify branch name matches trigger
3. Check workflow file syntax (use GitHub Actions validator)
4. Ensure workflows enabled in repository settings

### Issue: Secrets not loading

**Symptom**: Application can't access environment variables

**Solution**:
1. Verify secrets configured in platform
2. Check environment variable names match
3. Ensure secrets passed to container/workflow
4. Check for typos in variable names

---

## Submitting Your Plugin

### Step 1: Create Feature Branch

```bash
git checkout -b feat/add-<tool>-infrastructure-plugin
```

### Step 2: Commit Your Changes

```bash
# Add all plugin files
git add plugins/infrastructure/<category>/<tool>/

# Add manifest update
git add plugins/PLUGIN_MANIFEST.yaml

# Commit with descriptive message
git commit -m "feat(infrastructure): Add <Tool> <Category> plugin

- Add <Tool> plugin directory structure
- Include multi-environment configuration
- Add Makefile integration targets
- Add agents.md extension snippet
- Add standards documentation
- Update PLUGIN_MANIFEST.yaml with <tool> entry
- Include how-tos for common tasks

<Category>: <containerization|ci-cd|iac|monitoring>
Follows plugin template structure from plugins/infrastructure/<category>/_template/
"
```

### Step 3: Push and Create PR

```bash
# Push to GitHub
git push -u origin feat/add-<tool>-infrastructure-plugin

# Create PR
gh pr create --title "feat(infrastructure): Add <Tool> plugin" --body "$(cat <<'EOF'
## Summary
Adds <Tool> infrastructure plugin for <category>.

## Changes
- ✅ <Tool> plugin directory structure
- ✅ Multi-environment support (dev, staging, prod)
- ✅ Configuration templates
- ✅ Makefile integration
- ✅ AGENTS.md extension snippet
- ✅ Standards documentation
- ✅ How-to guides
- ✅ PLUGIN_MANIFEST.yaml entry

## Features
**Environments**: dev, staging, production
**Integration**: Python, TypeScript language plugins
**State Management**: Remote backend with locking (IaC)
**Secrets**: Environment-based secrets handling

## Testing
Tested standalone installation in clean directory:
- ✅ All configuration files created correctly
- ✅ Makefile targets work
- ✅ Multi-environment configuration validated
- ✅ Integration with language plugins tested
- ✅ AGENTS.md updated correctly
- ✅ No conflicts with existing plugins

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Next Steps

After creating your infrastructure plugin:

1. **Test in real projects** - Deploy actual applications
2. **Document edge cases** - Capture unusual scenarios
3. **Add advanced features** - Monitoring, auto-scaling, disaster recovery
4. **Create complementary plugins** - Combine containerization + CI/CD + IaC
5. **Share examples** - Provide complete reference implementations
6. **Help others** - Review community plugin PRs

---

## Additional Resources

### Documentation
- `PLUGIN_ARCHITECTURE.md` - Plugin structure requirements
- `PLUGIN_MANIFEST.yaml` - All available plugins
- `DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` - Docker-first development
- `plugins/infrastructure/<category>/_template/` - Boilerplate template

### Reference Implementations
- `plugins/infrastructure/containerization/docker/` - Docker plugin (PR9)
- `plugins/infrastructure/ci-cd/github-actions/` - GitHub Actions plugin (PR10)
- `plugins/infrastructure/iac/terraform/providers/aws/` - Terraform/AWS plugin (PR11)

### External Resources
- Docker: https://docs.docker.com/
- GitHub Actions: https://docs.github.com/en/actions
- Terraform: https://www.terraform.io/docs

---

**Questions?** Open an issue on GitHub or check existing infrastructure plugins for examples.

**Ready to contribute?** Follow this guide to add support for Kubernetes, GitLab CI, Pulumi, or any infrastructure tool!
