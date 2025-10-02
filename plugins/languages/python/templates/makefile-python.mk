# Purpose: Python-specific Makefile targets for linting, formatting, testing, and type checking
# Scope: Python development workflow automation with Docker-first approach
# Overview: Provides standardized Make targets for Python projects including Ruff linting/formatting,
#     MyPy type checking, Bandit security scanning, and pytest testing. Implements Docker-first
#     development pattern with automatic fallback to isolated environments (Poetry) or direct local.
#     Designed to be included in a project's main Makefile.
# Dependencies: Docker (preferred), Poetry/pip (fallback), Python tools (ruff, mypy, bandit, pytest)
# Exports: Make targets for Python development tasks with environment auto-detection
# Related: Python development workflow, CI/CD integration, Docker multi-stage builds
# Implementation: Makefile targets with three-tier environment hierarchy (Docker → Poetry → Direct)

################################################################################
# Python Development Targets - Docker-First Pattern
################################################################################
# Include this file in your main Makefile with: -include Makefile.python
# Or copy these targets directly into your main Makefile
#
# Environment Hierarchy:
# 1. Docker (Preferred) - Consistent, isolated, no local pollution
# 2. Poetry (Fallback) - Project-isolated virtual environment
# 3. Direct (Last Resort) - Direct local execution (not recommended)
################################################################################

.PHONY: lint-python format-python format-check-python typecheck security-scan lint-mypy lint-bandit lint-pylint lint-flake8 complexity-radon complexity-xenon security-full test-python test-coverage-python python-check python-install dev-python lint-start-python

# Color codes for output
PYTHON_CYAN := \033[0;36m
PYTHON_GREEN := \033[0;32m
PYTHON_YELLOW := \033[0;33m
PYTHON_RED := \033[0;31m
PYTHON_NC := \033[0m

# Python source directories (customize for your project)
PYTHON_SRC_DIRS := src app

# Python test directory
PYTHON_TEST_DIR := tests test

# Docker configuration
DOCKER_COMPOSE := docker compose
DOCKER_COMPOSE_APP := $(DOCKER_COMPOSE) -f .docker/compose/app.yml
DOCKER_COMPOSE_LINT := $(DOCKER_COMPOSE) -f .docker/compose/lint.yml
PROJECT_NAME ?= python-app
BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null | tr '/' '-' | tr '[:upper:]' '[:lower:]' || echo "main")
BACKEND_PORT ?= 8000

# Environment detection
HAS_DOCKER := $(shell command -v docker 2>/dev/null)
HAS_POETRY := $(shell command -v poetry 2>/dev/null)

################################################################################
# Development Environment
################################################################################

dev-python: ## Start Python development environment (Docker-first with auto-detection)
ifdef HAS_DOCKER
	@echo "$(PYTHON_CYAN)Starting Python development environment (Docker)...$(PYTHON_NC)"
	@BRANCH_NAME=$(BRANCH_NAME) BACKEND_PORT=$(BACKEND_PORT) PROJECT_NAME=$(PROJECT_NAME) \
		$(DOCKER_COMPOSE_APP) up -d
	@echo "$(PYTHON_GREEN)✓ Development environment started!$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Backend: http://localhost:$(BACKEND_PORT)$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Logs: docker logs -f $(PROJECT_NAME)-backend-$(BRANCH_NAME)-dev$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry install
	@poetry run uvicorn app.main:app --host 0.0.0.0 --port $(BACKEND_PORT) --reload
else
	@echo "$(PYTHON_RED)⚠️  WARNING: Using direct local execution (not recommended)$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Install Docker or Poetry for better isolation$(PYTHON_NC)"
	@pip install -r requirements.txt 2>/dev/null || pip install -e .
	@uvicorn app.main:app --host 0.0.0.0 --port $(BACKEND_PORT) --reload
endif

dev-stop-python: ## Stop Python development environment
ifdef HAS_DOCKER
	@echo "$(PYTHON_CYAN)Stopping Python development environment...$(PYTHON_NC)"
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE_APP) down
	@echo "$(PYTHON_GREEN)✓ Development environment stopped$(PYTHON_NC)"
else
	@echo "$(PYTHON_YELLOW)No Docker environment to stop$(PYTHON_NC)"
endif

################################################################################
# Linting (Docker-First)
################################################################################

lint-start-python: ## Start dedicated linting containers
ifdef HAS_DOCKER
	@echo "$(PYTHON_CYAN)Starting Python linting containers...$(PYTHON_NC)"
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE_LINT) up -d
	@echo "$(PYTHON_GREEN)✓ Linting containers started$(PYTHON_NC)"
else
	@echo "$(PYTHON_YELLOW)Docker not available, linting will run locally$(PYTHON_NC)"
endif

lint-stop-python: ## Stop dedicated linting containers
ifdef HAS_DOCKER
	@echo "$(PYTHON_CYAN)Stopping Python linting containers...$(PYTHON_NC)"
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE_LINT) down
	@echo "$(PYTHON_GREEN)✓ Linting containers stopped$(PYTHON_NC)"
endif

lint-python: ## Run Python linting (Ruff) - Docker-first with auto-detection
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running Python linter (Ruff) in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && \
		ruff format --check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR) && \
		ruff check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)"
	@echo "$(PYTHON_GREEN)✓ Python linting complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run ruff format --check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@poetry run ruff check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python linting complete$(PYTHON_NC)"
