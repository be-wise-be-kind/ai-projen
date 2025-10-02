# Plugin Discovery & Orchestration

**Purpose**: How orchestrators discover, select, and install plugins

**Scope**: Discovery logic, user interaction flow, roadmap generation, and installation orchestration

**Overview**: Defines how the CREATE/UPGRADE/ADD orchestrators work - how they read the manifest,
    ask discovery questions, generate custom roadmaps, and execute plugin installations. Essential for
    understanding the user experience and how to add new orchestration capabilities.

**Dependencies**: PLUGIN_MANIFEST.yaml, plugin AGENT_INSTRUCTIONS.md files

**Exports**: Orchestration patterns, discovery flows, roadmap generation logic

**Related**: PLUGIN_ARCHITECTURE.md for plugin structure, PROJECT_CONTEXT.md for philosophy

**Implementation**: Manifest-driven discovery with interactive question flow and roadmap generation

---

## Overview

Orchestrators guide users through setting up repositories by:
1. Reading `PLUGIN_MANIFEST.yaml`
2. Asking discovery questions
3. Generating custom roadmap
4. Executing plugin installations sequentially

## The Three Orchestrators

### CREATE-NEW-AI-REPO.md
**Purpose**: Create new repository from empty directory

**Flow**:
```
Welcome → Install Foundation → Discovery Questions → Generate Roadmap → Execute PRs
```

**Use Case**: Starting a new project from scratch

### UPGRADE-TO-AI-REPO.md
**Purpose**: Add AI patterns to existing repository

**Flow**:
```
Analyze Existing → Identify Gaps → Recommend Plugins → Generate Roadmap → Execute PRs
```

**Use Case**: Modernizing an existing project

### ADD-CAPABILITY.md
**Purpose**: Add single capability incrementally

**Flow**:
```
List Plugins → User Selects → Check Dependencies → Install Plugin
```

**Use Case**: Adding one feature (e.g., "add Docker support")

## Discovery Flow (CREATE)

### Phase 1: Foundation (Automatic)
```markdown
Agent: "Installing universal foundation..."
→ Execute: plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md
Agent: "✅ .ai folder created"
```

**No questions**. Foundation is always required.

### Phase 2: Language Discovery
```markdown
Agent: "What programming language(s) will you use?"
Options:
  - Python
  - TypeScript
  - Go (coming soon)
  - Rust (coming soon)
  - Other (please specify)

User: "Python and TypeScript"

Agent: "Great! I found stable plugins for both."
```

#### Python Configuration
```markdown
Agent: "I can set up Python with these linters:"
  - Ruff (recommended - fast, comprehensive)
  - Pylint (traditional, thorough)
  - Flake8 (classic, extensible)

Which would you prefer? [Default: Ruff]

User: [Ruff]

Agent: "✅ Python with Ruff selected"
```

#### TypeScript Configuration
```markdown
Agent: "I can set up TypeScript with these linters:"
  - ESLint (recommended - industry standard)
  - Biome (new, very fast)

Which would you prefer? [Default: ESLint]

User: [ESLint]

Agent: "Will this be a React project?"
User: "Yes"
Agent: "✅ TypeScript with ESLint + React patterns selected"
```

### Phase 3: Infrastructure Discovery
```markdown
Agent: "Do you need containerization? [Yes/No]"
User: "Yes"

Agent: "Which containerization tool?"
  - Docker (recommended)
  - Podman (coming soon)

User: [Docker]
Agent: "✅ Docker selected"
```

```markdown
Agent: "Do you need CI/CD? [Yes/No]"
User: "Yes"

Agent: "Which CI/CD platform?"
  - GitHub Actions (recommended for GitHub repos)
  - GitLab CI (coming soon)
  - Other

User: [GitHub Actions]
Agent: "✅ GitHub Actions selected"
```

```markdown
Agent: "Do you need Infrastructure as Code? [Yes/No]"
User: "Yes"

Agent: "Which IaC tool?"
  - Terraform (recommended - mature, multi-cloud)
  - Pulumi (coming soon)
  - CDK (coming soon)

User: [Terraform]

Agent: "Which cloud provider?"
  - AWS (recommended - most plugins available)
  - GCP (coming soon)
  - Azure (coming soon)

User: [AWS]
Agent: "✅ Terraform/AWS selected"
```

