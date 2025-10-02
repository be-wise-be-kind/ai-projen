# How to Create a CLI Command

**Purpose**: Step-by-step guide for creating command-line interface commands using Click or Typer frameworks with Docker-first development

**Scope**: CLI application development, command creation, argument/option handling, Docker-based CLI execution

**Overview**: Comprehensive guide for building command-line tools with modern Python CLI frameworks. Covers framework selection (Click vs Typer), command structure, argument parsing, option handling, and Docker-first execution patterns that ensure consistent behavior across development environments.

**Dependencies**: Click or Typer framework, Python type hints, Docker, basic CLI design knowledge

**Exports**: CLI command creation workflow, framework comparison, Docker execution patterns

**Related**: Python packaging, CLI design patterns, Docker development, testing CLI applications

**Implementation**: Click/Typer command patterns, argument validation, Docker-based CLI tools, help text generation

---

This guide provides step-by-step instructions for creating command-line interface (CLI) commands using Click or Typer frameworks with Docker-first development.

## Prerequisites

- Python plugin installed in your project
- Docker installed and running
- Basic understanding of command-line interfaces
- Python type hints knowledge (especially for Typer)

## Docker-First Development Pattern

This guide follows the Docker-first approach. All CLI tools should be developed and tested in containers first.

**Environment Priority**:
1. Docker containers (recommended)
2. Poetry virtual environment (fallback)
3. Direct local execution (last resort)

## Framework Selection: Click vs Typer

Both Click and Typer are excellent CLI frameworks. Choose based on your needs:

### Click
**Best for:**
- Complex CLI applications with multiple subcommands
- Maximum flexibility and control
- Established projects already using Click
- Python 3.7+ compatibility

**Pros:**
- Battle-tested and mature
- Extensive ecosystem and plugins
- Fine-grained control over parsing

**Cons:**
- More verbose code
- Manual type handling

### Typer
**Best for:**
- Modern Python projects (3.7+)
- Type-hint-first development
- Rapid CLI development
- Projects wanting automatic help generation

**Pros:**
- Minimal boilerplate
- Automatic type validation from hints
- Beautiful help text generation
- Built on Click (compatible ecosystem)

**Cons:**
- Newer (less ecosystem maturity)
- Requires type hints

**Recommendation**: Use Typer for new projects, Click for established codebases or maximum control.

## Steps to Create a CLI Command

### 1. Install Framework

**Docker approach** - Add to your `pyproject.toml`:
```toml
[tool.poetry.dependencies]
click = "^8.1.0"  # For Click
# OR
typer = {extras = ["all"], version = "^0.9.0"}  # For Typer with rich output
```

Then rebuild:
```bash
make python-install  # Rebuilds Docker image with new dependencies
```

**Poetry fallback**:
```bash
poetry add click
# OR
poetry add "typer[all]"
```

### 2. Create CLI Module Structure

Organize your CLI code:

```bash
# Create CLI module directory
mkdir -p backend/cli

# Create main CLI entry point
touch backend/cli/__init__.py
touch backend/cli/main.py

# Create command modules
touch backend/cli/commands/__init__.py
touch backend/cli/commands/data.py
touch backend/cli/commands/admin.py
```

### 3. Create Your First Command (Click)

**Using the template**:
```bash
cp plugins/languages/python/templates/click-command.py.template backend/cli/commands/hello.py
```

**Manual creation**:
```python
# backend/cli/commands/hello.py
"""Hello command for CLI."""

import click
from typing import Optional


@click.command()
@click.option(
    '--name',
    '-n',
    default='World',
    help='Name to greet',
    show_default=True
)
@click.option(
    '--count',
    '-c',
    default=1,
    type=int,
    help='Number of times to greet',
    show_default=True
)
@click.option(
    '--upper',
    is_flag=True,
    help='Convert output to uppercase'
)
def hello(name: str, count: int, upper: bool) -> None:
    """Greet someone with a friendly hello message.

    Examples:
        cli hello --name Alice
        cli hello --name Bob --count 3
        cli hello --name Charlie --upper
    """
    greeting = f"Hello, {name}!"

    if upper:
        greeting = greeting.upper()

    for _ in range(count):
        click.echo(greeting)


if __name__ == '__main__':
    hello()
```

### 4. Create Your First Command (Typer)

**Using the template**:
```bash
cp plugins/languages/python/templates/typer-command.py.template backend/cli/commands/hello.py
```

