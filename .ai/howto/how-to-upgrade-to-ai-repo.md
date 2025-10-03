# How-To: Upgrade Existing Repository to AI-Ready

**Purpose**: Guide for adding AI-ready patterns to existing repositories using ai-projen plugin framework

**Scope**: Safe, non-destructive upgrade of existing repositories with gap analysis, conflict resolution, incremental installation, and backup strategies

**Overview**: Step-by-step guide for analyzing existing repositories, identifying missing capabilities, safely installing plugins without breaking existing functionality, merging configurations, and validating the upgrade. Designed for repositories that already have code, tooling, or infrastructure but want to adopt AI-ready patterns incrementally.

**Dependencies**: Existing Git repository, ai-projen repository access, basic understanding of current repository structure

**Exports**: Upgraded repository with AI patterns, merged configurations, enhanced tooling, preserved existing functionality

**Related**: [how-to-create-new-ai-repo.md](how-to-create-new-ai-repo.md), [how-to-add-capability.md](how-to-add-capability.md), [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml)

**Implementation**: Analyze → Identify gaps → Backup → Install incrementally → Merge configs → Validate

**Difficulty**: advanced

**Estimated Time**: 30-60min (varies by existing complexity)

---

## Prerequisites

Before upgrading an existing repository, ensure you have:

- **Existing Git repository**: Working repository with code
- **Git working tree clean**: All changes committed (no uncommitted work)
- **Backup capability**: Ability to create branch or backup
- **ai-projen repository**: Cloned locally or accessible
- **Understanding of current setup**: Know what linters, configs, infrastructure already exist
- **Testing capability**: Existing tests should pass before upgrade

## Overview

### What This Upgrades

This guide safely adds AI-ready patterns to existing repositories:

- **Foundation**: `.ai/` directory structure (if missing)
- **Enhanced tooling**: Better linters, formatters, test frameworks
- **Infrastructure**: Docker, CI/CD, cloud deployment (if missing)
- **Standards**: Security scanning, documentation, pre-commit hooks
- **AI navigation**: agents.md entry point for AI agents

### Upgrade Philosophy

**Non-Destructive Approach**:
- Never delete existing configuration
- Always backup before modifying
- Merge plugin configs with existing configs
- Preserve custom settings
- Provide rollback instructions

**Progressive Enhancement**:
- Add capabilities incrementally
- Test after each addition
- Keep existing functionality working
- Enhance, don't replace

### When to Use This Guide

Use this guide when you:
- Have existing repository with code
- Want to add AI-ready patterns
- Need to preserve existing functionality
- Want better tooling without disruption
- Are adding Docker, CI/CD, or standards to existing project

### When NOT to Use This Guide

Do not use this guide when you:
- Have empty repository (use how-to-create-new-ai-repo.md instead)
- Want to start from scratch (create new repo instead)
- Can't test existing functionality (too risky to upgrade)
- Don't have backups (backup first!)

---

## Steps

### Step 1: Create Safety Backup

Create backup branch before making any changes.

**Create Backup Branch**:
```bash
# Ensure working tree is clean
git status
# Should show: nothing to commit, working tree clean

# Create backup branch
git checkout -b backup-before-ai-upgrade

# Push backup to remote (if using remote)
git push -u origin backup-before-ai-upgrade

# Return to main branch
git checkout main

# Create upgrade working branch
git checkout -b upgrade-to-ai-ready
```

**Verify Existing Tests Pass**:
```bash
# Run existing tests to establish baseline
# Examples (adjust to your project):
pytest  # Python
npm test  # JavaScript/TypeScript
make test  # If you have a Makefile
./run-tests.sh  # Custom script

# Document current state
git log --oneline -5 > upgrade-baseline.txt
git status >> upgrade-baseline.txt
```

**Why This Matters**: Backup branch provides rollback point if upgrade causes issues. Baseline test results confirm what "working" looks like.

### Step 2: Analyze Existing Repository

Detect what's already present in the repository.

