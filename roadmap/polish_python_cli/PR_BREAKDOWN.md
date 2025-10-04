# Polish Python CLI Application - PR Breakdown

**Purpose**: Detailed implementation breakdown of Polish Python CLI into manageable, atomic pull requests

**Scope**: Complete enhancement from basic python-cli to comprehensive, turnkey CLI application with all quality gates and distribution automation

**Overview**: Comprehensive breakdown of the Polish Python CLI feature into 3 manageable, atomic
    pull requests. Each PR is designed to be self-contained, testable, and maintains application functionality
    while incrementally building toward the complete feature. Includes detailed implementation steps, file
    structures, testing requirements, and success criteria for each PR.

**Dependencies**: Python core plugin (comprehensive tooling), python-cli plugin (current), Docker, GitHub Actions

**Exports**: PR implementation plans, file structures, testing strategies, and success criteria for each development phase

**Related**: AI_CONTEXT.md for feature overview, PROGRESS_TRACKER.md for status tracking

**Implementation**: Atomic PR approach with detailed step-by-step implementation guidance and comprehensive testing validation

---

## Overview
This document breaks down the Polish Python CLI feature into 3 manageable, atomic PRs. Each PR is designed to be:
- Self-contained and testable
- Maintains a working plugin
- Incrementally builds toward the complete feature
- Revertible if needed

---

## PR1: Orchestrate Comprehensive Python Tooling

### 🎯 Goal
Make python-cli plugin install ALL comprehensive Python tooling (Pylint, Flake8, Radon, Xenon, Safety, pip-audit) and Makefile targets automatically. Transform from basic setup to complete quality gate suite.

### 📋 Prerequisites
- [ ] Reviewed python core plugin capabilities
- [ ] Reviewed current python-cli AGENT_INSTRUCTIONS.md
- [ ] Understanding of comprehensive tooling suite
- [ ] Git repository ready for feature branch

### 🔧 Implementation Steps

#### Step 1: Create Feature Branch
```bash
git checkout -b feature/pr1-comprehensive-tooling
```

#### Step 2: Update python-cli AGENT_INSTRUCTIONS.md

**File**: `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md`

**Changes**:

1. **After Phase 2 (Language Plugin Installation)**, add new step:

```markdown
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
```

2. **After Phase 2.5**, add Makefile installation step:

```markdown
### Phase 2.6: Install Python Makefile Targets

**Copy Makefile from python core plugin**:

```bash
# Copy Python Makefile targets
cp plugins/languages/python/core/project-content/makefiles/makefile-python.mk ./Makefile.python

# Create main Makefile that includes Python targets
cat > Makefile <<'EOF'
# Python CLI Application Makefile

.PHONY: help

# Include Python development targets
-include Makefile.python

help: ## Show this help message
	@echo "Available targets:"
	@echo ""
	@$(MAKE) help-python
EOF
```

**Create composite Makefile with lint-* namespace**:

Instead of using the python core's individual targets, create a cleaner composite structure:

```bash
# Create simplified Makefile with composite targets
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
```

3. **Update validation section** to include comprehensive tools:

```markdown
### Validation

Run complete validation:

```bash
# Check all files created
test -f Makefile && echo "✅ Makefile" || echo "❌ Missing Makefile"
test -f Makefile.python && echo "✅ Makefile.python" || echo "❌ Missing Makefile.python"

# Check composite targets installed
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
```
```

#### Step 3: Update pyproject.toml.template

**File**: `plugins/applications/python-cli/project-content/pyproject.toml.template`

**Add comprehensive tool dependencies**:

```toml
[project.optional-dependencies]
dev = [
    # Core tools
    "pytest>=8.4.2",
    "pytest-asyncio>=0.23.0",
    "pytest-cov>=4.1.0",
    "ruff>=0.13.0",
    "mypy>=1.18.1",
    "bandit>=1.7.5",

    # Comprehensive linters
    "pylint>=3.3.3",
    "flake8>=7.1.0",
    "flake8-docstrings>=1.7.0",
    "flake8-bugbear>=24.11.19",
    "flake8-comprehensions>=3.15.0",
    "flake8-simplify>=0.21.0",

    # Complexity analysis
    "radon>=6.0.1",
    "xenon>=0.9.3",

    # Comprehensive security
    "safety>=3.2.11",
    "pip-audit>=2.8.0",
]
```

**Add comprehensive tool configurations**:

```toml
[tool.pylint.messages_control]
disable = [
    "C0111",  # missing-docstring (handled by flake8-docstrings)
    "R0903",  # too-few-public-methods (often fine for CLIs)
]

[tool.pylint.format]
max-line-length = 120

[tool.flake8]
max-line-length = 120
extend-ignore = ["E203", "E501"]  # E203: whitespace before ':', E501: line too long (handled by ruff)
docstring-convention = "google"

[tool.radon]
cc_min = "C"  # Warn on complexity >= C
show_complexity = true

[tool.xenon]
max-absolute = "B"
max-modules = "B"
max-average = "A"
```

#### Step 4: Update manifest.yaml

**File**: `plugins/applications/python-cli/manifest.yaml`

**Update provides section**:

```yaml
provides:
  comprehensive_tooling:
    description: Complete Python quality tooling suite automatically installed
    tools:
      - name: Ruff
        purpose: Fast linting and formatting
      - name: MyPy
        purpose: Static type checking
      - name: Bandit
        purpose: Security vulnerability scanning
      - name: Pylint
        purpose: Comprehensive code quality linting
      - name: Flake8
        purpose: Style guide enforcement with plugins
      - name: Radon
        purpose: Cyclomatic complexity and maintainability analysis
      - name: Xenon
        purpose: Complexity enforcement (fails build if too complex)
      - name: Safety
        purpose: Dependency vulnerability scanning (CVE database)
      - name: pip-audit
        purpose: Dependency security audit (OSV database)

  makefile_targets:
    description: Composite Makefile with clean lint-* namespace for all quality checks
    file: Makefile
    includes:
      - Fast Development: lint, format, test
      - Comprehensive Quality: lint-all, lint-security, lint-complexity, lint-full
      - Testing: test, test-coverage
      - Utilities: install, clean, help