**Manual creation**:
```python
# backend/cli/commands/hello.py
"""Hello command for CLI."""

import typer
from typing import Annotated


app = typer.Typer(help="Hello command group")


@app.command()
def greet(
    name: Annotated[str, typer.Option("--name", "-n", help="Name to greet")] = "World",
    count: Annotated[int, typer.Option("--count", "-c", help="Number of times to greet")] = 1,
    upper: Annotated[bool, typer.Option("--upper", help="Convert output to uppercase")] = False,
) -> None:
    """Greet someone with a friendly hello message.

    Examples:
        cli greet --name Alice
        cli greet --name Bob --count 3
        cli greet --name Charlie --upper
    """
    greeting = f"Hello, {name}!"

    if upper:
        greeting = greeting.upper()

    for _ in range(count):
        typer.echo(greeting)


if __name__ == '__main__':
    app()
```

### 5. Create Main CLI Entry Point

**Click version**:
```python
# backend/cli/main.py
"""Main CLI entry point."""

import click
from backend.cli.commands import hello


@click.group()
@click.version_option(version='1.0.0')
def cli() -> None:
    """My Application CLI.

    Comprehensive command-line interface for application management.
    """
    pass


# Register commands
cli.add_command(hello.hello)


if __name__ == '__main__':
    cli()
```

**Typer version**:
```python
# backend/cli/main.py
"""Main CLI entry point."""

import typer
from backend.cli.commands import hello


app = typer.Typer(
    name="mycli",
    help="My Application CLI - Comprehensive command-line interface for application management",
    add_completion=True,
)


# Register command groups
app.add_typer(hello.app, name="hello")


def version_callback(value: bool) -> None:
    """Show version and exit."""
    if value:
        typer.echo("My CLI Version 1.0.0")
        raise typer.Exit()


@app.callback()
def main(
    version: bool = typer.Option(
        False,
        "--version",
        "-v",
        callback=version_callback,
        is_eager=True,
        help="Show version and exit",
    )
) -> None:
    """Main callback for global options."""
    pass


if __name__ == '__main__':
    app()
```

### 6. Configure CLI as Script

Add to `pyproject.toml`:

```toml
[tool.poetry.scripts]
mycli = "backend.cli.main:cli"  # For Click
# OR
mycli = "backend.cli.main:app"  # For Typer

# You can add multiple commands
myapp-admin = "backend.cli.admin:admin_cli"
myapp-data = "backend.cli.data:data_cli"
```

### 7. Install and Test in Docker

**Build with new CLI**:
```bash
# Rebuild Docker image with CLI script
make python-install
```

**Test in Docker container**:
```bash
# Start container
make dev-python

# Execute CLI in container
docker exec -it python-backend-container mycli --help
docker exec -it python-backend-container mycli hello --name Docker
docker exec -it python-backend-container mycli hello --name Alice --count 3 --upper

# Interactive shell in container
docker exec -it python-backend-container bash
# Then run commands directly:
mycli --help
mycli hello --name Interactive
```

**Poetry fallback**:
```bash
# Install in development mode
poetry install

# Run CLI
poetry run mycli --help
poetry run mycli hello --name Poetry
```

### 8. Advanced Command Patterns

**Click - Multiple arguments and validation**:
```python
import click
from pathlib import Path


@click.command()
@click.argument('input_file', type=click.Path(exists=True, path_type=Path))
@click.argument('output_file', type=click.Path(path_type=Path))
@click.option('--format', type=click.Choice(['json', 'yaml', 'csv']), default='json')
@click.option('--verbose', '-v', count=True, help='Increase verbosity (-vvv for max)')
def convert(
    input_file: Path,
    output_file: Path,
    format: str,
    verbose: int
) -> None:
    """Convert INPUT_FILE to OUTPUT_FILE in specified format.

    Args:
        input_file: Source file to convert
        output_file: Destination file path
        format: Output format (json, yaml, or csv)
        verbose: Verbosity level (0-3)
    """
    verbosity_level = "DEBUG" if verbose >= 2 else "INFO" if verbose == 1 else "WARNING"
    click.echo(f"Converting {input_file} -> {output_file} (format={format}, level={verbosity_level})")
    # Implementation here
```

