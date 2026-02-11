# ai-projen - Project Context

**Purpose**: Project development context for AI agents working on or with the ai-projen framework

**Scope**: Mission, architecture, key patterns, directory structure, and development guidelines

**Overview**: Primary context document for AI agents. Describes what ai-projen does, how it works, its architectural patterns, and the directory structure agents need to navigate. Peer document to ai-rules.md; together with index.yaml they form the three core documents every agent reads first.

**Dependencies**: AGENTS.md (entry point), ai-rules.md (mandatory rules), index.yaml (navigation)

**Exports**: Framework context, architectural patterns, development guidelines

**Related**: ai-rules.md for mandatory rules, index.yaml for navigation, .ai/docs/PROJECT_CONTEXT.md for deep-dive reference

---

## Mission

ai-projen is a plugin-based framework that transforms repositories into AI-ready environments through composable, standalone plugins.

**AI-Ready Definition**: A repository where AI agents can be trusted to generate code that is well-written, durable, scalable, performant, secure, and follows industry best practices.

**Services Provided**:
1. Create new repositories from scratch
2. Upgrade existing repositories safely
3. Add single or multiple capabilities to repositories
4. Lint, evaluate, and grade existing repositories

## Architecture

### Plugin-Based Design

Everything in ai-projen is a composable plugin organized into six categories:

| Category | Location | Purpose |
|----------|----------|---------|
| Foundation | `plugins/foundation/` | Universal plugins (ai-folder, roadmap) |
| Languages | `plugins/languages/` | Language-specific tooling (Python, TypeScript) |
| Infrastructure | `plugins/infrastructure/` | Deployment tools (Docker, CI/CD, IaC) |
| Standards | `plugins/standards/` | Quality enforcement (security, docs, pre-commit) |
| Applications | `plugins/applications/` | Pre-configured compositions (python-cli, react-python-fullstack) |
| Repository | `plugins/repository/` | Repository-level tools (environment-setup) |

### Plugin Structure

Every plugin follows this standard organization:

```
<plugin-name>/
├── AGENT_INSTRUCTIONS.md       # AI installation guide (REQUIRED)
├── README.md                   # Human documentation (REQUIRED)
├── ai-content/                 # -> Target repo's .ai/ directory
│   ├── docs/
│   ├── howtos/
│   └── templates/
├── project-content/            # -> Target repo root
└── src-templates/              # Code examples (not auto-installed)
```

### Plugin Manifest

`plugins/PLUGIN_MANIFEST.yaml` is the single source of truth for available plugins, their status, options, dependencies, and installation paths.

## Key Patterns

### Two Agent Interaction Types

1. **Repository Assistant Mode** - Agent helps a user work on THEIR repository using ai-projen plugins
2. **Framework Developer Mode** - Agent works on ai-projen itself

### Three Core Documents

Every AI session begins by reading:
1. `.ai/ai-context.md` (this document) - Project context and patterns
2. `.ai/ai-rules.md` - Quality gates and mandatory rules
3. `.ai/index.yaml` - Navigation and resource index

### Standalone-First Plugins

Every plugin works independently without requiring orchestration. This enables incremental adoption and reduces coupling.

### Composable Without Conflicts

Plugins combine through isolated configurations, namespaced Make targets, and non-overlapping file paths.

## Directory Structure

```
ai-projen/
├── AGENTS.md                   # Primary AI agent entry point
├── CLAUDE.md                   # Claude-specific IDE config
├── warp.md                     # Warp IDE config
├── .cursor/rules/agents.mdc   # Cursor IDE config
├── .ai/
│   ├── ai-context.md           # Project context (this file)
│   ├── ai-rules.md             # Mandatory rules
│   ├── index.yaml              # Navigation index
│   ├── docs/                   # Conceptual documentation
│   ├── howto/                  # Procedural how-to guides
│   └── templates/              # Reusable templates
├── plugins/
│   ├── PLUGIN_MANIFEST.yaml    # Master plugin registry
│   ├── foundation/             # Universal plugins
│   ├── languages/              # Language-specific plugins
│   ├── infrastructure/         # Deployment tooling
│   ├── standards/              # Quality/governance
│   ├── applications/           # Meta-plugins
│   └── repository/             # Repository-level tools
└── .roadmap/
    ├── features/
    │   ├── planning/           # Features being planned
    │   ├── active/             # Features in progress
    │   └── completed/          # Completed features
    └── initiatives/
        ├── planning/           # Initiatives being planned
        ├── active/             # Initiatives in progress
        └── completed/          # Completed initiatives
```

## Design Philosophies

1. **Determinism Over Flexibility** - Explicit instructions, clear success criteria, defensive validation
2. **Explicit Over Implicit** - Never assume agents remember context; state requirements in every plugin
3. **Standalone First** - Every plugin works independently
4. **Composable by Design** - Plugins combine without conflicts
5. **Extensible Through Templates** - `_template/` directories for each category
6. **Protect the User's Machine** - Isolated environments, no global installs

## Source Material

All patterns are extracted from the [durable-code-test](https://github.com/steve-e-jackson/durable-code-test) production repository - proven patterns from real applications, not theoretical best practices.

## Roadmap Structure

ai-projen uses a two-tier roadmap system:

- **Features** (`.roadmap/features/`) - Individual deliverables with milestones. Each feature has PROGRESS_TRACKER.md, MILESTONE_BREAKDOWN.md, and AI_CONTEXT.md.
- **Initiatives** (`.roadmap/initiatives/`) - Strategic groupings of related features. Each initiative has INITIATIVE_TRACKER.md, FEATURE_BREAKDOWN.md, and AI_CONTEXT.md.

Both follow a lifecycle: `planning/` -> `active/` -> `completed/`

See `.ai/howto/how-to-plan-a-feature.md` and `.ai/howto/how-to-plan-an-initiative.md` for planning workflows.

## Deep-Dive Reference

For comprehensive architecture details, plugin development guides, and full design philosophy documentation, see `.ai/docs/PROJECT_CONTEXT.md`.
