# How to Handle Authentication

**Purpose**: Step-by-step guide for implementing OAuth2/JWT authentication in FastAPI with secure password handling and Docker-first development

**Scope**: JWT token generation, OAuth2 flow, password hashing, protected endpoints, refresh tokens, Docker-based auth testing

**Overview**: Comprehensive guide for implementing secure authentication and authorization using OAuth2 with JWT tokens in FastAPI. Covers password hashing with bcrypt, token generation and validation, protected endpoints with dependencies, refresh token patterns, and comprehensive security testing in Docker containers. Ensures production-grade authentication following OWASP best practices.

**Dependencies**: FastAPI security, python-jose, passlib, bcrypt, Docker, authentication concepts, security best practices

**Exports**: Authentication workflow, JWT patterns, password security, protected endpoint patterns

**Related**: Security best practices, user management, session handling, API security

**Implementation**: OAuth2 password flow, JWT encoding/decoding, FastAPI security dependencies, bcrypt hashing

---

This guide provides step-by-step instructions for implementing secure authentication using OAuth2/JWT with FastAPI and Docker.

## Prerequisites

- Python plugin installed in your project
- FastAPI backend configured
- Docker and Docker Compose running
- User database model created (see [How to Add Database Model](how-to-add-database-model.md))
- Understanding of authentication concepts
- Basic security knowledge

## Docker-First Development Pattern

All authentication should be tested in Docker to ensure secure configuration.

**Environment Priority**:
1. Docker containers (recommended)
2. Poetry virtual environment (fallback)
3. Direct local execution (last resort)

## Security Warning

**NEVER**:
- Store passwords in plain text
- Log passwords or tokens
- Hardcode secrets in code
- Use weak hashing algorithms (MD5, SHA1)
- Expose internal errors to users

**ALWAYS**:
- Use bcrypt or Argon2 for password hashing
- Store secrets in environment variables
- Use HTTPS in production
- Implement rate limiting
- Validate and sanitize input

## Steps to Implement Authentication

### 1. Install Security Dependencies

**Add to `pyproject.toml`**:
```toml
[tool.poetry.dependencies]
python-jose = {extras = ["cryptography"], version = "^3.3.0"}
passlib = {extras = ["bcrypt"], version = "^1.7.4"}
python-multipart = "^0.0.6"  # For OAuth2 form data
bcrypt = "^4.0.1"

[tool.poetry.group.dev.dependencies]
pytest-mock = "^3.11.1"  # For testing auth
```

**Rebuild Docker**:
```bash
make python-install
```

### 2. Configure Security Settings

**Create security config** (`backend/core/security.py`):
```python
"""Security configuration and utilities."""

from datetime import datetime, timedelta
from typing import Any, Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel
import os

# Security settings
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
REFRESH_TOKEN_EXPIRE_DAYS = 7

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class Token(BaseModel):
    """Token response model."""
    access_token: str
    token_type: str
    refresh_token: Optional[str] = None


class TokenData(BaseModel):
    """Token payload data."""
    username: Optional[str] = None
    user_id: Optional[int] = None


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify password against hash.

    Args:
        plain_password: Plain text password
        hashed_password: Hashed password from database

    Returns:
        True if password matches
    """
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    """Hash password using bcrypt.

    Args:
        password: Plain text password

    Returns:
        Hashed password

    Example:
        >>> hashed = get_password_hash("mypassword")
        >>> verify_password("mypassword", hashed)
        True
    """
    return pwd_context.hash(password)


def create_access_token(
    data: dict[str, Any],
    expires_delta: Optional[timedelta] = None
) -> str:
    """Create JWT access token.

    Args:
        data: Data to encode in token
        expires_delta: Optional expiration time

    Returns:
        Encoded JWT token
    """
    to_encode = data.copy()

    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    to_encode.update({"exp": expire, "type": "access"})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

    return encoded_jwt


def create_refresh_token(data: dict[str, Any]) -> str:
    """Create JWT refresh token.

    Args:
        data: Data to encode in token

    Returns:
        Encoded JWT refresh token
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)

    to_encode.update({"exp": expire, "type": "refresh"})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

    return encoded_jwt


def decode_token(token: str) -> dict[str, Any]:
    """Decode and verify JWT token.

    Args:
        token: JWT token to decode

    Returns:
        Decoded token payload

    Raises:
        JWTError: If token is invalid or expired
    """
    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    return payload
```

### 3. Create Authentication Dependencies

