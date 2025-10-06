# How to Create a Language Plugin

**Purpose**: Step-by-step guide for creating new language plugins for ai-projen

**Scope**: Complete workflow from template copying to PR submission for language-specific tooling

**Overview**: Comprehensive, actionable guide for developers who want to add support for new programming
    languages to ai-projen. Covers directory structure, configuration files, integration points, testing,
    and best practices. Uses Python and TypeScript plugins as reference implementations.

**Dependencies**: foundation/ai-folder plugin, PLUGIN_MANIFEST.yaml

**Exports**: Knowledge for creating Go, Rust, Java, PHP, Ruby, or any language plugin

**Related**: PLUGIN_ARCHITECTURE.md for structure requirements, _template/ for boilerplate

**Implementation**: Template-based plugin creation with standardized integration points

---

## Overview

### What is a Language Plugin?

A language plugin provides language-specific development tooling including:
- **Linters** - Code quality and style checking (e.g., Ruff for Python, ESLint for TypeScript)
- **Formatters** - Automatic code formatting (e.g., Black for Python, Prettier for TypeScript)
- **Test Frameworks** - Testing infrastructure (e.g., pytest for Python, Vitest for TypeScript)
- **Type Checkers** - Static type analysis (e.g., mypy for Python, tsc for TypeScript)
- **Standards Documentation** - Language-specific coding conventions
- **Makefile Integration** - Consistent command interface (`make lint-python`, `make test-ts`)
- **CI/CD Integration** - GitHub Actions workflows for automated checks

### Why Create a Language Plugin?

Language plugins enable:
- **Consistent Development Experience** - Same patterns across all languages
- **AI Agent Compatibility** - Clear instructions for automated setup
- **Standalone Functionality** - Works without orchestrator
- **Community Contributions** - Easy to add support for new languages
- **Battle-Tested Configurations** - Production-ready tool configurations

### Architecture Philosophy

Each language plugin must:
1. **Work Standalone** - Install and function without orchestrator
2. **Offer Options** - Multiple linter/formatter/testing choices with recommended defaults
3. **Integrate Cleanly** - Extend agents.md, Makefile, and CI/CD without conflicts
4. **Document Clearly** - Provide AGENT_INSTRUCTIONS.md for AI agents
5. **Follow Conventions** - Use consistent naming and structure patterns

---

## Prerequisites

Before creating a language plugin, ensure you have:

### Technical Requirements
- ✅ **Git repository** - ai-projen cloned locally
- ✅ **Language runtime** - Installed for testing (e.g., Python 3.11+, Node 20+)
- ✅ **Package manager** - Language's package manager (pip, npm, cargo, etc.)
- ✅ **Development tools** - Linters, formatters, test frameworks for your language

### Knowledge Requirements
- ✅ **Language ecosystem** - Understand common tooling options
- ✅ **Best practices** - Know recommended linters, formatters, and test frameworks
- ✅ **Configuration formats** - Familiar with tool config files (YAML, JSON, TOML, etc.)

### Framework Familiarity
- ✅ Read `PLUGIN_ARCHITECTURE.md` - Understand plugin structure
- ✅ Read `PLUGIN_MANIFEST.yaml` - See existing plugin definitions
- ✅ Review `plugins/languages/_template/` - Understand template structure
- ✅ Check Python and TypeScript plugins - See reference implementations (when available)

---

## Step-by-Step Guide

### Step 1: Copy the Template

Start by copying the language plugin template:

```bash
cd /home/stevejackson/Projects/ai-projen

# Copy template to your language directory
cp -r plugins/languages/_template/ plugins/languages/<language-name>/
cd plugins/languages/<language-name>/

# Example for Go:
# cp -r plugins/languages/_template/ plugins/languages/go/
# cd plugins/languages/go/
```

**Naming Convention**:
- Use lowercase language name: `python`, `typescript`, `go`, `rust`, `java`
- Use full names, not abbreviations: `javascript` not `js`, `typescript` not `ts`
- For multi-word names, use hyphens: `c-sharp`, `objective-c`

### Step 2: Identify Your Language's Tools

Research and document the available tooling options for your language:

#### Linters
Identify popular linters with their strengths:

**Python Example**:
- **Ruff** (recommended) - Fast, comprehensive, combines multiple tools
- **Pylint** - Traditional, highly configurable
- **Flake8** - Popular, plugin-based

**TypeScript Example**:
- **ESLint** (recommended) - Industry standard, extensive ecosystem
- **Biome** - Fast, all-in-one tool

**Go Example**:
- **golangci-lint** (recommended) - Runs multiple linters
- **staticcheck** - Advanced static analysis
- **revive** - Fast, configurable

#### Formatters
Identify formatter options:

**Python Example**:
- **Black** (recommended) - Opinionated, minimal configuration
- **autopep8** - PEP 8 compliant
- **yapf** - Highly configurable

**TypeScript Example**:
- **Prettier** (recommended) - Opinionated, widely adopted
- **Biome** - Fast alternative

**Go Example**:
- **gofmt** (recommended) - Official formatter
- **goimports** - Adds import management

#### Test Frameworks
Identify testing frameworks:

**Python Example**:
- **pytest** (recommended) - Feature-rich, plugin ecosystem
- **unittest** - Built-in standard library

**TypeScript Example**:
- **Vitest** (recommended) - Fast, modern, Vite-native
- **Jest** - Popular, comprehensive
- **Mocha** - Flexible, minimal

**Go Example**:
- **testing** (recommended) - Built-in standard library
- **testify** - Assertion library
- **ginkgo** - BDD-style testing

#### Type Checkers (if applicable)
For languages with optional type systems:

