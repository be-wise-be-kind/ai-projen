# How-To: Create New AI-Ready Repository

**Purpose**: Guide for creating brand-new AI-ready repositories from empty directories using ai-projen plugin framework

**Scope**: Complete repository setup from initialization through full-stack development environment with languages, infrastructure, and standards

**Overview**: Comprehensive step-by-step guide for AI agents and developers to create production-ready repositories in under 30 minutes. Covers discovery questions, plugin selection, dependency resolution, sequential installation, validation, and resume capability. Transforms empty directories into complete development environments with linting, testing, Docker, CI/CD, and cloud deployment.

**Dependencies**: ai-projen repository access, Git, optional Docker/Node/Python for specific plugins

**Exports**: Fully configured repository with selected language tooling, infrastructure, and quality standards

**Related**: [how-to-add-capability.md](how-to-add-capability.md), [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md), [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml)

**Implementation**: Interactive discovery → plugin selection → dependency resolution → sequential installation → validation

**Difficulty**: intermediate

**Estimated Time**: 20-30min (varies by plugin selection)

---

## Prerequisites

Before creating a new AI-ready repository, ensure you have:

- **Git installed**: `git --version` shows Git 2.30+
- **Empty or new directory**: Target location for the new repository
- **ai-projen repository**: Cloned locally or accessible for plugin copying
- **Basic understanding**: Familiarity with command-line operations
- **Optional runtimes**: Python 3.11+, Node 20+, Docker (depending on what you want to install)

## Overview

### What This Creates

This guide creates a complete, production-ready repository with:

- **Foundation**: `.ai/` directory structure for AI agent navigation
- **Language tooling**: Linters, formatters, test frameworks, type checkers
- **Infrastructure**: Docker containers, CI/CD pipelines, cloud deployment
- **Standards**: Security scanning, documentation templates, pre-commit hooks
- **Consistency**: Unified Makefile commands, integrated workflows

### Workflow Summary

1. **Discovery Phase**: Answer questions about project needs
2. **Plugin Selection**: Build list of plugins based on answers
3. **Dependency Resolution**: Determine installation order
4. **Roadmap Generation**: Create custom installation plan
5. **Sequential Installation**: Install plugins one by one
6. **Validation**: Verify everything works
7. **Resume Capability**: Track progress for interruption recovery

### When to Use This Guide

Use this guide when you:
- Start a new project from scratch
- Want a complete development environment quickly
- Need AI-agent-friendly repository structure
- Want production-ready tooling and standards
- Are creating Python, TypeScript, or full-stack applications

### When NOT to Use This Guide

Do not use this guide when you:
- Have an existing repository (use how-to-upgrade-to-ai-repo.md instead)
- Want to add just one plugin (use how-to-add-capability.md instead)
- Need a highly specialized configuration (install plugins manually)
- Don't want any automated setup (configure manually)

---

## Steps

### Step 1: Initialize Git Repository

Create and initialize the target repository directory.

**Create Target Directory**:
```bash
# Create new directory for your project
mkdir my-new-project
cd my-new-project

# Initialize Git
git init

# Create initial README
echo "# My New Project" > README.md
git add README.md
git commit -m "Initial commit"
```

**Verify Initialization**:
```bash
# Check Git status
git status
# Should show: On branch main, nothing to commit, working tree clean

# Verify directory is empty except Git and README
ls -la
# Should show: .git/, README.md
```

**Why This Matters**: Git initialization is required for all plugins. Starting with a clean Git repository ensures no conflicts and proper version control from the start.

### Step 2: Run Discovery Questions

Answer questions about your project needs to determine which plugins to install.

**Discovery Question Flow**:

**Question 1: What programming language(s) will you use?**
```
Options:
a) Python only
b) TypeScript/JavaScript only
c) Both Python and TypeScript (full-stack)
d) Other (manual plugin selection)

Your choice: [a/b/c/d]
```

**Question 2: Will you use a frontend framework?** (if TypeScript selected)
```
Options:
a) React (recommended)
b) Vue
c) Svelte
d) None (backend or CLI only)

Your choice: [a/b/c/d]
```

