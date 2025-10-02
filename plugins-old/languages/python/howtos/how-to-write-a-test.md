# How to Write a Test

**Purpose**: Step-by-step guide for writing comprehensive tests using pytest with Docker-first development and coverage reporting

**Scope**: pytest test creation, fixtures, parametrization, async testing, mocking, coverage analysis, Docker-based testing

**Overview**: Comprehensive guide for implementing robust tests using pytest framework. Covers test structure, AAA pattern, fixture design, parametrization for multiple scenarios, async/await testing, mocking external dependencies, and coverage reporting in Docker containers. Ensures tests are maintainable, reliable, and executable across all environments.

**Dependencies**: pytest, pytest-asyncio, pytest-cov, pytest-mock, Docker, testing best practices

**Exports**: Testing workflow, fixture patterns, parametrization techniques, Docker test execution

**Related**: Test-driven development, API testing, database testing, mocking strategies

**Implementation**: pytest test cases, conftest configuration, fixtures, Docker test runners, coverage tools

---

This guide provides step-by-step instructions for writing comprehensive tests using pytest with Docker-first development patterns.

## Prerequisites

- Python plugin installed in your project
- Docker and Docker Compose configured
- pytest and related tools installed
- Understanding of testing concepts
- Basic knowledge of assertions

## Docker-First Development Pattern

All tests should be run in Docker containers first to ensure consistent behavior.

**Environment Priority**:
1. Docker containers (recommended)
2. Poetry virtual environment (fallback)
3. Direct local execution (last resort)

## Steps to Write a Test

### 1. Setup Testing Dependencies

**Add to `pyproject.toml`**:
```toml
[tool.poetry.group.dev.dependencies]
pytest = "^7.4.0"
pytest-asyncio = "^0.21.0"  # For async tests
pytest-cov = "^4.1.0"  # For coverage
pytest-mock = "^3.11.1"  # For mocking
pytest-env = "^0.8.2"  # For environment variables
httpx = "^0.24.0"  # For testing FastAPI
faker = "^19.0.0"  # For generating test data

[tool.pytest.ini_options]
minversion = "7.0"
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "-v",
    "--strict-markers",
    "--tb=short",
    "--cov=backend",
    "--cov-report=term-missing",
    "--cov-report=html",
]
markers = [
    "unit: Unit tests",
    "integration: Integration tests",
    "slow: Slow running tests",
    "asyncio: Async tests",
]
asyncio_mode = "auto"
```

**Rebuild Docker**:
```bash
make python-install  # Rebuilds with test dependencies
```

### 2. Create Test Directory Structure

```bash
# Create test directories
mkdir -p tests/{unit,integration,fixtures}

# Create conftest.py files
touch tests/conftest.py
touch tests/unit/conftest.py
touch tests/integration/conftest.py

# Create __init__.py for imports
touch tests/__init__.py
```

**Recommended structure**:
```
tests/
├── __init__.py
├── conftest.py              # Root fixtures and configuration
├── unit/                    # Unit tests
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_models.py
│   ├── test_crud.py
│   └── test_utils.py
├── integration/             # Integration tests
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_api.py
│   └── test_database.py
└── fixtures/                # Shared fixtures and test data
    ├── __init__.py
    └── test_data.py
```

### 3. Create Your First Test

**Using the template**:
```bash
cp plugins/languages/python/templates/pytest-test.py.template tests/unit/test_example.py
```

**Manual creation** (`tests/unit/test_example.py`):
```python
"""Example unit tests demonstrating pytest patterns."""

import pytest
from backend.utils.calculator import Calculator


class TestCalculator:
    """Tests for Calculator class."""

    def test_addition(self) -> None:
        """Test addition operation.

        Follows AAA pattern:
        - Arrange: Set up test data
        - Act: Execute the operation
        - Assert: Verify the result
        """
        # Arrange
        calc = Calculator()

        # Act
        result = calc.add(2, 3)

        # Assert
        assert result == 5

    def test_division(self) -> None:
        """Test division operation."""
        # Arrange
        calc = Calculator()

        # Act
        result = calc.divide(10, 2)

        # Assert
        assert result == 5.0

    def test_division_by_zero(self) -> None:
        """Test division by zero raises exception."""
        # Arrange
        calc = Calculator()

        # Act & Assert
        with pytest.raises(ZeroDivisionError):
            calc.divide(10, 0)

    @pytest.mark.parametrize("a,b,expected", [
        (1, 2, 3),
        (0, 0, 0),
        (-1, 1, 0),
        (100, 200, 300),
    ])
    def test_addition_parametrized(self, a: int, b: int, expected: int) -> None:
        """Test addition with multiple inputs."""
        calc = Calculator()
        assert calc.add(a, b) == expected
```

