# Python CLI Application - Agent Instructions

**Purpose**: Installation instructions for AI agents to set up Python CLI application with Click framework

**Scope**: Complete installation of Python CLI application with all dependencies and tooling

**Overview**: Step-by-step instructions for installing a complete Python CLI application with Click framework,
    Docker packaging, configuration management, and comprehensive testing. This meta-plugin orchestrates
    the installation of foundation, language, infrastructure, and standards plugins, then adds a production-ready
    CLI starter application with example commands, config handling, and distribution tools.

**Prerequisites**: Empty or existing repository with git initialized

---

## Installation Approach: Roadmap-Based (REQUIRED)

**CRITICAL**: This meta-plugin installation MUST use a roadmap-based approach.

**Why?**
- Meta-plugin installations are complex (6 phases, 7+ plugin installations)
- Agents tend to rush, skip phases, or take shortcuts when given all phases at once
- Breaking into separate PRs prevents shortcuts and ensures systematic execution

**How it works:**

### Step 1: Create Installation Roadmap (PR0)

**Your task RIGHT NOW is to create the roadmap, not execute the full installation.**

1. Calculate parameter values:
   ```bash
   # Extract repository name from target path
   REPO_NAME=$(basename "${TARGET_REPO_PATH}")  # e.g., "my-cli-tool"
   APP_NAME="${REPO_NAME}"                      # CLI tools use simple name

   # Calculate installation paths
   INSTALL_PATH="."

   echo "✅ Parameters calculated:"
   echo "   APP_NAME: ${APP_NAME}"
   echo "   INSTALL_PATH: ${INSTALL_PATH}"
   ```

2. Create roadmap files from templates:
   ```bash
   mkdir -p .roadmap/python-cli-install

   # Copy all three roadmap templates
   cp .ai/templates/roadmap-meta-plugin-installation.md.template \
      .roadmap/python-cli-install/PROGRESS_TRACKER.md

   cp .ai/templates/roadmap-pr-breakdown.md.template \
      .roadmap/python-cli-install/PR_BREAKDOWN.md

   cp .ai/templates/roadmap-ai-context.md.template \
      .roadmap/python-cli-install/AI_CONTEXT.md
   ```

