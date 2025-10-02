# Comprehensive Python Tooling Guide

**Purpose**: Complete reference for all Python development tools in the ai-projen framework

**Scope**: Type checking, security scanning, linting, complexity analysis, and testing tools

**Overview**: Comprehensive guide to all Python tooling available in the plugin, including configuration,
    usage patterns, and integration strategies. Based on production-ready configurations from durable-code-test.

---

## Tool Categories

### 1. Type Checking

#### MyPy
**Purpose**: Static type checking to catch type errors before runtime

**Configuration**: `pyproject.toml` `[tool.mypy]` section

**Key Settings**:
- `python_version = "3.11"` - Target Python version
- `disallow_untyped_defs = true` - Require type hints on all functions
- `warn_return_any = true` - Warn when returning Any type
- `strict_equality = true` - Strict equality checking

**Usage**:
```bash
make typecheck           # Docker-first with auto-detection
make lint-mypy          # Alias for typecheck
```

**When to Use**:
- Always enable for production code
- Catches type mismatches, None errors, attribute errors
- Improves IDE autocomplete and refactoring

---

### 2. Security Scanning

#### Bandit
**Purpose**: Security vulnerability scanner for Python code

**Configuration**: `pyproject.toml` `[tool.bandit]` section

**Key Settings**:
- `exclude_dirs = ["/tests/", "/test/"]` - Skip test files
- `skips = ["B101"]` - Allow assert statements

**Usage**:
```bash
make security-scan      # Bandit only (quick)
make lint-bandit       # Alias for security-scan
```

**Detects**:
- Hardcoded passwords and secrets
- SQL injection vulnerabilities
- Use of insecure functions (eval, exec, pickle)
- Weak cryptography
- Shell injection risks

#### Safety
**Purpose**: Dependency vulnerability scanner using CVE database

**Configuration**: None required (uses PyPI advisory database)

**Usage**:
```bash
make security-full      # Includes Safety + Bandit + pip-audit
```

**Detects**:
- Known vulnerabilities in installed packages
- Outdated dependencies with security issues
- CVE matches against dependency versions

#### pip-audit
**Purpose**: Alternative dependency security auditor using OSV database

**Configuration**: None required (uses OSV database)

**Usage**:
```bash
make security-full      # Comprehensive security scan
```

**Detects**:
- Security vulnerabilities in dependencies
- More comprehensive than Safety (uses multiple databases)
- Supply chain security issues

**Best Practice**: Run `make security-full` in CI/CD to catch all security issues

---

### 3. Linting and Code Quality

#### Ruff (Primary - Recommended)
**Purpose**: Fast all-in-one linter and formatter (replaces Black, isort, flake8)

**Configuration**: `pyproject.toml` `[tool.ruff]` section

**Key Features**:
- 10-100x faster than traditional tools
- Combines linting + formatting + import sorting
- Compatible with Black formatting
- Extensive rule sets (pycodestyle, pyflakes, bugbear, etc.)

**Usage**:
```bash
make lint-python        # Linting check
make lint-fix-python    # Auto-fix issues
make format-python      # Format code
```

**Why Use It**:
- Single tool replaces multiple tools
- Extremely fast (written in Rust)
- Active development and community support
- Default choice for new projects

#### Pylint
**Purpose**: Comprehensive code quality linter with advanced checks

**Configuration**: `standards/.pylintrc` or `pyproject.toml` `[tool.pylint]`

**Key Features**:
- Design pattern enforcement
- Code smell detection
- Refactoring suggestions
- Naming convention checking

**Usage**:
```bash
make lint-pylint        # Comprehensive linting
```

**When to Use**:
- More thorough than Ruff for code quality
- Catches design issues and code smells
- Good for legacy code audits
- Use alongside Ruff for comprehensive coverage

#### Flake8 + Plugins
**Purpose**: Style guide enforcement with plugin ecosystem

**Configuration**: `standards/.flake8` (INI format)

**Plugins Included**:
- **flake8-docstrings**: Documentation standards (Google-style)
- **flake8-bugbear**: Common bug detection
- **flake8-comprehensions**: Better list/dict/set comprehensions
- **flake8-simplify**: Code simplification suggestions