**Question 3: Do you need Docker containerization?**
```
Options:
a) Yes - Docker with docker-compose (recommended)
b) No - Local development only

Your choice: [a/b]
```

**Question 4: Do you need CI/CD pipelines?**
```
Options:
a) Yes - GitHub Actions (recommended)
b) Yes - GitLab CI
c) No - Manual testing and deployment

Your choice: [a/b/c]
```

**Question 5: Do you need cloud infrastructure?**
```
Options:
a) Yes - AWS with Terraform (recommended for ECS deployment)
b) Yes - GCP
c) Yes - Azure
d) No - Local or PaaS deployment

Your choice: [a/b/c/d]
```

**Question 6: Apply security standards?**
```
Options:
a) Yes - Secrets scanning, dependency scanning, code scanning (recommended)
b) No - Manual security management

Your choice: [a/b]
```

**Question 7: Apply documentation standards?**
```
Options:
a) Yes - File headers, README templates, API docs (recommended)
b) No - Manual documentation

Your choice: [a/b]
```

**Question 8: Apply pre-commit hooks?**
```
Options:
a) Yes - Automated quality gates before commits (recommended)
b) No - Manual quality checks

Your choice: [a/b]
```

**Example Discovery Session**:
```
Q1: Programming language? → c (Python + TypeScript)
Q2: Frontend framework? → a (React)
Q3: Docker? → a (Yes)
Q4: CI/CD? → a (GitHub Actions)
Q5: Cloud? → a (AWS/Terraform)
Q6: Security? → a (Yes)
Q7: Documentation? → a (Yes)
Q8: Pre-commit hooks? → a (Yes)

Result: Full-stack application with all recommended tooling
```

**Why This Matters**: Discovery questions ensure you get exactly what you need without over-engineering or under-tooling your repository.

### Step 3: Build Plugin List

Based on discovery answers, build the complete list of plugins to install.

**Plugin Selection Logic**:

**Always Installed**:
- `foundation/ai-folder` - Required for all repositories

**Based on Language Choice**:
- Python selected → `languages/python`
- TypeScript selected → `languages/typescript`
- Both → Both plugins

**Based on Infrastructure Choice**:
- Docker selected → `infrastructure/docker`
- GitHub Actions selected → `infrastructure/ci-cd/github-actions`
- AWS/Terraform selected → `infrastructure/iac/terraform-aws`

**Based on Standards Choice**:
- Security selected → `standards/security`
- Documentation selected → `standards/documentation`
- Pre-commit hooks selected → `standards/pre-commit-hooks`

**Example Plugin List** (from above discovery):
```yaml
plugins_to_install:
  - foundation/ai-folder              # Always required
  - languages/python                  # Python tooling
  - languages/typescript              # TypeScript tooling
  - infrastructure/docker             # Docker containerization
  - infrastructure/ci-cd/github-actions  # CI/CD pipelines
  - infrastructure/iac/terraform-aws  # AWS deployment
  - standards/security                # Security scanning
  - standards/documentation           # Documentation standards
  - standards/pre-commit-hooks        # Quality gates

installation_order:  # Dependencies resolved
  1. foundation/ai-folder
  2. languages/python
  3. languages/typescript
  4. infrastructure/docker
  5. infrastructure/ci-cd/github-actions
  6. infrastructure/iac/terraform-aws
  7. standards/security
  8. standards/documentation
  9. standards/pre-commit-hooks

estimated_time: 25-30 minutes
```

**Dependency Resolution**:
```
foundation/ai-folder → (no dependencies)
languages/python → requires: foundation/ai-folder
languages/typescript → requires: foundation/ai-folder
infrastructure/docker → requires: language plugins
infrastructure/ci-cd/github-actions → requires: language plugins
infrastructure/iac/terraform-aws → requires: docker
standards/security → requires: language plugins
standards/documentation → requires: foundation/ai-folder
standards/pre-commit-hooks → requires: language plugins
```

**Why This Matters**: Proper dependency ordering ensures each plugin has its prerequisites when installed. Installing out of order causes failures.

### Step 4: Generate Installation Roadmap