3. Fill in template variables using sed:
   ```bash
   # PROGRESS_TRACKER.md - Metadata variables
   sed -i "s|{{PLUGIN_NAME}}|python-cli|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{TOTAL_PLUGINS}}|7|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{TOTAL_PRS}}|7|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{TARGET_REPO_PATH}}|${TARGET_REPO_PATH}|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PROJECT_NAME}}|${APP_NAME}|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{INSTALL_PATH}}|${INSTALL_PATH}|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md

   # PROGRESS_TRACKER.md - PR Titles and Notes (python-cli specific)
   sed -i "s|{{PR0_TITLE}}|Create roadmap|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR1_TITLE}}|Install foundation/ai-folder plugin|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR1_NOTES}}|Creates .ai/ structure|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR2_TITLE}}|Install Python plugin|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR2_NOTES}}|Creates pyproject.toml|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR3_TITLE}}|Install Docker + CI/CD plugins|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR3_NOTES}}|Creates docker-compose.yml|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR4_TITLE}}|Install security, docs, pre-commit plugins|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR4_NOTES}}|Sets up quality gates|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR5_TITLE}}|Copy CLI code, configure, install deps|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR5_NOTES}}|Installs app code|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR6_PHASE}}|Finalization|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR6_TITLE}}|Validate setup, create AGENTS.md|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR6_NOTES}}|Final validation|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md

   # PR_BREAKDOWN.md variables
   sed -i "s|{{FEATURE_NAME}}|python-cli installation|g" .roadmap/python-cli-install/PR_BREAKDOWN.md
   sed -i "s|{{TOTAL_PRS}}|7|g" .roadmap/python-cli-install/PR_BREAKDOWN.md
   sed -i "s|{{PROJECT_NAME}}|${APP_NAME}|g" .roadmap/python-cli-install/PR_BREAKDOWN.md

   # AI_CONTEXT.md - Fill all placeholders
   sed -i "s|{{FEATURE_NAME}}|python-cli installation|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{FEATURE_SCOPE}}|Complete installation of Python CLI application with all dependencies|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{FEATURE_OVERVIEW}}|Systematic installation of python-cli meta-plugin via 7 sequential PRs|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{DEPENDENCIES_LIST}}|ai-projen framework, Git, Python 3.11+, Docker, Poetry. See pyproject.toml for Python package dependencies.|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{EXPORTS_DESCRIPTION}}|Production-ready Python CLI application with Click, Docker, CI/CD, testing|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{ADDITIONAL_RELATIONS}}||g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{IMPLEMENTATION_APPROACH}}|Roadmap-based meta-plugin installation|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{DETAILED_OVERVIEW}}|The python-cli installation creates a complete CLI application infrastructure with Click framework, comprehensive testing, linting, security scanning, Docker packaging, and CI/CD automation. Installation proceeds through 7 PRs: Planning, Foundation, Languages, Infrastructure, Standards, Application, Finalization.|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{PROJECT_BACKGROUND}}|Installing python-cli meta-plugin for ${APP_NAME} project|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{FEATURE_VISION_POINTS}}|Professional CLI application with Click, comprehensive tooling (Ruff, pytest, mypy), Docker packaging, CI/CD automation, security scanning, pre-commit hooks|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{CURRENT_APP_CONTEXT}}|Initial setup - no application code exists yet|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{CORE_COMPONENTS}}|CLI entrypoint (src/cli.py), configuration handler (src/config.py), test suite (tests/), Docker setup, CI/CD workflows|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{USER_JOURNEY_STEPS}}|1. Install via pip or Docker 2. Run CLI commands 3. Configure via YAML/JSON 4. Extend with new commands|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{ADDITIONAL_ARCHITECTURE_SECTION}}||g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{KEY_DECISIONS_SECTIONS}}|Click framework (mature, decorator-based), Poetry (isolated deps), Ruff (fast linting), Docker (cross-platform distribution)|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{EXISTING_FEATURE_INTEGRATIONS}}|None - initial setup|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{ADDITIONAL_INTEGRATION_SECTIONS}}||g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{SUCCESS_METRICS}}|All PRs complete, validation passes, CLI runs, tests pass, Docker builds|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{TECHNICAL_CONSTRAINTS}}|Python 3.11+ required, Poetry required, Docker required, Git required|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{PRIMARY_ACTION}}|executing PRs|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{PRIMARY_ACTION_GUIDANCE}}|Execute ONE PR at a time, validate, update tracker, commit, then STOP|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{SECONDARY_ACTION}}|following plugin instructions|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{SECONDARY_ACTION_GUIDANCE}}|Read entire AGENT_INSTRUCTIONS.md before starting, follow steps sequentially, validate after each step|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{COMMON_PATTERNS}}|State detection before changes, branching before installation, validation after installation, Make target organization|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{RISK_MITIGATION_STRATEGIES}}|Roadmap prevents shortcuts, Poetry prevents system corruption, validation gates ensure completeness, Git branches enable rollback|g" .roadmap/python-cli-install/AI_CONTEXT.md
   sed -i "s|{{FUTURE_ENHANCEMENTS}}|Post-installation: develop CLI commands, add language-specific features, integrate with other tools|g" .roadmap/python-cli-install/AI_CONTEXT.md

   echo "✅ Template variables replaced with calculated values"
   ```

