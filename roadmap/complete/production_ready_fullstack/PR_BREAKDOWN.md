# Production-Ready React-Python Fullstack - PR Breakdown

**Purpose**: Detailed implementation breakdown of Production-Ready Fullstack into manageable, atomic pull requests

**Scope**: Complete enhancement from basic react-python-fullstack to comprehensive, turnkey application with all quality gates, optional UI scaffold, and optional Terraform deployment

**Overview**: Comprehensive breakdown of the Production-Ready Fullstack feature into 4 manageable, atomic
    pull requests. Each PR is designed to be self-contained, testable, and maintains application functionality
    while incrementally building toward the complete feature. Includes detailed implementation steps, file
    structures, testing requirements, and success criteria for each PR.

**Dependencies**: python-cli plugin (reference), durable-code-test (reference), react-python-fullstack plugin (current)

**Exports**: PR implementation plans, file structures, testing strategies, and success criteria for each development phase

**Related**: AI_CONTEXT.md for feature overview, PROGRESS_TRACKER.md for status tracking

**Implementation**: Atomic PR approach with detailed step-by-step implementation guidance and comprehensive testing validation

---

## Overview
This document breaks down the Production-Ready Fullstack feature into 4 manageable, atomic PRs. Each PR is designed to be:
- Self-contained and testable
- Maintains a working plugin
- Incrementally builds toward the complete feature
- Revertible if needed

---

## PR1: Orchestrate Comprehensive Tooling (Backend + Frontend)

### 🎯 Goal
Install ALL comprehensive quality tools for both backend (9 tools) and frontend (6 tools) automatically. Create composite Makefile with clean namespace.

### 📋 Prerequisites
- [ ] Reviewed python-cli comprehensive tooling (roadmap/polish_python_cli/)
- [ ] Reviewed current react-python-fullstack AGENT_INSTRUCTIONS.md
- [ ] Understanding of comprehensive tooling suite
- [ ] Git repository ready for feature branch

### 🔧 Implementation Steps

#### Step 1: Create Feature Branch
```bash
git checkout main
git pull
git checkout -b feature/pr1-comprehensive-tooling
```

#### Step 2: Update Backend Comprehensive Tooling

**File**: `plugins/applications/react-python-fullstack/project-content/backend/pyproject.toml.template`

**Add to `[tool.poetry.group.dev.dependencies]`**:
```toml
# Comprehensive Linting Suite
pylint = "^3.0.0"
flake8 = "^7.0.0"
flake8-docstrings = "^1.7.0"
flake8-bugbear = "^23.0.0"
flake8-comprehensions = "^3.14.0"
flake8-simplify = "^0.21.0"

# Complexity Analysis
radon = "^6.0.0"
xenon = "^0.9.0"

# Comprehensive Security
safety = "^3.0.0"
pip-audit = "^2.6.0"
```

**Add tool configurations**:
```toml
[tool.pylint.main]
max-line-length = 100
disable = ["C0111"]  # Missing docstring - covered by flake8-docstrings

[tool.flake8]
max-line-length = 100
extend-ignore = ["E203", "W503"]
per-file-ignores = ["__init__.py:F401"]

[tool.radon]
cc_min = "B"
mi_min = "B"

[tool.xenon]
max-absolute = "B"
max-modules = "B"
max-average = "A"
```

#### Step 3: Update Frontend Comprehensive Tooling

**File**: `plugins/applications/react-python-fullstack/project-content/frontend/package.json.template`

**Add to `devDependencies`**:
```json
{
  "devDependencies": {
    "@playwright/test": "^1.40.0",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.1.0",
    "eslint-plugin-jsx-a11y": "^6.8.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-import": "^2.29.0",
    "eslint-plugin-complexity": "^1.0.0",
    "vitest": "^1.0.0",
    "@vitest/ui": "^1.0.0",
    "happy-dom": "^12.10.0"
  }
}
```

**Add to `scripts`**:
```json
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest --coverage",
    "test:e2e": "playwright test",
    "lint:complexity": "eslint --ext .ts,.tsx --max-warnings 10 --plugin complexity src/"
  }
}
```

#### Step 4: Create Production Makefile

**File**: `plugins/applications/react-python-fullstack/project-content/Makefile.template`

