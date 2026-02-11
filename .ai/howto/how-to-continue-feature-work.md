# How-To: Continue Feature Work

**Purpose**: Guide AI agents through resuming work on an active feature

**Scope**: Picking up where a previous session left off; status transitions, branch creation, milestone implementation

**Overview**: Provides the workflow for continuing implementation of an active feature. Covers reading the current state from PROGRESS_TRACKER.md, identifying the next milestone, creating a branch, implementing changes, and updating progress.

**Dependencies**: Active feature with PROGRESS_TRACKER.md

**Exports**: Completed milestone with updated progress tracking

**Related**: how-to-plan-a-feature.md, how-to-update-progress.md

**Implementation**: Progress-driven continuation with systematic milestone implementation

**Difficulty**: intermediate

**Estimated Time**: varies by milestone

---

## Prerequisites

- **Feature directory**: Exists under `.roadmap/features/active/<feature-name>/`
- **PROGRESS_TRACKER.md**: Exists with milestone dashboard
- **MILESTONE_BREAKDOWN.md**: Exists with implementation details

## Steps

### Step 1: Read Feature State

Read these documents in order:
1. `.roadmap/features/active/<feature-name>/PROGRESS_TRACKER.md`
2. `.roadmap/features/active/<feature-name>/MILESTONE_BREAKDOWN.md`
3. `.roadmap/features/active/<feature-name>/AI_CONTEXT.md` (if exists)

### Step 2: Identify Next Milestone

From PROGRESS_TRACKER.md, find:
- The "Next Milestone" section
- Any blocked milestones
- Overall progress status

Inform the user:
```
Feature: <feature-name>
Current progress: X/Y milestones complete
Next milestone: <milestone-title>
Summary: <what this milestone accomplishes>
```

### Step 3: Create Feature Branch

```bash
git checkout -b feature/<feature-name>-milestone-<N>
```

### Step 4: Implement Milestone

Follow the milestone's implementation steps from MILESTONE_BREAKDOWN.md:
1. Read the milestone's detailed steps
2. Implement changes
3. Validate against success criteria
4. Run any specified tests or validations

### Step 5: Update Progress

After completing the milestone:
1. Update PROGRESS_TRACKER.md:
   - Mark milestone as Complete
   - Add commit hash to Notes
   - Update "Next Milestone" section
   - Update overall progress percentage
2. Commit the progress update

### Step 6: Status Transitions

If all milestones are complete:
1. Move feature directory from `active/` to `completed/`
2. If feature belongs to an initiative, update the initiative's INITIATIVE_TRACKER.md

If feature is still in `planning/` and work is beginning:
1. Move feature directory from `planning/` to `active/`

## Success Criteria

- [ ] Next milestone identified and communicated to user
- [ ] Milestone implemented per MILESTONE_BREAKDOWN.md
- [ ] PROGRESS_TRACKER.md updated with completion status
- [ ] Feature branch created for changes
