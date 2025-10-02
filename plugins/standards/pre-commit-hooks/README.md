# Pre-commit Hooks Plugin

**Purpose**: Automated code quality enforcement through pre-commit hooks with Docker integration and dynamic language detection

**Scope**: Git hooks for all project languages (Python, TypeScript, JavaScript) with branch protection, auto-fix, and security scanning

**Overview**: This plugin provides comprehensive pre-commit and pre-push hooks that enforce code quality standards
    across multiple languages in a Docker-first development environment. Features include branch protection
    preventing direct commits to main, automatic fixing of linting issues before validation, language-specific
    linting tools (Python: ruff, flake8, mypy, pylint, bandit, xenon; TypeScript: ESLint, Prettier, type
    checking, stylelint), security scanning, complexity analysis, and custom design linters. All hooks execute
    in Docker containers for consistent environments. Dynamically detects project languages and configures
    appropriate hooks. Supports pre-commit (fast, file-specific) and pre-push (comprehensive, full validation)
    stages with emergency skip capabilities.

**Dependencies**: Git, Docker, Docker Compose, pre-commit framework, optionally Python plugin and TypeScript plugin

**Exports**: .pre-commit-config.yaml configuration, git hooks installation, comprehensive documentation

**Related**: plugins/languages/python (Python tooling), plugins/languages/typescript (TypeScript tooling), plugins/infrastructure/containerization/docker (container execution), plugins/standards/security (security scanning)

**Implementation**: Template-based configuration with dynamic language detection, Docker container execution, and Makefile integration

---

## Features

### Branch Protection
- **Prevents direct commits to main/master**: Enforces feature branch workflow
- **Clear error messages**: Guides developers to create feature branches
- **Always runs**: Cannot be bypassed by file filters

### Auto-fix Capabilities
- **Runs before linting**: Automatically fixes formatting and style issues
- **Stages fixed files**: `git add -u` after fixes
- **Reduces hook failures**: Most issues auto-corrected before validation

### Language-Specific Hooks

#### Python
- **Ruff**: Format and lint with modern Python tooling
- **Flake8**: Style checking (PEP 8 compliance)
- **MyPy**: Static type checking
- **Pylint**: Comprehensive code analysis
- **Bandit**: Security vulnerability scanning
- **Xenon**: Code complexity analysis

#### TypeScript/JavaScript
- **TypeScript Compiler**: Type checking
- **ESLint**: Linting and code quality
- **Prettier**: Code formatting
- **Stylelint**: CSS/SCSS linting

### Docker Integration
- **Container execution**: All hooks run in Docker containers
- **Consistent environments**: Same tools in development and CI/CD
- **Isolated dependencies**: No local tool installation conflicts

### Security Features
- **Bandit scanning**: Python security vulnerabilities
- **ESLint security**: JavaScript/TypeScript security rules
- **Design linters**: Project-specific security patterns
- **No-skip enforcement**: Prevents bypassing security checks

### Pre-push Validation
- **Comprehensive linting**: Runs all linters before push
- **Full test suite**: Runs all tests before push
- **Uncommitted changes check**: Ensures clean working directory
- **Emergency skip**: PRE_PUSH_SKIP environment variable for emergencies

---

## Quick Start

### Prerequisites
- Git repository initialized
- Docker and Docker Compose running
- Makefile with `lint-fix`, `lint-all`, `test-all` targets
- Optional: Python or Node.js for pre-commit framework

### Installation

1. **Copy configuration template**:
   ```bash
   cp plugins/standards/pre-commit-hooks/ai-content/templates/.pre-commit-config.yaml.template .pre-commit-config.yaml
   ```

2. **Install pre-commit framework**:
   ```bash
   pip install pre-commit
   ```

3. **Install git hooks**:
   ```bash
   pre-commit install
   pre-commit install --hook-type pre-push
   ```

4. **Test installation**:
   ```bash
   pre-commit run --all-files
   ```

See `AGENT_INSTRUCTIONS.md` for detailed installation guide.

---

## Usage

### Normal Development Workflow

1. **Create feature branch**:
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes**:
   ```bash
   # Edit files
   vim app/main.py
   ```

3. **Auto-fix issues**:
   ```bash
   make lint-fix
   git add -u
   ```

4. **Commit** (hooks run automatically):
   ```bash
   git commit -m "Add new feature"
   ```