**Python Example**:
- **mypy** (recommended) - Standard type checker
- **pyright** - Microsoft's type checker
- **none** - Skip type checking

**TypeScript Example**:
- **tsc** (built-in) - TypeScript compiler type checker

### Step 3: Create Linter Configurations

For each linter option, create a subdirectory with:
1. AGENT_INSTRUCTIONS.md
2. Configuration file(s)
3. README.md (optional)

#### Directory Structure
```
linters/
├── <linter1-name>/
│   ├── AGENT_INSTRUCTIONS.md
│   ├── config/
│   │   └── .<linter>rc (or appropriate config file)
│   └── README.md
├── <linter2-name>/
│   ├── AGENT_INSTRUCTIONS.md
│   ├── config/
│   │   └── .<linter>rc
│   └── README.md
└── <linter3-name>/
    ├── AGENT_INSTRUCTIONS.md
    ├── config/
    │   └── .<linter>rc
    └── README.md
```

#### Example: Python Ruff Linter

**File**: `linters/ruff/AGENT_INSTRUCTIONS.md`
```markdown
# Ruff Linter - Agent Instructions

**Purpose**: Install and configure Ruff linter for Python

**Scope**: Code quality and style checking with Ruff

**Prerequisites**: Python 3.7+ installed

## Installation Steps

### Step 1: Install Ruff
```bash
pip install ruff
```

### Step 2: Copy Configuration
Copy `config/ruff.toml` to repository root:
```bash
cp plugins/languages/python/linters/ruff/config/ruff.toml ./ruff.toml
```

### Step 3: Verify Installation
```bash
ruff --version
ruff check .
```

## Configuration Details

The ruff.toml includes:
- Line length: 100 characters
- Select: Comprehensive rule set (E, F, W, I, N, D, UP, S, B, A, C4, T20, SIM)
- Ignore: Specific rules as needed
- Per-file ignores for tests/
```

**File**: `linters/ruff/config/ruff.toml`
```toml
[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "F",   # pyflakes
    "W",   # pycodestyle warnings
    "I",   # isort
    "N",   # pep8-naming
    "D",   # pydocstyle
    "UP",  # pyupgrade
    "S",   # bandit security
    "B",   # flake8-bugbear
    "A",   # flake8-builtins
    "C4",  # flake8-comprehensions
    "T20", # flake8-print
    "SIM", # flake8-simplify
]

ignore = [
    "D203",  # one-blank-line-before-class
    "D213",  # multi-line-summary-second-line
]

[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = ["S101", "D"]  # Allow asserts and skip docstrings in tests
```

#### Example: TypeScript ESLint

**File**: `linters/eslint/AGENT_INSTRUCTIONS.md`
```markdown
# ESLint Linter - Agent Instructions

**Purpose**: Install and configure ESLint for TypeScript/JavaScript

**Scope**: Code quality and style checking with ESLint

**Prerequisites**: Node.js 18+ and npm installed

## Installation Steps

### Step 1: Install ESLint and Plugins
```bash
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

### Step 2: Copy Configuration
```bash
cp plugins/languages/typescript/linters/eslint/config/.eslintrc.json ./.eslintrc.json
```

### Step 3: Verify Installation
```bash
npx eslint --version
npx eslint . --ext .ts,.tsx,.js,.jsx
```

## Configuration Details

The .eslintrc.json includes:
- TypeScript parser and plugin
- Recommended rules
- React support (if needed)
```

**File**: `linters/eslint/config/.eslintrc.json`
```json
{
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "plugins": ["@typescript-eslint"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/explicit-function-return-type": "warn",
    "no-console": "warn"
  },
  "ignorePatterns": ["dist/", "build/", "node_modules/"]
}
```

### Step 4: Create Formatter Configurations

Follow the same pattern as linters:

#### Directory Structure
```
formatters/
├── <formatter1-name>/
│   ├── AGENT_INSTRUCTIONS.md
│   ├── config/
│   │   └── .<formatter>rc
│   └── README.md
└── <formatter2-name>/
    ├── AGENT_INSTRUCTIONS.md
    ├── config/
    │   └── .<formatter>rc
    └── README.md
```

#### Example: Python Black Formatter

**File**: `formatters/black/config/pyproject.toml`
```toml
[tool.black]
line-length = 100
target-version = ['py311']
include = '\.pyi?$'
extend-exclude = '''
/(
  # directories
  \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | build
  | dist
)/
'''
```

#### Example: TypeScript Prettier Formatter

**File**: `formatters/prettier/config/.prettierrc.json`
```json
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "arrowParens": "always"
}
```

### Step 5: Create Test Framework Configurations

#### Directory Structure
```
testing/
├── <framework1-name>/
│   ├── AGENT_INSTRUCTIONS.md
│   ├── config/
│   │   └── <test-config-file>
│   └── README.md
└── <framework2-name>/
    ├── AGENT_INSTRUCTIONS.md
    ├── config/
    │   └── <test-config-file>
    └── README.md
