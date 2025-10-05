# Production-Ready Fullstack Standards

**Purpose**: Define production-ready standards for fullstack applications including comprehensive tooling, quality gates, and operational excellence

**Scope**: All react-python-fullstack applications created via ai-projen plugin

**Overview**: Comprehensive standards that define what "production-ready" means for fullstack applications.
    Covers all 15+ quality tools (9 backend, 6 frontend), progressive quality workflows, infrastructure requirements,
    security standards, testing requirements, documentation completeness, and operational excellence patterns.
    This document serves as the canonical reference for production-ready fullstack development standards
    and ensures all applications meet industry best practices for security, reliability, and maintainability.

**Dependencies**: React-python-fullstack plugin, Python core plugin, TypeScript core plugin, Docker plugin, CI/CD plugin

**Exports**: Production standards, quality gates, tooling requirements, and operational best practices

**Related**: README.md (what you get), AGENTS.md (AI agent guide), fullstack how-to guides

**Implementation**: Comprehensive tooling suite with progressive quality levels and zero-configuration setup

---

## Overview

This document defines the production-ready standards for fullstack applications. These standards ensure that every application built with the react-python-fullstack plugin meets industry best practices for:

- **Quality**: Comprehensive automated quality checking
- **Security**: Multi-layer security scanning
- **Reliability**: Thorough testing and type safety
- **Maintainability**: Consistent code style and documentation
- **Performance**: Complexity analysis and optimization
- **Operations**: Infrastructure as code and deployment automation

## Core Principles

### 1. Comprehensive > Basic

Production-ready means ALL quality gates, not just the minimum:
- ✅ Install ALL 15+ tools automatically
- ✅ Pre-configure all tools with production settings
- ✅ Provide progressive quality workflows (fast → thorough → comprehensive)
- ❌ Never settle for basic linting only

### 2. Zero Configuration

Production-ready means turnkey experience:
- ✅ Everything pre-configured in templates
- ✅ All tools work out of the box
- ✅ No manual setup required
- ❌ Never require users to configure tools manually

### 3. Progressive Quality

Production-ready means appropriate quality levels for different contexts:
- ✅ Fast feedback during development (~3 seconds)
- ✅ Thorough check before commit (~30 seconds)
- ✅ Comprehensive gate before PR (~2 minutes)
- ❌ Never force slow checks during rapid iteration

### 4. Security First

Production-ready means multi-layer security:
- ✅ CVE scanning (Safety for Python)
- ✅ OSV scanning (pip-audit for Python, npm audit for frontend)
- ✅ Code security analysis (Bandit for Python)
- ✅ Dependency vulnerability scanning
- ❌ Never skip security tools

### 5. Type Safety

Production-ready means static type checking:
- ✅ MyPy strict mode for Python
- ✅ TypeScript strict mode for frontend
- ✅ Type checking in CI/CD pipelines
- ❌ Never allow untyped code in production

## Backend Standards (9 Tools)

### Required Tools

#### 1. Ruff - Fast Linting & Formatting
**Purpose**: Lightning-fast linting and code formatting
**When**: Every development iteration (make lint-backend)
**Configuration**: Pre-configured in pyproject.toml
```toml
[tool.ruff]
line-length = 100
target-version = "py311"
```

#### 2. Pylint - Comprehensive Quality
**Purpose**: Deep code quality analysis and best practice enforcement
**When**: Before commit (make lint-all)
**Configuration**: Pre-configured in pyproject.toml
```toml
[tool.pylint.main]
max-line-length = 100
disable = ["C0111"]  # Covered by flake8-docstrings
```

#### 3. Flake8 - Style Checking
**Purpose**: PEP 8 compliance and style consistency
**When**: Before commit (make lint-all)
**Required Plugins**:
- `flake8-docstrings` - Docstring enforcement
- `flake8-bugbear` - Bug pattern detection
- `flake8-comprehensions` - List/dict/set optimization
- `flake8-simplify` - Code simplification suggestions

