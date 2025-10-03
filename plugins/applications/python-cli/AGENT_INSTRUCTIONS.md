# Python CLI Application - Agent Instructions

**Purpose**: Installation instructions for AI agents to set up Python CLI application with Click framework

**Scope**: Complete installation of Python CLI application with all dependencies and tooling

**Overview**: Step-by-step instructions for installing a complete Python CLI application with Click framework,
    Docker packaging, configuration management, and comprehensive testing. This meta-plugin orchestrates
    the installation of foundation, language, infrastructure, and standards plugins, then adds a production-ready
    CLI starter application with example commands, config handling, and distribution tools.

**Prerequisites**: Empty or existing repository with git initialized

---

## What This Application Provides

**Use Case**: Build professional command-line tools and utilities with modern Python practices

**Technology Stack**:
- Python 3.11+
- Click 8.x (CLI framework)
- pytest (testing)
- Ruff (linting and formatting)
- Docker (packaging and distribution)
- GitHub Actions (CI/CD)

**What Gets Installed**:
- Complete CLI starter application with Click commands
- YAML/JSON configuration file management
- Structured logging setup
- Comprehensive error handling patterns
- Docker containerization for distribution
- CI/CD pipeline for automated testing
- Security and documentation standards
- Pre-commit hooks for code quality

## Installation Steps

### Prerequisites Check

Before installation, verify:

```bash
# Check git repository exists
test -d .git && echo "✅ Git repository" || echo "❌ Run: git init"

# Check Python installed
python --version && echo "✅ Python" || echo "❌ Install Python 3.11+"

# Check pip installed
pip --version && echo "✅ pip" || echo "❌ Install pip"

# Check Docker running
docker ps > /dev/null 2>&1 && echo "✅ Docker running" || echo "❌ Start Docker"

# Check Docker Compose installed
docker-compose --version && echo "✅ Docker Compose" || echo "❌ Install Docker Compose"
```

### Phase 1: Foundation Setup

**1. Install foundation/ai-folder plugin**

Follow: `plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md`

Creates `.ai/` directory structure for AI navigation.

**Validation**:
```bash
test -d .ai && echo "✅ .ai folder created" || echo "❌ Foundation plugin failed"
```

### Phase 2: Language Plugin Installation

**2. Install languages/python plugin**

Follow: `plugins/languages/python/AGENT_INSTRUCTIONS.md`

Installs Python with linting, formatting, type checking, testing.

**Options**:
- Linter: ruff
- Formatter: ruff
- Testing: pytest
- Type checking: mypy

**Validation**:
```bash
test -f pyproject.toml && echo "✅ Python configured" || echo "❌ Python plugin failed"
```

### Phase 3: Infrastructure Plugin Installation

**3. Install infrastructure/containerization/docker plugin**

Follow: `plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md`

**Options**:
- Services: cli
- Compose: yes

Creates Docker containerization for CLI application.

**Validation**:
```bash
test -f docker-compose.yml && echo "✅ Docker configured" || echo "❌ Docker plugin failed"
```

**4. Install infrastructure/ci-cd/github-actions plugin**

Follow: `plugins/infrastructure/ci-cd/github-actions/AGENT_INSTRUCTIONS.md`

**Options**:
- Workflows: all
- Matrix: yes
- Python versions: ["3.11", "3.12"]

Creates CI/CD pipeline for automated testing and deployment.

**Validation**:
```bash
test -d .github/workflows && echo "✅ CI/CD configured" || echo "❌ CI/CD plugin failed"
```

### Phase 4: Standards Plugin Installation

**5. Install standards/security plugin**

Follow: `plugins/standards/security/AGENT_INSTRUCTIONS.md`

**Options**:
- Scanning: [secrets, dependencies]
- Tools: [gitleaks, trivy]

**Validation**:
```bash
test -f .gitignore && grep -q "secrets" .gitignore && echo "✅ Security configured" || echo "❌ Security plugin failed"
```

