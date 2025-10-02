# Pre-commit Hooks Plugin - Agent Instructions

**Purpose**: Installation and configuration guide for AI agents implementing pre-commit hooks in Docker-first development projects

**Scope**: Git hooks for automated code quality enforcement, branch protection, security scanning, and Docker-integrated linting

**Overview**: Step-by-step instructions for AI agents to install and configure the Pre-commit Hooks Plugin
    with dynamic language detection. This plugin provides automated code quality enforcement through
    pre-commit and pre-push hooks that execute in Docker containers. Features branch protection (no
    direct commits to main), auto-fix capabilities, language-specific linting (Python: ruff, flake8,
    mypy, pylint, bandit; TypeScript: ESLint, Prettier, type checking), and security scanning. Dynamically
    detects project languages and configures appropriate hooks. Integrates with Docker-first development
    pattern for consistent execution environments.

**Dependencies**: Git repository, Docker, Docker Compose, optionally pre-commit framework, Python or TypeScript language plugins

**Exports**: .pre-commit-config.yaml, pre-commit hook installation, Docker-integrated linting workflows

**Related**: plugins/languages/python (Python linting tools), plugins/languages/typescript (TypeScript linting), plugins/infrastructure/containerization/docker (Docker execution), plugins/standards/security (security scanning)

**Implementation**: Template-based installation with dynamic language detection and Docker container integration

---

## Prerequisites

Before installing this plugin, verify:

1. **Git Repository Initialized**
   ```bash
   git rev-parse --git-dir >/dev/null 2>&1 && echo "✓ Git repository" || echo "✗ Initialize git first"
   ```

2. **Docker and Docker Compose Running**
   ```bash
   docker ps >/dev/null 2>&1 && echo "✓ Docker running" || echo "✗ Start Docker first"
   docker compose version >/dev/null 2>&1 && echo "✓ Docker Compose available" || echo "✗ Install Docker Compose"
   ```

3. **Makefile with Linting Targets**
   ```bash
   grep -q "lint-fix:" Makefile && echo "✓ Makefile has lint targets" || echo "✗ Add lint targets to Makefile"
   ```

4. **Optional: Pre-commit Framework**
   ```bash
   command -v pre-commit >/dev/null 2>&1 && echo "✓ Pre-commit installed" || echo "ℹ Install with: pip install pre-commit"
   ```

---

## Installation Steps

### Step 1: Detect Project Languages

Detect which languages are present in the project:

```bash
# Detect Python
if [ -f pyproject.toml ] || [ -f requirements.txt ] || [ -f setup.py ] || [ -d app ]; then
  echo "✓ Python project detected"
  HAS_PYTHON=true
else
  echo "ℹ No Python project detected"
  HAS_PYTHON=false
fi

# Detect TypeScript/JavaScript
if [ -f package.json ] || [ -f tsconfig.json ] || [ -d frontend ]; then
  echo "✓ TypeScript/JavaScript project detected"
  HAS_TYPESCRIPT=true
else
  echo "ℹ No TypeScript/JavaScript project detected"
  HAS_TYPESCRIPT=false
fi

# Detect Docker containers
if [ -f docker-compose.yml ] || [ -f docker-compose.yaml ]; then
  echo "✓ Docker Compose configuration found"
  HAS_DOCKER=true
else
  echo "ℹ No Docker Compose configuration found"
  HAS_DOCKER=false
fi
```

### Step 2: Copy Pre-commit Configuration Template

Copy the pre-commit configuration template to the project root:

```bash
# Copy template
cp plugins/standards/pre-commit-hooks/ai-content/templates/.pre-commit-config.yaml.template .pre-commit-config.yaml

echo "✓ Created .pre-commit-config.yaml"
```

### Step 3: Configure Dynamic Language Detection

The template supports dynamic language detection. Review and customize based on detected languages:

```bash
# The template automatically detects:
# - Python files (*.py) and runs Python linters if present
# - TypeScript files (*.ts, *.tsx) and runs TypeScript linters if present
# - Docker containers for linting execution

echo "✓ Pre-commit configuration supports:"
[ "$HAS_PYTHON" = true ] && echo "  - Python linting (ruff, flake8, mypy, pylint, bandit, xenon)"
[ "$HAS_TYPESCRIPT" = true ] && echo "  - TypeScript linting (ESLint, Prettier, type checking, stylelint)"
echo "  - Branch protection (no commits to main)"
echo "  - Auto-fix capabilities"
echo "  - Docker container execution"
```

### Step 4: Install Pre-commit Framework

Install the pre-commit framework:

```bash
# Install pre-commit (Python required)
if command -v pip >/dev/null 2>&1; then
  pip install pre-commit
  echo "✓ Installed pre-commit framework"
elif command -v pip3 >/dev/null 2>&1; then
  pip3 install pre-commit
  echo "✓ Installed pre-commit framework"
else
  echo "✗ Python pip not found. Install Python first."
  exit 1
fi

# Verify installation
pre-commit --version
```

### Step 5: Install Git Hooks

Install the pre-commit and pre-push hooks:

```bash
# Install pre-commit hooks
pre-commit install
echo "✓ Installed pre-commit hooks"

# Install pre-push hooks
pre-commit install --hook-type pre-push
echo "✓ Installed pre-push hooks"

# Verify installation
ls -la .git/hooks/pre-commit .git/hooks/pre-push
```

### Step 6: Configure Docker Linting Containers

Ensure Docker linting containers are configured in docker-compose.yml:

```bash
# Check for linting container configuration
if grep -q "python-linter" docker-compose.yml 2>/dev/null; then
  echo "✓ Python linting container configured"
else
  echo "ℹ Add Python linting container to docker-compose.yml if needed"
fi

if grep -q "js-linter" docker-compose.yml 2>/dev/null; then
  echo "✓ JavaScript/TypeScript linting container configured"
else
  echo "ℹ Add JS/TS linting container to docker-compose.yml if needed"
fi
```

### Step 7: Test Pre-commit Hooks

Test the pre-commit hooks on existing files:

```bash
# Run pre-commit on all files (first run may take time)
echo "Running pre-commit hooks on all files (first run downloads tools)..."
pre-commit run --all-files

# Check exit code
if [ $? -eq 0 ]; then
  echo "✓ All pre-commit hooks passed"
else
  echo "ℹ Some hooks failed - review output and fix issues"
  echo "  Run 'make lint-fix' to auto-fix issues, then try again"
fi
```

### Step 8: Copy Documentation

Copy pre-commit standards and how-to guides:

```bash
# Create documentation directories if needed
mkdir -p .ai/docs
mkdir -p .ai/howto

# Copy standards documentation
cp plugins/standards/pre-commit-hooks/ai-content/standards/PRE_COMMIT_STANDARDS.md .ai/docs/

# Copy how-to guides
cp plugins/standards/pre-commit-hooks/ai-content/howtos/how-to-install-pre-commit.md .ai/howto/
cp plugins/standards/pre-commit-hooks/ai-content/howtos/how-to-add-custom-hook.md .ai/howto/
cp plugins/standards/pre-commit-hooks/ai-content/howtos/how-to-debug-failing-hooks.md .ai/howto/

echo "✓ Copied pre-commit documentation"
```

### Step 9: Update .ai/index.yaml

Add pre-commit hooks to the project's .ai index:

```yaml
# Add to .ai/index.yaml under 'standards' section
standards:
  pre-commit-hooks:
    description: "Pre-commit hooks for automated code quality enforcement"
    documentation:
      - path: "docs/PRE_COMMIT_STANDARDS.md"
        description: "Pre-commit hooks standards and configuration"
    howtos:
      - path: "howto/how-to-install-pre-commit.md"
        description: "Install and configure pre-commit hooks"
      - path: "howto/how-to-add-custom-hook.md"
        description: "Create custom pre-commit hooks"
      - path: "howto/how-to-debug-failing-hooks.md"
        description: "Debug failing pre-commit hooks"
    configuration:
      - path: ".pre-commit-config.yaml"
        description: "Pre-commit hooks configuration"
```