Create a custom roadmap document for tracking progress and enabling resume capability.

**Create Roadmap Directory**:
```bash
# Create roadmap tracking directory
mkdir -p roadmap/new-repo-setup

# Generate roadmap file
cat > roadmap/new-repo-setup/INSTALLATION_ROADMAP.md << 'EOF'
# Installation Roadmap - My New Project

## Project Configuration

**Languages**: Python, TypeScript
**Frontend**: React
**Infrastructure**: Docker, GitHub Actions, Terraform/AWS
**Standards**: Security, Documentation, Pre-commit Hooks

## Installation Plan

### Phase 1: Foundation
- [ ] Install foundation/ai-folder

### Phase 2: Languages
- [ ] Install languages/python
- [ ] Install languages/typescript

### Phase 3: Infrastructure
- [ ] Install infrastructure/docker
- [ ] Install infrastructure/ci-cd/github-actions
- [ ] Install infrastructure/iac/terraform-aws

### Phase 4: Standards
- [ ] Install standards/security
- [ ] Install standards/documentation
- [ ] Install standards/pre-commit-hooks

## Progress Tracking

**Started**: [TIMESTAMP]
**Current Phase**: Phase 1
**Current Plugin**: foundation/ai-folder
**Completed**: 0/9 plugins
**Estimated Remaining Time**: 25-30 minutes

## Resume Instructions

If interrupted, resume by:
1. Check last completed plugin in checklist above
2. Start with next unchecked plugin
3. Follow AGENT_INSTRUCTIONS.md for that plugin
4. Update checklist when complete
5. Continue until all plugins installed

## Validation Checklist

After all installations:
- [ ] All Make targets work
- [ ] All tests pass
- [ ] Docker builds succeed
- [ ] CI/CD workflows valid
- [ ] All config files present
EOF
```

**Commit Roadmap**:
```bash
git add roadmap/
git commit -m "Add installation roadmap for new repo setup"
```

**Why This Matters**: The roadmap provides resumability, progress tracking, and clear next steps if installation is interrupted.

### Step 5: Install Foundation Plugin

Install the foundation/ai-folder plugin first (required for all other plugins).

**Locate Plugin**:
```bash
# Navigate to ai-projen repository
cd /path/to/ai-projen

# View foundation plugin instructions
cat plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md
```

**Installation Commands**:
```bash
# Return to your new repository
cd /path/to/my-new-project

# Create .ai directory structure
mkdir -p .ai/{docs,howto,templates,features}

# Copy foundation templates from ai-projen
cp /path/to/ai-projen/plugins/foundation/ai-folder/ai-content/templates/index.yaml.template .ai/index.yaml
cp /path/to/ai-projen/plugins/foundation/ai-folder/ai-content/templates/layout.yaml.template .ai/layout.yaml
cp /path/to/ai-projen/plugins/foundation/ai-folder/ai-content/templates/agents.md.template ./agents.md

# Customize index.yaml
sed -i 's/{{PROJECT_NAME}}/my-new-project/g' .ai/index.yaml
sed -i 's/{{PROJECT_TYPE}}/full-stack-application/g' .ai/index.yaml

# Customize agents.md
sed -i 's/{{PROJECT_NAME}}/my-new-project/g' agents.md
sed -i 's/{{PROJECT_DESCRIPTION}}/Full-stack application with Python backend and React frontend/g' agents.md
```

**Validation**:
```bash
# Verify .ai structure
ls -la .ai/
# Should show: docs/, howto/, templates/, features/, index.yaml, layout.yaml

# Verify agents.md
cat agents.md
# Should show customized project information

# Commit
git add .ai/ agents.md
git commit -m "Install foundation/ai-folder plugin"
```

**Update Roadmap**:
```bash
# Mark foundation plugin complete
sed -i 's/\[ \] Install foundation\/ai-folder/\[x\] Install foundation\/ai-folder/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 0\/9/Completed: 1\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/
git commit -m "Update roadmap: foundation/ai-folder complete"
```

**Why This Matters**: The foundation plugin creates the `.ai/` structure that all other plugins depend on. Without it, subsequent installations will fail.