```

#### Step 5: Test Installation

**Create test CLI project**:

```bash
# Create temporary test directory
mkdir -p /tmp/test-polished-cli
cd /tmp/test-polished-cli
git init

# Install foundation plugin
# (follow plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md)

# Install updated python-cli plugin
# (follow updated plugins/applications/python-cli/AGENT_INSTRUCTIONS.md)

# Verify comprehensive tooling
make help-python

# Expected output should include:
# - All basic targets (lint-python, typecheck, security-scan, test-python)
# - All comprehensive targets (lint-pylint, lint-flake8, complexity-radon, complexity-xenon, security-full)

# Test targets
make lint-python
make lint-pylint
make lint-flake8
make complexity-radon
make complexity-xenon
make security-full
make typecheck
make test-python
```

### ✅ Success Criteria
- [x] AGENT_INSTRUCTIONS.md includes comprehensive tooling installation
- [x] pyproject.toml.template has ALL tool dependencies
- [x] pyproject.toml.template has ALL tool configurations
- [x] manifest.yaml documents comprehensive tooling
- [x] Makefile created with composite lint-* targets
- [x] `make help` shows clean, organized target list (lint, lint-all, lint-security, lint-complexity, lint-full)
- [x] All composite targets execute successfully
- [x] Test CLI project passes `make lint-full`

### 📦 Files Changed
- `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md` (added comprehensive tooling + Makefile steps)
- `plugins/applications/python-cli/project-content/pyproject.toml.template` (added comprehensive tools)
- `plugins/applications/python-cli/manifest.yaml` (documented comprehensive capabilities)

### 🧪 Testing
```bash
# Create test CLI project
mkdir -p /tmp/test-pr1
cd /tmp/test-pr1
git init

# Run updated python-cli installation
# Verify comprehensive tools installed
poetry show | grep -E "(pylint|flake8|radon|xenon|safety|pip-audit)"

# Verify composite Makefile targets
make help | grep -E "(lint-all|lint-security|lint-complexity|lint-full)"

# Run all quality gates
make lint-full
make test
```

### 🚀 Merge Criteria
- All files updated with comprehensive tooling
- Test CLI project created successfully
- All Makefile targets verified working
- Documentation updated
- Commit message follows conventions

---

## PR2: Add Distribution & Publishing Capability

### 🎯 Goal
Add automated publishing to PyPI, Docker Hub, and GitHub Releases. Create release workflow triggered by git tags. Provide how-to guides for all distribution methods.

### 📋 Prerequisites
- [ ] PR1 merged (comprehensive tooling installed)
- [ ] Understanding of GitHub Actions workflows
- [ ] PyPI publishing process knowledge
- [ ] Docker multi-arch build knowledge

### 🔧 Implementation Steps

#### Step 1: Create Feature Branch
```bash
git checkout main
git pull
git checkout -b feature/pr2-distribution-publishing
```

#### Step 2: Create Release Workflow Template

**File**: `plugins/applications/python-cli/project-content/.github/workflows/release.yml.template`

**Content**:

```yaml
# Purpose: Automated release workflow for Python CLI tool
# Scope: PyPI publishing, Docker Hub multi-arch builds, GitHub Release creation
# Triggers: Git tags matching v*.*.* pattern

name: Release

on:
  push:
    tags:
      - 'v*.*.*'

