# How to Parametrize Tests

**Purpose**: Run the same test with multiple inputs using @pytest.mark.parametrize

**Scope**: Test parametrization, multiple parameters, indirect parametrization, id customization

**Dependencies**: pytest

---

## Basic Parametrization

```python
import pytest

@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
])
def test_square(input, expected):
    assert input ** 2 == expected
```

## Multiple Parameters

```python
@pytest.mark.parametrize("x", [1, 2, 3])
@pytest.mark.parametrize("y", [10, 20])
def test_multiplication(x, y):
    # Runs 6 times (3 * 2 combinations)
    assert x * y == y * x
```

## Parametrize with IDs

```python
@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
], ids=["two_squared", "three_squared", "four_squared"])
def test_square_with_ids(input, expected):
    assert input ** 2 == expected
```

## Parametrize with pytest.param

```python
@pytest.mark.parametrize("value,expected", [
    pytest.param(1, 1, id="one"),
    pytest.param(2, 4, id="two"),
    pytest.param(3, 9, marks=pytest.mark.slow, id="three_slow"),
])
def test_with_param_objects(value, expected):
    assert value ** 2 == expected
```

## Indirect Parametrization (with Fixtures)

```python
@pytest.fixture
def user_role(request):
    return create_user(role=request.param)

@pytest.mark.parametrize("user_role", ["admin", "user", "guest"], indirect=True)
def test_permissions(user_role):
    assert user_role.has_valid_role()
```

## Parametrize Classes

```python
@pytest.mark.parametrize("value", [1, 2, 3])
class TestCalculations:
    def test_double(self, value):
        assert value * 2 == value + value

    def test_square(self, value):
        assert value ** 2 >= value
```

## Complex Parametrization

```python
test_cases = [
    ("valid_email@example.com", True),
    ("invalid-email", False),
    ("another.valid@domain.co.uk", True),
    ("@invalid.com", False),
]

@pytest.mark.parametrize("email,is_valid", test_cases)
def test_email_validation(email, is_valid):
    result = validate_email(email)
    assert result == is_valid
```

## Skipping Specific Parameters

```python
@pytest.mark.parametrize("x,y,expected", [
    (1, 2, 3),
    (2, 3, 5),
    pytest.param(3, 4, 7, marks=pytest.mark.skip(reason="Not ready")),
    (4, 5, 9),
])
def test_addition(x, y, expected):
    assert x + y == expected
```
