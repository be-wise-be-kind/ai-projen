# How to Discover and Install Plugins

**Purpose**: Guide for discovering available plugins and installing them in your repository

**Scope**: Plugin discovery process from user intent to successful installation

**Overview**: Step-by-step guide for users and AI agents to discover what plugins are available,
    understand what each plugin provides, and successfully install plugins to add capabilities to
    a repository. Bridges the gap between "I need feature X" and "Install plugin Y".

**Dependencies**: PLUGIN_MANIFEST.yaml, PLUGIN_ARCHITECTURE.md

**Exports**: Clear discovery and installation workflow for all plugin types

**Related**: PLUGIN_ARCHITECTURE.md for structure details, AGENT_INSTRUCTIONS.md for installation steps

**Implementation**: Manifest-driven discovery with clear navigation path to installation

---

## Overview

### The Discovery Challenge

When you need to add a capability to your repository, you need to know:
1. **What's available?** - Which plugins exist?
2. **What does it do?** - What will this plugin provide?
3. **How do I get it?** - How do I install it?
4. **Where do files go?** - What gets added to my repository?

This guide provides the **discovery path** from user intent to successful installation.

---

## The Discovery Flow

### Visual Flow

```
User Intent: "I need [capability]"
         ↓
Step 1: Check PLUGIN_MANIFEST.yaml
         "What plugins are available?"
         ↓
Step 2: Review PLUGIN_ARCHITECTURE.md
         "How are plugins organized?"
         ↓
Step 3: Read plugin README.md
         "What does this specific plugin do?"
         ↓
Step 4: Follow AGENT_INSTRUCTIONS.md
         "How do I install it?"
         ↓
Step 5: Validate Installation
         "Did it work? Where are the files?"
         ↓
Result: Capability added to repository!
```

---

## Step 1: Check PLUGIN_MANIFEST.yaml

**Location**: `plugins/PLUGIN_MANIFEST.yaml`

**Purpose**: Central catalog of all available plugins

### How to Use

1. **Open the manifest**:
   ```bash
   cat plugins/PLUGIN_MANIFEST.yaml
   ```

2. **Find your capability category**:
   - **Languages**: `languages:` section
   - **Infrastructure**: `infrastructure:` section
   - **Standards**: `standards:` section
   - **Foundation**: `foundation:` section

3. **Check plugin status**:
   - `stable` - Production-ready, fully tested
   - `planned` - On roadmap, not yet implemented
   - `community` - Community-contributed
   - `experimental` - Available but may change

### Example: Finding Python Support

```yaml
languages:
  python:
    status: stable
    description: Python development environment with linting, formatting, and testing
    location: plugins/languages/python/
    dependencies:
      - foundation/ai-folder

    options:
      linters:
        available: [ruff, pylint, flake8]
        recommended: ruff

      formatters:
        available: [black]
        recommended: black

      testing:
        available: [pytest]
        recommended: pytest
```

**Key Information**:
- ✅ **Status**: `stable` (production-ready)
- 📍 **Location**: `plugins/languages/python/`
- 🔗 **Dependencies**: Requires `foundation/ai-folder`
- ⚙️ **Options**: Multiple linter choices, Black formatter, pytest testing

---

## Step 2: Understand Plugin Organization

**Location**: `.ai/docs/PLUGIN_ARCHITECTURE.md`

**Purpose**: Explains how plugins are structured and organized

### Plugin Taxonomy

```
plugins/
├── foundation/              # Universal (always required)
│   └── ai-folder/          # The .ai directory structure
│
├── languages/               # Language-specific tooling
│   ├── python/
│   │   ├── core/           # Core Python setup
│   │   ├── linters/        # Ruff, Pylint, Flake8
│   │   ├── formatters/     # Black
│   │   └── testing/        # pytest
│   └── typescript/
│       ├── core/
│       ├── linters/        # ESLint, Biome
│       ├── formatters/     # Prettier
│       └── testing/        # Vitest, Jest
│
├── infrastructure/
│   ├── containerization/
│   │   └── docker/         # Docker containers
│   ├── ci-cd/
│   │   └── github-actions/ # CI/CD workflows
│   └── iac/
│       └── terraform-aws/  # AWS infrastructure
│
└── standards/
    ├── security/           # Security scanning
    ├── documentation/      # Doc standards
    └── pre-commit-hooks/   # Quality gates
```

