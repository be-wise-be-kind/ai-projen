# How-To: Add Individual Capability to Existing Repository

**Purpose**: Guide for adding single plugin capabilities to an existing ai-projen repository incrementally

**Scope**: Standalone plugin installation for users who want to add one capability at a time rather than using orchestrators or full application templates

**Overview**: Step-by-step guide for browsing available plugins, selecting a single capability to add, checking dependencies, installing the plugin following AGENT_INSTRUCTIONS.md, validating integration with existing setup, and testing the new capability. Optimized for quick, incremental capability additions with smart dependency detection and conflict prevention.

**Dependencies**: foundation/ai-folder plugin (required for all plugins), PLUGIN_MANIFEST.yaml for plugin discovery

**Exports**: Knowledge of plugin selection, dependency checking, standalone installation, integration validation, and testing procedures

**Related**: [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md), [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml), [PLUGIN_ARCHITECTURE.md](../docs/PLUGIN_ARCHITECTURE.md)

**Implementation**: Browse-select-install-validate workflow with dependency resolution and conflict detection

**Difficulty**: intermediate

**Estimated Time**: 10min per plugin (excluding dependency installations)

---

## Prerequisites

Before adding a capability, ensure you have:

- **Git repository**: Initialized with `git init`
- **foundation/ai-folder**: The `.ai/` directory structure must exist (if not, install foundation/ai-folder first)
- **agents.md file**: The primary AI entry point must exist at repository root
- **Working directory**: You are in the repository root directory
- **Plugin knowledge**: Understanding that plugins are modular, composable capabilities

## Overview

### What is a Capability?

A capability is a discrete piece of functionality provided by a plugin, such as:
- **Language support**: Python linting, TypeScript formatting, Go testing
- **Infrastructure**: Docker containerization, GitHub Actions CI/CD, Terraform deployment
- **Standards**: Security scanning, documentation templates, pre-commit hooks
- **Complete applications**: Python CLI tool, React+Python full-stack app (meta-plugins)

### Why Add Capabilities Incrementally?

Adding capabilities one at a time offers several advantages:
- **Control**: Choose exactly what you need, no unwanted tooling
- **Understanding**: Learn what each plugin provides as you install it
- **Flexibility**: Mix and match plugins for custom configurations
- **Debugging**: Easier to identify issues when adding one thing at a time
- **Existing projects**: Add to projects that already have some structure

### When to Use This Guide

Use this guide when you:
- Want to add a single capability to your repository
- Have an existing project and want to add one more plugin
- Prefer granular control over what gets installed
- Want to understand each plugin before installing
- Are building a custom configuration not covered by application templates

### When NOT to Use This Guide

Do not use this guide when you:
- Want a complete, ready-to-code application (use application plugins instead)
- Are starting from scratch and want all tooling at once (use how-to-create-new-ai-repo.md)
- Don't have foundation/ai-folder installed yet (install that first)

---

## Steps

### Step 1: Browse Available Plugins

Discover what plugins are available by examining the plugin manifest.

**View All Available Plugins**:
```bash
cat plugins/PLUGIN_MANIFEST.yaml
```

**Plugin Categories**:

1. **Foundation** (universal, always required):
   - `ai-folder` - Creates .ai/ directory structure for AI navigation

2. **Languages** (language-specific tooling):
   - `python` - Python linting (Ruff), formatting (Black), testing (pytest), type checking (MyPy), security (Bandit)
   - `typescript` - TypeScript/JavaScript linting (ESLint), formatting (Prettier), testing (Vitest)

3. **Infrastructure** (deployment and tooling):
   - `containerization/docker` - Docker multi-stage builds, docker-compose orchestration
   - `ci-cd/github-actions` - GitHub Actions CI/CD pipelines
   - `iac/terraform-aws` - Terraform infrastructure as code for AWS deployment

4. **Standards** (quality and governance):
   - `security` - Security scanning (Gitleaks, Trivy, Bandit)
   - `documentation` - Documentation standards and file headers
   - `pre-commit-hooks` - Pre-commit hooks for quality gates

