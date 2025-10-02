# Ruff Linter - Agent Instructions

**Purpose**: Install and configure Ruff for Python linting and formatting

**Scope**: Ruff linter and formatter setup

**Overview**: Ruff is a fast Python linter written in Rust that replaces Black, isort, flake8,
    and parts of pylint. It provides both linting and formatting in a single tool.

**Dependencies**: Python 3.11+, pip or poetry

---

## Environment Strategy

**IMPORTANT**: Follow the Docker-first development hierarchy:

1. **Docker (Preferred)** 🐳
   - Run Ruff in containers via `make lint-python` (auto-detects Docker)
   - Consistent across all environments
   - Zero local environment pollution
   - See: `.ai/docs/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`

2. **Poetry (Fallback)** 📦
   - Use Poetry virtual environment when Docker unavailable
   - Makefile automatically detects and uses Poetry
   - Still provides project isolation

3. **Direct Local (Last Resort)** ⚠️
   - Only when Docker AND Poetry unavailable
   - Risk of environment pollution
   - Not recommended for team environments

---

## Installation Steps

### Step 1: Configure in pyproject.toml

**All configuration goes in `pyproject.toml`** (works in Docker and locally):

```bash
# If pyproject.toml doesn't exist, copy the entire file
cp plugins/languages/python/linters/ruff/config/pyproject.toml ./pyproject.toml

# If pyproject.toml already exists, append the [tool.ruff] sections
# Read the config file and merge the sections into existing pyproject.toml
```

**Important**: If `pyproject.toml` already exists, merge the `[tool.ruff]`, `[tool.ruff.format]`,
and `[tool.ruff.lint]` sections into the existing file.

### Step 2: Install Based on Environment

**Docker-First Approach (Recommended)**:

```bash
# Build Docker images with all Python tools including Ruff
make python-install  # Builds Docker images

# Run linting in container (auto-detects environment)
make lint-python     # Uses Docker if available
```

**Poetry Fallback** (if Docker unavailable):

```bash
poetry add --group dev ruff
poetry run ruff check .
```

**Direct Local** (if neither Docker nor Poetry available):

```bash
pip install ruff
ruff check .
```

### Step 3: Verify Installation

**Docker Approach**:
```bash
# Verify Docker images built
docker images | grep python-linter

# Run linting in container
make lint-python

# Auto-fix in container
make lint-fix-python
```

**Poetry Approach**:
```bash
# Check version
poetry run ruff --version

# Run linting
poetry run ruff check .

# Check formatting
poetry run ruff format --check .
```

**Direct Local Approach**:
```bash
# Check version
ruff --version

# Run linting
ruff check .

# Auto-fix issues
ruff check --fix .
ruff format .
```

## What Ruff Provides

### Linting Features
- **Code quality**: Detects bugs, anti-patterns, and code smells
- **Style enforcement**: PEP 8 compliance, naming conventions
- **Security scanning**: Built-in bandit-style security checks
- **Import sorting**: Replaces isort for import organization
- **Complexity checking**: McCabe complexity limits

### Formatting Features
- **Auto-formatting**: Formats code to consistent style (Black-compatible)
- **Line length**: Configurable max line length (default 120)
- **Quote style**: Configurable quote style (default double quotes)
- **Import organization**: Automatically sorts and organizes imports

## Configuration Details

The provided configuration:
- **Target Python**: 3.11+
- **Line length**: 120 characters
- **Selected rules**:
  - E/W: pycodestyle errors and warnings
  - F: pyflakes (imports, undefined names)
  - I: isort (import sorting)
  - B: bugbear (common bugs)
  - C4: comprehensions
  - UP: pyupgrade (modern syntax)
  - N: naming conventions
  - SIM: simplify suggestions
  - S: security (bandit subset)
  - C90: complexity checking
- **Ignored rules**: Line too long (handled by formatter), some FastAPI/testing-specific rules
- **Max complexity**: 10 (configurable)

## Usage Examples

```bash
# Lint all Python files
ruff check .

# Lint specific directory
ruff check src/

# Auto-fix issues
ruff check --fix .

# Format code
ruff format .

# Check formatting without changing files
ruff format --check .

# Lint and format together
ruff check --fix . && ruff format .
```

## Makefile Integration

The Python plugin's Makefile (`makefile-python.mk`) includes automatic environment detection:

```makefile
# From makefile-python.mk (already included in plugin)
lint-python: ## Auto-detects Docker → Poetry → Direct
	# Automatically uses best available environment
	# Priority: Docker > Poetry > Direct local

# Just run this - it works everywhere:
make lint-python
```

**How it works**:
1. Checks if Docker is available → uses linting container
2. Falls back to Poetry if Docker unavailable
3. Falls back to direct `ruff` command if neither available

No need to modify - the Makefile handles environment detection automatically!

## Success Criteria

Ruff is successfully installed when:
- ✅ `pyproject.toml` contains `[tool.ruff]` configuration
- ✅ `make lint-python` runs successfully (in any environment)
- ✅ Docker approach (preferred): Linting runs in container
- ✅ Poetry approach (fallback): `poetry run ruff --version` works
- ✅ Direct approach (last resort): `ruff --version` works
- ✅ Configuration works in all three environments (thanks to pyproject.toml)
