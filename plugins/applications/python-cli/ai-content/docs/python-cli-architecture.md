# Python CLI Application Architecture

**Purpose**: Architectural documentation for Python CLI applications built with Typer framework

**Scope**: Design patterns, component structure, and best practices for CLI application development

**Overview**: This document describes the architecture of Python CLI applications created with this plugin.
    It covers the Typer-based command structure, configuration management patterns, error handling strategies,
    testing approaches, and Docker packaging. The architecture emphasizes modularity, testability, and
    production-ready practices for building professional command-line tools with Rich-styled output.

**Dependencies**: Typer framework, Rich library, Python 3.11+, pytest, Docker

**Exports**: Architectural patterns, component descriptions, design decisions, extension points

**Related**: .ai/howtos/python-cli/, plugins/languages/python/, Python CLI plugin README

**Implementation**: Typer commands with Annotated type hints, Rich console output, Docker multi-stage builds

---

## Overview

The Python CLI application architecture provides a production-ready foundation for building command-line tools with:

- **Modular Command Structure**: Typer-based commands with type hints and automatic validation
- **Rich Integration**: Styled console output with colors, tables, and progress bars
- **Configuration Management**: YAML/JSON config with validation and defaults
- **Comprehensive Error Handling**: User-friendly error messages and exit codes
- **Structured Logging**: Configurable logging with multiple levels
- **Testing Framework**: pytest with Typer testing utilities
- **Container Packaging**: Docker-based distribution

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     CLI Application                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              CLI Entrypoint (src/cli.py)              │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐     │  │
│  │  │   hello    │  │   config   │  │  custom    │     │  │
│  │  │  command   │  │   group    │  │  commands  │     │  │
│  │  └────────────┘  └────────────┘  └────────────┘     │  │
│  │         │              │                │             │  │
│  └─────────┼──────────────┼────────────────┼─────────────┘  │
│            │              │                │                 │
│  ┌─────────▼──────────────▼────────────────▼─────────────┐  │
│  │          Configuration Layer (src/config.py)          │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐     │  │
│  │  │   Load     │  │   Validate │  │    Save    │     │  │
│  │  │   Config   │  │   Schema   │  │   Config   │     │  │
│  │  └────────────┘  └────────────┘  └────────────┘     │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐  │
│  │           Logging & Error Handling Layer              │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐     │  │
│  │  │  Structured│  │   Error    │  │  Exit Code │     │  │
│  │  │   Logger   │  │  Handlers  │  │  Management│     │  │
│  │  └────────────┘  └────────────┘  └────────────┘     │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                Rich Output Layer                        │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐     │  │
│  │  │   Tables   │  │   Colors   │  │  Progress  │     │  │
│  │  │            │  │  & Styles  │  │    Bars    │     │  │
│  │  └────────────┘  └────────────┘  └────────────┘     │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ Packaged as
                            ▼
              ┌───────────────────────────┐
              │     Docker Container       │
              │  ┌─────────────────────┐  │
              │  │  Python 3.11 Slim   │  │
              │  │  + Dependencies     │  │
              │  │  + CLI Application  │  │
              │  └─────────────────────┘  │
              └───────────────────────────┘
```

## Core Components

### 1. CLI Entrypoint (src/cli.py)

The main CLI interface using Typer framework with Rich integration.

**Responsibilities**:
- Define CLI commands and subcommands using Typer
- Handle command-line arguments and options with type hints
- Coordinate between commands and business logic
- Manage application state for shared data
- Configure logging based on verbosity flags
- Provide styled output with Rich

**Key Patterns**:

```python
import typer
import logging
from typing import Annotated, Optional
from pathlib import Path
from enum import Enum

from rich import print as rprint
from rich.console import Console

console = Console()

# State class for sharing data between commands
class State:
    def __init__(self):
        self.config: dict = {}
        self.verbose: bool = False

state = State()

# Create main app
app = typer.Typer(
    name="mycli",
    help="My CLI application",
    rich_markup_mode="rich",
)

# Create subcommand group
config_app = typer.Typer(help="Configuration commands.")
app.add_typer(config_app, name="config")