**Configuration**: Pre-configured in pyproject.toml
```toml
[tool.flake8]
max-line-length = 100
extend-ignore = ["E203", "W503"]
per-file-ignores = ["__init__.py:F401"]
```

#### 4. MyPy - Type Checking
**Purpose**: Static type checking for Python
**When**: Before commit (make lint-all)
**Configuration**: Strict mode enabled
```toml
[tool.mypy]
strict = true
warn_return_any = true
disallow_untyped_defs = true
```

#### 5. Bandit - Security Scanning
**Purpose**: Security vulnerability detection in Python code
**When**: Before PR (make lint-full)
**Configuration**: Pre-configured with security checks

#### 6. Radon - Complexity Metrics
**Purpose**: Cyclomatic complexity and maintainability index
**When**: Before PR (make lint-full)
**Configuration**: Pre-configured thresholds
```toml
[tool.radon]
cc_min = "B"
mi_min = "B"
```

#### 7. Xenon - Complexity Enforcement
**Purpose**: Enforce complexity thresholds
**When**: Before PR (make lint-full)
**Configuration**: Pre-configured limits
```toml
[tool.xenon]
max-absolute = "B"
max-modules = "B"
max-average = "A"
```

#### 8. Safety - CVE Scanning
**Purpose**: Known vulnerability scanning via CVE database
**When**: Before PR (make lint-full)
**Configuration**: Scans all dependencies

#### 9. pip-audit - OSV Scanning
**Purpose**: Vulnerability scanning via OSV database
**When**: Before PR (make lint-full)
**Configuration**: Scans all dependencies

### Quality Gate Progression

**Fast (Development - ~3 seconds)**:
```bash
make lint-backend  # Ruff only
```

**Thorough (Before Commit - ~30 seconds)**:
```bash
make lint-backend-all  # Ruff + Pylint + Flake8 + MyPy
```

**Comprehensive (Before PR - ~2 minutes)**:
```bash
make lint-backend-full  # All 9 tools
```

## Frontend Standards (6 Tools)

### Required Tools

#### 1. ESLint - Linting
**Purpose**: JavaScript/TypeScript linting
**When**: Every development iteration (make lint-frontend)
**Required Plugins**:
- `eslint-plugin-react-hooks` - React Hooks rules
- `eslint-plugin-jsx-a11y` - Accessibility checking
- `eslint-plugin-import` - Import/export validation

**Configuration**: Pre-configured in package.json
```json
{
  "eslintConfig": {
    "extends": [
      "react-app",
      "plugin:jsx-a11y/recommended"
    ],
    "plugins": ["import", "jsx-a11y", "react-hooks"]
  }
}
```

#### 2. TypeScript - Type Checking
**Purpose**: Static type checking with strict mode
**When**: Before commit (make lint-all)
**Configuration**: Strict mode enabled in tsconfig.json
```json
{
  "compilerOptions": {
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true
  }
}
```

#### 3. Vitest - Unit Testing
**Purpose**: Fast unit testing framework
**When**: Before commit (make test-all)
**Configuration**: Pre-configured with coverage

#### 4. React Testing Library - Component Testing
**Purpose**: Component testing utilities
**When**: Before commit (make test-all)
**Configuration**: Pre-configured with best practices

#### 5. Playwright - E2E Testing
**Purpose**: End-to-end browser testing
**When**: Before PR (make lint-full)
**Configuration**: Pre-configured browsers

#### 6. npm audit - Security Scanning
**Purpose**: Vulnerability scanning for npm packages
**When**: Before PR (make lint-full)
**Configuration**: Moderate level threshold

### Quality Gate Progression

**Fast (Development - ~3 seconds)**:
```bash
make lint-frontend  # ESLint only
```

**Thorough (Before Commit - ~30 seconds)**:
```bash
make lint-frontend-all  # ESLint + TypeScript strict
```

