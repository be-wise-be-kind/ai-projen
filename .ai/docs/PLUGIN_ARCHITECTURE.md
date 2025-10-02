# Plugin Architecture

**Purpose**: Technical specification for ai-projen plugin system

**Scope**: Plugin structure, requirements, interfaces, and integration patterns

**Overview**: Defines the technical architecture of the plugin system including directory structures,
    required files, metadata formats, dependency management, and integration patterns. Essential for
    anyone creating new plugins or understanding how plugins interact with the orchestration system
    and with each other.

**Dependencies**: PLUGIN_MANIFEST.yaml, orchestrator documents (CREATE/UPGRADE/ADD)

**Exports**: Plugin specifications, structure requirements, integration patterns

**Related**: PROJECT_CONTEXT.md for philosophy, PLUGIN_DISCOVERY.md for orchestration

**Implementation**: Standard directory structures, YAML manifest, markdown documentation

---

## Plugin Categories

### foundation/
**Purpose**: Universal plugins required by all projects

**Example**: `ai-folder` - The .ai directory structure

**Characteristics**:
- Always installed first
- Required for all repositories
- Language/framework agnostic
- Minimal dependencies

### languages/
**Purpose**: Language-specific development tooling

**Examples**: `python`, `typescript`

**Characteristics**:
- Linting, formatting, testing frameworks
- Language-specific standards
- Build system integration
- Can coexist (multi-language projects)

### infrastructure/
**Purpose**: Deployment and runtime tooling

**Subdirectories**:
- `containerization/` (Docker, Podman)
- `ci-cd/` (GitHub Actions, GitLab CI)
- `iac/` (Terraform, Pulumi, CDK)

**Characteristics**:
- Environment setup
- Deployment automation
- Cloud integration
- May depend on language plugins

### standards/
**Purpose**: Quality, security, and documentation enforcement

**Examples**: `security`, `documentation`, `pre-commit-hooks`

**Characteristics**:
- Cross-cutting concerns
- Integrate with language plugins
- Policy enforcement
- Best practices

## Plugin Taxonomy

### Complete Taxonomy Structure

```
plugins/
├── foundation/                          # Universal/required
│   └── ai-folder/                      # The .ai directory itself
│
├── languages/                           # Language-specific
│   └── <language>/                     # e.g., python, typescript, go
│       ├── core/                       # Language core setup
│       ├── linters/
│       │   └── <tool>/                # e.g., ruff, eslint
│       ├── formatters/
│       │   └── <tool>/                # e.g., black, prettier
│       ├── testing/
│       │   └── <framework>/           # e.g., pytest, vitest
│       └── frameworks/                 # Optional framework-specific
│           └── <framework>/           # e.g., fastapi, react
│
├── infrastructure/
│   ├── containerization/
│   │   └── <tool>/                    # e.g., docker, podman
│   ├── ci-cd/
│   │   └── <platform>/                # e.g., github-actions, gitlab-ci
│   └── iac/
│       └── <tool>-<vendor>/          # e.g., terraform-aws, pulumi-gcp
│
└── standards/                           # Cross-cutting concerns
    └── <standard-name>/                # e.g., security, documentation
```

### Plugin Taxonomy Principles

1. **Capability over Vendor**: Organize by what the plugin does, not who makes it
   - ✅ `infrastructure/ci-cd/github-actions/` (capability: CI/CD, tool: GitHub Actions)
   - ❌ `github/actions/` (organized by vendor)

2. **Hierarchy by Specificity**: General → Specific
   - Language → Tool Category → Specific Tool
   - Example: `languages/python/linters/ruff/`

3. **Vendor Suffix for Cloud**: Only add vendor when multiple exist
   - ✅ `iac/terraform-aws/` (Terraform has multiple providers)
   - ✅ `containerization/docker/` (Docker is the tool itself)

## Plugin Structure

### Standard Internal Structure

**Every plugin** (regardless of taxonomy level) follows this structure:

```
<plugin-name>/
├── AGENT_INSTRUCTIONS.md              # AI installation guide
├── README.md                          # Human documentation
├── manifest.yaml                       # Plugin metadata (optional)
│
├── ai-content/                         # → Goes to target repo's .ai/
│   ├── docs/                          # Documentation files
│   ├── howtos/                        # Task guides
│   │   ├── README.md                  # Index/catalog
│   │   └── how-to-*.md               # Individual guides
│   ├── standards/                     # Standards documents
│   └── templates/                     # Code generation templates
│
├── project-content/                    # → Goes to target repo root
│   ├── config/                        # Config files (.ruff.toml, etc)
│   ├── makefiles/                     # Makefile snippets
│   ├── workflows/                     # CI/CD workflows
│   ├── docker/                        # Dockerfiles, compose files
│   └── terraform/                     # IaC files
│
└── src-templates/                      # → Code examples (not auto-installed)
    └── examples/                      # Example implementations
```