```

#### Example: Python pytest

**File**: `testing/pytest/config/pyproject.toml`
```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = "test_*.py"
python_classes = "Test*"
python_functions = "test_*"
addopts = [
    "-v",
    "--strict-markers",
    "--cov=src",
    "--cov-report=term-missing",
    "--cov-report=html",
]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests",
]
```

#### Example: TypeScript Vitest

**File**: `testing/vitest/config/vitest.config.ts`
```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      exclude: ['**/node_modules/**', '**/dist/**', '**/*.config.*'],
    },
  },
});
```

### Step 6: Add Plugin Parameters Support

Language plugins should support parameters to enable flexible installation paths. This allows meta-plugins to install language tooling in subdirectories rather than the repository root.

**Why Parameters Matter**: When creating full-stack applications, you need Python files in `backend/` and TypeScript files in `frontend/`, not at the root. Parameters enable this flexibility while maintaining standalone functionality.

#### Parameter Standard

See `.ai/docs/PLUGIN_PARAMETER_STANDARD.md` for complete parameter implementation guidance. Key points:

- **INSTALL_PATH parameter**: Specifies where language files/config should be installed
- **Default to current directory**: Use `${INSTALL_PATH:-.}` for standalone compatibility
- **Update all file operations**: Prepend `"${INSTALL_PATH}/"` to all file paths
- **Validate correctly**: Check files are in INSTALL_PATH, not orphaned at root

#### Implementation Steps

When writing your AGENT_INSTRUCTIONS.md in the next step, include:

1. **Parameters section** (before Prerequisites):
   - Document INSTALL_PATH parameter
   - Show default value and examples
   - Demonstrate usage with and without parameter

2. **Installation path setup** (first installation step):
   - Accept parameter with default: `INSTALL_PATH="${INSTALL_PATH:-.}"`
   - Create directory: `mkdir -p "${INSTALL_PATH}"`
   - Echo for visibility: `echo "Installing to: ${INSTALL_PATH}"`

3. **File operations** (throughout installation):
   - Use `"${INSTALL_PATH}/filename"` for all file creation
   - Examples: `cat > "${INSTALL_PATH}/package.json"`, `cp config "${INSTALL_PATH}/.eslintrc.json"`

4. **Validation** (final step):
   - Check files exist in INSTALL_PATH: `test -f "${INSTALL_PATH}/config"`
   - Verify no orphans when using custom path
   - Test both standalone and parameterized modes

### Step 7: Write AGENT_INSTRUCTIONS.md

The main plugin AGENT_INSTRUCTIONS.md coordinates the entire installation and implements parameter support:

**File**: `AGENT_INSTRUCTIONS.md`

```markdown
# <Language> Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the <Language> language plugin

**Scope**: <Language> development environment with linting, formatting, and testing

**Overview**: Step-by-step instructions for AI agents to install and configure <Language> tooling
    including linters, formatters, test frameworks, and integration with Makefile and CI/CD.

**Dependencies**: foundation/ai-folder plugin

**Exports**: <Language> development environment with quality tooling

**Related**: Language plugin for <Language> projects

**Implementation**: Option-based installation with user preferences

---

## Parameters

This plugin accepts the following parameters:

- **INSTALL_PATH** - Directory where <Language> tooling will be installed
  - Default: `.` (current directory)
  - Example: `backend/`, `services/api/`, `src/`

### Usage

Standalone (uses current directory):
```
Follow: plugins/languages/<language>/core/AGENT_INSTRUCTIONS.md
```

With custom path:
```
Follow: plugins/languages/<language>/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=backend/
```

---

## Prerequisites

Before installing this plugin, ensure:
- ✅ Git repository is initialized
- ✅ foundation/ai-folder plugin is installed (agents.md and .ai/ exist)
- ✅ <Language> runtime is installed (or will be installed)
- ✅ Package manager (<package-manager>) is available

## Installation Steps

### Step 1: Set Installation Path

```bash
# Accept INSTALL_PATH parameter with default to current directory
INSTALL_PATH="${INSTALL_PATH:-.}"

# Create installation directory if it doesn't exist
mkdir -p "${INSTALL_PATH}"

echo "Installing <Language> plugin to: ${INSTALL_PATH}"
```

### Step 2: Gather User Preferences

Ask the user (or use recommended defaults):

1. **Linter**: Which linter should we use?
   - <linter1> (recommended - <reason>)
   - <linter2> (<reason>)
   - Default: <linter1>

2. **Formatter**: Which formatter should we use?
   - <formatter1> (recommended - <reason>)
   - <formatter2> (<reason>)
   - Default: <formatter1>

3. **Testing**: Which test framework?
   - <framework1> (recommended - <reason>)
   - <framework2> (<reason>)
   - Default: <framework1>

### Step 3: Install Linter

Based on user's choice, follow the appropriate sub-instructions:

- For <linter1>: See `linters/<linter1>/AGENT_INSTRUCTIONS.md`
- For <linter2>: See `linters/<linter2>/AGENT_INSTRUCTIONS.md`

### Step 4: Install Formatter

Based on user's choice:

- For <formatter1>: See `formatters/<formatter1>/AGENT_INSTRUCTIONS.md`
- For <formatter2>: See `formatters/<formatter2>/AGENT_INSTRUCTIONS.md`

### Step 5: Install Test Framework

Based on user's choice:

- For <framework1>: See `testing/<framework1>/AGENT_INSTRUCTIONS.md`
- For <framework2>: See `testing/<framework2>/AGENT_INSTRUCTIONS.md`

### Step 6: Create Configuration Files

```bash
# Create linter configuration in INSTALL_PATH
cat > "${INSTALL_PATH}/<linter-config>" << 'EOF'
<configuration content>
EOF

# Create formatter configuration in INSTALL_PATH
cat > "${INSTALL_PATH}/<formatter-config>" << 'EOF'
<configuration content>
EOF

# Create package configuration in INSTALL_PATH
cat > "${INSTALL_PATH}/package.json" << 'EOF'
<package configuration>
EOF
```

### Step 7: Create Makefile Targets

