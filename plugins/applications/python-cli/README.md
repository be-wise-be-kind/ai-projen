# Python CLI Application Plugin

**Purpose**: Meta-plugin providing complete Python CLI application with Click framework, Docker packaging, and production-ready tooling

**Scope**: End-to-end CLI application setup for developers building command-line tools and utilities

**Overview**: This application plugin composes foundation, language, infrastructure, and standards plugins
    to deliver a complete, production-ready Python CLI application. It includes a functional starter application
    built with Click framework, configuration file management, structured logging, comprehensive testing,
    Docker packaging, and CI/CD pipeline. The plugin simplifies CLI development by providing battle-tested
    architecture with application-specific how-to guides and code generation templates.

**Dependencies**: foundation/ai-folder, languages/python, infrastructure/containerization/docker,
    infrastructure/ci-cd/github-actions, standards/security, standards/documentation, standards/pre-commit-hooks

**Exports**: Complete CLI starter application, CLI-specific how-tos, code generation templates, Docker configuration

**Related**: Python plugin (plugins/languages/python/), Docker plugin (plugins/infrastructure/containerization/docker/)

**Implementation**: Meta-plugin composition pattern with opinionated technology choices and comprehensive starter code

---

## What This Plugin Provides

### Starter Application

A complete, production-ready CLI application including:

- **Click Framework Integration**: Modern CLI with subcommands, options, and help text
- **Configuration Management**: YAML/JSON config file support with validation
- **Structured Logging**: Configurable logging with levels and formatters
- **Error Handling**: Comprehensive exception handling patterns
- **Docker Packaging**: Containerized distribution for easy deployment
- **Test Suite**: pytest-based tests with CLI invocation patterns
- **Type Hints**: Full type annotations throughout codebase
- **Code Quality**: Ruff linting and formatting pre-configured

### Example Commands

The starter application includes:

1. **hello** - Simple greeting command demonstrating CLI basics
2. **config show** - Display current configuration
3. **config set** - Update configuration values

### Technology Stack

- **Python**: 3.11+ with modern language features
- **Click**: 8.x for CLI framework
- **pytest**: Testing framework with Click testing utilities
- **Ruff**: Fast linting and formatting
- **Docker**: Container packaging for distribution
- **GitHub Actions**: Automated testing and releases

### Application Structure

```
your-project/
├── src/
│   ├── __init__.py              # Package initialization
│   ├── cli.py                   # Main CLI entrypoint with Click
│   └── config.py                # Configuration file management
│
├── tests/
│   ├── __init__.py
│   └── test_cli.py              # CLI command tests
│
├── .ai/
│   ├── docs/
│   │   └── python-cli-architecture.md
│   ├── howtos/python-cli/
│   │   ├── README.md
│   │   ├── how-to-add-cli-command.md
│   │   ├── how-to-handle-config-files.md
│   │   └── how-to-package-cli-tool.md
│   └── templates/python-cli/
│       ├── cli-entrypoint.py.template
│       ├── config-loader.py.template
│       └── setup.py.template
│
├── pyproject.toml               # Python project configuration
├── docker-compose.cli.yml       # CLI Docker setup
└── README.md                    # Project documentation
```

## Use Cases

This plugin is ideal for:

- **DevOps Tools**: Automation scripts and utilities
- **System Administration**: Server management CLIs
- **Data Processing**: ETL and transformation tools
- **Developer Tools**: Code generators, formatters, analyzers
- **API Clients**: Command-line interfaces for APIs
- **Deployment Scripts**: Infrastructure management tools

## Installation

### For AI Agents

Follow: `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md`

### For Humans

1. Ensure prerequisites:
   - Python 3.11+
   - Docker and Docker Compose
   - Git repository initialized

2. Install via ai-projen plugin manager:
   ```bash
   # From ai-projen repository
   ./install-plugin.sh applications/python-cli
   ```

3. Verify installation:
   ```bash
   python -m src.cli --help
   ```

## Quick Start

### Run the CLI Locally

```bash
# View available commands
python -m src.cli --help

# Run example hello command
python -m src.cli hello --name "World"
# Output: Hello, World!

# Show current configuration
python -m src.cli config show

# Update configuration
python -m src.cli config set key value
```

### Run Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html

# Run specific test
pytest tests/test_cli.py::test_hello_command
```

### Run in Docker

```bash
# Build container
docker-compose -f docker-compose.cli.yml build

# Run CLI in container
docker-compose -f docker-compose.cli.yml run cli --help

# Run command in container
docker-compose -f docker-compose.cli.yml run cli hello --name "Docker"
```

### Development Workflow

```bash
# Install dependencies
pip install -e ".[dev]"

# Make changes to src/cli.py
# Add new commands, modify existing ones

# Run tests
pytest

# Lint code
ruff check src tests

# Format code
ruff format src tests

# Commit (pre-commit hooks run automatically)
git add .
git commit -m "Add new feature"
```

## Common Tasks

### Add a New CLI Command

See: `.ai/howtos/python-cli/how-to-add-cli-command.md`

Quick example:
```python
# In src/cli.py

@cli.command()
@click.option('--input', '-i', required=True, help='Input file')
@click.option('--output', '-o', required=True, help='Output file')
def process(input: str, output: str):
    """Process input file and write to output."""
    click.echo(f"Processing {input} -> {output}")
    # Your processing logic here
