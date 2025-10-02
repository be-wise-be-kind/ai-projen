# Pytest - Python Testing Framework

**What is Pytest?**

Pytest is a mature, full-featured Python testing framework that makes it easy to write small, readable tests and scales to support complex functional testing for applications and libraries.

**Why Pytest?**

- **Simple syntax**: No boilerplate, just write functions
- **Powerful features**: Fixtures, parametrization, markers
- **Rich plugin ecosystem**: 800+ plugins available
- **Excellent reporting**: Clear, detailed test output
- **Async support**: First-class async/await test support
- **Community standard**: Most popular Python testing framework

**What This Plugin Provides**

- Pre-configured pytest settings for Python 3.11+
- Async test support (pytest-asyncio)
- Coverage reporting (pytest-cov)
- Custom markers (unit, integration, slow, smoke, e2e)
- Sensible defaults for test discovery

**Writing Tests**

```python
# tests/test_example.py

def test_simple():
    """A simple test."""
    assert 1 + 1 == 2

@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (2, 4),
    (3, 6),
])
def test_double(input, expected):
    """Test with multiple inputs."""
    assert input * 2 == expected

@pytest.fixture
def user_data():
    """Fixture providing test data."""
    return {"name": "Alice", "age": 30}

def test_with_fixture(user_data):
    """Test using fixture."""
    assert user_data["name"] == "Alice"
```

**Commands**

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src

# Run only unit tests
pytest -m unit

# Run specific file
pytest tests/test_example.py
```

**Markers**

```python
@pytest.mark.unit           # Fast, isolated unit test
@pytest.mark.integration    # Integration test
@pytest.mark.slow          # Slow-running test
@pytest.mark.smoke         # Smoke test
@pytest.mark.e2e           # End-to-end test
```

**Configuration Location**

- `config/pytest.ini` - Pytest configuration file (copy to project root)

**Learn More**

- [Pytest Documentation](https://docs.pytest.org/)
- [Pytest Fixtures](https://docs.pytest.org/en/stable/fixture.html)
- [Pytest Plugins](https://docs.pytest.org/en/stable/plugins.html)
