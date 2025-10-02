# MyPy - Python Static Type Checker

**What is MyPy?**

MyPy is a static type checker for Python. It analyzes your code to find type errors before you run it, helping catch bugs early in development.

**Why MyPy?**

- **Catch bugs early**: Find type-related errors before runtime
- **Better IDE support**: Enhanced autocomplete and refactoring
- **Documentation**: Type hints serve as inline documentation
- **Gradual typing**: Add types incrementally to existing code
- **Python standard**: PEP 484 compliant type checking

**What This Plugin Provides**

- Pre-configured MyPy settings for strict type checking
- Python 3.11+ type checking configuration
- Sensible defaults for production code
- Ready-to-use mypy.ini configuration file

**Commands**

```bash
# Type check all files
mypy .

# Type check specific directory
mypy src/

# Show error codes
mypy --show-error-codes .
```

**Type Hints Example**

```python
def calculate_total(prices: list[float], tax_rate: float = 0.1) -> float:
    """Calculate total price with tax."""
    subtotal = sum(prices)
    return subtotal * (1 + tax_rate)

# MyPy will catch errors like:
result = calculate_total(["10.00", "20.00"])  # Error: Expected list[float], got list[str]
```

**Configuration Location**

- `config/mypy.ini` - MyPy configuration file (copy to project root)

**Learn More**

- [MyPy Documentation](https://mypy.readthedocs.io/)
- [PEP 484 - Type Hints](https://www.python.org/dev/peps/pep-0484/)
- [MyPy Cheat Sheet](https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html)