### Navigation Pattern

From PLUGIN_MANIFEST.yaml location, navigate to the plugin directory:

```bash
# Example: Python plugin
LOCATION=$(grep -A 3 "python:" plugins/PLUGIN_MANIFEST.yaml | grep "location:" | cut -d' ' -f6)
cd $LOCATION  # Now in plugins/languages/python/
```

---

## Step 3: Read Plugin Documentation

**Location**: `<plugin-directory>/README.md`

**Purpose**: Understand what the plugin provides and requires

### What to Look For

1. **Plugin Description**: What this plugin does
2. **Features Provided**: What capabilities you'll get
3. **Dependencies**: What must be installed first
4. **Configuration Options**: What choices you have
5. **Integration Points**: What other plugins it works with

### Example: Python Plugin README

**Key Information**:
- **Provides**: Linting (Ruff/Pylint/Flake8), Formatting (Black), Testing (pytest), Type checking (MyPy)
- **Requires**: Git repository, foundation/ai-folder plugin
- **Options**: Choose your linter, formatter, test framework
- **Integration**: Works with Docker, CI/CD, pre-commit hooks plugins

---

## Step 4: Follow Installation Instructions

**Location**: `<plugin-directory>/AGENT_INSTRUCTIONS.md`

**Purpose**: Step-by-step installation guide for AI agents (and humans)

### Installation Pattern

Every AGENT_INSTRUCTIONS.md follows this pattern:

```markdown
## Prerequisites
- Required tools and versions
- Dependencies that must be installed first

## Installation Steps
1. Gather configuration preferences
2. Install dependencies
3. Copy configuration files
4. Add Makefile targets
5. Extend agents.md
6. Update .ai/index.yaml

## Validation
- How to test the installation
- Expected outcomes

## Success Criteria
- Checklist of completion requirements
```

### Example: Installing Python Plugin

1. **Navigate to plugin**:
   ```bash
   cd plugins/languages/python/core/
   ```

2. **Read AGENT_INSTRUCTIONS.md**:
   ```bash
   cat AGENT_INSTRUCTIONS.md
   ```

3. **Follow the steps** (or point AI agent to the file):
   ```
   Prerequisites: ✅ Git initialized, ✅ .ai/ folder exists

   Step 1: Choose linter (Ruff recommended)
   Step 2: Choose formatter (Black recommended)
   Step 3: Choose test framework (pytest recommended)
   Step 4: Install dependencies via pip/poetry
   Step 5: Copy configs to repository root
   Step 6: Add Makefile targets
   Step 7: Extend agents.md with Python guidelines
   Step 8: Validate with make lint-python
   ```

---

## Step 5: Understand File Placement

### Where Do Files Go?

Different plugin types place files in different locations:

#### Foundation Plugins (ai-folder)
```
Repository Root/
├── agents.md                    # Primary AI entry point
└── .ai/
    ├── docs/
    ├── features/
    ├── howto/
    ├── templates/
    ├── index.yaml
    └── layout.yaml
```

#### Language Plugins (python, typescript)
```
Repository Root/
├── pyproject.toml              # Python dependencies & tool configs
├── .ruff.toml                  # Ruff linter config
├── pytest.ini                  # pytest config
├── Makefile.python             # Python Make targets
├── .github/
│   └── workflows/
│       └── python.yml          # CI/CD workflow
└── .ai/
    ├── docs/
    │   └── PYTHON_STANDARDS.md # Python standards doc
    └── howto/
        └── how-to-*.md         # Python how-tos
```

