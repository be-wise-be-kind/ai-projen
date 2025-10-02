# AI Folder Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the foundational .ai folder structure

**Scope**: Creation and configuration of the .ai directory that enables AI navigation and project understanding

**Overview**: Step-by-step instructions for AI agents to install the universal ai-folder plugin that creates
    the foundational .ai directory structure. This plugin is the cornerstone of AI-ready repositories, providing
    structured navigation, documentation, and templates for AI agents to understand and work with the codebase.

**Dependencies**: Git repository initialized

**Exports**: .ai/ directory with docs/, features/, howto/, templates/, index.yaml, and layout.yaml

**Related**: Foundation plugin for all AI-ready repositories

**Implementation**: Template-based installation with variable substitution for project-specific values

---

## Prerequisites

Before installing this plugin, ensure:
- ✅ Git repository is initialized (`git init` has been run)
- ✅ You know the project name
- ✅ You know the project type (e.g., python, typescript, full-stack, etc.)

## Installation Steps

### Step 1: Gather Project Information

Ask the user (or infer from context):
1. **Project Name**: What is the name of this project?
2. **Project Type**: What type of project is this? (python, typescript, go, rust, full-stack, etc.)
3. **Project Purpose**: Brief description of what this project does

### Step 2: Create .ai Directory Structure

Create the following directory structure in the repository root:

```bash
mkdir -p .ai/{docs,features,howto,templates}
```

This creates:
- `.ai/` - Root AI navigation folder
- `.ai/docs/` - Project documentation for AI understanding
- `.ai/features/` - Feature-specific documentation
- `.ai/howto/` - How-to guides for common tasks
- `.ai/templates/` - Reusable file templates

### Step 3: Create index.yaml

Copy `template/index.yaml.template` to `.ai/index.yaml` and replace variables:

**Variables to replace:**
- `{{PROJECT_NAME}}` → Actual project name
- `{{PROJECT_TYPE}}` → Actual project type
- `{{PROJECT_PURPOSE}}` → Brief project description

**Example:**
```yaml
version: "1.0"
project:
  name: my-awesome-app
  type: full-stack
  purpose: E-commerce platform with React frontend and Python backend
  status: in-development
  version: "0.1.0"
```

### Step 4: Create layout.yaml

Copy `template/layout.yaml.template` to `.ai/layout.yaml` and replace variables:

**Variables to replace:**
- `{{PROJECT_TYPE}}` → Actual project type
- Add/remove sections based on project type

**Example for Python project:**
```yaml
version: "1.0"

directories:
  source: src/
  tests: tests/
  docs: docs/

ai_navigation:
  index: .ai/index.yaml
  docs: .ai/docs/
  howto: .ai/howto/
  templates: .ai/templates/
```

### Step 5: Create Initial Documentation

Create `.ai/docs/PROJECT_CONTEXT.md` with:

```markdown
# {{PROJECT_NAME}} - Project Context

**Purpose**: [Brief description of project purpose]

**Scope**: [What this project does and doesn't do]

**Overview**: [High-level architecture and design]

**Dependencies**: [Key dependencies and external services]

**Exports**: [What this project provides]

**Related**: [Related projects or documentation]

**Implementation**: [Key implementation details]

---

## Project Purpose

[Detailed description of why this project exists and what problems it solves]

## Architecture Overview

[High-level architecture description]

## Key Components

[List and describe major components]

## Development Guidelines

[Guidelines for developers working on this project]
```

Replace `{{PROJECT_NAME}}` with the actual project name and fill in the sections.

### Step 6: Validate Installation

Verify the following structure exists:

```
.ai/
├── docs/
│   └── PROJECT_CONTEXT.md
├── features/
├── howto/
├── templates/
├── index.yaml
└── layout.yaml
```

### Step 7: Verify YAML Files

Ensure both YAML files parse correctly:

```bash
# Check if YAML is valid (should produce no errors)
python3 -c "import yaml; yaml.safe_load(open('.ai/index.yaml'))"
python3 -c "import yaml; yaml.safe_load(open('.ai/layout.yaml'))"
```

Or if Python is not available:
```bash
# Basic syntax check (look for obvious errors)
cat .ai/index.yaml
cat .ai/layout.yaml
```

## Post-Installation

After successful installation:

1. **Inform the user** that the .ai folder has been created
2. **Explain the purpose** of each directory
3. **Suggest next steps** (e.g., adding language plugins, infrastructure plugins)

## Integration with Other Plugins

This plugin is the foundation. Other plugins will:
- Add documentation to `.ai/docs/`
- Add how-to guides to `.ai/howto/`
- Add templates to `.ai/templates/`
- Update `index.yaml` with new resources
- Update `layout.yaml` with new directory mappings

## Troubleshooting

### Issue: .ai directory already exists
**Solution**: Check if it's from this plugin or something else. If different structure, ask user how to proceed (merge, replace, or skip).

### Issue: YAML files don't parse
**Solution**: Validate YAML syntax. Common issues:
- Incorrect indentation (use spaces, not tabs)
- Missing quotes around special characters
- Invalid structure

### Issue: Git repository not initialized
**Solution**: Run `git init` first, then retry plugin installation.

## Standalone Usage

This plugin works standalone without the orchestrator:

```bash
# Manual installation
1. Copy this plugin to your project
2. Follow steps 1-7 above
3. Validate with step 7
```

## Success Criteria

Installation is successful when:
- ✅ `.ai/` directory exists
- ✅ All subdirectories (docs, features, howto, templates) exist
- ✅ `index.yaml` exists and parses correctly
- ✅ `layout.yaml` exists and parses correctly
- ✅ `PROJECT_CONTEXT.md` exists with project-specific content
- ✅ User understands the purpose of the .ai folder