5. **Push** (pre-push hooks run):
   ```bash
   git push origin feature/my-feature
   ```

### Manual Hook Execution

Run hooks manually without committing:

```bash
# Run all hooks on all files
pre-commit run --all-files

# Run specific hook
pre-commit run python-ruff --all-files

# Run on specific files
pre-commit run --files app/main.py app/utils.py
```

### Skip Hooks (Emergency Only)

Skip hooks when absolutely necessary:

```bash
# Skip pre-commit hooks (not recommended)
git commit --no-verify -m "Emergency hotfix"

# Skip pre-push hooks (use environment variable)
PRE_PUSH_SKIP=1 git push
```

---

## Configuration

### Dynamic Language Detection

The configuration automatically detects languages:

```yaml
# Python hooks run if .py files changed
- id: python-ruff
  files: \.(py)$

# TypeScript hooks run if .ts/.tsx files changed
- id: typescript-check
  files: ^frontend/.*\.(ts|tsx)$
```

### Hook Stages

**Pre-commit** (runs on `git commit`):
- Fast, file-specific checks
- Auto-fix before validation
- Runs only on changed files

**Pre-push** (runs on `git push`):
- Comprehensive validation
- All linters on all code
- Full test suite execution
- Ensures code quality before pushing

### Customization

Edit `.pre-commit-config.yaml` to customize:

**Add protected branches**:
```yaml
- id: no-commit-to-main
  entry: bash -c 'branch=$(git rev-parse --abbrev-ref HEAD); if [ "$branch" = "main" ] || [ "$branch" = "develop" ]; then ...'
```

**Disable specific hooks**:
```yaml
# Comment out hooks you don't need
# - id: python-xenon
#   name: Xenon (Python complexity)
```

**Add custom hooks**:
```yaml
- id: custom-check
  name: Custom project check
  entry: bash -c 'echo "Running custom check..."'
  language: system
  pass_filenames: false
```

---

## Documentation

### For AI Agents
- `AGENT_INSTRUCTIONS.md`: Installation and configuration guide
- `manifest.yaml`: Plugin metadata and integration points

### For Developers
- `.ai/docs/PRE_COMMIT_STANDARDS.md`: Standards and best practices
- `.ai/howto/how-to-install-pre-commit.md`: Installation guide
- `.ai/howto/how-to-add-custom-hook.md`: Custom hook creation
- `.ai/howto/how-to-debug-failing-hooks.md`: Troubleshooting guide

---

## Integration

### Python Plugin
- Integrates Python linting tools (ruff, flake8, mypy, pylint, bandit, xenon)
- Executes in Python linting Docker container
- Uses `make lint-fix` for auto-fixing

### TypeScript Plugin
- Integrates TypeScript tools (tsc, ESLint, Prettier, stylelint)
- Executes in JavaScript linting Docker container
- Supports React and Next.js projects

### Security Plugin
- Integrates security scanning (Bandit, ESLint security)
- Enforces secret detection
- No-skip enforcement for security rules

### Docker Plugin
- Executes all hooks in Docker containers
- Consistent tool versions across environments
- Isolated dependency management

---

## Troubleshooting

### Hooks Not Running

**Check installation**:
```bash
ls -la .git/hooks/pre-commit .git/hooks/pre-push
```

**Reinstall if needed**:
```bash
pre-commit install
pre-commit install --hook-type pre-push
```

### Docker Container Not Found

**Start containers**:
```bash
make lint-ensure-containers
# or
docker compose up -d
```

### Hooks Failing

**Run auto-fix first**:
```bash
make lint-fix
git add -u
git commit -m "Your message"
```

**Check specific hook**:
```bash
pre-commit run python-ruff --all-files --verbose
```

### Hooks Too Slow

**First run is slower**: Tools are downloaded and cached
**Subsequent runs are fast**: Hooks only run on changed files

**Optimize**:
1. Run `make lint-fix` before committing
2. Commit frequently with small changes
3. Use pre-push hooks for comprehensive checks

---

## Best Practices

### Development Workflow
1. **Always use feature branches**: Never commit directly to main
2. **Run lint-fix before committing**: Auto-fixes most issues
3. **Commit small, logical changes**: Faster hook execution
4. **Read hook output**: Understand failures before skipping
5. **Never skip security hooks**: Address security issues immediately

