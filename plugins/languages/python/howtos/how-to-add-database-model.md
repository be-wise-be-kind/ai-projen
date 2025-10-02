# How to Add a Database Model

**Purpose**: Step-by-step guide for creating database models using SQLAlchemy with Alembic migrations and Pydantic schemas in a Docker-first environment

**Scope**: SQLAlchemy ORM models, Pydantic schemas, Alembic migrations, CRUD operations, Docker-based database development

**Overview**: Comprehensive guide for implementing database persistence with SQLAlchemy ORM, automatic schema generation, type-safe Pydantic models for API serialization, and Alembic migration management. Covers complete workflow from model definition through migration generation and execution in Docker containers, ensuring data integrity and type safety.

**Dependencies**: SQLAlchemy, Alembic, Pydantic, PostgreSQL/MySQL, Docker, database design knowledge

**Exports**: Database model creation workflow, migration patterns, CRUD operations, schema validation

**Related**: Database design, API development, data validation, Docker Compose services

**Implementation**: SQLAlchemy declarative models, Alembic migration scripts, Pydantic validation, Docker database services

---

This guide provides step-by-step instructions for adding database models with SQLAlchemy, creating Pydantic schemas, and managing migrations with Alembic in a Docker-first environment.

## Prerequisites

- Python plugin installed in your project
- Docker and Docker Compose installed
- Database service configured (PostgreSQL, MySQL, etc.)
- Understanding of SQL and database concepts
- Basic knowledge of ORMs

## Docker-First Development Pattern

All database operations should be performed in Docker containers to ensure consistent behavior.

**Environment Priority**:
1. Docker containers with database service (recommended)
2. Poetry with local database (fallback)
3. Direct local execution (last resort)

## Steps to Add a Database Model

### 1. Setup Database Dependencies

**Add to `pyproject.toml`**:
```toml
[tool.poetry.dependencies]
sqlalchemy = "^2.0.0"
alembic = "^1.12.0"
psycopg2-binary = "^2.9.0"  # For PostgreSQL
# OR
pymysql = "^1.1.0"  # For MySQL
pydantic = "^2.0.0"
asyncpg = "^0.29.0"  # For async PostgreSQL

[tool.poetry.group.dev.dependencies]
sqlalchemy-utils = "^0.41.0"  # Utilities for testing
```

**Rebuild Docker**:
```bash
make python-install  # Rebuilds with new dependencies
```

### 2. Configure Database Connection

**Create database configuration** (`backend/core/database.py`):
```python
"""Database configuration and session management."""

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from typing import Generator
import os

# Database URL from environment
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://user:password@db:5432/myapp"
)

# Create engine
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # Verify connections before using
    pool_size=10,
    max_overflow=20,
)

# Create session factory
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# Base class for models
Base = declarative_base()


def get_db() -> Generator:
    """Get database session.

    Yields:
        Database session

    Example:
        ```python
        from fastapi import Depends
        @app.get("/users")
        def get_users(db: Session = Depends(get_db)):
            return db.query(User).all()
        ```
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

**Configure in docker-compose.yml**:
```yaml
services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build: .
    environment:
      DATABASE_URL: postgresql://user:password@db:5432/myapp
    depends_on:
      db:
        condition: service_healthy
    volumes:
      - .:/app

volumes:
  postgres_data:
```

### 3. Initialize Alembic

**In Docker container**:
```bash
# Start database service
make dev-python

# Initialize Alembic
docker exec -it python-backend-container alembic init alembic
```

**Configure Alembic** (`alembic/env.py`):
```python
"""Alembic environment configuration."""

from logging.config import fileConfig
from sqlalchemy import engine_from_config, pool
from alembic import context
import os
import sys

# Add your app to the path
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

# Import your models
from backend.core.database import Base
from backend.models import user, post, comment  # Import all model modules

# Alembic Config object
config = context.config

# Set database URL from environment
config.set_main_option(
    "sqlalchemy.url",
    os.getenv("DATABASE_URL", "postgresql://user:password@db:5432/myapp")
)

