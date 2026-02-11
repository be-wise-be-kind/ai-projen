# How-To: Convert Feature to Initiative

**Purpose**: Guide AI agents through promoting a feature to an initiative when scope grows

**Scope**: Converting a single feature into an initiative with multiple sub-features

**Overview**: When a feature grows beyond its original scope and needs to be broken into multiple sub-features, it should be promoted to an initiative. This guide walks through creating the initiative structure, decomposing the original feature into sub-features, and preserving existing progress.

**Dependencies**: Existing feature directory with planning documents

**Exports**: Initiative directory with feature inventory, original feature decomposed into sub-features

**Related**: how-to-plan-a-feature.md, how-to-plan-an-initiative.md

**Implementation**: Feature decomposition with progress preservation

**Difficulty**: intermediate

**Estimated Time**: 30min

---

## Prerequisites

- **Existing feature**: Feature directory exists under `.roadmap/features/<phase>/<feature-name>/`
- **Scope growth**: Feature has grown beyond what a single feature can reasonably cover
- **User agreement**: User agrees the feature should be promoted

## When to Convert

Consider converting when:
- A feature has more than 8-10 milestones
- Milestones are loosely related (different concerns)
- Multiple people or sessions could work on different parts independently
- The feature encompasses multiple deliverables

## Steps

### Step 1: Read Existing Feature

Read all documents in the feature directory:
- PROGRESS_TRACKER.md
- MILESTONE_BREAKDOWN.md
- AI_CONTEXT.md

Note any completed milestones and existing progress.

### Step 2: Create Initiative Directory

```bash
mkdir -p .roadmap/initiatives/<phase>/<initiative-name>/
```

Use the same phase (planning/active/completed) as the original feature.

### Step 3: Identify Sub-Features

Group the original feature's milestones into logical sub-features:
- Each sub-feature should be independently deliverable
- Preserve milestone ordering within sub-features
- Identify dependencies between sub-features

### Step 4: Create Initiative Documents

Create the three initiative documents using templates:
1. **INITIATIVE_TRACKER.md** - Rollup of sub-features
2. **FEATURE_BREAKDOWN.md** - Sub-feature inventory
3. **AI_CONTEXT.md** - Expand from original feature's AI_CONTEXT.md

### Step 5: Create Sub-Feature Directories

For each sub-feature:

```bash
mkdir -p .roadmap/features/<phase>/<sub-feature-name>/
```

Create PROGRESS_TRACKER.md, MILESTONE_BREAKDOWN.md, and AI_CONTEXT.md for each, distributing the original milestones appropriately.

### Step 6: Preserve Progress

For any completed milestones:
- Mark them as complete in the appropriate sub-feature's PROGRESS_TRACKER.md
- Preserve commit hashes and notes

### Step 7: Remove Original Feature

After all content has been migrated:

```bash
rm -rf .roadmap/features/<phase>/<original-feature-name>/
```

### Step 8: Validate

- [ ] Initiative directory exists with three documents
- [ ] Sub-feature directories exist with three documents each
- [ ] All original milestones accounted for in sub-features
- [ ] Completed milestone progress preserved
- [ ] Original feature directory removed
- [ ] Initiative tracker shows correct rollup

## Success Criteria

- [ ] Initiative created with correct structure
- [ ] Sub-features properly decomposed
- [ ] No milestones lost in conversion
- [ ] Progress preserved for completed work
- [ ] User informed of new structure
