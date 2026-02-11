# Roadmap Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the roadmap-based development workflow plugin

**Scope**: Creation of .roadmap directory with features and initiatives, templates, howto guides, and AGENTS.md integration

**Overview**: Step-by-step instructions for AI agents to install the roadmap plugin that enables structured
    feature and initiative planning. Creates a two-tier roadmap system (features for individual deliverables,
    initiatives for strategic groupings) with planning, active, and completed lifecycle phases.

**Dependencies**: foundation/ai-folder plugin (AGENTS.md and .ai/ directory must exist)

**Exports**: .roadmap/ directory with features/ and initiatives/, howto guides, templates, AGENTS.md integration

**Related**: Foundation plugin for roadmap-driven development workflows

**Implementation**: Template-based installation with AGENTS.md integration for feature/initiative detection and routing

---

## Prerequisites

Before installing this plugin, ensure:
- Git repository is initialized
- foundation/ai-folder plugin is installed (AGENTS.md and .ai/ directory exist)
- Project has features or initiatives requiring structured planning

## Installation Steps

### Step 1: Create .roadmap Directory Structure

Create the roadmap directory structure with features and initiatives:

```bash
mkdir -p .roadmap/features/{planning,active,completed}
mkdir -p .roadmap/initiatives/{planning,active,completed}
```

This creates:
- `.roadmap/features/planning/` - Features being planned
- `.roadmap/features/active/` - Features in progress
- `.roadmap/features/completed/` - Completed features (archived)
- `.roadmap/initiatives/planning/` - Initiatives being planned
- `.roadmap/initiatives/active/` - Initiatives in progress
- `.roadmap/initiatives/completed/` - Completed initiatives (archived)

### Step 2: Copy Feature Templates to .ai/templates/

Copy the three feature templates:

```bash
cp plugins/foundation/roadmap/ai-content/templates/feature-progress-tracker.md.template .ai/templates/
cp plugins/foundation/roadmap/ai-content/templates/feature-milestone-breakdown.md.template .ai/templates/
cp plugins/foundation/roadmap/ai-content/templates/feature-ai-context.md.template .ai/templates/
```

### Step 3: Copy Initiative Templates to .ai/templates/

Copy the three initiative templates:

```bash
cp plugins/foundation/roadmap/ai-content/templates/initiative-tracker.md.template .ai/templates/
cp plugins/foundation/roadmap/ai-content/templates/initiative-feature-breakdown.md.template .ai/templates/
cp plugins/foundation/roadmap/ai-content/templates/initiative-ai-context.md.template .ai/templates/
```

### Step 4: Create How-To Guides

Copy the howto guides to .ai/howto/:

```bash
cp plugins/foundation/roadmap/ai-content/templates/how-to-plan-feature.md.template .ai/howto/how-to-plan-a-feature.md
cp plugins/foundation/roadmap/ai-content/templates/how-to-plan-initiative.md.template .ai/howto/how-to-plan-an-initiative.md
cp plugins/foundation/roadmap/ai-content/templates/how-to-continue-feature.md.template .ai/howto/how-to-continue-feature-work.md
cp plugins/foundation/roadmap/ai-content/templates/how-to-continue-initiative.md.template .ai/howto/how-to-continue-initiative-work.md
cp plugins/foundation/roadmap/ai-content/templates/how-to-update-progress.md.template .ai/howto/how-to-update-progress.md
```

Replace `{{PROJECT_NAME}}` with actual project name in all howto files.

### Step 5: Copy Roadmap Workflow Documentation

```bash
cp plugins/foundation/roadmap/ai-content/docs/ROADMAP_WORKFLOW.md .ai/docs/
```

### Step 6: Update AGENTS.md with Roadmap Guidance

Add a "Roadmap-Driven Development" section to AGENTS.md. Insert after the main workflow sections:

