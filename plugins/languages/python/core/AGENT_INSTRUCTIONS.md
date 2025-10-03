# Python Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the Python language plugin

**Scope**: Python development environment with linting, formatting, type checking, security scanning, and testing

**Overview**: Step-by-step instructions for AI agents to install and configure Python tooling including
    Ruff (linting + formatting), MyPy (type checking), Bandit (security), and pytest (testing),
    with integration into Makefile and CI/CD workflows.

**Dependencies**: foundation/ai-folder plugin

**Exports**: Complete Python development environment with quality tooling

**Related**: Language plugin for Python projects

**Implementation**: Option-based installation with user preferences

---

## Prerequisites

Before installing this plugin, ensure:
- ✅ Git repository is initialized
- ✅ foundation/ai-folder plugin is installed (agents.md and .ai/ exist)
- ✅ Python 3.11+ runtime is installed (or will be installed)
- ✅ Package manager (pip or poetry) is available

## Environment Strategy

**IMPORTANT**: Follow the Docker-first development hierarchy:

1. **Docker (Preferred)** 🐳
   - Use Docker containers for dev, lint, test, and prod
   - Benefits: Consistent environments, zero local pollution, works everywhere
   - See: `.ai/docs/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`

2. **Isolated Environment (Fallback)** 📦
   - Use Poetry virtual environments when Docker unavailable
   - Still provides project isolation but platform-dependent

3. **Direct Local (Last Resort)** ⚠️
   - Only when Docker AND Poetry unavailable
   - Risk of polluting global Python environment

**This plugin provides templates for all three approaches with automatic detection in Makefiles.**

## Installation Steps

### Step 1: Gather User Preferences

Ask the user (or use recommended defaults):

#### Core Tools (Always Installed)
1. **Linter + Formatter**: Use Ruff?
   - **Ruff** (RECOMMENDED - fast, all-in-one tool combining linting + formatting)
     - Replaces: Black, isort, flake8, and parts of pylint
     - 10-100x faster than traditional tools
     - Single configuration file
   - Default: **Ruff**

2. **Type Checking**: Enable MyPy?
   - **Yes** (RECOMMENDED - catches type errors before runtime)
   - No
   - Default: **Yes**

3. **Security Scanning**: Enable Bandit?
   - **Yes** (RECOMMENDED - scans for security vulnerabilities)
   - No
   - Default: **Yes**

4. **Testing Framework**: Use pytest?
   - **pytest** (RECOMMENDED - industry standard, feature-rich)
   - unittest (Python built-in, less features)
   - Default: **pytest**

#### Comprehensive Tooling Suite (PR7.6 - Production-Grade)
5. **Additional Linters**: Install comprehensive linting suite?
   - **Pylint** (comprehensive code quality linting)
   - **Flake8** + plugins (style guide enforcement with docstrings, bugbear, comprehensions, simplify)
   - Default: **Yes** (recommended for production projects)

6. **Complexity Analysis**: Enable complexity monitoring?
   - **Radon** (cyclomatic complexity and maintainability index)
   - **Xenon** (complexity enforcement - fails build if too complex)
   - Default: **Yes** (recommended for maintainability)

7. **Comprehensive Security**: Enable all security tools?
   - **Safety** (dependency vulnerability scanning via CVE database)
   - **pip-audit** (alternative dependency auditor via OSV database)
   - Default: **Yes** (recommended for production security)

8. **Project Structure**: Create starter files?
   - Yes (creates example.py and tests/)
   - No
   - Default: **No** (only if new project)

**Note**: The comprehensive tooling suite includes all tools from durable-code-test reference implementation.
See `standards/comprehensive-tooling.md` for detailed tool documentation.

### Step 2: Install Ruff (Linter + Formatter)

**Follow**: `linters/ruff/AGENT_INSTRUCTIONS.md`

**Summary**:
1. Install Ruff via pip or poetry:
   ```bash
   poetry add --group dev ruff
   # or
   pip install ruff
   ```

2. Copy Ruff configuration:
   ```bash
   # If pyproject.toml doesn't exist
   cp plugins/languages/python/linters/ruff/config/pyproject.toml ./pyproject.toml

   # If pyproject.toml exists, merge [tool.ruff] sections
   ```

3. Verify:
   ```bash
   ruff --version
   ruff check .
   ruff format --check .
   ```

### Step 3: Install MyPy (Type Checker)

**If user selected MyPy**, follow: `linters/mypy/AGENT_INSTRUCTIONS.md`

**Summary**:
1. Install MyPy:
   ```bash
   poetry add --group dev mypy
   ```