4. Initialize PR status dashboard and remove unused rows:
   ```bash
   # Mark PR0 as complete (we just did it!)
   sed -i "s|{{PR0_STATUS}}|✅ Complete|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md

   # Mark PRs 1-6 as not started
   sed -i "s|{{PR1_STATUS}}|🔴 Not Started|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR2_STATUS}}|🔴 Not Started|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR3_STATUS}}|🔴 Not Started|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR4_STATUS}}|🔴 Not Started|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR5_STATUS}}|🔴 Not Started|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i "s|{{PR6_STATUS}}|🔴 Not Started|g" .roadmap/python-cli-install/PROGRESS_TRACKER.md

   # Remove PR7 and PR8 rows (python-cli only has 7 PRs: PR0-PR6)
   sed -i '/| PR7 |/d' .roadmap/python-cli-install/PROGRESS_TRACKER.md
   sed -i '/| PR8 |/d' .roadmap/python-cli-install/PROGRESS_TRACKER.md

   echo "✅ PR status dashboard initialized"
   ```

5. Commit roadmap:
   ```bash
   git add .roadmap/python-cli-install/
   git commit -m "chore: Create roadmap for python-cli installation"
   ```

7. Inform user:
   ```
   ✅ Roadmap created at: .roadmap/python-cli-install/

   Three-document structure created:
   - PROGRESS_TRACKER.md (primary handoff - current status and next PR)
   - PR_BREAKDOWN.md (detailed PR implementation steps)
   - AI_CONTEXT.md (installation context and architecture)

   Next steps:
   1. Review PROGRESS_TRACKER.md to understand the installation plan
   2. Execute one PR at a time by requesting: "Execute PR1 from roadmap"
   3. Each PR will install one phase and update the roadmap
   ```

### Step 2: User Executes PRs One at a Time

User will request execution like:
- "Execute PR1 from .roadmap/python-cli-install"
- "Execute PR2 from .roadmap/python-cli-install"
- etc.

Each PR execution:
1. Agent reads PROGRESS_TRACKER.md
2. Checks "Next PR to Implement" section
3. Executes ONLY that PR's instructions
4. Validates completion
5. Updates PROGRESS_TRACKER.md (mark PR complete, update "Next PR")
6. Commits and merges PR branch
7. STOPS - does NOT continue to next PR

**DO NOT execute multiple PRs in one session.**

---

## Important: Creating Atemporal AGENTS.md (PR6)

When creating AGENTS.md in PR6, follow these rules to avoid temporal information:

**❌ NEVER include temporal language**:
- "will be added after PR5"
- "currently supports"
- "planned for future"
- "coming soon"
- Specific dependency versions

**✅ ALWAYS use atemporal references**:
- Reference configuration files: "See `pyproject.toml` for Python dependencies managed by Poetry"
- Reference directories generically: "See `.ai/howtos/python-cli/` for guides"
- Avoid listing specific files unless they're guaranteed to exist
- Point to package manifests as source of truth for dependencies

**Example - External Dependencies Section**:
```markdown
### External Dependencies
See `pyproject.toml` for the complete and authoritative list of Python dependencies managed by Poetry.
```

**NOT**:
```markdown
### External Dependencies
- **Click**: CLI framework - https://click.palletsprojects.com/
- **Ruff**: Linting - https://docs.astral.sh/ruff/
```

Dependencies change frequently. Always point to the package manifest (pyproject.toml, package.json, Cargo.toml) as the source of truth.

---

## Roadmap PR Breakdown

When creating the roadmap, ensure it includes these PRs:

- **PR0**: Planning (create roadmap) - YOU DO THIS NOW
- **PR1**: Foundation (install ai-folder plugin)
- **PR2**: Languages (install Python plugin)
- **PR3**: Infrastructure (install Docker + CI/CD plugins)
- **PR4**: Standards (install security, docs, pre-commit plugins)
- **PR5**: Application (copy CLI code, configure, install dependencies)
- **PR6**: Finalization (validate setup, create AGENTS.md)

**Note**: Python-cli has NO optional features. All PRs are required.

---

## If You Are Being Asked to "Install python-cli Plugin"

**STOP. You should NOT execute the full installation in one go.**

Instead, your task is:
1. **Create the roadmap** (PR0 instructions above)
2. **Calculate parameters** (TARGET_REPO_PATH, APP_NAME)
3. **Create PROGRESS_TRACKER.md**
4. **Inform user to execute PRs one at a time**