else
	@echo "$(PYTHON_RED)⚠️  Using direct local execution$(PYTHON_NC)"
	@ruff format --check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@ruff check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python linting complete$(PYTHON_NC)"
endif

lint-fix-python: ## Auto-fix Python linting issues - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Auto-fixing Python code in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && \
		ruff format $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR) && \
		ruff check --fix $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)"
	@echo "$(PYTHON_GREEN)✓ Python auto-fix complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run ruff format $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@poetry run ruff check --fix $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python auto-fix complete$(PYTHON_NC)"
else
	@ruff format $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@ruff check --fix $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python auto-fix complete$(PYTHON_NC)"
endif

format-python: lint-fix-python ## Alias for lint-fix-python

format-check-python: ## Check Python formatting - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Checking Python formatting in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && ruff format --check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)"
	@echo "$(PYTHON_GREEN)✓ Python format check complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@poetry run ruff format --check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python format check complete$(PYTHON_NC)"
else
	@ruff format --check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python format check complete$(PYTHON_NC)"
endif

################################################################################
# Type Checking (Docker-First)
################################################################################

typecheck: ## Run Python type checking (MyPy) - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running Python type checker (MyPy) in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && \
		mkdir -p /tmp/.cache/mypy && \
		MYPY_CACHE_DIR=/tmp/.cache/mypy mypy $(PYTHON_SRC_DIRS)"
	@echo "$(PYTHON_GREEN)✓ Type checking complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run mypy $(PYTHON_SRC_DIRS)
	@echo "$(PYTHON_GREEN)✓ Type checking complete$(PYTHON_NC)"
else
	@mypy $(PYTHON_SRC_DIRS)
	@echo "$(PYTHON_GREEN)✓ Type checking complete$(PYTHON_NC)"
endif

################################################################################
# Security Scanning (Docker-First)
################################################################################

security-scan: ## Run Python security scanning (Bandit) - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running Python security scanner (Bandit) in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && bandit -r $(PYTHON_SRC_DIRS) -q"
	@echo "$(PYTHON_GREEN)✓ Security scan complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run bandit -r $(PYTHON_SRC_DIRS) -q
	@echo "$(PYTHON_GREEN)✓ Security scan complete$(PYTHON_NC)"
else
	@bandit -r $(PYTHON_SRC_DIRS) -q
	@echo "$(PYTHON_GREEN)✓ Security scan complete$(PYTHON_NC)"
endif

################################################################################
# Comprehensive Linting Tools (Docker-First)
################################################################################

lint-mypy: typecheck ## Alias for typecheck (MyPy type checking)

lint-bandit: security-scan ## Alias for security-scan (Bandit security scanning)

lint-pylint: ## Run Pylint comprehensive code quality linting - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running Pylint code quality linter in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && pylint $(PYTHON_SRC_DIRS) --output-format=colorized"
	@echo "$(PYTHON_GREEN)✓ Pylint linting complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run pylint $(PYTHON_SRC_DIRS) --output-format=colorized
	@echo "$(PYTHON_GREEN)✓ Pylint linting complete$(PYTHON_NC)"
else
	@pylint $(PYTHON_SRC_DIRS) --output-format=colorized
	@echo "$(PYTHON_GREEN)✓ Pylint linting complete$(PYTHON_NC)"
endif

lint-flake8: ## Run Flake8 style guide enforcement with plugins - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running Flake8 style checker in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && flake8 $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)"
	@echo "$(PYTHON_GREEN)✓ Flake8 linting complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run flake8 $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Flake8 linting complete$(PYTHON_NC)"
else
	@flake8 $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Flake8 linting complete$(PYTHON_NC)"
endif

