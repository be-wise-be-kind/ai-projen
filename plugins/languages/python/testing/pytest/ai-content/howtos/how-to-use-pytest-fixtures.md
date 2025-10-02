# How to Use pytest Fixtures

**Purpose**: Master pytest fixtures for test setup, teardown, and dependency injection

**Scope**: Fixture scopes, conftest.py, fixture composition, parametrization

**Dependencies**: pytest

---

## Basic Fixture

```python
import pytest

@pytest.fixture
def sample_data():
    return {"key": "value", "count": 42}

def test_uses_fixture(sample_data):
    assert sample_data["key"] == "value"
    assert sample_data["count"] == 42
```

## Fixture Scopes

```python
@pytest.fixture(scope="function")  # Default: new for each test
def function_fixture():
    return "function"

@pytest.fixture(scope="class")  # Shared across test class
def class_fixture():
    return "class"

@pytest.fixture(scope="module")  # Shared across test file
def module_fixture():
    return "module"

@pytest.fixture(scope="session")  # Shared across entire test session
def session_fixture():
    return "session"
```

## Setup and Teardown

```python
@pytest.fixture
def resource():
    # Setup
    connection = open_connection()

    yield connection  # Test runs here

    # Teardown
    connection.close()
```

## conftest.py for Shared Fixtures

```python
# conftest.py in tests/ directory
import pytest

@pytest.fixture
def db_session():
    """Available to all tests in this directory and subdirectories."""
    session = create_test_db_session()
    yield session
    session.close()
```

## Fixture Composition (Fixtures Using Other Fixtures)

```python
@pytest.fixture
def database():
    return create_test_database()

@pytest.fixture
def user(database):
    user = User(email="test@example.com")
    database.add(user)
    database.commit()
    return user

def test_user_exists(user, database):
    assert database.query(User).filter_by(email=user.email).first() is not None
```

## Parametrized Fixtures

```python
@pytest.fixture(params=["sqlite", "postgresql", "mysql"])
def database_url(request):
    return f"{request.param}://localhost/testdb"

def test_database_connection(database_url):
    # Test runs 3 times, once for each parameter
    conn = connect(database_url)
    assert conn is not None
```

## Autouse Fixtures

```python
@pytest.fixture(autouse=True)
def setup_test_env():
    """Automatically runs before every test."""
    os.environ["TEST_MODE"] = "true"
    yield
    del os.environ["TEST_MODE"]
```

## Request Fixture for Metadata

```python
@pytest.fixture
def configured_object(request):
    # Access test function name
    print(f"Setting up for: {request.function.__name__}")

    # Access markers
    marker = request.node.get_closest_marker("slow")
    if marker:
        return SlowObject()
    return FastObject()
```

## Fixture Finalization

```python
@pytest.fixture
def resource(request):
    res = acquire_resource()

    def cleanup():
        res.release()

    request.addfinalizer(cleanup)
    return res
```

See `conftest.py.template` for complete fixture examples.
