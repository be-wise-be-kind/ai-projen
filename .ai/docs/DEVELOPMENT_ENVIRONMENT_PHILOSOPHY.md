# Development Environment Philosophy

**Purpose**: Define the development environment hierarchy and priorities for AI-Projen

**Scope**: Development, linting, testing, and production environments

**Overview**: This document establishes Docker-first development as the standard pattern for AI-Projen
    projects. It defines a three-tier hierarchy: Docker (preferred), isolated environments (fallback),
    and direct local execution (last resort). This ensures consistent, reproducible environments while
    avoiding local environment pollution.

**Dependencies**: Docker, Docker Compose, language-specific package managers (Poetry, npm)

**Exports**: Development environment standards and decision tree for tool execution

**Related**: Plugin templates, Makefiles, language standards documents

**Implementation**: Auto-detection in Makefiles with graceful fallback across the hierarchy

---

## Environment Hierarchy

AI-Projen enforces a strict three-tier hierarchy for development environments:

### 1. Docker (Preferred) 🐳

**Priority**: FIRST CHOICE
**Use When**: Docker is available (95% of cases)

**Benefits**:
- ✅ Consistent environments across team members and CI/CD
- ✅ Zero local environment pollution
- ✅ Isolated dependencies prevent version conflicts
- ✅ Multi-stage builds support dev, lint, test, and prod
- ✅ Easy cleanup with `docker compose down -v`
- ✅ Works identically on macOS, Linux, and Windows

**How It Works**:
```bash
# Development with hot reload
make dev  # Starts Docker containers with volume mounts

# Linting in dedicated container
make lint-all  # Runs all linters in isolated containers

# Testing in dedicated container
make test  # Executes tests in fresh environment
```

### 2. Isolated Environments (Fallback) 📦

**Priority**: SECOND CHOICE
**Use When**: Docker unavailable, but project isolation tools exist

**Tools**:
- **Python**: Poetry virtual environments, venv
- **TypeScript**: npm with local node_modules
- **Rust**: Cargo workspaces
- **Go**: Go modules

**Benefits**:
- ✅ Project-isolated dependencies
- ✅ Reproducible builds via lock files
- ⚠️ Still some local environment impact
- ⚠️ Platform-dependent behavior possible

**How It Works**:
```bash
# Python with Poetry
poetry install
poetry run pytest

# TypeScript with npm
npm ci
npm run lint
```

### 3. Direct Local (Last Resort) ⚠️

**Priority**: LAST RESORT
**Use When**: No Docker, no isolation tools available

**Risks**:
- ❌ Pollutes global environment
- ❌ Version conflicts between projects
- ❌ "Works on my machine" problems
- ❌ Difficult to reproduce CI/CD locally
- ❌ Hard to clean up

**How It Works**:
```bash
# Direct Python execution (not recommended)
pip install -r requirements.txt  # ❌ Pollutes global Python
pytest

# Direct TypeScript execution
npm install -g eslint  # ❌ Pollutes global Node
```

---

## Decision Tree

```
┌─────────────────────────────────────┐
│  Need to run development/lint/test? │
└─────────────────┬───────────────────┘
                  │
                  ▼
          ┌───────────────┐
          │ Docker installed? │
          └───────┬───────────┘
                  │
         ┌────────┴────────┐
         │ YES             │ NO
         ▼                 ▼
    ┌─────────┐      ┌──────────────┐
    │ Use     │      │ Isolated env │
    │ Docker  │      │ available?   │
    │ ✅      │      └──────┬───────┘
    └─────────┘             │
                   ┌────────┴────────┐
                   │ YES             │ NO
                   ▼                 ▼
              ┌──────────┐     ┌──────────┐
              │ Use      │     │ Use      │
              │ Poetry/  │     │ Direct   │
              │ npm      │     │ Local ⚠️ │
              │ ✅       │     └──────────┘
              └──────────┘
```

---

## Implementation in Plugins

### Makefile Auto-Detection

All language plugins implement automatic detection:

```makefile
# Auto-detect environment type
HAS_DOCKER := $(shell command -v docker 2>/dev/null)
HAS_POETRY := $(shell command -v poetry 2>/dev/null)

# Development target with automatic fallback
dev:
ifdef HAS_DOCKER
	@echo "Using Docker (preferred)"
	@docker compose -f docker-compose.dev.yml up
else ifdef HAS_POETRY
	@echo "Using Poetry (fallback)"
	@poetry install && poetry run uvicorn app.main:app --reload
else
	@echo "WARNING: Using direct local (not recommended)"
	@pip install -r requirements.txt && uvicorn app.main:app --reload
endif
```

### Multi-Stage Dockerfiles

All Docker-based environments use multi-stage builds:

```dockerfile
# Shared base layer
FROM python:3.11-slim AS base
RUN pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry install --only main

# Dev stage with hot reload
FROM base AS dev
RUN poetry install
COPY . .
CMD ["uvicorn", "app.main:app", "--reload"]

# Lint stage with all tools
FROM base AS lint
RUN poetry install && apt-get install -y shellcheck
CMD ["tail", "-f", "/dev/null"]

# Test stage
FROM base AS test
RUN poetry install
COPY . .
CMD ["pytest"]

# Production stage (minimal)
FROM base AS prod
COPY app ./app
CMD ["uvicorn", "app.main:app"]
```

---

## Benefits of Docker-First

### For Developers
- **Onboarding**: New developers run `make init && make dev` - zero configuration
- **Consistency**: Code that works on your machine works everywhere
- **Cleanup**: `make clean` removes everything - no leftover dependencies
- **Isolation**: Work on multiple projects without version conflicts

### For CI/CD
- **Parity**: Local environment matches CI/CD exactly
- **Speed**: Docker layer caching speeds up builds
- **Debugging**: Reproduce CI issues locally with same containers
- **Matrix Testing**: Test multiple Python/Node versions easily

### For Production
- **Deployment**: Same Dockerfile from dev to prod
- **Security**: Minimal production images (no dev tools)
- **Scaling**: Container orchestration (ECS, Kubernetes)
- **Rollback**: Immutable image tags enable instant rollback

---

## Common Patterns

### Development with Hot Reload

```yaml
# docker-compose.dev.yml
services:
  backend-dev:
    build:
      target: dev
    volumes:
      - ./app:/app  # Mount source for hot reload
    command: uvicorn app.main:app --reload
```

### Dedicated Linting Containers

```yaml
# docker-compose.lint.yml
services:
  python-linter:
    build:
      target: lint
    volumes:
      - .:/workspace  # Mount entire project
    command: tail -f /dev/null  # Keep running for make targets
```

### Parallel Linting

```makefile
lint-all:
	@make -j3 lint-python lint-js lint-infra
```

---

## When NOT to Use Docker

Docker-first is preferred, but there are exceptions:

### Skip Docker When:
1. **CI runners without Docker**: Use isolated environments instead
2. **Resource-constrained machines**: Poetry/venv may be lighter
3. **Docker daemon unavailable**: Corporate restrictions, shared hosting
4. **Native performance critical**: Some ML training prefers native CUDA

### Graceful Degradation:
Always implement fallback in Makefiles - never force Docker as hard requirement.

---

## Migration Strategy

### For Existing Projects

1. **Add Docker support** without removing existing workflows:
   ```bash
   make dev          # New: Docker-based
   poetry run dev    # Old: Still works
   ```

2. **Document both paths** in README:
   ```markdown
   ## Quick Start

   ### Docker (Recommended)
   make dev

   ### Poetry (Alternative)
   poetry install && poetry run dev
   ```

3. **Update CI/CD** to use Docker for consistency

4. **Provide escape hatch** for edge cases

---

## References

- **Example**: durable-code-test repository demonstrates full Docker-first pattern
- **Dockerfiles**: `.docker/dockerfiles/` with multi-stage builds
- **Compose**: `.docker/compose/` with dev, lint, test configurations
- **Makefiles**: `Makefile` with auto-detection and graceful fallback