**Detect Programming Languages**:
```bash
# Check for Python
find . -name "*.py" | head -5
cat pyproject.toml 2>/dev/null || cat setup.py 2>/dev/null || cat requirements.txt 2>/dev/null
python --version 2>/dev/null

# Check for TypeScript/JavaScript
find . -name "*.ts" -o -name "*.tsx" | head -5
cat package.json 2>/dev/null
cat tsconfig.json 2>/dev/null
node --version 2>/dev/null

# Check for Go
find . -name "*.go" | head -5
cat go.mod 2>/dev/null

# Document findings
echo "=== Language Detection ===" > analysis.txt
echo "Python files: $(find . -name '*.py' | wc -l)" >> analysis.txt
echo "TypeScript files: $(find . -name '*.ts' -o -name '*.tsx' | wc -l)" >> analysis.txt
echo "JavaScript files: $(find . -name '*.js' | wc -l)" >> analysis.txt
```

**Detect Existing Linters/Formatters**:
```bash
# Python tools
ls -la | grep -E '(\.ruff\.toml|\.flake8|pylintrc|\.black|pyproject\.toml)'

# TypeScript/JavaScript tools
ls -la | grep -E '(\.eslintrc|\.prettierrc|biome\.json)'

# Add to analysis
echo "=== Existing Tools ===" >> analysis.txt
echo "Python linters: $(ls -1 | grep -E '(ruff|flake8|pylint)' | tr '\n' ', ')" >> analysis.txt
echo "JS/TS linters: $(ls -1 | grep -E '(eslint|prettier|biome)' | tr '\n' ', ')" >> analysis.txt
```

**Detect Existing Docker**:
```bash
# Check for Docker files
ls -la | grep -i docker
find . -name "Dockerfile*" -o -name "docker-compose*.yml"

# Add to analysis
echo "=== Docker ===" >> analysis.txt
echo "Dockerfiles: $(find . -name 'Dockerfile*' | wc -l)" >> analysis.txt
echo "Compose files: $(find . -name 'docker-compose*.yml' | wc -l)" >> analysis.txt
```

**Detect Existing CI/CD**:
```bash
# Check for GitHub Actions
ls -la .github/workflows/ 2>/dev/null

# Check for GitLab CI
ls -la .gitlab-ci.yml 2>/dev/null

# Check for other CI
ls -la | grep -E '(\.travis|circle|jenkins)'

# Add to analysis
echo "=== CI/CD ===" >> analysis.txt
echo "GitHub Actions: $(ls -1 .github/workflows/ 2>/dev/null | wc -l) workflows" >> analysis.txt
echo "GitLab CI: $(test -f .gitlab-ci.yml && echo 'Yes' || echo 'No')" >> analysis.txt
```

**Detect Existing Infrastructure**:
```bash
# Check for Terraform
find . -name "*.tf" | head -5
ls -la terraform.tfstate 2>/dev/null

# Check for Kubernetes
find . -name "*.yaml" -path "*/k8s/*" -o -name "*.yaml" -path "*/kubernetes/*"

# Add to analysis
echo "=== Infrastructure ===" >> analysis.txt
echo "Terraform files: $(find . -name '*.tf' | wc -l)" >> analysis.txt
echo "Kubernetes files: $(find . -name '*.yaml' -path '*/k8s/*' | wc -l)" >> analysis.txt
```

**Review Analysis**:
```bash
# View complete analysis
cat analysis.txt

# Save to repository
git add analysis.txt
git commit -m "Add repository analysis for AI upgrade"
```

**Why This Matters**: Understanding what exists prevents duplicate installations and identifies integration points.

### Step 3: Identify Missing Capabilities

Compare existing setup against available plugins to find gaps.

**Create Gap Analysis**:
```bash
cat > gap-analysis.txt << 'EOF'
# Gap Analysis - AI-Ready Upgrade

## Existing Capabilities
(from analysis.txt)

## Missing Capabilities

### Foundation
- [ ] .ai/ folder structure - NEEDED for AI navigation
- [ ] agents.md file - NEEDED for AI entry point

### Language Tooling

#### Python (if Python detected)
- [ ] Ruff linter - Faster, more comprehensive
- [ ] Black formatter - Standard formatter
- [ ] pytest - Test framework
- [ ] MyPy - Type checking
- [ ] Bandit - Security scanning

#### TypeScript (if TypeScript detected)
- [ ] ESLint - Linting
- [ ] Prettier - Formatting
- [ ] Vitest - Modern test framework
- [ ] TypeScript strict mode - Type safety

### Infrastructure
- [ ] Docker multi-stage builds - Optimized containers
- [ ] docker-compose - Development orchestration
- [ ] GitHub Actions CI/CD - Automated testing
- [ ] Terraform/AWS - Infrastructure as code

### Standards
- [ ] Security scanning - Secrets, dependencies, SAST
- [ ] Documentation standards - File headers, README templates
- [ ] Pre-commit hooks - Quality gates

## Recommended Upgrade Path
1. Install foundation/ai-folder (always first)
2. Enhance existing language tooling
3. Add missing infrastructure
4. Apply standards

## Conflicts to Resolve
(List any existing configs that will conflict with plugins)

## Estimated Time
Foundation: 5min
Language enhancements: 10-15min
Infrastructure: 15-20min
Standards: 10min
Total: 40-50min
EOF

# Review and edit
cat gap-analysis.txt
```

