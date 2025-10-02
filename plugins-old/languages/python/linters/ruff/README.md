# Ruff - Python Linter and Formatter

**What is Ruff?**

Ruff is an extremely fast Python linter and code formatter written in Rust. It's designed to replace multiple tools in the Python ecosystem:
- **Black** (formatting)
- **isort** (import sorting)
- **flake8** (linting)
- **pyupgrade** (Python syntax modernization)
- Parts of **pylint**, **bandit** (security), and more

**Why Ruff?**

- **Speed**: 10-100x faster than traditional Python linters
- **All-in-one**: Combines linting and formatting in a single tool
- **Compatible**: Black-compatible formatting, familiar rule names
- **Comprehensive**: 700+ lint rules covering quality, security, and style
- **Actively maintained**: Rapidly growing ecosystem adoption

**What This Plugin Provides**

- Pre-configured Ruff settings optimized for Python 3.11+
- PEP 8 compliance with sensible defaults
- Security checks (bandit subset)
- Complexity limits (McCabe)
- Import sorting (isort replacement)
- Auto-formatting (Black-compatible)

**Commands**

```bash
# Lint code
ruff check .

# Format code
ruff format .

# Auto-fix issues
ruff check --fix .

# Combined lint and format
ruff check --fix . && ruff format .
```

**Configuration Location**

- `config/pyproject.toml` - Ruff configuration (merge into your existing pyproject.toml)

**Learn More**

- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [Ruff Rules](https://docs.astral.sh/ruff/rules/)
- [Ruff GitHub](https://github.com/astral-sh/ruff)