**Create auth dependencies** (`backend/core/dependencies.py`):
```python
"""FastAPI dependencies for authentication."""

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.orm import Session
from backend.core.security import decode_token, TokenData
from backend.core.database import get_db
from backend.models.user import User
from backend.crud.user import get_user_by_username

# OAuth2 scheme
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/auth/token")


async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> User:
    """Get current authenticated user from token.

    Args:
        token: JWT access token
        db: Database session

    Returns:
        Current User object

    Raises:
        HTTPException: 401 if authentication fails
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        # Decode token
        payload = decode_token(token)
        username: str = payload.get("sub")
        user_id: int = payload.get("user_id")
        token_type: str = payload.get("type")

        if username is None or user_id is None:
            raise credentials_exception

        if token_type != "access":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token type",
            )

    except JWTError:
        raise credentials_exception

    # Get user from database
    user = get_user_by_username(db, username=username)
    if user is None:
        raise credentials_exception

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Inactive user"
        )

    return user


async def get_current_active_user(
    current_user: User = Depends(get_current_user)
) -> User:
    """Get current active user.

    Args:
        current_user: Current user from token

    Returns:
        Active User object

    Raises:
        HTTPException: 403 if user is inactive
    """
    if not current_user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Inactive user"
        )
    return current_user


async def get_current_superuser(
    current_user: User = Depends(get_current_user)
) -> User:
    """Get current superuser.

    Args:
        current_user: Current user from token

    Returns:
        Superuser object

    Raises:
        HTTPException: 403 if user is not superuser
    """
    if not current_user.is_superuser:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    return current_user
```

### 4. Create Authentication Endpoints

**Using the template**:
```bash
cp plugins/languages/python/templates/fastapi-auth.py.template backend/api/auth.py
```

**Manual creation** (`backend/api/auth.py`):
```python
"""Authentication API endpoints."""

from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from backend.core.database import get_db
from backend.core.security import (
    Token,
    verify_password,
    create_access_token,
    create_refresh_token,
    decode_token,
    ACCESS_TOKEN_EXPIRE_MINUTES
)
from backend.core.dependencies import get_current_user
from backend.crud.user import get_user_by_username, create_user
from backend.models.user import User
from backend.schemas.user import UserCreate, UserResponse
from jose import JWTError

router = APIRouter(prefix="/api/auth", tags=["authentication"])


def authenticate_user(
    db: Session,
    username: str,
    password: str
) -> User | None:
    """Authenticate user with username and password.

    Args:
        db: Database session
        username: Username
        password: Plain text password

    Returns:
        User object if authenticated, None otherwise
    """
    user = get_user_by_username(db, username=username)
    if not user:
        return None
    if not verify_password(password, user.hashed_password):
        return None
    return user


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(
    user: UserCreate,
    db: Session = Depends(get_db)
) -> UserResponse:
    """Register new user.

    Args:
        user: User registration data
        db: Database session

    Returns:
        Created user

    Raises:
        HTTPException: 400 if username/email already exists
    """
    # Check if user exists
    db_user = get_user_by_username(db, username=user.username)
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username already registered"
        )

    # Create user
    new_user = create_user(db=db, user=user)
    return new_user


@router.post("/token", response_model=Token)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
) -> Token:
    """Login and get access token.

    Args:
        form_data: OAuth2 form with username and password
        db: Database session

    Returns:
        Access token and refresh token

    Raises:
        HTTPException: 401 if credentials are invalid
    """
    # Authenticate user
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Inactive user"
        )

    # Create tokens
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username, "user_id": user.id},
        expires_delta=access_token_expires
    )
    refresh_token = create_refresh_token(
        data={"sub": user.username, "user_id": user.id}
    )

    return Token(
        access_token=access_token,
        token_type="bearer",
        refresh_token=refresh_token
    )


@router.post("/refresh", response_model=Token)
def refresh_token(
    refresh_token: str,
    db: Session = Depends(get_db)
) -> Token:
    """Refresh access token using refresh token.

    Args:
        refresh_token: JWT refresh token
        db: Database session

    Returns:
        New access token

    Raises:
        HTTPException: 401 if refresh token is invalid
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        # Decode refresh token
        payload = decode_token(refresh_token)
        username: str = payload.get("sub")
        token_type: str = payload.get("type")

        if username is None or token_type != "refresh":
            raise credentials_exception

    except JWTError:
        raise credentials_exception

    # Get user
    user = get_user_by_username(db, username=username)
    if user is None or not user.is_active:
        raise credentials_exception

    # Create new access token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username, "user_id": user.id},
        expires_delta=access_token_expires
    )

    return Token(
        access_token=access_token,
        token_type="bearer"
    )


@router.get("/me", response_model=UserResponse)
def read_users_me(
    current_user: User = Depends(get_current_user)
) -> UserResponse:
    """Get current user information.

    Args:
        current_user: Current authenticated user

    Returns:
        Current user data
    """
    return current_user


@router.post("/logout")
def logout(
    current_user: User = Depends(get_current_user)
) -> dict:
    """Logout current user.

    Note: With JWT, logout is handled client-side by discarding the token.
    This endpoint can be used for logging or other cleanup.

    Args:
        current_user: Current authenticated user

    Returns:
        Logout confirmation
    """
    # Optional: Add token to blacklist in Redis
    # Optional: Log logout event

    return {"message": "Successfully logged out"}
```