@app.callback()
def main(
    verbose: Annotated[bool, typer.Option(
        "--verbose", "-v",
        help="Enable verbose output"
    )] = False,
    config: Annotated[Optional[Path], typer.Option(
        "--config", "-c",
        help="Config file path"
    )] = None,
):
    """Main CLI entrypoint with shared options."""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(level=level)

    state.config = load_config(config)
    state.verbose = verbose

@app.command()
def hello(
    name: Annotated[str, typer.Option(
        "--name", "-n",
        help="Name to greet"
    )] = "World",
):
    """Print a greeting message."""
    greeting = state.config.get('greeting', 'Hello')
    rprint(f"[green]{greeting}, {name}![/green]")

@config_app.command("show")
def config_show():
    """Display current configuration."""
    from rich.table import Table
    table = Table(title="Configuration")
    table.add_column("Key", style="cyan")
    table.add_column("Value", style="green")
    for k, v in state.config.items():
        table.add_row(k, str(v))
    console.print(table)
```

**Design Decisions**:
- **Typer App**: Modern CLI framework built on Click with type hints
- **State Class**: Module-level state object replaces Click's context passing
- **Annotated Types**: Clean, type-safe parameter definitions
- **Rich Integration**: Styled output for professional appearance
- **Subcommand Groups**: Organize related commands with `add_typer()`

### 2. Configuration Management (src/config.py)

Handles loading, validating, and saving configuration files.

**Responsibilities**:
- Load config from YAML or JSON files
- Provide sensible defaults
- Validate configuration schema
- Save configuration updates
- Locate config files (user home, current directory, explicit path)

**Key Patterns**:

```python
from pathlib import Path
import yaml
from typing import Dict, Any, Optional

DEFAULT_CONFIG_LOCATIONS = [
    Path.home() / '.config' / 'mycli' / 'config.yaml',
    Path.cwd() / 'config.yaml',
]

DEFAULT_CONFIG = {
    'greeting': 'Hello',
    'log_level': 'INFO',
    'output_format': 'text',
}

def load_config(config_path: Optional[Path] = None) -> Dict[str, Any]:
    """Load configuration with fallback to defaults."""
    if config_path and config_path.exists():
        with open(config_path) as f:
            user_config = yaml.safe_load(f)
        return {**DEFAULT_CONFIG, **user_config}

    # Try default locations
    for location in DEFAULT_CONFIG_LOCATIONS:
        if location.exists():
            with open(location) as f:
                user_config = yaml.safe_load(f)
            return {**DEFAULT_CONFIG, **user_config}

    return DEFAULT_CONFIG.copy()

def save_config(config: Dict[str, Any], config_path: Optional[Path] = None):
    """Save configuration to file."""
    path = config_path or DEFAULT_CONFIG_LOCATIONS[0]
    path.parent.mkdir(parents=True, exist_ok=True)

    with open(path, 'w') as f:
        yaml.dump(config, default_flow_style=False)

def validate_config(config: Dict[str, Any]) -> tuple[bool, list[str]]:
    """Validate configuration schema."""
    errors = []
    required_keys = ['greeting', 'log_level']
    for key in required_keys:
        if key not in config:
            errors.append(f"Missing required key: {key}")
    return len(errors) == 0, errors
```

**Design Decisions**:
- **Multiple Locations**: Check multiple paths for config files
- **Defaults**: Always have working defaults
- **Merging**: User config overrides defaults
- **Validation**: Fail early with clear messages
- **Type Safety**: Use type hints throughout

### 3. Error Handling

Comprehensive error handling with user-friendly messages and Rich styling.

**Responsibilities**:
- Catch and handle exceptions gracefully
- Provide informative error messages with colors
- Use appropriate exit codes
- Log errors for debugging

**Key Patterns**:

```python
import typer
from rich import print as rprint

class CLIError(Exception):
    """Base exception for CLI errors."""
    exit_code = 1

class ConfigError(CLIError):
    """Configuration-related errors."""
    exit_code = 2

class ValidationError(CLIError):
    """Input validation errors."""
    exit_code = 3

@app.command()
def risky_operation():
    """Command that might fail."""
    try:
        # Operation logic
        result = perform_operation()
        rprint(f"[green]✓ Success: {result}[/green]")
    except ConfigError as e:
        rprint(f"[red]Configuration error: {e}[/red]")
        raise typer.Exit(code=2)
    except ValidationError as e:
        rprint(f"[red]Validation error: {e}[/red]")
        raise typer.Exit(code=3)
    except Exception as e:
        rprint(f"[red]Unexpected error: {e}[/red]")
        raise typer.Exit(code=1)
