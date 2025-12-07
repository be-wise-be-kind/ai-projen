# How to Add CLI Commands

**Purpose**: Step-by-step guide for adding new commands to Python CLI applications using Typer framework

**Scope**: Command creation, options, arguments, groups, Rich output, and testing

**Overview**: This guide demonstrates how to add new commands to your CLI application using Typer with
    type hints and Rich integration. It covers simple commands, command groups, options and arguments,
    error handling, Rich-styled output, and testing. Examples show Typer best practices including
    Annotated types, automatic validation, and professional output for command-line interfaces.

**Prerequisites**: Python CLI application installed, basic Python knowledge, familiarity with type hints

**Related**: .ai/docs/python-cli-architecture.md, .ai/templates/python-cli/cli-entrypoint.py.template

---

## Overview

Adding commands to your CLI involves:
1. Defining command function with Typer decorators
2. Adding options and arguments with type hints
3. Implementing command logic
4. Adding Rich-styled output
5. Adding error handling
6. Writing tests
7. Updating documentation

## Simple Command

### Step 1: Add Basic Command

Edit `src/cli.py` and add a new command:

```python
from rich import print as rprint

@app.command()
def status():
    """Display application status."""
    rprint("[green]Application is running[/green]")
    rprint(f"[cyan]Version:[/cyan] 1.0.0")
```

### Step 2: Test the Command

```bash
# View help
python -m src.cli status --help

# Run command
python -m src.cli status
```

**Output**:
```
Application is running
Version: 1.0.0
```

## Command with Options

### Step 1: Add Options

Options are optional flags that modify command behavior. Use `Annotated` for clean type hints:

```python
from typing import Annotated

@app.command()
def greet(
    name: Annotated[str, typer.Option(
        "--name", "-n",
        help="Name to greet"
    )] = "World",
    uppercase: Annotated[bool, typer.Option(
        "--uppercase", "-u",
        help="Convert to uppercase"
    )] = False,
):
    """Greet someone with optional formatting."""
    greeting = f"Hello, {name}!"

    if uppercase:
        greeting = greeting.upper()

    rprint(f"[green]{greeting}[/green]")
```

### Step 2: Test with Options

```bash
# Default behavior
python -m src.cli greet
# Output: Hello, World!

# With name option
python -m src.cli greet --name Alice
# Output: Hello, Alice!

# With short form
python -m src.cli greet -n Bob
# Output: Hello, Bob!

# With uppercase flag
python -m src.cli greet --name Charlie --uppercase
# Output: HELLO, CHARLIE!

# Short form combined
python -m src.cli greet -n Dave -u
# Output: HELLO, DAVE!
```

## Command with Arguments

### Step 1: Add Required Arguments

Arguments are positional parameters (required by default):

```python
from pathlib import Path
from enum import Enum

class OutputFormat(str, Enum):
    json = "json"
    yaml = "yaml"
    text = "text"

@app.command()
def convert(
    input_file: Annotated[Path, typer.Argument(
        help="Path to input file",
        exists=True,
    )],
    output_file: Annotated[Path, typer.Argument(
        help="Path to output file",
    )],
    format: Annotated[OutputFormat, typer.Option(
        "--format", "-f",
        help="Output format"
    )] = OutputFormat.text,
):
    """Convert INPUT_FILE to OUTPUT_FILE in specified format."""
    rprint(f"[cyan]Converting {input_file} to {output_file}[/cyan]")
    rprint(f"[cyan]Output format: {format.value}[/cyan]")

    # Your conversion logic here
    with open(input_file, 'r') as infile:
        content = infile.read()

    # Process content based on format
    # ... conversion logic ...

    with open(output_file, 'w') as outfile:
        outfile.write(content)

    rprint("[green]✓ Conversion complete![/green]")
```

### Step 2: Test with Arguments

```bash
# Create test file
echo "test content" > input.txt

# Run conversion
python -m src.cli convert input.txt output.txt --format json

# Output:
# Converting input.txt to output.txt
# Output format: json
# ✓ Conversion complete!
```

## Command Groups

### Step 1: Create Command Group

Organize related commands into groups using `add_typer()`:

```python
# Create database command group
database_app = typer.Typer(help="Database management commands.")
app.add_typer(database_app, name="database")

@database_app.command("init")
def database_init(
    path: Annotated[Path, typer.Option(
        "--path",
        help="Database file path"
    )] = Path("./data.db"),
):
    """Initialize a new database."""
    rprint(f"[cyan]Initializing database at {path}[/cyan]")
    # Database initialization logic
    rprint("[green]✓ Database initialized successfully![/green]")

@database_app.command("backup")
def database_backup(
    destination: Annotated[Path, typer.Argument(
        help="Backup destination path"
    )],
):
    """Backup database to DESTINATION."""
    rprint(f"[cyan]Backing up database to {destination}[/cyan]")
    # Backup logic
    rprint("[green]✓ Backup complete![/green]")

@database_app.command("restore")
def database_restore(
    source: Annotated[Path, typer.Argument(
        help="Backup source path",
        exists=True,
    )],
):
    """Restore database from SOURCE."""
    rprint(f"[cyan]Restoring database from {source}[/cyan]")
    # Restore logic
    rprint("[green]✓ Restore complete![/green]")
```

### Step 2: Test Command Group

```bash
# View group help
python -m src.cli database --help

# Output:
# Usage: cli database [OPTIONS] COMMAND [ARGS]...
#
# Database management commands.
#
# Commands:
#   backup   Backup database to DESTINATION.
#   init     Initialize a new database.
#   restore  Restore database from SOURCE.

# Run subcommands
python -m src.cli database init
python -m src.cli database backup backup.db
python -m src.cli database restore backup.db
```

## Advanced Options

### Multiple Values

Accept multiple values for an option:

```python
@app.command()
def tag_file(
    filename: Annotated[str, typer.Argument(help="File to tag")],
    tag: Annotated[list[str], typer.Option(
        "--tag", "-t",
        help="Tags to add"
    )] = [],
):
    """Add tags to a file."""
    if tag:
        rprint(f"[cyan]Tagging {filename} with: {', '.join(tag)}[/cyan]")
    else:
        rprint(f"[yellow]No tags specified for {filename}[/yellow]")
```

**Usage**:
```bash
python -m src.cli tag-file document.txt -t important -t urgent -t review
# Output: Tagging document.txt with: important, urgent, review
```

### Prompts for Input

Prompt user for input if option not provided:

```python
@app.command()
def login(
    password: Annotated[str, typer.Option(
        "--password",
        prompt=True,
        hide_input=True,
        confirmation_prompt=True,
        help="Login password"
    )],
):
    """Login with password."""
    rprint("[green]✓ Login successful![/green]")
```

**Usage**:
```bash
python -m src.cli login
# Password:
# Repeat for confirmation:
# ✓ Login successful!
```

### Environment Variables

Read options from environment variables:

```python
@app.command()
def api_call(
    api_key: Annotated[str, typer.Option(
        "--api-key",
        envvar="API_KEY",
        help="API key (or set API_KEY env var)"
    )],
):
    """Make API call with key."""
    rprint(f"[cyan]Using API key: {api_key[:4]}...[/cyan]")
```

**Usage**:
```bash
export API_KEY="secret-key-12345"
python -m src.cli api-call
# Output: Using API key: secr...
```

## Using Application State

### Step 1: Set Up State Class

Share data between commands using a State class:

```python
from typing import Any

class State:
    """Application state shared across commands."""
    def __init__(self):
        self.config: dict[str, Any] = {}
        self.started_at: datetime = None
        self.verbose: bool = False

state = State()

@app.callback()
def main(
    config: Annotated[Optional[Path], typer.Option(
        "--config", "-c",
        help="Config file path"
    )] = None,
    verbose: Annotated[bool, typer.Option(
        "--verbose", "-v",
        help="Enable verbose output"
    )] = False,
):
    """Main application with shared config."""
    from datetime import datetime

    state.config = load_config(config) if config else {}
    state.started_at = datetime.now()
    state.verbose = verbose

@app.command()
def info():
    """Display application info."""
    rprint(f"[cyan]Config loaded from:[/cyan] {state.config.get('path', 'default')}")
    rprint(f"[cyan]Started at:[/cyan] {state.started_at}")
    if state.verbose:
        rprint("[cyan]Verbose mode:[/cyan] enabled")
```

### Step 2: Test State Passing

```bash
python -m src.cli --config myconfig.yaml --verbose info
```

## Rich Output Integration

### Colored Text

```python
from rich import print as rprint

@app.command()
def status():
    """Display colored status messages."""
    rprint("[green]✓ Success![/green]")
    rprint("[yellow]⚠ Warning: proceed with caution[/yellow]")
    rprint("[red]✗ Error occurred[/red]")
    rprint("[bold cyan]Important information[/bold cyan]")
```

### Tables

```python
from rich.console import Console
from rich.table import Table

console = Console()

@app.command()
def list_items():
    """Display items in a table."""
    table = Table(title="Items", show_header=True, header_style="bold cyan")
    table.add_column("ID", style="dim")
    table.add_column("Name", style="green")
    table.add_column("Status", style="yellow")

    table.add_row("1", "Item One", "Active")
    table.add_row("2", "Item Two", "Pending")
    table.add_row("3", "Item Three", "Complete")

    console.print(table)
```

