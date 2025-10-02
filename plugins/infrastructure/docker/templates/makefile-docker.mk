# Purpose: Docker infrastructure Make targets for containerized development
# Scope: Common Docker operations for building, running, and managing containers
# Overview: Provides convenient Make targets for Docker and docker-compose operations.
#     Includes targets for building images, starting/stopping services, viewing logs,
#     executing commands in containers, and cleanup operations. Supports multi-stage
#     builds with separate targets for dev, lint, test, and production.
# Dependencies: Docker, Docker Compose, Dockerfiles, docker-compose.yml
# Usage: make <target> (e.g., make docker-up, make docker-logs)

# ==============================================================================
# Docker Configuration
# ==============================================================================

# Project name (override with environment variable or in main Makefile)
PROJECT_NAME ?= app

# Docker Compose file
COMPOSE_FILE ?= docker-compose.yml

# Dockerfile paths
DOCKERFILE_BACKEND ?= .docker/dockerfiles/Dockerfile.backend
DOCKERFILE_FRONTEND ?= .docker/dockerfiles/Dockerfile.frontend

# ==============================================================================
# Docker Build Targets
# ==============================================================================

.PHONY: docker-build
docker-build: ## Build all Docker images (dev target)
	@echo "Building all Docker images..."
	docker compose -f $(COMPOSE_FILE) build

.PHONY: docker-build-backend
docker-build-backend: ## Build backend Docker image
	@echo "Building backend Docker image..."
	docker build --target dev -t $(PROJECT_NAME)-backend:dev -f $(DOCKERFILE_BACKEND) .

.PHONY: docker-build-frontend
docker-build-frontend: ## Build frontend Docker image
	@echo "Building frontend Docker image..."
	docker build --target dev -t $(PROJECT_NAME)-frontend:dev -f $(DOCKERFILE_FRONTEND) .

.PHONY: docker-build-prod
docker-build-prod: ## Build production Docker images
	@echo "Building production Docker images..."
	docker build --target prod -t $(PROJECT_NAME)-backend:prod -f $(DOCKERFILE_BACKEND) .
	docker build --target prod -t $(PROJECT_NAME)-frontend:prod -f $(DOCKERFILE_FRONTEND) .

.PHONY: docker-build-test
docker-build-test: ## Build test Docker images
	@echo "Building test Docker images..."
	docker build --target test -t $(PROJECT_NAME)-backend:test -f $(DOCKERFILE_BACKEND) .
	docker build --target test -t $(PROJECT_NAME)-frontend:test -f $(DOCKERFILE_FRONTEND) .

.PHONY: docker-build-lint
docker-build-lint: ## Build lint Docker images
	@echo "Building lint Docker images..."
	docker build --target lint -t $(PROJECT_NAME)-backend:lint -f $(DOCKERFILE_BACKEND) .
	docker build --target lint -t $(PROJECT_NAME)-frontend:lint -f $(DOCKERFILE_FRONTEND) .

# ==============================================================================
# Docker Compose Operations
# ==============================================================================

.PHONY: docker-up
docker-up: ## Start all services with docker-compose
	@echo "Starting all services..."
	docker compose -f $(COMPOSE_FILE) up -d
	@echo "Services started. View logs with: make docker-logs"

.PHONY: docker-up-build
docker-up-build: ## Start all services and rebuild images
	@echo "Starting all services with rebuild..."
	docker compose -f $(COMPOSE_FILE) up -d --build

.PHONY: docker-down
docker-down: ## Stop all services
	@echo "Stopping all services..."
	docker compose -f $(COMPOSE_FILE) down

.PHONY: docker-down-volumes
docker-down-volumes: ## Stop all services and remove volumes
	@echo "Stopping all services and removing volumes..."
	docker compose -f $(COMPOSE_FILE) down -v

.PHONY: docker-restart
docker-restart: ## Restart all services
	@echo "Restarting all services..."
	docker compose -f $(COMPOSE_FILE) restart

.PHONY: docker-ps
docker-ps: ## Show running containers
	@echo "Running containers:"
	docker compose -f $(COMPOSE_FILE) ps

# ==============================================================================
# Container Access
# ==============================================================================

.PHONY: docker-shell-backend
docker-shell-backend: ## Open shell in backend container
	@echo "Opening shell in backend container..."
	docker compose -f $(COMPOSE_FILE) exec backend-dev /bin/bash

.PHONY: docker-shell-frontend
docker-shell-frontend: ## Open shell in frontend container
	@echo "Opening shell in frontend container..."
	docker compose -f $(COMPOSE_FILE) exec frontend-dev /bin/sh

.PHONY: docker-exec-backend
docker-exec-backend: ## Execute command in backend (usage: make docker-exec-backend CMD="python --version")
	@docker compose -f $(COMPOSE_FILE) exec backend-dev $(CMD)

