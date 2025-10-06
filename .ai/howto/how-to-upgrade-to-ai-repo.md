# How-To: Upgrade Existing Repository to AI-Ready

**Purpose**: Workflow for safely adding AI-ready patterns to existing repositories with code and tooling already present

**Scope**: Abstract process for analyzing existing setup, identifying gaps, safely installing missing plugins, merging configurations, and validating preservation of existing functionality

**Overview**: High-level orchestration workflow for non-destructive upgrades that works regardless of which plugins exist. Describes repository analysis, gap detection, safe installation with backups, configuration merging strategies, and validation. Delegates all plugin-specific installation details to individual plugin AGENT_INSTRUCTIONS.md files.

**Dependencies**: Existing Git repository, ai-projen access, PLUGIN_MANIFEST.yaml, backup capability

**Exports**: Upgraded repository with AI patterns, merged configurations, enhanced tooling, preserved existing functionality

**Related**: [how-to-create-new-ai-repo.md](how-to-create-new-ai-repo.md), [how-to-add-capability.md](how-to-add-capability.md), [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md)

**Implementation**: Backup → Analyze → Identify gaps → Install incrementally → Merge → Validate

**Difficulty**: advanced

**Estimated Time**: 30-90min (varies by existing complexity and plugin count)

---

## Prerequisites

- **Existing Git repository**: Working repository with code
- **Clean working tree**: All changes committed
- **Backup capability**: Ability to create backup branch
- **ai-projen access**: For PLUGIN_MANIFEST.yaml and AGENT_INSTRUCTIONS.md
- **Existing tests**: Should pass before upgrade (baseline)

## Overview

### What This Upgrades

This workflow safely adds AI-ready patterns by:
1. Creating safety backup before any changes
2. Analyzing existing repository structure (languages, tools, configs)
3. Querying PLUGIN_MANIFEST.yaml to identify missing capabilities
4. Installing missing plugins via their AGENT_INSTRUCTIONS.md
5. Merging plugin configs with existing configs (not replacing)
6. Validating that existing functionality still works

### Core Principles

**Non-Destructive**: Never delete existing configuration
**Backup-First**: Always create rollback point
**Incremental**: Add capabilities one at a time
**Merge-Over-Replace**: Preserve custom settings
**Validate-Continuously**: Test after each addition
**Plugin-Agnostic**: Works with any plugins in manifest

### When to Use This Workflow

- Have existing repository with code
- Want to add AI-ready patterns
- Need to preserve existing functionality
- Can't afford to break current setup
- Want progressive enhancement

### When NOT to Use This Workflow

- Empty repository (use how-to-create-new-ai-repo.md)
- Want to start from scratch
- Can't test existing functionality
- Don't have backups available

---

## Using Plugin Parameters

Plugins accept optional parameters to customize installation behavior. When upgrading existing repositories, parameters are especially valuable for integrating AI patterns into your established directory structure without disrupting existing layouts.

**Parameter Syntax**:
```
Follow: plugins/path/to/plugin/AGENT_INSTRUCTIONS.md
  with PARAM_NAME=value
  with ANOTHER_PARAM=value
```

**Key Points**:
- **All parameters are optional** - Every parameter has a sensible default
- **Plugins work standalone** - You can install plugins without providing any parameters
- **Documentation in AGENT_INSTRUCTIONS.md** - Each plugin documents its accepted parameters in its AGENT_INSTRUCTIONS.md file
- **Integration flexibility** - Parameters help plugins adapt to your existing structure

**Common Parameter Examples for Upgrades**:

**Installing Python tooling in existing backend directory**:
```
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=src/backend/
```
This creates `src/backend/pyproject.toml` alongside your existing Python code, rather than at root.

**Installing TypeScript tooling where your frontend already lives**:
```
Follow: plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=client/
```
This creates `client/package.json` and `client/tsconfig.json` in your existing frontend directory.

**Adding Docker to multi-language existing project**:
```
Follow: plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md
  with LANGUAGES=python,typescript
  with SERVICES=api,webapp,worker
  with INSTALL_PATH=.docker/
```
This generates Dockerfiles for your existing languages and creates docker-compose matching your service architecture.

**When to Use Parameters (Upgrades)**:
- Your code is already organized in subdirectories
- Adding tooling to existing multi-language project
- Preserving established directory conventions
- Avoiding root-level config file conflicts
- Matching team's existing layout patterns

