# Pylint Linter - Agent Instructions

**Purpose**: Install and configure Pylint for comprehensive Python code quality linting

**Scope**: Code quality analysis, design issues, code smells, and maintainability checks

**Overview**: Step-by-step instructions for AI agents to install Pylint, a comprehensive Python linter
    that checks for errors, enforces coding standards, looks for code smells, and offers simple
    refactoring suggestions.

**Dependencies**: Python 3.11+, pip or poetry

**Exports**: Pylint configuration and linting capabilities

**Related**: Python linting tooling, code quality standards

**Implementation**: Configuration-based linting with .pylintrc

---

## Prerequisites

Before installing Pylint, ensure:
- ✅ Python 3.11+ is installed
- ✅ pip or poetry is available
- ✅ Project has a Python codebase to lint

## What is Pylint?

Pylint is a comprehensive Python linter that:
- Checks for errors and coding standard violations
- Detects code smells and design issues
- Enforces coding conventions and best practices
- Provides refactoring suggestions
- Calculates complexity metrics
- More thorough but slower than Ruff

**When to use Pylint**:
- Need comprehensive code quality analysis
- Want detailed design feedback
- Enforcing strict coding standards
- Complementing Ruff for additional checks

## Installation Steps

### Step 1: Install Pylint

Using pip:
```bash
pip install pylint
```

Using poetry:
```bash
poetry add --group dev pylint
```

### Step 2: Copy Configuration

Copy the Pylint configuration file to your project root:

```bash
cp plugins/languages/python/linters/pylint/project-content/config/.pylintrc ./.pylintrc
```

**Configuration highlights**:
- Max line length: 120 characters (consistent with Ruff/Black)
- Disabled overly strict checks (missing-docstring, invalid-name)
- Complexity limits (max-args: 5, max-branches: 12)
- Compatible with FastAPI and Pydantic patterns

### Step 3: Verify Installation

```bash
# Check version
pylint --version

# Run on a file
pylint your_file.py

# Run on entire project
pylint src/
```

### Step 4: Add to Makefile (if using Makefile integration)

The Python core plugin already includes pylint targets in `makefile-python.mk`:

```makefile
lint-pylint: ## Run Pylint comprehensive code quality linting
	pylint src/
```

If manually adding:
```makefile
.PHONY: lint-pylint
lint-pylint:
	@echo "Running Pylint..."
	pylint src/
```

### Step 5: Configure for Docker (if using Docker plugin)

Pylint is already included in the Python linting Docker image. No additional configuration needed.

The linting container includes:
```dockerfile
RUN pip install --no-cache-dir \
    ruff \
    mypy \
    bandit \
    pylint \
    flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify
```

## Configuration Details

### .pylintrc Structure

```ini
[MESSAGES CONTROL]
max-line-length = 120

# Disabled checks (with rationale)
disable =
    C0111,  # missing-docstring (too strict for all code)
    C0103,  # invalid-name (conflicts with common patterns)
    C0301,  # line-too-long (handled by ruff formatter)
    R0903,  # too-few-public-methods (valid for simple classes)
    R0913,  # too-many-arguments (common in complex functions)
    W0212,  # protected-access (sometimes needed)
    E0213,  # no-self-argument (false positive with Pydantic)
    W0613,  # unused-argument (false positive with FastAPI)

[DESIGN]
max-args = 5
max-locals = 15
max-returns = 6
max-branches = 12
max-statements = 50
```

### Customization

Edit `.pylintrc` to:
1. **Enable/disable specific checks**: Add to `disable` or `enable` lists
2. **Adjust complexity limits**: Modify `[DESIGN]` section values
3. **Add custom messages**: Use `[MESSAGES CONTROL]`
4. **Configure output**: Modify `[REPORTS]` section

## Integration with Other Tools

### With Ruff

Pylint complements Ruff:
- **Ruff**: Fast, focused on common issues, formatting
- **Pylint**: Comprehensive, design feedback, code smells

