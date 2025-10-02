# How to Test Database Operations

**Purpose**: Testing SQLAlchemy models, queries, and transactions with pytest

**Scope**: Database fixtures, transactions, async databases, test isolation

**Dependencies**: pytest, SQLAlchemy, pytest-asyncio (for async)

---

## In-Memory SQLite Test Database

```python
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.database import Base

@pytest.fixture(scope="function")
def db_session():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)

    Session = sessionmaker(bind=engine)
    session = Session()

    yield session

    session.close()
    Base.metadata.drop_all(engine)
```

## Testing CRUD Operations

```python
from app.models import User

def test_create_user(db_session):
    user = User(email="test@example.com", name="Test")
    db_session.add(user)
    db_session.commit()

    assert user.id is not None
    assert db_session.query(User).count() == 1

def test_read_user(db_session):
    user = User(email="test@example.com", name="Test")
    db_session.add(user)
    db_session.commit()

    found = db_session.query(User).filter_by(email="test@example.com").first()
    assert found.name == "Test"

def test_update_user(db_session):
    user = User(email="test@example.com", name="Old Name")
    db_session.add(user)
    db_session.commit()

    user.name = "New Name"
    db_session.commit()

    updated = db_session.query(User).get(user.id)
    assert updated.name == "New Name"

def test_delete_user(db_session):
    user = User(email="test@example.com", name="Test")
    db_session.add(user)
    db_session.commit()

    db_session.delete(user)
    db_session.commit()

    assert db_session.query(User).count() == 0
```

## Async Database Testing

```python
import pytest
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker

@pytest.fixture
async def async_db_session():
    engine = create_async_engine("sqlite+aiosqlite:///:memory:")

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

    async with async_session() as session:
        yield session

    await engine.dispose()

@pytest.mark.asyncio
async def test_async_create_user(async_db_session):
    user = User(email="async@example.com", name="Async User")
    async_db_session.add(user)
    await async_db_session.commit()

    assert user.id is not None
```

## Testing Transactions and Rollback

```python
def test_transaction_rollback(db_session):
    user1 = User(email="user1@example.com", name="User 1")
    db_session.add(user1)

    try:
        user2 = User(email="user1@example.com", name="Duplicate")  # Violates unique constraint
        db_session.add(user2)
        db_session.commit()
    except Exception:
        db_session.rollback()

    assert db_session.query(User).count() == 1  # Only user1 exists
```

## Mocking Database for Unit Tests

```python
def test_service_with_mocked_db(mocker):
    mock_session = mocker.Mock()
    mock_user = User(id=1, email="test@example.com", name="Test")

    mock_session.query.return_value.filter_by.return_value.first.return_value = mock_user

    result = get_user_by_email(mock_session, "test@example.com")
    assert result.id == 1
```

See `templates/test-database-model.py.template` and `conftest.py.template` for complete examples.