**6. Install standards/documentation plugin**

Follow: `plugins/standards/documentation/AGENT_INSTRUCTIONS.md`

**Options**:
- Headers: yes
- README sections: standard

**Validation**:
```bash
test -f .ai/docs/file-headers.md && echo "✅ Documentation configured" || echo "❌ Documentation plugin failed"
```

**7. Install standards/pre-commit-hooks plugin**

Follow: `plugins/standards/pre-commit-hooks/AGENT_INSTRUCTIONS.md`

**Options**:
- Hooks: [format, lint, secrets, trailing-whitespace]
- Python: yes

**Validation**:
```bash
test -f .pre-commit-config.yaml && echo "✅ Pre-commit configured" || echo "❌ Pre-commit plugin failed"
```

### Phase 5: Application-Specific Installation

**8. Copy Application Starter Code**

Copy files from `plugins/applications/python-cli/project-content/` to project root:

```bash
# Copy application source structure
cp -r plugins/applications/python-cli/project-content/src ./

# Copy test suite
cp -r plugins/applications/python-cli/project-content/tests ./

# Copy configuration files
cp plugins/applications/python-cli/project-content/pyproject.toml.template ./pyproject.toml
cp plugins/applications/python-cli/project-content/README.md.template ./README.md

# Copy CLI-specific docker-compose
cp plugins/applications/python-cli/project-content/docker-compose.cli.yml ./
```

**9. Copy Application Documentation**

Copy files from `plugins/applications/python-cli/ai-content/` to `.ai/`:

```bash
# Copy architecture documentation
cp plugins/applications/python-cli/ai-content/docs/python-cli-architecture.md .ai/docs/

# Copy application-specific how-tos
mkdir -p .ai/howtos/python-cli
cp -r plugins/applications/python-cli/ai-content/howtos/* .ai/howtos/python-cli/

# Copy application templates
mkdir -p .ai/templates/python-cli
cp -r plugins/applications/python-cli/ai-content/templates/* .ai/templates/python-cli/
```

**10. Configure Application**

Customize application for this project:

```bash
# Update project name in pyproject.toml
# Replace {{PROJECT_NAME}} with actual project name
sed -i 's/{{PROJECT_NAME}}/my-cli-tool/g' pyproject.toml
sed -i 's/{{PROJECT_DESCRIPTION}}/My awesome CLI tool/g' pyproject.toml
sed -i 's/{{AUTHOR_NAME}}/Your Name/g' pyproject.toml
sed -i 's/{{AUTHOR_EMAIL}}/your.email@example.com/g' pyproject.toml

# Update README.md
sed -i 's/{{PROJECT_NAME}}/my-cli-tool/g' README.md
sed -i 's/{{PROJECT_DESCRIPTION}}/My awesome CLI tool/g' README.md
```

**11. Install Dependencies with Poetry**

```bash
# Install Poetry if not already installed
# Poetry manages dependencies in isolated virtual environment
curl -sSL https://install.python-poetry.org | python3 -

# Configure Poetry to create venv in project directory (optional but recommended)
poetry config virtualenvs.in-project true

# Install all dependencies (runtime + dev) in isolated venv
# This does NOT corrupt the user's global Python environment
poetry install

# Install pre-commit hooks
poetry run pre-commit install
```

**Philosophy**: We use Poetry to ensure all dependencies are installed in an isolated virtual environment, preventing corruption of the user's system Python installation.

**12. Update .ai/index.yaml**

Add application entry to `.ai/index.yaml`:

```yaml
application:
  type: cli
  stack: [python, click, docker]
  howtos: .ai/howtos/python-cli/
  templates: .ai/templates/python-cli/
  primary_language: python
  frameworks: [click, pytest]
```

## Post-Installation

### Initial Setup

