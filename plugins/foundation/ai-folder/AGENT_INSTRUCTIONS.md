# AI Folder Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the foundational .ai folder structure

**Scope**: Creation and configuration of the .ai directory, core documents, and IDE config files

**Overview**: Step-by-step instructions for AI agents to install the universal ai-folder plugin that creates
    the foundational .ai directory structure, three core documents (ai-context.md, ai-rules.md, index.yaml),
    IDE configuration files (AGENTS.md, CLAUDE.md, warp.md, .cursor/rules/agents.mdc), and initial documentation.

**Dependencies**: Git repository initialized

**Exports**: .ai/ directory with ai-context.md, ai-rules.md, index.yaml, docs/, howto/, templates/;
    AGENTS.md, CLAUDE.md, warp.md, .cursor/rules/agents.mdc at repository root

**Related**: Foundation plugin for all AI-ready repositories

**Implementation**: Template-based installation with variable substitution for project-specific values

---

## Parameters

This plugin accepts the following parameters:

- **INSTALL_PATH** - Directory where .ai/ folder will be created
  - Default: `.` (current directory)
  - Example: `backend/`, `services/api/`, `app/`
  - Notes: Creates the .ai/ directory and AGENTS.md at this location

### Usage

Standalone (creates .ai/ in current directory):
```
Follow: plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md
```

With custom path:
```
Follow: plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=backend/
```

---

## Prerequisites

Before installing this plugin, ensure:
- Git repository is initialized (`git init` has been run)
- You know the project name
- You know the project type (e.g., python, typescript, full-stack, etc.)

## Installation Steps

### Step 1: Gather Project Information

Ask the user (or infer from context):
1. **Project Name**: What is the name of this project?
2. **Project Type**: What type of project is this? (python, typescript, go, rust, full-stack, etc.)
3. **Project Purpose**: Brief description of what this project does
4. **Project Status**: Current status (in-development, stable, experimental, etc.)

### Step 2: Create .ai Directory Structure

Set the installation path and create the directory structure:

```bash
INSTALL_PATH="${INSTALL_PATH:-.}"
mkdir -p "${INSTALL_PATH}/.ai/{docs,howto,templates}"
```

This creates:
- `${INSTALL_PATH}/.ai/` - Root AI navigation folder
- `${INSTALL_PATH}/.ai/docs/` - Project documentation for AI understanding
- `${INSTALL_PATH}/.ai/howto/` - How-to guides for common tasks
- `${INSTALL_PATH}/.ai/templates/` - Reusable file templates

### Step 3: Create ai-context.md

Copy `ai-content/templates/ai-context.md.template` to `${INSTALL_PATH}/.ai/ai-context.md` and replace variables:

**Variables to replace:**
- `{{PROJECT_NAME}}` -> Actual project name
- `{{PROJECT_PURPOSE}}` -> Brief project description
- `{{PROJECT_TYPE}}` -> Actual project type
- `{{PROJECT_STATUS}}` -> Current status

Fill in the Architecture, Key Patterns, and Directory Structure sections based on the project.

### Step 4: Create ai-rules.md

Copy `ai-content/templates/ai-rules.md.template` to `${INSTALL_PATH}/.ai/ai-rules.md` and replace variables:

**Variables to replace:**
- `{{PROJECT_TYPE}}` -> Actual project type

Customize rules for the specific project type.

### Step 5: Create index.yaml

Copy `ai-content/templates/index.yaml.template` to `${INSTALL_PATH}/.ai/index.yaml` and replace variables:

**Variables to replace:**
- `{{PROJECT_NAME}}` -> Actual project name
- `{{PROJECT_TYPE}}` -> Actual project type
- `{{PROJECT_PURPOSE}}` -> Brief project description
- `{{ARCHITECTURE_PATTERN}}` -> Architecture pattern

### Step 6: Create AGENTS.md

Copy `ai-content/templates/agents.md.template` to `${INSTALL_PATH}/AGENTS.md` and replace variables:

**Variables to replace:**
- `{{PROJECT_NAME}}` -> Actual project name
- `{{PROJECT_PURPOSE}}` -> Brief project description
- `{{PROJECT_TYPE}}` -> Actual project type
- `{{PROJECT_STATUS}}` -> Current status

**Important**: This file goes in `${INSTALL_PATH}/` (at the same level as `.ai/`).

### Step 7: Create IDE Configuration Files

Create three IDE configuration files:

**CLAUDE.md** (at `${INSTALL_PATH}/CLAUDE.md`):
```
Copy ai-content/templates/claude.md.template to ${INSTALL_PATH}/CLAUDE.md
```

**warp.md** (at `${INSTALL_PATH}/warp.md`):
```
Copy ai-content/templates/warp.md.template to ${INSTALL_PATH}/warp.md
```

**.cursor/rules/agents.mdc** (at `${INSTALL_PATH}/.cursor/rules/agents.mdc`):
```
mkdir -p ${INSTALL_PATH}/.cursor/rules
Copy ai-content/templates/cursor-agents.mdc.template to ${INSTALL_PATH}/.cursor/rules/agents.mdc
```

All three contain: `- The very first response you should have to any prompt is to read AGENTS.md`

### Step 8: Create Initial Documentation (Optional)

Create `${INSTALL_PATH}/.ai/docs/PROJECT_CONTEXT.md` as a deep-dive reference document:

```markdown
# {{PROJECT_NAME}} - Project Context

**Purpose**: Comprehensive project context and architecture documentation

**Scope**: Deep-dive reference for {{PROJECT_NAME}}

**Overview**: Detailed architecture, design decisions, and development guidelines.
    For primary context, see .ai/ai-context.md.

---

## Project Purpose

[Detailed description of why this project exists]

## Architecture Overview

[High-level architecture description]

## Key Components

[List and describe major components]
```

### Step 9: Validate Installation

Verify the following structure exists:

```
${INSTALL_PATH}/
├── AGENTS.md              # Primary agent entry point
├── CLAUDE.md              # Claude IDE config
├── warp.md                # Warp IDE config
├── .cursor/
│   └── rules/
│       └── agents.mdc     # Cursor IDE config
└── .ai/
    ├── ai-context.md       # Project context
    ├── ai-rules.md         # Mandatory rules
    ├── index.yaml          # Navigation index
    ├── docs/
    │   └── PROJECT_CONTEXT.md (optional)
    ├── howto/
    └── templates/
```

### Step 10: Verify YAML Files

Ensure YAML files parse correctly:

```bash
python3 -c "import yaml; yaml.safe_load(open('${INSTALL_PATH}/.ai/index.yaml'))"
```

## Post-Installation

After successful installation:

1. **Inform the user** that the .ai folder and core documents have been created
2. **Explain the three-document protocol**: ai-context.md, ai-rules.md, index.yaml
3. **Highlight AGENTS.md** as the primary entry point for AI agents
4. **Suggest next steps** (e.g., adding language plugins, infrastructure plugins)

## Integration with Other Plugins

This plugin is the foundation. Other plugins will:
- Add documentation to `.ai/docs/`
- Add how-to guides to `.ai/howto/`
- Add templates to `.ai/templates/`
- Update `index.yaml` with new resources
- **Extend `AGENTS.md`** by adding content between plugin extension markers

## Success Criteria

Installation is successful when:
- `${INSTALL_PATH}/AGENTS.md` exists with project-specific content
- `${INSTALL_PATH}/CLAUDE.md` exists with "read AGENTS.md" instruction
- `${INSTALL_PATH}/warp.md` exists with "read AGENTS.md" instruction
- `${INSTALL_PATH}/.cursor/rules/agents.mdc` exists with "read AGENTS.md" instruction
- `${INSTALL_PATH}/.ai/ai-context.md` exists with project context
- `${INSTALL_PATH}/.ai/ai-rules.md` exists with mandatory rules
- `${INSTALL_PATH}/.ai/index.yaml` exists and parses correctly
- All subdirectories (docs, howto, templates) exist
- User understands the three-document protocol
