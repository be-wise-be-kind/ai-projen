# How-To: Add Individual Capability to Repository

**Purpose**: Workflow for adding single plugin capabilities to repositories incrementally with granular control

**Scope**: Abstract process for browsing available plugins, selecting one capability, checking dependencies, installing via AGENT_INSTRUCTIONS.md, and validating integration

**Overview**: High-level orchestration workflow for incremental capability addition that works regardless of which plugins exist. Describes plugin discovery from manifest, dependency verification, standalone installation, integration validation, and testing. Delegates all plugin-specific installation details to individual plugin AGENT_INSTRUCTIONS.md files.

**Dependencies**: Git repository, ai-projen access, PLUGIN_MANIFEST.yaml for plugin discovery

**Exports**: Repository enhanced with single additional capability, validated and integrated

**Related**: [how-to-create-new-ai-repo.md](how-to-create-new-ai-repo.md), [how-to-upgrade-to-ai-repo.md](how-to-upgrade-to-ai-repo.md), [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md)

**Implementation**: Browse → Select → Check deps → Install → Validate

**Difficulty**: beginner

**Estimated Time**: 5-15min per plugin (excluding dependency installations)

---

## Prerequisites

- **Git repository**: Initialized (empty or with code)
- **Working directory**: In repository root
- **ai-projen access**: For PLUGIN_MANIFEST.yaml and plugin files
- **Basic understanding**: Plugin concept (discrete capabilities)

## Overview

### What This Adds

This workflow adds a single capability by:
1. Browsing PLUGIN_MANIFEST.yaml to see available plugins
2. Selecting one plugin to install
3. Checking that plugin's dependencies are met
4. Following plugin's AGENT_INSTRUCTIONS.md for installation
5. Validating integration with existing setup
6. Testing the new capability works

### Core Principles

**Plugin-Agnostic**: Works with any plugin in manifest
**Dependency-Aware**: Checks prerequisites before installing
**Instruction-Delegated**: Installation from AGENT_INSTRUCTIONS.md
**One-at-a-Time**: Focused on single capability
**Validation-Driven**: Confirms successful integration

### When to Use This Workflow

- Want to add one specific plugin
- Prefer granular control over what's installed
- Building custom configuration incrementally
- Already have some plugins installed
- Want to understand each plugin before installing

### When NOT to Use This Workflow

- Want multiple related plugins (use how-to-create-new-ai-repo.md)
- Want complete guided setup (use how-to-create-new-ai-repo.md)
- Have existing code needing safe upgrade (use how-to-upgrade-to-ai-repo.md)

---

## Steps

### Step 1: Browse Available Plugins

Discover what plugins are available by reading PLUGIN_MANIFEST.yaml.

**View Complete Manifest**:
```bash
# Read entire manifest
cat /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Or browse by category
cat /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "category:"
```

**List Stable Plugins Only**:
```bash
# Extract stable plugins
grep "status: stable" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml -B 5 | grep "^  [a-z]" | cut -d: -f1 | tr -d ' '

# Example output:
# foundation/ai-folder
# languages/python
# languages/typescript
# infrastructure/docker
# ...
```

**Browse by Category**:
```bash
# Foundation plugins
grep -A 3 "category: foundation" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Language plugins
grep -A 3 "category: languages" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Infrastructure plugins
grep -A 3 "category: infrastructure" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Standards plugins
grep -A 3 "category: standards" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Application plugins (complete app types)
grep -A 3 "category: applications" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml
```

**Why This Matters**: Manifest is the single source of truth for available capabilities. Browse before selecting.

---

### Step 2: Select Plugin to Install

Choose one plugin based on your immediate need.

**View Plugin Details**:
```bash
# Get details for specific plugin
plugin_id="languages/python"  # Example

# Extract plugin information
grep -A 20 "^  $plugin_id:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Shows:
# - status (stable/experimental/planned)
# - category
# - description
# - dependencies
# - location
```

**Selection Criteria**:

1. **Status is stable**: Only install `status: stable` plugins for production
2. **Matches need**: Plugin provides capability you want
3. **Dependencies checkable**: Can verify prerequisites
4. **Location exists**: Plugin directory accessible

**Why This Matters**: Selecting the right plugin prevents wasted effort. Ensure it matches your need and is production-ready.

---

### Step 3: Check Dependencies

Verify all plugin dependencies are met before installation.

**Read Plugin Dependencies from Manifest**:
```bash
# Extract dependencies for selected plugin
plugin_id="languages/python"  # Example

grep -A 20 "^  $plugin_id:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "dependencies:" -A 10

# Example output:
# dependencies:
#   - foundation/ai-folder
```

**Check Each Dependency**:

**Foundation Dependency** (most common):
```bash
# Check if foundation/ai-folder installed
if [ -d .ai ] && [ -f agents.md ]; then
    echo "✓ Foundation installed"
else
    echo "✗ Foundation missing - install foundation/ai-folder first"
    exit 1
fi
```