```bash
# IMPORTANT: Always use Make targets (don't run python/pytest/ruff directly)
# Make targets ensure consistent execution in isolated environment

# Verify CLI works
make cli-help

# Should see:
# Usage: cli [OPTIONS] COMMAND [ARGS]...
#
# Options:
#   --help  Show this message and exit.
#
# Commands:
#   config  Configuration management commands
#   hello   Print a greeting message

# Run example command
make cli-hello

# Build Docker container
make docker-build

# Run CLI in container
make docker-cli-help

# Run tests (uses Poetry's isolated venv)
make test

# Run linting (uses Poetry's isolated venv)
make lint

# Run formatting (uses Poetry's isolated venv)
make format
```

### Validation

Run complete validation:

```bash
# Check all files created
test -d src && echo "✅ Application source" || echo "❌ Missing src/"
test -f src/cli.py && echo "✅ CLI entrypoint" || echo "❌ Missing src/cli.py"
test -f src/config.py && echo "✅ Config handler" || echo "❌ Missing src/config.py"
test -d tests && echo "✅ Application tests" || echo "❌ Missing tests/"
test -f pyproject.toml && echo "✅ Python config" || echo "❌ Missing pyproject.toml"
test -f docker-compose.cli.yml && echo "✅ Docker compose" || echo "❌ Missing docker-compose.cli.yml"
test -d .github/workflows && echo "✅ CI/CD workflows" || echo "❌ Missing .github/workflows/"
test -f .ai/howtos/python-cli/README.md && echo "✅ Application how-tos" || echo "❌ Missing how-tos"

# Run CLI tool
python -m src.cli hello --name "Test"

# Should see: Hello, Test!

# Run tests
pytest -v

# Should see: All tests passing
```

## Success Criteria

- [x] All plugin dependencies installed successfully
- [x] Application starter code copied and configured
- [x] CLI runs and displays help correctly
- [x] Example commands work (hello, config)
- [x] Tests pass
- [x] Linting passes
- [x] Docker container builds successfully
- [x] CI/CD pipeline configured
- [x] Application-specific how-tos available in .ai/howtos/python-cli/
- [x] Security standards applied
- [x] Documentation standards applied
- [x] Pre-commit hooks installed

## Next Steps

1. **Read Application How-Tos**: Check `.ai/howtos/python-cli/` for guides
2. **Customize Application**: Modify starter code for your CLI tool needs
3. **Add Commands**: Follow how-to-add-cli-command.md to add new commands
4. **Configure Settings**: Use how-to-handle-config-files.md for config management
5. **Package Tool**: Follow how-to-package-cli-tool.md for distribution

## Common Issues

### Issue: Plugin dependency failed
**Solution**: Install failed plugin manually following its AGENT_INSTRUCTIONS.md

### Issue: Docker containers won't start
**Solution**:
```bash
docker-compose -f docker-compose.cli.yml down
docker-compose -f docker-compose.cli.yml build --no-cache
docker-compose -f docker-compose.cli.yml up
```

### Issue: Tests failing
**Solution**: Check that dependencies are installed:
```bash
pip install -e ".[dev]"
pytest -v
```

### Issue: Click command not found
**Solution**: Ensure you're running from project root and src is importable:
```bash
# Run as module
python -m src.cli --help

# Or install in editable mode
pip install -e .
my-cli-tool --help
```

### Issue: Import errors in tests
**Solution**: Install package in editable mode:
```bash
pip install -e ".[dev]"
```

## Application-Specific Notes

- CLI entrypoint is `src/cli.py` - all commands defined here
- Configuration handled by `src/config.py` - supports YAML and JSON
- Default config location: `~/.config/{{PROJECT_NAME}}/config.yaml`
- Logging configured in `src/cli.py` with DEBUG level for development
- Docker image uses Python 3.11 slim base for smaller size
- Tests use pytest fixtures for CLI invocation testing
- Add new commands as Click command functions in `src/cli.py`

---

**Remember**: This is a starter application. Customize it for your needs. All underlying plugins can be configured independently.
