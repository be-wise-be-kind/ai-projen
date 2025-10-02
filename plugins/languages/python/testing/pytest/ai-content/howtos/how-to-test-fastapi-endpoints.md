# How to Test FastAPI Endpoints

**Purpose**: Testing FastAPI REST API endpoints with TestClient and async testing

**Scope**: Endpoint testing, authentication, request/response validation, dependency injection, error handling

**Dependencies**: pytest, httpx, FastAPI TestClient

---

## Basic Endpoint Testing

```python
from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()

@app.get("/health")
def health_check():
    return {"status": "healthy"}

client = TestClient(app)

def test_health_endpoint():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}
```

## Async Endpoint Testing

```python
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_async_endpoint():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/users/1")
        assert response.status_code == 200
```

## POST Requests with Body

```python
def test_create_user():
    payload = {"email": "test@example.com", "name": "Test User"}
    response = client.post("/users/", json=payload)

    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "test@example.com"
    assert "id" in data
```

## Testing Authentication

```python
def test_protected_endpoint_without_auth():
    response = client.get("/protected")
    assert response.status_code == 401

def test_protected_endpoint_with_auth():
    headers = {"Authorization": "Bearer valid-token-123"}
    response = client.get("/protected", headers=headers)
    assert response.status_code == 200
```

## Dependency Overrides

```python
from fastapi import Depends
from app.dependencies import get_db

def get_test_db():
    return MockDatabase()

app.dependency_overrides[get_db] = get_test_db

def test_with_overridden_dependency():
    response = client.get("/users/")
    assert response.status_code == 200
```

## Testing Error Responses

```python
def test_user_not_found():
    response = client.get("/users/99999")
    assert response.status_code == 404
    assert response.json() == {"detail": "User not found"}

def test_validation_error():
    payload = {"email": "invalid-email"}  # Missing name
    response = client.post("/users/", json=payload)
    assert response.status_code == 422
```

See `templates/test-api-endpoint.py.template` for complete examples.