################################################################################
# Complexity Analysis (Docker-First)
################################################################################

complexity-radon: ## Run Radon complexity and maintainability analysis - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running Radon complexity analysis in Docker...$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Cyclomatic Complexity (CC):$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && radon cc $(PYTHON_SRC_DIRS) -a -s"
	@echo ""
	@echo "$(PYTHON_YELLOW)Maintainability Index (MI):$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && radon mi $(PYTHON_SRC_DIRS) -s"
	@echo "$(PYTHON_GREEN)✓ Radon complexity analysis complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Cyclomatic Complexity (CC):$(PYTHON_NC)"
	@poetry run radon cc $(PYTHON_SRC_DIRS) -a -s
	@echo ""
	@echo "$(PYTHON_YELLOW)Maintainability Index (MI):$(PYTHON_NC)"
	@poetry run radon mi $(PYTHON_SRC_DIRS) -s
	@echo "$(PYTHON_GREEN)✓ Radon complexity analysis complete$(PYTHON_NC)"
else
	@echo "$(PYTHON_YELLOW)Cyclomatic Complexity (CC):$(PYTHON_NC)"
	@radon cc $(PYTHON_SRC_DIRS) -a -s
	@echo ""
	@echo "$(PYTHON_YELLOW)Maintainability Index (MI):$(PYTHON_NC)"
	@radon mi $(PYTHON_SRC_DIRS) -s
	@echo "$(PYTHON_GREEN)✓ Radon complexity analysis complete$(PYTHON_NC)"
endif

complexity-xenon: ## Run Xenon complexity monitoring and enforcement - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running Xenon complexity enforcement in Docker...$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && xenon --max-absolute A --max-modules A --max-average A $(PYTHON_SRC_DIRS)"
	@echo "$(PYTHON_GREEN)✓ Xenon complexity check passed (grade A)$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run xenon --max-absolute A --max-modules A --max-average A $(PYTHON_SRC_DIRS)
	@echo "$(PYTHON_GREEN)✓ Xenon complexity check passed (grade A)$(PYTHON_NC)"
else
	@xenon --max-absolute A --max-modules A --max-average A $(PYTHON_SRC_DIRS)
	@echo "$(PYTHON_GREEN)✓ Xenon complexity check passed (grade A)$(PYTHON_NC)"
endif

################################################################################
# Comprehensive Security Scanning (Docker-First)
################################################################################

security-full: ## Run all security tools (Bandit, Safety, pip-audit) - Docker-first
ifdef HAS_DOCKER
	@if ! docker ps | grep -q "$(PROJECT_NAME)-python-linter-$(BRANCH_NAME)"; then \
		$(MAKE) lint-start-python; \
	fi
	@echo "$(PYTHON_CYAN)Running comprehensive security scanning in Docker...$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)1. Bandit (code security vulnerabilities):$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && bandit -r $(PYTHON_SRC_DIRS) -ll"
	@echo ""
	@echo "$(PYTHON_YELLOW)2. Safety (dependency vulnerabilities):$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && safety check --json || true"
	@echo ""
	@echo "$(PYTHON_YELLOW)3. pip-audit (dependency security audit):$(PYTHON_NC)"
	@docker exec $(PROJECT_NAME)-python-linter-$(BRANCH_NAME) bash -c "\
		cd /workspace && pip-audit || true"
	@echo "$(PYTHON_GREEN)✓ Comprehensive security scan complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)1. Bandit (code security vulnerabilities):$(PYTHON_NC)"
	@poetry run bandit -r $(PYTHON_SRC_DIRS) -ll
	@echo ""
	@echo "$(PYTHON_YELLOW)2. Safety (dependency vulnerabilities):$(PYTHON_NC)"
	@poetry run safety check --json || true
	@echo ""
	@echo "$(PYTHON_YELLOW)3. pip-audit (dependency security audit):$(PYTHON_NC)"
	@poetry run pip-audit || true
	@echo "$(PYTHON_GREEN)✓ Comprehensive security scan complete$(PYTHON_NC)"
else
	@echo "$(PYTHON_YELLOW)1. Bandit (code security vulnerabilities):$(PYTHON_NC)"
	@bandit -r $(PYTHON_SRC_DIRS) -ll
	@echo ""
	@echo "$(PYTHON_YELLOW)2. Safety (dependency vulnerabilities):$(PYTHON_NC)"
	@safety check --json || true
	@echo ""
	@echo "$(PYTHON_YELLOW)3. pip-audit (dependency security audit):$(PYTHON_NC)"
	@pip-audit || true
	@echo "$(PYTHON_GREEN)✓ Comprehensive security scan complete$(PYTHON_NC)"