**Comprehensive (Before PR - ~2 minutes)**:
```bash
make lint-frontend-full  # All 6 tools
```

## Combined Quality Workflows

### Development Workflow (Fast Feedback)
```bash
# During rapid iteration
make lint-backend   # ~1-2 seconds
make lint-frontend  # ~1-2 seconds
```

### Commit Workflow (Thorough)
```bash
# Before committing code
make lint-all       # ~30 seconds
# Runs: Ruff + Pylint + Flake8 + MyPy + ESLint + TypeScript
```

### Pull Request Workflow (Comprehensive)
```bash
# Before creating PR
make lint-full      # ~2 minutes
# Runs: ALL 15+ tools including security and complexity
```

### Complete Validation
```bash
# Verify complete setup
make test-all                          # All tests
./scripts/validate-fullstack-setup.sh  # Validate installation
```

## Infrastructure Standards

### Required Components

#### Docker Orchestration
- **docker-compose.yml**: Multi-service orchestration
- **Backend Dockerfile**: Python container with all dependencies
- **Frontend Dockerfile**: Node.js build + Nginx serving
- **Database Service**: PostgreSQL 15+ with persistent volumes
- **Hot Reload**: Both backend and frontend support live reload

#### CI/CD Pipeline
- **GitHub Actions**: Automated testing and deployment
- **Test Workflow**: Run all quality gates on PRs
- **Deploy Workflow**: Automated deployment to staging/production
- **Security Scanning**: Integrated into CI pipeline

#### Environment Management
- **Backend .env**: Database URL, API config, secrets
- **Frontend .env**: API URL, environment-specific config
- **Docker .env**: Service configuration

### Optional Components

#### UI Scaffold
- Modern landing page with hero banner
- Configurable feature cards
- AI Principles banner with modal popups
- Tab navigation system (3 blank tabs)
- Responsive design (mobile + desktop)
- Complete customization how-to guides

#### Terraform Deployment
- AWS ECS Fargate for backend containers
- S3 + CloudFront for frontend static hosting
- RDS PostgreSQL for database
- Application Load Balancer
- Multi-environment support (dev/staging/prod)
- Complete infrastructure how-to guides

## Security Standards

### Multi-Layer Security

#### Code Security
- **Bandit**: Scan Python code for security issues
- **ESLint Security**: Check for common JavaScript vulnerabilities

#### Dependency Security
- **Safety**: CVE database scanning for Python packages
- **pip-audit**: OSV database scanning for Python packages
- **npm audit**: Vulnerability scanning for npm packages

#### Infrastructure Security
- **Environment Variables**: Never commit secrets to git
- **CORS Configuration**: Proper origin restrictions
- **Database Credentials**: Secure credential management
- **API Authentication**: JWT token-based auth patterns

### Security Thresholds
- **npm audit**: Moderate or higher vulnerabilities block deployment
- **Bandit**: High severity issues block deployment
- **Safety/pip-audit**: Known CVEs block deployment

## Testing Standards

### Backend Testing
- **pytest**: Primary testing framework
- **Coverage**: Minimum 70% code coverage
- **Test Types**:
  - Unit tests for business logic
  - Integration tests for API endpoints
  - Database tests with test fixtures

### Frontend Testing
- **Vitest**: Unit testing
- **React Testing Library**: Component testing
- **Playwright**: E2E testing
- **Coverage**: Minimum 70% code coverage

### Test Automation
- **Pre-commit**: Run fast tests locally
- **CI Pipeline**: Run full test suite on PRs
- **Deployment**: Tests must pass before deploy

## Documentation Standards

### Required Documentation

#### Repository Root
- **README.md**: Complete setup and usage guide
  - "What You Get" section listing all 15+ tools
  - Progressive quality workflows
  - Quick start guide
  - Optional features clearly marked
  - Troubleshooting section

