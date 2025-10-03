# Plugin Git Workflow Standard

**Purpose**: Standard Git workflow pattern for all plugin AGENT_INSTRUCTIONS.md files

**Scope**: Branching requirements, commit practices, and merge strategies for plugin installation workflows

**Overview**: All plugins that modify repository files must follow Git best practices by creating feature branches before making changes. This standard defines the required workflow pattern that must be included in every plugin's AGENT_INSTRUCTIONS.md.

**Dependencies**: Git repository initialized

**Exports**: Standard branching step template for plugin developers

**Related**: agents.md (Git Workflow section), PLUGIN_ARCHITECTURE.md

**Implementation**: Conditional branching based on state detection

---

## Core Principle

**Never make changes directly to main/master/develop branches.**

Every plugin installation that modifies files must:
1. **Detect current state** first
2. **Determine if changes are needed**
3. **Create feature branch** if changes required
4. **Make changes** on the feature branch
5. **Commit changes** with descriptive message
6. **Inform user** about next steps (review, merge, PR)

---

## Standard Step Template

Every plugin's AGENT_INSTRUCTIONS.md must include this step **immediately after state detection** and **before making any file modifications**.

### Step N: Create Feature Branch (if changes needed)

**IMPORTANT**: Before making any changes, create a feature branch following Git best practices.

```bash
# Determine if changes are needed based on previous state detection
CHANGES_NEEDED=false

# Check your plugin-specific conditions here
# Example:
# if [ "$HAS_PLUGIN_FILE" = false ] || [ "$CONFIG_OK" = false ]; then
#   CHANGES_NEEDED=true
# fi

# If changes are needed, create a feature branch
if [ "$CHANGES_NEEDED" = true ]; then
  echo ""
  echo "Changes are needed - creating feature branch..."

  # Check current branch
  CURRENT_BRANCH=$(git branch --show-current)
  echo "Current branch: $CURRENT_BRANCH"

  # Don't create branch if already on a feature branch
  if [[ "$CURRENT_BRANCH" == "main" ]] || [[ "$CURRENT_BRANCH" == "master" ]] || [[ "$CURRENT_BRANCH" == "develop" ]]; then
    # Create feature branch with plugin-specific name
    BRANCH_NAME="feature/add-<plugin-name>"

    echo "Creating feature branch: $BRANCH_NAME"
    git checkout -b "$BRANCH_NAME"

    if [ $? -eq 0 ]; then
      echo "✓ Created and switched to branch: $BRANCH_NAME"
    else
      echo "✗ Failed to create branch - aborting"
      exit 1
    fi
  else
    echo "ℹ  Already on feature branch: $CURRENT_BRANCH"
  fi
else
  echo ""
  echo "✓ No changes needed - <plugin> is already installed!"
  echo ""
  echo "Summary:"
  # List what was detected as already present
  echo ""
  echo "Your repository already has <plugin> properly configured."
  exit 0
fi
```

---

## Required Components

### 1. State Detection (Step Before Branching)

Before the branching step, plugins MUST have a state detection step that sets boolean flags:

```bash
# Example state detection
if [ -f .plugin-config ]; then
  HAS_PLUGIN=true
else
  HAS_PLUGIN=false
fi

if [ -f Makefile ] && grep -q "plugin-target" Makefile; then
  CONFIG_OK=true
else
  CONFIG_OK=false
fi
```

### 2. Changes Needed Logic

The branching step must evaluate state and determine if changes are required:

```bash
CHANGES_NEEDED=false

if [ "$HAS_PLUGIN" = false ] || [ "$CONFIG_OK" = false ]; then
  CHANGES_NEEDED=true
fi
```

### 3. Branch Name Convention

Branch names should follow this pattern:

- **Feature additions**: `feature/add-<plugin-name>`
- **Bug fixes**: `fix/<issue-description>`
- **Enhancements**: `enhance/<capability-name>`

Examples:
- `feature/add-environment-setup`
- `feature/add-python-linting`
- `feature/add-docker-compose`
- `fix/correct-terraform-config`

### 4. Early Exit on No Changes

If no changes are needed, exit early with success message:

```bash
else
  echo ""
  echo "✓ No changes needed - <plugin> is already installed!"
  echo ""
  echo "Summary:"
  [ "$HAS_PLUGIN" = true ] && echo "  ✓ Plugin configured"
  [ "$CONFIG_OK" = true ] && echo "  ✓ Configuration valid"
  echo ""
  echo "Your repository already has <plugin> properly configured."
  exit 0
fi
```

