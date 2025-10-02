# Python Standards and Best Practices

**Purpose**: Python coding standards and conventions for ai-projen projects

**Scope**: Code style, naming, organization, and quality guidelines

**Overview**: Comprehensive Python standards based on PEP 8, modern Python idioms (3.11+),
    and industry best practices. Enforced through Ruff, MyPy, and Bandit.

---

## Development Environment

**IMPORTANT**: This project follows a Docker-first development pattern.

See `.ai/docs/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` for the complete philosophy.

**Three-Tier Hierarchy**:
1. **Docker (Preferred)** - Use `make dev-python`, `make lint-python`, `make test-python`
2. **Poetry (Fallback)** - Use `poetry run` commands when Docker unavailable
3. **Direct Local (Last Resort)** - Direct tool execution only when no other option

All quality tools (Ruff, MyPy, Bandit, Pytest) work seamlessly across all three environments thanks to `pyproject.toml` configuration.

---

## Code Style (PEP 8 Compliance)

### Line Length and Formatting
- **Maximum line length**: 120 characters
- **Indentation**: 4 spaces (no tabs)
- **Quote style**: Double quotes for strings
- **Trailing commas**: Use in multi-line collections
- **Blank lines**: 2 between top-level definitions, 1 between methods

```python
# Good
def calculate_total(
    items: list[dict],
    tax_rate: float = 0.1,
) -> float:
    """Calculate total with tax."""
    subtotal = sum(item["price"] for item in items)
    return subtotal * (1 + tax_rate)
```

### Import Organization
Imports should be organized in three groups with blank lines between:

1. **Standard library imports**
2. **Third-party imports**
3. **Local application imports**

```python
# Good
import os
import sys
from pathlib import Path

import requests
from fastapi import FastAPI

from myapp.models import User
from myapp.utils import validate_email
```

Use absolute imports, not relative:
```python
# Good
from myapp.models import User

# Avoid
from ..models import User
```

## Naming Conventions

### Variables and Functions
- **snake_case** for variables, functions, and methods
- **Descriptive names** that explain purpose
- **Avoid single-letter names** except for loop counters

```python
# Good
user_count = 10
def calculate_user_score(user_id: int) -> float:
    ...

# Bad
n = 10
def calc(x: int) -> float:
    ...
```

### Classes
- **PascalCase** for class names
- **Descriptive, noun-based names**

```python
# Good
class UserAuthentication:
    ...

class PaymentProcessor:
    ...

# Bad
class user_auth:
    ...
```

### Constants
- **UPPER_SNAKE_CASE** for constants
- **Module-level constants** at the top

```python
# Good
MAX_RETRIES = 3
DATABASE_URL = "postgresql://localhost/mydb"
DEFAULT_TIMEOUT_SECONDS = 30
```

### Private Members
- **Leading underscore** for private/internal
- **Double underscore** for name mangling (rare)

```python
class Example:
    def __init__(self):
        self.public_attr = "visible"
        self._internal_attr = "internal use"
        self.__private_attr = "name mangled"

    def public_method(self):
        ...

    def _internal_method(self):
        ...
```

### File Names
- **snake_case** for Python files
- **Descriptive names** matching module purpose

```
# Good
user_authentication.py
payment_processor.py
database_models.py

# Bad
UserAuth.py
paymentProcessor.py
```

## Type Hints

Always use type hints for function signatures:

```python
from typing import Optional

def process_user(
    user_id: int,
    name: str,
    email: Optional[str] = None,
) -> dict[str, any]:
    """Process user data and return result."""
    return {"id": user_id, "name": name, "email": email}
```

### Modern Type Hints (Python 3.11+)
Use built-in types instead of typing module when possible:

```python
# Good (Python 3.11+)
def get_users(limit: int = 10) -> list[dict[str, str]]:
    ...

# Old style (still works)
from typing import List, Dict
def get_users(limit: int = 10) -> List[Dict[str, str]]:
    ...
```