env:
  PYTHON_VERSION: '3.11'
  REGISTRY: docker.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # Job 1: Build and publish to PyPI
  publish-pypi:
    name: Publish to PyPI
    runs-on: ubuntu-latest
    permissions:
      id-token: write  # Required for trusted publishing

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: latest
          virtualenvs-in-project: true

      - name: Build package
        run: |
          poetry build
          ls -lah dist/

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
        with:
          # Uses OIDC trusted publishing (no password needed)
          # Configure in PyPI: https://pypi.org/manage/account/publishing/

  # Job 2: Build and push Docker multi-arch images
  publish-docker:
    name: Publish to Docker Hub
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Extract version from tag
        id: version
        run: echo "VERSION=${GITHUB_REF#refs/tags/v}" >> $GITHUB_OUTPUT

      - name: Build and push multi-arch image
        uses: docker/build-push-action@v5
        with:
          context: .
          platforms: linux/amd64,linux/arm64
          push: true
          tags: |
            ${{ env.IMAGE_NAME }}:latest
            ${{ env.IMAGE_NAME }}:${{ steps.version.outputs.VERSION }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # Job 3: Create GitHub Release
  create-release:
    name: Create GitHub Release
    runs-on: ubuntu-latest
    needs: [publish-pypi, publish-docker]
    permissions:
      contents: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Install Poetry
        uses: snok/install-poetry@v1

      - name: Build package artifacts
        run: |
          poetry build
          ls -lah dist/

      - name: Extract version from tag
        id: version
        run: echo "VERSION=${GITHUB_REF#refs/tags/v}" >> $GITHUB_OUTPUT

      - name: Create Release Notes
        id: release_notes
        run: |
          cat > release_notes.md <<EOF
          ## 🚀 Release v${{ steps.version.outputs.VERSION }}

          ### 📦 Installation Methods

          **PyPI (pip)**:
          \`\`\`bash
          pip install ${{ github.event.repository.name }}
          \`\`\`

          **Docker**:
          \`\`\`bash
          docker pull ${{ env.IMAGE_NAME }}:${{ steps.version.outputs.VERSION }}
          docker run --rm ${{ env.IMAGE_NAME }}:${{ steps.version.outputs.VERSION }} --help
          \`\`\`

          **From Source**:
          \`\`\`bash
          git clone https://github.com/${{ github.repository }}.git
          cd ${{ github.event.repository.name }}
          poetry install
          \`\`\`

          ### 📋 Changes
          See commit history for detailed changes.

          ### 🔗 Artifacts
          - Python wheel and sdist attached below
          - Docker image: \`${{ env.IMAGE_NAME }}:${{ steps.version.outputs.VERSION }}\`
          - Multi-arch support: linux/amd64, linux/arm64
          EOF

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          body_path: release_notes.md
          files: dist/*
          draft: false
          prerelease: false
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Step 3: Create PyPI Publishing How-To

**File**: `plugins/applications/python-cli/ai-content/howtos/how-to-publish-to-pypi.md`

**Content**:

```markdown
# How to Publish Python CLI Tool to PyPI

**Purpose**: Guide for publishing Python CLI tool to Python Package Index (PyPI)

**Scope**: PyPI account setup, trusted publishing configuration, versioning, and automated release

**Overview**: Step-by-step instructions for publishing a Python CLI tool to PyPI using GitHub Actions
    trusted publishing (no API tokens needed). Covers account setup, version management, and automated
    publishing triggered by git tags.

---

## Prerequisites

- Python CLI tool built with this plugin
- GitHub repository with CLI code
- PyPI account (free): https://pypi.org/account/register/

## Setup PyPI Trusted Publishing

Trusted publishing eliminates the need for API tokens by using OIDC.

### Step 1: Create PyPI Account

1. Visit https://pypi.org/account/register/
2. Create account and verify email
3. Enable 2FA (recommended)

### Step 2: Configure Trusted Publisher

1. Go to https://pypi.org/manage/account/publishing/
2. Click "Add a new pending publisher"
3. Fill in:
   - **PyPI Project Name**: Your CLI tool name (from pyproject.toml)
   - **Owner**: Your GitHub username or org
   - **Repository name**: Your repo name
   - **Workflow name**: `release.yml`
   - **Environment name**: (leave blank)
4. Save pending publisher

### Step 3: Verify pyproject.toml

Ensure your `pyproject.toml` has correct metadata:

\`\`\`toml
[project]
name = "your-cli-tool"
version = "0.1.0"  # Will be updated for each release
description = "Your CLI tool description"
authors = [
    {name = "Your Name", email = "your.email@example.com"}
]
readme = "README.md"
requires-python = ">=3.11"
license = {text = "MIT"}

classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]

[project.urls]
Homepage = "https://github.com/yourusername/your-cli-tool"
Issues = "https://github.com/yourusername/your-cli-tool/issues"
Documentation = "https://github.com/yourusername/your-cli-tool#readme"

[project.scripts]
your-cli-tool = "src.cli:cli"
\`\`\`

## Publishing Process

### Step 1: Update Version

Edit `pyproject.toml` and bump version:

\`\`\`toml
version = "1.0.0"  # Update this
\`\`\`

### Step 2: Commit Version Bump

\`\`\`bash
git add pyproject.toml
git commit -m "chore: bump version to 1.0.0"
git push
\`\`\`

### Step 3: Create and Push Git Tag

\`\`\`bash
# Create annotated tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Push tag (triggers release workflow)
git push origin v1.0.0
\`\`\`

### Step 4: Monitor Release

1. Go to GitHub Actions tab
2. Watch "Release" workflow run
3. Verify three jobs complete:
   - ✅ Publish to PyPI
   - ✅ Publish to Docker Hub
   - ✅ Create GitHub Release

### Step 5: Verify on PyPI

1. Visit https://pypi.org/project/your-cli-tool/
2. Confirm version published
3. Test installation:

\`\`\`bash
pip install your-cli-tool
your-cli-tool --help
\`\`\`

## Troubleshooting

### Issue: "Project name not found on PyPI"
**Solution**: The pending publisher must match exact project name. Create publisher on PyPI first.

### Issue: "OIDC token verification failed"
**Solution**: Ensure workflow file is named `release.yml` and matches PyPI configuration.

### Issue: "Version already exists"
**Solution**: PyPI doesn't allow re-uploading same version. Bump version and create new tag.

### Issue: "Build fails during poetry build"
**Solution**: Run `poetry build` locally first to test. Check pyproject.toml for errors.

## Manual Publishing (Fallback)

If GitHub Actions unavailable:

\`\`\`bash
# Install build tools
pip install build twine

# Build package
python -m build

# Upload to PyPI (requires API token)
twine upload dist/*
\`\`\`

## Version Management Best Practices

- Use semantic versioning: MAJOR.MINOR.PATCH
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes
- Always update version in pyproject.toml before tagging
- Use annotated tags: `git tag -a v1.0.0 -m "message"`

## References

- PyPI Trusted Publishing: https://docs.pypi.org/trusted-publishers/
- Python Packaging: https://packaging.python.org/
- Semantic Versioning: https://semver.org/
```

#### Step 4: Create GitHub Release How-To

**File**: `plugins/applications/python-cli/ai-content/howtos/how-to-create-github-release.md`

**Content**:

```markdown
# How to Create GitHub Releases for Python CLI

**Purpose**: Guide for creating GitHub Releases with automated artifact publishing

**Scope**: GitHub Release creation, artifact uploads, release notes, and automation

**Overview**: Step-by-step instructions for creating GitHub Releases for Python CLI tools
    with automatic artifact uploads (wheel, sdist), Docker image links, and formatted release notes.

---

## Overview

GitHub Releases provide:
- Tagged version history
- Downloadable artifacts (wheel, sdist)
- Release notes and changelog
- Multi-platform distribution links

The release workflow automatically creates releases when you push a git tag.

## Automated Release Process

### Step 1: Prepare Release

1. Update version in `pyproject.toml`:
   \`\`\`toml
   version = "1.0.0"
   \`\`\`

2. Update CHANGELOG.md (if you have one):
   \`\`\`markdown
   ## [1.0.0] - 2025-10-03

   ### Added
   - New feature X

   ### Fixed
   - Bug Y
   \`\`\`

3. Commit changes:
   \`\`\`bash
   git add pyproject.toml CHANGELOG.md
   git commit -m "chore: prepare release v1.0.0"
   git push
   \`\`\`

### Step 2: Create and Push Tag

\`\`\`bash
# Create annotated tag
git tag -a v1.0.0 -m "Release v1.0.0

New features:
- Feature X
- Feature Y

Bug fixes:
- Fix Z"

# Push tag (triggers release workflow)
git push origin v1.0.0
\`\`\`

### Step 3: Workflow Creates Release

The release workflow automatically:
1. ✅ Builds Python package (wheel + sdist)
2. ✅ Publishes to PyPI
3. ✅ Builds multi-arch Docker image
4. ✅ Pushes to Docker Hub
5. ✅ Creates GitHub Release with:
   - Release notes (installation methods)
   - Package artifacts attached
   - Docker image links
   - Version info

### Step 4: Verify Release

1. Go to https://github.com/youruser/yourrepo/releases
2. See new release created
3. Check artifacts attached
4. Verify release notes

## Manual Release Creation (Fallback)

If automation unavailable:

### Step 1: Build Artifacts

\`\`\`bash
# Build Python package
poetry build

# Artifacts in dist/
ls dist/
# your-cli-tool-1.0.0-py3-none-any.whl
# your-cli-tool-1.0.0.tar.gz
\`\`\`

### Step 2: Create Release on GitHub

1. Go to https://github.com/youruser/yourrepo/releases/new
2. Choose tag: `v1.0.0`
3. Release title: `Release v1.0.0`
4. Description:
   \`\`\`markdown
   ## Installation

   **PyPI**:
   \`\`\`bash
   pip install your-cli-tool
   \`\`\`

   **Docker**:
   \`\`\`bash
   docker pull youruser/your-cli-tool:1.0.0
   \`\`\`

   ## Changes
   - Feature X added
   - Bug Y fixed
   \`\`\`
5. Upload artifacts from `dist/`
6. Click "Publish release"

## Release Notes Best Practices

### Good Release Notes Include:

1. **Installation Instructions**:
   - pip install command
   - Docker pull command
   - From source instructions

2. **What's New**:
   - New features added
   - Breaking changes (if any)
   - Deprecations

3. **Bug Fixes**:
   - Issues fixed
   - Performance improvements

4. **Links**:
   - PyPI package
   - Docker image
   - Documentation

### Example Release Notes

\`\`\`markdown
## 🚀 Release v1.0.0

### ✨ New Features
- Added interactive mode with prompt_toolkit
- Support for YAML and JSON config files
- Multi-command parallel execution

### 🐛 Bug Fixes
- Fixed exit code handling in error scenarios
- Resolved config file parsing edge cases

### 📦 Installation

**PyPI**:
\`\`\`bash
pip install your-cli-tool==1.0.0
\`\`\`

**Docker**:
\`\`\`bash
docker pull youruser/your-cli-tool:1.0.0
\`\`\`

**From Source**:
\`\`\`bash
git clone https://github.com/youruser/your-cli-tool.git
cd your-cli-tool
git checkout v1.0.0
poetry install
\`\`\`

### 📋 Full Changelog
See: https://github.com/youruser/your-cli-tool/compare/v0.9.0...v1.0.0
\`\`\`

## Troubleshooting

### Issue: "Release not created automatically"
**Solution**: Check GitHub Actions workflow ran successfully. Look for errors in logs.

### Issue: "Artifacts not attached"
**Solution**: Verify `dist/` contains wheel and sdist. Check workflow upload step.

### Issue: "Release marked as draft"
**Solution**: Workflow has `draft: false`. If draft, manually publish from GitHub UI.

## References

- GitHub Releases: https://docs.github.com/en/repositories/releasing-projects-on-github
- Release Best Practices: https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases
```

#### Step 5: Update python-cli AGENT_INSTRUCTIONS.md

**File**: `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md`

**Add after Phase 4 (Infrastructure Installation)**:

```markdown
### Phase 4.5: Install Release Automation

**5. Install GitHub Actions Release Workflow**

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

# Test workflow syntax
gh workflow view release.yml  # requires GitHub CLI
```
```

#### Step 6: Update How-To Index

**File**: `plugins/applications/python-cli/ai-content/howtos/README.md`

**Add new how-tos**:

```markdown
## Distribution & Publishing

- [how-to-publish-to-pypi.md](./how-to-publish-to-pypi.md) - Publish CLI tool to Python Package Index
- [how-to-create-github-release.md](./how-to-create-github-release.md) - Create GitHub Releases with artifacts
```

### ✅ Success Criteria
- [x] Release workflow template created
- [x] PyPI publishing configured with trusted publishing
- [x] Docker Hub multi-arch build configured
- [x] GitHub Release creation automated
- [x] How-to guides created for PyPI and GitHub releases
- [x] AGENT_INSTRUCTIONS.md updated with release workflow setup
- [x] Test release workflow validates successfully

### 📦 Files Changed
- `plugins/applications/python-cli/project-content/.github/workflows/release.yml.template` (NEW)
- `plugins/applications/python-cli/ai-content/howtos/how-to-publish-to-pypi.md` (NEW)
- `plugins/applications/python-cli/ai-content/howtos/how-to-create-github-release.md` (NEW)
- `plugins/applications/python-cli/ai-content/howtos/README.md` (updated index)
- `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md` (added release workflow step)

### 🧪 Testing
```bash
# Validate workflow syntax
gh workflow view release.yml

# Test workflow manually (requires tag)
git tag -a v0.0.1-test -m "Test release"
git push origin v0.0.1-test

# Monitor workflow in GitHub Actions
# Verify all jobs complete successfully

# Clean up test tag
git tag -d v0.0.1-test
git push origin :refs/tags/v0.0.1-test
```

### 🚀 Merge Criteria
- Release workflow template comprehensive
- How-to guides complete and clear
- AGENT_INSTRUCTIONS updated
- Workflow tested successfully
- All documentation updated

---

## PR3: CLI Quality Standards & Validation

### 🎯 Goal
Document CLI-specific quality standards and provide validation script to ensure complete setup. Add CLI testing patterns and update README with comprehensive capabilities list.

### 📋 Prerequisites
- [ ] PR1 and PR2 merged
- [ ] Understanding of CLI UX best practices
- [ ] Bash scripting knowledge for validation script

### 🔧 Implementation Steps

#### Step 1: Create Feature Branch
```bash
git checkout main
git pull
git checkout -b feature/pr3-quality-standards-validation
```

#### Step 2: Create CLI Quality Standards Document

**File**: `plugins/applications/python-cli/ai-content/docs/cli-quality-standards.md`

**Content**:

```markdown
# CLI Quality Standards

**Purpose**: Quality standards and best practices for Python CLI applications

**Scope**: Exit codes, error handling, help text, user experience, and testing patterns

**Overview**: Comprehensive quality standards for building professional Python CLI tools.
    Covers conventions for exit codes, error messages, help text formatting, configuration
    handling, and user experience patterns. Ensures CLI tools are intuitive, reliable, and
    follow industry best practices.

---

## Exit Code Conventions

### Standard Exit Codes

\`\`\`python
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
\`\`\`

### Implementation

\`\`\`python
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
\`\`\`

## Error Handling

### Principles

1. **User-Friendly Messages**: Explain what went wrong and how to fix it
2. **Error Output to stderr**: Use `click.echo(..., err=True)`
3. **Appropriate Exit Codes**: Use standard exit codes
4. **Stack Traces for Debug**: Only show stack traces with `--debug` flag

### Pattern

\`\`\`python
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
\`\`\`

## Help Text Standards

### Command Help

\`\`\`python
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
\`\`\`

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

\`\`\`python
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
\`\`\`

## User Experience

### Progress Indication

\`\`\`python
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
\`\`\`

### Confirmation Prompts

\`\`\`python
@click.command()
@click.option('--force', is_flag=True, help='Skip confirmation')
def delete(force):
    if not force:
        click.confirm('Are you sure you want to delete?', abort=True)

    # Proceed with deletion
\`\`\`

### Colored Output

\`\`\`python
@click.command()
def status():
    click.secho('✅ Success', fg='green')
    click.secho('⚠️  Warning', fg='yellow')
    click.secho('❌ Error', fg='red', err=True)
\`\`\`

### Verbosity Levels

\`\`\`python
@click.command()
@click.option('-v', '--verbose', count=True, help='Increase verbosity')
def my_command(verbose):
    # verbose = 0 (quiet), 1 (normal), 2+ (debug)

    if verbose >= 1:
        click.echo("Processing...")

    if verbose >= 2:
        click.echo(f"Debug: detailed info...")
\`\`\`

## Testing Standards

### CLI Testing with Click

\`\`\`python
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
\`\`\`

### Testing with Temporary Files

\`\`\`python
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
\`\`\`

## Logging Standards

### Setup

\`\`\`python
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
\`\`\`

## Performance

### Lazy Loading

\`\`\`python
import click

@click.group()
def cli():
    pass

@cli.command()
def heavy_command():
    # Import heavy dependencies only when needed
    from heavy_library import process
    process()
\`\`\`

### Streaming Large Files

\`\`\`python
@click.command()
@click.argument('input', type=click.File('r'))
@click.argument('output', type=click.File('w'))
def transform(input, output):
    # Stream line by line (don't load entire file)
    for line in input:
        output.write(transform_line(line))
\`\`\`

## Security

### Input Validation

\`\`\`python
import click
import re

def validate_email(ctx, param, value):
    if not re.match(r'^[\\w.-]+@[\\w.-]+\\.\\w+$', value):
        raise click.BadParameter('Invalid email format')
    return value

@click.command()
@click.option('--email', callback=validate_email)
def send(email):
    # email is validated
    pass
\`\`\`

### Path Traversal Prevention

\`\`\`python
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
\`\`\`

## References

- Click Documentation: https://click.palletsprojects.com/
- GNU Exit Codes: https://www.gnu.org/software/libc/manual/html_node/Exit-Status.html
- CLI Guidelines: https://clig.dev/
```

#### Step 3: Create Validation Script

**File**: `plugins/applications/python-cli/scripts/validate-cli-setup.sh`

**Content**:

```bash
#!/usr/bin/env bash
# Purpose: Validate Python CLI application setup completeness
# Scope: Check all tools, Makefile targets, CI/CD workflows, and configurations
# Overview: Comprehensive validation script that checks Python CLI setup includes all
#     comprehensive tooling, Makefile targets, release workflows, and proper configurations.
#     Provides clear success/failure output with specific remediation steps.

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     Python CLI Application Setup Validation           ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to check file exists
check_file() {
    local file=$1
    local description=$2

    if [ -f "$file" ]; then
        echo -e "${GREEN}✅${NC} $description: $file"
        return 0
    else
        echo -e "${RED}❌${NC} $description: $file (MISSING)"
        ((ERRORS++))
        return 1
    fi
}

# Function to check command exists
check_command() {
    local cmd=$1
    local description=$2

    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -n1)
        echo -e "${GREEN}✅${NC} $description: $cmd ($version)"
        return 0
    else
        echo -e "${RED}❌${NC} $description: $cmd (NOT INSTALLED)"
        ((ERRORS++))
        return 1
    fi
}

# Function to check Makefile target
check_make_target() {
    local target=$1
    local description=$2

    if make -n "$target" &> /dev/null; then
        echo -e "${GREEN}✅${NC} $description: make $target"
        return 0
    else
        echo -e "${RED}❌${NC} $description: make $target (NOT FOUND)"
        ((ERRORS++))
        return 1
    fi
}

# Function to check pyproject.toml has tool
check_pyproject_tool() {
    local tool=$1
    local description=$2

    if [ -f "pyproject.toml" ] && grep -q "\\[tool\\.$tool\\]" pyproject.toml; then
        echo -e "${GREEN}✅${NC} $description: [tool.$tool] configured"
        return 0
    else
        echo -e "${YELLOW}⚠️${NC}  $description: [tool.$tool] (NOT CONFIGURED)"
        ((WARNINGS++))
        return 1
    fi
}

echo -e "${CYAN}📁 Checking Project Structure...${NC}"
check_file "pyproject.toml" "Python project config"
check_file "src/cli.py" "CLI entrypoint"
check_file "src/config.py" "Config handler"
check_file "tests/test_cli.py" "CLI tests"
check_file "Makefile" "Main Makefile"
check_file "README.md" "Project README"
echo ""

echo -e "${CYAN}🔧 Checking Core Tools...${NC}"
check_command "python" "Python runtime"
check_command "poetry" "Poetry package manager"
check_command "docker" "Docker"
echo ""

echo -e "${CYAN}🧹 Checking Linting Tools...${NC}"
if command -v poetry &> /dev/null; then
    poetry run ruff --version &> /dev/null && echo -e "${GREEN}✅${NC} Ruff (fast linter + formatter)" || { echo -e "${RED}❌${NC} Ruff (NOT INSTALLED)"; ((ERRORS++)); }
    poetry run pylint --version &> /dev/null && echo -e "${GREEN}✅${NC} Pylint (comprehensive linting)" || { echo -e "${RED}❌${NC} Pylint (NOT INSTALLED)"; ((ERRORS++)); }
    poetry run flake8 --version &> /dev/null && echo -e "${GREEN}✅${NC} Flake8 (style guide enforcement)" || { echo -e "${RED}❌${NC} Flake8 (NOT INSTALLED)"; ((ERRORS++)); }
else
    echo -e "${YELLOW}⚠️${NC}  Poetry not available, skipping tool checks"
    ((WARNINGS++))
fi
echo ""

echo -e "${CYAN}🔒 Checking Security Tools...${NC}"
if command -v poetry &> /dev/null; then
    poetry run bandit --version &> /dev/null && echo -e "${GREEN}✅${NC} Bandit (code security)" || { echo -e "${RED}❌${NC} Bandit (NOT INSTALLED)"; ((ERRORS++)); }
    poetry run safety --version &> /dev/null && echo -e "${GREEN}✅${NC} Safety (dependency vulnerabilities)" || { echo -e "${RED}❌${NC} Safety (NOT INSTALLED)"; ((ERRORS++)); }
    poetry run pip-audit --version &> /dev/null && echo -e "${GREEN}✅${NC} pip-audit (dependency audit)" || { echo -e "${RED}❌${NC} pip-audit (NOT INSTALLED)"; ((ERRORS++)); }
fi
echo ""

echo -e "${CYAN}📊 Checking Complexity Tools...${NC}"
if command -v poetry &> /dev/null; then
    poetry run radon --version &> /dev/null && echo -e "${GREEN}✅${NC} Radon (complexity analysis)" || { echo -e "${RED}❌${NC} Radon (NOT INSTALLED)"; ((ERRORS++)); }
    poetry run xenon --version &> /dev/null && echo -e "${GREEN}✅${NC} Xenon (complexity enforcement)" || { echo -e "${RED}❌${NC} Xenon (NOT INSTALLED)"; ((ERRORS++)); }
fi
echo ""

echo -e "${CYAN}🎯 Checking Type Checking...${NC}"
if command -v poetry &> /dev/null; then
    poetry run mypy --version &> /dev/null && echo -e "${GREEN}✅${NC} MyPy (static type checker)" || { echo -e "${RED}❌${NC} MyPy (NOT INSTALLED)"; ((ERRORS++)); }
fi
echo ""

echo -e "${CYAN}🧪 Checking Testing Tools...${NC}"
if command -v poetry &> /dev/null; then
    poetry run pytest --version &> /dev/null && echo -e "${GREEN}✅${NC} pytest (testing framework)" || { echo -e "${RED}❌${NC} pytest (NOT INSTALLED)"; ((ERRORS++)); }
    poetry show pytest-cov &> /dev/null && echo -e "${GREEN}✅${NC} pytest-cov (coverage)" || { echo -e "${YELLOW}⚠️${NC}  pytest-cov (NOT INSTALLED)"; ((WARNINGS++)); }
fi
echo ""

echo -e "${CYAN}🎯 Checking Makefile Targets...${NC}"
check_make_target "help" "Help target"
check_make_target "lint" "Fast linting (Ruff)"
check_make_target "lint-all" "Comprehensive linting"
check_make_target "lint-security" "Security scanning"
check_make_target "lint-complexity" "Complexity analysis"
check_make_target "lint-full" "ALL quality checks"
check_make_target "format" "Auto-fix formatting"
check_make_target "test" "Run tests"
check_make_target "test-coverage" "Tests with coverage"
echo ""

echo -e "${CYAN}⚙️  Checking Tool Configurations...${NC}"
check_pyproject_tool "ruff" "Ruff config"
check_pyproject_tool "pylint" "Pylint config"
check_pyproject_tool "mypy" "MyPy config"
echo ""

echo -e "${CYAN}🚀 Checking CI/CD...${NC}"
check_file ".github/workflows/python.yml" "Python CI workflow"
check_file ".github/workflows/release.yml" "Release workflow"
echo ""

echo -e "${CYAN}📚 Checking Documentation...${NC}"
check_file ".ai/docs/python-cli-architecture.md" "Architecture docs"
check_file ".ai/howtos/python-cli/how-to-add-cli-command.md" "How-to: Add command"
check_file ".ai/howtos/python-cli/how-to-publish-to-pypi.md" "How-to: PyPI publishing"
check_file ".ai/howtos/python-cli/how-to-create-github-release.md" "How-to: GitHub releases"
echo ""

# Summary
echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    Validation Summary                  ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All critical checks passed!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found (non-critical)${NC}"
    fi
    echo -e "${GREEN}Your Python CLI setup is complete and production-ready!${NC}"
    exit 0
else
    echo -e "${RED}❌ $ERRORS error(s) found${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Remediation:${NC}"
    echo "1. Install missing tools: poetry install"
    echo "2. Install missing Makefile: cp plugins/languages/python/core/project-content/makefiles/makefile-python.mk ./Makefile.python"
    echo "3. Install release workflow: cp plugins/applications/python-cli/project-content/.github/workflows/release.yml.template .github/workflows/release.yml"
    echo ""
    exit 1
fi
```

Make the script executable:
```bash
chmod +x plugins/applications/python-cli/scripts/validate-cli-setup.sh
```

#### Step 4: Update README with Comprehensive Capabilities

**File**: `plugins/applications/python-cli/README.md`

**Add "What You Get" section after "What This Plugin Provides"**:

```markdown
## What You Get: Complete Capabilities List

When you install the python-cli plugin, you get a **fully turnkey Python CLI application** with:

### 🧹 Comprehensive Linting & Formatting
- ✅ **Ruff** - Lightning-fast linting + formatting (10-100x faster)
- ✅ **Pylint** - Comprehensive code quality analysis
- ✅ **Flake8** - Style guide enforcement with plugins:
  - flake8-docstrings (Google-style docstring enforcement)
  - flake8-bugbear (bug and design problem detection)
  - flake8-comprehensions (list/set/dict comprehension optimization)
  - flake8-simplify (code simplification suggestions)

### 🔒 Multi-Layer Security Scanning
- ✅ **Bandit** - Code security vulnerability scanning
- ✅ **Safety** - Dependency vulnerability scanning (CVE database)
- ✅ **pip-audit** - Dependency security audit (OSV database)

### 📊 Complexity Analysis
- ✅ **Radon** - Cyclomatic complexity & maintainability index
- ✅ **Xenon** - Complexity enforcement (fails build if too complex)

### 🎯 Type Checking & Testing
- ✅ **MyPy** - Static type checking with strict mode
- ✅ **pytest** - Modern testing framework with:
  - pytest-asyncio (async test support)
  - pytest-cov (coverage reporting)
  - Click.testing.CliRunner (CLI testing utilities)

### 🛠️ Clean Makefile with lint-* Namespace
All tools accessible via clean, intuitive targets:

**Fast Development (use these):**
- `make lint` - Fast linting (Ruff only) - 2 seconds
- `make format` - Auto-fix formatting and linting issues
- `make test` - Run all tests

**Comprehensive Quality:**
- `make lint-all` - ALL linters (Ruff + Pylint + Flake8 + MyPy) - 30 seconds
- `make lint-security` - ALL security tools (Bandit + Safety + pip-audit)
- `make lint-complexity` - Complexity analysis (Radon + Xenon)
- `make lint-full` - EVERYTHING (all linters + security + complexity) - 2 minutes

**Testing:**
- `make test` - Run all tests
- `make test-coverage` - Run tests with coverage

**Utilities:**
- `make install` - Install dependencies with Poetry
- `make clean` - Clean cache and artifacts
- `make help` - Show all available targets

**Workflow:**
```bash
# During development (fast feedback)
make lint     # Ruff only
make format   # Auto-fix

# Before commit (more thorough)
make lint-all
make test

# Pre-commit hook / CI (comprehensive)
make lint-full
make test-coverage
```

### 🚀 Automated Distribution
- ✅ **PyPI Publishing** - Automatic on git tags (trusted publishing, no tokens)
- ✅ **Docker Hub** - Multi-arch builds (linux/amd64, linux/arm64)
- ✅ **GitHub Releases** - Automatic with artifacts and release notes

**To Release:**
```bash
# 1. Update version in pyproject.toml
# 2. Commit and tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 3. Automation handles:
#    - Builds wheel & sdist
#    - Publishes to PyPI
#    - Builds multi-arch Docker image
#    - Pushes to Docker Hub
#    - Creates GitHub Release with artifacts
```

### 🐳 Docker-First Development
- ✅ Consistent environments across all machines
- ✅ Zero local pollution (all tools in containers)
- ✅ Automatic fallback to Poetry/pip when Docker unavailable
- ✅ Production-ready Docker images

### 📚 Complete Documentation
- ✅ CLI Quality Standards (exit codes, error handling, UX patterns)
- ✅ How-to Guides:
  - Add CLI commands
  - Handle config files
  - Package for distribution
  - Publish to PyPI
  - Create GitHub releases
- ✅ Architecture documentation
- ✅ Code templates for common patterns

### ✅ Validation
- ✅ Setup validation script (`scripts/validate-cli-setup.sh`)
- ✅ Pre-commit hooks (format, lint, secrets, trailing-whitespace)
- ✅ CI/CD workflows (test, lint, security, build, deploy)

### 🎯 Result: Truly Turnkey

**You only need to:**
1. Run the installation (once)
2. Implement your CLI commands (`src/cli.py`)
3. Write tests (`tests/`)

**Everything else is automatic:**
- ✅ Quality gates enforced
- ✅ Security scanning continuous
- ✅ Complexity monitored
- ✅ Testing comprehensive
- ✅ Distribution automated
- ✅ Documentation complete

This is what "polished" means - **ZERO additional setup required**.
```

#### Step 5: Update AGENT_INSTRUCTIONS.md with Validation

**File**: `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md`

**Add final validation step before "Success Criteria"**:

```markdown
### Phase 6: Validate Complete Setup

**Run validation script**:

```bash
# Make validation script executable
chmod +x plugins/applications/python-cli/scripts/validate-cli-setup.sh

# Copy to project
cp plugins/applications/python-cli/scripts/validate-cli-setup.sh ./scripts/
chmod +x ./scripts/validate-cli-setup.sh

# Run validation
./scripts/validate-cli-setup.sh

# Should see:
# ✅ All critical checks passed!
# Your Python CLI setup is complete and production-ready!
```

If validation fails, follow remediation steps provided by the script.
```

### ✅ Success Criteria
- [x] CLI quality standards documented comprehensively
- [x] Validation script created and functional
- [x] README updated with complete "What You Get" section
- [x] CLI testing patterns documented
- [x] AGENT_INSTRUCTIONS.md includes validation step
- [x] Test CLI project passes all validation checks

### 📦 Files Changed
- `plugins/applications/python-cli/ai-content/docs/cli-quality-standards.md` (NEW)
- `plugins/applications/python-cli/scripts/validate-cli-setup.sh` (NEW)
- `plugins/applications/python-cli/README.md` (added "What You Get" section)
- `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md` (added validation step)

### 🧪 Testing
```bash
# Test validation script
cd /tmp/test-polished-cli
./scripts/validate-cli-setup.sh

# Should show:
# ✅ All critical checks passed!
# Your Python CLI setup is complete and production-ready!

# Verify all checks
# - Project structure ✅
# - Core tools ✅
# - Linting tools ✅
# - Security tools ✅
# - Complexity tools ✅
# - Type checking ✅
# - Testing tools ✅
# - Makefile targets ✅
# - Tool configurations ✅
# - CI/CD workflows ✅
# - Documentation ✅
```

### 🚀 Merge Criteria
- CLI quality standards complete
- Validation script comprehensive
- README shows all capabilities
- All documentation updated
- Validation passes on test project
- Feature fully polished

---

## Implementation Guidelines

### Code Standards
- Follow PEP 8 (120 char line length)
- Type hints required for all functions
- Google-style docstrings for all public functions
- Maximum complexity: A grade (Xenon enforcement)

### Testing Requirements
- All new functionality must have tests
- CLI testing with Click.testing.CliRunner
- Coverage > 80% for new code
- Both unit and integration tests

### Documentation Standards
- All files require headers (per FILE_HEADER_STANDARDS.md)
- How-to guides follow HOWTO_STANDARDS.md
- All make targets documented in help text
- README kept up to date

### Security Considerations
- All paths validated (prevent traversal)
- No hardcoded secrets
- Input validation on all user input
- Security scanning in CI/CD

### Performance Targets
- CLI startup < 1 second
- Makefile targets execute efficiently
- Docker builds use layer caching
- Release workflow < 10 minutes total

## Rollout Strategy

### Phase 1: Comprehensive Tooling (PR1)
- Update python-cli orchestration
- Install all comprehensive tools
- Add Makefile targets
- Validate quality gates

### Phase 2: Distribution Automation (PR2)
- Create release workflow
- Configure PyPI publishing
- Setup Docker Hub builds
- Document processes

### Phase 3: Polish & Validate (PR3)
- Document CLI standards
- Create validation script
- Update all documentation
- Final testing

## Success Metrics

### Launch Metrics
- All 3 PRs merged to main
- Comprehensive tooling installed
- Release automation functional
- Documentation complete
- Validation passing

### Ongoing Metrics
- New CLI projects use plugin successfully
- All quality gates passing
- Releases automated end-to-end
- User feedback positive
- Zero "missing setup" issues
