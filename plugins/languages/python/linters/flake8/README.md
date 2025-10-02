# Flake8 Plugin (with Comprehensive Plugin Suite)

Python style guide enforcement with Flake8 and comprehensive plugins.

## What This Plugin Does

Adds Flake8 with a complete plugin suite:
- **flake8-docstrings**: Google-style docstring validation
- **flake8-bugbear**: Bug detection and design issues
- **flake8-comprehensions**: Comprehension optimization
- **flake8-simplify**: Code simplification suggestions

## Why You Need It

**Flake8 provides**:
- PEP 8 style guide enforcement
- Docstring validation (Google/NumPy/Sphinx styles)
- Bug pattern detection (mutable defaults, bare except, etc.)
- Comprehension improvements
- Code simplification suggestions

**Complements Ruff**:
- Ruff: Fast, modern, core checks
- Flake8: Plugin ecosystem, docstring validation, additional patterns

## What Gets Installed

### Configuration Files
- `.flake8` - Flake8 + plugins configuration (120 char line length, complexity 10, Google docstrings)

### Tools
- **flake8** - Core linter
- **flake8-docstrings** - Docstring checker (pydocstyle)
- **flake8-bugbear** - Bug detector
- **flake8-comprehensions** - Comprehension optimizer
- **flake8-simplify** - Code simplifier

### Makefile Targets
- `make lint-flake8` - Run Flake8 with all plugins
- Docker-first execution

## Installation

### Standalone

```bash
# 1. Navigate to flake8 plugin
cd plugins/languages/python/linters/flake8/

# 2. Follow AGENT_INSTRUCTIONS.md
cat AGENT_INSTRUCTIONS.md
```

### Via Orchestrator

Included when selecting comprehensive Python tooling:
```
Additional Linters: Install comprehensive linting suite?
- Pylint
- Flake8 + plugins ← This plugin
Default: Yes
```

## Usage

### Basic Linting
```bash
# Run Flake8 with all plugins
make lint-flake8

# Or directly
flake8 src/
```

### Check Specific Issues
```bash
# Docstrings only
flake8 --select=D src/

# Bugbear only
flake8 --select=B src/

# Comprehensions only
flake8 --select=C4 src/

# Simplifications only
flake8 --select=SIM src/
```

## Plugin Features

### flake8-docstrings (D-codes)
Validates docstrings using Google/NumPy/Sphinx conventions:

```python
# ❌ Missing docstring
def process_data(items):
    return [x * 2 for x in items]

# ✅ Google-style docstring
def process_data(items):
    """Process items by doubling values.

    Args:
        items: List of integers to process

    Returns:
        List of doubled values
    """
    return [x * 2 for x in items]
```

### flake8-bugbear (B-codes)
Detects common Python gotchas:

```python
# ❌ Mutable default argument (B006)
def add_item(item, items=[]):
    items.append(item)
    return items

# ✅ Use None as default
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

### flake8-comprehensions (C4-codes)
Optimizes list/dict/set comprehensions:

```python
# ❌ Unnecessary list comprehension (C400)
items = list([x for x in range(10)])

# ✅ Direct comprehension
items = [x for x in range(10)]

# ❌ Unnecessary dict comprehension (C402)
mapping = dict([(k, v) for k, v in pairs])

# ✅ Dict comprehension
mapping = {k: v for k, v in pairs}
```

### flake8-simplify (SIM-codes)
Suggests code simplifications:

```python
# ❌ Multiple isinstance calls (SIM101)
if isinstance(obj, int) or isinstance(obj, float):
    process_number(obj)

# ✅ Combined isinstance
if isinstance(obj, (int, float)):
    process_number(obj)

# ❌ Unnecessary else (SIM103)
def is_valid(value):
    if value > 0:
        return True
    else:
        return False

# ✅ Return directly
def is_valid(value):
    return value > 0
```

## Configuration

### Customize .flake8

```ini
[flake8]
max-line-length = 120
max-complexity = 10

# Adjust ignored codes
ignore = E203, W503, D100

# Change docstring style
docstring-convention = numpy  # or sphinx, pep257
```

### Per-File Ignores

```ini
[flake8]
per-file-ignores =
    __init__.py:F401,D104
    tests/*:D100,D101,D102,D103
```

## Integration

### With Ruff
```bash
# Fast daily checks
make lint-python  # Ruff

# Comprehensive docstring/plugin checks
make lint-flake8  # Flake8
```

### With Pre-commit
```yaml
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
Already in `ci-python.yml` workflow

## Common Checks

| Plugin | Code | Description | Example |
|--------|------|-------------|---------|
| **Core** | E501 | Line too long | Lines > 120 chars |
| **Core** | F401 | Unused import | `import os` but never used |
| **Docstrings** | D100 | Missing module docstring | No docstring at top |
| **Docstrings** | D102 | Missing method docstring | Undocumented method |
| **Bugbear** | B006 | Mutable default arg | `def func(items=[])` |
| **Bugbear** | B008 | Function call in default | `def func(t=time.time())` |
| **Comprehensions** | C400 | Unnecessary list() | `list([x for x in...])` |
| **Comprehensions** | C402 | Unnecessary dict() | `dict([(k,v) for...])` |
| **Simplify** | SIM101 | Multiple isinstance | Combine checks |
| **Simplify** | SIM103 | Unnecessary else | Return directly |

## Output Example

```bash
$ make lint-flake8

src/api.py:12:1: D103 Missing docstring in public function
src/api.py:45:5: B006 Do not use mutable data structures for argument defaults
src/utils.py:23:9: C400 Unnecessary list comprehension - 'list([x for x in ...])'
src/helpers.py:67:4: SIM103 Return the condition 'value > 0' directly
```

## Troubleshooting

### Too many docstring errors?
Adjust in `.flake8`:
```ini
ignore = D100, D104  # Relax module/package docstrings
```

### Conflicts with Black?
Already configured:
```ini
ignore = E203, W503  # Black compatibility
```

### Plugins not detected?
Verify installation:
```bash
flake8 --version  # Should list all plugins
```

## Related Documentation

- **Configuration**: `.flake8` in project root
- **Python Standards**: `.ai/docs/PYTHON_STANDARDS.md`
- **Comprehensive Tooling**: `.ai/docs/COMPREHENSIVE_TOOLING.md`

---

**Flake8 + Plugins**: Comprehensive PEP 8 enforcement with docstring validation, bug detection, and code optimization.