**When to Skip Parameters (Upgrades)**:
- Simple single-language project with root configs
- Default plugin behavior matches current structure
- First time testing plugin (learn default behavior first)
- Planning to restructure anyway

**Finding Available Parameters**:
To see what parameters a plugin accepts, read its AGENT_INSTRUCTIONS.md:
```bash
# Example: Check Python plugin parameters
cat /path/to/ai-projen/plugins/languages/python/core/AGENT_INSTRUCTIONS.md | grep -A 10 "## Parameters"

# Example: Check Docker plugin parameters
cat /path/to/ai-projen/plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md | grep -A 10 "## Parameters"
```

Each plugin's AGENT_INSTRUCTIONS.md contains a "Parameters" section with:
- Complete list of accepted parameters
- Default value for each parameter
- Usage examples showing common scenarios

**Using Parameters During Config Merges**:
When merging plugin configs with your existing configs, parameters help place new files where they make sense:
```bash
# If your existing pyproject.toml is at src/pyproject.toml
# Use INSTALL_PATH=src/ so plugin enhances existing location
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=src/

# Then merge plugin's config with your existing src/pyproject.toml
```

---

## Steps

### Step 1: Create Safety Backup

Create backup branch before making any changes.

**Create Backup**:
```bash
# Ensure working tree is clean
git status
# Must show: nothing to commit, working tree clean

# Create backup branch
git checkout -b backup-before-ai-upgrade

# Push to remote (recommended)
git push -u origin backup-before-ai-upgrade

# Return to main branch
git checkout main

# Create upgrade working branch
git checkout -b upgrade-to-ai-ready
```

**Establish Baseline**:
```bash
# Run existing tests to document current state
# (Adjust commands to your project's test suite)
# Examples:
pytest || npm test || make test || ./run-tests.sh

# Document baseline
git log --oneline -5 > upgrade-baseline.txt
echo "Tests passing: $(date)" >> upgrade-baseline.txt
git add upgrade-baseline.txt
git commit -m "Establish upgrade baseline"
```

**Why This Matters**: Backup enables rollback if upgrade causes issues. Baseline proves what "working" looks like.

---

### Step 2: Analyze Existing Repository

Detect what already exists in the repository using file inspection.

**Detect Languages**:
```bash
# Language detection (generic approach)
echo "=== Language Detection ===" > analysis.txt

# Check for common language indicators
find . -name "*.py" -not -path "./venv/*" -not -path "./.venv/*" | head -1 && echo "Python: detected" >> analysis.txt
find . -name "*.ts" -o -name "*.tsx" | head -1 && echo "TypeScript: detected" >> analysis.txt
find . -name "*.js" -o -name "*.jsx" | head -1 && echo "JavaScript: detected" >> analysis.txt
find . -name "*.go" | head -1 && echo "Go: detected" >> analysis.txt
find . -name "*.rs" | head -1 && echo "Rust: detected" >> analysis.txt
# Add more as needed

# Check for language config files
test -f pyproject.toml && echo "Python config: pyproject.toml" >> analysis.txt
test -f package.json && echo "Node config: package.json" >> analysis.txt
test -f go.mod && echo "Go config: go.mod" >> analysis.txt
```

**Detect Existing Tools**:
```bash
# Tool detection (generic patterns)
echo "=== Existing Tools ===" >> analysis.txt

# Linters/formatters (look for common config files)
find . -maxdepth 2 -name ".*rc*" -o -name "*.config.*" | while read config; do
    echo "Config found: $config" >> analysis.txt
done

# Specific tool checks
test -f .ruff.toml && echo "Ruff: configured" >> analysis.txt
test -f .eslintrc.json && echo "ESLint: configured" >> analysis.txt
test -f .prettierrc && echo "Prettier: configured" >> analysis.txt
test -f pytest.ini && echo "pytest: configured" >> analysis.txt
```

**Detect Infrastructure**:
```bash
# Infrastructure detection
echo "=== Infrastructure ===" >> analysis.txt

# Docker
find . -name "Dockerfile*" -o -name "docker-compose*.yml" | while read docker_file; do
    echo "Docker: $docker_file" >> analysis.txt
done

# CI/CD
test -d .github/workflows && echo "GitHub Actions: $(ls .github/workflows | wc -l) workflows" >> analysis.txt
test -f .gitlab-ci.yml && echo "GitLab CI: configured" >> analysis.txt
test -f .travis.yml && echo "Travis CI: configured" >> analysis.txt

# Infrastructure as Code
find . -name "*.tf" | head -1 && echo "Terraform: detected" >> analysis.txt
find . -name "*.yaml" -path "*/k8s/*" | head -1 && echo "Kubernetes: detected" >> analysis.txt
```

