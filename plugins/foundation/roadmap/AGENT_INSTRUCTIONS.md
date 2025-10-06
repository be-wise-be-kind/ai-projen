# Roadmap Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the roadmap-based development workflow plugin

**Scope**: Creation and configuration of .roadmap directory structure and roadmap workflow templates

**Overview**: Step-by-step instructions for AI agents to install the roadmap plugin that enables structured,
    multi-PR feature planning and execution. This plugin provides templates and workflows for breaking down
    complex features into manageable, trackable roadmaps with planning, in-progress, and completion phases.

**Dependencies**: foundation/ai-folder plugin (AGENTS.md and .ai/ directory must exist)

**Exports**: .roadmap/ directory with planning/, in-progress/, complete/ subdirectories, how-to-roadmap.md guide,
    roadmap templates in .ai/templates/, and AGENTS.md integration

**Related**: Foundation plugin for roadmap-driven development workflows

**Implementation**: Template-based installation with AGENTS.md integration for roadmap detection and routing

---

## Prerequisites

Before installing this plugin, ensure:
- ✅ Git repository is initialized (`git init` has been run)
- ✅ foundation/ai-folder plugin is installed (AGENTS.md and .ai/ directory exist)
- ✅ Project has complex features requiring multi-PR planning

## Installation Steps

### Step 1: Create .roadmap Directory Structure

Create the roadmaps directory structure in the repository root:

```bash
mkdir -p .roadmap/{planning,in-progress,complete}
```

This creates:
- `.roadmap/` - Root directory for all roadmaps
- `.roadmap/planning/` - Roadmaps being planned (not yet started)
- `.roadmap/in-progress/` - Currently active roadmaps
- `.roadmap/complete/` - Completed roadmaps (archived for reference)

### Step 2: Copy Roadmap Templates to .ai/templates/

Copy the three core roadmap templates from the plugin to the target repository:

```bash
# Copy from plugin location to target repo
cp plugins/foundation/roadmap/ai-content/templates/roadmap-progress-tracker.md.template .ai/templates/
cp plugins/foundation/roadmap/ai-content/templates/roadmap-pr-breakdown.md.template .ai/templates/
cp plugins/foundation/roadmap/ai-content/templates/roadmap-ai-context.md.template .ai/templates/
```

These templates are:
1. **roadmap-progress-tracker.md.template** - Primary handoff document for tracking current progress
2. **roadmap-pr-breakdown.md.template** - Detailed PR breakdown with implementation steps
3. **roadmap-ai-context.md.template** - Comprehensive feature context for AI agents

### Step 3: Create how-to-roadmap.md Guide

Copy the roadmap workflow guide to .ai/howtos/ (following convention that all how-tos go in .ai/howtos/):

```bash
mkdir -p .ai/howtos
cp plugins/foundation/roadmap/ai-content/templates/how-to-roadmap.md.template .ai/howtos/how-to-roadmap.md
```

Then replace these variables in `.ai/howtos/how-to-roadmap.md`:
- `{{PROJECT_NAME}}` → Actual project name
- Any other project-specific placeholders

### Step 4: Add Roadmap Workflow Documentation

Copy the roadmap workflow documentation to .ai/docs/:

```bash
cp plugins/foundation/roadmap/ai-content/docs/ROADMAP_WORKFLOW.md .ai/docs/
```

### Step 5: Update AGENTS.md with Roadmap Guidance

Add roadmap-specific instructions to AGENTS.md. Insert the following section after the "Navigation" section:

```markdown
## Roadmap-Driven Development

### When User Requests Planning

If the user says any of the following:
- "I want to plan out..."
- "I want to roadmap..."
- "Create a roadmap for..."
- "Plan the implementation of..."
- "Break down the feature..."

**Your Actions**:
1. **Read** `.ai/howtos/how-to-roadmap.md` for roadmap workflow guidance
2. **Use templates** from `.ai/templates/roadmap-*.md.template`
3. **Create roadmap** in `.roadmap/planning/[feature-name]/`
4. **Follow** the three-document structure:
   - PROGRESS_TRACKER.md (required - primary handoff document)
   - PR_BREAKDOWN.md (required for multi-PR features)
   - AI_CONTEXT.md (optional - architectural context)

### When User Requests Continuation

If the user says any of the following:
- "I want to continue with..."
- "Continue the roadmap for..."
- "What's next in..."
- "Resume work on..."

**Your Actions**:
1. **Check** `.roadmap/in-progress/` for active roadmaps
2. **Read** the roadmap's `PROGRESS_TRACKER.md` FIRST
3. **Follow** the "Next PR to Implement" section
4. **Update** PROGRESS_TRACKER.md after completing each PR

### Roadmap Lifecycle

```
planning/ → in-progress/ → complete/
   ↓             ↓              ↓
