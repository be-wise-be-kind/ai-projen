# Pylint Plugin

Comprehensive Python code quality linting with Pylint.

## What This Plugin Does

Adds Pylint to your Python project for:
- **Comprehensive code quality checks** - Errors, warnings, refactoring suggestions
- **Design issue detection** - Code smells, complexity problems, maintainability issues
- **Coding standards enforcement** - PEP 8 compliance, naming conventions
- **Refactoring suggestions** - Simplification opportunities, best practices

## Why You Need It

**Use Pylint when**:
- You need thorough code quality analysis beyond basic linting
- You want design feedback and code smell detection
- You're enforcing strict coding standards
- You need comprehensive checks in CI/CD

**Pylint complements Ruff**:
- **Ruff**: Fast, focused, formatting - for daily development
- **Pylint**: Comprehensive, design-focused - for code reviews and CI/CD

## What Gets Installed

### Configuration Files
- `.pylintrc` - Pylint configuration (max line length 120, complexity limits, disabled overly-strict checks)

### Makefile Targets
- `make lint-pylint` - Run Pylint comprehensive linting
- Docker-first execution with automatic container management

### Tools
- **pylint** - Comprehensive Python linter

## Installation

### Standalone (without orchestrator)

```bash
# 1. Navigate to Python pylint plugin
cd plugins/languages/python/linters/pylint/

# 2. Follow AGENT_INSTRUCTIONS.md
cat AGENT_INSTRUCTIONS.md
```

### Via Orchestrator

The Python core plugin installation asks:
```
Additional Linters: Install comprehensive linting suite?
- Pylint (comprehensive code quality linting)
- Flake8 + plugins
Default: Yes
```

## Usage

### Basic Linting
```bash
# Run Pylint
make lint-pylint

# Or directly
pylint src/
```

### Docker-First (if Docker plugin installed)
```bash
# Automatically uses linting container
make lint-pylint
```

### CI/CD Integration
```bash
# Already included in ci-python.yml workflow
# Runs on every pull request
```

## Configuration

### Customize .pylintrc

```ini
[MESSAGES CONTROL]
max-line-length = 120

# Enable/disable specific checks
disable = C0111, C0103, R0903

[DESIGN]
# Adjust complexity limits
max-args = 5
max-branches = 12
```

### Per-File Ignores

```python
# pylint: disable=invalid-name,missing-docstring
```

### Integration with Other Tools

Works with:
- ✅ Ruff (complementary, run both)
- ✅ MyPy (type checking)
- ✅ Bandit (security)
- ✅ Pre-commit hooks
- ✅ GitHub Actions CI/CD

## Checks Performed

### Error Detection
- Syntax errors
- Undefined variables
- Import errors
- Type errors (basic)

### Code Quality
- Complexity analysis
- Duplicate code detection
- Design issues
- Unused code

### Standards Enforcement
- PEP 8 compliance
- Naming conventions
- Docstring requirements
- Import ordering

## Output Example

```bash
$ make lint-pylint

************* Module src.api.endpoints
src/api/endpoints.py:45:0: R0914: Too many local variables (16/15) (too-many-locals)
src/api/endpoints.py:67:4: W0612: Unused variable 'result' (unused-variable)

------------------------------------------------------------------
Your code has been rated at 9.23/10 (previous run: 9.18/10, +0.05)
```

## Complementary Tools

| Tool | Purpose | Speed | Use Case |
|------|---------|-------|----------|
| **Ruff** | Fast linting + formatting | ⚡⚡⚡ | Daily development |
| **Pylint** | Comprehensive analysis | ⚡ | Code reviews, CI/CD |
| **MyPy** | Type checking | ⚡⚡ | Type safety |
| **Bandit** | Security scanning | ⚡⚡ | Security audits |

## When to Use

### ✅ Use Pylint
- Code reviews
- CI/CD pipelines
- Pre-release quality checks
- Refactoring large codebases
- Learning Python best practices

### ⚠️ Pylint May Be Overkill
- Quick prototypes
- Scripts and one-offs
- When Ruff catches most issues
- Performance-critical CI/CD (use Ruff instead)

## Performance Tips

1. **Use Ruff for daily work** - Much faster
2. **Pylint in CI/CD** - Comprehensive checks before merge
3. **Selective scanning** - Run Pylint on changed files only
4. **Parallel execution** - Use `--jobs=N` for multi-core

```bash
# Fast: Ruff (daily)
make lint-python

# Thorough: Pylint (pre-commit/CI)
make lint-pylint
```

## Troubleshooting

### Too many false positives?
Customize `.pylintrc` to disable specific checks

### Conflicts with Ruff?
Disable overlapping checks in Pylint (line-too-long, etc.)

### Slow performance?
Use selectively, or only in CI/CD, not locally

### Import errors?
Install package in editable mode: `pip install -e .`

## Related Documentation

- **Configuration**: `.pylintrc` in project root
- **Python Standards**: `.ai/docs/PYTHON_STANDARDS.md`
- **Comprehensive Tooling**: `.ai/docs/COMPREHENSIVE_TOOLING.md`
- **CI/CD Integration**: `.github/workflows/ci-python.yml`

---

**Pylint**: Comprehensive Python linting for production-ready code quality.
