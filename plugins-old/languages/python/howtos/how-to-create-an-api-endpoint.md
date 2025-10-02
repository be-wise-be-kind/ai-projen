# How to Create an API Endpoint

**Purpose**: Step-by-step guide for adding new FastAPI endpoints to a Python backend with Docker-first development

**Scope**: FastAPI backend development, REST API creation, endpoint documentation, request/response handling with Docker containers

**Overview**: Comprehensive guide for adding new API endpoints to a FastAPI backend that ensures proper integration with auto-generated documentation. Covers endpoint creation patterns, request/response models, validation, error handling, and Docker-first testing approaches that maintain consistency with modern Python development standards.

**Dependencies**: FastAPI backend, Python type hints, Pydantic models, REST API knowledge, Docker

**Exports**: API endpoint creation workflow, documentation patterns, Docker-first testing approaches

**Related**: FastAPI backend documentation, API design standards, testing guides, Docker development patterns

**Implementation**: FastAPI router patterns, Pydantic validation, endpoint documentation, Docker-based testing integration

---

This guide provides step-by-step instructions for adding new API endpoints to a FastAPI backend with proper documentation and Docker-first testing.

## Prerequisites

- Python plugin installed in your project
- Docker installed and running
- FastAPI backend configured
- Understanding of Python type hints
- Basic knowledge of REST API principles

## Docker-First Development Pattern

This guide follows the Docker-first approach established in PR7.5. All development and testing should occur in containers first, with Poetry as a fallback.

**Environment Priority**:
1. Docker containers (recommended)
2. Poetry virtual environment (fallback)
3. Direct local execution (last resort)

See `.ai/docs/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` for complete details.

## Steps to Add a New API Endpoint

### 1. Start Development Environment

**Docker (Recommended)**:
```bash
# Start your FastAPI backend in Docker
make dev-python

# Verify containers are running
docker ps | grep python
```

**Poetry Fallback**:
```bash
# If Docker unavailable
poetry shell
poetry install
```

### 2. Create or Update Your Router Module

Create a new Python module in your backend app directory or add to an existing one.

**Using the template**:
```bash
# Copy the FastAPI router template
cp plugins/languages/python/templates/fastapi-router.py.template backend/app/your_feature.py
```

**Manual creation**:
```python
# backend/app/your_feature.py
from fastapi import APIRouter
from pydantic import BaseModel
from typing import Any

# Create a router with prefix and tags
router = APIRouter(
    prefix="/api/your_feature",
    tags=["your_feature"],  # This groups endpoints in the docs
)
```

### 3. Define Pydantic Models (Optional but Recommended)

Define request and response models for type safety and automatic documentation:

```python
# backend/app/your_feature.py

class RequestModel(BaseModel):
    """Request model for your endpoint.

    Attributes:
        field1: Description of field1
        field2: Description of field2
    """
    field1: str
    field2: int

class ResponseModel(BaseModel):
    """Response model for your endpoint.

    Attributes:
        result: The operation result
        status: The operation status
    """
    result: str
    status: str
```

### 4. Create Your Endpoint

Add your endpoint to the router with comprehensive documentation:

```python
@router.get("/config", tags=["your_feature"])
async def get_config() -> dict[str, Any]:
    """Get configuration for your feature.

    This docstring appears in the API documentation.
    Provide comprehensive details about what this endpoint does.

    Returns:
        Configuration dictionary with supported parameters.

    Example:
        ```python
        {
            "setting1": "value1",
            "setting2": "value2"
        }
        ```
    """
    return {
        "setting1": "value1",
        "setting2": "value2"
    }

@router.post("/action", response_model=ResponseModel)
async def perform_action(request: RequestModel) -> ResponseModel:
    """Perform an action with the given parameters.

    Args:
        request: The request parameters containing field1 and field2

    Returns:
        ResponseModel: The action result with status

    Raises:
        HTTPException: If validation fails or operation errors

    Example:
        ```json
        {
            "field1": "example",
            "field2": 42
        }
        ```
    """
    # Your business logic here
    result = f"Processed {request.field1} with value {request.field2}"
    return ResponseModel(result=result, status="completed")
```