**Save Analysis**:
```bash
git add analysis.txt
git commit -m "Add repository analysis"
```

**Create Upgrade Roadmap** (Optional but recommended):
```bash
# For tracking upgrade progress, create a roadmap
mkdir -p roadmap/upgrade-to-ai-ready

# Use simplified progress tracker for upgrades
cat > roadmap/upgrade-to-ai-ready/PROGRESS_TRACKER.md << EOF
# Upgrade to AI-Ready - Progress Tracker

**Purpose**: Track progress of upgrading existing repository to AI-ready patterns

**Current Status**: Analysis phase

## Upgrade Steps
- [x] Create backup branch
- [x] Analyze existing repository
- [ ] Identify missing capabilities
- [ ] Install foundation (if needed)
- [ ] Install missing plugins incrementally
- [ ] Merge configurations
- [ ] Validate existing functionality preserved
- [ ] Final validation

## Current Task
Analyzing existing repository structure

## Notes for AI Agents
- Always backup before changes
- Merge configs, never replace
- Validate after each plugin
- Keep existing functionality working
EOF

git add roadmap/
git commit -m "Add upgrade roadmap"
```

**Why This Matters**: Understanding existing setup prevents duplicate installations and identifies integration points. The roadmap helps track upgrade progress and provides resumability.

---

### Step 3: Identify Missing Capabilities

Compare existing setup against PLUGIN_MANIFEST.yaml to find gaps.

**Query Manifest for Available Plugins**:
```bash
# Read all stable plugins from manifest
grep "status: stable" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml -B 5 > available-plugins.txt
```

**Gap Analysis Process**:
```bash
cat > gap-analysis.txt << 'EOF'
# Gap Analysis

## Detected Existing Capabilities
(from analysis.txt)

## Available Plugin Categories
(from PLUGIN_MANIFEST.yaml)

## Missing Capabilities

### Foundation
- [ ] Check if .ai/ folder exists
- [ ] Check if agents.md exists

### Language Enhancements
(For each detected language, check if corresponding plugin offers enhancements)

### Infrastructure
(Check for Docker, CI/CD, IaC gaps)

### Standards
(Check for Security, Documentation, Pre-commit hooks)

## Conflicts to Resolve
(List existing configs that may conflict with plugins)

## Recommended Installation Order
1. Foundation (if missing)
2. Language enhancements
3. Missing infrastructure
4. Standards

EOF
```

**Map Detected → Available**:
```bash
# For each detected language, find corresponding plugin
# Example: If Python detected, check for languages/python plugin

# If Python detected:
if grep -q "Python: detected" analysis.txt; then
    # Check if languages/python available
    if grep -q "languages/python" available-plugins.txt; then
        echo "- languages/python (available for Python tooling)" >> gap-analysis.txt
    fi
fi

# Repeat for other languages, infrastructure, standards
```

**Commit Gap Analysis**:
```bash
git add gap-analysis.txt available-plugins.txt
git commit -m "Add gap analysis"
```

**Why This Matters**: Gap analysis identifies exactly what's missing without installing unnecessary plugins.

---

### Step 4: Install Foundation Plugin (if missing)

Install foundation/ai-folder if .ai/ doesn't exist.

**Check if Foundation Needed**:
```bash
if [ ! -d .ai ]; then
    echo "Foundation needed: .ai/ missing"

    # Locate foundation plugin in manifest
    foundation_location=$(grep -A 5 "foundation/ai-folder:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "location:" | awk '{print $2}')

    # Read AGENT_INSTRUCTIONS.md
    cat "/path/to/ai-projen/$foundation_location/AGENT_INSTRUCTIONS.md"

    # Follow instructions to install
    echo "Follow AGENT_INSTRUCTIONS.md to install foundation/ai-folder"

    # After installation, commit
    git add .ai/ AGENTS.md
    git commit -m "Install foundation/ai-folder plugin"
else
    echo "Foundation exists: .ai/ present"

    # If .ai/ exists but incomplete, consider backup and enhancement
    if [ ! -f .ai/index.yaml ]; then
        echo "WARNING: .ai/ exists but incomplete"
        cp -r .ai .ai.backup
        # Follow foundation AGENT_INSTRUCTIONS.md to complete
    fi
fi
```