### Required Files

Every plugin MUST contain:

#### 1. AGENT_INSTRUCTIONS.md
Format:
```markdown
# {Plugin Name} - Agent Instructions

## Prerequisites
- System requirements
- Tool versions
- Dependencies

## Installation Steps
1. Step-by-step instructions
2. With exact commands
3. And file operations

## Configuration
- Customization points
- Variables to set
- Integration with other plugins

## Validation
- How to test installation
- Expected outcomes
- Troubleshooting

## Success Criteria
- [ ] Checklist of requirements
- [ ] For completion
```

#### 2. README.md
Format:
```markdown
# {Plugin Name}

## What This Plugin Does
Brief description

## Why You Need It
Use cases

## What Gets Installed
- File list
- Configuration files
- Dependencies

## How to Install Standalone
```bash
# Commands
```

## How to Customize
Variables and options

## Integration
Works with: {other plugins}

### Optional but Recommended

#### 3. templates/
Directory containing:
- Configuration files (.toml, .json, .yaml)
- Template files (.template extension)
- Makefile snippets (.mk files)
- Workflow files (.yml for CI/CD)

**Template Variables**:
- `{{PROJECT_NAME}}` - Repository name
- `{{PROJECT_TYPE}}` - Language/framework
- `{{AUTHOR_NAME}}` - Developer name
- `{{AUTHOR_EMAIL}}` - Developer email
- Custom plugin-specific variables

#### 4. configs/
Pre-configured files ready to copy:
- Linter configurations
- Formatter configurations
- Test framework setups
- Tool-specific settings

### Content Categories

#### ai-content/ Directory
**Purpose**: Content that goes into the target repository's `.ai/` directory

**Contents**:
- `docs/` - Plugin-specific documentation
- `howtos/` - Step-by-step task guides
- `standards/` - Standards and best practices documents
- `templates/` - Code generation templates (.template files)

**Destination**: `.ai/` in target repository

**Template Variables** (for files in ai-content/templates/):
- `{{PROJECT_NAME}}` - Repository name
- `{{PROJECT_TYPE}}` - Language/framework
- `{{AUTHOR_NAME}}` - Developer name
- `{{AUTHOR_EMAIL}}` - Developer email
- Custom plugin-specific variables

#### project-content/ Directory
**Purpose**: Configuration and infrastructure files for the project root

**Contents**:
- `config/` - Configuration files (pyproject.toml, .eslintrc, etc.)
- `makefiles/` - Makefile snippets (.mk files)
- `workflows/` - CI/CD workflow files
- `docker/` - Docker and docker-compose files
- `terraform/` - Terraform configuration files

**Destination**: Project root or designated directories in target repository

#### src-templates/ Directory
**Purpose**: Example source code implementations

**Contents**:
- `examples/` - Example implementations referenced by how-tos
- NOT automatically installed
- Used by AI agents when following how-to guides

**Destination**: Not automatically copied; used as reference

### Directory Structure Examples

#### Language Plugin - Core (Python Example)
```
plugins/languages/python/core/
├── AGENT_INSTRUCTIONS.md           # Installation guide for AI agents
├── README.md                        # Human-readable overview
├── manifest.yaml                    # Plugin metadata and dependencies
│
├── ai-content/                      # → .ai/ in target repo
│   ├── howtos/                     # Task guides
│   │   ├── README.md               # Index of how-tos
│   │   ├── how-to-create-an-api-endpoint.md
│   │   ├── how-to-add-database-model.md
│   │   └── how-to-write-a-test.md
│   ├── standards/                  # Standards documents
│   │   ├── python-standards.md
│   │   └── comprehensive-tooling.md
│   └── templates/                  # Code generation templates
│       ├── fastapi-router.py.template
│       ├── sqlalchemy-model.py.template
│       └── pytest-test.py.template
│
├── project-content/                 # → Project root
│   ├── config/                     # Config files
│   │   ├── pyproject.toml.template
│   │   ├── .flake8
│   │   └── .pylintrc
│   ├── makefiles/                  # Makefile snippets
│   │   └── makefile-python.mk
│   ├── docker/                     # Docker files
│   │   ├── Dockerfile.python
│   │   └── docker-compose.python.yml
│   └── workflows/                  # CI/CD workflows
│       └── github-workflow-python.yml
│
└── src-templates/                   # Examples (not auto-installed)
    └── examples/
        ├── example.py
        └── test_example.py
```

#### Language Plugin - Linter Tool (Ruff Example)
```
plugins/languages/python/linters/ruff/
├── AGENT_INSTRUCTIONS.md           # Installation guide
├── README.md                        # Tool overview
│
├── ai-content/
│   └── howtos/                     # Ruff-specific how-tos (optional)
│
└── project-content/
    └── config/                     # Ruff configuration
        └── pyproject.toml          # [tool.ruff] sections
