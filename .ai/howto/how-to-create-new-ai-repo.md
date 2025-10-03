# How-To: Create New AI-Ready Repository

**Purpose**: Workflow for creating brand-new AI-ready repositories from empty directories using plugin discovery and orchestration

**Scope**: Abstract process for repository initialization, plugin discovery, selection, dependency resolution, and sequential installation

**Overview**: High-level orchestration workflow that works regardless of which plugins exist. Describes the discovery process, plugin selection logic, dependency management, and installation coordination. Delegates all plugin-specific installation details to individual plugin AGENT_INSTRUCTIONS.md files.

**Dependencies**: ai-projen repository access, Git, PLUGIN_MANIFEST.yaml for plugin discovery

**Exports**: Fully configured repository with selected plugins installed and validated

**Related**: [how-to-add-capability.md](how-to-add-capability.md), [how-to-upgrade-to-ai-repo.md](how-to-upgrade-to-ai-repo.md), [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md)

**Implementation**: Initialize → Discover → Select → Resolve → Install → Validate

**Difficulty**: intermediate

**Estimated Time**: 20-60min (varies by plugin count and complexity)

---

## Prerequisites

- **Git installed**: Version 2.30+
- **Empty or new directory**: Target location for repository
- **ai-projen access**: Cloned locally or accessible for plugin manifest
- **PLUGIN_MANIFEST.yaml**: Available for querying plugins
- **Optional runtimes**: Installed as needed based on plugin selection

## Overview

### What This Creates

This workflow creates a production-ready repository by:
1. Querying PLUGIN_MANIFEST.yaml to discover available plugins
2. Using discovery questions to determine project needs
3. Selecting appropriate plugins based on answers
4. Resolving dependencies to determine installation order
5. Installing each plugin via its AGENT_INSTRUCTIONS.md
6. Validating the complete setup

### Core Principles

**Plugin-Agnostic**: Works with any plugins in PLUGIN_MANIFEST.yaml
**Discovery-Driven**: Questions determine plugin selection dynamically
**Dependency-Aware**: Respects plugin dependencies from manifest
**Instruction-Delegated**: Installation details come from AGENT_INSTRUCTIONS.md
**Resumable**: Progress tracking enables interruption recovery

### When to Use This Workflow

- Starting new project from empty directory
- Want complete development environment
- Prefer guided discovery over manual selection
- Need multiple related plugins installed together

### When NOT to Use This Workflow

- Have existing code (use how-to-upgrade-to-ai-repo.md)
- Want single plugin only (use how-to-add-capability.md)
- Need highly customized setup (install manually)

---

## Steps

### Step 1: Initialize Repository

Create and initialize the target Git repository.

**Create Directory and Initialize Git**:
```bash
# Create project directory
mkdir my-new-project
cd my-new-project

# Initialize Git
git init

# Create initial README
echo "# My New Project" > README.md
git add README.md
git commit -m "Initial commit"
```

**Why This Matters**: Git is required by all plugins. Clean initialization prevents conflicts.

---

### Step 2: Query Available Plugins

Discover what plugins are available by reading PLUGIN_MANIFEST.yaml.

**Read Plugin Manifest**:
```bash
# View complete manifest
cat /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Or query specific sections
grep -A 10 "^plugins:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml
```

**Understand Plugin Structure**:

The manifest contains:
- **Plugin ID**: Unique identifier (e.g., `languages/python`)
- **Status**: `stable`, `experimental`, or `planned`
- **Dependencies**: Required plugins that must be installed first
- **Category**: `foundation`, `languages`, `infrastructure`, `standards`, `applications`
- **Location**: Path to plugin directory with AGENT_INSTRUCTIONS.md

**Build Available Plugin List**:
```bash
# Extract all stable plugins
grep "status: stable" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml -B 5

# Note categories
grep "category:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml
```

**Why This Matters**: You need to know what's available before running discovery questions. The manifest is the single source of truth.

---

### Step 3: Run Discovery Process

Ask questions to determine project needs and map to available plugins.

**Discovery Question Pattern**:

For each capability category, ask questions that map to plugin selections:

**Example Discovery Questions** (adapt based on manifest contents):