**Identify Conflicts**:
```bash
# Check for config file conflicts
echo "=== Potential Conflicts ===" >> gap-analysis.txt

# Will .ai/ conflict?
test -d .ai && echo "- .ai/ directory exists (will merge)" >> gap-analysis.txt || echo "- .ai/ directory missing (will create)" >> gap-analysis.txt

# Will agents.md conflict?
test -f agents.md && echo "- agents.md exists (will merge)" >> gap-analysis.txt || echo "- agents.md missing (will create)" >> gap-analysis.txt

# Will pyproject.toml conflict?
test -f pyproject.toml && echo "- pyproject.toml exists (will merge)" >> gap-analysis.txt || echo "- pyproject.toml missing (will create)" >> gap-analysis.txt

# Will package.json conflict?
test -f package.json && echo "- package.json exists (will merge)" >> gap-analysis.txt || echo "- package.json missing (will create)" >> gap-analysis.txt

# Will Dockerfile conflict?
test -f Dockerfile && echo "- Dockerfile exists (will need manual merge)" >> gap-analysis.txt || echo "- Dockerfile missing (will create)" >> gap-analysis.txt
```

**Commit Gap Analysis**:
```bash
git add gap-analysis.txt
git commit -m "Add gap analysis for AI upgrade"
```

**Why This Matters**: Gap analysis prevents installing unnecessary plugins and identifies conflicts to handle carefully.

### Step 4: Install Foundation Plugin

Install foundation/ai-folder plugin to create `.ai/` structure.

**Check if .ai/ Already Exists**:
```bash
if [ -d .ai ]; then
    echo "WARNING: .ai/ directory already exists"
    echo "Backing up existing .ai/ to .ai.backup/"
    cp -r .ai .ai.backup
    git add .ai.backup
    git commit -m "Backup existing .ai/ directory"
fi
```

**Install Foundation Plugin**:
```bash
# Create .ai/ structure (or enhance existing)
mkdir -p .ai/{docs,howto,templates,features}

# Copy foundation templates
cp /path/to/ai-projen/plugins/foundation/ai-folder/ai-content/templates/index.yaml.template .ai/index.yaml
cp /path/to/ai-projen/plugins/foundation/ai-folder/ai-content/templates/layout.yaml.template .ai/layout.yaml

# Customize for your project
PROJECT_NAME=$(basename $(pwd))
sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" .ai/index.yaml
sed -i "s/{{PROJECT_TYPE}}/existing-project-upgrade/g" .ai/index.yaml

# Create or merge agents.md
if [ -f agents.md ]; then
    echo "Backing up existing agents.md"
    cp agents.md agents.md.backup
    # Append AI-ready section
    cat /path/to/ai-projen/plugins/foundation/ai-folder/ai-content/templates/agents.md.template >> agents.md
else
    # Create new
    cp /path/to/ai-projen/plugins/foundation/ai-folder/ai-content/templates/agents.md.template agents.md
    sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" agents.md
fi

# Commit
git add .ai/ agents.md agents.md.backup 2>/dev/null || true
git commit -m "Install foundation/ai-folder plugin"
```

**Why This Matters**: Foundation plugin creates the structure all other plugins depend on.

### Step 5: Upgrade Language Tooling

Enhance existing language tooling with plugin configurations.