Run both:
```bash
make lint-python   # Runs Ruff (fast)
make lint-pylint   # Runs Pylint (thorough)
```

### With Pre-commit Hooks

Add to `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: pylint
        name: Pylint
        entry: pylint
        language: system
        types: [python]
        args: [--rcfile=.pylintrc]
```

### With CI/CD

GitHub Actions workflow (already in `ci-python.yml`):
```yaml
- name: Lint with Pylint
  run: pylint src/
```

## Common Pylint Checks

### Error Detection (E)
- E0001: Syntax errors
- E1101: No member (attribute doesn't exist)
- E1102: Not callable

### Warning (W)
- W0612: Unused variable
- W0613: Unused argument
- W0622: Redefining built-in

### Refactor (R)
- R0914: Too many local variables
- R0915: Too many statements
- R1705: Unnecessary else after return

### Convention (C)
- C0103: Invalid name
- C0114: Missing module docstring
- C0116: Missing function docstring

## Disabling Checks

### File-level disable
```python
# pylint: disable=invalid-name,missing-docstring
```

### Block-level disable
```python
# pylint: disable=broad-exception-caught
try:
    risky_operation()
except Exception:  # Intentionally broad
    handle_error()
# pylint: enable=broad-exception-caught
```

### Line-level disable
```python
result = some_complex_function(a, b, c, d, e, f)  # pylint: disable=too-many-arguments
```

## Troubleshooting

### Issue: Too many false positives

**Solution**: Add specific disables to `.pylintrc`:
```ini
[MESSAGES CONTROL]
disable = E0213, W0613  # Add specific codes
```

### Issue: Conflicting with other linters

**Solution**: Disable overlapping checks in `.pylintrc`:
```ini
disable = C0301  # Line too long (Ruff handles this)
```

### Issue: Slow performance

**Solution**:
1. Use Pylint selectively for important files
2. Run Ruff for day-to-day linting (much faster)
3. Use Pylint in CI/CD only

### Issue: Import errors

**Solution**: Ensure dependencies are installed:
```bash
pip install -e .  # Install package in editable mode
```

## Output Formats

### Terminal (default)
```bash
pylint src/
```

### JSON (for parsing)
```bash
pylint --output-format=json src/
```

### Colorized
```bash
pylint --output-format=colorized src/
```

### Score only
```bash
pylint --score=y src/
```

## Best Practices

1. **Run Ruff first**: Fix quick issues with Ruff before Pylint
2. **Use selectively**: Pylint on critical code paths
3. **Configure thoughtfully**: Disable overly strict checks
4. **Document disables**: Explain why checks are disabled
5. **Combine with other tools**: Pylint + Ruff + MyPy = comprehensive coverage

## Post-Installation Validation

Verify Pylint is working:

```bash
# 1. Check installation
pylint --version

# 2. Run on sample file
pylint src/example.py

# 3. Verify configuration loaded
pylint --rcfile=.pylintrc --help

# 4. Test Makefile target
make lint-pylint

# 5. Check Docker integration (if using Docker)
make lint-start-python
docker exec ai-projen-python-linter-main pylint --version
```

## Success Criteria

Installation is successful when:
- ✅ `pylint --version` shows installed version
- ✅ `.pylintrc` exists in project root
- ✅ `make lint-pylint` runs without errors
- ✅ Pylint detects issues in sample code
- ✅ Configuration is loaded correctly
- ✅ Output shows customized checks (not default strict mode)

## Next Steps

After installing Pylint:
1. Run initial scan: `make lint-pylint`
2. Review and fix critical issues
3. Adjust `.pylintrc` for project needs
4. Add to CI/CD pipeline
5. Consider pre-commit hook for critical files
6. Document any project-specific disable rationales

---

**Note**: Pylint is comprehensive but slower than Ruff. Use Ruff for fast, frequent checks and Pylint for thorough code reviews and CI/CD validation.
