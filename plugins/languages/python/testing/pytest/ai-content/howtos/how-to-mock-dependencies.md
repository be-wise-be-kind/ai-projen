# How to Mock Dependencies

**Purpose**: Step-by-step guide for mocking external dependencies in pytest tests

**Scope**: unittest.mock, pytest-mock, mocking HTTP requests, database calls, external APIs, time, and file system operations

**Overview**: Comprehensive guide for isolating tests from external dependencies using mocks, stubs, and fakes.
    Covers pytest-mock (fixture-based), unittest.mock (standard library), mocking patterns for common scenarios,
    and best practices for maintainable test mocks.

**Dependencies**: pytest, pytest-mock, httpx (for testing), pytest-httpx (for mocking httpx)

**Exports**: Mocking patterns, fixture examples, isolation techniques

**Related**: Testing best practices, test isolation, dependency injection

**Implementation**: pytest-mock fixtures, unittest.mock decorators, contextlib patterns

---

## Prerequisites

- pytest installed in your project
- pytest-mock plugin installed
- Understanding of test isolation principles
- Familiarity with the code being tested

## Why Mock?

**Mocking isolates tests from**:
- External APIs and web services
- Databases and file systems
- Time-dependent behavior
- Random number generation
- Network calls
- Third-party services (payment gateways, email, etc.)

**Benefits**:
- Fast tests (no network I/O)
- Reliable tests (no external dependencies)
- Predictable tests (controlled outputs)
- Offline testing (no internet required)

## Mocking Tools

### pytest-mock (Recommended)
Fixture-based mocking, cleaner syntax:
```python
def test_example(mocker):
    mock_obj = mocker.patch('module.function')
```

### unittest.mock (Standard Library)
Built-in, decorator-based:
```python
from unittest.mock import patch, MagicMock

@patch('module.function')
def test_example(mock_func):
    pass
```

## Common Mocking Patterns

### 1. Mocking HTTP Requests (httpx/requests)

**Scenario**: Testing code that calls external APIs

```python
import httpx
import pytest

# Code being tested (in app/services.py)
async def fetch_user_data(user_id: int) -> dict:
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.example.com/users/{user_id}")
        response.raise_for_status()
        return response.json()

# Test with pytest-mock
@pytest.mark.asyncio
async def test_fetch_user_data_success(mocker):
    # Arrange
    mock_response = mocker.Mock()
    mock_response.json.return_value = {"id": 1, "name": "Alice"}
    mock_response.raise_for_status = mocker.Mock()

    mock_get = mocker.patch("httpx.AsyncClient.get", return_value=mock_response)

    # Act
    result = await fetch_user_data(user_id=1)

    # Assert
    assert result == {"id": 1, "name": "Alice"}
    mock_get.assert_called_once_with("https://api.example.com/users/1")
```

**Alternative: pytest-httpx**
```python
import pytest
from pytest_httpx import HTTPXMock

@pytest.mark.asyncio
async def test_fetch_user_data_with_httpx_mock(httpx_mock: HTTPXMock):
    # Arrange
    httpx_mock.add_response(
        url="https://api.example.com/users/1",
        json={"id": 1, "name": "Alice"},
        status_code=200
    )

    # Act
    result = await fetch_user_data(user_id=1)

    # Assert
    assert result == {"id": 1, "name": "Alice"}
```

### 2. Mocking Database Calls

**Scenario**: Testing code that queries a database