**Usage**:
```bash
make lint-flake8        # Run Flake8 with all plugins
```

**When to Use**:
- Need specific plugin functionality
- Enforcing documentation standards
- Finding common bugs and anti-patterns
- Alternative to Ruff for teams already using Flake8

---

### 4. Complexity Analysis

#### Radon
**Purpose**: Cyclomatic complexity and maintainability index calculation

**Configuration**: `standards/radon.cfg`

**Metrics**:
- **Cyclomatic Complexity (CC)**: Measures code paths
  - Grade A: 1-5 (simple, easy to test)
  - Grade B: 6-10 (moderate complexity)
  - Grade C: 11-20 (complex, needs refactoring)
  - Grade D: 21-50 (very complex)
  - Grade F: 51+ (unmaintainable)

- **Maintainability Index (MI)**: Overall maintainability score
  - Grade A: 20-100 (maintainable)
  - Grade B: 10-19 (moderately maintainable)
  - Grade C: 0-9 (difficult to maintain)

**Usage**:
```bash
make complexity-radon   # Show CC and MI metrics
```

**Output**:
```
M 142:0 calculate_total - A (3)
M 156:0 process_order - B (7)
M 178:0 complex_function - C (12)  # ⚠️ Needs refactoring
```

**Standards**:
- Enforce Grade A complexity (CC 1-5)
- Enforce Grade A maintainability (MI 20-100)
- Refactor any function with Grade C or lower

#### Xenon
**Purpose**: Complexity monitoring and enforcement (fails on violations)

**Configuration**: Command-line flags (no config file)

**Usage**:
```bash
make complexity-xenon   # Enforce Grade A complexity
```

**Settings**:
- `--max-absolute A`: No function exceeds Grade A
- `--max-modules A`: No module exceeds Grade A average
- `--max-average A`: Project average must be Grade A

**When to Use**:
- CI/CD pipeline to enforce complexity limits
- Fails the build if complexity exceeds thresholds
- Prevents complexity from increasing over time

---

### 5. Testing

#### Pytest
**Purpose**: Modern testing framework with extensive features

**Configuration**: `pyproject.toml` `[tool.pytest.ini_options]`

**Features**:
- Fixtures for test setup/teardown
- Parametrization for data-driven tests
- Async/await support
- Coverage reporting with pytest-cov
- Markers for test categorization

**Usage**:
```bash
make test-python                # All tests
make test-coverage-python       # Tests with coverage
make test-unit-python           # Unit tests only
make test-integration-python    # Integration tests only
```

**Coverage Configuration**: `pyproject.toml` `[tool.coverage]`
- Minimum coverage thresholds
- Files to exclude from coverage
- HTML and terminal reports

---

## Tool Comparison and Selection Guide

### When to Use Each Tool

| Need | Primary Tool | Alternative | Use Case |
|------|-------------|-------------|----------|
| **Fast linting** | Ruff | Pylint | Development, CI/CD |
| **Comprehensive linting** | Pylint | Flake8 | Code audits, reviews |
| **Type checking** | MyPy | - | All production code |
| **Code security** | Bandit | - | All projects |
| **Dependency security** | Safety + pip-audit | - | CI/CD pipelines |
| **Complexity monitoring** | Radon | Xenon | Analysis vs enforcement |
| **Documentation checks** | Flake8-docstrings | Pylint | Public APIs |
| **Testing** | Pytest | - | All projects |

### Recommended Workflow

#### Development (Local)
```bash
make lint-python        # Quick Ruff check
make typecheck          # Type checking
make test-python        # Run tests
```

#### Pre-Commit
```bash
make lint-fix-python    # Auto-fix issues
make format-python      # Format code
make typecheck          # Verify types
```

#### CI/CD Pipeline
```bash
make lint-python        # Ruff linting
make lint-pylint        # Comprehensive linting
make typecheck          # Type checking
make security-full      # All security scans
make complexity-xenon   # Enforce complexity limits
make test-coverage-python  # Tests with coverage
```