**Typer - Rich output and progress**:
```python
import typer
from rich.progress import track
from rich.console import Console
from pathlib import Path
from typing import Annotated
import time

console = Console()


@app.command()
def process(
    input_dir: Annotated[Path, typer.Argument(help="Input directory", exists=True, file_okay=False)],
    pattern: Annotated[str, typer.Option("--pattern", "-p", help="File pattern to match")] = "*.txt",
    dry_run: Annotated[bool, typer.Option("--dry-run", help="Show what would be done")] = False,
) -> None:
    """Process files in INPUT_DIR matching pattern.

    Demonstrates rich output with progress bars and colored text.
    """
    files = list(input_dir.glob(pattern))

    if not files:
        console.print(f"[yellow]No files found matching {pattern}[/yellow]")
        return

    console.print(f"[green]Found {len(files)} files[/green]")

    if dry_run:
        console.print("[yellow]DRY RUN - No changes will be made[/yellow]")

    for file in track(files, description="Processing..."):
        if not dry_run:
            # Process file
            time.sleep(0.1)  # Simulate work
        console.print(f"  Processed: {file.name}")

    console.print("[bold green]✓ Complete![/bold green]")
```

### 9. Error Handling

**Click**:
```python
import click
import sys


@click.command()
@click.argument('config_file', type=click.Path(exists=True))
def validate(config_file: str) -> None:
    """Validate configuration file."""
    try:
        # Validation logic
        with open(config_file) as f:
            config = json.load(f)

        click.secho("✓ Configuration valid", fg='green')

    except json.JSONDecodeError as e:
        click.secho(f"✗ Invalid JSON: {e}", fg='red', err=True)
        sys.exit(1)
    except Exception as e:
        click.secho(f"✗ Error: {e}", fg='red', err=True)
        sys.exit(1)
```

**Typer**:
```python
import typer
from rich.console import Console

console = Console()


@app.command()
def validate(config_file: Path) -> None:
    """Validate configuration file."""
    try:
        # Validation logic
        if not config_file.exists():
            console.print(f"[red]✗ File not found: {config_file}[/red]")
            raise typer.Exit(code=1)

        with config_file.open() as f:
            config = json.load(f)

        console.print("[green]✓ Configuration valid[/green]")

    except json.JSONDecodeError as e:
        console.print(f"[red]✗ Invalid JSON: {e}[/red]")
        raise typer.Exit(code=1)
    except Exception as e:
        console.print(f"[red]✗ Error: {e}[/red]")
        raise typer.Exit(code=1)
```

## Templates Reference

This guide references the following templates:

- `plugins/languages/python/templates/click-command.py.template` - Click command pattern
- `plugins/languages/python/templates/typer-command.py.template` - Typer command pattern
- `plugins/languages/python/templates/cli-main.py.template` - CLI entry point

## Verification Steps

### 1. Test Help Text

**In Docker**:
```bash
docker exec -it python-backend-container mycli --help
docker exec -it python-backend-container mycli hello --help
```

**Poetry fallback**:
```bash
poetry run mycli --help
poetry run mycli hello --help
```

### 2. Test Command Functionality

**In Docker**:
```bash
# Test basic command
docker exec -it python-backend-container mycli hello --name TestUser

# Test with options
docker exec -it python-backend-container mycli hello --name Alice --count 3

# Test flags
docker exec -it python-backend-container mycli hello --name Bob --upper

# Test with files (if command uses files)
docker exec -it python-backend-container mycli process /app/data --pattern "*.json"
```

### 3. Test Error Handling

```bash
# Test invalid input
docker exec -it python-backend-container mycli hello --count invalid

# Test missing required arguments
docker exec -it python-backend-container mycli convert

# Test file not found
docker exec -it python-backend-container mycli process /nonexistent
```

### 4. Integration Testing

Create automated tests for your CLI:

```python
# tests/test_cli.py
from click.testing import CliRunner
from backend.cli.main import cli


def test_hello_command():
    """Test hello command."""
    runner = CliRunner()
    result = runner.invoke(cli, ['hello', '--name', 'Test'])

    assert result.exit_code == 0
    assert 'Hello, Test!' in result.output


def test_hello_with_count():
    """Test hello command with count."""
    runner = CliRunner()
    result = runner.invoke(cli, ['hello', '--name', 'Test', '--count', '3'])

    assert result.exit_code == 0
    assert result.output.count('Hello, Test!') == 3


def test_hello_uppercase():
    """Test hello command with uppercase."""
    runner = CliRunner()
    result = runner.invoke(cli, ['hello', '--name', 'test', '--upper'])

    assert result.exit_code == 0
    assert 'HELLO, TEST!' in result.output
```

Run tests in Docker:
```bash
make test-python
```

## Best Practices

### 1. Comprehensive Help Text

