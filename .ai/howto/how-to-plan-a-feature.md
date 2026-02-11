# How-To: Plan a Feature

**Purpose**: Guide AI agents through planning a new feature with the three-document roadmap structure

**Scope**: Feature planning from discovery through document creation; does not cover implementation

**Overview**: Walks through the process of planning a new feature using the feature roadmap pattern. Creates a feature directory with PROGRESS_TRACKER.md, MILESTONE_BREAKDOWN.md, and AI_CONTEXT.md. Helps agents ask the right discovery questions and break work into milestones.

**Dependencies**: .ai/ directory with templates, .roadmap/features/ directory

**Exports**: Complete feature planning directory with three documents ready for implementation

**Related**: how-to-continue-feature-work.md, how-to-plan-an-initiative.md, how-to-convert-feature-to-initiative.md

**Implementation**: Template-based planning with guided discovery questions

**Difficulty**: intermediate

**Estimated Time**: 30min

---

## Prerequisites

- **Repository**: Has .ai/ directory with templates
- **Roadmap directory**: `.roadmap/features/` exists with planning/, active/, completed/
- **Templates**: Feature templates exist in `.ai/templates/`

## Steps

### Step 1: Gather Feature Information

Ask the user (or infer from context):

1. **Feature Name**: What is this feature called? (use kebab-case for directory name)
2. **Feature Scope**: What does this feature accomplish?
3. **Feature Vision**: What is the desired end state?
4. **Dependencies**: What does this feature depend on?
5. **Success Criteria**: How do you know the feature is done?

### Step 2: Create Feature Directory

```bash
mkdir -p .roadmap/features/planning/<feature-name>/
```

### Step 3: Create AI_CONTEXT.md

Copy `.ai/templates/feature-ai-context.md.template` to `.roadmap/features/planning/<feature-name>/AI_CONTEXT.md`.

Replace all `{{PLACEHOLDERS}}` with actual values from Step 1.

This document captures:
- Feature vision and rationale
- Target architecture
- Key decisions
- Technical constraints
- AI agent guidance

### Step 4: Break Into Milestones

Work with the user to identify milestones:
- Each milestone should be self-contained and testable
- Milestones should build incrementally toward the feature
- Each milestone should be completable in a single session
- Consider dependencies between milestones

### Step 5: Create MILESTONE_BREAKDOWN.md

Copy `.ai/templates/feature-milestone-breakdown.md.template` to `.roadmap/features/planning/<feature-name>/MILESTONE_BREAKDOWN.md`.

Fill in milestone details:
- Implementation steps for each milestone
- File changes expected
- Testing requirements
- Success criteria

### Step 6: Create PROGRESS_TRACKER.md

Copy `.ai/templates/feature-progress-tracker.md.template` to `.roadmap/features/planning/<feature-name>/PROGRESS_TRACKER.md`.

Fill in:
- Milestone dashboard with all milestones from Step 4
- Next milestone section pointing to Milestone 1
- Definition of done from Step 1

### Step 7: Validate

- [ ] Feature directory exists at `.roadmap/features/planning/<feature-name>/`
- [ ] AI_CONTEXT.md exists with feature-specific content
- [ ] MILESTONE_BREAKDOWN.md exists with milestone details
- [ ] PROGRESS_TRACKER.md exists with milestone dashboard
- [ ] All placeholders replaced with actual values

### Step 8: Inform User

Present the feature plan to the user:
- Summary of milestones identified
- Estimated scope
- Recommended starting point
- Ask if they want to begin implementation (which would move to active/)

## Next Steps

When ready to implement:
1. Move feature directory from `planning/` to `active/`
2. Follow `.ai/howto/how-to-continue-feature-work.md`
3. Create feature branch for first milestone

## Success Criteria

- [ ] Three documents created with feature-specific content
- [ ] Milestones are well-defined and sequenced
- [ ] User has reviewed and approved the plan