#### Periodic Audits
```bash
make lint-flake8        # Style guide enforcement
make complexity-radon   # Complexity analysis
make security-full      # Security audit
```

---

## Configuration File Locations

### Primary Configuration: `pyproject.toml`
Contains configurations for:
- Ruff (`[tool.ruff]`)
- MyPy (`[tool.mypy]`)
- Pylint (`[tool.pylint]`)
- Bandit (`[tool.bandit]`)
- Pytest (`[tool.pytest.ini_options]`)
- Coverage (`[tool.coverage]`)
- Radon (`[tool.radon]`)

### Standalone Configurations
- `.flake8` - Flake8 and plugins (INI format)
- `.pylintrc` - Alternative Pylint config (INI format)
- `radon.cfg` - Alternative Radon config (INI format)

### Template Location
- `plugins/languages/python/templates/pyproject.toml.template` - Complete template
- `plugins/languages/python/standards/` - Standalone config files

---

## Docker-First Pattern

All tools support three execution modes:

1. **Docker (Preferred)**: Runs in dedicated linting containers
   - Zero local environment pollution
   - Consistent across all developers
   - Isolated from project dependencies

2. **Poetry (Fallback)**: Runs in Poetry virtual environment
   - Project-isolated but platform-dependent
   - Used when Docker unavailable

3. **Direct (Last Resort)**: Direct local execution
   - Not recommended (pollutes global environment)
   - Only when Docker and Poetry unavailable

The Makefile automatically detects and uses the best available option.

---

## Tool Versions (from durable-code-test)

Recommended versions for production use:

```toml
[tool.poetry.group.dev.dependencies]
pytest = "^8.4.2"
pytest-asyncio = "^0.23.0"
pytest-cov = "^4.1.0"
ruff = "^0.13.0"
mypy = "^1.18.1"
radon = "^6.0.1"
bandit = "^1.7.5"
safety = "^3.0.0"
pip-audit = "^2.9.0"
pylint = "^3.0.0"
flake8 = "^7.0.0"
flake8-docstrings = "^1.7.0"
flake8-bugbear = "^24.0.0"
flake8-comprehensions = "^3.14.0"
flake8-simplify = "^0.21.0"
xenon = "^0.9.1"
```

---

## Integration Examples

### Pre-commit Hooks
```yaml
repos:
  - repo: local
    hooks:
      - id: ruff
        name: Ruff Linting
        entry: make lint-python
        language: system
        pass_filenames: false

      - id: mypy
        name: MyPy Type Checking
        entry: make typecheck
        language: system
        pass_filenames: false
```

### GitHub Actions
```yaml
- name: Run Python Quality Checks
  run: |
    make lint-python
    make lint-pylint
    make typecheck
    make security-full
    make complexity-xenon
    make test-coverage-python
```

---

## Troubleshooting

### Issue: Tools not found
**Solution**: Ensure dependencies installed via Poetry or pip
```bash
make python-install
```

### Issue: Different results locally vs CI
**Solution**: Use Docker for consistent environments
```bash
make lint-start-python  # Start linting containers
```

### Issue: Too many linting errors
**Solution**: Start with Ruff (fast, auto-fixable), then add others incrementally
```bash
make lint-fix-python  # Auto-fix Ruff issues first
```

### Issue: Complexity too high
**Solution**: Refactor complex functions into smaller units
```bash
make complexity-radon  # Identify complex functions
```

---

## Summary

This comprehensive tooling suite provides:
- ✅ **Type Safety**: MyPy catches type errors
- ✅ **Security**: Bandit, Safety, pip-audit protect against vulnerabilities
- ✅ **Code Quality**: Ruff, Pylint, Flake8 enforce standards
- ✅ **Maintainability**: Radon, Xenon measure and enforce complexity limits
- ✅ **Testing**: Pytest with coverage ensures reliability
- ✅ **Docker-First**: Consistent environments across all platforms

**Recommendation**: Start with Ruff + MyPy + Bandit, then add others as needed.

---

**Version**: 1.0.0
**Last Updated**: 2025-10-01
**Based On**: durable-code-test reference implementation