Always provide detailed help text:

**Click**:
```python
@click.command()
@click.option('--verbose', '-v', is_flag=True, help='Enable verbose output')
def command(verbose: bool) -> None:
    """Short description of what the command does.

    Long description providing more details about the command's
    purpose, behavior, and any important notes.

    Examples:
        mycli command --verbose
        mycli command --config /path/to/config.yml
    """
    pass
```

**Typer**:
```python
@app.command()
def command(
    verbose: Annotated[bool, typer.Option("--verbose", "-v", help="Enable verbose output")] = False
) -> None:
    """Short description of what the command does.

    Long description providing more details about the command's
    purpose, behavior, and any important notes.

    Examples:
        mycli command --verbose
        mycli command --config /path/to/config.yml
    """
    pass
```

### 2. Use Type Hints

Always use type hints (especially with Typer):

```python
from typing import Annotated, Optional
from pathlib import Path


@app.command()
def process(
    input_file: Annotated[Path, typer.Argument(help="Input file path")],
    output_dir: Annotated[Optional[Path], typer.Option(help="Output directory")] = None,
    workers: Annotated[int, typer.Option(help="Number of workers")] = 4,
) -> None:
    """Type hints provide automatic validation."""
    pass
```

### 3. Validation and Error Messages

Provide clear error messages:

```python
@app.command()
def process(count: int) -> None:
    """Process with validation."""
    if count <= 0:
        console.print("[red]Error: count must be positive[/red]")
        raise typer.Exit(code=1)

    if count > 1000:
        console.print("[yellow]Warning: large count may take time[/yellow]")

    # Process
```

### 4. Configuration Files

Support configuration files for complex options:

```python
import click
import yaml


@click.command()
@click.option('--config', type=click.Path(exists=True), help='Configuration file')
@click.pass_context
def command(ctx: click.Context, config: Optional[str]) -> None:
    """Command with config file support."""
    if config:
        with open(config) as f:
            config_data = yaml.safe_load(f)
            # Override defaults with config file values
            ctx.default_map = config_data
```

### 5. Logging

Integrate proper logging:

```python
import logging
from loguru import logger


@app.command()
def process(
    verbose: Annotated[bool, typer.Option("--verbose", "-v")] = False
) -> None:
    """Command with logging."""
    # Configure logging level
    level = "DEBUG" if verbose else "INFO"
    logger.remove()
    logger.add(sys.stderr, level=level)

    logger.info("Starting process")
    logger.debug("Debug information")
    # Process
```

## Common Issues and Solutions

### Command Not Found in Docker

**Issue**: `mycli: command not found` in container

**Solutions**:
1. Verify script is in `pyproject.toml`:
   ```toml
   [tool.poetry.scripts]
   mycli = "backend.cli.main:cli"
   ```
2. Rebuild Docker image:
   ```bash
   make python-install
   ```
3. Check installation in container:
   ```bash
   docker exec -it python-backend-container which mycli
   docker exec -it python-backend-container pip show yourpackage
   ```

### Import Errors

**Issue**: `ModuleNotFoundError` when running CLI

**Solutions**:
1. Ensure package is installed in editable mode
2. Check PYTHONPATH in container
3. Verify module structure:
   ```bash
   docker exec -it python-backend-container python -c "import backend.cli.main"
   ```
4. Add `__init__.py` files to all directories

### Type Validation Failures (Typer)

**Issue**: Type validation errors with Typer

**Solutions**:
1. Use proper type hints with `Annotated`
2. Import from `typing` for compatibility
3. Use Typer's type validators:
   ```python
   from typer import Option
   count: int = Option(..., min=1, max=100)
   ```

### Path Handling in Docker

**Issue**: File paths work locally but not in Docker

**Solutions**:
1. Use absolute paths in container
2. Map volumes in docker-compose.yml:
   ```yaml
   volumes:
     - ./data:/app/data
   ```
3. Access files via mapped paths:
   ```bash
   docker exec -it container mycli process /app/data/input.txt
   ```

## Example: Complete CLI Application

Here's a complete example combining all best practices:

```python
# backend/cli/main.py
"""Application CLI with multiple commands."""

import typer
from rich.console import Console
from rich.table import Table
from pathlib import Path
from typing import Annotated, Optional
import sys

console = Console()
app = typer.Typer(
    name="myapp",
    help="MyApp CLI - Application management tools",
    add_completion=True,
)


@app.command()
def init(
    directory: Annotated[Path, typer.Argument(help="Project directory")] = Path("."),
    template: Annotated[str, typer.Option("--template", "-t", help="Template to use")] = "default",
    force: Annotated[bool, typer.Option("--force", "-f", help="Overwrite existing files")] = False,
) -> None:
    """Initialize a new project.

    Creates project structure with specified template.

    Examples:
        myapp init ./my-project
        myapp init ./my-project --template advanced --force
    """
    if directory.exists() and not force:
        console.print(f"[red]Directory {directory} already exists. Use --force to overwrite.[/red]")
        raise typer.Exit(code=1)

    console.print(f"[green]Initializing project in {directory} with template '{template}'[/green]")
    # Implementation
    console.print("[bold green]✓ Project initialized successfully![/bold green]")


@app.command()
def status(
    verbose: Annotated[bool, typer.Option("--verbose", "-v", help="Show detailed status")] = False,
) -> None:
    """Show application status.

    Displays current configuration and system status.
    """
    table = Table(title="Application Status")
    table.add_column("Component", style="cyan")
    table.add_column("Status", style="magenta")
    table.add_column("Details", style="green")

    # Add rows
    table.add_row("Database", "✓ Connected", "PostgreSQL 15.2")
    table.add_row("Cache", "✓ Active", "Redis 7.0")
    table.add_row("API", "✓ Running", "Port 8000")

    console.print(table)

    if verbose:
        console.print("\n[cyan]Additional Details:[/cyan]")
        console.print("  Version: 1.0.0")
        console.print("  Environment: development")


@app.command()
def migrate(
    direction: Annotated[str, typer.Argument(help="Migration direction: up or down")] = "up",
    steps: Annotated[int, typer.Option("--steps", "-n", help="Number of migrations")] = 1,
    dry_run: Annotated[bool, typer.Option("--dry-run", help="Show what would be done")] = False,
) -> None:
    """Run database migrations.

    Args:
        direction: Migration direction (up or down)
        steps: Number of migration steps
        dry_run: Preview changes without applying

    Examples:
        myapp migrate up
        myapp migrate down --steps 2
        myapp migrate up --dry-run
    """
    if direction not in ["up", "down"]:
        console.print("[red]Direction must be 'up' or 'down'[/red]")
        raise typer.Exit(code=1)

    mode = "DRY RUN" if dry_run else "LIVE"
    console.print(f"[yellow]Running {steps} migration(s) {direction} [{mode}][/yellow]")

    # Implementation
    console.print(f"[green]✓ Completed {steps} migration(s)[/green]")


def version_callback(value: bool) -> None:
    """Show version and exit."""
    if value:
        console.print("MyApp CLI Version 1.0.0")
        raise typer.Exit()


@app.callback()
def main(
    version: bool = typer.Option(
        False,
        "--version",
        "-v",
        callback=version_callback,
        is_eager=True,
        help="Show version and exit",
    ),
    config: Optional[Path] = typer.Option(
        None,
        "--config",
        "-c",
        help="Configuration file path",
        exists=True,
    ),
) -> None:
    """MyApp CLI - Application management tools.

    Comprehensive command-line interface for managing your application.
    """
    if config:
        console.print(f"[dim]Using config: {config}[/dim]")


if __name__ == '__main__':
    app()
```

## Checklist

Before considering your CLI complete:

- [ ] Framework chosen (Click or Typer)
- [ ] Dependencies added to pyproject.toml
- [ ] CLI module structure created
- [ ] Commands implemented with type hints
- [ ] Comprehensive help text provided
- [ ] Script entry point configured
- [ ] Docker image rebuilt: `make python-install`
- [ ] Help text verified: `docker exec ... mycli --help`
- [ ] Commands tested in Docker
- [ ] Error handling implemented
- [ ] Automated tests written
- [ ] Tests pass: `make test-python`

## Related Documentation

- [How to Write a Test](how-to-write-a-test.md) - Test your CLI commands
- [Click Documentation](https://click.palletsprojects.com/)
- [Typer Documentation](https://typer.tiangolo.com/)
- [Rich Documentation](https://rich.readthedocs.io/) - For beautiful CLI output

## Related Templates

- `plugins/languages/python/templates/click-command.py.template` - Click command template
- `plugins/languages/python/templates/typer-command.py.template` - Typer command template
- `plugins/languages/python/templates/cli-main.py.template` - CLI entry point template

---

**Difficulty**: Intermediate
**Estimated Time**: 45-60 minutes
**Last Updated**: 2025-10-01