### 5. Register the Router in main.py

**CRITICAL STEP**: Your endpoints won't appear in the documentation unless you register the router in `main.py`:

```python
# backend/app/main.py
from .your_feature import router as your_feature_router

# After app initialization
app.include_router(your_feature_router)
```

### 6. Test in Docker Environment

**Start/Restart your application**:
```bash
# If containers are running, restart to pick up changes
make dev-stop-python
make dev-python

# Or reload if hot-reload is configured
docker exec -it python-backend-container python -c "import uvicorn; print('Reload triggered')"
```

**Check the API documentation**:
- Open browser to `http://localhost:8000/docs`
- Verify your endpoint appears under the correct tag
- Test using the "Try it out" button

**Test with curl from host**:
```bash
# GET request
curl http://localhost:8000/api/your_feature/config

# POST request
curl -X POST http://localhost:8000/api/your_feature/action \
  -H "Content-Type: application/json" \
  -d '{"field1": "test", "field2": 123}'
```

**Test with curl from container**:
```bash
# Execute curl inside the container
docker exec -it python-backend-container curl http://localhost:8000/api/your_feature/config
```

### 7. WebSocket Endpoints (Special Case)

WebSocket endpoints need special handling because OpenAPI 3.0 doesn't natively support WebSockets. Best practice is to create a companion GET endpoint that documents the WebSocket interface:

```python
from fastapi import WebSocket

# The actual WebSocket endpoint
@router.websocket("/stream")
async def websocket_endpoint(websocket: WebSocket):
    """WebSocket endpoint for real-time streaming.

    Connect to this endpoint for real-time data streaming.
    See /stream/info for connection details and message formats.
    """
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            # Process and respond
            await websocket.send_json({"echo": data})
    except Exception as e:
        await websocket.close()

# Document the WebSocket endpoint with a GET endpoint
@router.get("/stream/info")
async def get_stream_info():
    """Get information about the WebSocket streaming endpoint.

    Returns connection details, message formats, and available commands
    for the WebSocket endpoint.

    Returns:
        WebSocket connection information and protocol details
    """
    return {
        "endpoint": "ws://localhost:8000/api/your_feature/stream",
        "protocol": "WebSocket",
        "commands": {
            "start": {
                "description": "Start streaming",
                "example": {"action": "start", "params": {}}
            },
            "stop": {
                "description": "Stop streaming",
                "example": {"action": "stop"}
            }
        },
        "response_format": {
            "type": "object",
            "properties": {
                "timestamp": "ISO 8601 timestamp",
                "data": "Streaming data payload"
            }
        }
    }
```

### 8. Excluding Endpoints from Documentation

To exclude certain endpoints (like health checks) from the documentation:

```python
@router.get("/health", include_in_schema=False)
async def health_check():
    """Health check endpoint - won't appear in /docs."""
    return {"status": "healthy"}
```

## Templates Reference

This guide references the following templates:

- `plugins/languages/python/templates/fastapi-router.py.template` - Complete router module
- `plugins/languages/python/templates/fastapi-endpoint.py.template` - Individual endpoint pattern
- `plugins/languages/python/templates/pydantic-schema.py.template` - Pydantic models

## Verification Steps

### 1. Check Documentation

1. Navigate to `http://localhost:8000/docs`
2. Verify your endpoint appears under the correct tag
3. Check that request/response schemas are properly displayed
4. Ensure docstrings appear in the documentation

### 2. Test Functionality