```

### Handle Configuration Files

See: `.ai/howtos/python-cli/how-to-handle-config-files.md`

Configuration is managed by `src/config.py`:
```python
from src.config import load_config, save_config

# Load configuration
config = load_config()

# Access values
api_key = config.get('api_key')

# Update configuration
config['api_key'] = 'new-key'
save_config(config)
```

### Package for Distribution

See: `.ai/howtos/python-cli/how-to-package-cli-tool.md`

Options:
- **Docker Image**: For containerized distribution
- **PyPI Package**: For pip installation
- **Standalone Binary**: Using PyInstaller (future)

## Application-Specific How-Tos

All how-to guides are in `.ai/howtos/python-cli/`:

1. **how-to-add-cli-command.md** - Add new Click commands and subcommands
2. **how-to-handle-config-files.md** - Configuration file management patterns
3. **how-to-package-cli-tool.md** - Package and distribute your CLI tool

## Code Generation Templates

Templates in `.ai/templates/python-cli/`:

1. **cli-entrypoint.py.template** - Template for new CLI modules
2. **config-loader.py.template** - Configuration handler template
3. **setup.py.template** - Package setup template

## Architecture

See: `.ai/docs/python-cli-architecture.md` for detailed architecture documentation.

### Key Components

- **src/cli.py**: Main CLI entrypoint using Click decorators
- **src/config.py**: Configuration file loading and validation
- **tests/test_cli.py**: CLI testing using Click's CliRunner

### Design Patterns

- **Click Command Groups**: Organize commands hierarchically
- **Configuration Management**: YAML/JSON with defaults and validation
- **Dependency Injection**: Pass config and dependencies through Click context
- **Error Handling**: Custom exceptions with user-friendly messages
- **Logging**: Structured logging with configurable levels

## Configuration

### pyproject.toml

Main project configuration:
```toml
[project]
name = "my-cli-tool"
version = "0.1.0"
dependencies = [
    "click>=8.0.0",
    "pyyaml>=6.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "ruff>=0.1.0",
]

[project.scripts]
my-cli-tool = "src.cli:cli"
```

### docker-compose.cli.yml

CLI-specific Docker configuration:
```yaml
services:
  cli:
    build: .
    volumes:
      - ./config:/config
    command: --help
```

## Testing

### Test Structure

Tests use pytest with Click's testing utilities:
```python
from click.testing import CliRunner
from src.cli import cli

def test_hello_command():
    runner = CliRunner()
    result = runner.invoke(cli, ['hello', '--name', 'Test'])
    assert result.exit_code == 0
    assert 'Hello, Test!' in result.output
```

### Running Tests

```bash
# All tests
pytest

# With coverage
pytest --cov=src

# Specific test file
pytest tests/test_cli.py

# Specific test
pytest tests/test_cli.py::test_hello_command

# Verbose output
pytest -v

# Stop on first failure
pytest -x
```

## CI/CD Integration

GitHub Actions workflow automatically:
- Runs tests on Python 3.11 and 3.12
- Checks code formatting with Ruff
- Runs linting with Ruff
- Generates coverage reports
- Builds Docker images
- Creates releases with packaged CLI

## Customization

### Changing CLI Tool Name

1. Update `pyproject.toml`:
   ```toml
   [project]
   name = "your-tool-name"

   [project.scripts]
   your-tool-name = "src.cli:cli"
   ```

2. Update Docker compose service name in `docker-compose.cli.yml`

3. Update references in documentation

### Adding Dependencies

1. Add to `pyproject.toml`:
   ```toml
   dependencies = [
       "click>=8.0.0",
       "pyyaml>=6.0",
       "your-new-dependency>=1.0",
   ]
   ```

2. Reinstall:
   ```bash
   pip install -e ".[dev]"
   ```

### Custom Configuration Schema

See: `.ai/howtos/python-cli/how-to-handle-config-files.md`

Modify `src/config.py` to add validation and defaults.

## Known Limitations

- Designed for single CLI tool (not multi-binary projects)
- Config file location is fixed (user home or current directory)
- Docker image includes full Python runtime (not size-optimized)
- No built-in plugin system (can be added)
- No shell auto-completion (can be added)

## Future Enhancements

- Plugin system for extensibility
- Shell auto-completion (bash, zsh, fish)
- Interactive mode with prompt_toolkit
- Standalone binary packaging with PyInstaller
- Configuration file encryption
- Multi-command parallel execution

## Contributing

To improve this plugin:

1. Add new example commands to starter application
2. Create additional how-to guides
3. Add more code generation templates
4. Improve Docker image size
5. Add shell completion support

## Support

- **Documentation**: `.ai/docs/python-cli-architecture.md`
- **How-Tos**: `.ai/howtos/python-cli/`
- **Templates**: `.ai/templates/python-cli/`
- **Issues**: Open issue in ai-projen repository

## References

- [Click Documentation](https://click.palletsprojects.com/)
- [pytest Documentation](https://docs.pytest.org/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [Python Packaging Guide](https://packaging.python.org/)

## License

Part of the ai-projen framework. See main repository for license details.