### 4. Create Fixtures

**Create conftest.py** (`tests/conftest.py`):
```python
"""Root conftest with shared fixtures."""

import pytest
from typing import Generator
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from fastapi.testclient import TestClient
from backend.core.database import Base
from backend.main import app


@pytest.fixture(scope="session")
def test_db_engine():
    """Create test database engine.

    Scope: session - created once for all tests
    """
    engine = create_engine(
        "postgresql://user:password@db-test:5432/test_db",
        pool_pre_ping=True,
    )
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)
    engine.dispose()


@pytest.fixture(scope="function")
def db_session(test_db_engine) -> Generator[Session, None, None]:
    """Create database session for test.

    Scope: function - new session for each test
    Automatically rolls back after test
    """
    connection = test_db_engine.connect()
    transaction = connection.begin()
    SessionLocal = sessionmaker(bind=connection)
    session = SessionLocal()

    yield session

    session.close()
    transaction.rollback()
    connection.close()


@pytest.fixture
def client(db_session: Session) -> TestClient:
    """Create test client with test database.

    Returns:
        FastAPI TestClient for making requests
    """
    def override_get_db():
        try:
            yield db_session
        finally:
            pass

    from backend.core.database import get_db
    app.dependency_overrides[get_db] = override_get_db

    with TestClient(app) as test_client:
        yield test_client

    app.dependency_overrides.clear()


@pytest.fixture
def sample_user_data() -> dict:
    """Provide sample user data for tests."""
    return {
        "email": "test@example.com",
        "username": "testuser",
        "password": "testpass123",
        "full_name": "Test User"
    }
```

### 5. Test API Endpoints

**Create API test** (`tests/integration/test_api_users.py`):
```python
"""Integration tests for user API endpoints."""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from backend.models.user import User


class TestUserAPI:
    """Tests for user API endpoints."""

    def test_create_user(self, client: TestClient, sample_user_data: dict) -> None:
        """Test creating a new user."""
        # Act
        response = client.post("/api/users", json=sample_user_data)

        # Assert
        assert response.status_code == 201
        data = response.json()
        assert data["email"] == sample_user_data["email"]
        assert data["username"] == sample_user_data["username"]
        assert "id" in data
        assert "password" not in data  # Ensure password not returned

    def test_create_user_duplicate_email(
        self,
        client: TestClient,
        db_session: Session,
        sample_user_data: dict
    ) -> None:
        """Test creating user with duplicate email fails."""
        # Arrange - create first user
        response1 = client.post("/api/users", json=sample_user_data)
        assert response1.status_code == 201

        # Act - try to create duplicate
        response2 = client.post("/api/users", json=sample_user_data)

        # Assert
        assert response2.status_code == 400
        assert "already registered" in response2.json()["detail"].lower()

    def test_get_user(
        self,
        client: TestClient,
        db_session: Session,
        sample_user_data: dict
    ) -> None:
        """Test retrieving a user by ID."""
        # Arrange - create user
        create_response = client.post("/api/users", json=sample_user_data)
        user_id = create_response.json()["id"]

        # Act
        response = client.get(f"/api/users/{user_id}")

        # Assert
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == user_id
        assert data["email"] == sample_user_data["email"]

    def test_get_user_not_found(self, client: TestClient) -> None:
        """Test retrieving non-existent user returns 404."""
        # Act
        response = client.get("/api/users/99999")

        # Assert
        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    @pytest.mark.parametrize("invalid_email", [
        "notanemail",
        "@example.com",
        "test@",
        "",
    ])
    def test_create_user_invalid_email(
        self,
        client: TestClient,
        sample_user_data: dict,
        invalid_email: str
    ) -> None:
        """Test creating user with invalid email fails."""
        # Arrange
        sample_user_data["email"] = invalid_email

        # Act
        response = client.post("/api/users", json=sample_user_data)

        # Assert
        assert response.status_code == 422  # Validation error
```

### 6. Test Async Functions

**Create async test** (`tests/unit/test_async_service.py`):
```python
"""Tests for async service functions."""

import pytest
from backend.services.external_api import ExternalAPIService


class TestExternalAPIService:
    """Tests for ExternalAPIService."""

    @pytest.mark.asyncio
    async def test_fetch_data(self) -> None:
        """Test fetching data from external API."""
        # Arrange
        service = ExternalAPIService()

        # Act
        result = await service.fetch_data("test-id")

        # Assert
        assert result is not None
        assert "data" in result

    @pytest.mark.asyncio
    async def test_fetch_data_with_mock(self, mocker) -> None:
        """Test fetching data with mocked HTTP client."""
        # Arrange
        service = ExternalAPIService()
        mock_response = {"data": "test data"}

        # Mock the HTTP client
        mock_get = mocker.patch(
            "httpx.AsyncClient.get",
            return_value=mocker.Mock(
                status_code=200,
                json=lambda: mock_response
            )
        )

        # Act
        result = await service.fetch_data("test-id")

        # Assert
        assert result == mock_response
        mock_get.assert_called_once()
```