The detailed phase instructions below are for REFERENCE ONLY. They will be executed incrementally via the roadmap PRs, not all at once.

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

---

## Detailed Phase Instructions (For Roadmap PR Execution Only)

**NOTE**: These instructions are used by individual roadmap PRs. Do NOT execute all phases in one session.

When executing a specific PR from the roadmap, follow only that PR's phase instructions below.

---

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

### Phase 2.5: Install Comprehensive Python Tooling Suite

**Follow**: `plugins/languages/python/core/AGENT_INSTRUCTIONS.md` Step 11 (Comprehensive Tooling)

**What Gets Installed**:
- **Additional Linters**: Pylint (comprehensive code quality), Flake8 + plugins (style guide + docstrings, bugbear, comprehensions, simplify)
- **Complexity Analysis**: Radon (cyclomatic complexity, maintainability index), Xenon (complexity enforcement)
- **Comprehensive Security**: Safety (CVE database), pip-audit (OSV database)

**Installation**:
```bash
# Using Poetry (recommended)
poetry add --group dev \
  pylint \
  flake8 flake8-docstrings flake8-bugbear flake8-comprehensions flake8-simplify \
  radon xenon \
  safety pip-audit
```

**Validation**:
```bash
# Check all tools installed
poetry run pylint --version
poetry run flake8 --version
poetry run radon --version
poetry run xenon --version
poetry run safety --version
poetry run pip-audit --version
```

### Phase 2.6: Install Python Makefile Targets

**Create composite Makefile with clean lint-* namespace**:

```bash
# Create Makefile with composite targets for clean organization
cat > Makefile <<'EOF'
# Python CLI Application Makefile
# Composite lint-* targets for clean namespace

.PHONY: help lint lint-all lint-security lint-complexity lint-full format test test-coverage install clean

help: ## Show available targets
	@echo "Available targets:"
	@echo "  make lint              - Fast linting (Ruff)"
	@echo "  make lint-all          - Comprehensive linting (Ruff + Pylint + Flake8 + MyPy)"
	@echo "  make lint-security     - Security scanning (Bandit + Safety + pip-audit)"
	@echo "  make lint-complexity   - Complexity analysis (Radon + Xenon)"
	@echo "  make lint-full         - ALL quality checks"
	@echo "  make format            - Auto-fix formatting and linting issues"
	@echo "  make test              - Run tests"
	@echo "  make test-coverage     - Run tests with coverage"
	@echo "  make install           - Install dependencies"
	@echo "  make clean             - Clean cache and artifacts"

lint: ## Fast linting (Ruff - use during development)
	@echo "Running fast linting (Ruff)..."
	@poetry run ruff check src/ tests/
	@poetry run ruff format --check src/ tests/

lint-all: ## Comprehensive linting (Ruff + Pylint + Flake8 + MyPy)
	@echo "Running comprehensive linting..."
	@poetry run ruff check src/ tests/
	@poetry run ruff format --check src/ tests/
	@poetry run pylint src/
	@poetry run flake8 src/ tests/
	@poetry run mypy src/

lint-security: ## Security scanning (Bandit + Safety + pip-audit)
	@echo "Running security scans..."
	@poetry run bandit -r src/ -q
	@poetry run safety check --json || true
	@poetry run pip-audit || true

lint-complexity: ## Complexity analysis (Radon + Xenon)
	@echo "Analyzing code complexity..."
	@poetry run radon cc src/ -a -s
	@poetry run radon mi src/ -s
	@poetry run xenon --max-absolute B --max-modules B --max-average A src/

lint-full: lint-all lint-security lint-complexity ## ALL quality checks
	@echo "✅ All linting checks complete!"

format: ## Auto-fix formatting and linting issues
	@poetry run ruff format src/ tests/
	@poetry run ruff check --fix src/ tests/

test: ## Run tests
	@poetry run pytest -v

test-coverage: ## Run tests with coverage
	@poetry run pytest --cov=src --cov-report=term --cov-report=html -v

install: ## Install dependencies
	@poetry install

clean: ## Clean cache and artifacts
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@rm -rf htmlcov/ .coverage 2>/dev/null || true
	@echo "✓ Cleaned cache and artifacts"
EOF
```