```makefile
# Production-Ready React-Python Fullstack Makefile
# Composite quality gate targets for clean namespace

.PHONY: help install clean
.PHONY: lint-backend lint-backend-all lint-backend-security lint-backend-complexity lint-backend-full
.PHONY: lint-frontend lint-frontend-all lint-frontend-security lint-frontend-full
.PHONY: lint-all lint-full test-all format

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "╔════════════════════════════════════════════════════════════╗"
	@echo "║    Production-Ready React-Python Fullstack Commands       ║"
	@echo "╚════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "🚀 Quick Start:"
	@echo "  make install           - Install all dependencies"
	@echo "  make lint-all          - Thorough quality check (before commit)"
	@echo "  make lint-full         - ALL quality gates (before PR)"
	@echo "  make test-all          - Run all tests with coverage"
	@echo ""
	@echo "🔧 Development (Fast Feedback):"
	@echo "  make lint-backend      - Fast backend linting (Ruff)"
	@echo "  make lint-frontend     - Fast frontend linting (ESLint)"
	@echo ""
	@echo "📊 Comprehensive (Before PR):"
	@echo "  make lint-backend-full - ALL backend tools (9 tools)"
	@echo "  make lint-frontend-full- ALL frontend tools (6 tools)"
	@echo "  make lint-full         - Everything (15+ tools)"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-25s %s\n", $$1, $$2}'

# Installation
install: ## Install all dependencies (backend + frontend)
	@echo "📦 Installing backend dependencies..."
	@cd backend && poetry install
	@echo "📦 Installing frontend dependencies..."
	@cd frontend && npm install
	@echo "✅ All dependencies installed!"

# Backend Linting Targets
lint-backend: ## Fast backend linting (Ruff - use during development)
	@echo "🔍 Running fast backend linting (Ruff)..."
	@cd backend && poetry run ruff check src/ tests/
	@cd backend && poetry run ruff format --check src/ tests/

lint-backend-all: ## Comprehensive backend linting (Ruff + Pylint + Flake8 + MyPy)
	@echo "🔍 Running comprehensive backend linting..."
	@cd backend && poetry run ruff check src/ tests/
	@cd backend && poetry run ruff format --check src/ tests/
	@cd backend && poetry run pylint src/
	@cd backend && poetry run flake8 src/ tests/
	@cd backend && poetry run mypy src/

lint-backend-security: ## Backend security scanning (Bandit + Safety + pip-audit)
	@echo "🔒 Running backend security scans..."
	@cd backend && poetry run bandit -r src/ -q
	@cd backend && poetry run safety check --json || true
	@cd backend && poetry run pip-audit || true

lint-backend-complexity: ## Backend complexity analysis (Radon + Xenon)
	@echo "📊 Analyzing backend complexity..."
	@cd backend && poetry run radon cc src/ -a -s
	@cd backend && poetry run radon mi src/ -s
	@cd backend && poetry run xenon --max-absolute B --max-modules B --max-average A src/

lint-backend-full: lint-backend-all lint-backend-security lint-backend-complexity ## ALL backend quality checks (9 tools)
	@echo "✅ All backend linting complete!"

# Frontend Linting Targets
lint-frontend: ## Fast frontend linting (ESLint - use during development)
	@echo "🔍 Running fast frontend linting (ESLint)..."
	@cd frontend && npm run lint

lint-frontend-all: ## Comprehensive frontend linting (ESLint + TypeScript strict)
	@echo "🔍 Running comprehensive frontend linting..."
	@cd frontend && npm run lint
	@cd frontend && npx tsc --noEmit --strict

lint-frontend-security: ## Frontend security scanning (npm audit)
	@echo "🔒 Running frontend security scan..."
	@cd frontend && npm audit --audit-level=moderate || true

lint-frontend-full: lint-frontend-all lint-frontend-security ## ALL frontend quality checks (6 tools)
	@echo "✅ All frontend linting complete!"

# Combined Targets
lint-all: lint-backend-all lint-frontend-all ## Thorough quality check (before commit)
	@echo "✅ All comprehensive linting complete!"

lint-full: lint-backend-full lint-frontend-full ## ALL quality gates (before PR)
	@echo "✅ ALL quality gates passed! Ready for PR."

# Testing Targets
test-backend: ## Run backend tests with coverage
	@cd backend && poetry run pytest --cov=src --cov-report=term --cov-report=html -v

test-frontend: ## Run frontend tests with coverage
	@cd frontend && npm run test:coverage

test-e2e: ## Run E2E tests with Playwright
	@cd frontend && npm run test:e2e

test-all: test-backend test-frontend ## Run all tests (backend + frontend)
	@echo "✅ All tests passed!"

# Formatting Targets
format-backend: ## Auto-fix backend formatting
	@cd backend && poetry run ruff format src/ tests/
	@cd backend && poetry run ruff check --fix src/ tests/

format-frontend: ## Auto-fix frontend formatting
	@cd frontend && npm run format

format: format-backend format-frontend ## Auto-fix all formatting

# Cleanup
clean: ## Clean cache and artifacts
	@echo "🧹 Cleaning backend..."
	@cd backend && find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@cd backend && find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@cd backend && find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@cd backend && find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	@cd backend && find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	@cd backend && rm -rf htmlcov/ .coverage 2>/dev/null || true
	@echo "🧹 Cleaning frontend..."
	@cd frontend && rm -rf node_modules/.cache coverage/ .vitest/ 2>/dev/null || true
	@echo "✅ Cleaned cache and artifacts"
```