# Configure logging
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# Set target metadata
target_metadata = Base.metadata


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    connectable = engine_from_config(
        config.get_section(config.config_ini_section),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
```

### 4. Create SQLAlchemy Model

**Using the template**:
```bash
cp plugins/languages/python/templates/sqlalchemy-model.py.template backend/models/user.py
```

**Manual creation** (`backend/models/user.py`):
```python
"""User database model."""

from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from datetime import datetime
from backend.core.database import Base


class User(Base):
    """User model for authentication and profile management.

    Attributes:
        id: Primary key
        email: Unique user email
        username: Unique username
        hashed_password: Bcrypt hashed password
        full_name: User's full name
        is_active: Whether account is active
        is_superuser: Whether user has admin privileges
        created_at: Timestamp of account creation
        updated_at: Timestamp of last update
        posts: Relationship to user's posts
    """

    __tablename__ = "users"

    # Primary key
    id = Column(Integer, primary_key=True, index=True)

    # Unique fields
    email = Column(String(255), unique=True, index=True, nullable=False)
    username = Column(String(50), unique=True, index=True, nullable=False)

    # Authentication
    hashed_password = Column(String(255), nullable=False)

    # Profile information
    full_name = Column(String(255), nullable=True)
    bio = Column(Text, nullable=True)

    # Status flags
    is_active = Column(Boolean, default=True, nullable=False)
    is_superuser = Column(Boolean, default=False, nullable=False)

    # Timestamps (automatic)
    created_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )
    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False
    )

    # Relationships
    posts = relationship("Post", back_populates="author", cascade="all, delete-orphan")

    def __repr__(self) -> str:
        """String representation."""
        return f"<User(id={self.id}, username='{self.username}', email='{self.email}')>"
```

**Complex model with relationships** (`backend/models/post.py`):
```python
"""Post database model."""

from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from backend.core.database import Base


class Post(Base):
    """Blog post model.

    Attributes:
        id: Primary key
        title: Post title
        content: Post content (markdown)
        published: Whether post is published
        author_id: Foreign key to User
        author: Relationship to User model
        tags: Relationship to tags
        created_at: Creation timestamp
        updated_at: Last update timestamp
    """

    __tablename__ = "posts"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False, index=True)
    slug = Column(String(255), unique=True, index=True, nullable=False)
    content = Column(Text, nullable=False)
    published = Column(Boolean, default=False, nullable=False)

    # Foreign key
    author_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    author = relationship("User", back_populates="posts")
    comments = relationship("Comment", back_populates="post", cascade="all, delete-orphan")

    def __repr__(self) -> str:
        """String representation."""
        return f"<Post(id={self.id}, title='{self.title}', author_id={self.author_id})>"
```

### 5. Create Pydantic Schemas

**Using the template**:
```bash
cp plugins/languages/python/templates/pydantic-schema.py.template backend/schemas/user.py
```

**Manual creation** (`backend/schemas/user.py`):
```python
"""User Pydantic schemas for API validation and serialization."""

from pydantic import BaseModel, EmailStr, ConfigDict
from datetime import datetime
from typing import Optional


class UserBase(BaseModel):
    """Base user schema with common fields."""

    email: EmailStr
    username: str
    full_name: Optional[str] = None
    bio: Optional[str] = None


class UserCreate(UserBase):
    """Schema for creating a new user.

    Includes password field for registration.
    """

    password: str

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "email": "user@example.com",
                "username": "johndoe",
                "full_name": "John Doe",
                "password": "securepassword123"
            }
        }
    )


class UserUpdate(BaseModel):
    """Schema for updating user information.

    All fields are optional for partial updates.
    """

    email: Optional[EmailStr] = None
    username: Optional[str] = None
    full_name: Optional[str] = None
    bio: Optional[str] = None
    is_active: Optional[bool] = None


class UserResponse(UserBase):
    """Schema for user responses from API.

    Excludes sensitive information like password.
    """

    id: int
    is_active: bool
    is_superuser: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class UserWithPosts(UserResponse):
    """User response with related posts."""

    posts: list["PostResponse"] = []

    model_config = ConfigDict(from_attributes=True)