**Language Runtime** (if language plugin):
```bash
# Example: Python plugin needs Python runtime
if [ "$plugin_id" = "languages/python" ]; then
    python --version || echo "✗ Python not installed"
fi

# Example: TypeScript plugin needs Node
if [ "$plugin_id" = "languages/typescript" ]; then
    node --version || echo "✗ Node not installed"
fi

# Adapt based on plugin requirements
```

**System Tools** (if infrastructure plugin):
```bash
# Example: Docker plugin needs Docker
if echo "$plugin_id" | grep -q "docker"; then
    docker --version || echo "✗ Docker not installed"
    docker compose version || echo "✗ Docker Compose not installed"
fi

# Example: Terraform plugin needs Terraform
if echo "$plugin_id" | grep -q "terraform"; then
    terraform --version || echo "✗ Terraform not installed"
fi
```

**Other Plugins** (if plugin depends on other plugins):
```bash
# For each dependency in manifest, check if installed
# Example: If plugin depends on languages/python

# Check for indicators that languages/python installed:
test -f pyproject.toml && test -f Makefile.python && echo "✓ languages/python installed"
```

**If Dependencies Missing**:
```bash
# Install dependencies first
echo "Installing dependency: foundation/ai-folder"

# Get dependency location from manifest
dep_location=$(grep -A 5 "foundation/ai-folder:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "location:" | awk '{print $2}')

# Follow dependency's AGENT_INSTRUCTIONS.md
cat "/path/to/ai-projen/$dep_location/AGENT_INSTRUCTIONS.md"

# After dependency installed, retry main plugin
```

**Why This Matters**: Installing plugins without dependencies causes failures. Check and install dependencies first.

---

### Step 4: Locate Plugin Installation Instructions

Find and read the plugin's AGENT_INSTRUCTIONS.md file.

**Get Plugin Location from Manifest**:
```bash
plugin_id="languages/python"  # Example

# Extract location
plugin_location=$(grep -A 20 "^  $plugin_id:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "location:" | awk '{print $2}')

echo "Plugin location: $plugin_location"
# Example output: plugins/languages/python
```

**Read AGENT_INSTRUCTIONS.md**:
```bash
# Construct path to instructions
instructions_path="/path/to/ai-projen/$plugin_location/AGENT_INSTRUCTIONS.md"

# Verify file exists
if [ ! -f "$instructions_path" ]; then
    echo "ERROR: AGENT_INSTRUCTIONS.md not found at $instructions_path"
    exit 1
fi

# Read instructions
cat "$instructions_path"
```

**Understand Instructions Structure**:

Every AGENT_INSTRUCTIONS.md follows this pattern:
- **Prerequisites**: What must exist before installation
- **Installation Steps**: Numbered steps to install plugin
- **Validation**: How to test plugin works
- **Success Criteria**: Checklist of completion requirements

**Why This Matters**: AGENT_INSTRUCTIONS.md is the authoritative source for installation. Contains exact steps to follow.

---

### Step 5: Follow Installation Instructions

Execute installation steps from AGENT_INSTRUCTIONS.md exactly.

**General Installation Pattern**:

```bash
# Read AGENT_INSTRUCTIONS.md and follow steps exactly
# Do NOT improvise or skip steps

# Common steps across most plugins:

# 1. Copy configuration files (if plugin provides them)
# Example from instructions:
# cp /path/to/plugin/templates/config.toml ./config.toml

# 2. Create directory structure (if needed)
# Example from instructions:
# mkdir -p src tests

# 3. Add Makefile targets (if plugin provides Makefile)
# Example from instructions:
# cp /path/to/plugin/templates/Makefile.plugin ./Makefile.plugin
# echo "-include Makefile.plugin" >> Makefile

# 4. Extend agents.md (if plugin provides extension)
# Example from instructions:
# cat /path/to/plugin/templates/agents-extension.md >> agents.md

# 5. Update .ai/index.yaml (record installation)
# Example from instructions:
# echo "  - $plugin_id" >> .ai/index.yaml
```

**Key Points**:
- **Follow exactly**: Don't deviate from AGENT_INSTRUCTIONS.md
- **Read carefully**: Each plugin has specific requirements
- **Don't skip**: All steps necessary for proper installation
- **Check paths**: Verify file paths are correct
- **One plugin**: Complete installation before next plugin

**Commit After Installation**:
```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "Install $plugin_id plugin"
```

**Why This Matters**: Following AGENT_INSTRUCTIONS.md exactly ensures clean, correct installation. Each plugin author knows best how their plugin should be installed.

---

### Step 6: Validate Integration

Ensure plugin integrates cleanly with existing setup.

**Check for Conflicts**:

**Config File Conflicts**:
```bash
# Check git status for modified vs new files
git status

# If files modified (not just new):
git diff

# Review changes carefully
# Ensure no custom settings overwritten
```

**Makefile Target Collisions**:
```bash
# If Makefile exists, check for duplicate targets
if [ -f Makefile ]; then
    make help

    # Look for duplicates or errors
fi
```

**agents.md Extension**:
```bash
# Verify agents.md was extended, not replaced
cat agents.md | grep "##"

# Should show sections from all installed plugins
```

**Dependency Integration**:
```bash
# Check that plugin integrates with dependencies
# Example: Docker plugin should reference language configs

# Verify cross-plugin references work
```

