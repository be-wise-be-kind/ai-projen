# MyPy Type Checker - Agent Instructions

**Purpose**: Install and configure MyPy for Python static type checking

**Scope**: Type checking setup for Python projects

**Overview**: MyPy is a static type checker for Python that verifies type hints at development
    time, catching type-related bugs before runtime.

**Dependencies**: Python 3.11+, pip or poetry

---

## Environment Strategy

**IMPORTANT**: Follow the Docker-first development hierarchy:

1. **Docker (Preferred)** 🐳
   - Run MyPy in containers via `make typecheck` (auto-detects Docker)
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

### Step 1: Configure MyPy

**Option A: pyproject.toml (Recommended - works in Docker and locally)**:

Add MyPy configuration to `pyproject.toml`:

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

**Option B: mypy.ini (Legacy)**:

```bash
cp plugins/languages/python/linters/mypy/config/mypy.ini ./mypy.ini
```

### Step 2: Install Based on Environment

**Docker-First Approach (Recommended)**:

```bash
# Build Docker images with all Python tools including MyPy
make python-install  # Builds Docker images

# Run type checking in container (auto-detects environment)
make typecheck       # Uses Docker if available
```

**Poetry Fallback** (if Docker unavailable):

```bash
poetry add --group dev mypy
poetry run mypy .
```

**Direct Local** (if neither Docker nor Poetry available):

```bash
pip install mypy
mypy .
```

### Step 3: Verify Installation

**Docker Approach**:
```bash
# Verify Docker images built
docker images | grep python-linter

# Run type checking in container
make typecheck
```

**Poetry Approach**:
```bash
# Check version
poetry run mypy --version

# Run type checking
poetry run mypy .
```

**Direct Local Approach**:
```bash
# Check version
mypy --version

# Run type checking
mypy .
```

## Configuration Options

The provided configuration includes:
- **Python version**: 3.11
- **Strict checking**: Enabled for production quality
- **Return types**: Warns about Any return types
- **Untyped definitions**: Disallowed (requires type hints)
- **Import checking**: Validates imported types
- **Redundancy warnings**: Catches unnecessary casts and ignores

**Note**: Configuration in `pyproject.toml` works identically in Docker, Poetry, and direct local environments.

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

## Makefile Integration

The Python plugin's Makefile (`makefile-python.mk`) includes automatic environment detection:

```makefile
# From makefile-python.mk (already included in plugin)
typecheck: ## Auto-detects Docker → Poetry → Direct
	# Automatically uses best available environment
	# Priority: Docker > Poetry > Direct local

# Just run this - it works everywhere:
make typecheck
```

**How it works**:
1. Checks if Docker is available → uses linting container
2. Falls back to Poetry if Docker unavailable
3. Falls back to direct `mypy` command if neither available

No need to modify - the Makefile handles environment detection automatically!

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
- ✅ `pyproject.toml` contains `[tool.mypy]` configuration (or mypy.ini exists)
- ✅ `make typecheck` runs successfully (in any environment)
- ✅ Docker approach (preferred): Type checking runs in container
- ✅ Poetry approach (fallback): `poetry run mypy --version` works
- ✅ Direct approach (last resort): `mypy --version` works
- ✅ Configuration works in all three environments
- ✅ Type hints are being validated during development

## Best Practices

1. **Add type hints gradually**: Start with function signatures, then expand
2. **Use strict mode for new code**: Enforce type hints from the start
3. **Install type stubs**: For third-party libraries you use frequently
4. **Run in CI/CD**: Catch type errors before they reach production
5. **Use reveal_type()**: For debugging type inference issues