**Upgrade Python Tooling** (if Python detected):
```bash
# Read Python plugin instructions
cat /path/to/ai-projen/plugins/languages/python/AGENT_INSTRUCTIONS.md

# Backup existing Python configs
test -f pyproject.toml && cp pyproject.toml pyproject.toml.backup
test -f setup.py && cp setup.py setup.py.backup
test -f pytest.ini && cp pytest.ini pytest.ini.backup

# Copy plugin configs to temp location for review
cp /path/to/ai-projen/plugins/languages/python/templates/pyproject.toml pyproject.toml.plugin
cp /path/to/ai-projen/plugins/languages/python/templates/.ruff.toml .ruff.toml
cp /path/to/ai-projen/plugins/languages/python/templates/Makefile.python Makefile.python

# Merge pyproject.toml (manual step - preserve existing sections)
echo "MANUAL ACTION REQUIRED:"
echo "1. Open pyproject.toml and pyproject.toml.plugin side-by-side"
echo "2. Merge [tool.ruff], [tool.black], [tool.pytest] from .plugin into main"
echo "3. Preserve existing [project], [build-system] sections"
echo "4. Remove pyproject.toml.plugin when done"

# Add Makefile inclusion
if [ -f Makefile ]; then
    echo "-include Makefile.python" >> Makefile
else
    echo "include Makefile.python" > Makefile
fi

# Extend agents.md
cat /path/to/ai-projen/plugins/languages/python/templates/agents-extension.md >> agents.md

# Test new Python tooling
make lint-python || echo "Note: May fail if no Python files match patterns yet"

# Commit
git add .
git commit -m "Upgrade Python tooling with ai-projen plugin"
```

**Upgrade TypeScript Tooling** (if TypeScript detected):
```bash
# Backup existing TypeScript configs
test -f package.json && cp package.json package.json.backup
test -f tsconfig.json && cp tsconfig.json tsconfig.json.backup
test -f .eslintrc.json && cp .eslintrc.json .eslintrc.json.backup

# Copy plugin configs for review
cp /path/to/ai-projen/plugins/languages/typescript/templates/package.json package.json.plugin
cp /path/to/ai-projen/plugins/languages/typescript/templates/tsconfig.json tsconfig.json.plugin
cp /path/to/ai-projen/plugins/languages/typescript/templates/.eslintrc.json .eslintrc.json.plugin
cp /path/to/ai-projen/plugins/languages/typescript/templates/.prettierrc.json .prettierrc.json
cp /path/to/ai-projen/plugins/languages/typescript/templates/Makefile.typescript Makefile.typescript

# Merge package.json
echo "MANUAL ACTION REQUIRED:"
echo "1. Merge devDependencies from package.json.plugin into package.json"
echo "2. Merge scripts from package.json.plugin into package.json"
echo "3. Run 'npm install' to install new dev dependencies"
echo "4. Remove package.json.plugin when done"

# Merge tsconfig.json
echo "MANUAL ACTION REQUIRED:"
echo "1. Merge compilerOptions from tsconfig.json.plugin into tsconfig.json"
echo "2. Enable strict mode if not already enabled"
echo "3. Remove tsconfig.json.plugin when done"

# Add Makefile inclusion
echo "-include Makefile.typescript" >> Makefile

# Extend agents.md
cat /path/to/ai-projen/plugins/languages/typescript/templates/agents-extension.md >> agents.md

# Commit after manual merges
echo "After completing manual merges, run:"
echo "git add ."
echo "git commit -m 'Upgrade TypeScript tooling with ai-projen plugin'"
```

**Why This Matters**: Upgrading language tooling enhances code quality without breaking existing code.

### Step 6: Add Missing Infrastructure

Add Docker, CI/CD, and cloud infrastructure if missing.

**Add Docker** (if not present):
```bash
# Check if Docker exists
if [ ! -f Dockerfile ] && [ ! -f docker-compose.yml ]; then
    echo "Adding Docker infrastructure..."

    # Create Docker directory structure
    mkdir -p .docker/dockerfiles .docker/compose

    # Copy Docker templates
    cp /path/to/ai-projen/plugins/infrastructure/docker/templates/Dockerfile.python .docker/dockerfiles/Dockerfile.backend
    cp /path/to/ai-projen/plugins/infrastructure/docker/templates/docker-compose.yml .docker/compose/docker-compose.dev.yml
    cp /path/to/ai-projen/plugins/infrastructure/docker/templates/.dockerignore .dockerignore
    cp /path/to/ai-projen/plugins/infrastructure/docker/templates/Makefile.docker Makefile.docker

    # Add Makefile inclusion
    echo "-include Makefile.docker" >> Makefile

    # Test Docker
    make docker-build

    # Commit
    git add .
    git commit -m "Add Docker infrastructure"
else
    echo "Docker already exists - skipping (use manual integration if needed)"
fi
```