2. Copy configuration:
   ```bash
   cp plugins/languages/python/linters/mypy/config/mypy.ini ./mypy.ini
   ```

3. Verify:
   ```bash
   mypy --version
   mypy .
   ```

### Step 4: Install Bandit (Security Scanner)

**If user selected Bandit**, follow: `linters/bandit/AGENT_INSTRUCTIONS.md`

**Summary**:
1. Install Bandit:
   ```bash
   poetry add --group dev bandit
   ```

2. Copy configuration:
   ```bash
   cp plugins/languages/python/linters/bandit/config/.bandit ./.bandit
   ```

3. Verify:
   ```bash
   bandit --version
   bandit -r . -q
   ```

### Step 5: Install Pytest (Testing)

**Follow**: `testing/pytest/AGENT_INSTRUCTIONS.md`

**Summary**:
1. Install pytest and plugins:
   ```bash
   poetry add --group dev pytest pytest-asyncio pytest-cov
   ```

2. Copy configuration:
   ```bash
   cp plugins/languages/python/testing/pytest/config/pytest.ini ./pytest.ini
   ```

3. Create tests directory:
   ```bash
   mkdir -p tests
   touch tests/__init__.py
   ```

4. Verify:
   ```bash
   pytest --version
   pytest
   ```

### Step 6: Create Makefile Targets