### Type Aliases for Complex Types
```python
from typing import TypeAlias

UserId: TypeAlias = int
UserData: TypeAlias = dict[str, str | int | bool]

def get_user(user_id: UserId) -> UserData:
    ...
```

## Docstrings

Use **Google-style docstrings** for documentation:

```python
def calculate_discount(
    price: float,
    discount_percent: float,
    max_discount: float = 100.0,
) -> float:
    """Calculate discounted price with maximum limit.

    Args:
        price: Original price before discount
        discount_percent: Discount percentage (0-100)
        max_discount: Maximum discount amount allowed

    Returns:
        Final price after applying discount

    Raises:
        ValueError: If discount_percent is negative or > 100

    Examples:
        >>> calculate_discount(100.0, 20.0)
        80.0
        >>> calculate_discount(100.0, 20.0, max_discount=10.0)
        90.0
    """
    if not 0 <= discount_percent <= 100:
        raise ValueError("Discount percent must be between 0 and 100")

    discount = price * (discount_percent / 100)
    discount = min(discount, max_discount)
    return price - discount
```

### Class Docstrings
```python
class PaymentProcessor:
    """Process payment transactions with multiple providers.

    This class handles payment processing through various payment gateways,
    including validation, authorization, and settlement.

    Attributes:
        provider: Payment gateway provider name
        api_key: API key for authentication
        timeout: Request timeout in seconds

    Example:
        >>> processor = PaymentProcessor("stripe", api_key="sk_test_...")
        >>> result = processor.process_payment(100.0, "usd")
    """

    def __init__(self, provider: str, api_key: str, timeout: int = 30):
        """Initialize payment processor."""
        self.provider = provider
        self.api_key = api_key
        self.timeout = timeout
```

## Error Handling

### Use Specific Exceptions
```python
# Good
try:
    user = get_user(user_id)
except UserNotFoundError:
    logger.error(f"User {user_id} not found")
    raise
except DatabaseError as e:
    logger.error(f"Database error: {e}")
    raise

# Bad
try:
    user = get_user(user_id)
except Exception:  # Too broad
    pass
```

### Custom Exceptions
```python
class UserNotFoundError(Exception):
    """Raised when user lookup fails."""

    def __init__(self, user_id: int):
        self.user_id = user_id
        super().__init__(f"User {user_id} not found")
```

### Context Managers
Use context managers for resource management:

```python
# Good
with open("data.txt") as f:
    content = f.read()

# Good
from contextlib import contextmanager

@contextmanager
def database_transaction():
    """Manage database transaction."""
    conn = get_connection()
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()
```

## Code Complexity

### Maximum Complexity: 10
Keep functions simple and focused:

```python
# Good - Single responsibility
def validate_email(email: str) -> bool:
    """Validate email format."""
    return "@" in email and "." in email.split("@")[1]

def validate_user_data(data: dict) -> bool:
    """Validate user data."""
    return (
        validate_email(data.get("email", ""))
        and len(data.get("name", "")) >= 2
        and data.get("age", 0) >= 18
    )

# Bad - Too complex
def process_user(data: dict) -> dict:
    """Too many responsibilities."""
    # Validation, transformation, database ops, API calls, etc.
    # 50+ lines of nested conditionals
    ...
```

### Refactoring Complex Code
Break down complex functions:

```python
# Before - Complex
def process_order(order_data: dict) -> dict:
    # Validate
    # Calculate prices
    # Apply discounts
    # Check inventory
    # Process payment
    # Send notifications
    # Update database
    # Return result
    pass  # 100+ lines

# After - Refactored
def process_order(order_data: dict) -> dict:
    """Process order through pipeline."""
    validated_order = validate_order(order_data)
    priced_order = calculate_order_total(validated_order)
    discounted_order = apply_discounts(priced_order)
    check_inventory(discounted_order)
    payment_result = process_payment(discounted_order)
    send_notifications(discounted_order, payment_result)
    return update_order_database(discounted_order, payment_result)
```