```

**Exit Codes**:
- `0`: Success
- `1`: General error
- `2`: Configuration error
- `3`: Validation error
- `4`: File not found
- `5`: Network error

### 4. Rich Output Integration

Styled console output using Rich library.

**Responsibilities**:
- Provide colored and styled text output
- Display data in tables
- Show progress bars for long operations
- Format error messages prominently

**Key Patterns**:

```python
from rich import print as rprint
from rich.console import Console
from rich.table import Table
from rich.progress import track
from rich.panel import Panel

console = Console()

# Colored text
rprint("[green]Success![/green]")
rprint("[red]Error occurred[/red]")
rprint("[yellow]Warning: proceed with caution[/yellow]")
rprint("[bold cyan]Important information[/bold cyan]")

# Tables for structured data
def show_config(config: dict):
    table = Table(title="Configuration", show_header=True)
    table.add_column("Key", style="cyan", width=20)
    table.add_column("Value", style="green")
    for key, value in config.items():
        table.add_row(str(key), str(value))
    console.print(table)

# Progress bars for iterations
def process_items(items: list):
    for item in track(items, description="Processing..."):
        process(item)
    rprint("[green]✓ Complete![/green]")

# Panels for important messages
def show_error(message: str):
    console.print(Panel(
        f"[red]{message}[/red]",
        title="Error",
        border_style="red"
    ))
```

### 5. Logging

Structured logging with configurable levels and formats.

**Responsibilities**:
- Configure logging based on verbosity
- Provide structured log output
- Support multiple log levels
- Enable debug logging for development

**Key Patterns**:

```python
import logging
from pathlib import Path
from typing import Optional

def setup_logging(verbose: bool = False, log_file: Optional[Path] = None):
    """Configure logging for the application."""
    level = logging.DEBUG if verbose else logging.INFO

    # Format: timestamp | level | message
    formatter = logging.Formatter(
        '%(asctime)s | %(levelname)-8s | %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )

    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)

    # Root logger configuration
    root_logger = logging.getLogger()
    root_logger.setLevel(level)
    root_logger.addHandler(console_handler)

    # Optional file logging
    if log_file:
        file_handler = logging.FileHandler(log_file)
        file_handler.setFormatter(formatter)
        root_logger.addHandler(file_handler)
```

### 6. Testing Framework

Comprehensive testing using pytest and Typer's testing utilities.

**Responsibilities**:
- Test CLI commands in isolation
- Test command interactions
- Test configuration handling
- Test error conditions

**Key Patterns**:

```python
from typer.testing import CliRunner
import pytest
from src.cli import app, state

@pytest.fixture
def runner():
    """Provide Typer test runner."""
    return CliRunner()

@pytest.fixture(autouse=True)
def reset_state():
    """Reset global state before each test."""
    state.config = {}
    state.verbose = False
    yield
    state.config = {}
    state.verbose = False

@pytest.fixture
def temp_config(tmp_path):
    """Provide temporary config file."""
    config_file = tmp_path / 'config.yaml'
    config_file.write_text('greeting: Hi\n')
    return config_file

def test_hello_command(runner):
    """Test basic hello command."""
    result = runner.invoke(app, ['hello', '--name', 'Test'])
    assert result.exit_code == 0
    assert 'Hello, Test!' in result.output

def test_hello_with_custom_config(runner, temp_config):
    """Test hello command with custom config."""
    result = runner.invoke(app, [
        '--config', str(temp_config),
        'hello', '--name', 'Test'
    ])
    assert result.exit_code == 0
    assert 'Hi, Test!' in result.output

def test_config_show_command(runner):
    """Test config show command."""
    result = runner.invoke(app, ['config', 'show'])
    assert result.exit_code == 0
    assert 'greeting' in result.output
```

**Test Organization**:
- `tests/test_cli.py`: Main CLI command tests
- `tests/test_config.py`: Configuration management tests
- `tests/test_integration.py`: End-to-end integration tests
- `tests/conftest.py`: Shared fixtures

## Docker Packaging

### Multi-Stage Build

```dockerfile
# Builder stage
FROM python:3.11-slim as builder