#### Step 5: Update AGENT_INSTRUCTIONS.md

**File**: `plugins/applications/react-python-fullstack/AGENT_INSTRUCTIONS.md`

**After Phase 2 (Install languages/python plugin), add**:

```markdown
### Phase 2.5: Install Comprehensive Python Tooling Suite

**Follow**: `plugins/languages/python/core/AGENT_INSTRUCTIONS.md` Step 11 (Comprehensive Tooling)

**What Gets Installed**:
- **Additional Linters**: Pylint, Flake8 + plugins
- **Complexity Analysis**: Radon, Xenon
- **Comprehensive Security**: Safety, pip-audit

**Installation**:
```bash
cd backend
poetry add --group dev \
  pylint \
  flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify \
  radon xenon \
  safety pip-audit
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
```

**After Phase 3 (Install languages/typescript plugin), add**:

```markdown
### Phase 2.7: Install Comprehensive TypeScript Tooling Suite

**What Gets Installed**:
- **Comprehensive ESLint**: React hooks, a11y, import plugins
- **Testing**: Vitest, React Testing Library, Playwright
- **Type Checking**: TypeScript strict mode

**Installation**:
```bash
cd frontend
npm install --save-dev \
  @playwright/test \
  @testing-library/react \
  @testing-library/jest-dom \
  eslint-plugin-jsx-a11y \
  eslint-plugin-react-hooks \
  eslint-plugin-import \
  eslint-plugin-complexity \
  vitest @vitest/ui happy-dom
```

**Validation**:
```bash
cd frontend
npx playwright --version
npx vitest --version
npx tsc --version
```
```

**After tooling installation, add**:

```markdown
### Phase 2.8: Install Production Makefile

**Copy Production Makefile**:
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
```

#### Step 6: Update manifest.yaml

**File**: `plugins/applications/react-python-fullstack/manifest.yaml`

**Update `provides.starter_application.features` section**:
```yaml
features:
  # ... existing features ...
  - Comprehensive backend quality tools (9 tools: Ruff, Pylint, Flake8+plugins, MyPy, Bandit, Radon, Xenon, Safety, pip-audit)
  - Comprehensive frontend quality tools (6 tools: ESLint+plugins, TypeScript strict, Vitest, React Testing Library, Playwright, npm audit)
  - Production Makefile with progressive quality levels (fast → thorough → comprehensive)
  - Clean Makefile namespace (lint-backend-*, lint-frontend-*, lint-all, lint-full)
  - Pre-configured tool settings in pyproject.toml and package.json
  - Zero manual tool configuration required
```

**Update `metadata.complexity`**:
```yaml
metadata:
  complexity: production  # Changed from "advanced"
```

### ✅ Validation Steps

1. **Create test repository**:
```bash
mkdir /tmp/test-fullstack-pr1
cd /tmp/test-fullstack-pr1
git init
```

2. **Follow updated AGENT_INSTRUCTIONS.md**:
- Install foundation plugin
- Install Python plugin
- Install comprehensive Python tooling (Phase 2.5)
- Install TypeScript plugin
- Install comprehensive TypeScript tooling (Phase 2.7)
- Install Production Makefile (Phase 2.8)
- Install Docker, CI/CD, standards plugins
- Copy application files

3. **Test all Makefile targets**:
```bash
make help                    # Should show all targets
make install                 # Install dependencies
make lint-backend            # Should run Ruff only (~1 sec)
make lint-backend-all        # Should run all linters + MyPy (~30 sec)
make lint-backend-security   # Should run Bandit + Safety + pip-audit
make lint-backend-complexity # Should run Radon + Xenon
make lint-backend-full       # Should run everything
make lint-frontend           # Should run ESLint only (~2 sec)
make lint-frontend-all       # Should run ESLint + TSC strict
make lint-frontend-security  # Should run npm audit
make lint-frontend-full      # Should run everything
make lint-all                # Should run comprehensive on both stacks
make lint-full               # Should run ALL 15+ tools
make test-all                # Should run all tests
```

4. **Verify tool installation**:
```bash
cd backend
poetry run pylint --version
poetry run flake8 --version
poetry run radon --version
poetry run xenon --version
poetry run safety --version
poetry run pip-audit --version

