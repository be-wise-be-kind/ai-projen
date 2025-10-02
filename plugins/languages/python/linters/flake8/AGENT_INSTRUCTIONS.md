# Flake8 Linter - Agent Instructions

**Purpose**: Install and configure Flake8 with comprehensive plugin suite for Python style guide enforcement

**Scope**: Style guide enforcement, documentation standards, bug detection, and code simplification

**Overview**: Step-by-step instructions for AI agents to install Flake8 with a comprehensive plugin suite
    including flake8-docstrings, flake8-bugbear, flake8-comprehensions, and flake8-simplify for
    production-ready code quality enforcement.

**Dependencies**: Python 3.11+, pip or poetry

**Exports**: Flake8 configuration with plugins

**Related**: Python linting tooling, PEP 8 compliance

**Implementation**: Configuration-based linting with .flake8

---

## Prerequisites

Before installing Flake8, ensure:
- ✅ Python 3.11+ is installed
- ✅ pip or poetry is available
- ✅ Project has a Python codebase to lint

## What is Flake8?

Flake8 is a Python style guide enforcement tool that:
- Combines PyFlakes, pycodestyle, and McCabe complexity checker
- Enforces PEP 8 style guide
- Extensible via plugins
- Fast and lightweight

**Flake8 Plugin Suite**:
- **flake8-docstrings**: Enforces Google-style docstrings
- **flake8-bugbear**: Detects likely bugs and design problems
- **flake8-comprehensions**: Improves list/dict/set comprehensions
- **flake8-simplify**: Suggests code simplifications

**When to use Flake8**:
- Need PEP 8 enforcement with plugins
- Want docstring validation
- Need bug detection patterns
- Prefer modular linting approach

## Installation Steps

### Step 1: Install Flake8 and Plugins

Using pip:
```bash
pip install flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify
```

Using poetry:
```bash
poetry add --group dev flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify
```

### Step 2: Copy Configuration

Copy the Flake8 configuration file to your project root:

```bash
cp plugins/languages/python/linters/flake8/project-content/config/.flake8 ./.flake8
```

**Configuration highlights**:
- Max line length: 120 characters (consistent with Ruff/Black)
- Max complexity: 10 (enforces maintainable code)
- Google-style docstrings
- Comprehensive plugin checks enabled
- Per-file ignores for tests and __init__.py

### Step 3: Verify Installation

```bash
# Check version
flake8 --version

# Verify plugins loaded
flake8 --version | grep -E "(docstrings|bugbear|comprehensions|simplify)"

# Run on a file
flake8 your_file.py

# Run on entire project
flake8 src/
```

### Step 4: Add to Makefile (if using Makefile integration)

The Python core plugin already includes flake8 targets in `makefile-python.mk`:

```makefile
lint-flake8: ## Run Flake8 style guide enforcement with plugins
	flake8 src/
```

If manually adding:
```makefile
.PHONY: lint-flake8
lint-flake8:
	@echo "Running Flake8 with plugins..."
	flake8 src/
```

### Step 5: Configure for Docker (if using Docker plugin)

Flake8 and plugins are already included in the Python linting Docker image:

```dockerfile
RUN pip install --no-cache-dir \
    flake8 \
    flake8-docstrings \
    flake8-bugbear \
    flake8-comprehensions \
    flake8-simplify
```

## Configuration Details

### .flake8 Structure

```ini
[flake8]
# Line length (consistent with Ruff and Black)
max-line-length = 120

# Complexity limit
max-complexity = 10

# Exclusions
exclude =
    .git,
    __pycache__,
    .venv,
    venv,
    .mypy_cache,
    .pytest_cache

# Ignored error codes
ignore =
    E203,  # Whitespace before ':' (conflicts with Black)
    E501,  # Line too long (handled by formatter)
    W503,  # Line break before operator (outdated PEP 8)
    D100,  # Missing module docstring (too strict)
    D104,  # Missing package docstring (too strict)
    D107,  # Missing __init__ docstring

# Selected checks (all plugins enabled)
select =
    E,     # pycodestyle errors
    W,     # pycodestyle warnings
    F,     # pyflakes
    C,     # mccabe complexity
    B,     # bugbear
    D,     # docstrings
    C4,    # comprehensions
    SIM,   # simplify

# Per-file ignores
per-file-ignores =
    __init__.py:F401,D104
    tests/*:D100,D101,D102,D103,S101
    test_*.py:D100,D101,D102,D103,S101

# Docstring convention
docstring-convention = google

# Statistics
show-source = True
statistics = True
count = True
```

### Plugin-Specific Checks

#### flake8-docstrings (D-codes)
- D100: Missing module docstring
- D101: Missing class docstring
- D102: Missing method docstring
- D103: Missing function docstring
- D200-D400: Docstring formatting

#### flake8-bugbear (B-codes)
- B001: Bare except
- B006: Mutable default argument
- B007: Unused loop variable
- B008: Function calls in defaults
- B011: Assert False (use raise)

