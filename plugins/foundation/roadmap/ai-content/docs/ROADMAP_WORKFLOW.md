# Roadmap Workflow Documentation

**Purpose**: Comprehensive documentation of the roadmap-driven development workflow

**Scope**: Feature and initiative lifecycle, document structure, AI agent coordination

**Overview**: Technical documentation for the two-tier roadmap system used in AI-ready repositories.
    Describes the feature and initiative document structures, lifecycle management
    (planning -> active -> completed), AI agent handoff protocols, and workflow patterns.

**Dependencies**: foundation/ai-folder plugin, roadmap plugin

**Exports**: Workflow patterns, coordination protocols, lifecycle management guidelines

**Related**: howto guides for planning and continuing work, roadmap templates, AGENTS.md

**Implementation**: Lifecycle-based workflow with structured handoff documentation

---

## Overview

The roadmap workflow provides a two-tier system for planning and tracking work:

1. **Features** - Individual deliverables with milestones
2. **Initiatives** - Strategic groupings of related features

Both tiers share the same lifecycle: `planning/` -> `active/` -> `completed/`

## Feature Structure

Each feature uses three documents:

### 1. PROGRESS_TRACKER.md (Required)
**Role**: Primary AI agent handoff document

Contains:
- Current status and next milestone
- Overall progress dashboard
- Milestone status table
- Update protocol

This is the FIRST document AI agents read when continuing work.

### 2. MILESTONE_BREAKDOWN.md (Required for multi-milestone features)
**Role**: Detailed implementation guide

Contains:
- Milestone breakdown with implementation steps
- Success criteria for each milestone
- Dependencies between milestones

### 3. AI_CONTEXT.md (Optional)
**Role**: Feature architecture context

Contains:
- Feature vision and rationale
- Target architecture
- Key decisions
- AI agent guidance

## Initiative Structure

Each initiative uses three documents:

### 1. INITIATIVE_TRACKER.md (Required)
**Role**: Rollup tracking across features

Contains:
- Feature progress rollup table
- Next action routing (to active feature)
- Strategic goals
- Update protocol

### 2. FEATURE_BREAKDOWN.md (Required)
**Role**: Feature inventory and dependencies

Contains:
- Feature inventory table
- Dependency graph
- Ordering recommendations

### 3. AI_CONTEXT.md (Optional)
**Role**: Strategic context

Contains:
- Strategic vision
- Cross-feature patterns
- Architectural decisions

## Lifecycle

### Planning Phase
**Location**: `.roadmap/features/planning/` or `.roadmap/initiatives/planning/`

Activities:
1. Create directory with three documents
2. Fill in templates with specifics
3. Break work into milestones (features) or features (initiatives)
4. Define success criteria
5. Review and refine plan

### Active Phase
**Location**: `.roadmap/features/active/` or `.roadmap/initiatives/active/`

Activities:
1. Read PROGRESS_TRACKER.md to identify next action
2. Implement milestone/feature
3. Update tracking documents
4. Continue until complete

### Completed Phase
**Location**: `.roadmap/features/completed/` or `.roadmap/initiatives/completed/`

Purpose:
- Archive for reference
- Extract learnings
- Inform future planning

## AI Agent Coordination

### Feature Work Flow

```
1. Read PROGRESS_TRACKER.md
2. Identify next milestone
3. Read MILESTONE_BREAKDOWN.md for that milestone
4. Create feature branch
5. Implement milestone
6. Update PROGRESS_TRACKER.md
7. Commit changes
```

### Initiative Work Flow

```
1. Read INITIATIVE_TRACKER.md
2. Identify next feature to work on
3. Route to feature's PROGRESS_TRACKER.md
4. Follow feature work flow
5. Update INITIATIVE_TRACKER.md after progress
```

### Detection Patterns

AI agents detect roadmap requests through:

**Feature planning**: "plan feature", "roadmap", "break down"
**Initiative planning**: "plan initiative", "strategic plan", "group features"
**Continuation**: "continue", "resume", "next milestone"
**Progress updates**: "update progress", "mark complete"

## Templates

### Feature Templates
- `feature-progress-tracker.md.template` - Primary handoff document
- `feature-milestone-breakdown.md.template` - Milestone implementation details
- `feature-ai-context.md.template` - Feature architecture context

### Initiative Templates
- `initiative-tracker.md.template` - Rollup tracking
- `initiative-feature-breakdown.md.template` - Feature inventory
- `initiative-ai-context.md.template` - Strategic context

## Best Practices

### Planning
- Break features into atomic milestones (each independently testable)
- Define clear success criteria for each milestone
- Use AI_CONTEXT.md for complex features with architecture decisions
- Map dependencies explicitly

### Implementation
- Read PROGRESS_TRACKER.md before every work session
- Update tracking documents immediately after completing milestones
- Document deviations and reasons
- Test thoroughly per success criteria

### Completion
- Move directories to completed/ when all work is done
- Preserve documents for future reference
- Extract reusable patterns

## Integration

### With AGENTS.md
Roadmap plugin adds "Roadmap-Driven Development" section with detection patterns and routing.

### With .ai/index.yaml
Roadmap resources registered under the `roadmap:` section.

### With Templates
Feature and initiative templates in `.ai/templates/` enable consistent planning.
