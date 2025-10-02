# How to Add an API Endpoint

**Purpose**: Step-by-step guide for creating new FastAPI REST endpoints with database integration, validation, and testing

**Scope**: Backend API development with FastAPI, SQLAlchemy, Pydantic, and pytest

**Overview**: Complete walkthrough for adding a new API endpoint to the FastAPI backend including router creation,
    Pydantic request/response models, SQLAlchemy database models, service layer business logic, comprehensive testing,
    and automatic OpenAPI documentation. Covers RESTful patterns, error handling, and integration with the existing
    application structure. Suitable for developers adding CRUD endpoints or custom business logic endpoints.

**Prerequisites**: Python basics, FastAPI fundamentals, SQLAlchemy ORM, pytest testing

**Estimated Time**: 30-45 minutes

---

## What You'll Build

By the end of this guide, you'll have:
- A new REST API endpoint (e.g., `/api/tasks`)
- Database model with SQLAlchemy
- Pydantic schemas for request/response validation
- Service layer for business logic
- Comprehensive pytest tests
- Automatic OpenAPI documentation at `/docs`

## Prerequisites

- Backend running: `docker-compose up backend`
- Database running and migrated: `docker-compose up db`
- Basic understanding of Python, FastAPI, and SQL

## Step 1: Create Database Model

Create a new SQLAlchemy model in `backend/src/models/`:

```bash
# Create the models directory if it doesn't exist
mkdir -p backend/src/models
```

**File**: `backend/src/models/task.py`

```python
"""
Purpose: SQLAlchemy model for Task entity with database schema definition

Scope: Task resource database representation with full CRUD support

Overview: Defines the Task table structure with SQLAlchemy ORM including primary key,
    foreign keys, constraints, relationships, and timestamp tracking. Provides the
    database schema for task management with user ownership, status tracking, and
    audit timestamps. Integrates with Alembic for migrations.

Dependencies: SQLAlchemy, database session, User model

Exports: Task model class

Implementation: SQLAlchemy declarative base with automatic timestamps
"""

from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from backend.src.database.base import Base


class Task(Base):
    """Task model for todo items with user ownership"""

    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False, index=True)
    description = Column(String(1000), nullable=True)
    completed = Column(Boolean, default=False, nullable=False, index=True)

    # Foreign key to users table (if you have user model)
    # user_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), onupdate=func.now(), server_default=func.now(), nullable=False)

    # Relationships (if applicable)
    # user = relationship("User", back_populates="tasks")

    def __repr__(self):
        return f"<Task(id={self.id}, title='{self.title}', completed={self.completed})>"
```

## Step 2: Create Pydantic Schemas

Create request/response schemas in `backend/src/schemas/`:

```bash
mkdir -p backend/src/schemas
```

**File**: `backend/src/schemas/task.py`

```python
"""
Purpose: Pydantic schemas for Task API request/response validation and serialization

Scope: Task resource API contracts with type validation

Overview: Defines Pydantic models for Task create, update, and response payloads with
    automatic validation, JSON serialization, and type checking. Provides strong typing
    for API endpoints and automatic OpenAPI schema generation. Ensures data integrity
    through field validators and type constraints.

Dependencies: Pydantic, Python type hints

Exports: TaskCreate, TaskUpdate, TaskResponse schemas

Implementation: Pydantic BaseModel with field validation and Config
"""

from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime


class TaskBase(BaseModel):
    """Base schema with common Task fields"""
    title: str = Field(..., min_length=1, max_length=200, description="Task title")
    description: str | None = Field(None, max_length=1000, description="Task description")
    completed: bool = Field(default=False, description="Task completion status")


class TaskCreate(TaskBase):
    """Schema for creating a new task"""
    pass


class TaskUpdate(BaseModel):
    """Schema for updating an existing task (all fields optional)"""
    title: str | None = Field(None, min_length=1, max_length=200)
    description: str | None = Field(None, max_length=1000)
    completed: bool | None = None


class TaskResponse(TaskBase):
    """Schema for task responses including database fields"""
    id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
```

## Step 3: Create Service Layer

Create business logic in `backend/src/services/`:

```bash
mkdir -p backend/src/services
```

**File**: `backend/src/services/task_service.py`