**Validation**:
```bash
# Verify Makefile targets available
make help

# Should show composite targets:
# - lint (fast - Ruff only)
# - lint-all (comprehensive - all linters + MyPy)
# - lint-security (Bandit + Safety + pip-audit)
# - lint-complexity (Radon + Xenon)
# - lint-full (everything)
# - format, test, test-coverage, install, clean
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

### Phase 4.5: Install Release Automation

**8. Install GitHub Actions Release Workflow**

**Copy release workflow**:
```bash
mkdir -p .github/workflows
cp plugins/applications/python-cli/project-content/.github/workflows/release.yml.template .github/workflows/release.yml

# Customize for your repository
sed -i 's/{{PROJECT_NAME}}/my-cli-tool/g' .github/workflows/release.yml
```

**Configure GitHub Secrets** (if using Docker Hub):
1. Go to GitHub repository Settings → Secrets → Actions
2. Add secrets:
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password/token

**Configure PyPI Trusted Publishing**:
1. Visit https://pypi.org/manage/account/publishing/
2. Add pending publisher:
   - PyPI Project Name: (your CLI tool name)
   - Owner: (your GitHub username)
   - Repository: (your repo name)
   - Workflow: `release.yml`

**Validation**:
```bash
test -f .github/workflows/release.yml && echo "✅ Release workflow" || echo "❌ Missing release workflow"

# Test workflow syntax (requires GitHub CLI)
gh workflow view release.yml || echo "GitHub CLI not installed - skip syntax check"
```

### Phase 5: Application-Specific Installation

**9. Copy Application Starter Code**

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

**10. Copy Application Documentation**

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

**11. Configure Application**

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

**12. Install Dependencies with Poetry**

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

**13. Update .ai/index.yaml**

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
test -f Makefile && echo "✅ Makefile" || echo "❌ Missing Makefile"
test -f docker-compose.cli.yml && echo "✅ Docker compose" || echo "❌ Missing docker-compose.cli.yml"
test -d .github/workflows && echo "✅ CI/CD workflows" || echo "❌ Missing .github/workflows/"
test -f .ai/howtos/python-cli/README.md && echo "✅ Application how-tos" || echo "❌ Missing how-tos"

# Check composite Makefile targets installed
make help | grep -q "lint-all" && echo "✅ lint-all target" || echo "❌ Missing lint-all"
make help | grep -q "lint-security" && echo "✅ lint-security target" || echo "❌ Missing lint-security"
make help | grep -q "lint-complexity" && echo "✅ lint-complexity target" || echo "❌ Missing lint-complexity"
make help | grep -q "lint-full" && echo "✅ lint-full target" || echo "❌ Missing lint-full"

# Run composite quality checks (may fail on starter code - that's expected)
make lint              # Fast linting (Ruff)
make lint-all          # All linters (Ruff + Pylint + Flake8 + MyPy)
make lint-security     # All security tools (Bandit + Safety + pip-audit)
make lint-complexity   # Complexity analysis (Radon + Xenon)
make lint-full         # EVERYTHING
make test              # pytest tests

# Run CLI tool
python -m src.cli hello --name "Test"

# Should see: Hello, Test!

# Run tests
pytest -v

# Should see: All tests passing
```

### Phase 6: Validate Complete Setup

**Run validation script**:

```bash
# Make validation script executable
chmod +x plugins/applications/python-cli/scripts/validate-cli-setup.sh

# Copy to project
mkdir -p ./scripts
cp plugins/applications/python-cli/scripts/validate-cli-setup.sh ./scripts/
chmod +x ./scripts/validate-cli-setup.sh

# Run validation
./scripts/validate-cli-setup.sh

# Should see:
# ✅ All critical checks passed!
# Your Python CLI setup is complete and production-ready!
```

If validation fails, follow remediation steps provided by the script.

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