### Progress Bars

```python
from rich.progress import track
import time

@app.command()
def process_items(
    count: Annotated[int, typer.Option(help="Number of items")] = 100,
):
    """Process multiple items with progress."""
    for item in track(range(count), description="Processing items..."):
        # Process item
        time.sleep(0.01)

    rprint("[green]✓ Processing complete![/green]")
```

### Panels

```python
from rich.panel import Panel

@app.command()
def show_message():
    """Display a message in a panel."""
    console.print(Panel(
        "[bold green]Operation completed successfully![/bold green]\n\n"
        "All files have been processed.",
        title="Success",
        border_style="green"
    ))
```

## Error Handling

### Step 1: Add Error Handling

Handle errors gracefully with informative messages:

```python
@app.command()
def process_file(
    filename: Annotated[Path, typer.Argument(
        help="File to process",
        exists=True,
    )],
):
    """Process a file."""
    try:
        with open(filename, 'r') as f:
            content = f.read()

        # Processing logic
        if not content.strip():
            rprint(f"[red]Error: File is empty[/red]")
            raise typer.Exit(code=1)

        # Process content
        result = process_content(content)

        rprint("[green]✓ File processed successfully![/green]")
        rprint(f"[cyan]Result: {result}[/cyan]")

    except PermissionError:
        rprint(f"[red]Permission denied: {filename}[/red]")
        raise typer.Exit(code=1)
    except UnicodeDecodeError:
        rprint(f"[red]Invalid file encoding: {filename}[/red]")
        raise typer.Exit(code=1)
    except Exception as e:
        rprint(f"[red]Processing failed: {str(e)}[/red]")
        raise typer.Exit(code=1)
```

### Custom Exit Codes

Use different exit codes for different errors:

```python
@app.command()
def validate():
    """Validate application state."""
    try:
        # Validation logic
        if not config_valid:
            rprint("[red]Configuration is invalid[/red]")
            raise typer.Exit(code=2)

        if not data_exists:
            rprint("[red]Required data not found[/red]")
            raise typer.Exit(code=3)

        rprint("[green]✓ Validation passed![/green]")

    except Exception as e:
        rprint(f"[red]Validation failed: {e}[/red]")
        raise typer.Exit(code=1)
```

## Testing Commands

### Step 1: Write Command Tests

Create tests in `tests/test_cli.py`:

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
    """Reset state before each test."""
    state.config = {}
    state.verbose = False
    yield
    state.config = {}
    state.verbose = False

def test_greet_default(runner):
    """Test greet command with default name."""
    result = runner.invoke(app, ['greet'])
    assert result.exit_code == 0
    assert 'Hello, World!' in result.output

def test_greet_with_name(runner):
    """Test greet command with custom name."""
    result = runner.invoke(app, ['greet', '--name', 'Alice'])
    assert result.exit_code == 0
    assert 'Hello, Alice!' in result.output

def test_greet_uppercase(runner):
    """Test greet command with uppercase flag."""
    result = runner.invoke(app, ['greet', '-n', 'Bob', '-u'])
    assert result.exit_code == 0
    assert 'HELLO, BOB!' in result.output

def test_convert_command(runner, tmp_path):
    """Test convert command with temp files."""
    # Create input file
    input_file = tmp_path / "input.txt"
    input_file.write_text("test content")

    output_file = tmp_path / "output.txt"

    # Run command
    result = runner.invoke(app, [
        'convert',
        str(input_file),
        str(output_file),
        '--format', 'json'
    ])

    assert result.exit_code == 0
    assert 'Conversion complete!' in result.output
    assert output_file.exists()

def test_database_init(runner, tmp_path):
    """Test database init command."""
    db_path = tmp_path / "test.db"

    result = runner.invoke(app, [
        'database', 'init',
        '--path', str(db_path)
    ])

    assert result.exit_code == 0
    assert 'initialized successfully' in result.output

def test_error_handling(runner):
    """Test command error handling."""
    result = runner.invoke(app, ['process-file', 'nonexistent.txt'])
    assert result.exit_code != 0
```

### Step 2: Run Tests

```bash
# Run all CLI tests
pytest tests/test_cli.py -v

# Run specific test
pytest tests/test_cli.py::test_greet_with_name -v