1. **Languages**: "What programming language(s)?" → Maps to `languages/*` plugins
2. **Frontend**: "Need frontend framework?" → Maps to framework-specific plugins
3. **Infrastructure**: "Need containerization?" → Maps to `infrastructure/docker` or similar
4. **CI/CD**: "Need automated pipelines?" → Maps to `infrastructure/ci-cd/*` plugins
5. **Cloud**: "Need cloud deployment?" → Maps to `infrastructure/iac/*` plugins
6. **Standards**: "Apply security/docs/hooks?" → Maps to `standards/*` plugins

**Dynamic Question Generation**:

Questions should be generated based on what's in PLUGIN_MANIFEST.yaml:
```bash
# Query manifest for language plugins
grep -A 2 "category: languages" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Query manifest for infrastructure categories
grep -A 2 "category: infrastructure" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml

# Query manifest for standards
grep -A 2 "category: standards" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml
```

Build questions dynamically from manifest contents, not hardcoded lists.

**Why This Matters**: Discovery questions must adapt to available plugins. If new plugins are added, questions should reflect them automatically.

---

### Step 4: Select Plugins Based on Answers

Map discovery answers to specific plugins from the manifest.

**Plugin Selection Logic**:

**Always Required**:
- Foundation plugins (e.g., `foundation/ai-folder`) - check manifest for `category: foundation`

**Based on Discovery Answers**:
- Map each answer to corresponding plugin ID from manifest
- Look up plugin in manifest to get location and dependencies
- Add selected plugins to installation list

**Example Mapping** (generic pattern):
```yaml
# User answers → Plugin selection
Answer: "Python" → Query manifest for languages/python
Answer: "Docker" → Query manifest for infrastructure matching docker
Answer: "Security" → Query manifest for standards matching security
```

**Build Plugin List**:
```bash
# For each selected plugin, record:
# - Plugin ID (from manifest)
# - Plugin location (from manifest)
# - Plugin dependencies (from manifest)
# - Installation order priority

# Create plugins-to-install.txt
cat > plugins-to-install.txt << 'EOF'
foundation/ai-folder
<other-selected-plugins>
EOF
```

**Why This Matters**: Selection must be dynamic based on manifest contents, not hardcoded plugin names.

---

### Step 5: Resolve Dependencies

Determine installation order based on plugin dependencies from manifest.

**Dependency Resolution Algorithm**:

1. **Read Dependencies**:
   ```bash
   # For each selected plugin, query its dependencies
   grep -A 10 "^  <plugin-id>:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "dependencies:"
   ```

2. **Build Dependency Graph**:
   - Foundation plugins first (no dependencies)
   - Plugins that depend only on foundation next
   - Plugins with multiple dependencies after their deps
   - Standards plugins typically last (depend on languages/infrastructure)

3. **Sort Topologically**:
   ```bash
   # Create ordered-plugins.txt with dependencies resolved
   # Example order:
   # 1. foundation/ai-folder (no deps)
   # 2. languages/python (depends: foundation/ai-folder)
   # 3. infrastructure/docker (depends: foundation/ai-folder, languages/python)
   # 4. standards/security (depends: languages/python)
   ```

**Detect Circular Dependencies**:
If plugin A depends on B and B depends on A, this is invalid. The manifest should prevent this, but verify during resolution.

**Why This Matters**: Installing plugins out of dependency order causes failures. Dependencies must be installed first.

---

### Step 6: Generate Installation Roadmap

Create a progress-tracking document for resumability using the roadmap templates.

**Create Roadmap Using Templates**:
```bash
# Create roadmap directory
mkdir -p roadmap/setup

# Use the progress tracker template for tracking installation
# Note: For simple installations, you may create a simplified version
# For complex multi-repo setups, use all three templates:
# - roadmap-progress-tracker.md.template
# - roadmap-pr-breakdown.md.template (if breaking into multiple PRs)
# - roadmap-ai-context.md.template (for complex feature context)

cat > roadmap/setup/PROGRESS_TRACKER.md << EOF
# Repository Setup - Progress Tracker

**Purpose**: Track installation progress for AI-ready repository setup

**Current Status**: In Progress

## Selected Plugins
$(cat ordered-plugins.txt)

## Installation Progress

- [ ] Initialize repository
- [ ] Install foundation plugins
- [ ] Install language plugins
- [ ] Install infrastructure plugins
- [ ] Install standards plugins
- [ ] Validate installation

## Current Task
Installing plugins in dependency order

## Resume Instructions
If interrupted, check last completed plugin above and resume with next unchecked item.

## Notes for AI Agents
- Follow AGENT_INSTRUCTIONS.md for each plugin exactly
- Validate after each plugin installation
- Commit after each successful plugin installation
- Update this file after each step
EOF

git add roadmap/
git commit -m "Add installation roadmap"
```