### Phase 4: Standards Selection
```markdown
Agent: "I recommend applying these universal standards:"
  - ✅ Security (secrets management, scanning)
  - ✅ Documentation (file headers, README standards)
  - ✅ Pre-commit Hooks (quality gates)

Apply all? [Yes/No] [Default: Yes]

User: [Yes]
Agent: "✅ All standards selected"
```

### Phase 5: Roadmap Generation
```markdown
Agent: "Based on your selections, I'll create this roadmap:"

PR1: Foundation - AI Folder Structure
PR2: Python Setup (Ruff linter, Black formatter, pytest)
PR3: TypeScript Setup (ESLint + React, Prettier, Vitest)
PR4: Docker Containerization (frontend + backend)
PR5: GitHub Actions CI/CD (lint, test, build, deploy)
PR6: Terraform/AWS Infrastructure (VPC, ECS, ALB)
PR7: Security Standards (secrets, scanning)
PR8: Documentation Standards (headers, README)
PR9: Pre-commit Hooks (integrating all tools)
PR10: Integration & Validation

Ready to proceed? [Yes/Review/Customize]

User: [Yes]
Agent: "Creating roadmap documents..."
```

### Phase 6: Execution
```markdown
Agent: "Executing PR1: Foundation..."
→ Read: plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md
→ Execute: Installation steps
→ Validate: Success criteria
→ Update: roadmap/ai_setup/PROGRESS_TRACKER.md

Agent: "✅ PR1 complete. Moving to PR2..."
```

## Roadmap Generation

### Structure Created
```
target-repo/
└── roadmap/
    └── ai_setup/
        ├── PROGRESS_TRACKER.md
        ├── AI_CONTEXT.md
        └── PR_BREAKDOWN.md
```

### PROGRESS_TRACKER.md
Generated with:
- Overall progress (0% initially)
- PR dashboard (all PRs listed)
- Next PR to implement
- Success criteria
- Resources and notes

### AI_CONTEXT.md
Generated with:
- Project purpose
- Technology stack selected
- Plugin choices made
- Architecture overview
- Success metrics

### PR_BREAKDOWN.md
Generated with:
- Detailed PR descriptions
- Implementation steps per PR
- Success criteria per PR
- Dependencies between PRs

## Manifest Reading

### Loading Manifest
```markdown
Agent reads: plugins/PLUGIN_MANIFEST.yaml

Extracts:
- Available languages and their options
- Available infrastructure plugins
- Available standards plugins
- Status of each plugin (stable/planned)
- Recommended defaults
```

### Using Manifest for Questions
```yaml
# From manifest:
languages:
  python:
    linters: [ruff, pylint, flake8]
    recommended_linter: ruff

# Generates question:
"I can set up Python with these linters: Ruff (recommended), Pylint, Flake8"
```

### Handling Missing Plugins
```markdown
User: "I need Go support"

Agent checks manifest:
languages:
  go:
    status: planned

Agent: "Go support is planned but not yet available. Would you like to:"
  1. Use a similar plugin (Python/TypeScript)
  2. Create the Go plugin yourself (see how-to-create-a-plugin.md)
  3. Skip for now and add later
```

## Dependency Resolution

### Declaration
Plugins declare dependencies in AGENT_INSTRUCTIONS.md:
```markdown
## Dependencies
- Required: plugins/foundation/ai-folder
- Optional: plugins/infrastructure/ci-cd/github-actions
```

### Resolution Logic
```markdown
Agent builds dependency graph:

PR1: foundation/ai-folder (no dependencies)
PR2: languages/python (depends on: foundation/ai-folder)
PR3: languages/typescript (depends on: foundation/ai-folder)
PR4: infrastructure/docker (depends on: languages/*)
PR5: infrastructure/ci-cd (depends on: languages/*)
PR6: standards/pre-commit (depends on: languages/*, standards/*)

Execution order: PR1 → PR2 → PR3 → PR4 → PR5 → PR6
```

## Resume Capability

### State Tracking
```markdown
After each PR completion:
- Update PROGRESS_TRACKER.md
- Mark PR as complete
- Update progress percentage
- Note any issues or blockers
```

### Resume Flow
```markdown
User returns after interruption

Agent: "I see you've completed PR1-PR5. Next up is PR6: Terraform/AWS."
Agent: "The roadmap shows 50% complete. Ready to continue?"

User: "Yes"

Agent reads:
- roadmap/ai_setup/PROGRESS_TRACKER.md (what's done)
- roadmap/ai_setup/PR_BREAKDOWN.md (what's next)

Agent: "Executing PR6..."
```