Created      Implementing    Archived
```

See `.ai/howtos/how-to-roadmap.md` for detailed workflow instructions.
```

### Step 6: Update .ai/index.yaml

Add roadmap resources to the project's `.ai/index.yaml`:

```yaml
roadmaps:
  location: .roadmap/
  guide: .ai/howtos/how-to-roadmap.md
  workflow_docs: .ai/docs/ROADMAP_WORKFLOW.md

  structure:
    planning: .roadmap/planning/
    in_progress: .roadmap/in-progress/
    complete: .roadmap/complete/

  templates:
    progress_tracker: .ai/templates/roadmap-progress-tracker.md.template
    pr_breakdown: .ai/templates/roadmap-pr-breakdown.md.template
    ai_context: .ai/templates/roadmap-ai-context.md.template

  three_document_structure:
    - PROGRESS_TRACKER.md (required - primary handoff)
    - PR_BREAKDOWN.md (required for multi-PR)
    - AI_CONTEXT.md (optional - architecture)
```

Add this section under the existing structure in index.yaml.

### Step 7: Create .gitkeep Files

Ensure empty directories are tracked by git:

```bash
touch .roadmap/planning/.gitkeep
touch .roadmap/in-progress/.gitkeep
touch .roadmap/complete/.gitkeep
```

### Step 8: Validate Installation

Verify the following structure exists:

```
.roadmap/
├── planning/
│   └── .gitkeep
├── in-progress/
│   └── .gitkeep
└── complete/
    └── .gitkeep

.ai/
├── howtos/
│   └── how-to-roadmap.md
├── templates/
│   ├── roadmap-progress-tracker.md.template
│   ├── roadmap-pr-breakdown.md.template
│   └── roadmap-ai-context.md.template
├── docs/
│   └── ROADMAP_WORKFLOW.md
└── index.yaml (updated)

AGENTS.md (updated with roadmap section)
```

## Post-Installation

After successful installation:

1. **Inform the user** that roadmap-driven development is now available
2. **Explain the roadmap lifecycle**: planning → in-progress → complete
3. **Highlight** the how-to guide at `.ai/howtos/how-to-roadmap.md`
4. **Suggest** creating their first roadmap if they have a complex feature to plan

## Integration with Other Plugins

The roadmap plugin integrates with:

1. **ai-folder plugin** (required) - Uses .ai/ directory for templates and docs
2. **Application plugins** - Provides workflow for complex app feature planning
3. **Standards plugins** - Roadmaps can enforce standards through PR checklists

## Use Cases

This plugin is essential for:
- **Multi-PR features** requiring coordinated implementation
- **Large repository upgrades** needing phased rollout
- **Complex features** with multiple dependencies
- **Team coordination** across AI agent sessions
- **Progress tracking** for long-running development efforts

## Troubleshooting

### Issue: .roadmap directory already exists
**Solution**: Check if it follows this structure. If different, ask user how to proceed (merge, replace, or skip).

### Issue: AGENTS.md doesn't have clear insertion point
**Solution**: Add the roadmap section after "Navigation" or at the end before any closing remarks.

### Issue: Templates not copying correctly
**Solution**: Verify source templates exist in plugin directory. Check file permissions.

## Standalone Usage

This plugin works standalone without the orchestrator:

```bash
# Manual installation
1. Copy this plugin to your project
2. Follow steps 1-8 above
3. Validate with step 8
```

## Success Criteria

Installation is successful when:
- ✅ `.roadmap/` directory exists with three subdirectories
- ✅ `.ai/howtos/how-to-roadmap.md` guide exists and is populated
- ✅ Three roadmap templates in `.ai/templates/`
- ✅ `AGENTS.md` updated with roadmap detection and routing
- ✅ `.ai/docs/ROADMAP_WORKFLOW.md` exists
- ✅ `.ai/index.yaml` includes roadmap resources
- ✅ User understands roadmap workflow and lifecycle
