# Ruff Linter - Agent Instructions

**Purpose**: Install and configure Ruff for Python linting and formatting

**Scope**: Ruff linter and formatter setup

**Overview**: Ruff is a fast Python linter written in Rust that replaces Black, isort, flake8,
    and parts of pylint. It provides both linting and formatting in a single tool.

**Dependencies**: Python 3.11+, pip or poetry

---

## Installation Steps

### Step 1: Install Ruff

Add Ruff to your Python dependencies:

**Using pip**:
```bash
pip install ruff
```

**Using poetry** (recommended):
```bash
poetry add --group dev ruff
```

**Using requirements-dev.txt**:
```
ruff>=0.13.0
```

### Step 2: Copy Configuration

Copy the Ruff configuration to your project:

```bash
# If pyproject.toml doesn't exist, copy the entire file
cp plugins/languages/python/linters/ruff/config/pyproject.toml ./pyproject.toml

# If pyproject.toml already exists, append the [tool.ruff] sections
# Read the config file and merge the sections into existing pyproject.toml
```

**Important**: If `pyproject.toml` already exists, merge the `[tool.ruff]`, `[tool.ruff.format]`,
and `[tool.ruff.lint]` sections into the existing file.

### Step 3: Add Scripts (if using package.json equivalent)

For Poetry, you can add scripts in `pyproject.toml`:

```toml
[tool.poetry.scripts]
lint = "ruff check ."
format = "ruff format ."
```

Or create a Makefile target (see main Python plugin instructions).

### Step 4: Verify Installation

Test that Ruff is working:

```bash
# Check version
ruff --version

# Run linting
ruff check .

# Check formatting
ruff format --check .

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

## Integration with Make

Add to your Makefile:

```makefile
.PHONY: lint-python format-python

lint-python:
	ruff check .

format-python:
	ruff format .

lint-fix-python:
	ruff check --fix . && ruff format .
```

## Success Criteria

Ruff is successfully installed when:
- ✅ `ruff --version` works
- ✅ `pyproject.toml` contains `[tool.ruff]` configuration
- ✅ `ruff check .` runs without errors (or shows expected violations)
- ✅ `ruff format --check .` runs without errors
- ✅ Make targets work (if Makefile integration completed)