## Security Best Practices

### Never Hardcode Secrets
```python
# Bad
API_KEY = "sk_live_abc123..."
PASSWORD = "MyPassword123"

# Good
import os
API_KEY = os.environ.get("API_KEY")
PASSWORD = os.environ.get("DB_PASSWORD")
```

### Use Parameterized Queries
```python
# Bad - SQL injection risk
query = f"SELECT * FROM users WHERE id = {user_id}"

# Good - Parameterized
query = "SELECT * FROM users WHERE id = ?"
cursor.execute(query, (user_id,))
```

### Validate Input
```python
def process_user_input(data: str) -> str:
    """Process user input with validation."""
    # Validate and sanitize
    if not data or len(data) > 1000:
        raise ValueError("Invalid input length")

    # Remove dangerous characters
    sanitized = data.strip()

    return sanitized
```

## Testing Conventions

### Test File Organization
```
tests/
├── unit/
│   ├── test_models.py
│   └── test_utils.py
├── integration/
│   ├── test_api.py
│   └── test_database.py
└── conftest.py
```

### Test Naming
```python
# Good - Descriptive test names
def test_user_creation_with_valid_email_succeeds():
    ...

def test_user_creation_with_invalid_email_raises_error():
    ...

# Bad - Unclear test names
def test_user():
    ...

def test_1():
    ...
```

### Test Structure (Arrange-Act-Assert)
```python
def test_calculate_discount_applies_correctly():
    """Test discount calculation."""
    # Arrange
    price = 100.0
    discount_percent = 20.0

    # Act
    result = calculate_discount(price, discount_percent)

    # Assert
    assert result == 80.0
```

## Modern Python Features (3.11+)

### Use Match Statements
```python
def process_status(status: str) -> str:
    """Process status with match statement."""
    match status:
        case "pending":
            return "Waiting for approval"
        case "approved":
            return "Processing"
        case "rejected":
            return "Cancelled"
        case _:
            return "Unknown status"
```

### Use Dataclasses
```python
from dataclasses import dataclass

@dataclass
class User:
    """User data model."""
    id: int
    name: str
    email: str
    active: bool = True
```

### Use Type Unions
```python
def process_value(value: int | str) -> str:
    """Process int or string value."""
    return str(value)
```

## Performance Considerations

### Use List Comprehensions
```python
# Good - Comprehension
squares = [x**2 for x in range(10)]

# Less efficient - Loop
squares = []
for x in range(10):
    squares.append(x**2)
```

### Use Generators for Large Data
```python
# Good - Generator for memory efficiency
def read_large_file(filename: str):
    """Read large file line by line."""
    with open(filename) as f:
        for line in f:
            yield line.strip()

# Bad - Loads entire file into memory
def read_large_file_bad(filename: str) -> list[str]:
    with open(filename) as f:
        return [line.strip() for line in f]
```

## Summary Checklist

### Code Quality
- ✅ Follow PEP 8 style guide (120 char line length)
- ✅ Use type hints for all function signatures
- ✅ Write Google-style docstrings
- ✅ Use snake_case for functions/variables, PascalCase for classes
- ✅ Keep complexity under 10 (McCabe)
- ✅ Organize imports (stdlib, third-party, local)
- ✅ Never hardcode secrets
- ✅ Use parameterized queries
- ✅ Write descriptive test names
- ✅ Use modern Python 3.11+ features
- ✅ Handle errors with specific exceptions
- ✅ Use context managers for resources

### Development Environment (Docker-First)
- ✅ Use `make dev-python` to start development environment
- ✅ Use `make lint-python` for linting (auto-detects Docker/Poetry/Direct)
- ✅ Use `make typecheck` for type checking
- ✅ Use `make security-scan` for security scanning
- ✅ Use `make test-python` for running tests
- ✅ Use `make python-check` to run all quality checks
- ✅ Configure all tools in `pyproject.toml` for environment consistency