WORKDIR /app

# Install dependencies
COPY pyproject.toml .
RUN pip install --no-cache-dir build && \
    pip wheel --no-cache-dir --wheel-dir /wheels .

# Runtime stage
FROM python:3.11-slim

WORKDIR /app

# Copy wheels and install
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/*.whl && \
    rm -rf /wheels

# Copy application
COPY src/ ./src/

# Set entrypoint
ENTRYPOINT ["python", "-m", "src.cli"]
CMD ["--help"]
```

### Docker Compose Configuration

```yaml
services:
  cli:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./config:/config
      - ./data:/data
    environment:
      - CLI_CONFIG_PATH=/config/config.yaml
    command: --help
```

**Design Decisions**:
- **Multi-Stage Build**: Minimize image size
- **Slim Base**: Use Python slim images
- **Volume Mounts**: Externalize config and data
- **Entrypoint**: Default to CLI module

## Command Organization Patterns

### Flat Structure

Simple CLIs with few commands:

```python
app = typer.Typer()

@app.command()
def command1():
    pass

@app.command()
def command2():
    pass
```

### Grouped Structure

Complex CLIs with related command groups:

```python
app = typer.Typer()

# Group 1
group1_app = typer.Typer(help="Group 1 commands.")
app.add_typer(group1_app, name="group1")

@group1_app.command()
def subcommand1():
    pass

@group1_app.command()
def subcommand2():
    pass

# Group 2
group2_app = typer.Typer(help="Group 2 commands.")
app.add_typer(group2_app, name="group2")
```

### Plugin-Based Structure

Extensible CLIs with plugin support:

```python
# In src/plugins/
class PluginBase:
    def register_commands(self, app: typer.Typer):
        raise NotImplementedError

# In src/cli.py
def load_plugins():
    for plugin in discover_plugins():
        plugin.register_commands(app)
```

## Extension Points

### Adding New Commands

1. **Simple Command**:
   ```python
   @app.command()
   def new_command(
       option: Annotated[str, typer.Option(help="Description")] = "default",
   ):
       """Command description."""
       rprint(f"[green]Running with {option}[/green]")
   ```

2. **Command Group**:
   ```python
   new_group = typer.Typer(help="Group description.")
   app.add_typer(new_group, name="new-group")

   @new_group.command()
   def subcommand():
       """Subcommand description."""
       pass
   ```

### Custom Configuration Schema

Extend configuration validation:

```python
from pydantic import BaseModel

class ConfigSchema(BaseModel):
    greeting: str = "Hello"
    log_level: str = "INFO"
    custom_field: int = 42

def load_config(path: Path) -> ConfigSchema:
    data = yaml.safe_load(open(path))
    return ConfigSchema(**data)
```

### Output Format Enum

Support multiple output formats with type-safe enums:

```python
from enum import Enum

class OutputFormat(str, Enum):
    json = "json"
    yaml = "yaml"
    text = "text"

@app.command()
def export(
    format: Annotated[OutputFormat, typer.Option(
        "--format", "-f",
        help="Output format"
    )] = OutputFormat.text,
):
    """Export data in specified format."""
    if format == OutputFormat.json:
        import json
        rprint(json.dumps(data, indent=2))
    elif format == OutputFormat.yaml:
        import yaml
        rprint(yaml.dump(data))
    else:
        rprint(str(data))
```

## Best Practices

### Command Design

- **Single Responsibility**: Each command does one thing well
- **Composability**: Commands can be combined in scripts
- **Idempotency**: Commands produce same result when run multiple times
- **Reversibility**: Provide undo operations where applicable

### Error Messages

- **Clear and Actionable**: Tell user what went wrong and how to fix it
- **Context**: Include relevant information (file paths, values)
- **Suggestions**: Offer alternatives when possible
- **Exit Codes**: Use appropriate exit codes for different error types
- **Color Coding**: Red for errors, yellow for warnings, green for success

### Configuration

- **Sensible Defaults**: Work out of the box
- **Override Hierarchy**: CLI args > env vars > config file > defaults
- **Validation**: Fail early with clear messages
- **Documentation**: Document all config options

### Testing

- **Test in Isolation**: Use Typer's CliRunner for isolated testing
- **Reset State**: Always reset global state between tests
- **Test Errors**: Verify error handling and messages
- **Test Edge Cases**: Boundary conditions, missing inputs, invalid data
- **Integration Tests**: Test command combinations and workflows

### Documentation

- **Help Text**: Comprehensive help for all commands with Rich markup
- **Examples**: Include usage examples in docstrings
- **README**: Quick start guide in project README
- **How-Tos**: Detailed guides for common tasks

## Performance Considerations

### Startup Time

- **Lazy Imports**: Import modules when needed, not at startup
- **Command Groups**: Delay loading subcommands until invoked
- **Dependencies**: Minimize number of dependencies

### Large Outputs

- **Streaming**: Stream large outputs instead of loading into memory
- **Pagination**: Paginate long output
- **Progress Bars**: Show progress with Rich's `track()` for long operations

### Concurrent Operations

- **Async Commands**: Use asyncio for I/O-bound operations
- **Parallel Processing**: Use multiprocessing for CPU-bound operations
- **Thread Safety**: Ensure shared resources are thread-safe

## Security Considerations

### Input Validation

- **Sanitize Input**: Validate and sanitize all user input
- **Path Traversal**: Prevent directory traversal attacks
- **Command Injection**: Avoid shell=True in subprocess calls
- **SQL Injection**: Use parameterized queries

### Configuration Security

- **Secrets Management**: Don't store secrets in config files
- **Environment Variables**: Use env vars for sensitive data
- **Permissions**: Restrict config file permissions (0600)
- **Encryption**: Encrypt sensitive configuration values

### Dependency Security

- **Regular Updates**: Keep dependencies up to date
- **Security Scanning**: Use pip-audit or safety
- **Minimal Dependencies**: Only include necessary dependencies
- **Pinned Versions**: Lock dependency versions

## Deployment Strategies

### PyPI Package

Distribute via Python Package Index:

```bash
# Build package
python -m build

# Upload to PyPI
python -m twine upload dist/*

# Users install with
pip install your-cli-tool
```

### Docker Image

Distribute as container:

```bash
# Build image
docker build -t your-cli-tool:latest .

# Push to registry
docker push your-cli-tool:latest

# Users run with
docker run your-cli-tool:latest command
```

### Standalone Binary

Package as executable (future):

```bash
# Using PyInstaller
pyinstaller --onefile src/cli.py

# Distribute binary
./dist/cli
```

## Monitoring and Observability

### Logging

- **Structured Logs**: Use structured logging for parsing
- **Log Levels**: Appropriate levels for different messages
- **Log Aggregation**: Send logs to centralized system
- **Log Rotation**: Rotate log files to prevent disk fill

### Metrics

- **Command Usage**: Track which commands are used
- **Execution Time**: Measure command performance
- **Error Rates**: Monitor error frequency
- **User Analytics**: Understand usage patterns (with consent)

### Debugging

- **Verbose Mode**: Enable detailed logging with --verbose
- **Debug Mode**: Include debug symbols in development
- **Stack Traces**: Full traces in verbose mode
- **Profiling**: Profile performance bottlenecks

## Migration and Upgrades

### Configuration Migration

Handle config schema changes:

```python
def migrate_config(old_config: dict) -> dict:
    """Migrate old config format to new."""
    if 'old_field' in old_config:
        old_config['new_field'] = old_config.pop('old_field')
    return old_config
```

### Backward Compatibility

- **Deprecation Warnings**: Warn before removing features
- **Version Detection**: Detect old config/data formats
- **Automatic Migration**: Migrate automatically when possible
- **Manual Migration**: Provide migration guide for breaking changes

## References

- **Typer Documentation**: https://typer.tiangolo.com/
- **Rich Documentation**: https://rich.readthedocs.io/
- **pytest Documentation**: https://docs.pytest.org/
- **Python Packaging**: https://packaging.python.org/
- **Docker Best Practices**: https://docs.docker.com/develop/dev-best-practices/

## Related Documentation

- `.ai/howtos/python-cli/how-to-add-cli-command.md`
- `.ai/howtos/python-cli/how-to-handle-config-files.md`
- `.ai/howtos/python-cli/how-to-package-cli-tool.md`
- `plugins/languages/python/` - Python plugin documentation
