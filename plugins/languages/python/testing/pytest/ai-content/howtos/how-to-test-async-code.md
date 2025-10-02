# How to Test Async Code

**Purpose**: Step-by-step guide for testing async/await code with pytest-asyncio

**Scope**: Async test functions, async fixtures, testing asyncio patterns, concurrent operations, timeout handling

**Overview**: Comprehensive guide for testing Python async/await code using pytest-asyncio. Covers async test
    functions, async fixtures, testing concurrent operations, handling timeouts, mocking async calls, and common
    asyncio patterns like tasks, gather, and event loops.

**Dependencies**: pytest, pytest-asyncio, asyncio

**Exports**: Async testing patterns, fixture examples, concurrency testing techniques

**Related**: AsyncIO programming, FastAPI testing, async database testing

**Implementation**: pytest-asyncio markers, async fixtures, event loop management

---

## Prerequisites

- pytest and pytest-asyncio installed
- Understanding of async/await syntax
- Familiarity with asyncio concepts
- Python 3.11+ recommended

## Setup pytest-asyncio

### Installation
```bash
poetry add --group dev pytest-asyncio
```

### Configuration in pyproject.toml
```toml
[tool.pytest.ini_options]
asyncio_mode = "auto"  # Automatically detect async tests
```

**Modes**:
- `"auto"`: Automatically treat `async def test_*` as async tests (recommended)
- `"strict"`: Require `@pytest.mark.asyncio` decorator explicitly

## Basic Async Test

### Simple Async Function Test

```python
import pytest
import asyncio

# Code being tested (in app/services.py)
async def fetch_data() -> dict:
    await asyncio.sleep(0.1)  # Simulate async operation
    return {"status": "success", "data": [1, 2, 3]}

# Test with auto mode
async def test_fetch_data():
    # Arrange & Act
    result = await fetch_data()

    # Assert
    assert result["status"] == "success"
    assert len(result["data"]) == 3

# Or with explicit decorator (strict mode)
@pytest.mark.asyncio
async def test_fetch_data_explicit():
    result = await fetch_data()
    assert result["status"] == "success"
```

## Async Fixtures

### Basic Async Fixture

```python
import pytest
import httpx

@pytest.fixture
async def async_client():
    """Async fixture for HTTP client."""
    async with httpx.AsyncClient() as client:
        yield client
    # Cleanup happens automatically when exiting async context

async def test_api_call(async_client):
    response = await async_client.get("https://api.example.com/health")
    assert response.status_code == 200
```

### Async Database Fixture

```python
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker

@pytest.fixture
async def async_db_session():
    """Async database session fixture."""
    engine = create_async_engine("sqlite+aiosqlite:///:memory:")

    # Create tables
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    # Create session
    async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

    async with async_session() as session:
        yield session

    # Cleanup
    await engine.dispose()

async def test_create_user(async_db_session):
    user = User(email="test@example.com", name="Test User")
    async_db_session.add(user)
    await async_db_session.commit()

    result = await async_db_session.get(User, user.id)
    assert result.email == "test@example.com"
```

### Fixture Scopes with Async

```python
@pytest.fixture(scope="function")  # Default: new for each test
async def function_scoped_fixture():
    yield "function"

@pytest.fixture(scope="module")  # Shared across module
async def module_scoped_fixture():
    yield "module"

@pytest.fixture(scope="session")  # Shared across entire test session
async def session_scoped_fixture():
    yield "session"
```

## Testing Concurrent Operations

### Testing asyncio.gather()

```python
import asyncio

# Code being tested
async def fetch_multiple_users(user_ids: list[int]) -> list[dict]:
    async def fetch_one(user_id: int) -> dict:
        await asyncio.sleep(0.1)
        return {"id": user_id, "name": f"User {user_id}"}

    return await asyncio.gather(*[fetch_one(uid) for uid in user_ids])

# Test concurrent fetching
async def test_fetch_multiple_users():
    # Arrange
    user_ids = [1, 2, 3, 4, 5]

    # Act
    results = await fetch_multiple_users(user_ids)

    # Assert
    assert len(results) == 5
    assert all(isinstance(user, dict) for user in results)
    assert [user["id"] for user in results] == user_ids
```

