"""Tests for example.py module.

Purpose: Demonstrate pytest testing best practices
Scope: Unit tests for example module
Overview: Shows proper test structure, naming, fixtures, and assertions
Dependencies: pytest
Related: example.py, pytest configuration
Implementation: Pytest unit tests
"""

import pytest

from example import User, calculate_discount, process_user_data, validate_email


class TestUser:
    """Tests for User class."""

    def test_user_creation_with_all_fields(self):
        """Test User creation with all fields provided."""
        user = User(id=1, name="Alice", email="alice@example.com", active=True)

        assert user.id == 1
        assert user.name == "Alice"
        assert user.email == "alice@example.com"
        assert user.active is True

    def test_user_creation_with_default_active(self):
        """Test User creation uses default active=True."""
        user = User(id=2, name="Bob", email="bob@example.com")

        assert user.active is True

    def test_get_display_name_returns_formatted_string(self):
        """Test get_display_name returns properly formatted string."""
        user = User(id=1, name="Alice", email="alice@example.com")

        result = user.get_display_name()

        assert result == "Alice (alice@example.com)"


class TestCalculateDiscount:
    """Tests for calculate_discount function."""

    def test_calculate_discount_with_twenty_percent(self):
        """Test 20% discount calculation."""
        result = calculate_discount(100.0, 20.0)

        assert result == 80.0

    def test_calculate_discount_with_fifty_percent(self):
        """Test 50% discount calculation."""
        result = calculate_discount(100.0, 50.0)

        assert result == 50.0

    def test_calculate_discount_with_max_limit(self):
        """Test discount with maximum limit applied."""
        result = calculate_discount(100.0, 50.0, max_discount=30.0)

        assert result == 70.0

    def test_calculate_discount_with_zero_percent(self):
        """Test zero discount returns original price."""
        result = calculate_discount(100.0, 0.0)

        assert result == 100.0

    def test_calculate_discount_raises_error_for_negative_price(self):
        """Test ValueError raised for negative price."""
        with pytest.raises(ValueError, match="Price cannot be negative"):
            calculate_discount(-10.0, 20.0)

    def test_calculate_discount_raises_error_for_invalid_percent(self):
        """Test ValueError raised for invalid discount percent."""
        with pytest.raises(ValueError, match="Discount percent must be between 0 and 100"):
            calculate_discount(100.0, 150.0)

    @pytest.mark.parametrize(
        "price,discount,expected",
        [
            (100.0, 10.0, 90.0),
            (50.0, 20.0, 40.0),
            (200.0, 25.0, 150.0),
            (75.0, 0.0, 75.0),
        ],
    )
    def test_calculate_discount_with_various_inputs(
        self, price: float, discount: float, expected: float
    ):
        """Test discount calculation with various input combinations."""
        result = calculate_discount(price, discount)

        assert result == expected


class TestValidateEmail:
    """Tests for validate_email function."""

    @pytest.mark.parametrize(
        "email",
        [
            "user@example.com",
            "alice.smith@company.co.uk",
            "test+tag@domain.org",
        ],
    )
    def test_validate_email_with_valid_emails(self, email: str):
        """Test validation passes for valid email formats."""
        result = validate_email(email)

        assert result is True

    @pytest.mark.parametrize(
        "email",
        [
            "invalid-email",
            "@example.com",
            "user@",
            "user@@example.com",
            "",
        ],
    )
    def test_validate_email_with_invalid_emails(self, email: str):
        """Test validation fails for invalid email formats."""
        result = validate_email(email)

        assert result is False


class TestProcessUserData:
    """Tests for process_user_data function."""

    @pytest.fixture
    def valid_user_data(self) -> dict[str, str | int]:
        """Provide valid user data dictionary."""
        return {
            "id": 1,
            "name": "Alice",
            "email": "alice@example.com",
            "active": True,
        }

    def test_process_user_data_creates_user_successfully(self, valid_user_data):
        """Test processing valid user data creates User instance."""
        user = process_user_data(valid_user_data)

        assert isinstance(user, User)
        assert user.id == 1
        assert user.name == "Alice"
        assert user.email == "alice@example.com"
        assert user.active is True

    def test_process_user_data_with_default_active(self):
        """Test processing data without active field uses default."""
        data = {"id": 2, "name": "Bob", "email": "bob@example.com"}

        user = process_user_data(data)

        assert user.active is True

    def test_process_user_data_raises_error_for_missing_id(self):
        """Test ValueError raised when id field is missing."""
        data = {"name": "Alice", "email": "alice@example.com"}

        with pytest.raises(ValueError, match="Missing required field: id"):
            process_user_data(data)

    def test_process_user_data_raises_error_for_missing_name(self):
        """Test ValueError raised when name field is missing."""
        data = {"id": 1, "email": "alice@example.com"}

        with pytest.raises(ValueError, match="Missing required field: name"):
            process_user_data(data)

    def test_process_user_data_raises_error_for_invalid_email(self):
        """Test ValueError raised for invalid email format."""
        data = {"id": 1, "name": "Alice", "email": "invalid-email"}

        with pytest.raises(ValueError, match="Invalid email format"):
            process_user_data(data)


@pytest.mark.integration
class TestIntegrationExample:
    """Example integration test (would require external services in real scenario)."""

    def test_full_user_workflow(self):
        """Test complete user creation and processing workflow."""
        # Arrange
        user_data = {"id": 1, "name": "Alice", "email": "alice@example.com"}

        # Act
        user = process_user_data(user_data)
        display_name = user.get_display_name()

        # Assert
        assert display_name == "Alice (alice@example.com)"
        assert user.active is True
