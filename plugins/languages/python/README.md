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

### For AI Agents

Follow the comprehensive instructions in `AGENT_INSTRUCTIONS.md`:

```bash
# AI agents should execute:
cat plugins/languages/python/AGENT_INSTRUCTIONS.md
# Then follow Steps 1-12
```

### For Humans

1. **Install dependencies**:
   ```bash
   # Using Poetry (recommended)
   poetry add --group dev ruff mypy bandit pytest pytest-asyncio pytest-cov

   # Or using pip
   pip install ruff mypy bandit pytest pytest-asyncio pytest-cov
   ```

2. **Copy configurations**:
   ```bash
   # Copy all config files to project root
   cp plugins/languages/python/linters/ruff/config/pyproject.toml ./
   cp plugins/languages/python/linters/mypy/config/mypy.ini ./
   cp plugins/languages/python/linters/bandit/config/.bandit ./
   cp plugins/languages/python/testing/pytest/config/pytest.ini ./
   ```

3. **Add Makefile targets**:
   ```bash
   # Option 1: Include Python Makefile
   echo "-include Makefile.python" >> Makefile
   cp plugins/languages/python/templates/makefile-python.mk ./Makefile.python

   # Option 2: Copy targets directly
   cat plugins/languages/python/templates/makefile-python.mk >> Makefile
   ```

4. **Create tests directory**:
   ```bash
   mkdir -p tests
   touch tests/__init__.py
   ```

5. **Verify installation**:
   ```bash
   make lint-python
   make typecheck
   make security-scan
   make test-python
   ```

## Available Commands

### Make Targets

```bash
# Quality checks
make lint-python              # Run Ruff linting
make format-python            # Format code with Ruff
make format-check-python      # Check formatting without changes
make typecheck                # Run MyPy type checking
make security-scan            # Run Bandit security scanner

# Testing
make test-python              # Run all tests
make test-coverage-python     # Run tests with coverage report
make test-unit-python         # Run only unit tests
make test-integration-python  # Run only integration tests

# Combined
make python-check             # Run all checks (lint + type + security + test)

# Utilities
make python-install           # Install dependencies
make clean-python             # Clean cache files
make help-python              # Show Python-specific help
```

### Direct Tool Usage

```bash
# Ruff
ruff check .                  # Lint code
ruff check --fix .            # Auto-fix issues
ruff format .                 # Format code
ruff format --check .         # Check formatting

# MyPy
mypy .                        # Type check all files
mypy src/                     # Type check specific directory

# Bandit
bandit -r .                   # Security scan
bandit -r . -ll              # Only high severity
bandit -r . -q               # Quiet mode

# Pytest
pytest                        # Run all tests
pytest -v                     # Verbose output
pytest --cov=src             # With coverage
pytest -m unit               # Only unit tests
```

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

### Pre-commit Hooks
Add to `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: ruff
        name: Ruff
        entry: ruff check --fix
        language: system
        types: [python]
      - id: mypy
        name: MyPy
        entry: mypy
        language: system
        types: [python]
```

### Docker
Add to `Dockerfile`:
```dockerfile
FROM python:3.11-slim
RUN pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-dev
```

### Security Plugin
Bandit integrates with security scanning workflows

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