#### Infrastructure Plugins (docker)
```
Repository Root/
├── .docker/
│   ├── dockerfiles/
│   │   ├── Dockerfile.backend
│   │   └── Dockerfile.frontend
│   └── compose/
│       └── app.yml
├── docker-compose.yml
├── .dockerignore
├── Makefile.docker             # Docker Make targets
└── .ai/
    ├── docs/
    │   └── DOCKER_SETUP.md
    └── howto/
        ├── how-to-add-service.md
        └── how-to-create-multi-stage-dockerfile.md
```

#### Infrastructure Plugins (ci-cd)
```
Repository Root/
├── .github/
│   └── workflows/
│       ├── lint.yml
│       ├── test.yml
│       ├── build.yml
│       └── deploy.yml
└── .ai/
    ├── docs/
    │   └── CI_CD_PIPELINE.md
    └── howto/
        ├── how-to-add-workflow.md
        └── how-to-configure-secrets.md
```

#### Infrastructure Plugins (terraform-aws)
```
Repository Root/
├── infra/
│   └── terraform/
│       ├── workspaces/
│       │   ├── base/
│       │   └── runtime/
│       ├── backend-config/
│       └── shared/
├── Makefile.terraform          # Terraform Make targets
└── .ai/
    ├── docs/
    │   └── TERRAFORM_SETUP.md
    └── howto/
        ├── how-to-deploy-to-aws.md
        └── how-to-manage-state.md
```

#### Standards Plugins (pre-commit-hooks)
```
Repository Root/
├── .pre-commit-config.yaml     # Hook configuration
└── .ai/
    └── docs/
        └── PRE_COMMIT_HOOKS.md
```

---

## Common Discovery Scenarios

### Scenario 1: "I need Python linting"

**Discovery Path**:
```
1. Intent: "I need Python linting"
   ↓
2. Check PLUGIN_MANIFEST.yaml
   → languages/python exists (status: stable)
   → Options: ruff (recommended), pylint, flake8
   ↓
3. Navigate to plugins/languages/python/
   ↓
4. Read README.md
   → Provides: Complete Python tooling
   → Dependencies: foundation/ai-folder
   ↓
5. Check dependencies
   → foundation/ai-folder installed? If not, install first
   ↓
6. Follow plugins/languages/python/core/AGENT_INSTRUCTIONS.md
   → Step 1: Choose linter (Ruff)
   → Step 2: Follow linters/ruff/AGENT_INSTRUCTIONS.md
   → Step 3: Install, configure, validate
   ↓
7. Result: Python linting configured!
   → Files: .ruff.toml, Makefile.python, .ai/docs/PYTHON_STANDARDS.md
   → Commands: make lint-python
```

### Scenario 2: "I need Docker containerization"

**Discovery Path**:
```
1. Intent: "I need Docker containerization"
   ↓
2. Check PLUGIN_MANIFEST.yaml
   → infrastructure/containerization/docker exists (status: stable)
   ↓
3. Navigate to plugins/infrastructure/containerization/docker/
   ↓
4. Read README.md
   → Provides: Docker multi-stage builds, compose files
   → Dependencies: None (standalone)
   ↓
5. Follow AGENT_INSTRUCTIONS.md
   → Install Docker configs
   → Create Dockerfiles
   → Add compose files
   ↓
6. Result: Docker configured!
   → Files: .docker/*, docker-compose.yml, Makefile.docker
   → Commands: make build-all, make dev
```

### Scenario 3: "I need full-stack setup (Python + TypeScript + Docker + CI/CD)"

