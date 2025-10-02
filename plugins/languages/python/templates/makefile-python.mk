# Purpose: Python-specific Makefile targets for linting, formatting, testing, and type checking
# Scope: Python development workflow automation
# Overview: Provides standardized Make targets for Python projects including Ruff linting/formatting,
#     MyPy type checking, Bandit security scanning, and pytest testing. Designed to be included
#     in a project's main Makefile.
# Dependencies: ruff, mypy, bandit, pytest (installed via pip/poetry)
# Exports: Make targets for Python development tasks
# Related: Python development workflow, CI/CD integration
# Implementation: Makefile targets that can be included or copied to main Makefile

################################################################################
# Python Development Targets
################################################################################
# Include this file in your main Makefile with: -include Makefile.python
# Or copy these targets directly into your main Makefile
################################################################################

.PHONY: lint-python format-python format-check-python typecheck security-scan test-python test-coverage-python python-check python-install

# Color codes for output
PYTHON_CYAN := \033[0;36m
PYTHON_GREEN := \033[0;32m
PYTHON_YELLOW := \033[0;33m
PYTHON_NC := \033[0m

# Python source directories (customize for your project)
PYTHON_SRC_DIRS := src app

# Python test directory
PYTHON_TEST_DIR := tests

# Linting with Ruff
lint-python: ## Run Python linting (Ruff)
	@echo "$(PYTHON_CYAN)Running Python linter (Ruff)...$(PYTHON_NC)"
	@ruff check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python linting complete$(PYTHON_NC)"

# Auto-fix linting issues
lint-fix-python: ## Auto-fix Python linting issues (Ruff)
	@echo "$(PYTHON_CYAN)Auto-fixing Python linting issues...$(PYTHON_NC)"
	@ruff check --fix $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python auto-fix complete$(PYTHON_NC)"

# Format code with Ruff
format-python: ## Format Python code (Ruff)
	@echo "$(PYTHON_CYAN)Formatting Python code...$(PYTHON_NC)"
	@ruff format $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python formatting complete$(PYTHON_NC)"

# Check formatting without modifying files
format-check-python: ## Check Python formatting (Ruff)
	@echo "$(PYTHON_CYAN)Checking Python formatting...$(PYTHON_NC)"
	@ruff format --check $(PYTHON_SRC_DIRS) $(PYTHON_TEST_DIR)
	@echo "$(PYTHON_GREEN)✓ Python format check complete$(PYTHON_NC)"

# Type checking with MyPy
typecheck: ## Run Python type checking (MyPy)
	@echo "$(PYTHON_CYAN)Running Python type checker (MyPy)...$(PYTHON_NC)"
	@mypy $(PYTHON_SRC_DIRS)
	@echo "$(PYTHON_GREEN)✓ Type checking complete$(PYTHON_NC)"

# Security scanning with Bandit
security-scan: ## Run Python security scanning (Bandit)
	@echo "$(PYTHON_CYAN)Running Python security scanner (Bandit)...$(PYTHON_NC)"
	@bandit -r $(PYTHON_SRC_DIRS) -q
	@echo "$(PYTHON_GREEN)✓ Security scan complete$(PYTHON_NC)"

# Run all tests
test-python: ## Run Python tests (pytest)
	@echo "$(PYTHON_CYAN)Running Python tests...$(PYTHON_NC)"
	@pytest -v
	@echo "$(PYTHON_GREEN)✓ Python tests complete$(PYTHON_NC)"

# Run tests with coverage
test-coverage-python: ## Run Python tests with coverage (pytest + coverage)
	@echo "$(PYTHON_CYAN)Running Python tests with coverage...$(PYTHON_NC)"
	@pytest --cov=$(PYTHON_SRC_DIRS) --cov-report=term --cov-report=html
	@echo "$(PYTHON_GREEN)✓ Python tests with coverage complete$(PYTHON_NC)"
	@echo "$(PYTHON_YELLOW)Coverage report: htmlcov/index.html$(PYTHON_NC)"

# Run only unit tests
test-unit-python: ## Run Python unit tests only
	@echo "$(PYTHON_CYAN)Running Python unit tests...$(PYTHON_NC)"
	@pytest -v -m unit
	@echo "$(PYTHON_GREEN)✓ Python unit tests complete$(PYTHON_NC)"

# Run only integration tests
test-integration-python: ## Run Python integration tests only
	@echo "$(PYTHON_CYAN)Running Python integration tests...$(PYTHON_NC)"
	@pytest -v -m integration
	@echo "$(PYTHON_GREEN)✓ Python integration tests complete$(PYTHON_NC)"

# Run all Python quality checks
python-check: lint-python typecheck security-scan test-python ## Run all Python checks (lint, type, security, test)
	@echo "$(PYTHON_GREEN)✅ All Python checks passed!$(PYTHON_NC)"

# Install Python dependencies
python-install: ## Install Python dependencies (poetry or pip)
	@echo "$(PYTHON_CYAN)Installing Python dependencies...$(PYTHON_NC)"
	@if [ -f "pyproject.toml" ] && command -v poetry >/dev/null 2>&1; then \
		echo "Using Poetry..."; \
		poetry install; \
	elif [ -f "requirements.txt" ]; then \
		echo "Using pip..."; \
		pip install -r requirements.txt; \
		if [ -f "requirements-dev.txt" ]; then \
			pip install -r requirements-dev.txt; \
		fi; \
	else \
		echo "$(PYTHON_YELLOW)No dependency file found (pyproject.toml or requirements.txt)$(PYTHON_NC)"; \
	fi
	@echo "$(PYTHON_GREEN)✓ Python dependencies installed$(PYTHON_NC)"

# Clean Python cache files
clean-python: ## Clean Python cache files and directories
	@echo "$(PYTHON_CYAN)Cleaning Python cache files...$(PYTHON_NC)"
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name "*.pyo" -delete 2>/dev/null || true
	@rm -rf htmlcov/ .coverage 2>/dev/null || true
	@echo "$(PYTHON_GREEN)✓ Python cache cleaned$(PYTHON_NC)"

# Help target for Python commands
help-python: ## Show Python-specific help
	@echo "$(PYTHON_CYAN)╔════════════════════════════════════════════════════════════╗$(PYTHON_NC)"
	@echo "$(PYTHON_CYAN)║              Python Development Commands                  ║$(PYTHON_NC)"
	@echo "$(PYTHON_CYAN)╚════════════════════════════════════════════════════════════╝$(PYTHON_NC)"
	@echo ""
	@echo "$(PYTHON_GREEN)Quality Checks:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make lint-python$(PYTHON_NC)              - Run Ruff linter"
	@echo "  $(PYTHON_YELLOW)make lint-fix-python$(PYTHON_NC)          - Auto-fix linting issues"
	@echo "  $(PYTHON_YELLOW)make format-python$(PYTHON_NC)            - Format code with Ruff"
	@echo "  $(PYTHON_YELLOW)make format-check-python$(PYTHON_NC)      - Check formatting"
	@echo "  $(PYTHON_YELLOW)make typecheck$(PYTHON_NC)                - Run MyPy type checker"
	@echo "  $(PYTHON_YELLOW)make security-scan$(PYTHON_NC)            - Run Bandit security scanner"
	@echo ""
	@echo "$(PYTHON_GREEN)Testing:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make test-python$(PYTHON_NC)              - Run all tests"
	@echo "  $(PYTHON_YELLOW)make test-coverage-python$(PYTHON_NC)     - Run tests with coverage"
	@echo "  $(PYTHON_YELLOW)make test-unit-python$(PYTHON_NC)         - Run unit tests only"
	@echo "  $(PYTHON_YELLOW)make test-integration-python$(PYTHON_NC)  - Run integration tests only"
	@echo ""
	@echo "$(PYTHON_GREEN)Utilities:$(PYTHON_NC)"
	@echo "  $(PYTHON_YELLOW)make python-check$(PYTHON_NC)             - Run all checks"
	@echo "  $(PYTHON_YELLOW)make python-install$(PYTHON_NC)           - Install dependencies"
	@echo "  $(PYTHON_YELLOW)make clean-python$(PYTHON_NC)             - Clean cache files"
	@echo ""

################################################################################
# Usage Examples:
#
# make lint-python              # Check code quality
# make format-python            # Format code
# make typecheck                # Check types
# make security-scan            # Scan for security issues
# make test-coverage-python     # Run tests with coverage
# make python-check             # Run all quality checks
#
################################################################################