### Modification Support
```markdown
User can edit PR_BREAKDOWN.md to:
- Skip PRs (mark as cancelled)
- Reorder PRs (change sequence)
- Add custom PRs (insert new steps)
- Change configurations (update plugin choices)

Agent adapts to modifications when resuming
```

## Upgrade Flow (UPGRADE)

### Analysis Phase
```markdown
Agent: "Analyzing your existing repository..."

Checks:
- Languages detected (scans for .py, .ts, .js, etc.)
- Existing infrastructure (.docker/, .github/workflows/)
- Current tooling (.eslintrc, .ruff.toml, etc.)
- Missing components (.ai/, pre-commit, etc.)
```

### Gap Detection
```markdown
Agent: "I found:"
  ✅ Python code (using Pylint currently)
  ✅ Docker setup (basic, could be improved)
  ❌ No .ai folder
  ❌ No TypeScript linting
  ❌ No pre-commit hooks
  ❌ No CI/CD automation

Agent: "I recommend adding:"
  1. Foundation (.ai folder)
  2. Upgrade Python tooling (Pylint → Ruff)
  3. Add TypeScript linting
  4. Add pre-commit hooks
  5. Add GitHub Actions CI/CD

Proceed? [Yes/Customize]
```

### Safe Installation
```markdown
Agent: "I'll install incrementally to avoid breaking existing setup:"

PR1: Add .ai folder (no conflicts)
PR2: Add Ruff alongside Pylint (you can migrate gradually)
PR3: Add TypeScript linting (new, no conflicts)
PR4: Add pre-commit hooks (optional enforcement)
PR5: Add GitHub Actions (no changes to Docker)

Each PR is independent and revertible.
```

## Add Capability Flow (ADD)

### Simple Selection
```markdown
User: "Add Python linting"

Agent: "I can install the Python language plugin with these options:"
  - Ruff (recommended)
  - Pylint
  - Flake8

Which linter? [Ruff]

Agent checks dependencies:
  ✅ foundation/ai-folder already present
  ✅ No conflicts detected

Agent: "Installing Python plugin with Ruff..."
→ Execute: plugins/languages/python/AGENT_INSTRUCTIONS.md
→ Configure: Ruff
→ Add: Make targets, pre-commit hooks (if present)
→ Validate: make lint-python works

Agent: "✅ Python linting with Ruff installed. Run: make lint-python"
```

## Error Handling

### Missing Prerequisites
```markdown
Plugin requires: Docker installed

Agent: "This plugin requires Docker. I don't detect Docker on your system."
Options:
  1. Install Docker first (see: https://docs.docker.com/install)
  2. Skip this plugin
  3. Continue anyway (may fail later)
```

### Conflicts
```markdown
Plugin: terraform/aws
Conflict: terraform/gcp (already installed)

Agent: "This plugin conflicts with terraform/gcp (different cloud provider)"
Options:
  1. Keep existing terraform/gcp
  2. Replace with terraform/aws
  3. Install both (manual configuration required)
```

### Failures
```markdown
Installation fails during PR3

Agent: "❌ PR3 failed: ESLint installation error"
Agent: "Would you like to:"
  1. Retry PR3
  2. Skip PR3 and continue
  3. Debug (show error details)
  4. Stop and review
```

## Best Practices

### For Orchestrator Design
1. **Ask minimum questions** - Use smart defaults
2. **Show progress** - Update user frequently
3. **Enable resume** - Always track state
4. **Validate early** - Check prerequisites upfront
5. **Provide options** - Don't force one path

### For Discovery Flow
1. **Start simple** - Foundation first, details later
2. **Group related** - Ask language questions together
3. **Recommend** - Highlight best choices
4. **Explain** - Why you're asking each question
5. **Allow customization** - Don't lock users in

### For Roadmap Generation
1. **Be specific** - Clear PR titles and descriptions
2. **Show dependencies** - Explain order
3. **Enable modification** - Let users adjust
4. **Track thoroughly** - Every step documented
5. **Validate completely** - Clear success criteria

---

**Remember**: Orchestrators should feel like a helpful guide, not a rigid script. Adapt to user needs, provide options, and always enable resume.