### 5. Protect Endpoints with Authentication

**Add authentication to endpoints**:
```python
"""Protected API endpoints."""

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.core.database import get_db
from backend.core.dependencies import get_current_user, get_current_superuser
from backend.models.user import User
from backend.schemas.post import PostCreate, PostResponse

router = APIRouter(prefix="/api/posts", tags=["posts"])


@router.post("/", response_model=PostResponse)
def create_post(
    post: PostCreate,
    current_user: User = Depends(get_current_user),  # Requires authentication
    db: Session = Depends(get_db)
) -> PostResponse:
    """Create new post (requires authentication).

    Args:
        post: Post data
        current_user: Authenticated user
        db: Database session

    Returns:
        Created post
    """
    # Create post for current user
    db_post = Post(**post.dict(), author_id=current_user.id)
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return db_post


@router.delete("/{post_id}")
def delete_post(
    post_id: int,
    current_user: User = Depends(get_current_superuser),  # Requires admin
    db: Session = Depends(get_db)
) -> dict:
    """Delete post (admin only).

    Args:
        post_id: Post ID
        current_user: Authenticated superuser
        db: Database session

    Returns:
        Deletion confirmation
    """
    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")

    db.delete(post)
    db.commit()
    return {"message": "Post deleted"}
```

### 6. Configure Environment Variables

**Add to `.env`**:
```bash
# Security
SECRET_KEY=your-super-secret-key-change-in-production-use-openssl-rand-hex-32
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Database
DATABASE_URL=postgresql://user:password@db:5432/myapp
```

**Generate secret key**:
```bash
# Generate secure secret key
docker exec -it python-backend-container python -c "import secrets; print(secrets.token_hex(32))"
```

### 7. Test Authentication

**Start services**:
```bash
make dev-python
```

**Register user**:
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "username": "testuser",
    "password": "SecurePass123!",
    "full_name": "Test User"
  }'
```

**Login and get token**:
```bash
curl -X POST http://localhost:8000/api/auth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=testuser&password=SecurePass123!"

# Save the access_token from response
```

**Access protected endpoint**:
```bash
TOKEN="your-access-token-here"

curl http://localhost:8000/api/auth/me \
  -H "Authorization: Bearer $TOKEN"
```

**Refresh token**:
```bash
REFRESH_TOKEN="your-refresh-token-here"

curl -X POST http://localhost:8000/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d "{\"refresh_token\": \"$REFRESH_TOKEN\"}"
```

### 8. Test in Swagger UI

1. Open `http://localhost:8000/docs`
2. Click "Authorize" button
3. Enter username and password
4. Click "Authorize"
5. Try protected endpoints - they now work!

## Templates Reference

This guide references the following templates:

- `plugins/languages/python/templates/fastapi-auth.py.template` - Authentication endpoints
- `plugins/languages/python/templates/jwt-handler.py.template` - JWT utilities
- `plugins/languages/python/templates/security-config.py.template` - Security configuration

## Verification Steps

### 1. Test Registration

```bash
docker exec -it python-backend-container pytest tests/test_auth.py::test_register -v
```

### 2. Test Login

```bash
docker exec -it python-backend-container pytest tests/test_auth.py::test_login -v
```

### 3. Test Protected Endpoints

```bash
docker exec -it python-backend-container pytest tests/test_auth.py::test_protected_endpoint -v
```

### 4. Security Tests

```python
# tests/test_auth.py
def test_cannot_access_protected_without_token(client):
    """Test protected endpoint requires token."""
    response = client.get("/api/auth/me")
    assert response.status_code == 401


def test_cannot_login_with_wrong_password(client, sample_user):
    """Test login fails with wrong password."""
    response = client.post(
        "/api/auth/token",
        data={"username": "testuser", "password": "wrongpassword"}
    )
    assert response.status_code == 401


def test_token_expires(client, sample_user):
    """Test expired token is rejected."""
    # Create expired token
    expired_token = create_access_token(
        data={"sub": "testuser"},
        expires_delta=timedelta(seconds=-1)
    )

    response = client.get(
        "/api/auth/me",
        headers={"Authorization": f"Bearer {expired_token}"}
    )
    assert response.status_code == 401
```

## Best Practices

### 1. Never Log Passwords or Tokens

```python
# ✓ Good
logger.info(f"User {username} logged in")

# ✗ Bad - NEVER DO THIS
logger.info(f"User {username} logged in with password {password}")
logger.info(f"Generated token: {token}")
```

