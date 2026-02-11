# How-To: Continue Initiative Work

**Purpose**: Guide AI agents through resuming work on an active initiative

**Scope**: Reading initiative state, routing to the appropriate active feature, updating initiative progress

**Overview**: Provides the workflow for continuing work on an active initiative. The key insight is that initiative work happens through features - this guide routes the agent to the right feature and ensures initiative-level tracking stays current.

**Dependencies**: Active initiative with INITIATIVE_TRACKER.md, active features under .roadmap/features/

**Exports**: Routed to correct feature with initiative context

**Related**: how-to-continue-feature-work.md, how-to-plan-an-initiative.md, how-to-update-progress.md

**Implementation**: Initiative-level routing to feature-level implementation

**Difficulty**: intermediate

**Estimated Time**: 5min (routing) + feature work time

---

## Prerequisites

- **Initiative directory**: Exists under `.roadmap/initiatives/active/<initiative-name>/`
- **INITIATIVE_TRACKER.md**: Exists with feature rollup
- **Feature directories**: Constituent features exist under `.roadmap/features/`

## Steps

### Step 1: Read Initiative State

Read these documents:
1. `.roadmap/initiatives/active/<initiative-name>/INITIATIVE_TRACKER.md`
2. `.roadmap/initiatives/active/<initiative-name>/FEATURE_BREAKDOWN.md`

### Step 2: Identify Next Feature

From INITIATIVE_TRACKER.md, find:
- Feature Progress Rollup table
- "Next Action" section
- Which feature to route to

Inform the user:
```
Initiative: <initiative-name>
Overall progress: X%
Active features: A/B
Next action: Work on <feature-name>
Rationale: <why this feature is next>
```

### Step 3: Route to Feature

Follow `.ai/howto/how-to-continue-feature-work.md` for the identified feature.

The feature's PROGRESS_TRACKER.md drives implementation from here.

### Step 4: Update Initiative After Feature Progress

After completing work on the feature:
1. Update the feature's PROGRESS_TRACKER.md (per feature workflow)
2. Return to INITIATIVE_TRACKER.md
3. Update the Feature Progress Rollup table
4. Recalculate overall initiative progress

### Step 5: Status Transitions

If a feature completes:
1. Move feature from `active/` to `completed/`
2. Update initiative's rollup table
3. Identify next feature to activate

If all features complete:
1. Move initiative from `active/` to `completed/`

## Success Criteria

- [ ] Correct feature identified for work
- [ ] User informed of initiative context and next action
- [ ] Routed to feature-level workflow
- [ ] Initiative tracker updated after feature progress