### Step 6: Install Language Plugins

Install Python and TypeScript language plugins with linting, formatting, and testing.

**Install Python Plugin**:
```bash
# Read Python plugin instructions
cat /path/to/ai-projen/plugins/languages/python/AGENT_INSTRUCTIONS.md

# Follow installation steps (summarized):

# 1. Copy Python configs
cp /path/to/ai-projen/plugins/languages/python/templates/pyproject.toml ./
cp /path/to/ai-projen/plugins/languages/python/templates/.ruff.toml ./
cp /path/to/ai-projen/plugins/languages/python/templates/Makefile.python ./

# 2. Create Python directory structure
mkdir -p src tests

# 3. Include Python Makefile
echo "-include Makefile.python" >> Makefile

# 4. Extend agents.md
cat /path/to/ai-projen/plugins/languages/python/templates/agents-extension.md >> agents.md

# 5. Test installation
make lint-python  # Should run (may show "no Python files yet")
make test-python  # Should run (may show "no tests yet")

# 6. Commit
git add .
git commit -m "Install languages/python plugin"

# Update roadmap
sed -i 's/\[ \] Install languages\/python/\[x\] Install languages\/python/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 1\/9/Completed: 2\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: languages/python complete"
```

**Install TypeScript Plugin**:
```bash
# Read TypeScript plugin instructions
cat /path/to/ai-projen/plugins/languages/typescript/AGENT_INSTRUCTIONS.md

# Follow installation steps (summarized):

# 1. Copy TypeScript configs
cp /path/to/ai-projen/plugins/languages/typescript/templates/package.json ./
cp /path/to/ai-projen/plugins/languages/typescript/templates/tsconfig.json ./
cp /path/to/ai-projen/plugins/languages/typescript/templates/.eslintrc.json ./
cp /path/to/ai-projen/plugins/languages/typescript/templates/.prettierrc.json ./
cp /path/to/ai-projen/plugins/languages/typescript/templates/vite.config.ts ./
cp /path/to/ai-projen/plugins/languages/typescript/templates/Makefile.typescript ./

# 2. Create TypeScript directory structure
mkdir -p frontend/src frontend/public

# 3. Install dependencies
npm install

# 4. Include TypeScript Makefile
echo "-include Makefile.typescript" >> Makefile

# 5. Extend agents.md
cat /path/to/ai-projen/plugins/languages/typescript/templates/agents-extension.md >> agents.md

# 6. Test installation
make lint-ts  # Should run
make test-ts  # Should run

# 7. Commit
git add .
git commit -m "Install languages/typescript plugin"

# Update roadmap
sed -i 's/\[ \] Install languages\/typescript/\[x\] Install languages\/typescript/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 2\/9/Completed: 3\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: languages/typescript complete"
```

**Why This Matters**: Language plugins provide the core development tooling (linting, formatting, testing) needed for writing quality code.

### Step 7: Install Infrastructure Plugins

Install Docker, CI/CD, and cloud infrastructure plugins.

**Install Docker Plugin**:
```bash
# Follow Docker plugin AGENT_INSTRUCTIONS.md
cat /path/to/ai-projen/plugins/infrastructure/docker/AGENT_INSTRUCTIONS.md

# Copy Docker templates
mkdir -p .docker/dockerfiles .docker/compose
cp /path/to/ai-projen/plugins/infrastructure/docker/templates/Dockerfile.python .docker/dockerfiles/Dockerfile.backend
cp /path/to/ai-projen/plugins/infrastructure/docker/templates/Dockerfile.react .docker/dockerfiles/Dockerfile.frontend
cp /path/to/ai-projen/plugins/infrastructure/docker/templates/docker-compose.yml .docker/compose/docker-compose.dev.yml
cp /path/to/ai-projen/plugins/infrastructure/docker/templates/.dockerignore ./
cp /path/to/ai-projen/plugins/infrastructure/docker/templates/Makefile.docker ./

# Include Docker Makefile
echo "-include Makefile.docker" >> Makefile

# Test Docker
make docker-build
make docker-up

# Commit
git add .
git commit -m "Install infrastructure/docker plugin"

# Update roadmap
sed -i 's/\[ \] Install infrastructure\/docker/\[x\] Install infrastructure\/docker/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 3\/9/Completed: 4\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: infrastructure/docker complete"
```