### 7. Test Database Operations

**Create database test** (`tests/integration/test_database.py`):
```python
"""Integration tests for database operations."""

import pytest
from sqlalchemy.orm import Session
from backend.models.user import User
from backend.crud.user import create_user, get_user, update_user
from backend.schemas.user import UserCreate, UserUpdate


class TestUserCRUD:
    """Tests for user CRUD operations."""

    def test_create_user(self, db_session: Session) -> None:
        """Test creating user in database."""
        # Arrange
        user_data = UserCreate(
            email="test@example.com",
            username="testuser",
            password="password123"
        )

        # Act
        user = create_user(db_session, user_data)

        # Assert
        assert user.id is not None
        assert user.email == user_data.email
        assert user.username == user_data.username
        assert user.hashed_password != user_data.password  # Password should be hashed

    def test_get_user(self, db_session: Session) -> None:
        """Test retrieving user from database."""
        # Arrange
        user_data = UserCreate(
            email="test@example.com",
            username="testuser",
            password="password123"
        )
        created_user = create_user(db_session, user_data)

        # Act
        retrieved_user = get_user(db_session, created_user.id)

        # Assert
        assert retrieved_user is not None
        assert retrieved_user.id == created_user.id
        assert retrieved_user.email == created_user.email

    def test_update_user(self, db_session: Session) -> None:
        """Test updating user in database."""
        # Arrange
        user_data = UserCreate(
            email="test@example.com",
            username="testuser",
            password="password123"
        )
        user = create_user(db_session, user_data)

        # Act
        update_data = UserUpdate(full_name="Updated Name")
        updated_user = update_user(db_session, user.id, update_data)

        # Assert
        assert updated_user is not None
        assert updated_user.full_name == "Updated Name"
        assert updated_user.email == user.email  # Unchanged fields remain
```

### 8. Use Mocking

**Create test with mocks** (`tests/unit/test_with_mocks.py`):
```python
"""Tests demonstrating mocking patterns."""

import pytest
from unittest.mock import Mock, patch, MagicMock
from backend.services.notification import NotificationService


class TestNotificationService:
    """Tests for NotificationService."""

    def test_send_email_with_mock(self, mocker) -> None:
        """Test sending email with mocked SMTP."""
        # Arrange
        service = NotificationService()
        mock_smtp = mocker.patch("smtplib.SMTP")

        # Act
        result = service.send_email(
            to="user@example.com",
            subject="Test",
            body="Test message"
        )

        # Assert
        assert result is True
        mock_smtp.assert_called_once()

    def test_send_email_failure(self, mocker) -> None:
        """Test email sending handles failures."""
        # Arrange
        service = NotificationService()
        mocker.patch(
            "smtplib.SMTP",
            side_effect=Exception("SMTP error")
        )

        # Act
        result = service.send_email(
            to="user@example.com",
            subject="Test",
            body="Test"
        )

        # Assert
        assert result is False

    @pytest.fixture
    def mock_external_api(self, mocker):
        """Fixture providing mocked external API."""
        mock = mocker.patch("backend.services.external.requests.get")
        mock.return_value = Mock(
            status_code=200,
            json=lambda: {"data": "test"}
        )
        return mock

    def test_with_fixture_mock(self, mock_external_api) -> None:
        """Test using mock fixture."""
        from backend.services.external import fetch_data

        # Act
        result = fetch_data("test-id")

        # Assert
        assert result["data"] == "test"
        mock_external_api.assert_called_once()
```

### 9. Run Tests in Docker

**Run all tests**:
```bash
# Run all tests in Docker
make test-python

# Run with verbose output
docker exec -it python-backend-container pytest -v

# Run specific test file
docker exec -it python-backend-container pytest tests/unit/test_example.py

# Run specific test
docker exec -it python-backend-container pytest tests/unit/test_example.py::TestCalculator::test_addition

# Run tests matching pattern
docker exec -it python-backend-container pytest -k "test_user"

# Run with markers
docker exec -it python-backend-container pytest -m unit
docker exec -it python-backend-container pytest -m integration
```