```markdown
## Roadmap-Driven Development

### Feature vs Initiative

| Concept | Scope | Location |
|---------|-------|----------|
| **Feature** | Single deliverable, 1+ milestones | `.roadmap/features/` |
| **Initiative** | Strategic grouping of features | `.roadmap/initiatives/` |

### Lifecycle

```
planning/ -> active/ -> completed/
```

### Detection Patterns

**Plan a feature** - User says "plan feature X", "roadmap X", "break down X":
- Route to: `.ai/howto/how-to-plan-a-feature.md`

**Plan an initiative** - User says "plan initiative X", "strategic plan for X":
- Route to: `.ai/howto/how-to-plan-an-initiative.md`

**Continue feature work** - User says "continue with X", "resume X", "next milestone":
- Route to: `.ai/howto/how-to-continue-feature-work.md`

**Continue initiative work** - User says "continue initiative X":
- Route to: `.ai/howto/how-to-continue-initiative-work.md`

**Update progress** - User says "update progress", "mark complete":
- Route to: `.ai/howto/how-to-update-progress.md`

### Templates

Feature: `.ai/templates/feature-*.md.template`
Initiative: `.ai/templates/initiative-*.md.template`
```

### Step 7: Update .ai/index.yaml

Add roadmap resources to index.yaml:

```yaml
roadmap:
  location: .roadmap/
  structure:
    features:
      planning: .roadmap/features/planning/
      active: .roadmap/features/active/
      completed: .roadmap/features/completed/
    initiatives:
      planning: .roadmap/initiatives/planning/
      active: .roadmap/initiatives/active/
      completed: .roadmap/initiatives/completed/

  feature_templates:
    progress_tracker: .ai/templates/feature-progress-tracker.md.template
    milestone_breakdown: .ai/templates/feature-milestone-breakdown.md.template
    ai_context: .ai/templates/feature-ai-context.md.template

  initiative_templates:
    tracker: .ai/templates/initiative-tracker.md.template
    feature_breakdown: .ai/templates/initiative-feature-breakdown.md.template
    ai_context: .ai/templates/initiative-ai-context.md.template

  guides:
    plan_feature: .ai/howto/how-to-plan-a-feature.md
    plan_initiative: .ai/howto/how-to-plan-an-initiative.md
    continue_feature: .ai/howto/how-to-continue-feature-work.md
    continue_initiative: .ai/howto/how-to-continue-initiative-work.md
    update_progress: .ai/howto/how-to-update-progress.md
    workflow_docs: .ai/docs/ROADMAP_WORKFLOW.md
```

### Step 8: Create .gitkeep Files

```bash
touch .roadmap/features/planning/.gitkeep
touch .roadmap/features/active/.gitkeep
touch .roadmap/features/completed/.gitkeep
touch .roadmap/initiatives/planning/.gitkeep
touch .roadmap/initiatives/active/.gitkeep
touch .roadmap/initiatives/completed/.gitkeep
```

### Step 9: Validate Installation

Verify the following structure exists:

```
.roadmap/
├── features/
│   ├── planning/
│   ├── active/
│   └── completed/
└── initiatives/
    ├── planning/
    ├── active/
    └── completed/

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
├── docs/
│   └── ROADMAP_WORKFLOW.md
└── index.yaml (updated)

AGENTS.md (updated with roadmap section)
```

## Post-Installation

After successful installation:

1. **Inform the user** that roadmap-driven development is available
2. **Explain the two-tier system**: features for individual deliverables, initiatives for strategic groupings
3. **Explain the lifecycle**: planning -> active -> completed
4. **Highlight howto guides** for planning and continuing work
5. **Suggest** creating their first feature or initiative if they have complex work to plan

## Integration with Other Plugins

1. **ai-folder plugin** (required) - Uses .ai/ directory for templates and docs
2. **Application plugins** - Provides workflow for complex app feature planning
3. **Standards plugins** - Roadmaps can enforce standards through milestone checklists

## Success Criteria

Installation is successful when:
- `.roadmap/features/` exists with planning/, active/, completed/ subdirectories
- `.roadmap/initiatives/` exists with planning/, active/, completed/ subdirectories
- 5 howto guides exist in `.ai/howto/`
- 6 templates (3 feature + 3 initiative) exist in `.ai/templates/`
- `AGENTS.md` updated with feature and initiative detection patterns
- `.ai/docs/ROADMAP_WORKFLOW.md` exists
- `.ai/index.yaml` includes roadmap resources
- User understands the two-tier roadmap system