**Install GitHub Actions Plugin**:
```bash
# Follow GitHub Actions AGENT_INSTRUCTIONS.md
cat /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/AGENT_INSTRUCTIONS.md

# Copy CI/CD workflows
mkdir -p .github/workflows
cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/ci-python.yml .github/workflows/
cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/ci-typescript.yml .github/workflows/
cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/ci-full-stack.yml .github/workflows/
cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/build-ecr.yml .github/workflows/
cp /path/to/ai-projen/plugins/infrastructure/ci-cd/github-actions/templates/deploy-aws.yml .github/workflows/

# Commit
git add .
git commit -m "Install infrastructure/ci-cd/github-actions plugin"

# Update roadmap
sed -i 's/\[ \] Install infrastructure\/ci-cd\/github-actions/\[x\] Install infrastructure\/ci-cd\/github-actions/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 4\/9/Completed: 5\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: CI/CD complete"
```

**Install Terraform/AWS Plugin**:
```bash
# Follow Terraform AGENT_INSTRUCTIONS.md
cat /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/AGENT_INSTRUCTIONS.md

# Copy Terraform templates
mkdir -p infra/terraform/workspaces/{vpc,ecs,alb}
cp -r /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/workspaces/* infra/terraform/workspaces/
cp /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/backend.tf infra/terraform/
cp /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/terraform.tfvars.example infra/terraform/
cp /path/to/ai-projen/plugins/infrastructure/iac/terraform-aws/templates/Makefile.terraform ./

# Include Terraform Makefile
echo "-include Makefile.terraform" >> Makefile

# Commit
git add .
git commit -m "Install infrastructure/iac/terraform-aws plugin"

# Update roadmap
sed -i 's/\[ \] Install infrastructure\/iac\/terraform-aws/\[x\] Install infrastructure\/iac\/terraform-aws/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 5\/9/Completed: 6\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: Terraform/AWS complete"
```

**Why This Matters**: Infrastructure plugins provide containerization, automated testing/deployment, and cloud infrastructure as code.

### Step 8: Install Standards Plugins

Install security, documentation, and pre-commit hooks plugins.

**Install Security Plugin**:
```bash
# Follow Security AGENT_INSTRUCTIONS.md
cat /path/to/ai-projen/plugins/standards/security/AGENT_INSTRUCTIONS.md

# Copy security templates
cp /path/to/ai-projen/plugins/standards/security/ai-content/templates/.gitignore.security.template ./.gitignore.security
cp /path/to/ai-projen/plugins/standards/security/ai-content/templates/.env.example.template ./.env.example
cp /path/to/ai-projen/plugins/standards/security/ai-content/templates/github-workflow-security.yml.template .github/workflows/security.yml

# Merge .gitignore.security into .gitignore
cat .gitignore.security >> .gitignore
rm .gitignore.security

# Commit
git add .
git commit -m "Install standards/security plugin"

# Update roadmap
sed -i 's/\[ \] Install standards\/security/\[x\] Install standards\/security/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 6\/9/Completed: 7\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: security complete"
```

**Install Documentation Plugin**:
```bash
# Follow Documentation AGENT_INSTRUCTIONS.md
cat /path/to/ai-projen/plugins/standards/documentation/AGENT_INSTRUCTIONS.md

# Copy documentation standards to .ai/docs/
cp /path/to/ai-projen/plugins/standards/documentation/ai-content/docs/file-headers.md .ai/docs/
cp /path/to/ai-projen/plugins/standards/documentation/ai-content/docs/readme-standards.md .ai/docs/
cp /path/to/ai-projen/plugins/standards/documentation/ai-content/docs/api-documentation.md .ai/docs/

# Copy templates
cp /path/to/ai-projen/plugins/standards/documentation/ai-content/templates/README.template .ai/templates/

# Commit
git add .
git commit -m "Install standards/documentation plugin"

# Update roadmap
sed -i 's/\[ \] Install standards\/documentation/\[x\] Install standards\/documentation/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 7\/9/Completed: 8\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: documentation complete"
```

