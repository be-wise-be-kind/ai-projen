# MyPy Type Checker - Agent Instructions

**Purpose**: Install and configure MyPy for Python static type checking

**Scope**: Type checking setup for Python projects

**Overview**: MyPy is a static type checker for Python that verifies type hints at development
    time, catching type-related bugs before runtime.

**Dependencies**: Python 3.11+, pip or poetry

---

## Installation Steps

### Step 1: Install MyPy

Add MyPy to your Python development dependencies:

**Using pip**:
```bash
pip install mypy
```

**Using poetry** (recommended):
```bash
poetry add --group dev mypy
```

**Using requirements-dev.txt**:
```
mypy>=1.18.1
```

### Step 2: Copy Configuration

Copy the MyPy configuration to your project root:

```bash
cp plugins/languages/python/linters/mypy/config/mypy.ini ./mypy.ini
```

**Alternative**: If you prefer pyproject.toml configuration, you can add the equivalent
settings to your `pyproject.toml` instead. See the configuration section below.

### Step 3: Verify Installation

Test that MyPy is working:

```bash
# Check version
mypy --version

# Run type checking on current directory
mypy .

# Run on specific directory
mypy src/
```

## Configuration Options

### Using mypy.ini (Recommended)

The provided `mypy.ini` includes:
- **Python version**: 3.11
- **Strict checking**: Enabled for production quality
- **Return types**: Warns about Any return types
- **Untyped definitions**: Disallowed (requires type hints)
- **Import checking**: Validates imported types
- **Redundancy warnings**: Catches unnecessary casts and ignores

### Using pyproject.toml (Alternative)

If you prefer to keep configuration in `pyproject.toml`, add:

```toml
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_unimported = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
check_untyped_defs = true
strict_equality = true
exclude = [
    '\.venv',
    'venv',
    'build',
    'dist',
    '\.mypy_cache',
    '\.pytest_cache',
    '\.ruff_cache',
]
```

## Type Checking Levels

The configuration is set to **strict mode**. You can adjust based on your project needs:

### Strict (Recommended for new projects)
```ini
disallow_untyped_defs = True
disallow_any_unimported = True
```

### Moderate (For migrating existing projects)
```ini
disallow_untyped_defs = False  # Allow untyped functions during migration
warn_return_any = True          # Still warn about Any returns
```

### Lenient (For legacy code)
```ini
check_untyped_defs = False
warn_unused_ignores = False
```

## Usage Examples

```bash
# Check all Python files
mypy .

# Check specific directory
mypy src/

# Check specific file
mypy src/main.py

# Show error codes
mypy --show-error-codes .

# Ignore missing imports for third-party packages
mypy --ignore-missing-imports .
```

## Integration with Make

Add to your Makefile:

```makefile
.PHONY: typecheck

typecheck:
	mypy .
```

## Common Type Hints

```python
# Function with type hints
def greet(name: str) -> str:
    return f"Hello, {name}"

# Optional types
from typing import Optional
def get_user(user_id: int) -> Optional[dict]:
    return None

# Lists and dictionaries
from typing import List, Dict
def process_items(items: List[str]) -> Dict[str, int]:
    return {item: len(item) for item in items}

# Generic types
from typing import TypeVar, Generic
T = TypeVar('T')
class Container(Generic[T]):
    def __init__(self, value: T) -> None:
        self.value = value
```

## Handling Third-Party Libraries

For libraries without type stubs, you can:

1. **Install type stubs** (if available):
```bash
pip install types-requests  # For requests library
pip install types-redis     # For redis library
```

2. **Ignore missing imports** in mypy.ini:
```ini
[mypy-some_library.*]
ignore_missing_imports = True
```

3. **Create your own stub files** (advanced):
```python
# stubs/some_library.pyi
def some_function(arg: str) -> int: ...
```

## Success Criteria

MyPy is successfully installed when:
- ✅ `mypy --version` works
- ✅ `mypy.ini` or `[tool.mypy]` configuration exists
- ✅ `mypy .` runs without errors (or shows expected type violations)
- ✅ Make target works (if Makefile integration completed)
- ✅ Type hints are being validated during development

## Best Practices

1. **Add type hints gradually**: Start with function signatures, then expand
2. **Use strict mode for new code**: Enforce type hints from the start
3. **Install type stubs**: For third-party libraries you use frequently
4. **Run in CI/CD**: Catch type errors before they reach production
5. **Use reveal_type()**: For debugging type inference issues
