# Pytest Testing Framework - Agent Instructions

**Purpose**: Install and configure pytest for Python testing

**Scope**: Testing framework setup for Python projects

**Overview**: Pytest is the de facto standard testing framework for Python, offering
    powerful features, excellent plugin ecosystem, and simple test writing.

**Dependencies**: Python 3.11+, pip or poetry

---

## Installation Steps

### Step 1: Install Pytest and Plugins

Add pytest and common plugins to your Python development dependencies:

**Using pip**:
```bash
pip install pytest pytest-asyncio pytest-cov
```

**Using poetry** (recommended):
```bash
poetry add --group dev pytest pytest-asyncio pytest-cov
```

**Using requirements-dev.txt**:
```
pytest>=8.4.2
pytest-asyncio>=0.23.0
pytest-cov>=4.1.0
```

### Step 2: Copy Configuration

Copy the pytest configuration to your project root:

```bash
cp plugins/languages/python/testing/pytest/config/pytest.ini ./pytest.ini
```

**Alternative**: You can also configure pytest in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
asyncio_mode = "auto"
addopts = "--tb=short -v"
cache_dir = "/tmp/.pytest_cache"
markers = [
    "unit: marks tests as unit tests",
    "integration: marks tests as integration tests",
    "slow: marks tests as slow running tests",
]
```

### Step 3: Create Tests Directory

Create the tests directory structure:

```bash
mkdir -p tests
touch tests/__init__.py
```

### Step 4: Verify Installation

Test that pytest is working:

```bash
# Check version
pytest --version

# Run all tests (will find no tests initially)
pytest

# Run with verbose output
pytest -v

# Run specific test file
pytest tests/test_example.py
```

## Test Directory Structure

Recommended structure:

```
project/
├── src/
│   └── mymodule/
│       ├── __init__.py
│       └── calculator.py
├── tests/
│   ├── __init__.py
│   ├── unit/
│   │   ├── __init__.py
│   │   └── test_calculator.py
│   ├── integration/
│   │   ├── __init__.py
│   │   └── test_api.py
│   └── conftest.py  # Shared fixtures
└── pytest.ini
```

## Writing Tests

### Basic Test Example

```python
# tests/unit/test_calculator.py

def test_addition():
    """Test that addition works correctly."""
    result = 2 + 2
    assert result == 4

def test_subtraction():
    """Test that subtraction works correctly."""
    result = 5 - 3
    assert result == 2
```

### Using Fixtures

```python
# tests/conftest.py
import pytest

@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {"name": "Test", "value": 42}

# tests/unit/test_data.py
def test_with_fixture(sample_data):
    """Test using fixture."""
    assert sample_data["name"] == "Test"
    assert sample_data["value"] == 42
```

### Async Tests

```python
# tests/unit/test_async.py
import pytest

@pytest.mark.asyncio
async def test_async_function():
    """Test async function."""
    result = await some_async_function()
    assert result == expected_value
```

### Test Markers

```python
# tests/unit/test_features.py
import pytest

@pytest.mark.unit
def test_fast_function():
    """Quick unit test."""
    assert True

@pytest.mark.integration
def test_database_connection():
    """Integration test requiring database."""
    # Test database operations
    pass

@pytest.mark.slow
def test_long_running_operation():
    """Slow test."""
    # Long-running test
    pass
```

## Running Tests

### Basic Commands

```bash
# Run all tests
pytest

# Run with verbose output
pytest -v

# Run specific file
pytest tests/test_example.py

# Run specific test
pytest tests/test_example.py::test_function_name

# Run tests matching pattern
pytest -k "test_add"
```

### Using Markers

```bash
# Run only unit tests
pytest -m unit

# Run only integration tests
pytest -m integration

# Exclude slow tests
pytest -m "not slow"

# Run unit OR integration
pytest -m "unit or integration"
```

### Coverage Reports

```bash
# Run with coverage
pytest --cov=src

# Generate HTML coverage report
pytest --cov=src --cov-report=html

# Generate terminal coverage report
pytest --cov=src --cov-report=term

# Fail if coverage below threshold
pytest --cov=src --cov-fail-under=80
```

## Configuration Details

The provided configuration includes:

- **Test paths**: `tests/` directory
- **File patterns**: `test_*.py` and `*_test.py`
- **Async support**: Automatic async test detection
- **Markers**: unit, integration, slow, smoke, e2e
- **Output**: Short tracebacks, verbose mode
- **Cache**: Stored in `/tmp/.pytest_cache`

## Integration with Make

Add to your Makefile:

```makefile
.PHONY: test test-unit test-integration test-coverage

test:
	pytest -v

test-unit:
	pytest -v -m unit

test-integration:
	pytest -v -m integration

test-coverage:
	pytest --cov=src --cov-report=term --cov-report=html
```

## Pytest Plugins

Common useful plugins:

```bash
# Already included:
pytest-asyncio    # Async test support
pytest-cov        # Coverage reporting

# Additional plugins you might want:
pytest-mock       # Mocking support
pytest-xdist      # Parallel test execution
pytest-timeout    # Test timeouts
pytest-benchmark  # Performance benchmarking
```

Install additional plugins:
```bash
poetry add --group dev pytest-mock pytest-xdist
```

## Best Practices

### 1. Test Organization
```python
# Group related tests in classes
class TestCalculator:
    def test_addition(self):
        assert 2 + 2 == 4

    def test_subtraction(self):
        assert 5 - 3 == 2
```

### 2. Descriptive Test Names
```python
# Good
def test_user_creation_with_valid_email_succeeds():
    ...

# Bad
def test_user():
    ...
```

### 3. Use Fixtures for Setup
```python
@pytest.fixture
def database_connection():
    """Create database connection for tests."""
    conn = create_connection()
    yield conn
    conn.close()
```

### 4. Parametrize Tests
```python
@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
])
def test_square(input, expected):
    assert input ** 2 == expected
```

### 5. Test Exceptions
```python
def test_division_by_zero_raises_error():
    with pytest.raises(ZeroDivisionError):
        1 / 0
```

## Success Criteria

Pytest is successfully installed when:
- ✅ `pytest --version` works
- ✅ `pytest.ini` configuration exists
- ✅ `tests/` directory exists
- ✅ `pytest` command runs without errors
- ✅ Can write and run tests successfully
- ✅ Coverage reports work with `pytest --cov`
- ✅ Make targets work (if Makefile integration completed)

## Troubleshooting

### Issue: Tests not discovered
**Solution**: Check that test files match naming patterns (`test_*.py` or `*_test.py`)

### Issue: Import errors
**Solution**: Ensure your package is installed in development mode:
```bash
pip install -e .  # or poetry install
```

### Issue: Async tests fail
**Solution**: Install pytest-asyncio and ensure `asyncio_mode = "auto"` in config

### Issue: Fixtures not found
**Solution**: Check that `conftest.py` is in the right location (tests root or parent directories)