```

#### Language Plugin - Testing Framework (Pytest Example)
```
plugins/languages/python/testing/pytest/
├── AGENT_INSTRUCTIONS.md           # Installation guide
├── README.md                        # Framework overview
│
├── ai-content/
│   └── howtos/                     # Pytest-specific how-tos (optional)
│
└── project-content/
    └── config/                     # Pytest configuration
        └── pytest.ini
```

#### Infrastructure Plugin - Containerization (Docker Example)
```
plugins/infrastructure/containerization/docker/
├── AGENT_INSTRUCTIONS.md           # Installation guide
├── README.md                        # Plugin overview
├── manifest.yaml                    # Plugin metadata
│
├── ai-content/                      # → .ai/ in target repo
│   ├── howtos/                     # Docker task guides
│   │   ├── README.md               # Index of Docker how-tos
│   │   ├── how-to-add-a-service.md
│   │   ├── how-to-create-multi-stage-dockerfile.md
│   │   └── how-to-add-volume.md
│   └── standards/                  # Docker best practices
│       └── docker-standards.md
│
└── project-content/                 # → Project root
    ├── docker/                     # Docker files
    │   ├── Dockerfile.backend
    │   ├── Dockerfile.frontend
    │   ├── docker-compose.yml
    │   ├── .dockerignore
    │   └── .env.example
    └── makefiles/                  # Makefile snippets
        └── makefile-docker.mk
```

#### Infrastructure Plugin - CI/CD (GitHub Actions Example)
```
plugins/infrastructure/ci-cd/github-actions/
├── AGENT_INSTRUCTIONS.md           # Installation guide
├── README.md                        # Plugin overview
├── manifest.yaml                    # Plugin metadata
│
├── ai-content/                      # → .ai/ in target repo
│   ├── howtos/                     # CI/CD task guides
│   │   ├── README.md               # Index of CI/CD how-tos
│   │   ├── how-to-add-workflow.md
│   │   ├── how-to-configure-secrets.md
│   │   └── how-to-add-deployment.md
│   └── standards/                  # CI/CD best practices
│       └── ci-cd-standards.md
│
└── project-content/                 # → Project root
    └── workflows/                  # Workflow templates
        ├── ci-python.yml
        ├── ci-typescript.yml
        ├── ci-full-stack.yml
        ├── build-ecr.yml
        ├── deploy-aws.yml
        └── release.yml
```

#### Infrastructure Plugin - IaC (Terraform AWS Example)
```
plugins/infrastructure/iac/terraform-aws/
├── AGENT_INSTRUCTIONS.md           # Installation guide
├── README.md                        # Plugin overview
├── manifest.yaml                    # Plugin metadata
│
├── ai-content/                      # → .ai/ in target repo
│   ├── howtos/                     # Terraform task guides
│   │   ├── README.md
│   │   ├── how-to-deploy-to-aws.md
│   │   ├── how-to-manage-state.md
│   │   └── how-to-create-workspace.md
│   └── standards/                  # Terraform best practices
│       └── terraform-standards.md
│
└── project-content/                 # → Project root
    └── terraform/                  # Terraform files
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── workspaces/
```

## Plugin Manifest

### Location
`plugins/PLUGIN_MANIFEST.yaml`

### Format
```yaml
version: "1.0"

foundation:
  ai-folder:
    status: stable
    required: true

languages:
  python:
    status: stable
    linters: [ruff, pylint, flake8]
    formatters: [black]
    testing: [pytest]
    recommended_linter: ruff
    recommended_formatter: black
    recommended_testing: pytest

  typescript:
    status: stable
    linters: [eslint, biome]
    formatters: [prettier]
    testing: [vitest, jest]
    recommended_linter: eslint
    recommended_formatter: prettier
    recommended_testing: vitest

infrastructure:
  containerization:
    docker:
      status: stable
    podman:
      status: planned

  ci-cd:
    github-actions:
      status: stable
    gitlab-ci:
      status: planned

  iac:
    terraform:
      status: stable
      providers: [aws]
      recommended_provider: aws
    pulumi:
      status: planned

standards:
  security:
    status: stable
    required: recommended
  documentation:
    status: stable
    required: recommended
  pre-commit-hooks:
    status: stable
    required: recommended
```

### Status Values
- `stable` - Production-ready, fully tested
- `planned` - On roadmap, not yet implemented
- `community-requested` - Desired, awaiting contribution
- `experimental` - Available but may change

### Required Values
- `true` - Must be installed
- `recommended` - Strongly suggested
- `optional` - User choice

## Plugin Dependencies

### Declaration
In AGENT_INSTRUCTIONS.md:
```markdown
## Dependencies