**Why This Matters**: Integration validation catches conflicts early. Fix integration issues before considering installation complete.

---

### Step 7: Test New Capability

Validate the plugin functionality works as expected.

**Test Makefile Targets** (if plugin added targets):
```bash
# If plugin added Makefile targets, test them
if [ -f Makefile ]; then
    # List targets
    make help

    # Test new targets (adapt to plugin)
    make <plugin-target> || echo "Target failed or not applicable"
fi
```

**Test Commands** (if plugin installed tools):
```bash
# If plugin installed linters, formatters, testers, etc.
# Run them to verify they work

# Examples (adapt to plugin):
# make lint-python  # If Python plugin
# make lint-ts      # If TypeScript plugin
# make docker-build # If Docker plugin
```

**Verify Files Created**:
```bash
# Check expected files exist
ls -la

# Check configs valid
# (Syntax check config files if possible)
```

**Run Validation** (if plugin provides validation):
```bash
# Some plugins provide validation targets
make validate-<plugin> 2>/dev/null || echo "No validation target"
```

**Why This Matters**: Testing confirms plugin works. Catch functionality issues before relying on the plugin.

---

## Verification

Final verification checklist:

**Files Exist**:
```bash
# Check expected files created
ls -la

# Verify configs present
# Verify Makefile targets added
```

**Makefile Integration**:
```bash
# List all targets
make help

# Verify new targets appear and work
```

**agents.md Updated**:
```bash
# Check plugin section added
cat agents.md | grep -i "<plugin-keyword>"
```

**Functionality Works**:
```bash
# Test plugin functionality
# (Adapt to specific plugin)
```

**Success Criteria**:
- [ ] Plugin installed without errors
- [ ] Dependencies satisfied
- [ ] No config conflicts
- [ ] Makefile targets work
- [ ] agents.md extended
- [ ] .ai/index.yaml updated
- [ ] Plugin functionality validated

---

## Common Issues

### Issue: Dependency Not Installed

**Symptoms**: Installation fails with "prerequisite not found"

**Solution**: Install dependency first:
```bash
# Check plugin dependencies in manifest
grep -A 10 "dependencies:" manifest | grep "$plugin_id" -A 5

# Install each dependency before plugin
```

### Issue: Config File Conflict

**Symptoms**: Plugin wants to create file that already exists

**Solution**: Merge configurations:
```bash
# Backup existing
cp <config-file> <config-file>.backup

# Review plugin config
cat /path/to/plugin/templates/<config-file>

# Manually merge (preserve existing + add plugin's)
```

### Issue: Make Target Doesn't Work

**Symptoms**: `make <target>` shows error

**Solution**: Check Makefile inclusion:
```bash
# Verify Makefile.<plugin> exists
ls -la Makefile.*

# Verify main Makefile includes it
cat Makefile | grep "include"

# Add if missing
echo "-include Makefile.<plugin>" >> Makefile
```

### Issue: Plugin Not Found in Manifest

**Symptoms**: Cannot find plugin when querying manifest

**Solution**: Check plugin status and ID:
```bash
# Search manifest for plugin
cat /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep -i "<keyword>"

# Verify plugin is stable (not planned)
# Verify correct plugin ID format
```

---

## Best Practices

- **One at a time**: Install one plugin, test, commit, then next
- **Read AGENT_INSTRUCTIONS.md**: Don't skip or improvise
- **Check dependencies first**: Verify prerequisites before installing
- **Test immediately**: Validate plugin works before moving on
- **Commit per plugin**: One commit per plugin for easy rollback
- **Review changes**: Use `git status` and `git diff` before committing

---

## Next Steps

After adding capability:

1. **Use the new capability**: Start using plugin's features
2. **Customize configs**: Adjust plugin settings to your needs
3. **Add related plugins**: Browse manifest for complementary plugins
4. **Learn plugin fully**: Read plugin README and how-tos

**Related Workflows**:
- **Create new repo**: [how-to-create-new-ai-repo.md](how-to-create-new-ai-repo.md)
- **Upgrade existing**: [how-to-upgrade-to-ai-repo.md](how-to-upgrade-to-ai-repo.md)
- **Discover plugins**: [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md)

---

## Key Insight

This workflow is a **single-plugin installer**, not a **multi-plugin orchestrator**:
- It **browses** PLUGIN_MANIFEST.yaml for available plugins
- It **selects** one plugin to install
- It **checks** dependencies from manifest
- It **delegates** installation to AGENT_INSTRUCTIONS.md
- It **validates** integration and functionality

The workflow works with any plugin in the manifest. When new plugins are added to the manifest, this workflow automatically supports them without modification.

---

## Related Documentation

- [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml) - Plugin catalog
- [Plugin Architecture](../docs/PLUGIN_ARCHITECTURE.md) - How plugins work
- [Plugin Discovery](how-to-discover-and-install-plugins.md) - Discovery workflow
- [Create New Repo](how-to-create-new-ai-repo.md) - Multiple plugins at once
- [Upgrade Repository](how-to-upgrade-to-ai-repo.md) - Add to existing code