**In Docker**:
```bash
# Test GET endpoint
docker exec -it python-backend-container \
  curl -s http://localhost:8000/api/your_feature/config | jq

# Test POST endpoint
docker exec -it python-backend-container \
  curl -s -X POST http://localhost:8000/api/your_feature/action \
  -H "Content-Type: application/json" \
  -d '{"field1": "docker-test", "field2": 999}' | jq
```

**From host**:
```bash
# Test with curl
curl http://localhost:8000/api/your_feature/config

# Test with httpie (if installed)
http POST localhost:8000/api/your_feature/action field1=test field2:=42
```

### 3. Check Logs

```bash
# View container logs
docker logs python-backend-container --tail 50 -f

# Check for errors
docker logs python-backend-container 2>&1 | grep -i error
```

### 4. Run Automated Tests

```bash
# Run tests in Docker
make test-python

# Run with coverage
make test-coverage-python
```

## Best Practices

### 1. Always Use Tags

Tags group related endpoints in the documentation:

```python
router = APIRouter(
    prefix="/api/feature",
    tags=["feature"],  # Groups endpoints in docs
)

# You can also add tags to individual endpoints
@router.get("/special", tags=["feature", "advanced"])
async def special_endpoint():
    pass
```

### 2. Provide Comprehensive Documentation

Use docstrings and response models:

```python
@router.get(
    "/items/{item_id}",
    summary="Get an item by ID",
    description="Retrieve a specific item from the database using its unique identifier",
    response_description="The requested item with all attributes",
    responses={
        200: {"description": "Item found and returned successfully"},
        404: {"description": "Item not found"},
        500: {"description": "Internal server error"}
    }
)
async def get_item(item_id: str) -> ItemModel:
    """Get item by ID with full documentation."""
    pass
```

### 3. Use Type Hints Everywhere

Type hints enable automatic validation and documentation:

```python
from typing import Optional
from fastapi import Query

async def get_items(
    skip: int = Query(0, description="Number of items to skip", ge=0),
    limit: int = Query(10, description="Number of items to return", ge=1, le=100),
    search: Optional[str] = Query(None, description="Search term"),
) -> list[ItemModel]:
    """Type hints provide automatic validation and documentation."""
    pass
```

### 4. Standard Response Models

Create consistent error response models:

```python
from datetime import datetime
from pydantic import BaseModel

class ErrorResponse(BaseModel):
    """Standard error response model."""
    error: str
    error_code: str
    timestamp: datetime
    details: dict[str, Any] = {}
```

### 5. Proper Error Handling

Use FastAPI's HTTPException for proper error responses:

```python
from fastapi import HTTPException, status

@router.get("/items/{item_id}")
async def get_item(item_id: str) -> ItemModel:
    """Get item with proper error handling."""
    item = await db.get_item(item_id)
    if not item:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Item {item_id} not found"
        )
    return item
```

## Common Issues and Solutions

### Endpoint Not Appearing in Docs

**Issue**: New endpoint doesn't show up in `/docs`

**Solutions**:
1. **Check router registration**: Ensure `app.include_router(your_router)` is in main.py
2. **Verify tags**: Make sure tags are properly set on router or endpoints
3. **Check include_in_schema**: Ensure it's not set to False
4. **Restart container**: Changes require container restart
   ```bash
   make dev-stop-python
   make dev-python
   ```
5. **Check logs for errors**:
   ```bash
   docker logs python-backend-container 2>&1 | grep -i error
   ```

### WebSocket Endpoints

**Issue**: WebSocket endpoints don't appear in Swagger UI

**Solution**: WebSocket endpoints won't appear directly in OpenAPI docs because OpenAPI 3.0 doesn't support WebSockets. Instead:
1. Create a companion GET endpoint that documents the WebSocket interface (see Section 7)
2. The GET endpoint will appear in `/docs` and provide all necessary information
3. Test WebSockets with a client tool or custom frontend code, not through Swagger UI

### CORS Issues

**Issue**: Frontend can't connect to API