### Testing asyncio.create_task()

```python
import asyncio

# Code being tested
async def background_processor():
    tasks = []
    for i in range(3):
        task = asyncio.create_task(process_item(i))
        tasks.append(task)

    results = await asyncio.gather(*tasks)
    return results

async def process_item(item_id: int) -> str:
    await asyncio.sleep(0.05)
    return f"Processed {item_id}"

# Test task creation and gathering
async def test_background_processor():
    results = await background_processor()

    assert len(results) == 3
    assert all("Processed" in result for result in results)
```

## Testing Timeouts

### asyncio.wait_for()

```python
import asyncio

# Code being tested
async def fetch_with_timeout(url: str, timeout: float = 1.0) -> dict:
    async def slow_fetch():
        await asyncio.sleep(0.5)
        return {"url": url, "data": "result"}

    try:
        return await asyncio.wait_for(slow_fetch(), timeout=timeout)
    except asyncio.TimeoutError:
        return {"error": "Request timed out"}

# Test successful completion within timeout
async def test_fetch_with_timeout_success():
    result = await fetch_with_timeout("https://api.example.com", timeout=1.0)

    assert "data" in result
    assert result["data"] == "result"

# Test timeout exceeded
async def test_fetch_with_timeout_expires():
    result = await fetch_with_timeout("https://slow-api.example.com", timeout=0.1)

    assert "error" in result
    assert result["error"] == "Request timed out"
```

### pytest timeout plugin

```python
import pytest
import asyncio

@pytest.mark.timeout(2)  # Fail if test takes > 2 seconds
async def test_should_complete_quickly():
    await asyncio.sleep(0.5)
    assert True

@pytest.mark.timeout(0.5)
async def test_timeout_violation():
    await asyncio.sleep(1.0)  # This will fail due to timeout
    assert True  # Never reached
```

## Mocking Async Functions

### Mocking Async API Calls

```python
import httpx
import pytest

# Code being tested
async def get_user_data(user_id: int) -> dict:
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.example.com/users/{user_id}")
        return response.json()

# Test with mocked async call
async def test_get_user_data(mocker):
    # Arrange
    mock_response = mocker.Mock()
    mock_response.json.return_value = {"id": 1, "name": "Alice"}

    # Mock the async context manager and get method
    mock_client = mocker.MagicMock()
    mock_client.__aenter__.return_value.get = mocker.AsyncMock(return_value=mock_response)

    mocker.patch("httpx.AsyncClient", return_value=mock_client)

    # Act
    result = await get_user_data(user_id=1)

    # Assert
    assert result == {"id": 1, "name": "Alice"}
```

### Using mocker.AsyncMock

```python
import pytest

async def async_function():
    return "async result"

async def test_async_mock(mocker):
    # Create async mock
    mock_async = mocker.AsyncMock(return_value="mocked result")

    # Replace real function
    mocker.patch("app.services.async_function", mock_async)

    # Call and verify
    result = await async_function()
    assert result == "mocked result"
    mock_async.assert_awaited_once()
```

## Testing Error Handling in Async Code

### Testing Async Exceptions

```python
import asyncio

# Code being tested
async def risky_operation():
    await asyncio.sleep(0.1)
    raise ValueError("Something went wrong")

# Test exception is raised
async def test_risky_operation_raises():
    with pytest.raises(ValueError, match="Something went wrong"):
        await risky_operation()
```

### Testing Async Retry Logic

```python
import asyncio

# Code being tested
async def retry_async_operation(operation, max_retries=3):
    for attempt in range(max_retries):
        try:
            return await operation()
        except Exception as e:
            if attempt == max_retries - 1:
                raise
            await asyncio.sleep(0.1 * (attempt + 1))  # Backoff

# Test with async mock
async def test_retry_succeeds_on_second_attempt(mocker):
    # Arrange
    mock_operation = mocker.AsyncMock()
    mock_operation.side_effect = [
        Exception("First fails"),
        "Success on second"
    ]

    # Act
    result = await retry_async_operation(mock_operation, max_retries=3)

    # Assert
    assert result == "Success on second"
    assert mock_operation.await_count == 2
```