#### flake8-comprehensions (C4-codes)
- C400: Unnecessary list comprehension
- C401: Unnecessary set comprehension
- C402: Unnecessary dict comprehension
- C403-C419: Various comprehension improvements

#### flake8-simplify (SIM-codes)
- SIM101: Multiple isinstance calls
- SIM102: Nested if statements
- SIM103: Return condition directly
- SIM105: Use contextlib.suppress
- SIM108: Use ternary operator

## Integration with Other Tools

### With Ruff

Flake8 complements Ruff:
- **Ruff**: Fast, modern, covers most checks
- **Flake8**: Plugin ecosystem, docstring validation

Run both:
```bash
make lint-python   # Runs Ruff (fast)
make lint-flake8   # Runs Flake8 with plugins (comprehensive)
```

### With Pre-commit Hooks

Add to `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/PyCQA/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
        additional_dependencies:
          - flake8-docstrings
          - flake8-bugbear
          - flake8-comprehensions
          - flake8-simplify
```

### With CI/CD

GitHub Actions workflow (already in `ci-python.yml`):
```yaml
- name: Lint with Flake8
  run: |
    pip install flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify
    flake8 src/
```

## Common Flake8 Checks

### Style Guide (E/W)
- E101: Indentation contains mixed spaces and tabs
- E111: Indentation is not a multiple of 4
- E302: Expected 2 blank lines
- W291: Trailing whitespace

### Errors (F)
- F401: Module imported but unused
- F821: Undefined name
- F841: Local variable assigned but never used

### Complexity (C)
- C901: Function too complex

### Bugbear (B)
- B006: Mutable default argument
- B008: Function call in default argument
- B011: Assert False (use raise instead)

## Disabling Checks

### File-level disable
```python
# flake8: noqa
```

### Line-level disable
```python
result = some_function(a, b, c, d, e)  # noqa: E501
```

### Specific code disable
```python
from module import *  # noqa: F403
```

## Troubleshooting

### Issue: Too many docstring errors

**Solution**: Adjust docstring requirements in `.flake8`:
```ini
ignore = D100, D104, D107  # Relax docstring requirements
```

### Issue: Conflicts with Black formatting

**Solution**: Already configured to ignore Black-conflicting rules:
```ini
ignore = E203, W503  # Black compatibility
```

### Issue: Plugins not loading

**Solution**: Verify plugins installed:
```bash
flake8 --version
# Should show: mccabe, pycodestyle, pyflakes, flake8-bugbear, etc.
```

### Issue: False positives in tests

**Solution**: Per-file ignores already configured:
```ini
per-file-ignores =
    tests/*:D100,D101,D102,D103,S101
```

## Output Formats

### Terminal (default)
```bash
flake8 src/
```

### With file statistics
```bash
flake8 --statistics src/
```

### Show source code
```bash
flake8 --show-source src/
```

### Count errors
```bash
flake8 --count src/
```

## Best Practices

1. **Use with Ruff**: Flake8 for docstrings/plugins, Ruff for speed
2. **Configure per-file ignores**: Different rules for tests vs. code
3. **Enable plugins selectively**: Only what you need
4. **Document exceptions**: Comment why rules are ignored
5. **Run in CI/CD**: Enforce before merge

## Plugin Benefits

### flake8-docstrings
- Enforces Google/NumPy/Sphinx docstring styles
- Validates docstring presence and format
- Catches missing documentation

### flake8-bugbear
- Detects common Python gotchas
- Finds likely bugs (mutable defaults, etc.)
- Suggests better patterns

### flake8-comprehensions
- Optimizes comprehensions
- Suggests simpler syntax
- Improves readability

### flake8-simplify
- Identifies unnecessary complexity
- Suggests code simplifications
- Improves maintainability

## Post-Installation Validation

Verify Flake8 is working:

```bash
# 1. Check installation and plugins
flake8 --version

# 2. Verify plugins loaded
flake8 --version | grep bugbear

# 3. Run on sample file
flake8 src/example.py

# 4. Test Makefile target
make lint-flake8

# 5. Check Docker integration (if using Docker)
make lint-start-python
docker exec ai-projen-python-linter-main flake8 --version
```

## Success Criteria

Installation is successful when:
- ✅ `flake8 --version` shows installed version and all plugins
- ✅ `.flake8` exists in project root
- ✅ `make lint-flake8` runs without errors
- ✅ Plugins detect issues (docstrings, bugbear, comprehensions, simplify)
- ✅ Configuration is loaded correctly
- ✅ Per-file ignores work for tests

## Next Steps

After installing Flake8:
1. Run initial scan: `make lint-flake8`
2. Review docstring requirements
3. Fix bugbear-detected issues
4. Optimize comprehensions
5. Simplify complex code patterns
6. Add to CI/CD pipeline

---

**Note**: Flake8 with plugins provides comprehensive PEP 8 enforcement and best practice validation. Use alongside Ruff for complete coverage.