**Add GitHub Actions** (if not present):
```bash
# Check if GitHub Actions exists
if [ ! -d .github/workflows ]; then
    echo "Adding GitHub Actions CI/CD..."

    # Create workflows directory
    mkdir -p .github/workflows

    # Copy workflow templates
    cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/ci-python.yml .github/workflows/ 2>/dev/null || true
    cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/ci-typescript.yml .github/workflows/ 2>/dev/null || true
    cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/ci-full-stack.yml .github/workflows/ 2>/dev/null || true

    # Commit
    git add .github/
    git commit -m "Add GitHub Actions CI/CD"
else
    echo "GitHub Actions already exists - consider adding new workflows manually"
    echo "Available templates: ci-python.yml, ci-typescript.yml, ci-full-stack.yml"
fi
```

**Add Terraform/AWS** (if not present):
```bash
# Check if Terraform exists
if [ ! -d infra ] && [ -z "$(find . -name '*.tf' 2>/dev/null)" ]; then
    echo "Adding Terraform/AWS infrastructure..."

    # Create infrastructure directory
    mkdir -p infra/terraform/workspaces/{vpc,ecs,alb}

    # Copy Terraform templates
    cp -r /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/workspaces/* infra/terraform/workspaces/
    cp /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/backend.tf infra/terraform/
    cp /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/terraform.tfvars.example infra/terraform/
    cp /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/Makefile.terraform Makefile.terraform

    # Add Makefile inclusion
    echo "-include Makefile.terraform" >> Makefile

    # Commit
    git add infra/ Makefile.terraform Makefile
    git commit -m "Add Terraform/AWS infrastructure"
else
    echo "Infrastructure already exists - skipping"
fi
```

**Why This Matters**: Infrastructure additions should be opt-in. Only add if truly missing.

### Step 7: Apply Standards Plugins

Add security, documentation, and pre-commit hooks.

**Add Security Standards**:
```bash
# Backup existing .gitignore
cp .gitignore .gitignore.backup

# Copy security templates
cp /path/to/ai-projen/plugins/standards/security/ai-content/templates/.gitignore.security.template .gitignore.security
cp /path/to/ai-projen/plugins/standards/security/ai-content/templates/.env.example.template .env.example

# Merge .gitignore
echo "" >> .gitignore
echo "# Security additions from ai-projen" >> .gitignore
cat .gitignore.security >> .gitignore
rm .gitignore.security

# Add security workflow
cp /path/to/ai-projen/plugins/standards/security/ai-content/templates/github-workflow-security.yml.template .github/workflows/security.yml

# Commit
git add .
git commit -m "Add security standards"
```

**Add Documentation Standards**:
```bash
# Copy documentation standards
mkdir -p .ai/docs
cp /path/to/ai-projen/plugins/standards/documentation/ai-content/docs/file-headers.md .ai/docs/
cp /path/to/ai-projen/plugins/standards/documentation/ai-content/docs/readme-standards.md .ai/docs/

# Copy templates
mkdir -p .ai/templates
cp /path/to/ai-projen/plugins/standards/documentation/ai-content/templates/README.template .ai/templates/

# Commit
git add .ai/
git commit -m "Add documentation standards"
```

**Add Pre-commit Hooks**:
```bash
# Check if pre-commit already exists
if [ -f .pre-commit-config.yaml ]; then
    echo "WARNING: .pre-commit-config.yaml already exists"
    cp .pre-commit-config.yaml .pre-commit-config.yaml.backup
    echo "Manual merge required"
else
    # Copy pre-commit config
    cp /path/to/ai-projen/plugins/standards/pre-commit-hooks/ai-content/templates/.pre-commit-config.yaml.template .pre-commit-config.yaml

    # Install pre-commit
    pip install pre-commit
    pre-commit install
    pre-commit install --hook-type pre-push

    # Test (may fail on existing code - that's okay)
    pre-commit run --all-files || echo "Note: Some hooks may fail on existing code. Fix incrementally."
fi

# Commit
git add .
git commit -m "Add pre-commit hooks"
```

**Why This Matters**: Standards improve quality but shouldn't block existing work. Apply incrementally.

### Step 8: Validate Upgrade

Verify existing functionality still works after upgrade.

**Run Existing Tests**:
```bash
# Run your existing test suite
# Examples (adjust to your project):
make test || pytest || npm test || ./run-tests.sh

# Compare with baseline
echo "=== Test Comparison ===" > validation.txt
echo "Baseline (before upgrade): See upgrade-baseline.txt" >> validation.txt
echo "After upgrade: Run tests and record results" >> validation.txt
```