---

## Final Step: Inform User About Branch

At the end of plugin installation, inform the user about the feature branch and next steps:

### Step N: Summary and Next Steps

```bash
echo ""
echo "======================================"
echo "✓ <PLUGIN> INSTALLATION COMPLETE"
echo "======================================"
echo ""
echo "Changes have been made on branch: $(git branch --show-current)"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Review the changes:"
echo "   git status"
echo "   git diff main"
echo ""
echo "2. Test the new functionality:"
echo "   <plugin-specific test commands>"
echo ""
echo "3. Commit the changes:"
echo "   git add -A"
echo "   git commit -m 'feat: Add <plugin> capability'"
echo ""
echo "4. Merge to main (or create PR):"
echo "   git checkout main"
echo "   git merge <branch-name>"
echo ""
echo "   OR create a pull request for review"
echo ""
```

---

## Example: Complete Workflow

Here's a complete example showing all required steps in order:

```markdown
## Installation Steps

### Step 1: Detect Current State

Check if plugin is already installed:

```bash
if [ -f .plugin-config ]; then
  echo "✓ Plugin config exists"
  HAS_PLUGIN=true
else
  echo "✗ Plugin config missing"
  HAS_PLUGIN=false
fi
```

### Step 2: Create Feature Branch (if changes needed)

**IMPORTANT**: Before making any changes, create a feature branch following Git best practices.

```bash
# Determine if changes are needed
CHANGES_NEEDED=false

if [ "$HAS_PLUGIN" = false ]; then
  CHANGES_NEEDED=true
fi

# Create feature branch if needed
if [ "$CHANGES_NEEDED" = true ]; then
  echo "Changes are needed - creating feature branch..."

  CURRENT_BRANCH=$(git branch --show-current)

  if [[ "$CURRENT_BRANCH" == "main" ]] || [[ "$CURRENT_BRANCH" == "master" ]] || [[ "$CURRENT_BRANCH" == "develop" ]]; then
    BRANCH_NAME="feature/add-my-plugin"
    git checkout -b "$BRANCH_NAME"
    echo "✓ Created branch: $BRANCH_NAME"
  else
    echo "ℹ  Already on feature branch: $CURRENT_BRANCH"
  fi
else
  echo "✓ No changes needed - plugin already installed!"
  exit 0
fi
```

### Step 3: Install Plugin Files

[Plugin-specific installation steps here]

### Step N: Summary and Next Steps

```bash
echo "✓ PLUGIN INSTALLATION COMPLETE"
echo ""
echo "Changes on branch: $(git branch --show-current)"
echo ""
echo "Next: Review, test, commit, and merge"
```

---

## Why This Standard Exists

### Problem

Agents following plugin AGENT_INSTRUCTIONS.md were making changes directly to main branches because:
- They successfully routed through orchestrator guides
- They followed plugin instructions precisely
- But plugin instructions didn't explicitly require branching
- General Git workflow guidance in agents.md wasn't being applied to plugin execution

### Solution

Make branching **explicit and mandatory** in every plugin's AGENT_INSTRUCTIONS.md:
- Detect state FIRST
- Create branch BEFORE any changes
- Exit early if no changes needed
- Follow pattern consistently across all plugins

### Benefits

1. **Explicit > Implicit**: Don't assume agents remember general guidelines when executing specific instructions
2. **Safe by Default**: Changes always on feature branches, never directly on main
3. **Reviewable**: All plugin installations can be reviewed before merging
4. **Revertible**: Easy to discard changes if something goes wrong
5. **Consistent**: Same pattern across all plugins
6. **Testable**: Can test plugin changes without affecting main branch

---

## Plugin Developer Checklist

When creating or updating a plugin's AGENT_INSTRUCTIONS.md:

- [ ] Step 1: State detection with boolean flags
- [ ] Step 2: Feature branch creation (using this standard template)
- [ ] Early exit if no changes needed
- [ ] All file modifications happen AFTER branching step
- [ ] Final step informs user about branch and next steps
- [ ] Branch name follows convention: `feature/add-<plugin-name>`
- [ ] Instructions never modify main/master/develop directly

---

## Related Standards

- **agents.md**: General Git workflow and branching strategy
- **PLUGIN_ARCHITECTURE.md**: Overall plugin structure requirements
- **FILE_HEADER_STANDARDS.md**: File documentation standards
- **how-to-add-capability.md**: Plugin installation orchestrator

---

**Remember**: Every plugin installation is a feature addition. Feature additions require feature branches. No exceptions.
