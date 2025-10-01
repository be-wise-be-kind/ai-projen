# AI-Projen Implementation - AI Context

**Purpose**: AI agent context document for implementing AI-Projen framework

**Scope**: Complete plugin-based framework for creating AI-ready repositories with production-ready full-stack support

**Overview**: Comprehensive context document for AI agents working on the AI-Projen Implementation feature.
    Provides architectural vision, design decisions, integration patterns, and implementation guidance for building
    a modular, extensible framework that transforms empty directories into production-ready, AI-assisted development
    environments. Focuses on plugin architecture, orchestrated discovery, and composable components extracted from
    proven patterns in durable-code-test-2.

**Dependencies**: [durable-code-test](https://github.com/steve-e-jackson/durable-code-test) repository (source patterns), Git, GitHub, three test repositories

**Exports**: Plugin architecture, orchestration system, reference implementations, extensibility framework

**Related**: PR_BREAKDOWN.md for implementation tasks, PROGRESS_TRACKER.md for current status

**Implementation**: Plugin-based architecture with smart orchestration, manifest-driven discovery, and standalone component installation

---

## Overview

**AI-Projen** is a framework for creating AI-ready repositories through composable, standalone plugins. It extracts proven patterns from durable-code-test-2 and makes them reusable, extensible, and accessible to any project.

### The Problem We're Solving

Creating an AI-ready repository requires:
1. ✅ Structured .ai folder with proper documentation
2. ✅ Language-specific linting, formatting, and testing
3. ✅ Docker containerization for consistent environments
4. ✅ CI/CD pipelines for automation
5. ✅ Infrastructure as Code for cloud deployment
6. ✅ Security and documentation standards
7. ✅ Pre-commit hooks for quality gates

Setting all this up from scratch takes days/weeks and requires deep expertise. **AI-Projen makes it take minutes**.

### The Solution

A **plugin-based framework** where:
- **Foundation plugin** (ai-folder) is universal - every project needs it
- **Language plugins** provide language-specific tooling (Python, TypeScript, etc.)
- **Infrastructure plugins** provide deployment capabilities (Docker, CI/CD, Terraform)
- **Standards plugins** enforce quality (Security, Documentation, Pre-commit hooks)
- **Orchestrators** (CREATE/UPGRADE/ADD) guide users through discovery and installation
- **Everything is standalone** - plugins work independently or composed together

## Project Background

### Origin
AI-Projen emerged from building **durable-code-test**, a full-stack application demonstrating AI-ready development patterns. After proving these patterns work in production, we want to make them reusable for future projects.

### Key Insight
**We're not building a library of every possible plugin.** We're building the **engine** that makes plugins easy to create and compose. Ship with excellent Python/TypeScript/Docker/AWS examples, document how to extend, and let the framework grow organically.

### Scope Decision
**V1.0 Includes**:
- ✅ Python + TypeScript (full-stack ready)
- ✅ Docker (frontend + backend)
- ✅ GitHub Actions (CI/CD)
- ✅ Terraform/AWS (cloud deployment)
- ✅ Pre-commit hooks (quality gates)
- ✅ Security + Documentation standards

**Future (community-driven)**:
- 🎯 Additional languages (Go, Rust, Java)
- 🎯 Additional clouds (GCP, Azure)
- 🎯 Additional IaC (Pulumi, CDK)
- 🎯 Organizational standards

## Feature Vision

1. **Framework Over Library**: Build the engine, not every possible plugin
2. **Standalone First**: Every plugin works independently
3. **Composable**: Plugins combine without conflicts
4. **Extensible**: Clear path to add new plugins (<2 hours with docs)
5. **Production-Ready**: Reference implementations are battle-tested
6. **Agent-Friendly**: Designed for AI agent consumption (AGENT_INSTRUCTIONS.md)

## Current Application Context

### Source Repository: durable-code-test
Repository: [steve-e-jackson/durable-code-test](https://github.com/steve-e-jackson/durable-code-test)

**What We're Extracting**:
- [.ai/](https://github.com/steve-e-jackson/durable-code-test/tree/main/.ai) folder structure and templates
- [Makefile](https://github.com/steve-e-jackson/durable-code-test/blob/main/Makefile) patterns for language operations
- [.docker/](https://github.com/steve-e-jackson/durable-code-test/tree/main/.docker) containerization setup
- [.github/workflows/](https://github.com/steve-e-jackson/durable-code-test/tree/main/.github/workflows) CI/CD pipelines
- [infra/terraform/](https://github.com/steve-e-jackson/durable-code-test/tree/main/infra/terraform) workspace patterns
- [.pre-commit-config.yaml](https://github.com/steve-e-jackson/durable-code-test/blob/main/.pre-commit-config.yaml) hook configurations
- Standards documents ([security](https://github.com/steve-e-jackson/durable-code-test/tree/main/.ai/docs), documentation, error handling)
- Design linter framework (custom quality rules)

### Target Repository: ai-projen
Repository: [steve-e-jackson/ai-projen](https://github.com/steve-e-jackson/ai-projen)

**What We're Building**:
- `plugins/` directory with all plugin categories
- `CREATE-NEW-AI-REPO.md` orchestrator
- `UPGRADE-TO-AI-REPO.md` orchestrator
- `ADD-CAPABILITY.md` orchestrator
- `.ai/` self-referential folder (dogfooding)
- `roadmap/` tracking this implementation

## Target Architecture

### Core Components

#### 1. Plugin System
```
plugins/
├── foundation/              # Universal (always required)
│   └── ai-folder/
├── languages/               # Language-specific tooling
│   ├── python/
│   ├── typescript/
│   └── _template/
├── infrastructure/          # Deployment & tooling
│   ├── containerization/
│   │   ├── docker/
│   │   └── _template/
│   ├── ci-cd/
│   │   ├── github-actions/
│   │   └── _template/
│   └── iac/
│       ├── terraform/
│       │   └── providers/
│       │       ├── aws/
│       │       └── _template/
│       └── _template/
└── standards/               # Quality & standards
    ├── security/
    ├── documentation/
    ├── pre-commit-hooks/
    └── _template/
```

#### 2. Plugin Structure (Standard)
Every plugin contains:
- `AGENT_INSTRUCTIONS.md` - How an AI agent installs this plugin
- `templates/` - File templates this plugin provides
- `configs/` - Configuration files this plugin provides
- `README.md` - Human-readable description

#### 3. Plugin Manifest
`plugins/PLUGIN_MANIFEST.yaml` declares:
- Available plugins
- Plugin status (stable/planned/community-requested)
- Plugin options (e.g., Python supports Ruff/Pylint/Flake8)
- Recommended defaults
- Dependencies between plugins

#### 4. Orchestrators
Three entry points for different use cases:
- `CREATE-NEW-AI-REPO.md` - New repository from scratch
- `UPGRADE-TO-AI-REPO.md` - Add AI patterns to existing repo
- `ADD-CAPABILITY.md` - Add single plugin to existing repo

### User Journey

#### Journey 1: Creating New Full-Stack App
```
User → Point agent to CREATE-NEW-AI-REPO.md
Agent → Asks discovery questions:
  - Languages? [Python, TypeScript]
  - Need Docker? [Yes]
  - Need CI/CD? [Yes, GitHub Actions]
  - Need Cloud? [Yes, AWS with Terraform]
  - Apply standards? [Yes, Security + Docs + Pre-commit]

Agent → Generates custom roadmap in target repo:
  roadmap/ai_setup/
  ├── PROGRESS_TRACKER.md  (tracks installation progress)
  ├── AI_CONTEXT.md        (why we're doing this)
  └── PR_BREAKDOWN.md      (step-by-step PRs)

Agent → Executes PRs sequentially:
  PR1: Foundation (.ai folder)
  PR2: Python setup (Ruff/Black/pytest)
  PR3: TypeScript setup (ESLint/Prettier/Vitest)
  PR4: Docker (frontend + backend containers)
  PR5: GitHub Actions (lint/test/build/deploy)
  PR6: Terraform/AWS (VPC/ECS/ALB)
  PR7: Security standards
  PR8: Documentation standards
  PR9: Pre-commit hooks
  PR10: Integration & validation

User → Has production-ready repo in <30 minutes
```

#### Journey 2: Adding Single Capability
```
User → "Add Python linting to my existing repo"
Agent → Reads ADD-CAPABILITY.md
Agent → Checks plugins/languages/python/AGENT_INSTRUCTIONS.md
Agent → Installs standalone:
  - .ruff.toml
  - Makefile targets (lint-python)
  - Pre-commit hook entry
  - GitHub Actions workflow (lint)
User → Can run `make lint-python` immediately
```

#### Journey 3: Resuming Interrupted Setup
```
User → Starts CREATE flow, completes PR1-PR5, closes laptop
User → Returns days later
Agent → Reads roadmap/ai_setup/PROGRESS_TRACKER.md
Agent → "I see you've completed PR1-PR5. Next up is PR6: Terraform/AWS. Ready to continue?"
User → "Yes"
Agent → Picks up exactly where left off
```

## Key Decisions Made

### 1. Plugin Architecture Over Monolith
**Decision**: Everything is a plugin, including foundation
**Rationale**:
- Extensibility - easy to add new languages/tools
- Maintainability - update one plugin without affecting others
- Testability - test plugins in isolation
- Community-friendly - clear contribution path

### 2. Standalone-First Design
**Decision**: Every plugin works without orchestrator
**Rationale**:
- Users can add capabilities incrementally
- Reduces coupling between components
- Enables "just give me Python linting" use case
- Orchestrator becomes optional convenience layer

### 3. Reference Implementations Only
**Decision**: Ship with Python/TypeScript/Docker/AWS, document extensibility
**Rationale**:
- Achievable scope for v1.0
- Proves the pattern works
- Avoids spreading effort thin
- Community can contribute additional plugins

### 4. Manifest-Driven Discovery
**Decision**: Central PLUGIN_MANIFEST.yaml declares what's available
**Rationale**:
- Single source of truth
- Enables smart orchestrator questions
- Easy to update when adding plugins
- Agents can parse quickly

### 5. Roadmap-Based State Tracking
**Decision**: Orchestrator creates PROGRESS_TRACKER.md in target repo
**Rationale**:
- Enables resume from interruption
- Transparent to user
- Dogfoods our own roadmap pattern
- No hidden state

### 6. Extract from durable-code-test-2
**Decision**: All patterns come from proven production code
**Rationale**:
- Battle-tested - we know these work
- Comprehensive - covers real-world needs
- Consistent - follows same philosophy
- Trustworthy - not theoretical patterns

## Integration Points

### With Existing Features (durable-code-test-2)

#### .ai Folder Structure
- **Extract**: Complete folder structure, template files, layout.yaml
- **Adapt**: Make generic (remove project-specific content)
- **Plugin**: `plugins/foundation/ai-folder/`

#### Python Tooling
- **Extract**: Ruff config, Black config, pytest setup, Makefile targets
- **Adapt**: Make configurable (allow Pylint/Flake8 options)
- **Plugin**: `plugins/languages/python/`

#### TypeScript Tooling
- **Extract**: ESLint config, Prettier config, Vitest setup, tsconfig
- **Adapt**: Make React optional, support multiple test frameworks
- **Plugin**: `plugins/languages/typescript/`

#### Docker Setup
- **Extract**: Multi-stage Dockerfiles, docker-compose patterns, .docker/ structure
- **Adapt**: Frontend + backend templates, make ports configurable
- **Plugin**: `plugins/infrastructure/containerization/docker/`

#### GitHub Actions
- **Extract**: Workflow files (lint.yml, test.yml, deploy.yml)
- **Adapt**: Make steps modular based on languages/tools selected
- **Plugin**: `plugins/infrastructure/ci-cd/github-actions/`

#### Terraform/AWS
- **Extract**: Workspace pattern, VPC/ECS/ALB setup, backend config
- **Adapt**: Make region/resource sizing configurable
- **Plugin**: `plugins/infrastructure/iac/terraform/providers/aws/`

#### Pre-commit Hooks
- **Extract**: .pre-commit-config.yaml, hook integrations
- **Adapt**: Dynamically add hooks based on languages selected
- **Plugin**: `plugins/standards/pre-commit-hooks/`

#### Design Linters
- **Extract**: Custom linting framework (future enhancement)
- **Adapt**: Make rules pluggable
- **Plugin**: `plugins/standards/custom-linters/` (future)

## Success Metrics

### Launch Metrics (v1.0.0)
- ✅ Agent can create Python+TypeScript+Docker+AWS repo from empty directory in <30min
- ✅ All 21 PRs complete and tested
- ✅ Three test repos validate successfully (empty, incremental, existing)
- ✅ Plugin _templates are usable (<2 hours to create new plugin with docs)
- ✅ Documentation complete (README, CONTRIBUTING, how-tos)
- ✅ Public GitHub release with examples

### Ongoing Metrics (post-launch)
- 🎯 Community contributions (new plugins added)
- 🎯 Adoption (GitHub stars, forks, usage)
- 🎯 Plugin diversity (languages/clouds beyond initial set)
- 🎯 Issue resolution (support requests, bug fixes)

## Technical Constraints

### Must Support
- Git repositories (GitHub, GitLab, Bitbucket compatible)
- Linux/macOS development environments
- Docker (if containerization plugin used)
- Cloud provider CLI tools (if cloud plugin used)
- Python 3.11+ and Node.js 18+ (for reference implementations)

### Does NOT Support (v1.0)
- Windows-native development (use WSL2)
- Monorepos (single repo = single project)
- Existing complex projects (UPGRADE works for simple cases only)
- Non-Git version control

### Limitations
- Terraform/AWS plugin provides scaffold, not production-hardened infrastructure
- UPGRADE-TO-AI-REPO works best for simple, clean existing repos
- Custom linting rules are Python/TypeScript only initially
- Plugin creation requires understanding of target language/tool

## AI Agent Guidance

### When Installing Foundation Plugin
1. Always install first (it's required for everything else)
2. Creates .ai/ folder with complete structure
3. Generates layout.yaml, index.yaml, templates/, howto/
4. This is the base - everything builds on this

### When Installing Language Plugin
1. Check PLUGIN_MANIFEST.yaml for available options (linters, formatters, testing)
2. Ask user for preferences or use recommended defaults
3. Install config files, Makefile targets, templates
4. Update .ai/index.yaml to document the installation
5. Add GitHub Actions workflow if CI/CD plugin present

### When Installing Infrastructure Plugin
1. Check dependencies (e.g., Terraform plugin needs AWS CLI)
2. Create configs in appropriate directory (.docker/, infra/, .github/)
3. Update Makefile with new targets
4. Add documentation to .ai/howto/
5. Validate installation with simple test

### When Generating Roadmaps
1. Use roadmap templates from durable-code-test-2
2. Create in target repo at `roadmap/ai_setup/`
3. Generate PROGRESS_TRACKER.md with all PRs listed
4. Make PR breakdown detailed enough to execute later
5. Update PROGRESS_TRACKER.md after each PR completion

### Common Patterns

#### Pattern 1: Incremental Installation
```
Install foundation → Test → Install language → Test → Install infra → Test
```

#### Pattern 2: Full Stack Setup
```
Discovery → Roadmap → PR1 (foundation) → PR2-N (plugins) → Integration Test
```

#### Pattern 3: Resume After Interruption
```
Read PROGRESS_TRACKER.md → Find last completed PR → Continue with next PR
```

## Risk Mitigation

### Risk 1: Plugin Conflicts
**Mitigation**: Each plugin is isolated, uses namespaced configs, clear dependency declarations

### Risk 2: Incomplete Extraction from durable-code-test-2
**Mitigation**: Test each plugin in clean environment, validate against source

### Risk 3: Poor Plugin Documentation
**Mitigation**: Require AGENT_INSTRUCTIONS.md for every plugin, test with fresh agent context

### Risk 4: Orchestrator Too Complex
**Mitigation**: Start simple (foundation only), iterate, keep discovery questions minimal

### Risk 5: Users Can't Extend Framework
**Mitigation**: Excellent _template/ directories, clear how-to docs, working examples

## Future Enhancements

### Phase 2 (post-v1.0)
- Additional language plugins (Go, Rust, Java)
- Additional cloud providers (GCP, Azure)
- Additional IaC tools (Pulumi, CDK)
- SOLID principles custom linting
- Organizational standards customization

### Phase 3 (community-driven)
- Plugin marketplace/registry
- Automated plugin validation
- Plugin composition testing
- Multi-language linting harmonization
- Advanced orchestration (conflict resolution, dry-run mode)

---

**Remember**: We're building the engine, not populating every possible plugin. Focus on excellent reference implementations and clear extensibility.