---

## Post-Installation Validation

After installation, verify the pre-commit hooks:

### Check Git Hooks Installation

```bash
# Verify hooks are installed
test -f .git/hooks/pre-commit && echo "✓ Pre-commit hook installed"
test -f .git/hooks/pre-push && echo "✓ Pre-push hook installed"

# Check hook contents reference pre-commit
grep -q "pre-commit" .git/hooks/pre-commit && echo "✓ Pre-commit hook configured correctly"
```

### Check Configuration File

```bash
# Verify configuration exists
test -f .pre-commit-config.yaml && echo "✓ Pre-commit configuration present"

# Check for key hooks
grep -q "no-commit-to-main" .pre-commit-config.yaml && echo "✓ Branch protection configured"
grep -q "make-lint-fix" .pre-commit-config.yaml && echo "✓ Auto-fix configured"
```

### Test Hooks Manually

```bash
# Test all hooks on existing files
echo "Testing all hooks..."
pre-commit run --all-files

# Test specific hook
echo "Testing branch protection..."
pre-commit run no-commit-to-main --all-files
```

### Test Commit Process

```bash
# Create a test commit on a feature branch
git checkout -b test-pre-commit-hooks
echo "# Test" > test-file.md
git add test-file.md
git commit -m "Test pre-commit hooks"

# Should succeed on feature branch
echo "✓ Pre-commit hooks work on feature branch"

# Clean up
git checkout main
git branch -D test-pre-commit-hooks
rm -f test-file.md
```

---

## Integration with Other Plugins

### Python Plugin Integration

The Pre-commit Hooks Plugin integrates with the Python plugin:
- **Ruff**: Format and lint Python code
- **Flake8**: Style checking
- **MyPy**: Type checking
- **Pylint**: Code analysis
- **Bandit**: Security scanning
- **Xenon**: Complexity analysis

All tools execute in the Python linting Docker container.

### TypeScript Plugin Integration

Integrates with TypeScript plugin:
- **TypeScript Compiler**: Type checking
- **ESLint**: Linting
- **Prettier**: Formatting
- **Stylelint**: CSS linting

All tools execute in the JavaScript linting Docker container.

### Security Plugin Integration

If Security plugin is installed:
- **Bandit**: Python security scanning
- **ESLint Security**: JavaScript/TypeScript security
- **Secret Detection**: Prevents committing secrets

### Docker Plugin Integration

Executes all hooks in Docker containers:
- **Python Linting Container**: Runs Python tools
- **JS Linting Container**: Runs TypeScript/JavaScript tools
- **Consistent Environments**: Same tools in dev and CI/CD

---

## Configuration Customization

### Customize Branch Protection

Edit `.pre-commit-config.yaml` to protect different branches:

```yaml
- id: no-commit-to-main
  name: Prevent commits to main branch
  entry: bash -c 'branch=$(git rev-parse --abbrev-ref HEAD); if [ "$branch" = "main" ] || [ "$branch" = "master" ] || [ "$branch" = "develop" ]; then echo "❌ Direct commits to protected branches not allowed!"; exit 1; fi'
  # Add "develop" to protected branches
```

### Disable Specific Hooks

Disable hooks you don't need:

```yaml
# Comment out hooks you don't want
# - id: python-xenon
#   name: Xenon (Python complexity)
#   ...
```

### Add Custom Hooks

Add project-specific hooks:

```yaml
- id: custom-check-todos
  name: Check for TODO comments
  entry: bash -c 'if git diff --cached | grep -i "# TODO"; then echo "⚠️  Warning: TODO comments found"; fi'
  language: system
  pass_filenames: false
  stages: [pre-commit]
```

### Skip Hooks Temporarily

Skip hooks for emergency commits:

```bash
# Skip pre-commit hooks (not recommended)
git commit --no-verify -m "Emergency fix"

# Skip pre-push hooks (use PRE_PUSH_SKIP env var)
PRE_PUSH_SKIP=1 git push
```

---

## Troubleshooting

### Issue: Pre-commit not found