#### AI Agent Support
- **.ai/AGENTS.md**: Quick reference for common tasks
  - Backend development patterns
  - Frontend development patterns
  - Testing workflows
  - Deployment procedures
  - Optional feature usage (UI scaffold, Terraform)

#### How-To Guides (.ai/howto/)
- Adding API endpoints
- Adding frontend pages
- Connecting frontend to backend
- Deploying to AWS
- Managing Terraform infrastructure (if installed)
- Customizing UI scaffold (if installed)

#### Architecture Docs (.ai/docs/)
- Fullstack architecture overview
- API-frontend integration patterns
- UI architecture (if UI scaffold installed)
- Terraform infrastructure (if Terraform installed)
- Production-ready standards (this document)

### Documentation Quality
- Every component has file headers per FILE_HEADER_STANDARDS.md
- All public APIs documented
- All environment variables documented
- All configuration options explained

## Operational Standards

### Validation
- **Installation Validation**: `./scripts/validate-fullstack-setup.sh`
  - Checks all 9 backend tools
  - Checks all 6 frontend tools
  - Validates Makefile targets
  - Verifies Docker setup
  - Confirms CI/CD workflows
  - Validates optional features (if installed)

### Monitoring
- Health check endpoints for all services
- Structured logging with log levels
- Error tracking and reporting
- Performance monitoring

### Deployment
- Zero-downtime deployments
- Database migration automation
- Rollback capability
- Environment-specific configuration

## Makefile Standards

### Required Targets

#### Installation
- `make help` - Show all available targets
- `make install` - Install all dependencies

#### Backend Targets
- `make lint-backend` - Fast linting (Ruff)
- `make lint-backend-all` - Comprehensive linting
- `make lint-backend-security` - Security scanning
- `make lint-backend-complexity` - Complexity analysis
- `make lint-backend-full` - All backend tools

#### Frontend Targets
- `make lint-frontend` - Fast linting (ESLint)
- `make lint-frontend-all` - Comprehensive linting
- `make lint-frontend-security` - Security scanning
- `make lint-frontend-full` - All frontend tools

#### Combined Targets
- `make lint-all` - Thorough check (before commit)
- `make lint-full` - All 15+ tools (before PR)
- `make test-all` - All tests with coverage
- `make format` - Auto-fix formatting
- `make clean` - Clean cache and artifacts

### Target Naming Convention
- Progressive quality levels: `lint-*`, `lint-*-all`, `lint-*-full`
- Clear separation: `lint-backend-*` vs `lint-frontend-*`
- Combined targets: `lint-all`, `lint-full`, `test-all`

## Success Criteria

A fullstack application is production-ready when:

### Tooling
- ✅ All 15+ tools installed and configured
- ✅ All Makefile targets functional
- ✅ Validation script passes all checks
- ✅ CI/CD pipeline operational

### Quality
- ✅ `make lint-full` passes with no errors
- ✅ `make test-all` passes with >70% coverage
- ✅ Security scans show no high-severity issues
- ✅ Complexity metrics within acceptable thresholds

### Infrastructure
- ✅ Docker Compose orchestration works
- ✅ Hot reload functional for both stacks
- ✅ Database migrations automated
- ✅ Environment variables properly managed

### Documentation
- ✅ README.md complete with "What You Get"
- ✅ .ai/AGENTS.md provides quick reference
- ✅ All how-to guides present
- ✅ Architecture docs complete

### Optional Features
- ✅ UI Scaffold (if opted-in) - responsive and customizable
- ✅ Terraform (if opted-in) - multi-environment ready

### Operational
- ✅ Validation script confirms complete setup
- ✅ Zero configuration required by users
- ✅ Truly turnkey experience delivered

---

## Version History

- **v1.0** (2025-10-05): Initial production-ready standards
  - 15+ comprehensive tools
  - Progressive quality workflows
  - Optional UI scaffold and Terraform
  - Complete validation and documentation

---

**These standards ensure every fullstack application is production-ready from day one, with zero additional setup required.**