**Discovery Path**:
```
1. Intent: "I need full-stack setup"
   ↓
2. Check PLUGIN_MANIFEST.yaml
   → languages/python (stable)
   → languages/typescript (stable)
   → infrastructure/containerization/docker (stable)
   → infrastructure/ci-cd/github-actions (stable)
   ↓
3. Check dependencies
   → All require: foundation/ai-folder
   ↓
4. Installation order:
   a. foundation/ai-folder (required first)
   b. languages/python
   c. languages/typescript
   d. infrastructure/containerization/docker
   e. infrastructure/ci-cd/github-actions (integrates with a-d)
   ↓
5. Follow each AGENT_INSTRUCTIONS.md in order
   ↓
6. Result: Full-stack environment!
   → Python linting, TypeScript linting
   → Docker containers
   → GitHub Actions CI/CD
   → All integrated via Makefile
```

### Scenario 4: "I want to add a capability to existing repo"

**Discovery Path**:
```
1. Intent: "Add [capability] to existing repo"
   ↓
2. Check PLUGIN_MANIFEST.yaml
   → Find plugin for capability
   ↓
3. Check dependencies
   → Already installed? (check for .ai/, agents.md, config files)
   → Missing dependencies? (install first)
   ↓
4. Follow AGENT_INSTRUCTIONS.md
   → Plugin detects existing configs
   → Asks to backup/merge or skip
   → Integrates with existing setup
   ↓
5. Result: Capability added incrementally!
   → No conflicts with existing setup
   → New Make targets added
   → CI/CD workflows extended
```

---

## Discovery by Intent Mapping

### "I want to..."

| User Intent | Plugin Category | Specific Plugin | Location |
|-------------|-----------------|-----------------|----------|
| "...add Python support" | languages | python | `plugins/languages/python/` |
| "...add TypeScript support" | languages | typescript | `plugins/languages/typescript/` |
| "...containerize my app" | infrastructure/containerization | docker | `plugins/infrastructure/containerization/docker/` |
| "...add CI/CD" | infrastructure/ci-cd | github-actions | `plugins/infrastructure/ci-cd/github-actions/` |
| "...deploy to AWS" | infrastructure/iac | terraform-aws | `plugins/infrastructure/iac/terraform-aws/` |
| "...enforce security" | standards | security | `plugins/standards/security/` |
| "...add documentation standards" | standards | documentation | `plugins/standards/documentation/` |
| "...add pre-commit hooks" | standards | pre-commit-hooks | `plugins/standards/pre-commit-hooks/` |
| "...create .ai folder structure" | foundation | ai-folder | `plugins/foundation/ai-folder/` |

---

## Quick Reference: Discovery Commands

### Find Available Plugins
```bash
# List all available plugins
grep -E "^\s+\w+:" plugins/PLUGIN_MANIFEST.yaml

# Find plugin by keyword
grep -i "python" plugins/PLUGIN_MANIFEST.yaml

# Check plugin status
yq '.languages.python.status' plugins/PLUGIN_MANIFEST.yaml
```

### Navigate to Plugin
```bash
# From manifest location to plugin directory
PLUGIN_PATH=$(yq '.languages.python.location' plugins/PLUGIN_MANIFEST.yaml)
cd $PLUGIN_PATH
```

### Read Plugin Documentation
```bash
# Plugin overview
cat README.md

# Installation instructions
cat AGENT_INSTRUCTIONS.md

# Check dependencies
grep -A 5 "Dependencies:" AGENT_INSTRUCTIONS.md
```

### Validate Installation
```bash
# Check if plugin files exist
ls -la <expected-config-files>

# Test plugin functionality
make lint-python  # or make lint-ts, make docker-build, etc.

# Verify integration
grep "<plugin-content>" agents.md
```

---

## Troubleshooting Discovery

### Issue: "I don't know what plugins exist"

**Solution**: Start with PLUGIN_MANIFEST.yaml
```bash
cat plugins/PLUGIN_MANIFEST.yaml
# Browse categories: foundation, languages, infrastructure, standards
```

### Issue: "I found a plugin but don't know what it does"

**Solution**: Read the plugin README.md
```bash
cd plugins/<category>/<plugin-name>/
cat README.md
```

