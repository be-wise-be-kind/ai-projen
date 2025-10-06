# Roadmap Plugin

**Purpose**: Enable roadmap-based development workflow for complex, multi-PR features

**Scope**: Foundation plugin for structured feature planning and execution tracking

**Overview**: The roadmap plugin provides a systematic approach to planning, implementing, and tracking
    complex features that require multiple pull requests. It creates a structured workflow with planning,
    in-progress, and completion phases, along with comprehensive templates for AI agent coordination.

**Dependencies**: foundation/ai-folder plugin

**Exports**: .roadmaps/ directory, roadmap templates, workflow documentation, and AGENTS.md integration

**Related**: Foundation for roadmap-driven development in AI-ready repositories

**Implementation**: Template-based installation with lifecycle management (planning → in-progress → complete)

---

## What This Plugin Does

The roadmap plugin establishes a roadmap-driven development workflow that:

1. **Structures complex feature planning** with standardized templates
2. **Tracks implementation progress** across multiple pull requests
3. **Coordinates AI agent work** with handoff documents
4. **Organizes roadmaps by lifecycle** (planning, in-progress, complete)
5. **Provides workflow guidance** through how-to documentation

## Why Use Roadmaps?

Roadmaps are essential for:

- **Multi-PR Features**: Breaking down large features into manageable, atomic pull requests
- **Complex Upgrades**: Planning phased rollouts of major repository changes
- **Team Coordination**: Maintaining context across multiple AI agent sessions
- **Progress Tracking**: Knowing exactly what's done, what's next, and what's remaining
- **AI Agent Handoff**: Enabling seamless continuation of work by AI agents

## Files and Directories Created

```
.roadmaps/
├── planning/              # Roadmaps being planned (not started)
├── in-progress/           # Currently active roadmaps
├── complete/              # Completed roadmaps (archived)
└── how-to-roadmap.md      # User guide for roadmap workflow

.ai/
├── templates/
│   ├── roadmap-progress-tracker.md.template    # Primary handoff document
│   ├── roadmap-pr-breakdown.md.template        # PR implementation details
│   └── roadmap-ai-context.md.template          # Feature architecture context
└── docs/
    └── ROADMAP_WORKFLOW.md                     # Workflow documentation

AGENTS.md                  # Updated with roadmap detection/routing
.ai/index.yaml            # Updated with roadmap resources
```

### Three-Document Roadmap Structure

Every roadmap uses a standardized three-document structure:

#### 1. PROGRESS_TRACKER.md (Required)
**Primary AI agent handoff document**

Contains:
- Current status and next PR to implement
- Overall progress dashboard
- Prerequisites and validation checklist
- AI agent instructions
- Update protocol

This is the FIRST document AI agents read when continuing work.

#### 2. PR_BREAKDOWN.md (Required for multi-PR features)
**Detailed implementation guide**

Contains:
- Complete PR breakdown with step-by-step instructions
- File structures and code examples
- Testing requirements
- Success criteria for each PR
- Dependencies between PRs

#### 3. AI_CONTEXT.md (Optional)
**Comprehensive feature context**

Contains:
- Feature vision and architecture
- Design decisions and rationale
- Integration points
- Technical constraints
- Common patterns to follow

## Roadmap Lifecycle

Roadmaps progress through three phases:

```
1. PLANNING              2. IN-PROGRESS           3. COMPLETE
   ↓                        ↓                        ↓
.roadmaps/planning/    .roadmaps/in-progress/   .roadmaps/complete/
   ↓                        ↓                        ↓
Creating roadmap       Implementing PRs         Archived for reference
Using templates        Following PROGRESS_      Learn from past work
                       TRACKER.md
```

### Planning Phase
- Create roadmap from templates
- Fill in feature details
- Break down into PRs
- Define success criteria

### In-Progress Phase
- Implement PRs sequentially
- Update PROGRESS_TRACKER.md after each PR
- Coordinate AI agent work
- Track blockers and notes

### Complete Phase
- Archive completed roadmap
- Preserve for future reference
- Extract learnings and patterns

## Installation

### Standalone (Without Orchestrator)

An AI agent can install this plugin by following [AGENT_INSTRUCTIONS.md](./AGENT_INSTRUCTIONS.md).

Quick summary:
1. Create `.roadmaps/` directory structure
2. Copy roadmap templates to `.ai/templates/`
3. Create `how-to-roadmap.md` guide
4. Add roadmap documentation
5. Update `AGENTS.md` with roadmap routing
6. Update `.ai/index.yaml`
7. Validate installation

### With Orchestrator

When using orchestration workflows, this plugin can be installed as part of the foundation setup for projects requiring complex feature planning.

## Using Roadmaps

### Creating a New Roadmap