```python
from sqlalchemy.orm import Session
from app.models import User
from app.services import get_user_by_email

# Code being tested
def get_user_by_email(db: Session, email: str) -> User | None:
    return db.query(User).filter(User.email == email).first()

# Test with mock database session
def test_get_user_by_email_found(mocker):
    # Arrange
    mock_db = mocker.Mock(spec=Session)
    mock_user = User(id=1, email="alice@example.com", name="Alice")

    mock_query = mocker.Mock()
    mock_query.filter.return_value.first.return_value = mock_user
    mock_db.query.return_value = mock_query

    # Act
    result = get_user_by_email(mock_db, "alice@example.com")

    # Assert
    assert result.id == 1
    assert result.email == "alice@example.com"
    mock_db.query.assert_called_once_with(User)

def test_get_user_by_email_not_found(mocker):
    # Arrange
    mock_db = mocker.Mock(spec=Session)
    mock_query = mocker.Mock()
    mock_query.filter.return_value.first.return_value = None
    mock_db.query.return_value = mock_query

    # Act
    result = get_user_by_email(mock_db, "notfound@example.com")

    # Assert
    assert result is None
```

### 3. Mocking Time/DateTime

**Scenario**: Testing time-dependent behavior

```python
from datetime import datetime, timedelta
from app.services import is_token_expired

# Code being tested
def is_token_expired(token_created_at: datetime, ttl_seconds: int = 3600) -> bool:
    return datetime.utcnow() > token_created_at + timedelta(seconds=ttl_seconds)

# Test with mocked time
def test_token_not_expired(mocker):
    # Arrange
    fixed_time = datetime(2024, 1, 1, 12, 0, 0)
    token_created = datetime(2024, 1, 1, 11, 30, 0)  # 30 min ago

    mocker.patch("app.services.datetime").utcnow.return_value = fixed_time

    # Act
    result = is_token_expired(token_created, ttl_seconds=3600)

    # Assert
    assert result is False  # Not expired (30min < 60min)

def test_token_expired(mocker):
    # Arrange
    fixed_time = datetime(2024, 1, 1, 12, 0, 0)
    token_created = datetime(2024, 1, 1, 10, 0, 0)  # 2 hours ago

    mocker.patch("app.services.datetime").utcnow.return_value = fixed_time

    # Act
    result = is_token_expired(token_created, ttl_seconds=3600)

    # Assert
    assert result is True  # Expired (2h > 1h)
```

### 4. Mocking File System Operations

**Scenario**: Testing code that reads/writes files

```python
from pathlib import Path
from app.services import read_config_file

# Code being tested
def read_config_file(config_path: Path) -> dict:
    with open(config_path, "r") as f:
        return json.load(f)

# Test with mocked file operations
def test_read_config_file(mocker):
    # Arrange
    mock_config_data = {"api_key": "test-key-123", "timeout": 30}

    mock_open = mocker.mock_open(read_data=json.dumps(mock_config_data))
    mocker.patch("builtins.open", mock_open)

    # Act
    result = read_config_file(Path("/etc/config.json"))

    # Assert
    assert result == mock_config_data
    mock_open.assert_called_once_with(Path("/etc/config.json"), "r")
```

### 5. Mocking Environment Variables

**Scenario**: Testing code that uses environment variables

```python
import os
from app.config import get_database_url

# Code being tested
def get_database_url() -> str:
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "5432")
    return f"postgresql://{host}:{port}/mydb"

# Test with mocked environment
def test_get_database_url_with_env(mocker):
    # Arrange
    mocker.patch.dict(os.environ, {
        "DB_HOST": "prod-db.example.com",
        "DB_PORT": "5433"
    })

    # Act
    result = get_database_url()

    # Assert
    assert result == "postgresql://prod-db.example.com:5433/mydb"

def test_get_database_url_defaults(mocker):
    # Arrange
    mocker.patch.dict(os.environ, {}, clear=True)  # Clear all env vars

    # Act
    result = get_database_url()

    # Assert
    assert result == "postgresql://localhost:5432/mydb"
```

### 6. Mocking Class Methods and Attributes

**Scenario**: Testing code that uses class instances