endif

################################################################################
# Testing (Docker-First)
################################################################################

test-python: ## Run Python tests (pytest) - Docker-first
ifdef HAS_DOCKER
	@echo "$(PYTHON_CYAN)Running Python tests in Docker...$(PYTHON_NC)"
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE) \
		-f .docker/compose/test.yml run --rm python-test
	@echo "$(PYTHON_GREEN)✓ Python tests complete$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run pytest -v
	@echo "$(PYTHON_GREEN)✓ Python tests complete$(PYTHON_NC)"
else
	@pytest -v
	@echo "$(PYTHON_GREEN)✓ Python tests complete$(PYTHON_NC)"
endif

test-coverage-python: ## Run Python tests with coverage - Docker-first
ifdef HAS_DOCKER
	@echo "$(PYTHON_CYAN)Running Python tests with coverage in Docker...$(PYTHON_NC)"
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE) \
		-f .docker/compose/test.yml run --rm python-test \
		pytest --cov=$(PYTHON_SRC_DIRS) --cov-report=term --cov-report=html -v
	@echo "$(PYTHON_GREEN)✓ Python tests with coverage complete$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Coverage report: htmlcov/index.html$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Docker not available, using Poetry...$(PYTHON_NC)"
	@poetry run pytest --cov=$(PYTHON_SRC_DIRS) --cov-report=term --cov-report=html -v
	@echo "$(PYTHON_GREEN)✓ Python tests with coverage complete$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Coverage report: htmlcov/index.html$(PYTHON_NC)"
else
	@pytest --cov=$(PYTHON_SRC_DIRS) --cov-report=term --cov-report=html -v
	@echo "$(PYTHON_GREEN)✓ Python tests with coverage complete$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Coverage report: htmlcov/index.html$(PYTHON_NC)"
endif

test-unit-python: ## Run Python unit tests only
ifdef HAS_DOCKER
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE) \
		-f .docker/compose/test.yml run --rm python-test pytest -v -m unit
else ifdef HAS_POETRY
	@poetry run pytest -v -m unit
else
	@pytest -v -m unit
endif

test-integration-python: ## Run Python integration tests only
ifdef HAS_DOCKER
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE) \
		-f .docker/compose/test.yml run --rm python-test pytest -v -m integration
else ifdef HAS_POETRY
	@poetry run pytest -v -m integration
else
	@pytest -v -m integration
endif

################################################################################
# Composite Targets
################################################################################

python-check: lint-python typecheck security-scan test-python ## Run all Python checks (Docker-first)
	@echo "$(PYTHON_GREEN)✅ All Python checks passed!$(PYTHON_NC)"

python-install: ## Install Python dependencies - environment-aware
ifdef HAS_DOCKER
	@echo "$(PYTHON_CYAN)Building Docker images with dependencies...$(PYTHON_NC)"
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE_APP) build
	@echo "$(PYTHON_GREEN)✓ Docker images built$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_CYAN)Installing Python dependencies with Poetry...$(PYTHON_NC)"
	@poetry install
	@echo "$(PYTHON_GREEN)✓ Poetry dependencies installed$(PYTHON_NC)"
else
	@echo "$(PYTHON_CYAN)Installing Python dependencies with pip...$(PYTHON_NC)"
	@if [ -f "requirements.txt" ]; then \
		pip install -r requirements.txt; \
	fi
	@if [ -f "requirements-dev.txt" ]; then \
		pip install -r requirements-dev.txt; \
	fi
	@echo "$(PYTHON_GREEN)✓ Dependencies installed$(PYTHON_NC)"
endif

################################################################################
# Cleanup
################################################################################

clean-python: ## Clean Python cache files and containers
	@echo "$(PYTHON_CYAN)Cleaning Python artifacts...$(PYTHON_NC)"
ifdef HAS_DOCKER
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE_APP) down -v 2>/dev/null || true
	@BRANCH_NAME=$(BRANCH_NAME) PROJECT_NAME=$(PROJECT_NAME) $(DOCKER_COMPOSE_LINT) down -v 2>/dev/null || true
endif
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name "*.pyo" -delete 2>/dev/null || true
	@rm -rf htmlcov/ .coverage 2>/dev/null || true
	@echo "$(PYTHON_GREEN)✓ Python artifacts cleaned$(PYTHON_NC)"

################################################################################
# Help
################################################################################