Add Python-specific targets to Makefile (create if doesn't exist):

**Option A**: Include the Python Makefile
```makefile
# At the top of Makefile
-include Makefile.python
```

Then copy the file:
```bash
cp plugins/languages/python/templates/makefile-python.mk ./Makefile.python
```

**Option B**: Copy targets directly into main Makefile
```bash
# Append Python targets to existing Makefile
cat plugins/languages/python/templates/makefile-python.mk >> Makefile
```

**Customize** the `PYTHON_SRC_DIRS` variable in the Makefile to match your project structure:
```makefile
# Change this based on your project
PYTHON_SRC_DIRS := src app  # or whatever your source directories are
```

### Step 7: Extend agents.md

Add Python-specific guidelines to agents.md:

1. Read agents.md
2. Find the `### LANGUAGE_SPECIFIC_GUIDELINES` section
3. Insert between `<!-- BEGIN_LANGUAGE_GUIDELINES -->` and `<!-- END_LANGUAGE_GUIDELINES -->` markers:

```markdown
#### Python (PEP 8)
- **Style**: 120 char line length, 4-space indentation, double quotes
- **Naming**: snake_case (functions/vars), PascalCase (classes), UPPER_SNAKE_CASE (constants)
- **Imports**: stdlib → third-party → local (with blank lines between groups)
- **Type hints**: Required for all function signatures (use Python 3.11+ built-in types)
- **Docstrings**: Google-style for all public functions and classes
- **Complexity**: Maximum McCabe complexity of 10
- **Security**: No hardcoded secrets, use parameterized queries, validate all inputs

**Linting**: `make lint-python` (runs Ruff - combines linting + formatting)
**Type Checking**: `make typecheck` (runs MyPy static type checker)
**Security**: `make security-scan` (runs Bandit security scanner)
**Testing**: `make test-python` (runs pytest)
**Coverage**: `make test-coverage-python` (runs pytest with coverage reporting)
**Format**: `make format-python` (auto-formats with Ruff)
**All Checks**: `make python-check` (runs lint, typecheck, security, and tests)
```

Or copy from template:
```bash
cat plugins/languages/python/templates/agents-md-extension.txt
# Then insert the content into AGENTS.md between markers
```

### Step 8: Add .ai Documentation

Create `.ai/docs/PYTHON_STANDARDS.md`:

```bash
mkdir -p .ai/docs
cp plugins/languages/python/standards/python-standards.md .ai/docs/PYTHON_STANDARDS.md
```

Update `.ai/index.yaml` to reference this documentation:

```yaml
documentation:
  standards:
    - path: docs/PYTHON_STANDARDS.md
      title: Python Coding Standards
      description: PEP 8 compliance, naming conventions, and best practices
```

### Step 9: Add GitHub Actions Workflow (if CI/CD plugin present)

If `.github/workflows/` exists:

1. Copy the Python workflow:
   ```bash
   mkdir -p .github/workflows
   cp plugins/languages/python/templates/github-workflow-python.yml .github/workflows/python.yml
   ```

2. Customize for repository structure:
   - Update `PYTHON_SRC_DIRS` if needed
   - Adjust coverage thresholds if desired
   - Modify workflow triggers if needed

### Step 10: Create Package Configuration

Ensure a package configuration file exists:

**Using Poetry** (recommended):
```bash
# If pyproject.toml doesn't exist
poetry init

# Add dev dependencies
poetry add --group dev ruff mypy bandit pytest pytest-asyncio pytest-cov
```

**Using pip**:
Create `requirements-dev.txt`:
```
ruff>=0.13.0
mypy>=1.18.1
bandit>=1.7.5
pytest>=8.4.2
pytest-asyncio>=0.23.0
pytest-cov>=4.1.0
```

### Step 11: Install Comprehensive Tooling Suite (Optional but Recommended)

**If user selected comprehensive tooling** (Pylint, Flake8, Radon, Xenon, Safety, pip-audit):

#### Install Additional Dependencies

Using the comprehensive pyproject.toml template:
```bash
# Copy the comprehensive template (includes all tools)
cp plugins/languages/python/templates/pyproject.toml.template ./pyproject.toml

# Customize placeholders in pyproject.toml:
# - {{PROJECT_NAME}} → your project name
# - {{PROJECT_DESCRIPTION}} → your description
# - {{PACKAGE_NAME}} → your main package
# - {{AUTHOR_NAME}} and {{AUTHOR_EMAIL}} → your info

# Install all dependencies
poetry install
```

Or add tools individually:
```bash
# Additional linters
poetry add --group dev pylint flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify

# Complexity analysis
poetry add --group dev radon xenon

# Additional security tools
poetry add --group dev safety pip-audit
```

#### Copy Configuration Files

```bash
# Flake8 configuration
cp plugins/languages/python/standards/.flake8 ./.flake8

# Pylint configuration (optional if using pyproject.toml)
cp plugins/languages/python/standards/.pylintrc ./.pylintrc

# Radon configuration (optional)
cp plugins/languages/python/standards/radon.cfg ./radon.cfg
```

#### Verify Comprehensive Tooling

```bash
# Verify installations
pylint --version
flake8 --version
radon --version
xenon --version
safety --version
pip-audit --version

# Test individual tools
make lint-pylint           # Pylint linting
make lint-flake8           # Flake8 + plugins
make complexity-radon      # Radon analysis
make complexity-xenon      # Xenon enforcement
make security-full         # All security tools
```

**Documentation**: See `standards/comprehensive-tooling.md` for detailed tool usage and configuration.

### Step 12: Create Example/Starter Files (Optional)

**If user requested starter files** or this is a new empty project:

1. Create source directory:
   ```bash
   mkdir -p src
   ```

2. Copy example Python file:
   ```bash
   cp plugins/languages/python/templates/example.py src/example.py
   ```

3. Copy example test file:
   ```bash
   mkdir -p tests
   cp plugins/languages/python/templates/test_example.py tests/test_example.py
   ```

4. Verify everything works:
   ```bash
   make lint-python
   make typecheck
   make test-python
   ```

### Step 13: Validate Installation

Run the following commands to verify complete installation:

```bash
# 1. Verify core tools are installed
ruff --version
mypy --version
bandit --version
pytest --version

# 2. Verify comprehensive tools (if installed)
pylint --version || echo "Pylint not installed (optional)"
flake8 --version || echo "Flake8 not installed (optional)"
radon --version || echo "Radon not installed (optional)"
xenon --version || echo "Xenon not installed (optional)"
safety --version || echo "Safety not installed (optional)"
pip-audit --version || echo "pip-audit not installed (optional)"

# 3. Verify config files exist
ls -la pyproject.toml  # Comprehensive config with all tools
ls -la .flake8         # Flake8 config (if comprehensive tooling installed)
ls -la .pylintrc       # Pylint config (if using standalone file)

# 4. Run quality checks
make lint-python       # Should pass or show expected warnings
make typecheck         # Should pass or show expected type issues
make security-scan     # Should pass or show security findings
make test-python       # Should pass if tests exist

# 5. Run comprehensive checks (if tools installed)
make lint-pylint || echo "Pylint not configured"
make lint-flake8 || echo "Flake8 not configured"
make complexity-radon || echo "Radon not configured"
make security-full || echo "Comprehensive security not configured"

# 6. Run all checks together
make python-check      # Runs core Python quality checks
```

## Post-Installation

After successful installation, inform the user:

**Installed Core Tools**:
- ✅ **Ruff**: Fast linter + formatter (replaces Black, isort, flake8)
- ✅ **MyPy**: Static type checker (if selected)
- ✅ **Bandit**: Security vulnerability scanner (if selected)
- ✅ **Pytest**: Testing framework with coverage support

**Installed Comprehensive Tools** (if selected):
- ✅ **Pylint**: Comprehensive code quality linting
- ✅ **Flake8 + plugins**: Style guide enforcement (docstrings, bugbear, comprehensions, simplify)
- ✅ **Radon**: Cyclomatic complexity and maintainability index
- ✅ **Xenon**: Complexity enforcement (fails on violations)
- ✅ **Safety**: Dependency vulnerability scanning (CVE database)
- ✅ **pip-audit**: Alternative dependency auditor (OSV database)

**Available Make Targets (Core)**:
```bash
make lint-python              # Run Ruff linting
make format-python            # Format code with Ruff
make typecheck                # Run MyPy type checking
make security-scan            # Run Bandit security scan
make test-python              # Run pytest tests
make test-coverage-python     # Run tests with coverage
make python-check             # Run all core checks
make python-install           # Install dependencies
make clean-python             # Clean cache files
```

**Available Make Targets (Comprehensive)**:
```bash
# Additional Linting
make lint-mypy                # MyPy type checking (alias)
make lint-bandit              # Bandit security scan (alias)
make lint-pylint              # Pylint comprehensive linting
make lint-flake8              # Flake8 + plugins linting

# Complexity Analysis
make complexity-radon         # Radon CC & MI analysis
make complexity-xenon         # Xenon complexity enforcement (fails on violations)

# Comprehensive Security
make security-full            # All security tools (Bandit + Safety + pip-audit)
```

**Next Steps**:
1. Run `make python-check` to verify all tools work
2. Review `.ai/docs/PYTHON_STANDARDS.md` for coding standards
3. Configure pre-commit hooks (if using pre-commit plugin)
4. Add Docker support (if using Docker plugin)
5. Start writing Python code following PEP 8 standards!

## Integration with Other Plugins

### With Pre-commit Hooks Plugin
If pre-commit plugin is installed, add Python hooks:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: ruff-lint
        name: Ruff Linting
        entry: ruff check --fix
        language: system
        types: [python]

      - id: ruff-format
        name: Ruff Formatting
        entry: ruff format
        language: system
        types: [python]

      - id: mypy
        name: MyPy Type Checking
        entry: mypy
        language: system
        types: [python]
        pass_filenames: false
```

### With CI/CD Plugin
Workflow already created in Step 9 if GitHub Actions present.

### With Docker Plugin
The Python plugin includes complete Docker support with multi-stage builds:

1. **Copy Docker templates**:
   ```bash
   mkdir -p .docker/dockerfiles .docker/compose
   cp plugins/languages/python/templates/Dockerfile.python .docker/dockerfiles/Dockerfile.backend
   cp plugins/languages/python/templates/docker-compose.python.yml .docker/compose/app.yml
   ```

2. **Start development with hot reload**:
   ```bash
   make dev  # Uses Docker automatically if available
   ```

3. **Run linting in containers**:
   ```bash
   make lint-all  # Runs in dedicated linting containers
   ```

The Dockerfile includes targets for:
- `dev`: Development with hot reload
- `lint`: All linting tools (Ruff, MyPy, Bandit, Pylint, etc.)
- `test`: Test execution with coverage
- `prod`: Minimal production image

## Troubleshooting

### Issue: Tools not found after installation
**Solution**: Ensure Python is in PATH and tools are installed:
```bash
which python
which ruff
poetry show | grep ruff
```

### Issue: Config file conflicts
**Solution**: If pyproject.toml exists, merge configurations instead of overwriting

### Issue: Make targets don't work
**Solution**: Verify Makefile syntax and that tools are installed and in PATH

### Issue: Import errors in tests
**Solution**: Install package in editable mode:
```bash
pip install -e .
# or
poetry install
```

## Standalone Usage

This plugin works standalone without the orchestrator:

1. Copy this plugin directory to your project
2. Follow steps 1-12 above manually
3. Validate with step 12

## Success Criteria

Installation is successful when:
- ✅ Ruff installed and configured (`ruff --version` works)
- ✅ MyPy installed and configured (if selected)
- ✅ Bandit installed and configured (if selected)
- ✅ Pytest installed and configured
- ✅ All configuration files exist (pyproject.toml, mypy.ini, .bandit, pytest.ini)
- ✅ Makefile targets work (`make lint-python`, etc.)
- ✅ agents.md updated with Python guidelines
- ✅ `.ai/docs/PYTHON_STANDARDS.md` exists
- ✅ `make python-check` runs successfully
- ✅ User can start developing with complete quality tooling

---

**Note**: This plugin provides production-ready Python tooling based on modern best practices
and configurations extracted from the durable-code-test reference implementation.