# Import to resolve forward references
from backend.schemas.post import PostResponse
UserWithPosts.model_rebuild()
```

### 6. Generate Migration

**In Docker container**:
```bash
# Create migration with descriptive name
docker exec -it python-backend-container \
  alembic revision --autogenerate -m "Create users table"

# Review the generated migration file in alembic/versions/
```

**Review and edit migration** (`alembic/versions/xxx_create_users_table.py`):
```python
"""Create users table

Revision ID: abc123def456
Revises:
Create Date: 2025-10-01 10:00:00.000000
"""

from alembic import op
import sqlalchemy as sa


# revision identifiers
revision = 'abc123def456'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    """Create users table."""
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('email', sa.String(length=255), nullable=False),
        sa.Column('username', sa.String(length=50), nullable=False),
        sa.Column('hashed_password', sa.String(length=255), nullable=False),
        sa.Column('full_name', sa.String(length=255), nullable=True),
        sa.Column('bio', sa.Text(), nullable=True),
        sa.Column('is_active', sa.Boolean(), nullable=False, server_default='true'),
        sa.Column('is_superuser', sa.Boolean(), nullable=False, server_default='false'),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_users_email'), 'users', ['email'], unique=True)
    op.create_index(op.f('ix_users_id'), 'users', ['id'], unique=False)
    op.create_index(op.f('ix_users_username'), 'users', ['username'], unique=True)


def downgrade() -> None:
    """Drop users table."""
    op.drop_index(op.f('ix_users_username'), table_name='users')
    op.drop_index(op.f('ix_users_id'), table_name='users')
    op.drop_index(op.f('ix_users_email'), table_name='users')
    op.drop_table('users')
```

### 7. Apply Migration

**In Docker**:
```bash
# Apply all pending migrations
docker exec -it python-backend-container alembic upgrade head

# Check migration status
docker exec -it python-backend-container alembic current

# View migration history
docker exec -it python-backend-container alembic history
```

**Verify in database**:
```bash
# Connect to database
docker exec -it postgres-container psql -U user -d myapp

# Check table
myapp=# \dt
myapp=# \d users
myapp=# SELECT * FROM alembic_version;
```

### 8. Create CRUD Operations

**Create CRUD module** (`backend/crud/user.py`):
```python
"""CRUD operations for User model."""

from sqlalchemy.orm import Session
from sqlalchemy import select
from typing import Optional
from backend.models.user import User
from backend.schemas.user import UserCreate, UserUpdate
from backend.core.security import get_password_hash


def get_user(db: Session, user_id: int) -> Optional[User]:
    """Get user by ID.

    Args:
        db: Database session
        user_id: User ID

    Returns:
        User object or None if not found
    """
    return db.query(User).filter(User.id == user_id).first()


def get_user_by_email(db: Session, email: str) -> Optional[User]:
    """Get user by email.

    Args:
        db: Database session
        email: User email

    Returns:
        User object or None if not found
    """
    return db.query(User).filter(User.email == email).first()


def get_users(
    db: Session,
    skip: int = 0,
    limit: int = 100
) -> list[User]:
    """Get list of users with pagination.

    Args:
        db: Database session
        skip: Number of records to skip
        limit: Maximum number of records to return

    Returns:
        List of User objects
    """
    return db.query(User).offset(skip).limit(limit).all()


def create_user(db: Session, user: UserCreate) -> User:
    """Create new user.

    Args:
        db: Database session
        user: User creation schema

    Returns:
        Created User object
    """
    hashed_password = get_password_hash(user.password)
    db_user = User(
        email=user.email,
        username=user.username,
        hashed_password=hashed_password,
        full_name=user.full_name,
        bio=user.bio,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def update_user(
    db: Session,
    user_id: int,
    user_update: UserUpdate
) -> Optional[User]:
    """Update user.

    Args:
        db: Database session
        user_id: User ID
        user_update: User update schema

    Returns:
        Updated User object or None if not found
    """
    db_user = get_user(db, user_id)
    if not db_user:
        return None

    # Update only provided fields
    update_data = user_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_user, field, value)

    db.commit()
    db.refresh(db_user)
    return db_user