### Required
- plugins/foundation/ai-folder (must be installed first)

### Optional
- plugins/infrastructure/ci-cd/github-actions (enables workflow integration)

### Conflicts
- None
```

### Resolution
Orchestrators resolve dependencies automatically:
1. Check all required dependencies
2. Install in dependency order
3. Warn about optional dependencies
4. Detect conflicts

## Plugin Integration

### With Makefiles
Plugins contribute Make targets via `.mk` files:

```makefile
# plugins/languages/python/templates/makefile-python.mk

.PHONY: lint-python
lint-python:
	@echo "Running Python linting..."
	ruff check .

.PHONY: format-python
format-python:
	@echo "Formatting Python code..."
	black .

.PHONY: test-python
test-python:
	@echo "Running Python tests..."
	pytest
```

Target repo includes via:
```makefile
# Makefile (in target repo)
include .ai/makefiles/python.mk
include .ai/makefiles/docker.mk
```

### With CI/CD
Plugins provide workflow templates:

```yaml
# plugins/languages/python/templates/github-workflow-python-lint.yml
name: Python Lint
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: pip install ruff black
      - run: make lint-python
```

### With Pre-commit Hooks
Plugins declare hooks:

```yaml
# plugins/languages/python/templates/pre-commit-python.yml
repos:
  - repo: local
    hooks:
      - id: ruff
        name: Ruff (Python linter)
        entry: ruff check
        language: system
        types: [python]

      - id: black
        name: Black (Python formatter)
        entry: black
        language: system
        types: [python]
```

## Template Variables

### Standard Variables
All plugins should support:
- `{{PROJECT_NAME}}` - Repository name
- `{{PROJECT_TYPE}}` - Primary language/framework
- `{{AUTHOR_NAME}}` - Developer name
- `{{AUTHOR_EMAIL}}` - Developer email
- `{{CREATION_DATE}}` - ISO date string

### Plugin-Specific Variables
Defined in AGENT_INSTRUCTIONS.md:
- `{{PYTHON_VERSION}}` - For Python plugins
- `{{NODE_VERSION}}` - For TypeScript/JavaScript plugins
- `{{AWS_REGION}}` - For AWS infrastructure plugins
- `{{DOCKER_PORT}}` - For Docker plugins

### Variable Substitution
Orchestrators replace variables during installation:
```bash
# In target repo
sed 's/{{PROJECT_NAME}}/my-awesome-app/g' template.txt > output.txt
```

## Plugin Validation

### Self-Validation
Every plugin should include validation in AGENT_INSTRUCTIONS.md:

```markdown
## Validation

Run these commands to verify installation:

\`\`\`bash
# Check configuration file exists
test -f .ruff.toml && echo "✅ Ruff config present" || echo "❌ Missing .ruff.toml"

# Check Make target works
make lint-python && echo "✅ Lint target works" || echo "❌ Lint target failed"

# Check pre-commit hook registered
grep "ruff" .pre-commit-config.yaml && echo "✅ Hook registered" || echo "❌ Hook missing"
\`\`\`
```

### Integration Testing
Test plugins with:
1. **Standalone** - Install in empty repo
2. **Combined** - Install with other plugins
3. **Resume** - Interrupt and resume installation

## _template/ Directories

### Purpose
Show how to create new plugins in each category

### Structure
```
plugins/languages/_template/
├── AGENT_INSTRUCTIONS.md.template
├── README.md.template
└── templates/
    └── (example files)
```

### Usage
```bash
# Create new language plugin
cp -r plugins/languages/_template plugins/languages/go
cd plugins/languages/go
# Fill in templates
# Replace {{LANGUAGE_NAME}} with "Go"
# Add actual configurations
```

## Best Practices

### 1. Keep Plugins Focused
- One responsibility per plugin
- Clear boundaries
- Minimal dependencies

### 2. Document Everything
- Clear AGENT_INSTRUCTIONS.md
- Comprehensive README.md
- Inline comments in templates

### 3. Test Thoroughly
- Standalone installation
- Integration with other plugins
- All three test repos

### 4. Follow Patterns
- Look at existing plugins
- Use same structure
- Match naming conventions

### 5. Make It Obvious
- Clear file names
- Descriptive variables
- Explicit instructions

## Anti-Patterns

### ❌ Don't
- Create monolithic plugins (separate concerns)
- Hide dependencies (declare explicitly)
- Hardcode paths (use variables)
- Skip documentation (always document)
- Assume context (be explicit)

### ✅ Do
- Keep plugins focused
- Declare all dependencies
- Use template variables
- Document thoroughly
- Provide examples

---

**Remember**: Plugins should be so clear that an AI agent can install them without human intervention.