**Test New Make Targets**:
```bash
# List all available targets
make help

# Test new targets
make lint-python 2>&1 | tee -a validation.txt || true
make lint-ts 2>&1 | tee -a validation.txt || true
make test-python 2>&1 | tee -a validation.txt || true
make test-ts 2>&1 | tee -a validation.txt || true

# Test Docker (if added)
make docker-build 2>&1 | tee -a validation.txt || true
```

**Verify No Breaking Changes**:
```bash
# Check that existing functionality works
echo "=== Functionality Checks ===" >> validation.txt

# Can you still run your app?
# (Adjust to your project's start command)
# python -m your_app --help || npm start || make run

# Do imports still work?
# python -c "import your_module" || node -e "require('./your-module')"

echo "All checks passed" >> validation.txt
```

**Review Changes**:
```bash
# Review all files changed
git diff backup-before-ai-upgrade..HEAD --stat

# Review all commits
git log backup-before-ai-upgrade..HEAD --oneline

# Save validation results
git add validation.txt
git commit -m "Validation complete: Upgrade successful"
```

**Why This Matters**: Validation ensures upgrade didn't break existing functionality.

---

## Verification

After completing the upgrade, verify successful integration:

**Check 1: Repository Structure Enhanced**
```bash
# Verify .ai/ structure exists
ls -la .ai/
# Should show: docs/, howto/, templates/, features/, index.yaml, layout.yaml

# Verify agents.md exists
cat agents.md
# Should include both original content (if any) and AI-ready sections
```

**Check 2: New Tooling Works**
```bash
# Test Make targets
make help
make lint-all || true
make test-all || true
```

**Check 3: Existing Functionality Preserved**
```bash
# Run existing tests
# (Use your project's test command)

# Verify app still runs
# (Use your project's start command)
```

**Check 4: Configurations Merged**
```bash
# Check config files have both old and new settings
cat pyproject.toml  # Should have both your settings and plugin settings
cat package.json    # Should have both your deps and plugin deps
cat .gitignore      # Should have both your patterns and security patterns
```

**Success Criteria**:
- [ ] .ai/ folder exists with proper structure
- [ ] agents.md exists and is complete
- [ ] New Make targets work
- [ ] Existing tests still pass
- [ ] Existing functionality works
- [ ] No files were deleted
- [ ] Configs were merged (not replaced)
- [ ] Backup branch exists for rollback

---

## Common Issues

### Issue: Config Merge Conflicts

**Symptoms**: Plugin config overwrites your custom settings

**Cause**: Direct copy instead of merge

**Solution**:
```bash
# Restore from backup
cp pyproject.toml.backup pyproject.toml

# Manual merge:
# 1. Open both files side-by-side
# 2. Add plugin sections to your existing file
# 3. Keep your custom settings
# 4. Test that both old and new settings work

# Alternative: Use git merge tool
git checkout backup-before-ai-upgrade -- pyproject.toml
# Then manually add plugin settings
```

### Issue: Existing Tests Fail After Upgrade

**Symptoms**: Tests that passed before upgrade now fail

**Cause**: New linters/formatters found issues, or config conflict

**Solution**:
```bash
# Identify what changed
git diff backup-before-ai-upgrade..HEAD

# If linting issues:
# Fix code to pass new linters, or
# Adjust linter config to be less strict initially

# If config conflict:
# Restore original config
# Merge more carefully

# Rollback if needed:
git checkout backup-before-ai-upgrade
git checkout -b rollback-upgrade
```

### Issue: Docker Build Fails

**Symptoms**: `make docker-build` fails after adding Docker plugin

**Cause**: Dockerfile doesn't match your project structure

**Solution**:
```bash
# Customize Dockerfile for your project
vim .docker/dockerfiles/Dockerfile.backend

# Adjust:
# - COPY paths to match your structure
# - Dependencies installation
# - Entrypoint command

# Test build
docker build -f .docker/dockerfiles/Dockerfile.backend -t test:latest .
```

### Issue: Pre-commit Hooks Block Commits

**Symptoms**: Can't commit because pre-commit hooks fail

**Cause**: Existing code doesn't meet new standards