**Install Pre-commit Hooks Plugin**:
```bash
# Follow Pre-commit AGENT_INSTRUCTIONS.md
cat /path/to/ai-projen/plugins/standards/pre-commit-hooks/AGENT_INSTRUCTIONS.md

# Copy pre-commit config
cp /path/to/ai-projen/plugins/standards/pre-commit-hooks/ai-content/templates/.pre-commit-config.yaml.template ./.pre-commit-config.yaml

# Install pre-commit framework
pip install pre-commit
pre-commit install
pre-commit install --hook-type pre-push

# Test hooks
pre-commit run --all-files

# Commit
git add .
git commit -m "Install standards/pre-commit-hooks plugin"

# Update roadmap
sed -i 's/\[ \] Install standards\/pre-commit-hooks/\[x\] Install standards\/pre-commit-hooks/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
sed -i 's/Completed: 8\/9/Completed: 9\/9/' roadmap/new-repo-setup/INSTALLATION_ROADMAP.md
git add roadmap/ && git commit -m "Update roadmap: pre-commit hooks complete - ALL PLUGINS INSTALLED"
```

**Why This Matters**: Standards plugins enforce quality, security, and documentation consistency across the repository.

### Step 9: Validate Complete Installation

Verify all plugins are installed correctly and integrated properly.

**Run All Validation Commands**:
```bash
# Check Make targets
make help
# Should show all plugin targets: lint-python, lint-ts, docker-build, test-all, etc.

# Test Python tooling
make lint-python
make format-python
make test-python

# Test TypeScript tooling
make lint-ts
make format-ts
make test-ts

# Test Docker
make docker-build
make docker-up
docker ps  # Should show running containers
make docker-down

# Test CI/CD workflows (syntax check)
cat .github/workflows/*.yml | grep "name:"
# Should list all workflows

# Test Terraform (validation only, no deployment)
cd infra/terraform/workspaces/vpc
terraform init
terraform validate
cd ../../../../

# Test pre-commit hooks
pre-commit run --all-files
# Should run all configured hooks

# Check security
cat .env.example  # Should show template env vars
cat .gitignore | grep ".env"  # Should ignore .env files
```

**Validation Checklist**:
```bash
# Review roadmap completion
cat roadmap/new-repo-setup/INSTALLATION_ROADMAP.md

# Should show all checkboxes marked:
# [x] Install foundation/ai-folder
# [x] Install languages/python
# [x] Install languages/typescript
# [x] Install infrastructure/docker
# [x] Install infrastructure/ci-cd/github-actions
# [x] Install infrastructure/iac/terraform-aws
# [x] Install standards/security
# [x] Install standards/documentation
# [x] Install standards/pre-commit-hooks

# All validation items should pass
```

**Final Commit**:
```bash
# Mark validation complete in roadmap
cat >> roadmap/new-repo-setup/INSTALLATION_ROADMAP.md << 'EOF'

## Installation Complete

**Completed**: [TIMESTAMP]
**Total Time**: [ACTUAL_TIME]
**Status**: ✅ All plugins installed and validated

All Make targets work, Docker builds succeed, CI/CD workflows valid, tests pass.
EOF

git add roadmap/
git commit -m "Installation complete: All 9 plugins installed and validated"
```

**Why This Matters**: Validation ensures everything works together. Catching integration issues now prevents problems during development.

---

## Verification

After completing all installation steps, verify the repository is production-ready:

**Check 1: Directory Structure**
```bash
# Verify complete structure
ls -la

# Should show:
# .ai/              - AI navigation
# .docker/          - Docker configs
# .github/          - CI/CD workflows
# infra/            - Terraform infrastructure
# src/              - Python source
# frontend/         - React source
# tests/            - Python tests
# roadmap/          - Installation tracking
# agents.md         - AI entry point
# Makefile          - Unified commands
# Makefile.*        - Plugin-specific targets
# pyproject.toml    - Python config
# package.json      - TypeScript config
# docker-compose.yml - Development orchestration
# .pre-commit-config.yaml - Quality gates
```