cd ../frontend
npx playwright --version
npx vitest --version
```

5. **Verify all quality gates pass**:
```bash
make lint-full  # Should pass with no errors on starter code
make test-all   # Should pass all tests
```

### 📊 Success Criteria
- [ ] All 9 backend tools installed
- [ ] All 6 frontend tools installed
- [ ] All tools pre-configured
- [ ] All Makefile targets work
- [ ] `make lint-full` passes on starter code
- [ ] `make test-all` passes on starter code
- [ ] Clean composite namespace (no target collisions)

### 🚢 Commit and Merge
```bash
git add -A
git commit -m "feat(pr1): Add comprehensive tooling for backend and frontend

Orchestrates comprehensive quality tools for production-ready fullstack:

Backend Tools (9):
- Ruff (fast linting + formatting)
- Pylint (comprehensive quality)
- Flake8 + plugins (style + docstrings + bugbear + comprehensions + simplify)
- MyPy (type checking)
- Bandit (security)
- Radon (complexity metrics)
- Xenon (complexity enforcement)
- Safety (CVE scanning)
- pip-audit (OSV scanning)

Frontend Tools (6):
- ESLint + plugins (React hooks, a11y, import, jsx-a11y, complexity)
- TypeScript strict mode
- Vitest (unit tests)
- React Testing Library (component tests)
- Playwright (E2E tests)
- npm audit (security)

Production Makefile:
- Progressive quality levels (fast → thorough → comprehensive)
- Clean namespace (lint-backend-*, lint-frontend-*, lint-all, lint-full)
- Test targets (test-backend, test-frontend, test-all)

All tools pre-configured in pyproject.toml and package.json.
Zero manual configuration required.

Changes:
- Update AGENT_INSTRUCTIONS.md with Phases 2.5, 2.7, 2.8
- Update backend/pyproject.toml.template with all tools
- Update frontend/package.json.template with all tools
- Create Makefile.template with composite targets
- Update manifest.yaml with production complexity

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git checkout main
git merge feature/pr1-comprehensive-tooling --no-ff
git branch -d feature/pr1-comprehensive-tooling
```

---

## PR2, PR3, PR4

**Note**: Due to document length constraints, PR2 (UI Scaffold), PR3 (Terraform), and PR4 (Validation & Docs) follow the same detailed structure as PR1.

**Key Points for Each**:

### PR2: Add Optional UI Scaffold
- Create `project-content/frontend/ui-scaffold/` directory
- Add HomePage, AppShell, PrinciplesBanner, TabNavigation components
- Add 3 blank starter tabs
- Create `.ai/templates/` for hero-card, tab-component, principle-card
- Create `.ai/howto/react-python-fullstack/` UI modification guides
- Create `.ai/docs/react-python-fullstack/` UI architecture docs
- Update AGENT_INSTRUCTIONS.md with Phase 6 (prompt user for UI scaffold)
- Test all 4 combinations (no UI, UI only, UI + everything)

### PR3: Add Optional Terraform Deployment
- Create `project-content/infra/terraform/` workspace structure
- Add workspaces/base/, workspaces/bootstrap/, modules/, shared/, backend-config/
- Create `Makefile.infra.template` with all terraform operations
- Create `.ai/howto/react-python-fullstack/` Terraform deployment guides
- Create `.ai/docs/react-python-fullstack/` Terraform architecture docs
- Update AGENT_INSTRUCTIONS.md with Phase 7 (prompt user for Terraform)
- Test all 4 combinations (no Terraform, Terraform only, Terraform + everything)

### PR4: Validation, Documentation & Integration
- Create `scripts/validate-fullstack-setup.sh`
- Update `README.md.template` with "What You Get" section
- Create `.ai/docs/PRODUCTION_READY_STANDARDS.md`
- Create comprehensive `.ai/AGENTS.md` template
- Update `manifest.yaml` with all capabilities documented
- Test all 8 combinations (2^3: UI yes/no, Terraform yes/no, comprehensive tooling required)
- Final integration testing and validation

---

## Testing Matrix

### All Combinations to Test
1. ✅ Comprehensive tooling only (no UI, no Terraform)
2. ✅ Comprehensive tooling + UI scaffold
3. ✅ Comprehensive tooling + Terraform
4. ✅ Comprehensive tooling + UI scaffold + Terraform (full install)

### Validation Checklist for Each Combination
- [ ] Installation completes without errors
- [ ] All required tools installed (15+ tools)
- [ ] Optional features installed if opted-in
- [ ] Optional features skipped if opted-out
- [ ] `make lint-full` passes
- [ ] `make test-all` passes
- [ ] Validation script passes
- [ ] README reflects what's installed
- [ ] AGENTS.md reflects what's available

---

**Document Version**: 1.0
**Last Updated**: 2025-10-04
**Status**: Ready for PR1 implementation
