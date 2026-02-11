# AI Folder Plugin

**Purpose**: Create the foundational .ai directory structure for AI-ready repositories

**Scope**: Universal plugin that every AI-ready repository needs

**Overview**: The ai-folder plugin creates a structured .ai directory that enables AI agents to navigate,
    understand, and work with your codebase effectively. Provides three core documents (ai-context.md,
    ai-rules.md, index.yaml), IDE configuration files (AGENTS.md, CLAUDE.md, warp.md, .cursor/rules/agents.mdc),
    and organized directories for documentation, how-to guides, and templates.

**Dependencies**: Git repository

**Exports**: .ai/ directory with core documents, IDE config files, docs/, howto/, templates/

**Related**: Foundation for all other ai-projen plugins

**Implementation**: Template-based installation with project-specific variable substitution

---

## What This Plugin Does

The ai-folder plugin creates a standardized `.ai/` directory structure that:

1. **Orients AI agents** through three core documents (ai-context.md, ai-rules.md, index.yaml)
2. **Configures IDE entry points** (AGENTS.md, CLAUDE.md, warp.md, .cursor/rules/agents.mdc)
3. **Documents project context** for AI understanding
4. **Provides templates** for common files and patterns
5. **Organizes how-to guides** for common tasks

## Why Every Project Needs This

AI coding assistants work best when they have:
- Clear project context and mandatory rules
- Structured navigation metadata
- IDE-specific entry point configuration
- Templates for common patterns

## Files and Directories Created

```
AGENTS.md                       # Primary AI agent entry point (root)
CLAUDE.md                       # Claude IDE config (root)
warp.md                         # Warp IDE config (root)
.cursor/
└── rules/
    └── agents.mdc              # Cursor IDE config
.ai/
├── ai-context.md               # Project context (core document 1)
├── ai-rules.md                 # Mandatory rules (core document 2)
├── index.yaml                  # Navigation index (core document 3)
├── docs/
│   └── PROJECT_CONTEXT.md      # Deep-dive reference (optional)
├── howto/                      # How-to guides
└── templates/                  # Reusable templates
```

### Three Core Documents

Every AI agent reads these first (the "three-document protocol"):

1. **ai-context.md** - What the project does, architecture, key patterns
2. **ai-rules.md** - Quality gates, coding standards, mandatory rules
3. **index.yaml** - Navigation index with all resources and file locations

### IDE Configuration Files

All IDE configs contain: "read AGENTS.md" - ensuring AI agents always start at the entry point regardless of which IDE/tool invokes them.

## Installation

### Standalone (Without Orchestrator)

An AI agent can install this plugin by following [AGENT_INSTRUCTIONS.md](./AGENT_INSTRUCTIONS.md).

Quick summary:
1. Create `.ai/` directory structure
2. Create ai-context.md, ai-rules.md from templates
3. Create index.yaml from template
4. Create AGENTS.md, CLAUDE.md, warp.md, .cursor/rules/agents.mdc
5. Optionally create PROJECT_CONTEXT.md
6. Validate YAML files

### With Orchestrator

When using how-to-create-new-ai-repo.md or how-to-upgrade-to-ai-repo.md, this plugin is automatically installed first as the foundation.

## Integration with Other Plugins

The ai-folder plugin is the foundation. Other plugins integrate by:

1. **Adding Documentation** to `.ai/docs/`
2. **Adding How-Tos** to `.ai/howto/`
3. **Adding Templates** to `.ai/templates/`
4. **Updating index.yaml** with new resources
5. **Extending AGENTS.md** using plugin extension markers

## Customization

Customize by:
1. Adding project-specific sections to ai-context.md
2. Adding project-specific rules to ai-rules.md
3. Creating how-to guides in `.ai/howto/`
4. Adding templates to `.ai/templates/`
5. Updating index.yaml with new resources

## Troubleshooting

### .ai folder already exists
Check if it follows the three-document pattern. Merge if compatible, replace if incompatible.

### YAML files not parsing
Use spaces (not tabs), quote special characters, validate with `python3 -c "import yaml; yaml.safe_load(open('.ai/index.yaml'))"`.
