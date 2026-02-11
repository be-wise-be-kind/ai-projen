# Roadmap Plugin

**Purpose**: Enable roadmap-based development workflow with features and initiatives

**Scope**: Foundation plugin for structured planning and execution tracking

**Overview**: The roadmap plugin provides a two-tier system for planning and tracking work:
    features for individual deliverables and initiatives for strategic groupings of features.
    Both follow a lifecycle of planning -> active -> completed.

**Dependencies**: foundation/ai-folder plugin

**Exports**: .roadmap/ directory with features/ and initiatives/, templates, howto guides, AGENTS.md integration

**Related**: Foundation for roadmap-driven development in AI-ready repositories

**Implementation**: Template-based installation with lifecycle management

---

## What This Plugin Does

The roadmap plugin establishes a two-tier development workflow:

1. **Features** - Individual deliverables broken into milestones
2. **Initiatives** - Strategic groupings of related features
3. **Lifecycle management** - planning -> active -> completed phases
4. **AI agent coordination** - Handoff documents for seamless continuation
5. **How-to guides** - Workflow guidance for planning and continuing work

## Directory Structure Created

```
.roadmap/
├── features/
│   ├── planning/              # Features being planned
│   ├── active/                # Features in progress
│   └── completed/             # Completed features
└── initiatives/
    ├── planning/              # Initiatives being planned
    ├── active/                # Initiatives in progress
    └── completed/             # Completed initiatives

.ai/
├── howto/
│   ├── how-to-plan-a-feature.md
│   ├── how-to-plan-an-initiative.md
│   ├── how-to-continue-feature-work.md
│   ├── how-to-continue-initiative-work.md
│   └── how-to-update-progress.md
├── templates/
│   ├── feature-progress-tracker.md.template
│   ├── feature-milestone-breakdown.md.template
│   ├── feature-ai-context.md.template
│   ├── initiative-tracker.md.template
│   ├── initiative-feature-breakdown.md.template
│   └── initiative-ai-context.md.template
└── docs/
    └── ROADMAP_WORKFLOW.md

AGENTS.md                      # Updated with roadmap routing
.ai/index.yaml                 # Updated with roadmap resources
```

## Feature Documents

Each feature has three documents:

| Document | Required | Purpose |
|----------|----------|---------|
| PROGRESS_TRACKER.md | Yes | Primary handoff - current status, next milestone |
| MILESTONE_BREAKDOWN.md | Yes (multi-milestone) | Implementation steps per milestone |
| AI_CONTEXT.md | Optional | Architecture, decisions, constraints |

## Initiative Documents

Each initiative has three documents:

| Document | Required | Purpose |
|----------|----------|---------|
| INITIATIVE_TRACKER.md | Yes | Feature rollup, next action routing |
| FEATURE_BREAKDOWN.md | Yes | Feature inventory and dependencies |
| AI_CONTEXT.md | Optional | Strategic vision, cross-feature patterns |

## Lifecycle

```
planning/ -> active/ -> completed/
```

Features and initiatives move through phases as work progresses.

## Installation

An AI agent can install this plugin by following [AGENT_INSTRUCTIONS.md](./AGENT_INSTRUCTIONS.md).

Quick summary:
1. Create `.roadmap/features/` and `.roadmap/initiatives/` directories
2. Copy feature and initiative templates to `.ai/templates/`
3. Create howto guides in `.ai/howto/`
4. Add workflow documentation
5. Update AGENTS.md with detection and routing
6. Update `.ai/index.yaml` with roadmap resources

## AI Agent Integration

### Detection Patterns

AI agents detect:
- **Feature planning**: "plan feature X", "roadmap X", "break down X"
- **Initiative planning**: "plan initiative X", "strategic plan for X"
- **Continuation**: "continue with X", "resume X", "next milestone"
- **Progress updates**: "update progress on X", "mark X complete"

### Routing

Detected requests route to the appropriate howto guide in `.ai/howto/`.

## Integration with Other Plugins

1. **ai-folder plugin** (required) - Uses .ai/ directory structure
2. **Application plugins** - Features and initiatives for complex app planning
3. **Standards plugins** - Milestone checklists can enforce standards