help-python: ## Show Python-specific help
	@echo "$(PYTHON_CYAN)╔════════════════════════════════════════════════════════════╗$(PYTHON_NC)"
	@echo "$(PYTHON_CYAN)║          Python Development Commands (Docker-First)       ║$(PYTHON_NC)"
	@echo "$(PYTHON_CYAN)╚════════════════════════════════════════════════════════════╝$(PYTHON_NC)"
	@echo ""
ifdef HAS_DOCKER
	@echo "$(PYTHON_GREEN)Environment: Docker (Preferred) 🐳$(PYTHON_NC)"
else ifdef HAS_POETRY
	@echo "$(PYTHON_YELLOW)Environment: Poetry (Fallback) 📦$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)⚠️  Consider installing Docker for better consistency$(PYTHON_NC)"
else
	@echo "$(PYTHON_RED)Environment: Direct Local (Last Resort) ⚠️$(PYTHON_NC)"
	@echo "$(PYTHON_RED)⚠️  Install Docker or Poetry for better isolation!$(PYTHON_NC)"
endif
	@echo ""
	@echo "$(PYTHON_GREEN)Development:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make dev-python$(PYTHON_NC)               - Start development environment"
	@echo "  $(PYTHON_YELLOW)make dev-stop-python$(PYTHON_NC)          - Stop development environment"
	@echo ""
	@echo "$(PYTHON_GREEN)Quality Checks (Primary):$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make lint-python$(PYTHON_NC)              - Run Ruff linter (fast, recommended)"
	@echo "  $(PYTHON_YELLOW)make lint-fix-python$(PYTHON_NC)          - Auto-fix linting issues"
	@echo "  $(PYTHON_YELLOW)make format-python$(PYTHON_NC)            - Format code with Ruff"
	@echo "  $(PYTHON_YELLOW)make format-check-python$(PYTHON_NC)      - Check formatting"
	@echo "  $(PYTHON_YELLOW)make typecheck$(PYTHON_NC)                - Run MyPy type checker"
	@echo "  $(PYTHON_YELLOW)make security-scan$(PYTHON_NC)            - Run Bandit security scanner"
	@echo ""
	@echo "$(PYTHON_GREEN)Additional Linting:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make lint-mypy$(PYTHON_NC)                - MyPy type checking (alias)"
	@echo "  $(PYTHON_YELLOW)make lint-bandit$(PYTHON_NC)              - Bandit security scan (alias)"
	@echo "  $(PYTHON_YELLOW)make lint-pylint$(PYTHON_NC)              - Pylint comprehensive linting"
	@echo "  $(PYTHON_YELLOW)make lint-flake8$(PYTHON_NC)              - Flake8 + plugins linting"
	@echo ""
	@echo "$(PYTHON_GREEN)Complexity Analysis:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make complexity-radon$(PYTHON_NC)         - Radon CC & MI analysis"
	@echo "  $(PYTHON_YELLOW)make complexity-xenon$(PYTHON_NC)         - Xenon complexity enforcement"
	@echo ""
	@echo "$(PYTHON_GREEN)Security (Comprehensive):$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make security-full$(PYTHON_NC)            - All security tools (Bandit+Safety+pip-audit)"
	@echo ""
	@echo "$(PYTHON_GREEN)Testing:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make test-python$(PYTHON_NC)              - Run all tests"
	@echo "  $(PYTHON_YELLOW)make test-coverage-python$(PYTHON_NC)     - Run tests with coverage"
	@echo "  $(PYTHON_YELLOW)make test-unit-python$(PYTHON_NC)         - Run unit tests only"
	@echo "  $(PYTHON_YELLOW)make test-integration-python$(PYTHON_NC)  - Run integration tests only"
	@echo ""
	@echo "$(PYTHON_GREEN)Utilities:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make python-check$(PYTHON_NC)             - Run all checks"
	@echo "  $(PYTHON_YELLOW)make python-install$(PYTHON_NC)           - Install/build dependencies"
	@echo "  $(PYTHON_YELLOW)make clean-python$(PYTHON_NC)             - Clean cache and containers"
	@echo ""

################################################################################
# Usage Examples:
#
# Docker-first development (recommended):
#   make dev-python              # Start dev environment
#   make lint-python             # Lint in container
#   make test-coverage-python    # Test with coverage in container
#   make python-check            # Run all checks in containers
#
# Poetry fallback (when Docker unavailable):
#   make python-install          # Install with Poetry
#   make lint-python             # Lint with Poetry
#   make test-python             # Test with Poetry
#
# Direct local (last resort):
#   make python-install          # Install with pip
#   make lint-python             # Lint directly
#
################################################################################