**Run with coverage**:
```bash
# Run tests with coverage report
make test-coverage-python

# Or directly in Docker
docker exec -it python-backend-container pytest --cov=backend --cov-report=html

# View coverage report (copy from container)
docker cp python-backend-container:/app/htmlcov ./htmlcov
open htmlcov/index.html
```

### 10. Generate Test Data

**Using Faker** (`tests/fixtures/factories.py`):
```python
"""Test data factories using Faker."""

from faker import Faker
from backend.schemas.user import UserCreate

fake = Faker()


def create_fake_user(**overrides) -> UserCreate:
    """Create fake user data.

    Args:
        **overrides: Override specific fields

    Returns:
        UserCreate schema with fake data
    """
    data = {
        "email": fake.email(),
        "username": fake.user_name(),
        "password": fake.password(),
        "full_name": fake.name(),
    }
    data.update(overrides)
    return UserCreate(**data)


def create_fake_users(count: int = 5) -> list[UserCreate]:
    """Create multiple fake users."""
    return [create_fake_user() for _ in range(count)]
```

**Use in tests**:
```python
from tests.fixtures.factories import create_fake_user, create_fake_users


def test_with_fake_data(db_session: Session) -> None:
    """Test using generated fake data."""
    # Create single user
    user_data = create_fake_user()
    user = create_user(db_session, user_data)
    assert user.id is not None

    # Create multiple users
    users_data = create_fake_users(count=10)
    for data in users_data:
        user = create_user(db_session, data)
        assert user.id is not None
```

## Templates Reference

This guide references the following templates:

- `plugins/languages/python/templates/pytest-test.py.template` - Basic test structure
- `plugins/languages/python/templates/pytest-conftest.py.template` - Fixtures and configuration
- `plugins/languages/python/templates/pytest-api-test.py.template` - API testing patterns

## Verification Steps

### 1. Run All Tests

```bash
# In Docker (recommended)
make test-python

# With Poetry
poetry run pytest

# Check exit code
echo $?  # Should be 0 for success
```

### 2. Check Coverage

```bash
# Generate coverage report
make test-coverage-python

# View in terminal
docker exec -it python-backend-container pytest --cov=backend --cov-report=term-missing

# Ensure minimum coverage (e.g., 80%)
docker exec -it python-backend-container pytest --cov=backend --cov-fail-under=80
```

### 3. Run Specific Test Types

```bash
# Unit tests only
docker exec -it python-backend-container pytest -m unit

# Integration tests only
docker exec -it python-backend-container pytest -m integration

# Fast tests only (exclude slow)
docker exec -it python-backend-container pytest -m "not slow"
```

### 4. Debug Failed Tests

```bash
# Run with full traceback
docker exec -it python-backend-container pytest --tb=long

# Stop on first failure
docker exec -it python-backend-container pytest -x

# Enter debugger on failure
docker exec -it python-backend-container pytest --pdb

# Show print statements
docker exec -it python-backend-container pytest -s
```

## Best Practices

### 1. Follow AAA Pattern

Always structure tests with Arrange-Act-Assert:

```python
def test_example():
    """Test following AAA pattern."""
    # Arrange - set up test data and preconditions
    calc = Calculator()
    a = 5
    b = 3

    # Act - execute the operation being tested
    result = calc.add(a, b)

    # Assert - verify the result
    assert result == 8
```

### 2. Use Descriptive Test Names

```python
# ✓ Good - describes what is being tested
def test_create_user_with_valid_data_returns_user_object():
    pass

def test_create_user_with_duplicate_email_raises_error():
    pass

# ✗ Bad - vague or unclear
def test_user():
    pass

def test_case_1():
    pass
```

### 3. One Assert Per Test (When Possible)

```python
# ✓ Good - focused test
def test_user_email():
    user = create_user()
    assert user.email == "test@example.com"

def test_user_username():
    user = create_user()
    assert user.username == "testuser"

# ✗ Bad - testing multiple things
def test_user():
    user = create_user()
    assert user.email == "test@example.com"
    assert user.username == "testuser"
    assert user.is_active is True
    # If first assert fails, others don't run
```

### 4. Use Fixtures for Common Setup

```python
# ✓ Good - use fixture
@pytest.fixture
def sample_user(db_session):
    return create_user(db_session, UserCreate(email="test@example.com", ...))

def test_user_update(db_session, sample_user):
    updated = update_user(db_session, sample_user.id, ...)
    assert updated.email == sample_user.email

# ✗ Bad - duplicate setup
def test_user_update(db_session):
    user = create_user(db_session, UserCreate(email="test@example.com", ...))
    updated = update_user(db_session, user.id, ...)
    assert updated.email == user.email
```

