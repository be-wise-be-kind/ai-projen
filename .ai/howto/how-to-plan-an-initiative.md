# How-To: Plan an Initiative

**Purpose**: Guide AI agents through planning a strategic initiative that groups multiple features

**Scope**: Initiative planning from strategy through feature identification; does not cover feature-level planning

**Overview**: Walks through the process of planning an initiative - a strategic grouping of related features. Creates an initiative directory with INITIATIVE_TRACKER.md, FEATURE_BREAKDOWN.md, and AI_CONTEXT.md. Then helps create individual feature directories for each constituent feature.

**Dependencies**: .ai/ directory with templates, .roadmap/ directory structure

**Exports**: Complete initiative directory with three documents plus stub feature directories

**Related**: how-to-plan-a-feature.md, how-to-continue-initiative-work.md

**Implementation**: Template-based planning with strategic decomposition

**Difficulty**: advanced

**Estimated Time**: 1hr

---

## Prerequisites

- **Repository**: Has .ai/ directory with templates
- **Roadmap directory**: `.roadmap/initiatives/` and `.roadmap/features/` exist
- **Templates**: Initiative and feature templates exist in `.ai/templates/`

## Steps

### Step 1: Gather Initiative Information

Ask the user:

1. **Initiative Name**: What is this initiative called? (use kebab-case)
2. **Strategic Vision**: What is the high-level goal?
3. **Constituent Features**: What features make up this initiative?
4. **Dependencies**: What external dependencies exist?
5. **Success Criteria**: How do you know the initiative is done?

### Step 2: Create Initiative Directory

```bash
mkdir -p .roadmap/initiatives/planning/<initiative-name>/
```

### Step 3: Create AI_CONTEXT.md

Copy `.ai/templates/initiative-ai-context.md.template` to the initiative directory.

Fill in:
- Strategic vision
- Initiative rationale
- Cross-feature patterns
- Architectural decisions

### Step 4: Identify and Catalog Features

Work with user to decompose the initiative into features:
- Each feature should be independently deliverable
- Identify dependencies between features
- Determine priority ordering
- Estimate relative complexity

### Step 5: Create FEATURE_BREAKDOWN.md

Copy `.ai/templates/initiative-feature-breakdown.md.template` to the initiative directory.

Fill in:
- Feature inventory table
- Dependency graph
- Feature details
- Ordering recommendations

### Step 6: Create INITIATIVE_TRACKER.md

Copy `.ai/templates/initiative-tracker.md.template` to the initiative directory.

Fill in:
- Feature progress rollup table
- Strategic goals
- Next action routing
- Definition of done

### Step 7: Create Feature Stubs

For each feature identified in Step 4, create a planning directory:

```bash
mkdir -p .roadmap/features/planning/<feature-name>/
```

Optionally, run `how-to-plan-a-feature.md` for each feature to create full planning documents. At minimum, create a stub AI_CONTEXT.md referencing the parent initiative.

### Step 8: Validate

- [ ] Initiative directory exists at `.roadmap/initiatives/planning/<initiative-name>/`
- [ ] INITIATIVE_TRACKER.md exists with feature rollup
- [ ] FEATURE_BREAKDOWN.md exists with feature inventory
- [ ] AI_CONTEXT.md exists with strategic context
- [ ] Feature stub directories created under `.roadmap/features/planning/`
- [ ] All placeholders replaced

### Step 9: Inform User

Present the initiative plan:
- Features identified and their ordering
- Dependencies between features
- Recommended starting feature
- Ask if they want to begin planning individual features

## Next Steps

1. Plan individual features using `.ai/howto/how-to-plan-a-feature.md`
2. When ready to implement, move initiative to `active/`
3. Begin with the highest-priority feature

## Success Criteria

- [ ] Initiative documents created with strategic content
- [ ] Features identified and cataloged
- [ ] Feature stub directories created
- [ ] User has reviewed and approved the plan
