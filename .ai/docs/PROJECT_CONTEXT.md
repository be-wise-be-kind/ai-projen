# AI-Projen - Project Context

**Purpose**: Comprehensive project context for AI agents working on or with the ai-projen framework

**Scope**: Framework architecture, development philosophy, plugin system, and operational guidance

**Overview**: Context document for AI agents maintaining, extending, or using the ai-projen framework. Describes the purpose, architecture, design decisions, and patterns that make ai-projen a plugin-based system for creating AI-ready repositories. Essential for understanding how to maintain the framework itself, how to create new plugins, and how to use the framework to transform repositories into production-ready, AI-compatible environments.

**Dependencies**: [durable-code-test](https://github.com/steve-e-jackson/durable-code-test) (source patterns), Git/GitHub, PLUGIN_MANIFEST.yaml

**Exports**: Framework context, architectural patterns, development guidelines, success criteria

**Related**: PLUGIN_ARCHITECTURE.md for technical details, PLUGIN_DISCOVERY.md for orchestration logic, AGENTS.md for agent routing

**Implementation**: Self-referential documentation following the same patterns the framework teaches

---

## What ai-projen Does

**ai-projen** is a plugin-based framework that transforms repositories into AI-ready environments through composable, standalone plugins.

### Definition: AI-Ready Repository

An AI-ready repository is one where AI agents can be trusted to generate code that is:
- Well-written and maintainable
- Durable and reliable
- Scalable and performant
- Secure and compliant
- Following industry best practices

This is achieved through comprehensive tooling, standards enforcement, clear documentation, and deterministic validation.

### Core Capabilities

The framework provides AI agents with the ability to:

1. **Create New Repositories** - Transform empty directories into production-ready environments in under 30 minutes
2. **Upgrade Existing Repositories** - Safely add AI patterns and tooling to working codebases without breaking functionality
3. **Add Specific Capabilities** - Install individual plugins incrementally for granular control
4. **Lint and Evaluate** - Grade repositories against AI-ready standards

### Key Characteristics

- **Plugin-Based**: Everything is a composable plugin
- **Standalone First**: Each plugin works independently without requiring orchestration
- **Extensible**: Easy to add new languages, clouds, tools, and standards
- **Battle-Tested**: Patterns extracted from production applications
- **Agent-Friendly**: Designed for AI agent consumption and execution

---

## AI-Ready Definition

For ai-projen, "AI-ready" means a repository has:

### 1. Clear Structure
- Organized directory layout
- Navigation documentation for AI agents (`.ai/` directory)
- Consistent file placement rules

### 2. Comprehensive Tooling
- Automated linting and formatting
- Type checking and security scanning
- Testing frameworks with coverage
- Pre-commit hooks for quality gates
- Immediate feedback loops (fast validation, clear error messages)

### 3. Standards Enforcement
- File header documentation
- Security scanning (secrets, vulnerabilities)
- Git workflow best practices
- CI/CD automation

### 4. Deterministic Validation
- Clear success criteria for all operations
- Automated testing and validation
- Immediate feedback loops
- Explicit error messages

### 5. Production Readiness
- Containerization (Docker)
- CI/CD pipelines (GitHub Actions)
- Infrastructure as Code (Terraform/AWS)
- Deployment automation

---

## Architecture Overview

### Plugin-Based Design

ai-projen organizes plugins into six categories:

#### 1. Foundation Plugins (`plugins/foundation/`)
**Purpose**: Universal plugins required by all repositories

**Example**: `ai-folder` - Creates the `.ai/` directory structure that provides AI navigation and documentation

**Characteristics**:
- Always installed first
- Required for all repositories
- Language/framework agnostic
- Provides core AI navigation

#### 2. Language Plugins (`plugins/languages/`)
**Purpose**: Language-specific development tooling

**Examples**: `python`, `typescript`

**Provides**:
- Linting and formatting (Ruff, ESLint)
- Type checking (MyPy, TypeScript)
- Security scanning (Bandit)
- Testing frameworks (Pytest, Vitest)
- Build system integration

**Characteristics**:
- Can coexist (multi-language projects)
- Isolated configurations
- Namespace-specific Make targets

#### 3. Infrastructure Plugins (`plugins/infrastructure/`)
**Purpose**: Deployment and runtime tooling

**Subdirectories**:
- `containerization/` - Docker, Podman
- `ci-cd/` - GitHub Actions, GitLab CI
- `iac/` - Terraform, Pulumi, CDK

**Characteristics**:
- Environment setup and configuration
- Deployment automation
- Cloud integration
- May depend on language plugins

#### 4. Standards Plugins (`plugins/standards/`)
**Purpose**: Quality, security, and documentation enforcement

**Examples**: `security`, `documentation`, `pre-commit-hooks`

**Characteristics**:
- Cross-cutting concerns
- Integrate with language plugins
- Policy enforcement
- Best practices baked in

#### 5. Application Plugins (`plugins/applications/`)
**Purpose**: Pre-configured plugin compositions for common application types

**Examples**: `python-cli`, `react-python-fullstack`

**Characteristics**:
- Meta-plugins that compose other plugins
- Provide complete, functional starter applications
- Include application-specific how-to guides
- Opinionated architectures with sensible defaults
- "Quick start" path vs. custom plugin selection

#### 6. Repository Plugins (`plugins/repository/`)
**Purpose**: Repository-level configuration and tooling

**Examples**: `environment-setup` (direnv, .env management)

**Characteristics**:
- Repository-wide concerns
- Optional but recommended
- Can work with or without foundation plugin
- Focus on operational tooling

### Plugin Manifest

`plugins/PLUGIN_MANIFEST.yaml` is the single source of truth declaring:
- Available plugins by category
- Plugin status (stable/planned/community)
- Configuration options and recommended defaults
- Dependencies and integration points
- Installation guide paths

---

## Two Agent Interaction Types

The framework supports two distinct modes of operation, defined in AGENTS.md:

### Type 1: Repository Assistant Mode
**When**: AI agent is working on a DIFFERENT repository (user's project)

**Detection Signals**:
- User mentions external repository path
- User asks about "my repo" or "my project"
- User wants to create, upgrade, or add capabilities to THEIR repository

**Workflow**:
1. Read three core documents (ai-context.md, ai-rules.md, index.yaml)
2. Classify user intent (create new / upgrade existing / add capability)
3. Confirm understanding with user
4. Route to appropriate how-to guide
5. Execute workflow in user's repository
6. Validate and report

**How-To Guides**:
- `.ai/howto/how-to-create-new-ai-repo.md` - Create new repository from scratch
- `.ai/howto/how-to-upgrade-to-ai-repo.md` - Upgrade existing repository safely
- `.ai/howto/how-to-add-capability.md` - Add single plugin incrementally

### Type 2: Framework Developer Mode
**When**: AI agent is working on ai-projen repository ITSELF

**Detection Signals**:
- Working directory is ai-projen repository
- User asks about improving ai-projen itself
- User mentions adding plugins, updating documentation, or fixing framework code

**Workflow**:
1. Read core ai-projen documents
2. Classify task type (add plugin / update existing / improve docs / fix bugs)
3. Review relevant standards
4. Create feature branch BEFORE changes
5. Make changes following standards
6. Validate changes
7. Commit and merge

**Standards Documents**:
- `.ai/docs/PLUGIN_GIT_WORKFLOW_STANDARD.md` - Git workflow requirements
- `.ai/docs/FILE_HEADER_STANDARDS.md` - File documentation requirements
- `.ai/docs/HOWTO_STANDARDS.md` - How-to guide standards
- `.ai/howto/how-to-create-a-*-plugin.md` - Plugin creation guides

---

## Entry Point System

### Primary Entry: AGENTS.md

AGENTS.md serves as the main entry point for all AI agents, providing:
- Agent type determination (Repository Assistant vs Framework Developer)
- Task routing logic with decision trees
- Links to relevant how-to guides
- Critical rules and workflow patterns

### How-To Guide Routing

Based on agent type and user intent, AGENTS.md routes to specific guides:

**For Repository Assistant Mode**:
- Create new repository → `how-to-create-new-ai-repo.md`
- Upgrade existing → `how-to-upgrade-to-ai-repo.md`
- Add specific capability → `how-to-add-capability.md`

**For Framework Developer Mode**:
- Create new plugin → `how-to-create-a-{category}-plugin.md`
- Discover plugins → `how-to-discover-and-install-plugins.md`
- Create templates → `how-to-create-a-template.md`

---

## Core Documents

Three core documents provide the primary framework context (read first by all agents):

### 1. `.ai/ai-context.md` (Primary Context)
**Purpose**: Project development context - mission, architecture, key patterns, directory structure

### 2. `.ai/ai-rules.md` (Mandatory Rules)
**Purpose**: Quality gates, coding standards, git rules, documentation rules

### 3. `.ai/index.yaml` (Navigation)
**Purpose**: Complete repository structure and navigation map

### Deep-Dive Reference: `.ai/docs/PROJECT_CONTEXT.md` (This Document)
**Purpose**: Comprehensive framework architecture, philosophy, and detailed development guidelines. Use this for in-depth understanding beyond what ai-context.md provides.

---

## Workflow Standards

### Git Workflow (PLUGIN_GIT_WORKFLOW_STANDARD.md)

**Core Principle**: Never make changes directly to main/master/develop branches

**Required Pattern for All Plugins**:

1. **Detect Current State** - Check if plugin is already installed
2. **Determine if Changes Needed** - Evaluate state flags
3. **Create Feature Branch** - Only if changes required
4. **Make Changes** - On feature branch, never on main
5. **Commit Changes** - With descriptive message
6. **Inform User** - About next steps (review, merge, PR)

**Branch Naming Convention**:
- `feature/add-{plugin-name}` - For new features
- `fix/{issue-description}` - For bug fixes
- `enhance/{capability-name}` - For improvements
- `docs/{documentation-update}` - For documentation only

**Why This Exists**: Makes branching explicit and mandatory in every plugin's AGENT_INSTRUCTIONS.md, ensuring safe, revertible changes.

### Branching Standard

Every plugin installation follows this workflow:

```bash
# Step 1: Detect state
HAS_PLUGIN=false  # or true based on detection

# Step 2: Determine if changes needed
CHANGES_NEEDED=false
if [ "$HAS_PLUGIN" = false ]; then
  CHANGES_NEEDED=true
fi

# Step 3: Create branch if needed
if [ "$CHANGES_NEEDED" = true ]; then
  CURRENT_BRANCH=$(git branch --show-current)
  if [[ "$CURRENT_BRANCH" == "main" ]] || [[ "$CURRENT_BRANCH" == "master" ]]; then
    git checkout -b "feature/add-plugin-name"
  fi
else
  echo "No changes needed - plugin already installed"
  exit 0
fi
```

---

## Plugin Structure

### Standard Plugin Organization

Every plugin follows this structure:

```
<plugin-name>/
├── AGENT_INSTRUCTIONS.md       # AI installation guide (REQUIRED)
├── README.md                   # Human documentation (REQUIRED)
├── manifest.yaml               # Plugin metadata (optional)
│
├── ai-content/                 # → Target repo's .ai/ directory
│   ├── docs/                   # Documentation files
│   ├── howtos/                 # Task guides
│   │   ├── README.md           # Index/catalog
│   │   └── how-to-*.md         # Individual guides
│   ├── standards/              # Standards documents
│   └── templates/              # Code generation templates
│
├── project-content/            # → Target repo root
│   ├── config/                 # Config files (.ruff.toml, etc)
│   ├── makefiles/              # Makefile snippets
│   ├── workflows/              # CI/CD workflows
│   ├── docker/                 # Dockerfiles, compose files
│   └── terraform/              # IaC files
│
└── src-templates/              # → Code examples (not auto-installed)
    └── examples/               # Example implementations
```

### Required Files

#### AGENT_INSTRUCTIONS.md
Format:
- Prerequisites (system requirements, dependencies)
- Installation Steps (numbered, sequential)
- Configuration (customization points)
- Validation (testing and verification)
- Success Criteria (completion checklist)

Must include:
- State detection step
- Branching step (following PLUGIN_GIT_WORKFLOW_STANDARD.md)
- File placement instructions
- Integration with other plugins

#### README.md
Format:
- What This Plugin Does
- Why You Need It
- What Gets Installed
- How to Install Standalone
- How to Customize
- Integration Points

---

## Design Philosophies

### 1. Determinism Over Flexibility

**Principle**: Maximize determinism while embracing AI agent flexibility

**Implementation**:
- Explicit instructions over implicit assumptions
- Clear success criteria for every operation
- Defensive validation at each step
- Predictable outcomes

**Example**: Plugin AGENT_INSTRUCTIONS.md provides numbered steps, not general guidance

### 2. Explicit Over Implicit

**Principle**: Never assume AI agents remember context or general guidelines

**Implementation**:
- Branching requirements in every plugin (not just in general docs)
- File placement explicitly stated (not inferred)
- Dependencies declared (not discovered)
- Validation steps included (not assumed)

**Example**: Git branching step is in EVERY plugin's AGENT_INSTRUCTIONS.md

### 3. Standalone First

**Principle**: Every plugin must work independently without requiring orchestration

**Implementation**:
- No hidden dependencies
- Self-contained installation instructions
- Independent validation
- Isolated configurations

**Benefits**:
- Incremental adoption
- Lower barrier to entry
- Reduced coupling
- Clear plugin boundaries

### 4. Composable Without Conflicts

**Principle**: Plugins combine seamlessly without interfering with each other

**Implementation**:
- Isolated configurations
- Namespaced Make targets
- Non-overlapping file paths
- Clear dependency declarations

**Example**: Python and TypeScript plugins coexist, each with separate configs and targets

### 5. Extensible by Design

**Principle**: Framework grows through community contributions

**Implementation**:
- `_template/` directories for each plugin category
- Clear "how-to-create-a-{category}-plugin.md" guides
- Low barrier to contribution
- Reference implementations to follow

**Goal**: Not to build every possible plugin, but to make plugin creation easy

### 6. Don't Corrupt User Machine

**Principle**: Protect user's system from pollution

**Implementation**:
- Use Poetry for isolated virtual environments (Python)
- Never use global pip installs
- Always use Make targets (never direct commands)
- All operations through isolated environments

**Philosophy**: User's machine should remain clean after framework use

---

## Source Material

All patterns extracted from **durable-code-test** repository:

- [.ai folder structure](https://github.com/steve-e-jackson/durable-code-test/tree/main/.ai)
- [Makefile patterns](https://github.com/steve-e-jackson/durable-code-test/blob/main/Makefile)
- [Docker setup](https://github.com/steve-e-jackson/durable-code-test/tree/main/.docker)
- [GitHub Actions](https://github.com/steve-e-jackson/durable-code-test/tree/main/.github/workflows)
- [Terraform workspaces](https://github.com/steve-e-jackson/durable-code-test/tree/main/infra/terraform)
- [Pre-commit hooks](https://github.com/steve-e-jackson/durable-code-test/blob/main/.pre-commit-config.yaml)
- [Standards documentation](https://github.com/steve-e-jackson/durable-code-test/tree/main/.ai/docs)

**Why Extract from Production**: Patterns proven in real applications, not theoretical best practices.

---

## Framework Development

### When Working on ai-projen Itself

#### 1. Follow Your Own Patterns
- ai-projen has a `.ai/` folder - use it
- Apply file headers to all files
- Document everything
- Dogfood the framework

#### 2. Maintain Plugin Independence
- Each plugin works standalone
- No hidden dependencies
- Clear prerequisite declarations
- Test in isolation

#### 3. Update Manifest
- Add new plugins to `plugins/PLUGIN_MANIFEST.yaml`
- Declare status (stable/planned)
- Specify options and defaults
- Document dependencies

#### 4. Create _templates
- Every plugin category has `_template/` directory
- Templates show how to create new plugins
- Keep templates current with standards
- Test template usage

#### 5. Document Extensibility
- Update `how-to-create-a-{category}-plugin.md` guides
- Provide real examples to follow
- Maintain contribution guidelines
- Show, don't just tell

### Git Workflow for Framework Development

**MANDATORY**: Create feature branch BEFORE any changes

```bash
# Branch naming
feature/add-{plugin-name}       # For new features
fix/{issue-description}         # For bug fixes
enhance/{capability-name}       # For improvements
docs/{documentation-update}     # For documentation only

# Example workflow
git checkout -b feature/add-go-plugin
# Make changes
git add -A
git commit -m "feat: Add Go language plugin with linter support"
git checkout main
git merge feature/add-go-plugin
git branch -d feature/add-go-plugin
```

### File Header Requirements

All files require headers per FILE_HEADER_STANDARDS.md:

**Markdown Files**:
```markdown
# Document Title

**Purpose**: Brief description
**Scope**: What this covers
**Overview**: Comprehensive explanation
**Dependencies**: Related files/resources
**Exports**: What this provides
**Related**: Links to related docs
**Implementation**: Notable patterns

---
```

**Python Files**:
```python
"""
Purpose: Brief description
Scope: What this handles
Overview: Comprehensive explanation
Dependencies: Key dependencies
Exports: Main classes/functions
Interfaces: Key APIs
Implementation: Notable patterns
"""
```

---

## Plugin Development

### Creating New Plugins

#### Step 1: Choose Category
- **foundation** - Universal/required
- **languages** - Language-specific tooling
- **infrastructure** - Deployment tools (containerization/ci-cd/iac)
- **standards** - Quality enforcement
- **applications** - Complete application types
- **repository** - Repository-level tooling

#### Step 2: Start with Template
```bash
# Copy template
cp -r plugins/{category}/_template plugins/{category}/{new-plugin}

# Fill in template files
cd plugins/{category}/{new-plugin}
# Replace {{PLACEHOLDERS}} with actual values
```

#### Step 3: Create AGENT_INSTRUCTIONS.md
Must include:
1. Prerequisites
2. State detection step
3. Branching step (from PLUGIN_GIT_WORKFLOW_STANDARD.md)
4. Installation steps
5. Configuration
6. Validation
7. Success criteria

#### Step 4: Create README.md
Must include:
- What the plugin does
- Why you need it
- What gets installed
- How to install standalone
- How to customize
- Integration points

#### Step 5: Organize Content
- `ai-content/` - Goes to target repo's `.ai/` directory
- `project-content/` - Goes to target repo root
- `src-templates/` - Example code (not auto-installed)

#### Step 6: Update PLUGIN_MANIFEST.yaml
Add entry with:
- Status (stable/planned)
- Description
- Location
- Dependencies
- Options and defaults
- Installation guide path

#### Step 7: Test Thoroughly
- Standalone installation (no orchestrator)
- Integration with other plugins
- Resume capability
- All validation steps

### Plugin Categories in Detail

#### Language Plugins
Guide: `.ai/howto/how-to-create-a-language-plugin.md`

Structure:
```
plugins/languages/{language}/
├── core/                       # Core language setup
├── linters/{tool}/            # Linter-specific configs
├── formatters/{tool}/         # Formatter-specific configs
├── testing/{framework}/       # Test framework setups
└── frameworks/{framework}/    # Optional frameworks
```

#### Infrastructure Plugins
Guide: `.ai/howto/how-to-create-an-infrastructure-plugin.md`

Structure:
```
plugins/infrastructure/{category}/{tool}/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   ├── howtos/
│   └── standards/
└── project-content/
    ├── docker/        # For containerization
    ├── workflows/     # For ci-cd
    └── terraform/     # For iac
```

#### Standards Plugins
Guide: `.ai/howto/how-to-create-a-standards-plugin.md`

Structure:
```
plugins/standards/{standard}/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   ├── docs/          # Standards documents
│   ├── howtos/        # How to apply standards
│   └── templates/     # Documentation templates
└── project-content/
    └── config/        # Tool configurations
```

---

## Success Criteria

### Framework Quality Metrics

- [ ] All reference plugins work standalone
- [ ] Plugins compose without conflicts
- [ ] `_template/` directories are clear and usable
- [ ] Documentation is comprehensive and accurate
- [ ] New plugin creation takes less than 2 hours
- [ ] Installation is deterministic and repeatable

### Plugin Quality Metrics

- [ ] AGENT_INSTRUCTIONS.md follows standard format
- [ ] README.md is comprehensive
- [ ] File headers on all files
- [ ] Branching step included in installation
- [ ] State detection before changes
- [ ] Validation steps with success criteria
- [ ] Tested standalone
- [ ] Tested with other plugins

### Repository Transformation Metrics

- [ ] Empty directory to production-ready in under 30 minutes
- [ ] Existing repo upgraded without breaking functionality
- [ ] All tooling passes validation
- [ ] Clear documentation for AI agents
- [ ] Deterministic success/failure
- [ ] Resume capability works

### Adoption Metrics

- [ ] Framework used for new projects
- [ ] Community contributions (new plugins)
- [ ] Plugin diversity (beyond initial set)
- [ ] Issue resolution rate
- [ ] Documentation clarity (low confusion rate)

---

## Plugin Discovery and Installation

Reference: `.ai/howto/how-to-discover-and-install-plugins.md`

### Discovery Flow

1. **Read PLUGIN_MANIFEST.yaml** - What plugins exist?
2. **Read PLUGIN_ARCHITECTURE.md** - How are they organized?
3. **Read {plugin}/README.md** - What does this plugin provide?
4. **Read {plugin}/AGENT_INSTRUCTIONS.md** - How to install it?
5. **Execute Installation** - Follow instructions exactly

### Orchestrator-Driven Installation

Orchestrators (`how-to-create-new-ai-repo.md`, `how-to-upgrade-to-ai-repo.md`) automate discovery:

1. Read PLUGIN_MANIFEST.yaml
2. Ask discovery questions
3. Generate custom roadmap
4. Execute plugins sequentially
5. Track progress in PROGRESS_TRACKER.md
6. Enable resume capability

---

## Key Design Decisions

### Why Plugin-Based?
**Extensibility**. Easy to add new languages, clouds, tools without modifying core framework.

### Why Standalone-First?
**Flexibility**. Users can add capabilities incrementally instead of all-or-nothing.

### Why AGENT_INSTRUCTIONS.md?
**AI-Friendly**. Clear, structured instructions AI agents can follow reliably without human interpretation.

### Why Manifest-Driven?
**Discovery**. Single source of truth for available plugins and options. Enables automated orchestration.

### Why Extract from durable-code-test?
**Proven**. Patterns that work in production applications, not theoretical best practices.

### Why Not Code Generation?
**Complexity**. Too many edge cases and variations. AI agents interpret instructions better than rigid code generators.

### Why Two Agent Types?
**Clarity**. Agents need different context when working on ai-projen vs. using ai-projen to transform other repos.

### Why Git Workflow Standard in Every Plugin?
**Explicit > Implicit**. Don't assume agents remember general guidelines when executing specific instructions.

---

## Future Directions

### Extensibility Focus

**Core Insight**: We're not building a library of every possible plugin. We're building the **engine** that makes plugins easy to create and compose.

**V1.0 Goals**:
- Stable reference implementations
- Clear plugin creation guides
- Comprehensive documentation
- Battle-tested patterns

**Post-V1.0 (Community-Driven)**:
- Additional languages (Go, Rust, Java)
- Additional clouds (GCP, Azure)
- Additional IaC (Pulumi, CDK)
- SOLID principles linting
- Organizational standards templates

**Long-Term Vision**:
- Plugin marketplace/registry
- Automated plugin validation
- Multi-language linting harmonization
- Advanced orchestration features

---

## Maintenance Notes

### Regular Tasks

- Keep dependencies updated
- Sync patterns from durable-code-test
- Review community PRs
- Update documentation
- Test against new language/tool versions
- Validate PLUGIN_MANIFEST.yaml schema

### Breaking Changes

- Version plugins separately
- Maintain backwards compatibility in orchestrators
- Provide clear migration guides
- Include deprecation warnings
- Update PLUGIN_MANIFEST.yaml status

### Community Health

- Respond to issues promptly
- Welcome new contributors
- Maintain code of conduct
- Celebrate contributions
- Keep documentation current

---

## Related Documents

### Essential Reading (Start Here)
- **AGENTS.md** - Primary entry point for all AI agents
- **ai-context.md** - Project context and patterns
- **ai-rules.md** - Quality gates and mandatory rules
- **index.yaml** - Complete repository structure map

### Architecture and Standards
- **PLUGIN_ARCHITECTURE.md** - Technical plugin specifications
- **PLUGIN_DISCOVERY.md** - Orchestration logic and discovery flow
- **PLUGIN_GIT_WORKFLOW_STANDARD.md** - Git workflow requirements
- **FILE_HEADER_STANDARDS.md** - File documentation requirements

### How-To Guides
- **how-to-create-new-ai-repo.md** - Create repository from scratch
- **how-to-upgrade-to-ai-repo.md** - Upgrade existing repository
- **how-to-add-capability.md** - Add single plugin
- **how-to-create-a-language-plugin.md** - Create language plugin
- **how-to-create-an-infrastructure-plugin.md** - Create infrastructure plugin
- **how-to-discover-and-install-plugins.md** - Plugin discovery guide

---

**Remember**: This is the framework that creates AI-ready repositories. It must exemplify the patterns it teaches. Be deterministic, explicit, and defensive. When in doubt, make it more explicit.