### 5. Use Parametrize for Multiple Cases

```python
@pytest.mark.parametrize("input_value,expected", [
    ("valid@email.com", True),
    ("invalid", False),
    ("@example.com", False),
    ("test@", False),
])
def test_email_validation(input_value, expected):
    """Test email validation with multiple cases."""
    result = is_valid_email(input_value)
    assert result == expected
```

## Common Issues and Solutions

### Tests Pass Locally But Fail in Docker

**Issue**: Tests succeed locally but fail in CI/Docker

**Solutions**:
1. Check for hardcoded paths
2. Verify environment variables
3. Ensure database is properly initialized
4. Check file permissions
```bash
# Run tests in Docker locally
make test-python

# Check environment in container
docker exec -it python-backend-container env | grep DATABASE_URL
```

### Database Test Isolation

**Issue**: Tests interfere with each other

**Solution**: Use transaction rollback in fixtures:
```python
@pytest.fixture
def db_session(test_db_engine):
    """Session that rolls back after test."""
    connection = test_db_engine.connect()
    transaction = connection.begin()
    session = SessionLocal(bind=connection)

    yield session

    session.close()
    transaction.rollback()  # Undo all changes
    connection.close()
```

### Async Test Issues

**Issue**: `RuntimeWarning: coroutine was never awaited`

**Solution**:
```python
# ✓ Correct - use @pytest.mark.asyncio
@pytest.mark.asyncio
async def test_async_function():
    result = await async_operation()
    assert result

# ✗ Incorrect - missing decorator
async def test_async_function():  # Warning!
    result = await async_operation()
```

### Fixture Scope Issues

**Issue**: Fixtures created too often or shared incorrectly

**Solution**: Choose appropriate scope:
```python
@pytest.fixture(scope="session")  # Created once for all tests
def app():
    return create_app()

@pytest.fixture(scope="function")  # Created for each test (default)
def db_session():
    return create_session()
```

## Example: Complete Test Suite

```python
"""Complete test suite example."""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from backend.models.user import User
from backend.crud.user import create_user, get_user
from backend.schemas.user import UserCreate


class TestUserEndToEnd:
    """End-to-end tests for user management."""

    @pytest.fixture
    def test_user_data(self):
        """Provide test user data."""
        return {
            "email": "test@example.com",
            "username": "testuser",
            "password": "SecurePass123!",
            "full_name": "Test User"
        }

    def test_user_lifecycle(
        self,
        client: TestClient,
        db_session: Session,
        test_user_data: dict
    ) -> None:
        """Test complete user lifecycle: create, read, update, delete."""
        # Create user
        create_response = client.post("/api/users", json=test_user_data)
        assert create_response.status_code == 201
        user_id = create_response.json()["id"]

        # Read user
        get_response = client.get(f"/api/users/{user_id}")
        assert get_response.status_code == 200
        assert get_response.json()["email"] == test_user_data["email"]

        # Update user
        update_data = {"full_name": "Updated Name"}
        update_response = client.patch(f"/api/users/{user_id}", json=update_data)
        assert update_response.status_code == 200
        assert update_response.json()["full_name"] == "Updated Name"

        # Delete user
        delete_response = client.delete(f"/api/users/{user_id}")
        assert delete_response.status_code == 204

        # Verify deletion
        get_after_delete = client.get(f"/api/users/{user_id}")
        assert get_after_delete.status_code == 404
```

## Checklist

- [ ] Test dependencies added to pyproject.toml
- [ ] pytest.ini_options configured
- [ ] Test directory structure created
- [ ] conftest.py files created with fixtures
- [ ] Tests follow AAA pattern
- [ ] Descriptive test names used
- [ ] Appropriate use of fixtures
- [ ] Parametrization for multiple scenarios
- [ ] Async tests properly marked
- [ ] Mocking used for external dependencies
- [ ] Tests run in Docker: `make test-python`
- [ ] Coverage meets threshold (e.g., 80%)
- [ ] All tests pass

## Related Documentation

- [How to Create an API Endpoint](how-to-create-an-api-endpoint.md) - Test your endpoints
- [How to Add Database Model](how-to-add-database-model.md) - Test database operations
- [pytest Documentation](https://docs.pytest.org/)
- [pytest-asyncio Documentation](https://pytest-asyncio.readthedocs.io/)

## Related Templates

- `plugins/languages/python/templates/pytest-test.py.template`
- `plugins/languages/python/templates/pytest-conftest.py.template`
- `plugins/languages/python/templates/pytest-api-test.py.template`

---

**Difficulty**: Intermediate
**Estimated Time**: 45-60 minutes
**Last Updated**: 2025-10-01
