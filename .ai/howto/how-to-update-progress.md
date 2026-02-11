# How-To: Update Progress

**Purpose**: Guide AI agents through updating progress on features and initiatives

**Scope**: Updating PROGRESS_TRACKER.md and INITIATIVE_TRACKER.md after completing work

**Overview**: Covers the standard process for recording progress after completing milestones, features, or initiative phases. Ensures consistent tracking across all roadmap items with commit hashes, status updates, and rollup calculations.

**Dependencies**: Active feature or initiative with tracking documents

**Exports**: Updated progress tracking documents

**Related**: how-to-continue-feature-work.md, how-to-continue-initiative-work.md

**Implementation**: Systematic progress recording with commit hash tracking

**Difficulty**: beginner

**Estimated Time**: 5min

---

## Prerequisites

- **Tracking document**: PROGRESS_TRACKER.md (feature) or INITIATIVE_TRACKER.md (initiative) exists
- **Completed work**: A milestone or feature has been completed

## Updating Feature Progress

### Step 1: Open PROGRESS_TRACKER.md

Navigate to `.roadmap/features/<phase>/<feature-name>/PROGRESS_TRACKER.md`

### Step 2: Update Milestone Status

In the Milestone Dashboard table:
1. Change the milestone's Status to Complete
2. Add commit hash to Notes: `git log --oneline -1`
3. Format: "Description (commit abc1234)"

### Step 3: Update Next Milestone

Update the "Next Milestone" section:
- Point to the next incomplete milestone
- Update pre-flight checklist
- If all milestones complete, note "Feature Complete"

### Step 4: Update Progress Percentage

Calculate: (completed milestones / total milestones) * 100

Update the progress bar and percentage.

### Step 5: Commit Progress Update

```bash
git add .roadmap/features/<phase>/<feature-name>/PROGRESS_TRACKER.md
git commit -m "docs: Update progress for <feature-name> milestone <N>"
```

## Updating Initiative Progress

### Step 1: Open INITIATIVE_TRACKER.md

Navigate to `.roadmap/initiatives/<phase>/<initiative-name>/INITIATIVE_TRACKER.md`

### Step 2: Update Feature Rollup

In the Feature Progress Rollup table:
1. Update the feature's Progress percentage
2. Update the feature's Status
3. If feature completed, update Phase to "completed"

### Step 3: Recalculate Overall Progress

Average the progress of all constituent features.

### Step 4: Update Next Action

If the active feature completed, route to the next feature.

### Step 5: Commit Progress Update

```bash
git add .roadmap/initiatives/<phase>/<initiative-name>/INITIATIVE_TRACKER.md
git commit -m "docs: Update initiative progress for <initiative-name>"
```

## Moving Between Phases

### Feature: planning -> active
```bash
mv .roadmap/features/planning/<feature-name> .roadmap/features/active/<feature-name>
```
Update PROGRESS_TRACKER.md Phase field to "active".

### Feature: active -> completed
```bash
mv .roadmap/features/active/<feature-name> .roadmap/features/completed/<feature-name>
```
Update PROGRESS_TRACKER.md Phase field to "completed".

### Initiative: Same pattern
```bash
mv .roadmap/initiatives/planning/<name> .roadmap/initiatives/active/<name>
mv .roadmap/initiatives/active/<name> .roadmap/initiatives/completed/<name>
```

## Success Criteria

- [ ] Progress tracking document updated with current status
- [ ] Commit hash recorded for completed work
- [ ] Next action/milestone correctly identified
- [ ] Progress percentage accurately calculated