```python
from app.services import UserService
from app.repositories import UserRepository

# Code being tested
class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo

    def create_user(self, email: str, name: str) -> dict:
        user = self.repo.create(email=email, name=name)
        return {"id": user.id, "email": user.email}

# Test with mocked repository
def test_create_user(mocker):
    # Arrange
    mock_repo = mocker.Mock(spec=UserRepository)
    mock_user = mocker.Mock(id=1, email="alice@example.com")
    mock_repo.create.return_value = mock_user

    service = UserService(repo=mock_repo)

    # Act
    result = service.create_user(email="alice@example.com", name="Alice")

    # Assert
    assert result == {"id": 1, "email": "alice@example.com"}
    mock_repo.create.assert_called_once_with(email="alice@example.com", name="Alice")
```

### 7. Mocking Side Effects and Exceptions

**Scenario**: Testing error handling

```python
from app.services import retry_operation

# Code being tested
def retry_operation(operation, max_retries=3):
    for attempt in range(max_retries):
        try:
            return operation()
        except Exception as e:
            if attempt == max_retries - 1:
                raise
            continue

# Test with side effects
def test_retry_operation_succeeds_on_second_attempt(mocker):
    # Arrange
    mock_operation = mocker.Mock()
    mock_operation.side_effect = [
        Exception("First attempt fails"),
        "Success"
    ]

    # Act
    result = retry_operation(mock_operation, max_retries=3)

    # Assert
    assert result == "Success"
    assert mock_operation.call_count == 2

def test_retry_operation_fails_after_max_retries(mocker):
    # Arrange
    mock_operation = mocker.Mock()
    mock_operation.side_effect = Exception("Always fails")

    # Act & Assert
    with pytest.raises(Exception, match="Always fails"):
        retry_operation(mock_operation, max_retries=3)

    assert mock_operation.call_count == 3
```

## Mock Assertions

### Verify Mock Was Called
```python
mock_func.assert_called()  # Called at least once
mock_func.assert_called_once()  # Called exactly once
mock_func.assert_called_with(arg1, arg2, kwarg=value)  # Called with specific args
mock_func.assert_called_once_with(arg1, arg2)  # Called once with specific args
mock_func.assert_not_called()  # Never called
```

### Check Call Count
```python
assert mock_func.call_count == 3
```

### Inspect Call Arguments
```python
args, kwargs = mock_func.call_args
call_list = mock_func.call_args_list  # List of all calls
```

## Best Practices

### 1. Mock at the Right Level
```python
# ❌ Don't mock too deep
mocker.patch("httpx.AsyncClient.__aenter__.__aexit__.get")

# ✅ Mock at the boundary
mocker.patch("app.services.httpx.AsyncClient.get")
```

### 2. Use spec= for Type Safety
```python
# ✅ Mock respects original interface
mock_db = mocker.Mock(spec=Session)
mock_db.nonexistent_method()  # Raises AttributeError
```

### 3. Avoid Over-Mocking
```python
# ❌ Too much mocking
def test_calculator(mocker):
    mocker.patch("builtins.int")
    mocker.patch("builtins.str")
    # Testing nothing real...

# ✅ Mock only external dependencies
def test_fetch_user(mocker):
    mocker.patch("httpx.AsyncClient.get")  # External API
    # Logic being tested is real
```

### 4. Use Fixtures for Common Mocks
```python
# conftest.py
@pytest.fixture
def mock_db_session(mocker):
    return mocker.Mock(spec=Session)

# test file
def test_something(mock_db_session):
    # Use the fixture
    pass
```

## Troubleshooting

### Mock Not Working?
- Check import path (mock where it's used, not where it's defined)
- Verify patch target string is correct
- Ensure patch is active during test execution

### AttributeError on Mock?
- Add `spec=` parameter to match real object
- Check for typos in attribute names

### Mock Called But Assertion Fails?
- Verify call arguments match exactly
- Check if mock was reset between calls
- Inspect `call_args_list` to see actual calls

## Template Reference

See `templates/mock-external-service.py.template` for complete mocking examples.

---

**Key Takeaway**: Mock external boundaries (APIs, databases, file system) to isolate and speed up tests, but keep business logic real.