1. **Copy templates** to `.roadmaps/planning/[feature-name]/`:
   ```bash
   mkdir -p .roadmaps/planning/my-feature
   cp .ai/templates/roadmap-progress-tracker.md.template .roadmaps/planning/my-feature/PROGRESS_TRACKER.md
   cp .ai/templates/roadmap-pr-breakdown.md.template .roadmaps/planning/my-feature/PR_BREAKDOWN.md
   cp .ai/templates/roadmap-ai-context.md.template .roadmaps/planning/my-feature/AI_CONTEXT.md
   ```

2. **Replace placeholders** with feature-specific values

3. **Plan the work** - Break down into atomic PRs

4. **Move to in-progress** when ready to start:
   ```bash
   mv .roadmaps/planning/my-feature .roadmaps/in-progress/
   ```

### Continuing an Existing Roadmap

1. **Check in-progress roadmaps**:
   ```bash
   ls .roadmaps/in-progress/
   ```

2. **Read PROGRESS_TRACKER.md** first:
   ```bash
   cat .roadmaps/in-progress/my-feature/PROGRESS_TRACKER.md
   ```

3. **Follow "Next PR to Implement"** section

4. **Update PROGRESS_TRACKER.md** after completing each PR

### Completing a Roadmap

When all PRs are done:

```bash
mv .roadmaps/in-progress/my-feature .roadmaps/complete/
```

Completed roadmaps serve as reference for similar future work.

## AI Agent Integration

### Detection Patterns

AI agents automatically detect roadmap requests:

**Planning requests**:
- "I want to plan out..."
- "Create a roadmap for..."
- "Plan the implementation of..."

**Continuation requests**:
- "Continue with..."
- "What's next in..."
- "Resume work on..."

### Routing Behavior

When detected, AI agents:
1. Read `.roadmaps/how-to-roadmap.md` for guidance
2. Use templates from `.ai/templates/roadmap-*.md.template`
3. Follow the three-document structure
4. Update PROGRESS_TRACKER.md after each PR

## Benefits

### For AI Agents
- **Clear handoff documentation** via PROGRESS_TRACKER.md
- **Detailed implementation guidance** via PR_BREAKDOWN.md
- **Architectural context** via AI_CONTEXT.md
- **Systematic progress tracking** across sessions

### For Developers
- **Organized feature planning** with templates
- **Progress visibility** at a glance
- **Consistent structure** across roadmaps
- **Knowledge retention** in archived roadmaps

### For Teams
- **Coordination** across AI agent sessions
- **Transparency** in feature progress
- **Reusable patterns** from past roadmaps
- **Quality assurance** through structured planning

## Examples

### Example Roadmap Structure

```
.roadmaps/in-progress/user-authentication/
├── PROGRESS_TRACKER.md      # Current: PR3 - OAuth Integration
├── PR_BREAKDOWN.md          # 5 PRs total, detailed steps
└── AI_CONTEXT.md            # Security architecture, auth flow
```

### Example User Interaction

**User**: "I want to plan out a new user dashboard feature"

**AI Agent**:
1. Reads `.roadmaps/how-to-roadmap.md`
2. Creates `.roadmaps/planning/user-dashboard/`
3. Copies three templates
4. Asks questions to fill in placeholders
5. Creates comprehensive roadmap
6. Ready to move to in-progress when user confirms

## Best Practices

1. **Always start with PROGRESS_TRACKER.md** when continuing work
2. **Update PROGRESS_TRACKER.md immediately** after completing each PR
3. **Use AI_CONTEXT.md** for complex features with many integration points
4. **Keep roadmaps focused** - One feature per roadmap
5. **Archive completed roadmaps** for future reference
6. **Review past roadmaps** before creating similar features

## Integration with Other Plugins

The roadmap plugin works with:

1. **ai-folder plugin** (required) - Uses .ai/ directory structure
2. **Application plugins** - Provides planning for complex app features
3. **Standards plugins** - Roadmaps enforce standards via PR checklists
4. **Language plugins** - Roadmaps coordinate multi-language implementations

## Troubleshooting

### Roadmap directory exists but structure is wrong
Check `.roadmaps/how-to-roadmap.md` exists and subdirectories (planning, in-progress, complete) are present.

### Templates missing in .ai/templates/
Re-run plugin installation or manually copy templates from `plugins/foundation/roadmap/ai-content/templates/`.

### AGENTS.md not routing to roadmaps
Verify the roadmap section was added to AGENTS.md. Look for "Roadmap-Driven Development" section.

### Can't find active roadmaps
Check `.roadmaps/in-progress/` directory. If empty, no roadmaps are currently active.

## Version History

- v1.0 - Initial release with three-document structure and lifecycle management

## Contributing

To improve this plugin:
1. Follow the template structure
2. Update AGENT_INSTRUCTIONS.md for changes
3. Test standalone installation
4. Update this README
5. Ensure templates remain backward compatible

## License

Part of ai-projen framework - MIT License