**Using Full Roadmap Templates** (for major repository setups):
```bash
# For complex setups, copy and fill in the full templates:
cp /path/to/ai-projen/.ai/templates/roadmap-progress-tracker.md.template roadmap/setup/PROGRESS_TRACKER.md
cp /path/to/ai-projen/.ai/templates/roadmap-pr-breakdown.md.template roadmap/setup/PR_BREAKDOWN.md
cp /path/to/ai-projen/.ai/templates/roadmap-ai-context.md.template roadmap/setup/AI_CONTEXT.md

# Then replace {{PLACEHOLDERS}} with actual values
```

**Why This Matters**: Roadmap enables resuming if installation is interrupted. Track progress explicitly. For complex setups, the full template structure provides comprehensive tracking and AI agent handoff support.

---

### Step 7: Install Plugins Sequentially

For each plugin in dependency order, follow its AGENT_INSTRUCTIONS.md.

**Installation Loop**:

```bash
# Read ordered plugins list
while read plugin_id; do
    echo "=== Installing $plugin_id ==="

    # 1. Locate plugin directory from manifest
    plugin_location=$(grep -A 5 "^  $plugin_id:" /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep "location:" | awk '{print $2}')

    # 2. Read AGENT_INSTRUCTIONS.md
    instructions_file="/path/to/ai-projen/$plugin_location/AGENT_INSTRUCTIONS.md"

    if [ ! -f "$instructions_file" ]; then
        echo "ERROR: $instructions_file not found"
        exit 1
    fi

    echo "Reading installation instructions from $instructions_file"
    cat "$instructions_file"

    # 3. Follow instructions (MANUAL STEP or script if automated)
    echo "Follow the steps in AGENT_INSTRUCTIONS.md to install $plugin_id"
    echo "When complete, press Enter to continue..."
    read

    # 4. Mark complete in roadmap
    sed -i "s/\[ \] $plugin_id/\[x\] $plugin_id/" roadmap/setup/INSTALLATION_ROADMAP.md
    git add roadmap/
    git commit -m "Installed $plugin_id"

    echo "=== $plugin_id installation complete ==="
done < ordered-plugins.txt
```

**Key Points**:
- **Do NOT hardcode installation steps** - read from AGENT_INSTRUCTIONS.md
- **Do NOT assume plugin structure** - get location from manifest
- **Follow AGENT_INSTRUCTIONS.md exactly** - it's the authoritative source
- **Validate after each plugin** - catch issues early

**Why This Matters**: Delegating to AGENT_INSTRUCTIONS.md keeps this workflow plugin-agnostic. New plugins work automatically.

---

### Step 8: Validate Installation

Verify all plugins installed correctly and integrate properly.

**Validation Checks**:

1. **Check Expected Files**:
   ```bash
   # Foundation should create .ai/
   test -d .ai && echo "✓ .ai/ exists" || echo "✗ .ai/ missing"

   # AGENTS.md should exist
   test -f AGENTS.md && echo "✓ agents.md exists" || echo "✗ agents.md missing"

   # Makefile should exist (if language plugins installed)
   test -f Makefile && echo "✓ Makefile exists" || echo "✗ Makefile missing"
   ```

2. **Test Commands**:
   ```bash
   # If Makefile exists, test targets
   if [ -f Makefile ]; then
       make help
   fi

   # Test any other commands plugins should have provided
   ```

3. **Check Integration**:
   ```bash
   # Verify .ai/index.yaml lists installed plugins
   cat .ai/index.yaml | grep "installed_plugins:" -A 20

   # Verify AGENTS.md has sections from all plugins
   cat AGENTS.md | grep "##"
   ```

4. **Run Validation Commands**:
   ```bash
   # If plugins provide validation targets
   make validate-all 2>/dev/null || echo "No validation target"
   ```

**Success Criteria**:
- All expected files exist
- All Makefile targets work
- No configuration conflicts
- Integration points connected