```python
"""
Purpose: Business logic service for Task resource CRUD operations

Scope: Task management with database operations and business rules

Overview: Provides service layer abstraction for Task operations including create, read,
    update, delete, and list with pagination. Encapsulates business logic, database
    queries, and error handling. Separates business logic from API routes for better
    testability and maintainability.

Dependencies: SQLAlchemy, Task model, database session

Exports: TaskService class with CRUD methods

Implementation: Service class pattern with database session dependency injection
"""

from sqlalchemy.orm import Session
from backend.src.models.task import Task
from backend.src.schemas.task import TaskCreate, TaskUpdate
from typing import List


class TaskService:
    """Service for Task CRUD operations"""

    @staticmethod
    def create_task(db: Session, task_data: TaskCreate) -> Task:
        """Create a new task"""
        task = Task(**task_data.model_dump())
        db.add(task)
        db.commit()
        db.refresh(task)
        return task

    @staticmethod
    def get_task(db: Session, task_id: int) -> Task | None:
        """Get task by ID"""
        return db.query(Task).filter(Task.id == task_id).first()

    @staticmethod
    def get_tasks(
        db: Session,
        skip: int = 0,
        limit: int = 100,
        completed: bool | None = None
    ) -> List[Task]:
        """Get list of tasks with pagination and optional filtering"""
        query = db.query(Task)

        if completed is not None:
            query = query.filter(Task.completed == completed)

        return query.offset(skip).limit(limit).all()

    @staticmethod
    def update_task(
        db: Session,
        task_id: int,
        task_data: TaskUpdate
    ) -> Task | None:
        """Update an existing task"""
        task = db.query(Task).filter(Task.id == task_id).first()

        if not task:
            return None

        # Update only provided fields
        update_data = task_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(task, field, value)

        db.commit()
        db.refresh(task)
        return task

    @staticmethod
    def delete_task(db: Session, task_id: int) -> bool:
        """Delete a task"""
        task = db.query(Task).filter(Task.id == task_id).first()

        if not task:
            return False

        db.delete(task)
        db.commit()
        return True
```

## Step 4: Create API Router

Create the FastAPI router in `backend/src/routers/`:

**File**: `backend/src/routers/tasks.py`

```python
"""
Purpose: FastAPI router for Task resource REST API endpoints

Scope: Task CRUD operations exposed as RESTful HTTP endpoints

Overview: Defines REST API routes for Task resource including create, read, update, delete,
    and list operations with automatic OpenAPI documentation. Implements standard HTTP
    methods and status codes, request validation, dependency injection for database sessions,
    and error handling. Provides self-documenting API via FastAPI's OpenAPI integration.

Dependencies: FastAPI, SQLAlchemy session, Task service, Task schemas

Exports: router instance for mounting in main app

Interfaces: GET /api/tasks, POST /api/tasks, GET /api/tasks/{id}, PUT /api/tasks/{id}, DELETE /api/tasks/{id}

Implementation: FastAPI APIRouter with dependency injection and Pydantic validation
"""

from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List

from backend.src.database.session import get_db
from backend.src.schemas.task import TaskCreate, TaskUpdate, TaskResponse
from backend.src.services.task_service import TaskService


router = APIRouter(
    prefix="/api/tasks",
    tags=["tasks"],
    responses={404: {"description": "Task not found"}},
)


@router.post(
    "/",
    response_model=TaskResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new task",
    description="Create a new task with title, optional description, and completion status",
)
def create_task(
    task_data: TaskCreate,
    db: Session = Depends(get_db)
):
    """Create a new task"""
    task = TaskService.create_task(db, task_data)
    return task


@router.get(
    "/",
    response_model=List[TaskResponse],
    summary="List all tasks",
    description="Get a paginated list of tasks with optional filtering by completion status",
)
def list_tasks(
    skip: int = Query(0, ge=0, description="Number of tasks to skip"),
    limit: int = Query(100, ge=1, le=1000, description="Maximum number of tasks to return"),
    completed: bool | None = Query(None, description="Filter by completion status"),
    db: Session = Depends(get_db)
):
    """Get list of tasks with pagination"""
    tasks = TaskService.get_tasks(db, skip=skip, limit=limit, completed=completed)
    return tasks


@router.get(
    "/{task_id}",
    response_model=TaskResponse,
    summary="Get task by ID",
    description="Retrieve a specific task by its unique identifier",
)
def get_task(
    task_id: int,
    db: Session = Depends(get_db)
):
    """Get a specific task by ID"""
    task = TaskService.get_task(db, task_id)

    if not task:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Task with id {task_id} not found"
        )

    return task


@router.put(
    "/{task_id}",
    response_model=TaskResponse,
    summary="Update task",
    description="Update an existing task's fields",
)
def update_task(
    task_id: int,
    task_data: TaskUpdate,
    db: Session = Depends(get_db)
):
    """Update an existing task"""
    task = TaskService.update_task(db, task_id, task_data)

    if not task:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Task with id {task_id} not found"
        )

    return task


@router.delete(
    "/{task_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete task",
    description="Delete a task by its ID",
)
def delete_task(
    task_id: int,
    db: Session = Depends(get_db)
):
    """Delete a task"""
    deleted = TaskService.delete_task(db, task_id)

    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Task with id {task_id} not found"
        )

    return None
```

## Step 5: Register Router in Main App

Update `backend/src/main.py` to include the new router:

```python
from backend.src.routers import tasks  # Add this import

# ... existing code ...

# Register routers
app.include_router(health.router)
app.include_router(tasks.router)  # Add this line
```

## Step 6: Create Database Migration

Generate Alembic migration for the new model:

```bash
# Generate migration
docker-compose run backend alembic revision --autogenerate -m "Add tasks table"

# Review the generated migration in backend/alembic/versions/

# Apply migration
docker-compose run backend alembic upgrade head
```

