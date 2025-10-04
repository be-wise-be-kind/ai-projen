# CLI Quality Standards

**Purpose**: Quality standards and best practices for Python CLI applications

**Scope**: Exit codes, error handling, help text, user experience, and testing patterns

**Overview**: Comprehensive quality standards for building professional Python CLI tools.
    Covers conventions for exit codes, error messages, help text formatting, configuration
    handling, and user experience patterns. Ensures CLI tools are intuitive, reliable, and
    follow industry best practices.

**Prerequisites**: Python CLI application built with Click framework

**Dependencies**: Click 8.x, pytest, click.testing.CliRunner

**Related**: python-cli-architecture.md, how-to-add-cli-command.md

---

## Exit Code Conventions

### Standard Exit Codes

```python
# Success
EXIT_SUCCESS = 0

# General errors
EXIT_ERROR = 1

# Usage errors (invalid arguments, missing required options)
EXIT_USAGE_ERROR = 2

# Configuration errors
EXIT_CONFIG_ERROR = 3

# Permission errors
EXIT_PERMISSION_ERROR = 4

# Not found errors (file, resource, etc.)
EXIT_NOT_FOUND = 5

# Timeout errors
EXIT_TIMEOUT = 6

# Interrupted (Ctrl+C)
EXIT_INTERRUPTED = 130
```

### Implementation

```python
import sys
import click

@click.command()
def my_command():
    try:
        # Your logic
        click.echo("Success!")
        sys.exit(0)  # EXIT_SUCCESS
    except FileNotFoundError:
        click.echo("Error: File not found", err=True)
        sys.exit(5)  # EXIT_NOT_FOUND
    except PermissionError:
        click.echo("Error: Permission denied", err=True)
        sys.exit(4)  # EXIT_PERMISSION_ERROR
    except KeyboardInterrupt:
        click.echo("\\nInterrupted", err=True)
        sys.exit(130)  # EXIT_INTERRUPTED
    except Exception as e:
        click.echo(f"Error: {e}", err=True)
        sys.exit(1)  # EXIT_ERROR
```

## Error Handling

### Principles

1. **User-Friendly Messages**: Explain what went wrong and how to fix it
2. **Error Output to stderr**: Use `click.echo(..., err=True)`
3. **Appropriate Exit Codes**: Use standard exit codes
4. **Stack Traces for Debug**: Only show stack traces with `--debug` flag

### Pattern

```python
@click.command()
@click.option('--debug', is_flag=True, help='Enable debug mode')
def my_command(debug: bool):
    try:
        # Your logic
        risky_operation()
    except SpecificError as e:
        click.echo(f"Error: {e}", err=True)
        if debug:
            import traceback
            traceback.print_exc()
        sys.exit(1)
```

## Help Text Standards

### Command Help

```python
@click.command(help="Process data files and generate reports.")
@click.option(
    '--input', '-i',
    required=True,
    type=click.Path(exists=True),
    help='Path to input file (JSON or YAML)'
)
@click.option(
    '--output', '-o',
    type=click.Path(),
    help='Output file path (default: stdout)'
)
@click.option(
    '--format',
    type=click.Choice(['json', 'yaml', 'csv']),
    default='json',
    show_default=True,
    help='Output format'
)
def process(input, output, format):
    """Process data and generate formatted report."""
    pass
```

### Help Text Guidelines

- **Command help**: One-line summary (imperative mood)
- **Docstring**: Longer description if needed
- **Option help**: Clear, concise description
- **Show defaults**: Use `show_default=True` for clarity
- **Choices**: Document available options with `click.Choice`
- **Path validation**: Use `click.Path(exists=True)` for files that must exist

## Configuration Handling

### Best Practices

1. **Hierarchy**: CLI args > Environment vars > Config file > Defaults
2. **Multiple formats**: Support both YAML and JSON
3. **Validation**: Validate config on load
4. **Error messages**: Clear messages for invalid config

### Pattern

```python
import os
from pathlib import Path
from src.config import load_config, ConfigError

@click.command()
@click.option(
    '--config',
    type=click.Path(exists=True),
    default=None,
    help='Config file path (YAML or JSON)'
)
@click.option(
    '--api-key',
    envvar='API_KEY',
    help='API key (can also use API_KEY env var)'
)
def my_command(config, api_key):
    try:
        # Load config with hierarchy
        cfg = load_config(config) if config else {}

        # CLI arg > env var > config > default
        final_api_key = api_key or cfg.get('api_key') or 'default-key'

    except ConfigError as e:
        click.echo(f"Config error: {e}", err=True)
        sys.exit(3)  # EXIT_CONFIG_ERROR
```