**Why This Matters**: Foundation is required for all other plugins. Install first if missing.

---

### Step 5: Install Missing Plugins Incrementally

For each missing capability, install its plugin via AGENT_INSTRUCTIONS.md.

**Installation Pattern** (for each missing plugin):

```bash
# Example: Installing a language enhancement plugin

# 1. Get plugin ID from gap-analysis.txt
plugin_id="languages/python"  # Example

# 2. Locate plugin in manifest
plugin_location=$(grep -A 5 "^  $plugin_id:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "location:" | awk '{print $2}')

# 3. Backup existing configs before installation
if [ -f pyproject.toml ]; then
    cp pyproject.toml pyproject.toml.backup
fi
# Backup other relevant files

# 4. Read AGENT_INSTRUCTIONS.md
instructions_file="/path/to/ai-projen/$plugin_location/AGENT_INSTRUCTIONS.md"
cat "$instructions_file"

# 5. Follow installation instructions
echo "Follow steps in AGENT_INSTRUCTIONS.md"
echo "IMPORTANT: When merging configs, preserve existing settings"

# 6. After installation, commit
git add .
git commit -m "Install $plugin_id plugin"
```

**Key Points for Upgrades**:
- **Backup first**: Save existing configs before plugin installation
- **Merge, don't replace**: Preserve custom settings when conflicts occur
- **Follow AGENT_INSTRUCTIONS.md**: It has installation details
- **One at a time**: Install incrementally, test after each
- **Manual merge if needed**: Some configs require human judgment

**Why This Matters**: Incremental installation with backups enables safe rollback per plugin.

---

### Step 6: Merge Configurations

When plugin configs conflict with existing configs, merge carefully.

**Config Merge Strategy**:

**General Pattern**:
```bash
# For each config file that exists and plugin wants to modify:

# 1. You have backup: <file>.backup
# 2. Plugin provided: <file>.plugin (copy from templates)
# 3. Need to create: <file> (merged result)

# Example: pyproject.toml
cp plugin-templates/pyproject.toml pyproject.toml.plugin

# Manual merge (cannot be automated safely):
echo "MERGE REQUIRED:"
echo "1. Open pyproject.toml.backup (your existing config)"
echo "2. Open pyproject.toml.plugin (plugin recommended config)"
echo "3. Merge into pyproject.toml (combined result)"
echo ""
echo "Preserve:"
echo "  - Your project name, version, dependencies"
echo "  - Your custom settings"
echo "Add:"
echo "  - Plugin tool configurations ([tool.ruff], [tool.pytest], etc.)"
echo ""
echo "When done, remove .backup and .plugin files"
```