5. **Applications** (complete application types - meta-plugins):
   - `python-cli` - Complete Python CLI application with Click, Docker, testing, CI/CD
   - `react-python-fullstack` - Full-stack web app with React frontend and FastAPI backend

**Check Plugin Status**:
```bash
# Find stable (production-ready) plugins
grep "status: stable" plugins/PLUGIN_MANIFEST.yaml

# Find planned plugins
grep "status: planned" plugins/PLUGIN_MANIFEST.yaml
```

**Why This Matters**: The manifest shows all available plugins, their status, locations, and dependencies. Only install plugins with `status: stable` for production use.

### Step 2: Select Plugin to Install

Choose one plugin based on your immediate need.

**Selection Criteria**:

1. **Capability match**: Does this plugin provide what you need?
2. **Status check**: Is it `stable` (production-ready)?
3. **Dependency review**: What dependencies does it require?
4. **Integration fit**: Will it integrate with your existing setup?

**Plugin Selection Examples**:

**Example 1**: "I need Python linting"
```bash
# Check Python plugin details
grep -A 30 "python:" plugins/PLUGIN_MANIFEST.yaml
```

Result: `languages/python` plugin provides Ruff linting + Black formatting + pytest testing + MyPy type checking + Bandit security

**Example 2**: "I need Docker containerization"
```bash
# Check Docker plugin details
grep -A 20 "docker:" plugins/PLUGIN_MANIFEST.yaml
```

Result: `infrastructure/containerization/docker` plugin provides multi-stage Dockerfiles and docker-compose orchestration

**Example 3**: "I need CI/CD pipeline"
```bash
# Check GitHub Actions plugin details
grep -A 15 "github-actions:" plugins/PLUGIN_MANIFEST.yaml
```

Result: `infrastructure/ci-cd/github-actions` plugin provides CI/CD workflows for test, lint, build, deploy

**View Plugin Details**:
```bash
# Navigate to plugin directory
cd plugins/<category>/<plugin-name>/

# Read plugin overview
cat README.md

# View installation instructions
cat AGENT_INSTRUCTIONS.md
```

**Why This Matters**: Understanding what a plugin provides before installation prevents installing the wrong plugin or installing multiple plugins that provide overlapping functionality.

### Step 3: Check Dependencies

Verify all plugin dependencies are met before installation.

**Dependency Check Process**:

1. **Check foundation/ai-folder** (required for ALL plugins):
   ```bash
   # Check if .ai/ directory exists
   ls -la .ai/

   # Check if agents.md exists
   ls -la agents.md
   ```

   If missing: Install foundation/ai-folder first using `plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md`

2. **Check plugin-specific dependencies**:
   ```bash
   # View dependencies from manifest
   grep -A 5 "dependencies:" plugins/PLUGIN_MANIFEST.yaml
   ```

3. **Check language runtime** (for language plugins):
   ```bash
   # Python plugin requires Python 3.11+
   python --version

   # TypeScript plugin requires Node 18+
   node --version
   ```

4. **Check system tools**:
   ```bash
   # Docker plugin requires Docker
   docker --version
   docker compose version

   # Terraform plugin requires Terraform
   terraform --version
   ```

**Dependency Resolution**:

If dependencies are missing:
- **foundation/ai-folder**: Install first (it's quick, <5 minutes)
- **Language plugins**: Install before infrastructure plugins that use them
- **System tools**: Install via package manager (apt, brew, choco)
- **Runtime versions**: Upgrade if version too old

**Warning Signs**:
- ❌ Attempting to install Docker plugin without Python/TypeScript plugins
- ❌ Installing language plugin without foundation/ai-folder
- ❌ Missing runtime (Python, Node, Docker, etc.)

**Why This Matters**: Installing plugins without dependencies will fail or cause integration issues. Dependencies must be installed in the correct order.

### Step 4: Locate Plugin Installation Instructions

Find and review the plugin's AGENT_INSTRUCTIONS.md file.

**Standard Location Pattern**:
```bash
# Language plugins
plugins/languages/<language>/AGENT_INSTRUCTIONS.md

# Infrastructure plugins
plugins/infrastructure/<category>/<plugin>/AGENT_INSTRUCTIONS.md

# Standards plugins
plugins/standards/<plugin>/AGENT_INSTRUCTIONS.md

# Application plugins
plugins/applications/<app-name>/AGENT_INSTRUCTIONS.md

# Foundation plugins
plugins/foundation/<plugin>/AGENT_INSTRUCTIONS.md
```

**Navigate to Instructions**:
```bash
# Example: Python plugin
cat plugins/languages/python/AGENT_INSTRUCTIONS.md

# Example: Docker plugin
cat plugins/infrastructure/docker/AGENT_INSTRUCTIONS.md

# Example: Security plugin
cat plugins/standards/security/AGENT_INSTRUCTIONS.md
```

**Review Installation Steps**:

Every AGENT_INSTRUCTIONS.md follows this structure:
1. **Prerequisites**: What must exist before installation
2. **Installation Steps**: Sequential steps to install the plugin
3. **Validation**: How to test the plugin works
4. **Success Criteria**: Checklist of completion requirements

**Why This Matters**: AGENT_INSTRUCTIONS.md is the authoritative source for plugin installation. It contains complete, step-by-step instructions that work for both AI agents and human developers.

### Step 5: Follow Installation Instructions

Execute the installation steps from AGENT_INSTRUCTIONS.md.

**Installation Workflow** (common pattern across all plugins):

1. **Gather configuration preferences**:
   - Choose tool options (linter, formatter, test framework)
   - Specify directories (source, test, docs)
   - Set environment variables (ports, names, paths)

2. **Create directory structure**:
   ```bash
   # Example: Docker plugin creates .docker/ directories
   mkdir -p .docker/dockerfiles
   mkdir -p .docker/compose
   ```

3. **Copy configuration files**:
   ```bash
   # Example: Python plugin copies tool configs
   cp plugins/languages/python/templates/pyproject.toml ./
   cp plugins/languages/python/templates/.ruff.toml ./
   cp plugins/languages/python/templates/pytest.ini ./
   ```

4. **Add Makefile targets**:
   ```bash
   # Example: Python plugin adds Makefile.python
   cp plugins/languages/python/templates/makefile-python.mk ./Makefile.python

   # Include in main Makefile
   echo "-include Makefile.python" >> Makefile
   ```

5. **Extend agents.md**:
   ```bash
   # Example: Append Python standards to agents.md
   cat plugins/languages/python/templates/agents-extension.md >> agents.md
   ```

6. **Update .ai/index.yaml**:
   ```bash
   # Add plugin to installed plugins list
   echo "  - languages/python" >> .ai/index.yaml
   ```

**Installation Tips**:

- **Read carefully**: AGENT_INSTRUCTIONS.md contains all necessary details
- **Follow order**: Steps must be executed sequentially
- **Check paths**: Ensure file paths are correct for your repository structure
- **Backup configs**: If files already exist, backup before overwriting
- **Ask about conflicts**: If config files exist, decide merge vs replace strategy

**Why This Matters**: Following AGENT_INSTRUCTIONS.md exactly ensures clean installation with all files in correct locations, proper Makefile integration, and updated agents.md guidance.

### Step 6: Validate Integration

Ensure the plugin integrates cleanly with existing setup.

**Integration Checks**:

1. **Config file conflicts**:
   ```bash
   # Check if plugin config files already existed
   git status

   # Review changes to existing files
   git diff
   ```

   **Resolution**:
   - New files: Added cleanly (good)
   - Modified files: Review changes, ensure no overwrites of custom settings
   - Conflicts: Manually merge plugin configs with existing configs

2. **Makefile target collisions**:
   ```bash
   # Check for duplicate target names
   make help

   # Test new targets
   make <new-target-name>
   ```

   **Resolution**:
   - Unique targets: No conflicts (good)
   - Duplicate targets: Rename one to avoid collision
   - Missing targets: Check Makefile inclusion (`-include Makefile.<plugin>`)

3. **agents.md extension**:
   ```bash
   # Verify agents.md was extended, not replaced
   cat agents.md

   # Check for plugin-specific guidelines
   grep "<plugin-name>" agents.md
   ```

   **Resolution**:
   - Appended content: Integrated correctly (good)
   - Replaced content: Restore original + re-append plugin content
   - Missing content: Manually append from plugin templates

4. **Dependency integration**:
   ```bash
   # Check that dependencies work together
   # Example: Docker plugin should find language configs
   cat .docker/dockerfiles/Dockerfile.backend
   # Should reference pyproject.toml, package.json, etc.
   ```

**Common Integration Issues**:

| Issue | Symptom | Solution |
|-------|---------|----------|
| Config overwrite | Existing settings lost | Manually merge configs, preserve custom settings |
| Target collision | `make target` runs wrong command | Rename target in Makefile.<plugin> |
| Missing inclusion | New Make targets don't work | Add `-include Makefile.<plugin>` to main Makefile |
| agents.md replaced | Original guidance lost | Restore original, append plugin content |
| Incompatible tools | Tools conflict with existing setup | Choose different tool option or resolve manually |

**Why This Matters**: Clean integration ensures the new plugin works alongside existing plugins without conflicts, overwrites, or broken functionality.

### Step 7: Test New Capability

Validate the plugin functionality works as expected.

**Testing Process**:

1. **Test new Makefile targets**:
   ```bash
   # Example: Python plugin
   make lint-python
   make format-python
   make test-python

   # Example: Docker plugin
   make docker-build
   make docker-up
   make docker-down

   # Example: Security plugin
   make scan-secrets
   make scan-dependencies
   ```

   **Expected Results**:
   - Commands execute without errors
   - Tools run successfully
   - Output shows expected results (lint results, test passes, build success)

2. **Run new linters/formatters**:
   ```bash
   # Example: Python Ruff linting
   make lint-python
   # Should show: "All checks passed" or list violations

   # Example: TypeScript ESLint
   make lint-ts
   # Should show: "✓ No lint errors found"
   ```

3. **Execute new tests**:
   ```bash
   # Example: Python pytest
   make test-python
   # Should show: "===== X passed in Y.Ys ====="

   # Example: TypeScript Vitest
   make test-ts
   # Should show: "Test Files X passed"
   ```

4. **Verify new infrastructure**:
   ```bash
   # Example: Docker containers
   make docker-up
   docker ps
   # Should show: Running containers

   # Example: GitHub Actions workflows
   ls -la .github/workflows/
   # Should show: New workflow files
   ```

5. **Check CI/CD integration** (if CI/CD plugin installed):
   ```bash
   # Verify new workflows exist
   cat .github/workflows/<new-workflow>.yml

   # Test workflow locally (if using act)
   act -l
   ```

**Validation Checklist**:

- [ ] All new Make targets work
- [ ] New tools execute successfully
- [ ] Linting passes (or shows expected violations)
- [ ] Tests run and pass
- [ ] Config files are valid
- [ ] No errors in command output
- [ ] Integration with existing tools works
- [ ] CI/CD workflows validate (if applicable)

**Why This Matters**: Testing confirms the plugin is installed correctly and functional. Catching issues early prevents problems during development.

---

## Verification

After installation and testing, verify complete integration:

**Check 1: Plugin Files Exist**
```bash
# Check config files were created
ls -la | grep -E '\.(toml|ini|yml|yaml|json)$'

# Check Makefile was created/updated
ls -la Makefile*

# Check .ai/ was updated
ls -la .ai/
cat .ai/index.yaml
```

**Expected Output**:
- Plugin config files in repository root
- Makefile.<plugin> exists
- .ai/index.yaml lists plugin

**Check 2: Makefile Integration**
```bash
# List all available targets
make help

# Verify new targets appear
make help | grep <plugin-keyword>
```

**Expected Output**:
- New plugin targets listed
- Targets have descriptions
- Targets execute without errors

**Check 3: agents.md Updated**
```bash
# Check agents.md contains plugin guidance
cat agents.md | grep -A 10 "<plugin-name>"
```

**Expected Output**:
- Plugin-specific guidelines present
- Standards documented
- Tool usage explained

**Check 4: Functionality Works**
```bash
# Run a comprehensive test
make lint-all    # If linting plugin
make test-all    # If testing plugin
make build-all   # If build/Docker plugin
```

**Expected Output**:
- All commands succeed
- No errors or warnings
- Expected results produced

**Success Criteria**:
- [ ] Plugin files installed in correct locations
- [ ] Makefile targets work correctly
- [ ] agents.md extended with plugin guidance
- [ ] .ai/index.yaml updated with plugin entry
- [ ] No conflicts with existing plugins
- [ ] All tests pass
- [ ] Plugin functionality validated

---

## Common Issues

### Issue: Dependency Not Installed

**Symptoms**: Installation fails with "prerequisite not found" or "dependency missing"

**Cause**: Plugin requires another plugin or system tool not installed

**Solution**:
```bash
# Check plugin dependencies in manifest
grep -A 5 "dependencies:" plugins/PLUGIN_MANIFEST.yaml

# Install missing dependency first
# Example: Install foundation/ai-folder
cat plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md
# Follow installation steps

# Retry plugin installation
```

### Issue: Config File Already Exists

**Symptoms**: Installation warns "file exists, overwrite?" or changes show file modifications

**Cause**: Repository already has config file with same name

**Solution**:
```bash
# Backup existing config
cp <config-file> <config-file>.backup

# Review plugin config
cat plugins/<category>/<plugin>/templates/<config-file>

# Manually merge:
# 1. Keep your custom settings
# 2. Add plugin's recommended settings
# 3. Remove conflicts

# Or choose one:
# - Use plugin config (lose custom settings)
# - Keep existing config (lose plugin defaults)
```

### Issue: Make Target Doesn't Work

**Symptoms**: `make <target>` shows "No rule to make target" or runs wrong command

**Cause**: Makefile.<plugin> not included in main Makefile

**Solution**:
```bash
# Check if Makefile.<plugin> exists
ls -la Makefile.*

# Check if main Makefile includes it
cat Makefile | grep "include Makefile.<plugin>"

# If missing, add inclusion
echo "-include Makefile.<plugin>" >> Makefile

# Test target
make <target>
```

### Issue: Plugin Conflicts with Existing Setup

**Symptoms**: New plugin tools interfere with existing tools, duplicate functionality

**Cause**: Installing plugin that overlaps with existing tooling

**Solution**:
```bash
# Identify conflict
# Example: Installing Ruff when Pylint already configured

# Choose resolution:
# Option 1: Remove old tool, keep new plugin
# - Remove old config files
# - Remove old Makefile targets
# - Use new plugin exclusively

# Option 2: Keep both (if compatible)
# - Rename targets to avoid collision
# - Configure tools to work together
# - Run separately via different commands

# Option 3: Skip plugin, keep existing
# - Don't install conflicting plugin
# - Continue with current setup
```

### Issue: Language Runtime Not Available

**Symptoms**: Plugin tools fail with "command not found" or "runtime missing"

**Cause**: Language runtime (Python, Node, etc.) not installed or wrong version

**Solution**:
```bash
# Check current version
python --version
node --version

# Install/upgrade runtime
# Ubuntu/Debian:
sudo apt update
sudo apt install python3.11 python3-pip

# macOS:
brew install python@3.11
brew install node@20

# Verify installation
python --version
node --version

# Retry plugin installation
```

### Issue: Docker Plugin Fails to Build

**Symptoms**: `make docker-build` fails with errors

**Cause**: Docker not installed, daemon not running, or Dockerfile errors

**Solution**:
```bash
# Check Docker installation
docker --version
docker compose version

# Check Docker daemon
docker ps
# If error, start Docker:
sudo systemctl start docker  # Linux
# Or start Docker Desktop     # macOS/Windows

# Check Dockerfile syntax
cat .docker/dockerfiles/Dockerfile.<service>

# Test build manually
docker build -f .docker/dockerfiles/Dockerfile.<service> -t test:latest .

# Review build output for specific errors
```

---

## Best Practices

- **One at a time**: Install one plugin at a time, test before adding next
- **Read first**: Always read AGENT_INSTRUCTIONS.md before starting
- **Check dependencies**: Verify all dependencies before installation
- **Backup configs**: Backup existing configs before plugin installation
- **Test thoroughly**: Run all new Make targets after installation
- **Review changes**: Use `git status` and `git diff` to review all changes
- **Commit per plugin**: Commit after each successful plugin installation
- **Document choices**: Note why you chose specific plugins/options in commit messages
- **Update regularly**: Keep plugins updated as new versions release

---

## Next Steps

After adding one capability, consider:

**Related Capabilities**:

- **Added Python?** → Consider: Docker (containerization), GitHub Actions (CI/CD), Security (scanning)
- **Added Docker?** → Consider: GitHub Actions (build/push images), Terraform (deploy containers)
- **Added GitHub Actions?** → Consider: Security (secrets scanning), Pre-commit hooks (quality gates)
- **Added TypeScript?** → Consider: Docker (frontend containers), GitHub Actions (frontend CI/CD)

**Plugin Discovery**:

- **Browse all plugins**: [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml)
- **Discover workflow**: [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md)
- **Plugin architecture**: [PLUGIN_ARCHITECTURE.md](../docs/PLUGIN_ARCHITECTURE.md)

**Advanced Workflows**:

- **Create custom plugins**: [how-to-create-a-language-plugin.md](how-to-create-a-language-plugin.md)
- **Use applications**: Consider `python-cli` or `react-python-fullstack` for complete setups
- **Orchestration**: Use how-to-create-new-ai-repo.md for installing multiple related plugins

---

## Checklist

Use this checklist to ensure complete installation:

- [ ] Browsed PLUGIN_MANIFEST.yaml to find desired plugin
- [ ] Selected one plugin to install
- [ ] Checked plugin status is `stable`
- [ ] Verified all dependencies are installed
- [ ] Located plugin AGENT_INSTRUCTIONS.md
- [ ] Read installation instructions completely
- [ ] Followed all installation steps in order
- [ ] Backed up any existing config files
- [ ] Created necessary directories
- [ ] Copied configuration files
- [ ] Added Makefile targets (Makefile.<plugin>)
- [ ] Included Makefile.<plugin> in main Makefile
- [ ] Extended agents.md with plugin guidance
- [ ] Updated .ai/index.yaml
- [ ] Tested new Makefile targets
- [ ] Ran linters/formatters/tests
- [ ] Verified no config conflicts
- [ ] Confirmed no Make target collisions
- [ ] Checked CI/CD integration (if applicable)
- [ ] Committed changes with descriptive message

---

## Related Documentation

- [Plugin Discovery Guide](how-to-discover-and-install-plugins.md) - Complete plugin discovery workflow
- [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml) - Catalog of all available plugins
- [PLUGIN_ARCHITECTURE.md](../docs/PLUGIN_ARCHITECTURE.md) - Plugin structure and organization
- [FILE_HEADER_STANDARDS.md](../docs/FILE_HEADER_STANDARDS.md) - File header requirements
- [HOWTO_STANDARDS.md](../docs/HOWTO_STANDARDS.md) - How-to guide standards

---

**Remember**: The key to successful incremental capability addition is patience. Install one plugin at a time, test thoroughly, commit after each success, and build your custom configuration gradually.