### Configuration Management
1. **Keep configuration in version control**: `.pre-commit-config.yaml`
2. **Document custom hooks**: Add comments explaining purpose
3. **Test changes locally**: `pre-commit run --all-files`
4. **Update hooks regularly**: `pre-commit autoupdate`

### Team Collaboration
1. **Share documentation**: Point team to `.ai/howto/` guides
2. **Enforce in CI/CD**: Run same hooks in GitHub Actions
3. **Review hook failures**: Don't merge PRs with hook failures
4. **Standardize skip policies**: Define when skipping is acceptable

---

## Architecture

### Hook Execution Flow

```
git commit
    ↓
1. Check branch (no-commit-to-main)
    ↓
2. Auto-fix issues (make lint-fix)
    ↓
3. Stage fixed files (git add -u)
    ↓
4. Language-specific linting
   ├─ Python (if .py files changed)
   │   ├─ Ruff (format + lint)
   │   ├─ Flake8 (style)
   │   ├─ MyPy (types)
   │   ├─ Pylint (analysis)
   │   ├─ Bandit (security)
   │   └─ Xenon (complexity)
   └─ TypeScript (if .ts/.tsx files changed)
       ├─ TypeScript (types)
       ├─ ESLint (lint)
       ├─ Prettier (format)
       └─ Stylelint (CSS)
    ↓
5. Custom linters (design linters)
    ↓
6. No-skip enforcement
    ↓
✓ Commit succeeds
```

### Container Architecture

```
Developer Machine
    ↓
git commit
    ↓
Pre-commit Framework
    ↓
Docker Containers
    ├─ Python Linting Container
    │   ├─ ruff
    │   ├─ flake8
    │   ├─ mypy
    │   ├─ pylint
    │   ├─ bandit
    │   └─ xenon
    └─ JavaScript Linting Container
        ├─ tsc
        ├─ eslint
        ├─ prettier
        └─ stylelint
```

---

## Performance

### Hook Execution Times

| Stage | First Run | Subsequent Runs |
|-------|-----------|-----------------|
| Pre-commit (changed files) | 10-30s | 3-10s |
| Pre-push (all files + tests) | 1-5min | 1-5min |

### Optimization Strategies

1. **File-specific hooks**: Only run on changed files
2. **Docker container caching**: Containers stay running
3. **Tool caching**: Pre-commit caches tool downloads
4. **Auto-fix first**: Reduces validation failures

---

## Security Considerations

### Protected Branches
- **Main/master always protected**: Cannot commit directly
- **Configurable protection**: Add more branches as needed

### Security Scanning
- **Bandit**: Scans Python code for vulnerabilities
- **ESLint security**: Checks JavaScript/TypeScript
- **Design linters**: Project-specific security rules

### No-skip Enforcement
- **Prevents bypassing**: Cannot skip critical security checks
- **Audit trail**: Git history shows all hook runs
- **CI/CD validation**: Same hooks run in CI/CD pipeline

### Emergency Procedures
- **Documented skip process**: Clear when skipping is acceptable
- **Environment variable**: PRE_PUSH_SKIP for emergencies
- **Review required**: Emergency commits require immediate review

---

## Contributing

### Adding New Hooks

See `.ai/howto/how-to-add-custom-hook.md` for detailed guide.

Example:
```yaml
- id: custom-check
  name: Custom project check
  entry: bash -c 'echo "Custom check passed"'
  language: system
  files: \.(py)$
  pass_filenames: false
  stages: [pre-commit]
```

### Updating Hook Configuration

1. Edit `.pre-commit-config.yaml`
2. Test changes: `pre-commit run --all-files`
3. Commit: `git add .pre-commit-config.yaml && git commit`
4. Document changes in commit message

---

## Support

### Resources
- **Installation Guide**: `AGENT_INSTRUCTIONS.md`
- **Standards**: `.ai/docs/PRE_COMMIT_STANDARDS.md`
- **How-to Guides**: `.ai/howto/how-to-*.md`
- **Pre-commit Documentation**: https://pre-commit.com/

### Common Issues
- Docker containers not running → `make lint-ensure-containers`
- Hooks failing → `make lint-fix` first
- Hooks too slow → First run is slower, subsequent runs fast
- Need to skip → Use `--no-verify` or `PRE_PUSH_SKIP=1` (emergency only)

---

## License

Part of the ai-projen framework.