**Check 2: All Make Targets Work**
```bash
# List all targets
make help

# Test each category
make lint-all
make format-all
make test-all
make docker-build
```

**Check 3: Git History Clean**
```bash
# Review commits
git log --oneline

# Should show progression:
# - Initial commit
# - Add installation roadmap
# - Install foundation/ai-folder
# - Install languages/python
# - Install languages/typescript
# - Install infrastructure/docker
# - Install CI/CD
# - Install Terraform
# - Install security
# - Install documentation
# - Install pre-commit hooks
# - Installation complete
```

**Check 4: agents.md Complete**
```bash
# Verify agents.md has all plugin sections
cat agents.md | grep "##"

# Should show sections for:
# - Project Overview
# - Python Standards
# - TypeScript Standards
# - Docker Usage
# - CI/CD Pipelines
# - Infrastructure Deployment
# - Security Standards
# - Documentation Standards
```

**Success Criteria**:
- [ ] All 9 plugins installed
- [ ] All Make targets execute successfully
- [ ] Docker builds and runs
- [ ] CI/CD workflows valid (syntax check)
- [ ] Terraform validates
- [ ] Pre-commit hooks work
- [ ] All tests pass (even if no tests yet)
- [ ] agents.md complete and accurate
- [ ] .ai/index.yaml updated
- [ ] Roadmap shows 100% complete

---

## Common Issues

### Issue: Plugin Installation Fails - Missing Dependency

**Symptoms**: Installation fails with "prerequisite not found"

**Cause**: Trying to install plugin before its dependencies

**Solution**:
```bash
# Check dependency requirements
cat /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep -A 5 "dependencies:"

# Install dependencies first
# Example: Docker requires language plugins
# Install languages/python BEFORE infrastructure/docker
```

### Issue: Make Targets Don't Work

**Symptoms**: `make lint-python` shows "No rule to make target"

**Cause**: Makefile.<plugin> not included in main Makefile

**Solution**:
```bash
# Check if Makefile exists
ls -la Makefile.*

# Verify main Makefile includes it
cat Makefile | grep "include"

# If missing, add:
echo "-include Makefile.python" >> Makefile
echo "-include Makefile.typescript" >> Makefile
echo "-include Makefile.docker" >> Makefile
```

### Issue: Docker Build Fails

**Symptoms**: `make docker-build` fails with errors

**Cause**: Docker not installed or not running

**Solution**:
```bash
# Check Docker installation
docker --version
docker compose version

# Start Docker daemon
sudo systemctl start docker  # Linux
# Or start Docker Desktop (macOS/Windows)

# Verify Docker works
docker ps

# Retry build
make docker-build
```

### Issue: Pre-commit Hooks Not Running

**Symptoms**: Commits succeed without hook execution

**Cause**: Pre-commit not installed

**Solution**:
```bash
# Install pre-commit framework
pip install pre-commit

# Install hooks
pre-commit install
pre-commit install --hook-type pre-push

# Test hooks
pre-commit run --all-files

# Retry commit
git commit -m "Test commit with hooks"
```

### Issue: Interrupted Installation - How to Resume

**Symptoms**: Installation stopped partway through

**Cause**: Process interrupted, connection lost, error occurred

**Solution**:
```bash
# Check roadmap for last completed plugin
cat roadmap/new-repo-setup/INSTALLATION_ROADMAP.md

# Find first unchecked plugin
# Example: If stopped at Docker, roadmap shows:
# [x] foundation/ai-folder
# [x] languages/python
# [x] languages/typescript
# [ ] infrastructure/docker  ← Start here

# Resume installation
# Follow AGENT_INSTRUCTIONS.md for next plugin
cat /path/to/ai-projen/plugins/infrastructure/docker/AGENT_INSTRUCTIONS.md

# Continue from that plugin onwards
```

### Issue: Node Modules or Python Packages Not Found

**Symptoms**: Linting/testing fails with "module not found"

**Cause**: Dependencies not installed