**Solution**:
```bash
# Temporary skip for existing issues
SKIP=ruff,pylint,eslint git commit -m "Allow commit while fixing lint issues"

# Or fix issues incrementally
pre-commit run --all-files
# Fix reported issues
git add .
git commit -m "Fix linting issues from upgrade"

# Or adjust hook config to be less strict
vim .pre-commit-config.yaml
# Set fail_fast: false or remove strict hooks initially
```

### Issue: Lost Custom Configuration

**Symptoms**: Your custom settings disappeared after upgrade

**Cause**: Plugin config overwrote instead of merging

**Solution**:
```bash
# Restore from backup
git show backup-before-ai-upgrade:pyproject.toml > pyproject.toml.original
git show HEAD:pyproject.toml > pyproject.toml.plugin

# Manual merge
# Combine both files, keeping all important settings
vim pyproject.toml

# Or use git merge
git checkout backup-before-ai-upgrade -- pyproject.toml
# Then re-apply plugin additions manually
```

---

## Best Practices

- **Always backup first**: Create backup branch before starting
- **Test continuously**: Run tests after each plugin addition
- **Merge, don't replace**: Preserve custom configurations
- **Review diffs carefully**: Check what's changing before committing
- **Fix incrementally**: Don't try to fix all lint issues at once
- **Document conflicts**: Note any manual merges needed
- **Keep existing tests passing**: Don't break functionality
- **Be patient**: Upgrades take longer than clean installs
- **Ask before overwriting**: Confirm destructive operations

---

## Rollback Instructions

If upgrade causes issues, rollback to backup:

**Full Rollback**:
```bash
# Return to backup branch
git checkout backup-before-ai-upgrade

# Delete failed upgrade branch
git branch -D upgrade-to-ai-ready

# Start over if desired
git checkout -b upgrade-to-ai-ready-v2
```

**Partial Rollback** (keep some changes):
```bash
# List commits to rollback
git log --oneline

# Revert specific commits
git revert <commit-hash>

# Or reset to specific point
git reset --hard <commit-before-problem>
```

**Restore Specific Files**:
```bash
# Restore one file from backup
git checkout backup-before-ai-upgrade -- path/to/file

# Restore config files
git checkout backup-before-ai-upgrade -- pyproject.toml package.json
```

---

## Next Steps

After successful upgrade:

1. **Fix lint issues incrementally**: Run linters, fix a few issues per PR
2. **Add tests**: Write tests for existing code using new test frameworks
3. **Enhance Docker**: Customize Dockerfiles for your specific needs
4. **Configure CI/CD**: Add GitHub Secrets for deployments
5. **Deploy infrastructure**: Run Terraform to create cloud resources
6. **Document changes**: Update README with new development workflow
7. **Train team**: Share new Make targets and AI-ready patterns

**Related Guides**:
- **Add more capabilities**: [how-to-add-capability.md](how-to-add-capability.md)
- **Create new repos**: [how-to-create-new-ai-repo.md](how-to-create-new-ai-repo.md)

---

## Checklist

### Pre-Upgrade
- [ ] Working tree is clean (no uncommitted changes)
- [ ] Backup branch created
- [ ] Existing tests pass
- [ ] Analysis.txt created
- [ ] Gap-analysis.txt created

### Installation
- [ ] Foundation plugin installed
- [ ] Language plugins upgraded/installed
- [ ] Infrastructure plugins added (if needed)
- [ ] Standards plugins applied

### Configuration Merging
- [ ] pyproject.toml merged (if exists)
- [ ] package.json merged (if exists)
- [ ] .gitignore merged
- [ ] Makefile enhanced
- [ ] agents.md enhanced

### Validation
- [ ] Existing tests still pass
- [ ] New Make targets work
- [ ] No functionality broken
- [ ] Validation.txt created
- [ ] All changes committed

### Cleanup
- [ ] Backup files removed (.backup)
- [ ] Temporary files removed (.plugin)
- [ ] Upgrade branch merged to main
- [ ] Backup branch preserved (for safety)

---

## Related Documentation

- [Create New Repo](how-to-create-new-ai-repo.md) - For starting from scratch
- [Add Capability](how-to-add-capability.md) - For adding single plugins
- [Plugin Manifest](../../plugins/PLUGIN_MANIFEST.yaml) - All available plugins
- [Plugin Architecture](../docs/PLUGIN_ARCHITECTURE.md) - How plugins work

---

**Congratulations!** You've successfully upgraded your existing repository to be AI-ready while preserving all existing functionality. Your repository now has enhanced tooling, infrastructure, and standards.
