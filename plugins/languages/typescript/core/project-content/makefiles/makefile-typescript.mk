# TypeScript Development Makefile
# Purpose: Docker-first TypeScript development with automatic fallback to npm
# Scope: TypeScript project automation with environment detection
# Overview: Implements Docker-first development hierarchy with graceful fallback.
#     Auto-detects Docker and npm availability, prioritizing Docker for consistency.
#     All targets support both Docker and npm execution paths transparently.
# Dependencies: Docker (preferred), Docker Compose (preferred), npm (fallback)
# Exports: Development, linting, testing, and building targets
# Related: DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md, Dockerfile.typescript
# Implementation: Auto-detection with ifdef conditionals for graceful degradation

.PHONY: typescript-install dev-typescript dev-typescript-stop lint-typescript lint-typescript-fix format-typescript format-check-typescript test-typescript test-coverage-typescript typecheck-typescript build-typescript typescript-check typescript-clean

# =============================================================================
# Environment Detection
# =============================================================================
HAS_DOCKER := $(shell command -v docker 2>/dev/null)
HAS_DOCKER_COMPOSE := $(shell command -v docker-compose 2>/dev/null || command -v docker 2>/dev/null)
HAS_NPM := $(shell command -v npm 2>/dev/null)

# Project configuration
TYPESCRIPT_COMPOSE_FILE := docker-compose.yml
TYPESCRIPT_CONTAINER_PREFIX := typescript-app

# Colors for output
CYAN = \033[0;36m
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# =============================================================================
# Installation & Setup
# =============================================================================

# Install dependencies using Docker-first approach
typescript-install:
ifdef HAS_DOCKER
	@echo "$(CYAN)Installing TypeScript dependencies with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) build --no-cache
	@echo "$(GREEN)✓ Docker images built successfully$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Installing TypeScript dependencies with npm (Docker not available)...$(NC)"
	@npm ci
	@echo "$(GREEN)✓ Dependencies installed successfully$(NC)"
else
	@echo "$(RED)❌ Neither Docker nor npm found. Please install Docker or Node.js/npm.$(NC)"
	@exit 1
endif

# =============================================================================
# Development
# =============================================================================

# Start development server with hot reload
dev-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Starting TypeScript development server with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) up -d frontend-dev
	@echo "$(GREEN)✓ Development server started!$(NC)"
	@echo "$(YELLOW)Frontend: http://localhost:5173$(NC)"
	@echo "$(YELLOW)Logs: make dev-typescript-logs$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Starting TypeScript development server with npm (Docker not available)...$(NC)"
	@npm run dev
else
	@echo "$(RED)❌ Neither Docker nor npm found. Please install Docker or Node.js/npm.$(NC)"
	@exit 1
endif

# Stop development server
dev-typescript-stop:
ifdef HAS_DOCKER
	@echo "$(CYAN)Stopping TypeScript development server...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) down
	@echo "$(GREEN)✓ Development server stopped$(NC)"
else
	@echo "$(YELLOW)No Docker containers to stop (using npm)$(NC)"
endif

# View development server logs
dev-typescript-logs:
ifdef HAS_DOCKER
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) logs -f frontend-dev
else
	@echo "$(YELLOW)Logs not available in npm mode$(NC)"
endif

# =============================================================================
# Linting & Formatting
# =============================================================================

# Lint TypeScript code with ESLint
lint-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Linting TypeScript code with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run lint
	@echo "$(GREEN)✓ Linting passed$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Linting TypeScript code with npm...$(NC)"
	@npm run lint
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# Auto-fix TypeScript linting and formatting issues
lint-typescript-fix:
ifdef HAS_DOCKER
	@echo "$(CYAN)Auto-fixing TypeScript issues with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run lint:fix
	@echo "$(GREEN)✓ Auto-fix complete$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Auto-fixing TypeScript issues with npm...$(NC)"
	@npm run lint:fix
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# Format TypeScript code with Prettier
format-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Formatting TypeScript code with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run format
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run lint:fix
	@echo "$(GREEN)✓ Formatting complete$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Formatting TypeScript code with npm...$(NC)"
	@npm run format
	@npm run lint:fix
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# Check TypeScript formatting without fixing
format-check-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Checking TypeScript formatting with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run format:check
	@echo "$(GREEN)✓ Format check passed$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Checking TypeScript formatting with npm...$(NC)"
	@npm run format:check
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# =============================================================================
# Testing
# =============================================================================

# Run TypeScript tests
test-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Running TypeScript tests with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run test:run
	@echo "$(GREEN)✓ Tests passed$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Running TypeScript tests with npm...$(NC)"
	@npm run test:run
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# Run TypeScript tests with coverage
test-coverage-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Running TypeScript tests with coverage (Docker)...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run test:coverage
	@echo "$(GREEN)✓ Tests with coverage complete$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Running TypeScript tests with coverage (npm)...$(NC)"
	@npm run test:coverage
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# =============================================================================
# Type Checking & Building
# =============================================================================

# Run TypeScript type checking
typecheck-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Type checking TypeScript code with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) run --rm frontend-dev npm run typecheck
	@echo "$(GREEN)✓ Type check passed$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Type checking TypeScript code with npm...$(NC)"
	@npm run typecheck
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# Build production bundle
build-typescript:
ifdef HAS_DOCKER
	@echo "$(CYAN)Building TypeScript production bundle with Docker...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) build --target builder
	@echo "$(GREEN)✓ Production build complete$(NC)"
else ifdef HAS_NPM
	@echo "$(YELLOW)Building TypeScript production bundle with npm...$(NC)"
	@npm run build
else
	@echo "$(RED)❌ Neither Docker nor npm found$(NC)"
	@exit 1
endif

# =============================================================================
# Combined Checks
# =============================================================================

# Run all TypeScript checks (lint + typecheck + test)
typescript-check: lint-typescript typecheck-typescript test-typescript
	@echo "$(GREEN)✅ All TypeScript checks passed$(NC)"

# =============================================================================
# Cleanup
# =============================================================================

# Clean Docker containers, volumes, and build artifacts
typescript-clean:
ifdef HAS_DOCKER
	@echo "$(CYAN)Cleaning TypeScript Docker resources...$(NC)"
	@docker compose -f $(TYPESCRIPT_COMPOSE_FILE) down -v --remove-orphans
	@echo "$(GREEN)✓ Docker cleanup complete$(NC)"
endif
ifdef HAS_NPM
	@echo "$(CYAN)Cleaning TypeScript build artifacts...$(NC)"
	@rm -rf dist coverage .vitest .eslintcache
	@echo "$(GREEN)✓ Build cleanup complete$(NC)"
endif

# =============================================================================
# Legacy Aliases (for backward compatibility)
# =============================================================================

lint-ts: lint-typescript
format-ts: format-typescript
format-check-ts: format-check-typescript
test-ts: test-typescript
test-coverage-ts: test-coverage-typescript
typecheck-ts: typecheck-typescript
ts-check: typescript-check