## Step 7: Write Tests

Create comprehensive tests in `backend/tests/`:

**File**: `backend/tests/test_tasks.py`

```python
"""
Purpose: Comprehensive test suite for Task API endpoints

Scope: Integration tests for Task CRUD operations

Overview: Tests all Task API endpoints including create, read, update, delete, and list
    operations with various scenarios, edge cases, and error conditions. Uses pytest
    fixtures for test database setup and teardown. Validates responses, status codes,
    and business logic.

Dependencies: pytest, FastAPI TestClient, SQLAlchemy test database

Exports: Test functions for Task API

Implementation: pytest with AAA pattern (Arrange, Act, Assert)
"""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from backend.src.main import app
from backend.src.database.session import get_db
from backend.tests.conftest import test_db  # Assuming you have test database fixture


client = TestClient(app)


def test_create_task():
    """Test creating a new task"""
    # Arrange
    task_data = {
        "title": "Test Task",
        "description": "Test Description",
        "completed": False
    }

    # Act
    response = client.post("/api/tasks/", json=task_data)

    # Assert
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == task_data["title"]
    assert data["description"] == task_data["description"]
    assert data["completed"] == task_data["completed"]
    assert "id" in data
    assert "created_at" in data
    assert "updated_at" in data


def test_get_task():
    """Test retrieving a task by ID"""
    # Arrange: Create a task first
    task_data = {"title": "Test Task", "completed": False}
    create_response = client.post("/api/tasks/", json=task_data)
    task_id = create_response.json()["id"]

    # Act
    response = client.get(f"/api/tasks/{task_id}")

    # Assert
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == task_id
    assert data["title"] == task_data["title"]


def test_get_task_not_found():
    """Test retrieving non-existent task returns 404"""
    # Act
    response = client.get("/api/tasks/99999")

    # Assert
    assert response.status_code == 404


def test_list_tasks():
    """Test listing tasks with pagination"""
    # Arrange: Create multiple tasks
    for i in range(5):
        client.post("/api/tasks/", json={"title": f"Task {i}", "completed": False})

    # Act
    response = client.get("/api/tasks/?skip=0&limit=3")

    # Assert
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) <= 3


def test_update_task():
    """Test updating a task"""
    # Arrange: Create a task
    create_response = client.post("/api/tasks/", json={"title": "Original", "completed": False})
    task_id = create_response.json()["id"]

    # Act
    update_data = {"title": "Updated", "completed": True}
    response = client.put(f"/api/tasks/{task_id}", json=update_data)

    # Assert
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Updated"
    assert data["completed"] is True


def test_delete_task():
    """Test deleting a task"""
    # Arrange: Create a task
    create_response = client.post("/api/tasks/", json={"title": "To Delete", "completed": False})
    task_id = create_response.json()["id"]

    # Act
    response = client.delete(f"/api/tasks/{task_id}")

    # Assert
    assert response.status_code == 204

    # Verify task is deleted
    get_response = client.get(f"/api/tasks/{task_id}")
    assert get_response.status_code == 404
```

## Step 8: Run Tests

```bash
# Run all tests
docker-compose run backend pytest

# Run specific test file
docker-compose run backend pytest tests/test_tasks.py

# Run with coverage
docker-compose run backend pytest --cov=backend/src tests/test_tasks.py
```

## Step 9: Test in Browser

1. **Start the backend**:
   ```bash
   docker-compose up backend
   ```

2. **Visit OpenAPI docs**: http://localhost:8000/docs

3. **Try the endpoints**:
   - Create a task: POST `/api/tasks/`
   - List tasks: GET `/api/tasks/`
   - Get task: GET `/api/tasks/{id}`
   - Update task: PUT `/api/tasks/{id}`
   - Delete task: DELETE `/api/tasks/{id}`

## Validation

✅ **Success Criteria**:
- [ ] Model created in `backend/src/models/task.py`
- [ ] Schemas created in `backend/src/schemas/task.py`
- [ ] Service created in `backend/src/services/task_service.py`
- [ ] Router created in `backend/src/routers/tasks.py`
- [ ] Router registered in `main.py`
- [ ] Migration created and applied
- [ ] Tests written and passing
- [ ] Endpoints visible in OpenAPI docs at `/docs`
- [ ] All CRUD operations work correctly

## Troubleshooting

### Issue: "Table doesn't exist"
**Solution**: Run migrations
```bash
docker-compose run backend alembic upgrade head
```

### Issue: "Module not found"
**Solution**: Check imports and ensure files are in correct directories

### Issue: "Tests failing"
**Solution**: Ensure test database is set up correctly in `conftest.py`

## Next Steps

1. **Add authentication**: Require users to be logged in
2. **Add user ownership**: Associate tasks with users
3. **Add validation**: Custom validators for business rules
4. **Add filtering**: More query parameters for filtering
5. **Connect to frontend**: See [How to Connect Frontend to API](how-to-connect-frontend-to-api.md)

---

**Congratulations!** You've created a complete REST API endpoint with database integration and tests.