### 2. Use Dependencies for Authorization

```python
# ✓ Good - reusable dependency
@router.get("/admin")
def admin_endpoint(user: User = Depends(get_current_superuser)):
    return {"message": "Admin access"}

# ✗ Bad - manual check
@router.get("/admin")
def admin_endpoint(user: User = Depends(get_current_user)):
    if not user.is_superuser:
        raise HTTPException(403)
    return {"message": "Admin access"}
```

### 3. Validate Password Strength

```python
import re

def validate_password(password: str) -> None:
    """Validate password meets requirements.

    Raises:
        ValueError: If password doesn't meet requirements
    """
    if len(password) < 8:
        raise ValueError("Password must be at least 8 characters")

    if not re.search(r"[A-Z]", password):
        raise ValueError("Password must contain uppercase letter")

    if not re.search(r"[a-z]", password):
        raise ValueError("Password must contain lowercase letter")

    if not re.search(r"\d", password):
        raise ValueError("Password must contain digit")

    if not re.search(r"[!@#$%^&*]", password):
        raise ValueError("Password must contain special character")
```

### 4. Implement Rate Limiting

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

@router.post("/token")
@limiter.limit("5/minute")  # Max 5 login attempts per minute
def login(request: Request, ...):
    pass
```

### 5. Use HTTPS in Production

```python
# In main.py
if os.getenv("ENVIRONMENT") == "production":
    # Redirect HTTP to HTTPS
    app.add_middleware(HTTPSRedirectMiddleware)
```

## Common Issues and Solutions

### Token Not Working

**Issue**: 401 error with valid token

**Solutions**:
```bash
# Check token format
echo $TOKEN

# Verify token is not expired
docker exec -it python-backend-container python -c "
from backend.core.security import decode_token
print(decode_token('$TOKEN'))
"

# Check SECRET_KEY matches
docker exec -it python-backend-container env | grep SECRET_KEY
```

### Password Hashing Errors

**Issue**: `ValueError: Invalid salt` or similar

**Solution**:
```bash
# Ensure bcrypt is installed
docker exec -it python-backend-container pip list | grep bcrypt

# Reinstall if needed
docker exec -it python-backend-container pip install --force-reinstall bcrypt
```

### CORS Issues

**Issue**: Browser blocks requests with auth

**Solution**:
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,  # Important for auth!
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## Example: Complete Auth Test

```python
"""Complete authentication test suite."""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session


class TestAuthentication:
    """Test authentication flow."""

    def test_register_login_access_flow(
        self,
        client: TestClient,
        db_session: Session
    ) -> None:
        """Test complete auth flow: register -> login -> access."""
        # Register
        register_data = {
            "email": "test@example.com",
            "username": "testuser",
            "password": "SecurePass123!",
            "full_name": "Test User"
        }
        register_response = client.post("/api/auth/register", json=register_data)
        assert register_response.status_code == 201

        # Login
        login_data = {
            "username": "testuser",
            "password": "SecurePass123!"
        }
        login_response = client.post("/api/auth/token", data=login_data)
        assert login_response.status_code == 200
        token = login_response.json()["access_token"]

        # Access protected endpoint
        me_response = client.get(
            "/api/auth/me",
            headers={"Authorization": f"Bearer {token}"}
        )
        assert me_response.status_code == 200
        assert me_response.json()["username"] == "testuser"
```

## Checklist

- [ ] Security dependencies installed
- [ ] SECRET_KEY configured (not hardcoded!)
- [ ] Password hashing implemented with bcrypt
- [ ] JWT token creation and validation working
- [ ] OAuth2 dependencies created
- [ ] Authentication endpoints implemented
- [ ] Protected endpoints use auth dependencies
- [ ] HTTPS configured for production
- [ ] Rate limiting implemented
- [ ] Password validation added
- [ ] Never log passwords or tokens
- [ ] Tests cover auth flows
- [ ] All tests pass: `make test-python`

## Related Documentation

- [How to Create an API Endpoint](how-to-create-an-api-endpoint.md) - Protect your endpoints
- [How to Add Database Model](how-to-add-database-model.md) - User model for auth
- [How to Write a Test](how-to-write-a-test.md) - Test authentication
- [FastAPI Security Documentation](https://fastapi.tiangolo.com/tutorial/security/)
- [JWT Documentation](https://jwt.io/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

## Related Templates

- `plugins/languages/python/templates/fastapi-auth.py.template`
- `plugins/languages/python/templates/jwt-handler.py.template`
- `plugins/languages/python/templates/security-config.py.template`

---

**Difficulty**: Advanced
**Estimated Time**: 90-120 minutes
**Last Updated**: 2025-10-01