def delete_user(db: Session, user_id: int) -> bool:
    """Delete user.

    Args:
        db: Database session
        user_id: User ID

    Returns:
        True if deleted, False if not found
    """
    db_user = get_user(db, user_id)
    if not db_user:
        return False

    db.delete(db_user)
    db.commit()
    return True
```

### 9. Integrate with FastAPI

**Create API endpoints** (`backend/api/users.py`):
```python
"""User API endpoints."""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.core.database import get_db
from backend.schemas.user import UserCreate, UserResponse, UserUpdate
from backend.crud import user as user_crud

router = APIRouter(prefix="/api/users", tags=["users"])


@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def create_user(
    user: UserCreate,
    db: Session = Depends(get_db)
) -> UserResponse:
    """Create a new user.

    Args:
        user: User creation data
        db: Database session

    Returns:
        Created user

    Raises:
        HTTPException: 400 if email already registered
    """
    # Check if email exists
    db_user = user_crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    return user_crud.create_user(db=db, user=user)


@router.get("/{user_id}", response_model=UserResponse)
def read_user(
    user_id: int,
    db: Session = Depends(get_db)
) -> UserResponse:
    """Get user by ID.

    Args:
        user_id: User ID
        db: Database session

    Returns:
        User details

    Raises:
        HTTPException: 404 if user not found
    """
    db_user = user_crud.get_user(db, user_id=user_id)
    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    return db_user


@router.get("/", response_model=list[UserResponse])
def read_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
) -> list[UserResponse]:
    """List users with pagination.

    Args:
        skip: Number of records to skip
        limit: Maximum number of records
        db: Database session

    Returns:
        List of users
    """
    return user_crud.get_users(db, skip=skip, limit=limit)
```

## Templates Reference

This guide references the following templates:

- `plugins/languages/python/templates/sqlalchemy-model.py.template` - SQLAlchemy model
- `plugins/languages/python/templates/pydantic-schema.py.template` - Pydantic schemas
- `plugins/languages/python/templates/crud-operations.py.template` - CRUD operations

## Verification Steps

### 1. Check Database Schema

```bash
# Connect to database in Docker
docker exec -it postgres-container psql -U user -d myapp

# List tables
\dt

# Describe table
\d users

# Check constraints and indexes
\di

# View data
SELECT * FROM users LIMIT 10;
```

### 2. Test Migrations

```bash
# Check current version
docker exec -it python-backend-container alembic current

# Test downgrade
docker exec -it python-backend-container alembic downgrade -1

# Verify table dropped
docker exec -it postgres-container psql -U user -d myapp -c "\dt"

# Upgrade again
docker exec -it python-backend-container alembic upgrade head
```

### 3. Test CRUD Operations

```bash
# Start API
make dev-python

# Create user
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "securepass123",
    "full_name": "Test User"
  }'

# Get user
curl http://localhost:8000/api/users/1

# List users
curl http://localhost:8000/api/users

# Update user
curl -X PATCH http://localhost:8000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"full_name": "Updated Name"}'

# Delete user
curl -X DELETE http://localhost:8000/api/users/1
```

### 4. Run Tests

```bash
make test-python
```

## Best Practices

### 1. Always Use Migrations

Never create tables manually. Always use Alembic:

```bash
# ✓ Correct
docker exec -it python-backend-container alembic revision --autogenerate -m "Add column"
docker exec -it python-backend-container alembic upgrade head

# ✗ Incorrect
docker exec -it postgres-container psql -U user -d myapp -c "ALTER TABLE users ADD COLUMN..."
```

### 2. Index Frequently Queried Fields

```python
class User(Base):
    email = Column(String(255), unique=True, index=True)  # ✓ Indexed
    username = Column(String(50), unique=True, index=True)  # ✓ Indexed
    bio = Column(Text)  # Not indexed (rarely queried)
