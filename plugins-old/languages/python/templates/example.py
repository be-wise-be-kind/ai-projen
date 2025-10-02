"""Example Python module demonstrating ai-projen standards.

Purpose: Demonstrate Python coding standards and best practices
Scope: Example code for new Python projects
Overview: This module shows proper code style, type hints, docstrings, and structure
    following PEP 8 and ai-projen standards.
Dependencies: None (stdlib only)
Exports: User class, calculate_discount function
Related: Python standards documentation
Implementation: Example code demonstrating best practices
"""

from dataclasses import dataclass
from typing import Optional


@dataclass
class User:
    """User data model.

    Represents a user in the system with basic information and status.

    Attributes:
        id: Unique user identifier
        name: User's full name
        email: User's email address
        active: Whether the user account is active

    Example:
        >>> user = User(id=1, name="Alice Smith", email="alice@example.com")
        >>> user.active
        True
    """

    id: int
    name: str
    email: str
    active: bool = True

    def get_display_name(self) -> str:
        """Get formatted display name.

        Returns:
            Formatted name string

        Example:
            >>> user = User(id=1, name="Alice Smith", email="alice@example.com")
            >>> user.get_display_name()
            'Alice Smith (alice@example.com)'
        """
        return f"{self.name} ({self.email})"


def calculate_discount(
    price: float,
    discount_percent: float,
    max_discount: Optional[float] = None,
) -> float:
    """Calculate discounted price with optional maximum limit.

    Args:
        price: Original price before discount
        discount_percent: Discount percentage (0-100)
        max_discount: Optional maximum discount amount

    Returns:
        Final price after applying discount

    Raises:
        ValueError: If price is negative or discount_percent is invalid

    Examples:
        >>> calculate_discount(100.0, 20.0)
        80.0
        >>> calculate_discount(100.0, 50.0, max_discount=30.0)
        70.0
    """
    if price < 0:
        raise ValueError("Price cannot be negative")

    if not 0 <= discount_percent <= 100:
        raise ValueError("Discount percent must be between 0 and 100")

    discount_amount = price * (discount_percent / 100)

    if max_discount is not None:
        discount_amount = min(discount_amount, max_discount)

    return price - discount_amount


def validate_email(email: str) -> bool:
    """Validate email format.

    Simple validation checking for @ symbol and domain.

    Args:
        email: Email address to validate

    Returns:
        True if email format is valid, False otherwise

    Example:
        >>> validate_email("user@example.com")
        True
        >>> validate_email("invalid-email")
        False
    """
    if not email or "@" not in email:
        return False

    parts = email.split("@")
    if len(parts) != 2:
        return False

    local, domain = parts
    return len(local) > 0 and "." in domain


def process_user_data(user_data: dict[str, str | int]) -> User:
    """Process and validate user data dictionary.

    Args:
        user_data: Dictionary containing user information

    Returns:
        User instance created from data

    Raises:
        ValueError: If required fields are missing or invalid

    Example:
        >>> data = {"id": 1, "name": "Bob", "email": "bob@example.com"}
        >>> user = process_user_data(data)
        >>> user.name
        'Bob'
    """
    required_fields = ["id", "name", "email"]

    for field in required_fields:
        if field not in user_data:
            raise ValueError(f"Missing required field: {field}")

    email = str(user_data["email"])
    if not validate_email(email):
        raise ValueError(f"Invalid email format: {email}")

    return User(
        id=int(user_data["id"]),
        name=str(user_data["name"]),
        email=email,
        active=bool(user_data.get("active", True)),
    )


if __name__ == "__main__":
    # Example usage
    user = User(id=1, name="Alice Smith", email="alice@example.com")
    print(f"User: {user.get_display_name()}")

    price = 100.0
    discount = 20.0
    final_price = calculate_discount(price, discount)
    print(f"Original: ${price}, Discount: {discount}%, Final: ${final_price}")
