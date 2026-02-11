# ai-projen - Mandatory Rules

**Purpose**: Quality gates, coding standards, and mandatory rules for all AI agents

**Scope**: Rules that apply to all work done in or with the ai-projen framework

**Overview**: Defines the mandatory rules, quality gates, and standards that every AI agent must follow when working on ai-projen or using it to transform target repositories. Peer document to ai-context.md; together with index.yaml they form the three core documents every agent reads first.

**Dependencies**: AGENTS.md (entry point), ai-context.md (project context), index.yaml (navigation)

**Exports**: Quality gates, coding standards, git rules, documentation rules

**Related**: ai-context.md for project context, .ai/docs/FILE_HEADER_STANDARDS.md for full header details

---

## Quality Gates

### YAML Validation

All YAML files must validate before committing:

```bash
python3 -c "import yaml; yaml.safe_load(open('.ai/index.yaml'))"
python3 -c "import yaml; yaml.safe_load(open('plugins/PLUGIN_MANIFEST.yaml'))"
```

### Plugin Standards

Every plugin must include:
- `AGENT_INSTRUCTIONS.md` with state detection, branching, installation steps, and success criteria
- `README.md` with human-readable overview
- Git branching step following `PLUGIN_GIT_WORKFLOW_STANDARD.md`

### File Header Standard

All files require headers. Reference `.ai/docs/FILE_HEADER_STANDARDS.md` for complete details.

**Mandatory fields** (all file types):
- **Purpose** - Brief description
- **Scope** - What this covers
- **Overview** - Comprehensive explanation

**Additional fields for code files**:
- **Dependencies** - Key dependencies
- **Exports** - Main classes/functions
- **Interfaces** - Key APIs
- **Implementation** - Notable patterns

**Markdown format**:
```markdown
# Document Title

**Purpose**: Brief description
**Scope**: What this covers
**Overview**: Comprehensive explanation
**Dependencies**: Related files/resources
**Exports**: What this provides
**Related**: Links to related docs
**Implementation**: Notable patterns

---
```

## Git Rules

### Branch Requirements

- **NEVER** work directly on main/master/develop branches
- Create feature branches BEFORE making changes
- Branch naming convention:
  - `feature/add-<name>` - New features
  - `fix/<issue>` - Bug fixes
  - `enhance/<capability>` - Improvements
  - `docs/<update>` - Documentation only

### Commit Standards

- Use conventional commits format: `feat:`, `fix:`, `docs:`, `enhance:`
- Include descriptive messages explaining the "why"
- Validate YAML files before committing
- Update relevant documentation with code changes

## Documentation Rules

### Atemporal Language

All documentation must use atemporal language. Avoid:
- Timestamps ("Created: 2025-09-12")
- State change language ("This replaces the old...")
- Temporal qualifiers ("Currently supports...", "Now includes...")
- Future references ("Will be added in...", "Coming soon")

### File Placement

| File Type | Location |
|-----------|----------|
| How-to guides | `.ai/howto/` (filenames start with `how-to-`) |
| Conceptual docs | `.ai/docs/` (architecture, standards, specs) |
| Templates | `.ai/templates/` (universal) or `plugins/*/templates/` (plugin-specific) |
| Plugin docs | `plugins/{category}/{name}/README.md` |
| Roadmaps | `.roadmap/features/` or `.roadmap/initiatives/` |

### Plugin Documentation

When creating or modifying plugins:
1. Follow `AGENT_INSTRUCTIONS.md` format exactly
2. Include all required sections (Prerequisites, Steps, Validation, Success Criteria)
3. Include Git branching step from `PLUGIN_GIT_WORKFLOW_STANDARD.md`
4. Update `PLUGIN_MANIFEST.yaml` when adding new plugins
5. Update `.ai/index.yaml` when adding new files/sections

## Anti-Shortcut Rules

When working as Repository Assistant, NEVER:
- Skip steps to "save time"
- Assume answers to user questions
- Copy files instead of running plugin instructions
- Skip validation steps
- Work on main branch

**Process correctness > Speed > End result**
