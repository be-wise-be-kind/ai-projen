# Python Language Plugin

**Purpose**: Complete Python development environment with linting, formatting, type checking, security scanning, and testing

**Status**: ✅ Stable

---

## What This Plugin Provides

A production-ready Python development setup based on modern best practices and real-world configurations from the [durable-code-test](https://github.com/steve-e-jackson/durable-code-test) reference implementation.

### Tools Included

1. **Ruff** - Fast all-in-one linter and formatter
   - Replaces: Black, isort, flake8, and parts of pylint
   - 10-100x faster than traditional Python tools
   - Single configuration for linting + formatting

2. **MyPy** - Static type checker
   - Catches type errors before runtime
   - Enforces type hints for better code quality
   - Configurable strictness levels

3. **Bandit** - Security vulnerability scanner
   - Detects common security issues
   - Finds hardcoded secrets, SQL injection risks, etc.
   - Integrated into CI/CD pipeline

4. **Pytest** - Testing framework
   - Industry-standard testing tool
   - Async support, fixtures, parametrization
   - Coverage reporting with pytest-cov

### Configuration Files

All configurations are pre-tuned for Python 3.11+ projects:

```
python/
├── linters/
│   ├── ruff/
│   │   └── config/pyproject.toml    # Ruff linting + formatting rules
│   ├── mypy/
│   │   └── config/mypy.ini          # MyPy type checking config
│   └── bandit/
│       └── config/.bandit           # Bandit security scan config
├── testing/
│   └── pytest/
│       └── config/pytest.ini        # Pytest test configuration
├── templates/
│   ├── makefile-python.mk           # Make targets for Python
│   ├── github-workflow-python.yml   # GitHub Actions workflow
│   ├── example.py                   # Example Python module
│   └── test_example.py              # Example test file
└── standards/
    └── python-standards.md          # PEP 8 + best practices
```

## Quick Start

**IMPORTANT**: This plugin follows the Docker-first development pattern established in PR7.5.

See `.ai/docs/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` for complete details.

### Docker-First Approach (Recommended)

1. **Copy Docker templates**:
   ```bash
   mkdir -p .docker/dockerfiles .docker/compose
   cp plugins/languages/python/templates/Dockerfile.python .docker/dockerfiles/Dockerfile.backend
   cp plugins/languages/python/templates/docker-compose.python.yml .docker/compose/app.yml
   ```

2. **Copy Makefile**:
   ```bash
   cp plugins/languages/python/templates/makefile-python.mk ./Makefile.python
   echo "-include Makefile.python" >> Makefile
   ```

3. **Configure in pyproject.toml**:
   ```bash
   # Copy base configuration (or merge into existing pyproject.toml)
   cp plugins/languages/python/linters/ruff/config/pyproject.toml ./
   ```

4. **Start developing**:
   ```bash
   make python-install  # Build Docker images
   make dev-python      # Start development environment
   make lint-python     # Lint in container
   make test-python     # Test in container
   ```

### Poetry Fallback (When Docker Unavailable)

1. **Install dependencies**:
   ```bash
   poetry add --group dev ruff mypy bandit pytest pytest-asyncio pytest-cov
   ```

2. **Copy configurations**:
   ```bash
   cp plugins/languages/python/linters/ruff/config/pyproject.toml ./
   ```

3. **Add Makefile**:
   ```bash
   cp plugins/languages/python/templates/makefile-python.mk ./Makefile.python
   echo "-include Makefile.python" >> Makefile
   ```

4. **Run tools**:
   ```bash
   make lint-python     # Auto-uses Poetry if Docker unavailable
   make test-python
   ```

### For AI Agents

Follow the comprehensive instructions in `AGENT_INSTRUCTIONS.md`:

```bash
cat plugins/languages/python/AGENT_INSTRUCTIONS.md
# Then follow Steps 1-12
```

## Available Commands

All Make targets support automatic environment detection (Docker → Poetry → Direct).

### Make Targets

```bash
# Development
make dev-python               # Start dev environment (Docker-first)
make dev-stop-python          # Stop dev environment

# Quality checks (Docker-first with auto-detection)
make lint-python              # Run Ruff linting
make lint-fix-python          # Auto-fix linting issues
make format-python            # Format code with Ruff
make typecheck                # Run MyPy type checking
make security-scan            # Run Bandit security scanner

# Testing (Docker-first with auto-detection)
make test-python              # Run all tests
make test-coverage-python     # Run tests with coverage report
make test-unit-python         # Run only unit tests
make test-integration-python  # Run only integration tests

# Combined
make python-check             # Run all checks (lint + type + security + test)

# Utilities
make python-install           # Install/build dependencies (environment-aware)
make clean-python             # Clean cache files and containers
make help-python              # Show Python-specific help with environment info
```

**Environment Auto-Detection**: All targets automatically detect and use:
1. Docker (if available) - runs in containers
2. Poetry (if Docker unavailable) - uses virtual environment
3. Direct local (last resort) - direct tool execution

### Direct Tool Usage (Not Recommended - Use Make Targets)

If you must use tools directly, the Makefile auto-detection ensures consistency:

**Docker Environment**:
```bash
# Tools run in containers automatically via make targets
make lint-python  # Runs: docker exec ... ruff check .
```

**Poetry Environment**:
```bash
# Tools run via Poetry automatically via make targets
make lint-python  # Runs: poetry run ruff check .
```

**Direct Local**:
```bash
# Only if Docker and Poetry unavailable
ruff check .      # Direct execution
mypy .
bandit -r .
pytest
```

**Recommendation**: Always use `make` targets for consistency across environments.

## How-To Guides

The Python plugin includes comprehensive step-by-step guides for common development tasks. All guides follow the Docker-first development pattern with automatic environment detection.

### API Development
- **[Create an API Endpoint](howtos/how-to-create-an-api-endpoint.md)** - FastAPI endpoints with automatic documentation and Docker testing (30-45 min, Intermediate)
- **[Add Database Model](howtos/how-to-add-database-model.md)** - SQLAlchemy models with Alembic migrations in Docker (60-90 min, Advanced)
- **[Handle Authentication](howtos/how-to-handle-authentication.md)** - OAuth2/JWT implementation with secure password handling (90-120 min, Advanced)

### CLI Development
- **[Create a CLI Command](howtos/how-to-create-a-cli-command.md)** - Click/Typer command-line tools with Docker execution (45-60 min, Intermediate)

### Testing
- **[Write a Test](howtos/how-to-write-a-test.md)** - pytest test cases with Docker support and coverage (45-60 min, Intermediate)

### Background Jobs
- **[Add Background Job](howtos/how-to-add-background-job.md)** - Celery/RQ async tasks with Redis and Docker (60-90 min, Advanced)

### What's Included in Each Guide

All how-tos include:
- **Step-by-step instructions** - Clear, actionable steps from start to finish
- **Code templates** - Ready-to-use templates with placeholders
- **Docker-first examples** - Commands for Docker, Poetry, and direct execution
- **Verification steps** - How to test that everything works
- **Common issues and solutions** - Troubleshooting help
- **Best practices** - Industry-standard patterns and security considerations
- **Complete checklists** - Ensure nothing is missed

See [howtos/README.md](howtos/README.md) for the complete guide index with quick reference by use case, difficulty, and time commitment.

## Code Templates

The plugin provides ready-to-use templates for common patterns:

**API & Database**:
- `templates/fastapi-router.py.template` - Complete FastAPI router module
- `templates/sqlalchemy-model.py.template` - SQLAlchemy ORM model
- `templates/pydantic-schema.py.template` - Pydantic validation schemas

**CLI Tools**:
- `templates/click-command.py.template` - Click CLI command
- `templates/typer-command.py.template` - Typer CLI command with rich output

**Testing**:
- `templates/pytest-test.py.template` - pytest test file with AAA pattern

**Background Jobs**:
- `templates/celery-task.py.template` - Celery task with retry logic

**Using Templates**:
```bash
# Copy template
cp plugins/languages/python/templates/fastapi-router.py.template backend/app/your_module.py

# Replace placeholders like {{MODULE_NAME}}, {{MODEL_NAME}}, etc.
# Follow template comments for customization
```

All templates include:
- Purpose and scope documentation
- Placeholder variables for customization
- Example code and comments
- Type hints and proper structure

## Python Standards

This plugin enforces:

- **PEP 8** compliance with 120 character line length
- **Type hints** required for all function signatures
- **Google-style docstrings** for documentation
- **Maximum complexity** of 10 (McCabe)
- **Security best practices** (no hardcoded secrets, parameterized queries)
- **Modern Python 3.11+** features and idioms

See `standards/python-standards.md` for complete guidelines.

## CI/CD Integration

### GitHub Actions

Copy the workflow template:

```bash
mkdir -p .github/workflows
cp plugins/languages/python/templates/github-workflow-python.yml .github/workflows/python.yml
```

The workflow includes:
- Ruff linting and formatting checks
- MyPy type checking
- Bandit security scanning
- Pytest with coverage reporting
- Artifact uploads for coverage reports
- Optimized caching for fast builds

## Example Code

See `templates/example.py` and `templates/test_example.py` for examples of:
- Proper code structure and style
- Type hints usage
- Google-style docstrings
- Dataclasses
- Error handling
- Pytest test patterns
- Fixtures and parametrization

## Integration with Other Plugins

### Docker Plugin (Included)
This plugin includes complete Docker support:

```bash
# Docker templates already provided
templates/Dockerfile.python              # Multi-stage build (dev, lint, test, prod)
templates/docker-compose.python.yml      # Docker Compose configuration
templates/makefile-python.mk             # Docker-first Makefile with auto-detection

# Copy and use:
make python-install  # Builds Docker images
make dev-python      # Starts containers
```

### Pre-commit Hooks Plugin
If using pre-commit, add to `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: ruff
        name: Ruff
        entry: make lint-python
        language: system
        pass_filenames: false
```

### Security Plugin
Bandit integrates with security scanning workflows via `make security-scan`

## Why These Tools?

### Ruff vs Traditional Tools

**Traditional Stack**:
- Black (formatting)
- isort (import sorting)
- flake8 (linting)
- pylint (advanced linting)
- Result: 4 tools, 4 configs, slow execution

**Ruff**:
- All-in-one tool
- 10-100x faster
- Single configuration
- Black-compatible
- Active development

### MyPy vs Alternatives

- **MyPy**: Most mature, PEP 484 reference implementation
- **Pyright**: Fast but less configurable
- **Pyre**: Facebook's checker, less community support

We chose MyPy for maturity and community adoption.

### Pytest vs Unittest

- **Pytest**: Feature-rich, fixtures, parametrization, plugins
- **Unittest**: Built-in but more verbose, fewer features

Pytest is the industry standard for good reason.

## Dependencies

- **Python**: 3.11 or higher
- **Package Manager**: Poetry (recommended) or pip
- **Git**: For version control
- **Make**: For task automation (optional but recommended)

## Support and Contribution

- **Documentation**: See `AGENT_INSTRUCTIONS.md` for detailed setup
- **Standards**: See `standards/python-standards.md` for coding guidelines
- **Examples**: See `templates/` for example code and tests
- **Issues**: Report issues to ai-projen repository

## License

Part of the ai-projen framework. See main repository for license details.

---

**Version**: 1.0.0
**Last Updated**: 2025-10-01
**Based On**: [durable-code-test](https://github.com/steve-e-jackson/durable-code-test) reference implementation