**Why This Matters**: Validation confirms successful installation. Catch issues before development starts.

---

## Verification

Final verification checklist:

**Repository Structure**:
```bash
ls -la
# Should show: .ai/, AGENTS.md, Makefile (if applicable), plugin configs
```

**Plugin Tracking**:
```bash
cat .ai/index.yaml
# Should list all installed plugins
```

**Functionality**:
```bash
# Test commands work
make help 2>/dev/null || echo "No Makefile"

# Verify Git clean
git status
# Should show: working tree clean
```

**Success Criteria**:
- [ ] All selected plugins installed
- [ ] Dependencies satisfied
- [ ] No installation errors
- [ ] Validation passed
- [ ] Roadmap shows 100% complete
- [ ] Repository ready for development

---

## Common Issues

### Issue: Plugin Not Found in Manifest

**Symptoms**: Plugin ID not found when querying manifest

**Solution**: Plugin may be `planned` not `stable`, or wrong ID. Check manifest structure:
```bash
cat /path/to/ai-projen/plugins/PLUGIN_MANIFEST.yaml | grep -i "plugin-name"
```

### Issue: Dependency Not Satisfied

**Symptoms**: Plugin installation fails due to missing dependency

**Solution**: Install dependencies first:
```bash
# Check plugin dependencies
grep -A 10 "^  <plugin-id>:" manifest | grep "dependencies:"

# Install dependencies before plugin
```

### Issue: AGENT_INSTRUCTIONS.md Not Found

**Symptoms**: Plugin directory exists but no AGENT_INSTRUCTIONS.md

**Solution**: Plugin may be incomplete or manifest location wrong:
```bash
# Verify location in manifest
grep -A 5 "^  <plugin-id>:" manifest | grep "location:"

# Check directory
ls -la /path/to/ai-projen/<location>/
```

### Issue: Installation Interrupted

**Symptoms**: Process stopped partway through

**Solution**: Resume from roadmap:
```bash
# Check last completed plugin
cat roadmap/setup/INSTALLATION_ROADMAP.md

# Resume with next unchecked plugin
# Continue installation loop from that point
```

---

## Best Practices

- **Always query manifest** - Don't hardcode plugin assumptions
- **Read AGENT_INSTRUCTIONS.md** - Don't duplicate installation logic
- **Validate early** - Test after each plugin, not at end
- **Track progress** - Update roadmap consistently
- **Commit frequently** - One commit per plugin installation
- **Handle errors gracefully** - Stop on failure, don't continue
- **Document selections** - Record why plugins were chosen

---

## Next Steps

After creating repository:

1. **Start Development**: Begin coding in installed language frameworks
2. **Run Tooling**: Use installed linters, formatters, tests
3. **Configure Deployment**: Set up CI/CD secrets and cloud credentials
4. **Add More Plugins**: Use how-to-add-capability.md for incremental additions
5. **Customize Configs**: Adjust plugin configs to project needs

**Related Workflows**:
- **Add capability**: [how-to-add-capability.md](how-to-add-capability.md)
- **Upgrade existing**: [how-to-upgrade-to-ai-repo.md](how-to-upgrade-to-ai-repo.md)
- **Discover plugins**: [how-to-discover-and-install-plugins.md](how-to-discover-and-install-plugins.md)

---

## Key Insight

This workflow is an **orchestrator**, not an **installer**:
- It **queries** PLUGIN_MANIFEST.yaml for available plugins
- It **discovers** user needs through questions
- It **selects** appropriate plugins dynamically
- It **resolves** dependencies from manifest
- It **delegates** installation to AGENT_INSTRUCTIONS.md
- It **validates** the result

The workflow adapts automatically when plugins are added/removed from the manifest. No changes to this document are needed when the plugin ecosystem evolves.

---

## Related Documentation

- [PLUGIN_MANIFEST.yaml](../../plugins/PLUGIN_MANIFEST.yaml) - Plugin catalog
- [Plugin Architecture](../docs/PLUGIN_ARCHITECTURE.md) - How plugins work
- [Plugin Discovery](how-to-discover-and-install-plugins.md) - Discovery workflow
- [Add Capability](how-to-add-capability.md) - Single plugin addition
- [Upgrade Repository](how-to-upgrade-to-ai-repo.md) - Existing repo upgrade