## User Experience

### Progress Indication

```python
import click

@click.command()
def long_task():
    items = range(100)

    with click.progressbar(
        items,
        label='Processing files',
        show_pos=True
    ) as bar:
        for item in bar:
            process_item(item)
```

### Confirmation Prompts

```python
@click.command()
@click.option('--force', is_flag=True, help='Skip confirmation')
def delete(force):
    if not force:
        click.confirm('Are you sure you want to delete?', abort=True)

    # Proceed with deletion
```

### Colored Output

```python
@click.command()
def status():
    click.secho('✅ Success', fg='green')
    click.secho('⚠️  Warning', fg='yellow')
    click.secho('❌ Error', fg='red', err=True)
```

### Verbosity Levels

```python
@click.command()
@click.option('-v', '--verbose', count=True, help='Increase verbosity')
def my_command(verbose):
    # verbose = 0 (quiet), 1 (normal), 2+ (debug)

    if verbose >= 1:
        click.echo("Processing...")

    if verbose >= 2:
        click.echo(f"Debug: detailed info...")
```

## Testing Standards

### CLI Testing with Click

```python
from click.testing import CliRunner
from src.cli import cli

def test_help_displays():
    runner = CliRunner()
    result = runner.invoke(cli, ['--help'])

    assert result.exit_code == 0
    assert 'Usage:' in result.output

def test_command_success():
    runner = CliRunner()
    result = runner.invoke(cli, ['process', '--input', 'test.json'])

    assert result.exit_code == 0
    assert 'Success' in result.output

def test_missing_required_arg():
    runner = CliRunner()
    result = runner.invoke(cli, ['process'])  # missing --input

    assert result.exit_code == 2  # EXIT_USAGE_ERROR
    assert 'Error: Missing option' in result.output

def test_file_not_found():
    runner = CliRunner()
    result = runner.invoke(cli, ['process', '--input', 'missing.json'])

    assert result.exit_code == 5  # EXIT_NOT_FOUND
```

### Testing with Temporary Files

```python
from click.testing import CliRunner
import tempfile
import os

def test_with_temp_file():
    runner = CliRunner()

    with runner.isolated_filesystem():
        # Creates temporary directory
        with open('input.json', 'w') as f:
            f.write('{"key": "value"}')

        result = runner.invoke(cli, ['process', '--input', 'input.json'])

        assert result.exit_code == 0
        assert os.path.exists('output.json')
```

## Logging Standards

### Setup

```python
import logging
import click

def setup_logging(verbose: int):
    level = logging.WARNING
    if verbose == 1:
        level = logging.INFO
    elif verbose >= 2:
        level = logging.DEBUG

    logging.basicConfig(
        level=level,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )

@click.command()
@click.option('-v', '--verbose', count=True)
def main(verbose):
    setup_logging(verbose)
    logger = logging.getLogger(__name__)

    logger.debug("Debug message")
    logger.info("Info message")
    logger.warning("Warning message")
```

## Performance

### Lazy Loading

```python
import click

@click.group()
def cli():
    pass

@cli.command()
def heavy_command():
    # Import heavy dependencies only when needed
    from heavy_library import process
    process()
```

### Streaming Large Files

```python
@click.command()
@click.argument('input', type=click.File('r'))
@click.argument('output', type=click.File('w'))
def transform(input, output):
    # Stream line by line (don't load entire file)
    for line in input:
        output.write(transform_line(line))
```

## Security

### Input Validation

```python
import click
import re

def validate_email(ctx, param, value):
    if not re.match(r'^[\w.-]+@[\w.-]+\.\w+$', value):
        raise click.BadParameter('Invalid email format')
    return value

@click.command()
@click.option('--email', callback=validate_email)
def send(email):
    # email is validated
    pass
```

### Path Traversal Prevention

```python
from pathlib import Path
import click

@click.command()
@click.argument('file', type=click.Path())
def read_file(file):
    # Resolve to absolute path and check containment
    base = Path.cwd()
    file_path = (base / file).resolve()

    if not file_path.is_relative_to(base):
        click.echo("Error: Path traversal not allowed", err=True)
        sys.exit(4)
```

## References

- Click Documentation: https://click.palletsprojects.com/
- GNU Exit Codes: https://www.gnu.org/software/libc/manual/html_node/Exit-Status.html
- CLI Guidelines: https://clig.dev/