.PHONY: docker-exec-frontend
docker-exec-frontend: ## Execute command in frontend (usage: make docker-exec-frontend CMD="npm --version")
	@docker compose -f $(COMPOSE_FILE) exec frontend-dev $(CMD)

# ==============================================================================
# Logs and Monitoring
# ==============================================================================

.PHONY: docker-logs
docker-logs: ## View logs from all services
	docker compose -f $(COMPOSE_FILE) logs -f

.PHONY: docker-logs-backend
docker-logs-backend: ## View backend logs
	docker compose -f $(COMPOSE_FILE) logs -f backend-dev

.PHONY: docker-logs-frontend
docker-logs-frontend: ## View frontend logs
	docker compose -f $(COMPOSE_FILE) logs -f frontend-dev

# ==============================================================================
# Testing in Docker
# ==============================================================================

.PHONY: docker-test
docker-test: ## Run tests in Docker containers
	@echo "Running tests in Docker..."
	docker compose run --rm backend-test || true
	docker compose run --rm frontend-test || true

.PHONY: docker-test-backend
docker-test-backend: ## Run backend tests in Docker
	@echo "Running backend tests..."
	docker compose run --rm backend-test

.PHONY: docker-test-frontend
docker-test-frontend: ## Run frontend tests in Docker
	@echo "Running frontend tests..."
	docker compose run --rm frontend-test

# ==============================================================================
# Linting in Docker
# ==============================================================================

.PHONY: docker-lint
docker-lint: ## Run linting in Docker containers
	@echo "Running linting in Docker..."
	docker compose run --rm backend-lint make lint-python || true
	docker compose run --rm frontend-lint npm run lint || true

.PHONY: docker-lint-backend
docker-lint-backend: ## Run backend linting in Docker
	@echo "Running backend linting..."
	docker compose run --rm backend-lint make lint-python

.PHONY: docker-lint-frontend
docker-lint-frontend: ## Run frontend linting in Docker
	@echo "Running frontend linting..."
	docker compose run --rm frontend-lint npm run lint

# ==============================================================================
# Cleanup
# ==============================================================================

.PHONY: docker-clean
docker-clean: ## Remove all containers, networks, and images
	@echo "Cleaning up Docker resources..."
	docker compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans

.PHONY: docker-clean-images
docker-clean-images: ## Remove all project images
	@echo "Removing project Docker images..."
	docker images | grep $(PROJECT_NAME) | awk '{print $$3}' | xargs -r docker rmi -f

.PHONY: docker-clean-volumes
docker-clean-volumes: ## Remove all project volumes
	@echo "Removing project volumes..."
	docker volume ls | grep $(PROJECT_NAME) | awk '{print $$2}' | xargs -r docker volume rm

.PHONY: docker-prune
docker-prune: ## Prune unused Docker resources (system-wide)
	@echo "Pruning unused Docker resources..."
	docker system prune -af --volumes

# ==============================================================================
# Rebuild
# ==============================================================================

.PHONY: docker-rebuild
docker-rebuild: docker-clean docker-build docker-up ## Clean rebuild of all services
	@echo "Complete rebuild finished!"

.PHONY: docker-rebuild-backend
docker-rebuild-backend: ## Clean rebuild of backend service
	@echo "Rebuilding backend..."
	docker compose -f $(COMPOSE_FILE) stop backend-dev
	docker compose -f $(COMPOSE_FILE) rm -f backend-dev
	docker compose -f $(COMPOSE_FILE) build backend-dev
	docker compose -f $(COMPOSE_FILE) up -d backend-dev

.PHONY: docker-rebuild-frontend
docker-rebuild-frontend: ## Clean rebuild of frontend service
	@echo "Rebuilding frontend..."
	docker compose -f $(COMPOSE_FILE) stop frontend-dev
	docker compose -f $(COMPOSE_FILE) rm -f frontend-dev
	docker compose -f $(COMPOSE_FILE) build frontend-dev
	docker compose -f $(COMPOSE_FILE) up -d frontend-dev

# ==============================================================================
# Health Checks
# ==============================================================================

.PHONY: docker-health
docker-health: ## Check health status of all services
	@echo "Checking service health..."
	@docker compose -f $(COMPOSE_FILE) ps --format json | jq -r '.[] | "\(.Name): \(.Health)"'

# ==============================================================================
# Development Helpers
# ==============================================================================

.PHONY: docker-dev
docker-dev: docker-build docker-up docker-logs ## Full development environment (build, start, logs)

.PHONY: docker-stop
docker-stop: docker-down ## Alias for docker-down

.PHONY: docker-config
docker-config: ## Validate and view docker-compose configuration
	@echo "Docker Compose configuration:"
	docker compose -f $(COMPOSE_FILE) config

# ==============================================================================
# Help
# ==============================================================================

.PHONY: docker-help
docker-help: ## Show Docker-related make targets
	@echo "Docker Make Targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; /^docker-/ {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
