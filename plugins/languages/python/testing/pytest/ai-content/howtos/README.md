# pytest How-To Guides

Comprehensive testing guides for Python projects using pytest.

## Available Guides

### 1. [How to Write a Test](./how-to-write-a-test.md)
**Purpose**: Foundational guide for creating tests with pytest

**Covers**:
- Test structure and organization
- AAA pattern (Arrange-Act-Assert)
- Basic assertions
- Docker-first testing
- Coverage reporting

**When to use**: Starting a new test or learning pytest basics

---

### 2. [How to Mock Dependencies](./how-to-mock-dependencies.md)
**Purpose**: Isolate tests from external dependencies

**Covers**:
- pytest-mock and unittest.mock
- Mocking HTTP requests (httpx, requests)
- Mocking database calls
- Mocking time/datetime
- Mocking file system operations
- Mock assertions and verification

**When to use**: Testing code that calls external APIs, databases, or file systems

---

### 3. [How to Test Async Code](./how-to-test-async-code.md)
**Purpose**: Testing Python async/await patterns

**Covers**:
- pytest-asyncio setup
- Async test functions
- Async fixtures
- Testing concurrent operations (gather, tasks)
- Timeout handling
- Mocking async functions
- Event loop management

**When to use**: Testing FastAPI endpoints, async database calls, or any asyncio code

---

### 4. [How to Test FastAPI Endpoints](./how-to-test-fastapi-endpoints.md)
**Purpose**: Testing REST API endpoints with FastAPI TestClient

**Covers**:
- GET/POST/PUT/DELETE endpoint testing
- Request/response validation
- Authentication testing
- Dependency overrides
- Error response testing
- Async endpoint testing

**When to use**: Testing FastAPI or similar web framework endpoints

---

### 5. [How to Test Database Operations](./how-to-test-database-operations.md)
**Purpose**: Testing SQLAlchemy models and database interactions

**Covers**:
- In-memory SQLite test databases
- CRUD operation testing
- Async database testing
- Transaction and rollback testing
- Mocking database for unit tests

**When to use**: Testing code that interacts with databases

---

### 6. [How to Use pytest Fixtures](./how-to-use-pytest-fixtures.md)
**Purpose**: Master pytest fixtures for test setup and dependency injection

**Covers**:
- Fixture scopes (function, class, module, session)
- Setup and teardown patterns
- conftest.py for shared fixtures
- Fixture composition
- Parametrized fixtures
- Autouse fixtures

**When to use**: Setting up test data, resources, or repeated test configuration

---

### 7. [How to Parametrize Tests](./how-to-parametrize-tests.md)
**Purpose**: Run same test with multiple inputs

**Covers**:
- @pytest.mark.parametrize decorator
- Multiple parameter sets
- Custom test IDs
- pytest.param for advanced scenarios
- Indirect parametrization with fixtures
- Class parametrization

**When to use**: Testing same logic with different inputs/edge cases

---

## Templates

Located in `../templates/`:

1. **test-api-endpoint.py.template** - FastAPI endpoint testing patterns
2. **test-async-function.py.template** - Async/await testing patterns
3. **test-database-model.py.template** - Database model CRUD testing
4. **conftest.py.template** - Common fixtures and test configuration
5. **mock-external-service.py.template** - Mocking patterns for external services

## Quick Reference

### Common Testing Scenarios

| Scenario | Guide | Template |
|----------|-------|----------|
| Testing REST API endpoint | [FastAPI Endpoints](./how-to-test-fastapi-endpoints.md) | test-api-endpoint.py.template |
| Testing async function | [Async Code](./how-to-test-async-code.md) | test-async-function.py.template |
| Testing database model | [Database Operations](./how-to-test-database-operations.md) | test-database-model.py.template |
| Mocking HTTP API call | [Mock Dependencies](./how-to-mock-dependencies.md) | mock-external-service.py.template |
| Testing with fixtures | [pytest Fixtures](./how-to-use-pytest-fixtures.md) | conftest.py.template |
| Multiple test cases | [Parametrize Tests](./how-to-parametrize-tests.md) | - |

### Testing Best Practices

1. **Follow AAA Pattern**: Arrange → Act → Assert
2. **One assertion per test**: Keep tests focused
3. **Use fixtures for setup**: Avoid repetition
4. **Mock external boundaries**: APIs, databases, file systems
5. **Test async code with pytest-asyncio**: Use `asyncio_mode = "auto"`
6. **Use descriptive test names**: `test_user_creation_with_valid_email()`
7. **Parametrize for edge cases**: Test multiple scenarios efficiently

### Test Organization

```
tests/
├── conftest.py              # Shared fixtures
├── test_api/
│   ├── conftest.py          # API-specific fixtures
│   ├── test_user_endpoints.py
│   └── test_auth_endpoints.py
├── test_models/
│   ├── test_user_model.py
│   └── test_post_model.py
├── test_services/
│   ├── test_user_service.py
│   └── test_email_service.py
└── test_utils/
    └── test_validators.py
```

---

**For detailed pytest documentation**: https://docs.pytest.org/