### Issue: "I don't know if I have dependencies installed"

**Solution**: Check AGENT_INSTRUCTIONS.md Prerequisites section
```bash
cd plugins/<category>/<plugin-name>/
grep -A 10 "Prerequisites" AGENT_INSTRUCTIONS.md
```

### Issue: "I installed a plugin but don't know where files went"

**Solution**: Check this guide's "File Placement" section or AGENT_INSTRUCTIONS.md
- Foundation plugins → `.ai/`, `agents.md`
- Language plugins → Config files (root), `.ai/docs/`, Makefile
- Infrastructure plugins → `.docker/`, `infra/`, `.github/workflows/`
- Standards plugins → `.ai/docs/`, configs (root)

### Issue: "I want a plugin that doesn't exist"

**Solution**: Create it! See `.ai/howto/how-to-create-a-*-plugin.md`
- Language plugin: `how-to-create-a-language-plugin.md`
- Infrastructure plugin: `how-to-create-an-infrastructure-plugin.md`
- Standards plugin: `how-to-create-a-standards-plugin.md`

---

## For AI Agents

### Automated Discovery Workflow

```python
# Pseudo-code for AI agent discovery

def discover_and_install_plugin(user_intent: str):
    # 1. Parse user intent
    capability = extract_capability(user_intent)  # "Python linting"

    # 2. Query manifest
    manifest = load_yaml("plugins/PLUGIN_MANIFEST.yaml")
    plugin = find_plugin_by_capability(manifest, capability)

    if not plugin:
        return "Plugin not found. Consider creating it!"

    # 3. Check dependencies
    for dep in plugin.dependencies:
        if not is_installed(dep):
            discover_and_install_plugin(dep)  # Recursive install

    # 4. Navigate to plugin
    plugin_path = plugin.location

    # 5. Read installation instructions
    instructions = read_file(f"{plugin_path}/AGENT_INSTRUCTIONS.md")

    # 6. Execute installation
    execute_steps(instructions)

    # 7. Validate
    validate_installation(instructions.success_criteria)

    return "Plugin installed successfully!"
```

### Agent-Friendly Navigation

**Start Point**: PLUGIN_MANIFEST.yaml
```yaml
# Agent reads this to discover available plugins
languages:
  python:
    location: plugins/languages/python/
    installation_guide: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
```

**Navigation**:
1. Read manifest → Get `location`
2. Navigate to `location`
3. Read `AGENT_INSTRUCTIONS.md`
4. Follow steps → Files placed automatically

---

## Summary

### The Discovery Path

```
User Says: "I need Python support"
           ↓
Step 1:    Check PLUGIN_MANIFEST.yaml → languages/python exists
           ↓
Step 2:    Read PLUGIN_ARCHITECTURE.md → Understand plugin organization
           ↓
Step 3:    Navigate to plugins/languages/python/
           ↓
Step 4:    Read README.md → What does Python plugin provide?
           ↓
Step 5:    Read AGENT_INSTRUCTIONS.md → How to install?
           ↓
Step 6:    Follow installation steps → Files placed in repo
           ↓
Result:    Python support added! ✅
```

### Key Takeaways

1. **PLUGIN_MANIFEST.yaml is the starting point** - Always check here first
2. **PLUGIN_ARCHITECTURE.md explains the structure** - Reference for organization
3. **README.md describes what you get** - Plugin overview and features
4. **AGENT_INSTRUCTIONS.md tells you how** - Step-by-step installation
5. **File placement is documented** - Know where everything goes

### Next Steps

- **For Users**: Use this guide to discover and install plugins
- **For AI Agents**: Automate discovery using manifest + AGENT_INSTRUCTIONS.md
- **For Developers**: Create new plugins using how-to-create-* guides

---

**Remember**: Discovery starts with the manifest, proceeds through architecture understanding, and ends with installation instructions. Every plugin is discoverable, installable, and self-documenting.