**Solution**: Install pre-commit framework:
```bash
pip install pre-commit
# or
pip3 install pre-commit
```

### Issue: Docker containers not found

**Solution**: Ensure Docker containers are running:
```bash
# Start linting containers
make lint-ensure-containers

# Or start all containers
docker compose up -d
```

### Issue: Hooks fail with "command not found"

**Solution**: Verify the command exists in the Docker container:
```bash
# Check Python container
docker exec <container-name> which ruff

# Check JS container
docker exec <container-name> which eslint
```

### Issue: Hooks take too long

**Solution**: Hooks run in Docker and only on changed files. First run is slower due to tool installation. Subsequent runs are fast.

**Optimization**:
```bash
# Run lint-fix first to auto-fix issues
make lint-fix

# Then commit (hooks will be faster)
git add .
git commit -m "Your message"
```

### Issue: Want to skip hooks temporarily

**Solution**: Use --no-verify for pre-commit or PRE_PUSH_SKIP for pre-push:
```bash
# Skip pre-commit (emergency only)
git commit --no-verify -m "Emergency fix"

# Skip pre-push (emergency only)
PRE_PUSH_SKIP=1 git push
```

### Issue: Hooks fail on first commit

**Solution**: First run downloads tools and may fail. Run again:
```bash
# First run may fail
pre-commit run --all-files

# Run again (should pass)
pre-commit run --all-files
```

---

## Best Practices

### Always Run on Feature Branches

1. **Never commit directly to main**: The branch protection hook prevents this
2. **Create feature branches**: `git checkout -b feature/my-feature`
3. **Commit on feature branches**: Hooks run automatically
4. **Push feature branches**: Pre-push hooks run comprehensive checks

### Use Auto-fix Before Committing

1. **Run make lint-fix**: Auto-fixes formatting and style issues
2. **Stage changes**: `git add -u`
3. **Commit**: Hooks run on already-fixed code

### Understand Hook Stages

1. **Pre-commit hooks**: Run on `git commit`
   - Fast, file-specific checks
   - Auto-fix when possible
   - Fail early on issues

2. **Pre-push hooks**: Run on `git push`
   - Comprehensive checks
   - Run all tests
   - Ensure code quality before pushing

### Review Hook Output

1. **Read failure messages**: Hooks provide detailed error messages
2. **Fix issues locally**: Don't skip hooks without understanding why they fail
3. **Run hooks manually**: `pre-commit run --all-files` to test

### Keep Hooks Fast

1. **Only check changed files**: Hooks already configured this way
2. **Use Docker containers**: Consistent, isolated environments
3. **Run lint-fix first**: Reduces hook execution time

---

## Success Criteria

After installing the Pre-commit Hooks Plugin, verify:

- ✅ `.pre-commit-config.yaml` present in project root
- ✅ Pre-commit framework installed
- ✅ Git hooks installed (`.git/hooks/pre-commit`, `.git/hooks/pre-push`)
- ✅ Branch protection works (cannot commit to main)
- ✅ Auto-fix runs before linting
- ✅ Language-specific hooks configured (Python, TypeScript)
- ✅ Docker containers execute hooks
- ✅ Documentation copied to `.ai/docs/` and `.ai/howto/`
- ✅ `.ai/index.yaml` references pre-commit hooks
- ✅ Test commit succeeds on feature branch

---

## Next Steps

After installation:

1. **Test hooks**: Create a feature branch and make a test commit
2. **Review documentation**: Read `.ai/docs/PRE_COMMIT_STANDARDS.md`
3. **Customize configuration**: Edit `.pre-commit-config.yaml` for project needs
4. **Add custom hooks**: See `.ai/howto/how-to-add-custom-hook.md`
5. **Train team**: Share `.ai/howto/how-to-install-pre-commit.md` with developers
6. **Run on all files**: `pre-commit run --all-files` to check entire codebase

For detailed guidance, see:
- `.ai/howto/how-to-install-pre-commit.md`
- `.ai/howto/how-to-add-custom-hook.md`
- `.ai/howto/how-to-debug-failing-hooks.md`