## Testing Event Loops

### Manual Event Loop Management (Advanced)

```python
import asyncio
import pytest

@pytest.fixture(scope="session")
def event_loop():
    """Create event loop for entire test session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

async def test_with_custom_loop(event_loop):
    # Use custom event loop
    result = await asyncio.sleep(0, result="test")
    assert result == "test"
```

## Common Async Patterns to Test

### Testing Background Tasks

```python
import asyncio
from asyncio import Queue

# Code being tested
async def producer_consumer_pattern():
    queue = Queue(maxsize=10)

    async def producer():
        for i in range(5):
            await queue.put(i)
            await asyncio.sleep(0.01)
        await queue.put(None)  # Sentinel

    async def consumer():
        results = []
        while True:
            item = await queue.get()
            if item is None:
                break
            results.append(item * 2)
        return results

    producer_task = asyncio.create_task(producer())
    consumer_task = asyncio.create_task(consumer())

    await producer_task
    results = await consumer_task
    return results

# Test producer-consumer
async def test_producer_consumer():
    results = await producer_consumer_pattern()

    assert results == [0, 2, 4, 6, 8]
```

### Testing Async Context Managers

```python
# Code being tested
class AsyncResource:
    async def __aenter__(self):
        await asyncio.sleep(0.01)
        self.connected = True
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        await asyncio.sleep(0.01)
        self.connected = False

    async def fetch_data(self) -> str:
        if not self.connected:
            raise RuntimeError("Not connected")
        return "data"

# Test async context manager
async def test_async_resource():
    async with AsyncResource() as resource:
        assert resource.connected is True
        data = await resource.fetch_data()
        assert data == "data"

    # After exiting context
    assert resource.connected is False
```

## Parametrizing Async Tests

```python
import pytest

@pytest.mark.parametrize("input_val,expected", [
    (1, 2),
    (2, 4),
    (3, 6),
])
async def test_async_double(input_val, expected):
    async def double(x):
        await asyncio.sleep(0.01)
        return x * 2

    result = await double(input_val)
    assert result == expected
```

## Best Practices

### 1. Use `asyncio_mode = "auto"`
```toml
[tool.pytest.ini_options]
asyncio_mode = "auto"
```

### 2. Avoid Mixing Sync and Async
```python
# ❌ Don't mix
def test_something():
    result = await async_function()  # SyntaxError!

# ✅ Make test async
async def test_something():
    result = await async_function()
```

### 3. Use Async Fixtures for Async Setup
```python
# ✅ Async fixture for async resource
@pytest.fixture
async def async_client():
    async with httpx.AsyncClient() as client:
        yield client
```

### 4. Mock Async Calls with AsyncMock
```python
# ✅ Use AsyncMock for async functions
mock_async = mocker.AsyncMock(return_value="result")
```

### 5. Test Timeouts Explicitly
```python
# ✅ Test both success and timeout scenarios
async def test_operation_completes_in_time():
    ...

async def test_operation_times_out():
    ...
```

## Troubleshooting

### "RuntimeError: Event loop is closed"
- Use `asyncio_mode = "auto"` in pytest config
- Don't manually close event loops in tests

### "coroutine was never awaited"
- Add `await` before async function calls
- Ensure test function is `async def`

### Fixture Scope Issues
- Use correct scope for async fixtures
- Session-scoped async fixtures may cause issues

### Timeout Not Working
- Install `pytest-timeout` plugin
- Add `@pytest.mark.timeout(seconds)` decorator

## Template Reference

See `templates/test-async-function.py.template` for complete async testing examples.

---

**Key Takeaway**: Use pytest-asyncio with `asyncio_mode = "auto"`, async fixtures for async resources, and AsyncMock for mocking async calls.