**Solution**: Ensure CORS is properly configured in main.py:

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Frontend URL
    allow_methods=["*"],
    allow_headers=["*"],
    allow_credentials=True,
)
```

### Container Connection Issues

**Issue**: Can't connect to API from host machine

**Solution**:
1. Check port mappings in `docker-compose.yml`:
   ```yaml
   ports:
     - "8000:8000"
   ```
2. Verify container is running:
   ```bash
   docker ps | grep python
   ```
3. Check if service is listening:
   ```bash
   docker exec -it python-backend-container netstat -tlnp | grep 8000
   ```

### Type Validation Errors

**Issue**: Pydantic validation errors with requests

**Solution**:
1. Ensure request data matches model schema
2. Check field types and requirements
3. Use proper JSON content type: `Content-Type: application/json`
4. Validate with model before sending:
   ```python
   # In tests
   request_data = RequestModel(field1="test", field2=42)
   assert request_data.model_validate(request_data.model_dump())
   ```

## Example: Complete Feature Module

Here's a complete example combining all best practices:

```python
# backend/app/features/user_management.py
"""User management API endpoints."""

from fastapi import APIRouter, HTTPException, status, Query
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

router = APIRouter(
    prefix="/api/users",
    tags=["users"],
)

# Request/Response Models
class UserCreate(BaseModel):
    """User creation request."""
    email: EmailStr
    username: str
    full_name: Optional[str] = None

class UserResponse(BaseModel):
    """User response model."""
    id: str
    email: str
    username: str
    full_name: Optional[str]
    created_at: datetime
    is_active: bool

class UserList(BaseModel):
    """Paginated user list response."""
    users: list[UserResponse]
    total: int
    page: int
    page_size: int

# Endpoints
@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate) -> UserResponse:
    """Create a new user.

    Args:
        user: User creation data

    Returns:
        Created user with generated ID and timestamps

    Raises:
        HTTPException: 409 if user already exists
    """
    # Business logic here
    pass

@router.get("/", response_model=UserList)
async def list_users(
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(10, ge=1, le=100, description="Items per page"),
    search: Optional[str] = Query(None, description="Search term"),
) -> UserList:
    """List users with pagination and search.

    Args:
        page: Page number (1-indexed)
        page_size: Number of items per page
        search: Optional search term

    Returns:
        Paginated list of users
    """
    # Business logic here
    pass

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: str) -> UserResponse:
    """Get user by ID.

    Args:
        user_id: User unique identifier

    Returns:
        User details

    Raises:
        HTTPException: 404 if user not found
    """
    # Business logic here
    pass
```

## Checklist

Before considering your endpoint complete:

- [ ] Router created with appropriate prefix and tags
- [ ] Pydantic models defined for requests/responses
- [ ] Comprehensive docstrings added
- [ ] Type hints used for all parameters
- [ ] Router registered in main.py
- [ ] Tested in Docker: `make dev-python`
- [ ] Endpoint appears in `/docs`
- [ ] Functionality verified with curl/httpie
- [ ] Error handling implemented
- [ ] CORS configured if needed
- [ ] Automated tests written
- [ ] Tests pass: `make test-python`

## Related Documentation

- [How to Write a Test](how-to-write-a-test.md) - Test your new endpoints
- [How to Add Database Model](how-to-add-database-model.md) - Add database persistence
- [How to Handle Authentication](how-to-handle-authentication.md) - Secure your endpoints
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Pydantic Documentation](https://docs.pydantic.dev/)
- [OpenAPI Specification](https://swagger.io/specification/)

## Related Templates

- `plugins/languages/python/templates/fastapi-router.py.template` - Router module template
- `plugins/languages/python/templates/fastapi-endpoint.py.template` - Endpoint pattern template
- `plugins/languages/python/templates/pydantic-schema.py.template` - Pydantic models template

---

**Difficulty**: Intermediate
**Estimated Time**: 30-45 minutes
**Last Updated**: 2025-10-01