# Run with coverage
pytest tests/test_cli.py --cov=src.cli
```

## Command Documentation

### Step 1: Write Good Help Text

Provide comprehensive help for commands with Rich markup:

```python
@app.command()
def copy(
    source: Annotated[Path, typer.Argument(
        help="Source file path",
        exists=True,
    )],
    destination: Annotated[Path, typer.Argument(
        help="Destination file path",
    )],
    overwrite: Annotated[bool, typer.Option(
        "--overwrite",
        help="Overwrite destination if exists"
    )] = False,
    verbose: Annotated[bool, typer.Option(
        "--verbose", "-v",
        help="Show detailed progress"
    )] = False,
):
    """
    Copy SOURCE file to DESTINATION.

    This command copies a file from SOURCE to DESTINATION with optional
    overwrite protection. Use --verbose for detailed progress information.

    [bold]Examples:[/bold]

        [dim]# Simple copy[/dim]
        cli copy file.txt backup.txt

        [dim]# Copy with overwrite[/dim]
        cli copy file.txt backup.txt --overwrite

        [dim]# Copy with verbose output[/dim]
        cli copy file.txt backup.txt -v
    """
    if verbose:
        rprint(f"[cyan]Copying {source} to {destination}...[/cyan]")

    # Copy logic here

    if verbose:
        rprint("[green]✓ Copy complete![/green]")
```

### Step 2: View Help

```bash
python -m src.cli copy --help
```

## Best Practices

### 1. Command Naming

- Use lowercase with hyphens: `process-data` not `processData`
- Be descriptive but concise: `backup` not `b`
- Group related commands: `database init`, `database backup`

### 2. Options and Arguments

- Use `Annotated` for clean type hints
- Use short forms for common options: `-v` for `--verbose`
- Make arguments positional and required
- Make options optional with sensible defaults
- Use Enums for choices: `OutputFormat` instead of string choices
- Use `Path` type for file arguments with `exists=True` for validation

### 3. Help Text

- Write clear, concise descriptions
- Include usage examples with Rich markup
- Document all options and arguments
- Use `[bold]`, `[dim]`, `[cyan]` etc. for Rich styling

### 4. Error Handling

- Validate inputs early
- Provide informative error messages with color
- Use appropriate exit codes
- Don't expose stack traces to users (unless --debug)

### 5. Output

- Use Rich for styled output
- Green for success, red for errors, yellow for warnings
- Use tables for structured data
- Use progress bars for long operations

### 6. Testing

- Test all commands
- Reset state between tests
- Test with various option combinations
- Test error conditions
- Use fixtures for test data

## Common Patterns

### Confirmation Prompts

```python
@app.command()
def delete_all(
    yes: Annotated[bool, typer.Option(
        "--yes", "-y",
        help="Skip confirmation"
    )] = False,
):
    """Delete all data."""
    if not yes:
        confirm = typer.confirm("This will delete all data. Continue?")
        if not confirm:
            raise typer.Abort()

    rprint("[yellow]Deleting all data...[/yellow]")
    # Deletion logic
    rprint("[green]✓ All data deleted[/green]")
```

### Version Callback

```python
def version_callback(value: bool):
    """Show version and exit."""
    if value:
        rprint(f"[cyan]myapp[/cyan] version [green]1.0.0[/green]")
        raise typer.Exit()

@app.callback()
def main(
    version: Annotated[bool, typer.Option(
        "--version",
        callback=version_callback,
        is_eager=True,
        help="Show version and exit"
    )] = False,
):
    """My CLI application."""
    pass
```

### Enum Choices

```python
from enum import Enum

class LogLevel(str, Enum):
    debug = "debug"
    info = "info"
    warning = "warning"
    error = "error"

@app.command()
def set_log_level(
    level: Annotated[LogLevel, typer.Argument(help="Log level to set")],
):
    """Set the logging level."""
    rprint(f"[cyan]Log level set to: {level.value}[/cyan]")
```

## Troubleshooting

### Issue: Command not found
**Solution**: Ensure command is decorated with `@app.command()` or added to a group

### Issue: Options not working
**Solution**: Check that `Annotated` types are properly formatted

### Issue: State not shared between commands
**Solution**: Use module-level State class and reset in test fixtures

### Issue: Tests failing with state pollution
**Solution**: Add `autouse=True` fixture to reset state before each test

### Issue: Rich styling not appearing in tests
**Solution**: Rich colors are stripped in non-TTY environments; check for text content

## Next Steps

- **Configuration**: See `how-to-handle-config-files.md` for config management
- **Packaging**: See `how-to-package-cli-tool.md` for distribution
- **Architecture**: See `.ai/docs/python-cli-architecture.md` for design patterns

## References

- [Typer Documentation](https://typer.tiangolo.com/)
- [Typer Tutorial](https://typer.tiangolo.com/tutorial/)
- [Rich Documentation](https://rich.readthedocs.io/)
- [Rich Console](https://rich.readthedocs.io/en/latest/console.html)
- [Rich Tables](https://rich.readthedocs.io/en/latest/tables.html)