**Solution**:
```bash
# Install Python dependencies
pip install -r requirements.txt
# Or if using poetry:
poetry install

# Install Node dependencies
npm install

# Verify installations
pip list
npm list

# Retry linting/testing
make lint-all
make test-all
```

---

## Best Practices

- **Answer discovery questions honestly**: Don't select tools you don't need
- **Follow installation order**: Respect dependency chains (foundation → languages → infrastructure → standards)
- **Test after each plugin**: Validate one plugin works before installing next
- **Commit after each plugin**: Enables easy rollback if something breaks
- **Update roadmap consistently**: Track progress for resume capability
- **Read AGENT_INSTRUCTIONS.md**: Don't skip plugin installation guides
- **Keep installations clean**: Remove any failed attempts before retrying
- **Use recommended options**: Default selections are battle-tested
- **Validate frequently**: Run `make help` and test targets after each install

---

## Next Steps

After creating your new AI-ready repository:

**Immediate Next Steps**:
1. **Start developing**: Add your application code to `src/` and `frontend/src/`
2. **Write tests**: Add tests to `tests/` and `frontend/src/__tests__/`
3. **Configure deployment**: Update `infra/terraform/terraform.tfvars` with your AWS details
4. **Set up CI/CD secrets**: Add AWS credentials to GitHub Secrets
5. **Create first PR**: Push to GitHub and let CI/CD run

**Development Workflow**:
```bash
# Start development environment
make docker-up

# Run linting
make lint-all

# Run tests
make test-all

# Build for production
make docker-build-prod

# Deploy to AWS (when ready)
make terraform-apply
```

**Related Guides**:
- **Add more capabilities**: [how-to-add-capability.md](how-to-add-capability.md)
- **Plugin discovery**: [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md)
- **Create custom plugins**: [how-to-create-a-language-plugin.md](how-to-create-a-language-plugin.md)

**Advanced Topics**:
- **Custom configurations**: Modify plugin configs to match your preferences
- **Additional plugins**: Browse PLUGIN_MANIFEST.yaml for more options
- **Plugin development**: Create custom plugins for your specific needs

---

## Checklist

Use this checklist to ensure complete setup:

### Pre-Installation
- [ ] Git installed and configured
- [ ] Target directory created
- [ ] Git repository initialized
- [ ] Initial README committed
- [ ] ai-projen repository accessible

### Discovery Phase
- [ ] All discovery questions answered
- [ ] Plugin list generated
- [ ] Dependencies identified
- [ ] Installation order determined
- [ ] Roadmap created

### Installation Phase
- [ ] foundation/ai-folder installed
- [ ] Language plugins installed (Python, TypeScript)
- [ ] Docker plugin installed
- [ ] CI/CD plugin installed
- [ ] Terraform plugin installed
- [ ] Security plugin installed
- [ ] Documentation plugin installed
- [ ] Pre-commit hooks plugin installed

### Validation Phase
- [ ] All Make targets work
- [ ] Python linting/testing works
- [ ] TypeScript linting/testing works
- [ ] Docker builds successfully
- [ ] CI/CD workflows validate
- [ ] Terraform validates
- [ ] Pre-commit hooks run
- [ ] agents.md complete
- [ ] .ai/index.yaml updated

### Post-Installation
- [ ] Roadmap marked complete
- [ ] All changes committed
- [ ] Repository pushed to GitHub (if applicable)
- [ ] CI/CD pipelines green
- [ ] Development environment tested

---

## Related Documentation

- [Plugin Discovery](how-to-discover-and-install-plugins.md) - Discover available plugins
- [Add Capability](how-to-add-capability.md) - Add single plugin incrementally
- [Upgrade Repository](how-to-upgrade-to-ai-repo.md) - Add AI patterns to existing repo
- [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml) - All available plugins
- [PLUGIN_ARCHITECTURE.md](../docs/PLUGIN_ARCHITECTURE.md) - Plugin structure
- [HOWTO_STANDARDS.md](../docs/HOWTO_STANDARDS.md) - How-to guide standards

---

**Congratulations!** You've created a production-ready, AI-ready repository in under 30 minutes. Your repository now has professional-grade tooling, infrastructure, and standards that would normally take days to set up manually.