```

### 3. Use Constraints

```python
from sqlalchemy import CheckConstraint

class Product(Base):
    __tablename__ = "products"

    price = Column(Numeric(10, 2), nullable=False)
    stock = Column(Integer, nullable=False)

    __table_args__ = (
        CheckConstraint('price >= 0', name='check_price_positive'),
        CheckConstraint('stock >= 0', name='check_stock_positive'),
    )
```

### 4. Relationship Loading Strategies

```python
from sqlalchemy.orm import relationship, joinedload

class User(Base):
    # Lazy loading (default)
    posts = relationship("Post", back_populates="author", lazy="select")

    # Eager loading
    # posts = relationship("Post", back_populates="author", lazy="joined")

# Query with explicit loading
users = db.query(User).options(joinedload(User.posts)).all()
```

### 5. Use Pydantic Config

```python
class UserResponse(BaseModel):
    """User response with ORM mode."""

    id: int
    email: str
    created_at: datetime

    # Enable ORM mode for SQLAlchemy models
    model_config = ConfigDict(from_attributes=True)
```

## Common Issues and Solutions

### Migration Conflicts

**Issue**: Multiple developers create migrations simultaneously

**Solution**:
```bash
# Check for multiple heads
docker exec -it python-backend-container alembic heads

# Merge migrations
docker exec -it python-backend-container alembic merge -m "Merge migrations" head1 head2

# Apply merged migration
docker exec -it python-backend-container alembic upgrade head
```

### Relationship Errors

**Issue**: `DetachedInstanceError` when accessing relationships

**Solution**:
```python
# ✓ Correct - access within session
def get_user_with_posts(db: Session, user_id: int):
    user = db.query(User).filter(User.id == user_id).first()
    # Access relationship while session is active
    posts = user.posts
    return user

# ✗ Incorrect - accessing after session closed
def get_user(db: Session, user_id: int):
    user = db.query(User).filter(User.id == user_id).first()
    return user
# Outside function, session is closed
user = get_user(db, 1)
posts = user.posts  # Error!
```

### Connection Pool Exhaustion

**Issue**: "QueuePool limit exceeded"

**Solution**:
```python
# Increase pool size
engine = create_engine(
    DATABASE_URL,
    pool_size=20,  # Increase from default 5
    max_overflow=40,  # Increase from default 10
    pool_pre_ping=True,
)
```

### Type Validation Errors

**Issue**: Pydantic validation fails for datetime fields

**Solution**:
```python
# Use proper datetime handling
from datetime import datetime
from pydantic import Field

class UserResponse(BaseModel):
    created_at: datetime = Field(..., description="Creation timestamp")

    model_config = ConfigDict(
        from_attributes=True,
        json_encoders={
            datetime: lambda v: v.isoformat()
        }
    )
```

## Checklist

- [ ] Database dependencies added to pyproject.toml
- [ ] Docker Compose configured with database service
- [ ] Database configuration created
- [ ] Alembic initialized and configured
- [ ] SQLAlchemy model created with proper types
- [ ] Indexes added to frequently queried fields
- [ ] Pydantic schemas created for API
- [ ] Migration generated and reviewed
- [ ] Migration applied: `alembic upgrade head`
- [ ] Database schema verified
- [ ] CRUD operations implemented
- [ ] API endpoints created
- [ ] Tests written
- [ ] All tests pass: `make test-python`

## Related Documentation

- [How to Create an API Endpoint](how-to-create-an-api-endpoint.md) - Use models in APIs
- [How to Write a Test](how-to-write-a-test.md) - Test database operations
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Alembic Documentation](https://alembic.sqlalchemy.org/)
- [Pydantic Documentation](https://docs.pydantic.dev/)

## Related Templates

- `plugins/languages/python/templates/sqlalchemy-model.py.template`
- `plugins/languages/python/templates/pydantic-schema.py.template`
- `plugins/languages/python/templates/crud-operations.py.template`

---

**Difficulty**: Advanced
**Estimated Time**: 60-90 minutes
**Last Updated**: 2025-10-01