Add <language>-specific targets to Makefile (create if doesn't exist):

\`\`\`makefile
# Copy from templates/makefile-<language>.mk

.PHONY: lint-<lang> format-<lang> test-<lang> <lang>-check

lint-<lang>:
	<linter-command>

format-<lang>:
	<formatter-command>

test-<lang>:
	<test-command>

<lang>-check: lint-<lang> test-<lang>
	@echo "✓ <Language> checks passed"
\`\`\`

### Step 8: Extend agents.md

Add <Language>-specific guidelines to agents.md between the
`### LANGUAGE_SPECIFIC_GUIDELINES` markers.

### Step 9: Add .ai Documentation

Create `.ai/docs/<LANGUAGE>_STANDARDS.md` with coding standards.
Update `.ai/index.yaml` to reference this documentation.

### Step 10: Validate Installation

Run the following commands to verify:

\`\`\`bash
# Check configuration files exist in correct location
test -f "${INSTALL_PATH}/<linter-config>" && echo "✅ Linter configured"
test -f "${INSTALL_PATH}/<formatter-config>" && echo "✅ Formatter configured"
test -f "${INSTALL_PATH}/package.json" && echo "✅ Package configured"

# Run linting
make lint-<lang>

# Run formatting
make format-<lang>

# Run tests
make test-<lang>

# Verify no orphaned files at root (when INSTALL_PATH is not current dir)
if [ "${INSTALL_PATH}" != "." ]; then
  ! test -f package.json && echo "✅ No root package file"
  ! test -f <linter-config> && echo "✅ No root linter config"
fi
\`\`\`

## Success Criteria

Installation is successful when:
- ✅ Linter config exists in INSTALL_PATH and linting works
- ✅ Formatter config exists in INSTALL_PATH and formatting works
- ✅ Test framework installed in INSTALL_PATH and tests run
- ✅ Makefile targets work
- ✅ agents.md updated with <Language> guidelines
- ✅ `.ai/docs/<LANGUAGE>_STANDARDS.md` exists
- ✅ Files created in INSTALL_PATH, not orphaned at root (when using custom path)
```

### Step 7: Create Makefile Integration

Create a Makefile snippet template that users can include:

**File**: `templates/makefile-<language>.mk`

**Python Example**:
```makefile
# Python Development Targets
# Include in main Makefile or use directly

.PHONY: lint-python format-python test-python python-check

lint-python:
	@echo "Running Python linter (Ruff)..."
	ruff check .

format-python:
	@echo "Formatting Python code (Black)..."
	black .
	@echo "Organizing imports (Ruff)..."
	ruff check --select I --fix .

test-python:
	@echo "Running Python tests (pytest)..."
	pytest

python-check: lint-python test-python
	@echo "✓ Python checks passed"

# Optional: Type checking
type-check-python:
	@echo "Running Python type checker (mypy)..."
	mypy .
```

**TypeScript Example**:
```makefile
# TypeScript Development Targets
# Include in main Makefile or use directly

.PHONY: lint-ts format-ts test-ts ts-check

lint-ts:
	@echo "Running TypeScript linter (ESLint)..."
	npx eslint . --ext .ts,.tsx,.js,.jsx

format-ts:
	@echo "Formatting TypeScript code (Prettier)..."
	npx prettier --write .

test-ts:
	@echo "Running TypeScript tests (Vitest)..."
	npx vitest run

ts-check: lint-ts test-ts
	@echo "✓ TypeScript checks passed"

# Optional: Type checking
type-check-ts:
	@echo "Running TypeScript compiler type check..."
	npx tsc --noEmit
```

**Go Example**:
```makefile
# Go Development Targets
# Include in main Makefile or use directly

.PHONY: lint-go format-go test-go go-check

lint-go:
	@echo "Running Go linter (golangci-lint)..."
	golangci-lint run ./...

format-go:
	@echo "Formatting Go code (gofmt + goimports)..."
	gofmt -w .
	goimports -w .

test-go:
	@echo "Running Go tests..."
	go test -v -race -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

go-check: lint-go test-go
	@echo "✓ Go checks passed"
```

### Step 8: Create agents.md Extension Snippet

Create a template snippet that gets inserted into agents.md:

**File**: `templates/agents-md-snippet.md`

**Python Example**:
```markdown
#### Python (PEP 8 + Type Hints)
- Use type hints for all function signatures
- Follow PEP 8 naming conventions (snake_case for functions/variables)
- Docstrings: Google style for all public functions
- Imports: Standard library → third-party → local (sorted within groups)
- Max line length: 100 characters
- Use f-strings for string formatting

**Linting**: `make lint-python` (runs Ruff)
**Formatting**: `make format-python` (runs Black)
**Testing**: `make test-python` (runs pytest)
**Type Checking**: `make type-check-python` (runs mypy)
```

**TypeScript Example**:
```markdown
#### TypeScript (Airbnb Style + React)
- Use TypeScript strict mode
- Follow Airbnb style guide conventions
- Prefer named exports over default exports
- Use functional components with hooks for React
- Imports: External → internal → relative (sorted within groups)
- Max line length: 100 characters

**Linting**: `make lint-ts` (runs ESLint)
**Formatting**: `make format-ts` (runs Prettier)
**Testing**: `make test-ts` (runs Vitest)
**Type Checking**: `make type-check-ts` (runs tsc)
```

### Step 9: Add .ai/docs/ Standards Documentation

Create comprehensive standards documentation:

**File**: `.ai/docs/<LANGUAGE>_STANDARDS.md`

**Python Example**:
```markdown
# Python Standards

**Purpose**: Python coding standards and best practices for this project

**Scope**: Code quality, style, testing, and type safety for Python code

**Overview**: Comprehensive Python development standards including linting rules, formatting style,
    naming conventions, import organization, testing conventions, and type annotation requirements.

---

## Linting Rules

### Ruff Configuration
- **Line length**: 100 characters
- **Target version**: Python 3.11+
- **Selected rules**: E, F, W, I, N, D, UP, S, B, A, C4, T20, SIM

### Rule Categories
- **E, F, W**: Core PEP 8 errors and warnings
- **I**: Import sorting (isort)
- **N**: Naming conventions (PEP 8)
- **D**: Docstring conventions (PEP 257)
- **UP**: Upgrade to newer Python syntax
- **S**: Security issues (Bandit)
- **B**: Bug detection (flake8-bugbear)
- **A**: Avoid shadowing builtins
- **C4**: Comprehension improvements
- **T20**: No print statements in production code
- **SIM**: Code simplification suggestions

## Formatting Style

### Black Configuration
- **Line length**: 100 characters
- **Target version**: Python 3.11
- **String quotes**: Double quotes (Black default)
- **Trailing commas**: Yes (for multi-line)

## Naming Conventions

- **Modules**: `lowercase_with_underscores.py`
- **Classes**: `PascalCase`
- **Functions**: `snake_case`
- **Variables**: `snake_case`
- **Constants**: `UPPER_CASE_WITH_UNDERSCORES`
- **Private**: `_leading_underscore`
- **Test files**: `test_*.py`
- **Test functions**: `test_*`

## Import Organization

1. Standard library imports
2. Third-party imports
3. Local application imports

Within each group, sorted alphabetically.

Example:
\`\`\`python
import os
import sys
from pathlib import Path

import pytest
import requests
from fastapi import FastAPI

from src.models import User
from src.utils import helper
\`\`\`

## Type Annotations

### Required
- All public function signatures
- Class attributes
- Module-level constants

### Type Checker
- **Tool**: mypy
- **Mode**: Strict
- **Ignore missing imports**: For third-party libraries without stubs

Example:
\`\`\`python
def process_data(input_file: Path, max_items: int = 100) -> list[dict[str, Any]]:
    """Process data from file."""
    results: list[dict[str, Any]] = []
    # Implementation
    return results
\`\`\`

## Testing Conventions

### pytest Configuration
- **Test directory**: `tests/`
- **Test file pattern**: `test_*.py`
- **Test function pattern**: `test_*`
- **Fixtures**: Use pytest fixtures for setup/teardown
- **Coverage**: Target 80%+ code coverage

### Test Structure
\`\`\`python
def test_feature_description():
    # Arrange
    input_data = create_test_data()

    # Act
    result = process_function(input_data)

    # Assert
    assert result == expected_value
\`\`\`

## Docstring Format

Use Google-style docstrings:

\`\`\`python
def calculate_total(items: list[float], tax_rate: float = 0.0) -> float:
    """Calculate total with optional tax.

    Args:
        items: List of item prices
        tax_rate: Tax rate as decimal (e.g., 0.08 for 8%)

    Returns:
        Total price including tax

    Raises:
        ValueError: If tax_rate is negative
    """
    if tax_rate < 0:
        raise ValueError("Tax rate cannot be negative")
    subtotal = sum(items)
    return subtotal * (1 + tax_rate)
\`\`\`
```

### Step 10: Update PLUGIN_MANIFEST.yaml

Add your plugin to the manifest:

**File**: `plugins/PLUGIN_MANIFEST.yaml`

**Go Example**:
```yaml
languages:
  go:
    status: community  # or 'stable' if officially supported
    description: Go development environment with linting, formatting, and testing
    location: plugins/languages/go/
    dependencies:
      - foundation/ai-folder

    options:
      linters:
        available: [golangci-lint, staticcheck, revive]
        recommended: golangci-lint
        description: Code quality and style checking

      formatters:
        available: [gofmt, goimports]
        recommended: goimports
        description: Automatic code formatting (goimports includes gofmt)

      testing:
        available: [testing, testify, ginkgo]
        recommended: testing
        description: Testing framework

    installation_guide: plugins/languages/go/AGENT_INSTRUCTIONS.md
```

**Rust Example**:
```yaml
languages:
  rust:
    status: community
    description: Rust development environment with linting, formatting, and testing
    location: plugins/languages/rust/
    dependencies:
      - foundation/ai-folder

    options:
      linters:
        available: [clippy]
        recommended: clippy
        description: Rust linter (official)

      formatters:
        available: [rustfmt]
        recommended: rustfmt
        description: Rust formatter (official)

      testing:
        available: [cargo-test]
        recommended: cargo-test
        description: Built-in Rust testing

    installation_guide: plugins/languages/rust/AGENT_INSTRUCTIONS.md
```

---

## File Structure Summary

A complete language plugin should have this structure:

```
plugins/languages/<language-name>/
├── AGENT_INSTRUCTIONS.md          # Main installation instructions
├── README.md                       # Human-readable plugin documentation
│
├── linters/                        # Linter options
│   ├── <linter1>/
│   │   ├── AGENT_INSTRUCTIONS.md
│   │   ├── config/
│   │   │   └── .<linter>rc
│   │   └── README.md
│   └── <linter2>/
│       ├── AGENT_INSTRUCTIONS.md
│       ├── config/
│       │   └── .<linter>rc
│       └── README.md
│
├── formatters/                     # Formatter options
│   ├── <formatter1>/
│   │   ├── AGENT_INSTRUCTIONS.md
│   │   ├── config/
│   │   │   └── .<formatter>rc
│   │   └── README.md
│   └── <formatter2>/
│       ├── AGENT_INSTRUCTIONS.md
│       ├── config/
│       │   └── .<formatter>rc
│       └── README.md
│
├── testing/                        # Test framework options
│   ├── <framework1>/
│   │   ├── AGENT_INSTRUCTIONS.md
│   │   ├── config/
│   │   │   └── <test-config>
│   │   └── README.md
│   └── <framework2>/
│       ├── AGENT_INSTRUCTIONS.md
│       ├── config/
│       │   └── <test-config>
│       └── README.md
│
├── templates/                      # Integration templates
│   ├── makefile-<language>.mk     # Makefile targets
│   ├── agents-md-snippet.md       # agents.md extension
│   ├── github-workflow-lint.yml   # CI/CD workflow
│   ├── example.<ext>              # Example code file
│   └── example.test.<ext>         # Example test file
│
└── standards/                      # Standards documentation
    └── <LANGUAGE>_STANDARDS.md    # Coding standards (also goes in .ai/docs/)
```

---

## Integration Points

### 1. Makefile Integration

Your plugin provides Makefile targets that users include:

**Pattern**:
```makefile
.PHONY: lint-<lang> format-<lang> test-<lang> <lang>-check

lint-<lang>:
	<linter-command>

format-<lang>:
	<formatter-command>

test-<lang>:
	<test-command>

<lang>-check: lint-<lang> test-<lang>
	@echo "✓ <Language> checks passed"
```

**Usage**:
```bash
make lint-python
make format-typescript
make test-go
make python-check  # Run all checks
```

### 2. agents.md Extension

Your plugin adds language-specific guidelines to `agents.md`:

**Location**: Between `### LANGUAGE_SPECIFIC_GUIDELINES` markers

**Format**:
```markdown
#### <Language> (<Style Guide>)
- Convention 1
- Convention 2
- Convention 3

**Linting**: `make lint-<lang>` (runs <tool>)
**Formatting**: `make format-<lang>` (runs <tool>)
**Testing**: `make test-<lang>` (runs <tool>)
```

### 3. CI/CD Integration

Provide GitHub Actions workflow template:

**File**: `templates/github-workflow-lint.yml`

**Python Example**:
```yaml
name: Python Lint & Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install ruff black pytest pytest-cov mypy

      - name: Lint with Ruff
        run: ruff check .

      - name: Check formatting with Black
        run: black --check .

      - name: Type check with mypy
        run: mypy .

      - name: Test with pytest
        run: pytest --cov=src --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
```

### 4. Pre-commit Hooks Integration

If the pre-commit-hooks plugin is present, provide hook configuration:

**Example**:
```yaml
# Add to .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: python-lint
        name: Lint Python code
        entry: make lint-python
        language: system
        pass_filenames: false
        files: \.py$

      - id: python-format
        name: Format Python code
        entry: make format-python
        language: system
        pass_filenames: false
        files: \.py$
```

### 5. Docker Integration

If Docker plugin is used, document runtime requirements:

**Example**:
```dockerfile
# Python runtime
FROM python:3.11-slim

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install dev tools
RUN pip install ruff black pytest mypy
```

---

## Testing Your Plugin

### Standalone Testing

Test your plugin works without the orchestrator:

```bash
# 1. Create test directory
mkdir -p /tmp/test-<language>-plugin
cd /tmp/test-<language>-plugin

# 2. Initialize git
git init

# 3. Install foundation plugin manually
# (Copy .ai/ structure, create AGENTS.md)

# 4. Install your language plugin
# Follow your AGENT_INSTRUCTIONS.md step-by-step

# 5. Verify all files created
ls -la  # Check config files present

# 6. Run linting
make lint-<lang>  # Should work without errors

# 7. Run formatting
make format-<lang>  # Should work without errors

# 8. Run tests (if example tests provided)
make test-<lang>  # Should pass or show expected output

# 9. Check AGENTS.md updated
grep "<Language>" AGENTS.md  # Should show your language section
```

### Integration Testing

Test your plugin with other plugins:

```bash
# Test with multiple language plugins
1. Install Python plugin
2. Install TypeScript plugin
3. Verify both work independently
4. Verify no conflicts in Makefile
5. Verify AGENTS.md has both sections
6. Run `make lint-python` and `make lint-ts`
```

### CI/CD Testing

Test GitHub Actions workflow:

```bash
# 1. Copy workflow to .github/workflows/
mkdir -p .github/workflows
cp templates/github-workflow-lint.yml .github/workflows/<language>-lint.yml

# 2. Push to GitHub
git add .github/workflows/<language>-lint.yml
git commit -m "Add <language> CI/CD workflow"
git push

# 3. Verify workflow runs on GitHub Actions tab
```

---

## Real Examples

### Python Plugin Reference

**Status**: Stable (defined in PLUGIN_MANIFEST.yaml)

**Location**: `plugins/languages/python/`

**Tools**:
- **Linters**: Ruff (recommended), Pylint, Flake8
- **Formatters**: Black (recommended), autopep8, yapf
- **Testing**: pytest (recommended), unittest
- **Type Checking**: mypy (recommended), pyright

**Key Files**:
- `linters/ruff/config/ruff.toml` - Comprehensive Ruff configuration
- `formatters/black/config/pyproject.toml` - Black formatting rules
- `testing/pytest/config/pyproject.toml` - pytest settings with coverage
- `templates/makefile-python.mk` - Python Make targets

**Pattern**: Shows how to handle multiple tool options with recommended defaults

### TypeScript Plugin Reference

**Status**: Stable (defined in PLUGIN_MANIFEST.yaml)

**Location**: `plugins/languages/typescript/`

**Tools**:
- **Linters**: ESLint (recommended), Biome
- **Formatters**: Prettier (recommended), Biome
- **Testing**: Vitest (recommended), Jest, Mocha
- **Frameworks**: React (recommended), Vue, none

**Key Files**:
- `linters/eslint/config/.eslintrc.json` - ESLint + TypeScript config
- `formatters/prettier/config/.prettierrc.json` - Prettier formatting rules
- `testing/vitest/config/vitest.config.ts` - Vitest configuration
- `templates/makefile-typescript.mk` - TypeScript Make targets

**Pattern**: Shows framework-specific options (React support)

---

## Common Patterns

### Pattern 1: Option-Based Installation

All language plugins follow this pattern:

```markdown
1. Ask user for preferences (linter/formatter/testing)
2. Follow sub-instructions for chosen tools
3. Install dependencies via package manager
4. Copy configuration files
5. Add Makefile targets
6. Extend agents.md
7. Validate installation
```

### Pattern 2: Consistent Naming

- **Directories**: `linters/`, `formatters/`, `testing/`, `templates/`, `standards/`
- **Make targets**: `lint-<lang>`, `format-<lang>`, `test-<lang>`, `<lang>-check`
- **Config files**: Use tool's standard naming (`.eslintrc.json`, `ruff.toml`, etc.)

### Pattern 3: Hierarchical Instructions

```
AGENT_INSTRUCTIONS.md (main)
  ├── linters/<tool1>/AGENT_INSTRUCTIONS.md
  ├── linters/<tool2>/AGENT_INSTRUCTIONS.md
  ├── formatters/<tool1>/AGENT_INSTRUCTIONS.md
  ├── formatters/<tool2>/AGENT_INSTRUCTIONS.md
  ├── testing/<tool1>/AGENT_INSTRUCTIONS.md
  └── testing/<tool2>/AGENT_INSTRUCTIONS.md
```

### Pattern 4: Configuration File Placement

- **Development tools** (linters, formatters, test frameworks): Repository root
- **Language-specific** (package.json, pyproject.toml, Cargo.toml): Repository root
- **CI/CD workflows**: `.github/workflows/`
- **Documentation**: `.ai/docs/`

### Pattern 5: Makefile Target Convention

```makefile
# Single-purpose targets
lint-<lang>:     # Run linter only
format-<lang>:   # Run formatter only
test-<lang>:     # Run tests only

# Composite target
<lang>-check:    # Run all quality checks (depends on lint + test)
```

---

## Best Practices

### Do's

✅ **Use recommended defaults** - Choose widely-adopted tools as recommended options

✅ **Provide multiple options** - Give users choice while suggesting best practices

✅ **Keep configs minimal** - Only include necessary rules, let tools use sensible defaults

✅ **Document tool choices** - Explain why each tool is recommended in AGENT_INSTRUCTIONS.md

✅ **Test configurations** - Verify configs work on real code before committing

✅ **Include examples** - Provide example code and test files that pass linting

✅ **Support latest versions** - Target current stable language versions

✅ **Make standalone** - Plugin must work without orchestrator

✅ **Follow conventions** - Use established file naming and directory structure

✅ **Version lock critical tools** - Specify minimum versions for consistency

### Parameter Best Practices

When implementing parameters in your plugin:

✅ **Always provide defaults** - Plugins must work without any parameters. Default INSTALL_PATH to `.` (current directory)

✅ **Document all parameters** - Include a Parameters section at the top of AGENT_INSTRUCTIONS.md with clear descriptions, defaults, and examples

✅ **Use meaningful names** - Follow UPPER_SNAKE_CASE convention. Use INSTALL_PATH not PATH or DIR

✅ **Test standalone mode** - The most important use case is standalone (no parameters). Test this first

✅ **Test with parameters** - Also test with INSTALL_PATH set to subdirectories like `backend/`, `src/`, etc.

✅ **Validate file locations** - In validation, check files are in INSTALL_PATH and NOT at root when using custom path

✅ **Consider composition** - Your plugin might be called by meta-plugins. Make sure it works when INSTALL_PATH is passed from upstream

✅ **Update all file operations** - Every file creation must use `"${INSTALL_PATH}/filename"` not just `filename`

✅ **Reference the standard** - Link to `.ai/docs/PLUGIN_PARAMETER_STANDARD.md` in your plugin's README for full parameter documentation

### Don'ts

❌ **Don't hardcode paths** - Use relative paths and standard locations

❌ **Don't assume project structure** - Work with common layouts (src/, tests/, etc.)

❌ **Don't create conflicts** - Ensure Makefile targets don't collide with other languages

❌ **Don't over-configure** - Avoid opinion overload, stick to essentials

❌ **Don't skip validation** - Always test installation steps before submitting

❌ **Don't forget dependencies** - Document all required tools and versions

❌ **Don't mix concerns** - Keep linter, formatter, and test configs separate

❌ **Don't duplicate docs** - Reference existing tool documentation instead of rewriting

❌ **Don't ignore edge cases** - Handle monorepos, multi-package projects, etc.

❌ **Don't break existing setups** - Check for existing configs before overwriting

---

## Troubleshooting

### Issue: Config file conflicts

**Symptom**: User already has `.eslintrc.json` or `ruff.toml`

**Solution**:
1. Detect existing config in AGENT_INSTRUCTIONS.md
2. Ask user if they want to backup existing and use plugin config
3. Provide merge instructions if they want to keep existing config

```markdown
### Step 2: Copy Configuration

Check if configuration already exists:
```bash
if [ -f .eslintrc.json ]; then
    echo "Existing .eslintrc.json found"
    read -p "Backup and replace? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv .eslintrc.json .eslintrc.json.backup
        cp plugins/languages/typescript/linters/eslint/config/.eslintrc.json ./
    fi
else
    cp plugins/languages/typescript/linters/eslint/config/.eslintrc.json ./
fi
```
```

### Issue: Package manager not found

**Symptom**: `pip: command not found` or `npm: command not found`

**Solution**: Document installation in Prerequisites section

```markdown
## Prerequisites

### Python Installation
If Python is not installed:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install python3 python3-pip

# macOS
brew install python@3.11

# Windows
# Download from https://www.python.org/downloads/
```
```

### Issue: Make targets don't work

**Symptom**: `make: lint-python: No such file or directory`

**Solution**: Verify Makefile has targets and tools are in PATH

```markdown
## Validation

Verify installation:
```bash
# Check Makefile has targets
grep "lint-python" Makefile

# Check tools are installed
which ruff
which black
which pytest

# If tools missing, install:
pip install ruff black pytest
```
```

### Issue: Tests fail in CI but pass locally

**Symptom**: GitHub Actions fails but `make test-<lang>` works locally

**Solution**: Check dependency installation in workflow

```yaml
# Ensure all dev dependencies installed
- name: Install dependencies
  run: |
    pip install -r requirements.txt
    pip install -r requirements-dev.txt  # Don't forget dev dependencies
```

### Issue: Linter reports different results on different machines

**Symptom**: Inconsistent linting results across environments

**Solution**: Lock tool versions in requirements file

```txt
# requirements-dev.txt
ruff==0.1.9
black==23.12.1
pytest==7.4.3
mypy==1.8.0
```

---

## Submitting Your Plugin

### Step 1: Create Feature Branch

```bash
git checkout -b feat/add-<language>-plugin
```

### Step 2: Commit Your Changes

```bash
# Add all plugin files
git add plugins/languages/<language>/

# Add manifest update
git add plugins/PLUGIN_MANIFEST.yaml

# Commit with descriptive message
git commit -m "feat(languages): Add <Language> plugin with <linter>/<formatter>/<test-framework>

- Add <Language> plugin directory structure
- Include <linter1>, <linter2> linter options
- Include <formatter1>, <formatter2> formatter options
- Include <framework1>, <framework2> test framework options
- Add Makefile integration targets
- Add agents.md extension snippet
- Add <LANGUAGE>_STANDARDS.md documentation
- Update PLUGIN_MANIFEST.yaml with <language> entry

Follows plugin template structure from plugins/languages/_template/
"
```

### Step 3: Push and Create PR

```bash
# Push to GitHub
git push -u origin feat/add-<language>-plugin

# Create PR via GitHub CLI
gh pr create --title "feat(languages): Add <Language> plugin" --body "$(cat <<'EOF'
## Summary
Adds <Language> language plugin with comprehensive tooling support.

## Changes
- ✅ <Language> plugin directory structure
- ✅ <Linter> linter with configuration
- ✅ <Formatter> formatter with configuration
- ✅ <Test Framework> test framework with configuration
- ✅ Makefile integration (`make lint-<lang>`, `make format-<lang>`, `make test-<lang>`)
- ✅ AGENTS.md extension snippet
- ✅ Standards documentation (`.ai/docs/<LANGUAGE>_STANDARDS.md`)
- ✅ GitHub Actions workflow template
- ✅ PLUGIN_MANIFEST.yaml entry

## Tools Supported
**Linters**: <linter1> (recommended), <linter2>, <linter3>
**Formatters**: <formatter1> (recommended), <formatter2>
**Testing**: <framework1> (recommended), <framework2>

## Testing
Tested standalone installation in clean directory:
- ✅ All configuration files created correctly
- ✅ Linting works (`make lint-<lang>`)
- ✅ Formatting works (`make format-<lang>`)
- ✅ Tests run (`make test-<lang>`)
- ✅ AGENTS.md updated correctly
- ✅ No conflicts with existing plugins

## Reference
Follows structure from `plugins/languages/_template/`
Pattern matches Python and TypeScript plugins

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Step 4: Address Review Feedback

Reviewers will check:
- ✅ Follows template structure
- ✅ AGENT_INSTRUCTIONS.md is clear and complete
- ✅ Configuration files use best practices
- ✅ Makefile targets follow naming convention
- ✅ Tested standalone (without orchestrator)
- ✅ Documentation is comprehensive
- ✅ No conflicts with existing plugins
- ✅ Manifest entry is correct

### Step 5: Merge and Celebrate!

Once approved and merged:
- Your plugin becomes available to all ai-projen users
- Orchestrators can discover and install it
- Community can use it as reference for similar languages

---

## Next Steps

After creating your language plugin:

1. **Test in real projects** - Use it to set up actual repositories
2. **Gather feedback** - Find pain points and improve
3. **Add advanced features** - Framework-specific support, additional tools
4. **Create infrastructure plugins** - Add Docker, CI/CD for your language
5. **Write blog post** - Share your experience creating the plugin
6. **Help others** - Review other community plugin PRs

---

## Additional Resources

### Documentation
- `PLUGIN_ARCHITECTURE.md` - Plugin structure requirements
- `PLUGIN_MANIFEST.yaml` - All available plugins
- `PLUGIN_DISCOVERY.md` - How orchestrators work
- `plugins/languages/_template/` - Boilerplate template

### Reference Implementations
- `plugins/languages/python/` - Python plugin (Ruff/Black/pytest)
- `plugins/languages/typescript/` - TypeScript plugin (ESLint/Prettier/Vitest)

### Community
- GitHub Issues - Ask questions, report problems
- GitHub Discussions - Share ideas, get help
- Pull Requests - Contribute improvements

---

**Questions?** Open an issue on GitHub or check existing language plugins for examples.

**Ready to contribute?** Follow this guide to add support for Go, Rust, Java, PHP, Ruby, or any other language!