**Merge Checklist**:
- [ ] Identify all files both you and plugin need to modify
- [ ] Backup your original versions
- [ ] Get plugin template versions
- [ ] Manually merge (preserve yours + add plugin's)
- [ ] Test merged result
- [ ] Commit merged config

**Why This Matters**: Config merging requires human judgment. Cannot be automated safely.

---

### Step 7: Validate Existing Functionality Preserved

Ensure existing code still works after upgrade.

**Run Existing Tests**:
```bash
# Run same test command as baseline
pytest || npm test || make test || ./run-tests.sh

# Compare with baseline
echo "Baseline: see upgrade-baseline.txt"
echo "Current: $(date)"

# Tests must still pass
```

**Test New Functionality**:
```bash
# If Makefile added, test new targets
if [ -f Makefile ]; then
    make help
    make lint-all || true  # May show violations on existing code
    make test-all || true
fi
```

**Check Integration**:
```bash
# Verify no files deleted
git status
git diff --stat backup-before-ai-upgrade..HEAD

# Confirm additions only, not deletions
```

**Rollback if Needed**:
```bash
# If something broke:
git checkout backup-before-ai-upgrade
git checkout -b rollback-and-retry

# Identify what failed, fix, retry upgrade
```

**Why This Matters**: Validation ensures upgrade didn't break existing functionality. Rollback if tests fail.

---

## Verification

After completing upgrade:

**Check Enhancements Added**:
```bash
# Verify .ai/ structure
ls -la .ai/

# Verify AGENTS.md enhanced
cat AGENTS.md | grep "##"

# Verify configs merged
cat pyproject.toml  # Should have both old and new sections
```

**Check Existing Preserved**:
```bash
# Original code untouched
git log --oneline --graph

# Tests pass
make test || pytest || npm test

# Application runs
# (Run your app's start command)
```

**Success Criteria**:
- [ ] All gaps filled
- [ ] Existing tests pass
- [ ] Existing functionality works
- [ ] No files deleted
- [ ] Configs merged (not replaced)
- [ ] Backup branch exists

---

## Common Issues

### Issue: Config Overwritten

**Symptoms**: Plugin installation replaced your config file

**Solution**: Restore from backup and merge manually:
```bash
# Restore original
cp <config>.backup <config>

# Get plugin version
cp /path/to/plugin/templates/<config> <config>.plugin

# Merge manually (preserve your settings, add plugin's)
# Edit <config> to combine both

# Test merged result
```

### Issue: Tests Fail After Upgrade

**Symptoms**: Tests passed before, fail after plugin installation

**Solution**: Identify what changed:
```bash
# Check what plugin modified
git diff backup-before-ai-upgrade..HEAD

# If new linter found issues:
# Option 1: Fix issues
# Option 2: Adjust linter config to be less strict initially

# If config conflict:
# Restore and merge more carefully
```

### Issue: Existing Tool Conflicts

**Symptoms**: Plugin tool conflicts with existing tool

**Solution**: Choose one or run separately:
```bash
# Option 1: Keep existing, skip conflicting plugin
# Option 2: Replace existing with plugin tool
# Option 3: Rename targets to avoid collision
```

### Issue: Lost Custom Settings

**Symptoms**: Custom configuration disappeared

**Solution**: Restore from backup:
```bash
# View your original
cat <config>.backup

# View current
cat <config>

# Manually restore custom sections
# Keep plugin additions too
```

---

## Best Practices

- **Always backup first**: Create backup branch before any changes
- **Test continuously**: Run tests after each plugin
- **Merge, don't replace**: Preserve custom configurations
- **One plugin at a time**: Don't batch installations
- **Read AGENT_INSTRUCTIONS.md**: Don't guess at installation
- **Commit frequently**: One commit per plugin enables granular rollback
- **Validate incrementally**: Catch issues early

---

## Rollback Instructions

If upgrade causes issues:

**Full Rollback**:
```bash
# Return to backup
git checkout backup-before-ai-upgrade

# Delete failed attempt
git branch -D upgrade-to-ai-ready

# Retry if desired
git checkout -b upgrade-to-ai-ready-v2
```

**Partial Rollback**:
```bash
# Revert specific commits
git log --oneline
git revert <commit-hash>

# Or reset to point
git reset --hard <commit-before-problem>
```

**File-Level Rollback**:
```bash
# Restore one file
git checkout backup-before-ai-upgrade -- path/to/file
```

---

## Next Steps

After successful upgrade:

1. **Fix Lint Issues**: Address violations found by new linters
2. **Enhance Tests**: Add tests using new test frameworks
3. **Customize Configs**: Tune plugin settings for your project
4. **Add More Capabilities**: Use how-to-add-capability.md
5. **Configure CI/CD**: If added, set up secrets and credentials

**Related Workflows**:
- **Add capability**: [how-to-add-capability.md](how-to-add-capability.md)
- **Create new repo**: [how-to-create-new-ai-repo.md](how-to-create-new-ai-repo.md)

---

## Key Insight

This workflow is a **safe upgrader**, not a **replacer**:
- It **analyzes** existing setup through file inspection
- It **identifies** gaps by comparing to PLUGIN_MANIFEST.yaml
- It **backups** before any changes
- It **installs** via AGENT_INSTRUCTIONS.md
- It **merges** configs (preserves custom settings)
- It **validates** existing functionality still works

The workflow works with any plugins in the manifest and any existing repository structure. It adapts automatically to what's detected and what's available.

---

## Related Documentation

- [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml) - Plugin catalog
- [Create New Repo](how-to-create-new-ai-repo.md) - For empty directories
- [Add Capability](how-to-add-capability.md) - Single plugin addition
- [Plugin Discovery](how-to-discover-and-install-plugins.md) - Discovery workflow
