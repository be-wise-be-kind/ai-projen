# How-To Integration Guide

**Purpose**: Documentation for how-to discovery, manifest integration, and agents.md presentation

**Scope**: How-to framework integration points across the ai-projen plugin system

**Overview**: This document explains how how-to guides integrate with the plugin manifest system,
    how AI agents discover available how-tos, and how they should be presented in agents.md
    for optimal discoverability and usability.

---

## Architecture Overview

The how-to framework operates at three levels:

### 1. Framework Level
- **Location**: `.ai/docs/`
- **Purpose**: Standards and templates for all how-tos
- **Files**:
  - `HOW_TO_TEMPLATE.md` - Master template
  - `HOWTO_STANDARDS.md` - Writing standards
  - `HOWTO_INTEGRATION.md` - This document

### 2. Plugin Level
- **Location**: `plugins/[category]/[plugin]/howtos/`
- **Purpose**: Plugin-specific how-to guides
- **Files**:
  - `README.md` - Index of plugin how-tos
  - `HOWTO_TEMPLATE.md` - Plugin-specific template
  - `how-to-*.md` - Actual how-to guides

### 3. Project Level
- **Location**: `.ai/howtos/` and `.ai/plugins/[plugin]/howtos/`
- **Purpose**: Project-specific and installed plugin how-tos
- **Files**:
  - Project-specific custom guides
  - Copied plugin how-tos from installations

---

## Plugin Manifest Integration

### Manifest Schema Extension

Add a `howtos` section to plugin manifests to declare available how-tos:

```yaml
# plugins/languages/python/manifest.yaml (example structure)

name: python
version: 1.0.0
status: stable
category: languages

# ... other manifest fields ...

howtos:
  directory: howtos/
  available:
    - name: setup-development-environment
      file: how-to-setup-development-environment.md
      title: "How to: Setup Development Environment"
      description: "Initial Python development environment setup and configuration"
      difficulty: beginner
      estimated_time: 15min
      prerequisites:
        - "Docker installed and running"
        - "Python 3.11+ available"
      tags:
        - getting-started
        - setup
        - environment
      templates_used:
        - templates/pyproject.toml.template
        - templates/pytest.ini.template
      related_howtos:
        - run-tests
        - run-linting
      related_docs:
        - docs/PYTHON_STANDARDS.md

    - name: add-api-endpoint
      file: how-to-add-api-endpoint.md
      title: "How to: Add a New API Endpoint"
      description: "Create FastAPI endpoints with automatic documentation"
      difficulty: intermediate
      estimated_time: 30min
      prerequisites:
        - "Python plugin installed"
        - "FastAPI knowledge recommended"
      tags:
        - api
        - fastapi
        - backend
      templates_used:
        - templates/fastapi-endpoint.py.template
        - templates/pydantic-model.py.template
      related_howtos:
        - write-unit-tests
        - implement-authentication
      related_docs:
        - docs/API_STANDARDS.md

    - name: write-unit-tests
      file: how-to-write-unit-tests.md
      title: "How to: Write Unit Tests"
      description: "Create comprehensive pytest test suites with coverage"
      difficulty: intermediate
      estimated_time: 30min
      prerequisites:
        - "Python plugin installed"
        - "pytest configured"
      tags:
        - testing
        - pytest
        - quality
      templates_used:
        - templates/pytest-test.py.template
      related_howtos:
        - run-tests
        - add-api-endpoint
      related_docs:
        - docs/TESTING_STANDARDS.md
```

### Manifest Field Definitions

#### Required Fields
- **name**: Unique identifier for the how-to (kebab-case)
- **file**: Filename in howtos/ directory
- **title**: Human-readable title (starts with "How to:")
- **description**: One-sentence description
- **difficulty**: beginner | intermediate | advanced
- **estimated_time**: Realistic time estimate

#### Optional Fields
- **prerequisites**: List of requirements before starting
- **tags**: Searchable/filterable keywords
- **templates_used**: Templates referenced in the guide
- **related_howtos**: Related how-to identifiers
- **related_docs**: Related documentation paths

### Validation Rules

When validating plugin manifests, check:

1. ✅ `howtos.directory` exists and contains files
2. ✅ Each `file` specified exists in `howtos.directory`
3. ✅ `difficulty` is one of: beginner, intermediate, advanced
4. ✅ `estimated_time` matches pattern: `\d+(min|hr)`
5. ✅ `templates_used` paths exist in plugin
6. ✅ `related_howtos` reference valid how-to names
7. ✅ All required fields are present

---

## Discovery Mechanisms

AI agents discover how-tos through multiple channels:

### 1. Plugin Manifest Discovery

When a plugin is installed, agents can query the manifest:

```python
# Pseudocode for how-to discovery
def discover_plugin_howtos(plugin_name):
    manifest = load_manifest(f"plugins/{category}/{plugin_name}/manifest.yaml")

    if "howtos" in manifest:
        howtos_dir = manifest["howtos"]["directory"]
        available_howtos = manifest["howtos"]["available"]

        for howto in available_howtos:
            yield {
                "plugin": plugin_name,
                "path": f"plugins/{category}/{plugin_name}/{howtos_dir}/{howto['file']}",
                "title": howto["title"],
                "difficulty": howto["difficulty"],
                "tags": howto.get("tags", [])
            }
```

### 2. Index-Based Discovery

The `.ai/index.yaml` provides project-level how-to information:

```yaml
# .ai/index.yaml (project using plugins)

plugins:
  installed:
    - name: python
      version: 1.0.0
      location: .ai/plugins/python/
      howtos:
        - path: .ai/plugins/python/howtos/how-to-setup-development-environment.md
          title: "How to: Setup Development Environment"
          category: getting-started
          difficulty: beginner
        - path: .ai/plugins/python/howtos/how-to-add-api-endpoint.md
          title: "How to: Add a New API Endpoint"
          category: api-development
          difficulty: intermediate

howtos:
  by_category:
    getting-started:
      - .ai/plugins/python/howtos/how-to-setup-development-environment.md
      - .ai/plugins/typescript/howtos/how-to-setup-react.md

    api-development:
      - .ai/plugins/python/howtos/how-to-add-api-endpoint.md
      - .ai/plugins/python/howtos/how-to-implement-authentication.md

    testing:
      - .ai/plugins/python/howtos/how-to-write-unit-tests.md
      - .ai/plugins/typescript/howtos/how-to-write-component-tests.md

    deployment:
      - .ai/plugins/docker/howtos/how-to-containerize-application.md
      - .ai/plugins/terraform/howtos/how-to-deploy-to-aws.md

  by_difficulty:
    beginner:
      - .ai/plugins/python/howtos/how-to-setup-development-environment.md
      - .ai/plugins/python/howtos/how-to-run-tests.md

    intermediate:
      - .ai/plugins/python/howtos/how-to-add-api-endpoint.md
      - .ai/plugins/python/howtos/how-to-write-unit-tests.md

    advanced:
      - .ai/plugins/python/howtos/how-to-implement-custom-linter.md
```

### 3. Direct README Discovery

Each plugin's `howtos/README.md` serves as a directory:

```bash
# AI agent workflow
1. Check if plugin has howtos/ directory
2. Read howtos/README.md for available guides
3. Filter by difficulty, tags, or category
4. Select appropriate how-to
5. Follow guide step-by-step
```

### 4. agents.md Integration

The primary `agents.md` file presents how-tos in context (see next section).

---

## agents.md Integration

### Structure for Presenting How-Tos

Include how-tos in `agents.md` to guide AI agents:

```markdown
# AI Agent Instructions

## Project Overview
[... project context ...]

## Available How-To Guides

This project uses the ai-projen plugin system. Each plugin provides how-to guides
for common tasks. How-tos are organized by category and difficulty.

### Quick Start Guides (Beginner)

Essential guides for getting started:

- **[Setup Development Environment](.ai/plugins/python/howtos/how-to-setup-development-environment.md)**
  - Initial Python development setup with Docker
  - Time: 15min | Prerequisites: Docker, Python 3.11+

- **[Run Tests](.ai/plugins/python/howtos/how-to-run-tests.md)**
  - Execute unit tests with pytest
  - Time: 5min | Prerequisites: Development environment setup

- **[Run Linting](.ai/plugins/python/howtos/how-to-run-linting.md)**
  - Code quality checks with Ruff
  - Time: 5min | Prerequisites: Development environment setup

### API Development (Intermediate)

Building backend features:

- **[Add API Endpoint](.ai/plugins/python/howtos/how-to-add-api-endpoint.md)**
  - Create FastAPI endpoints with automatic documentation
  - Time: 30min | Prerequisites: FastAPI basics
  - Templates: `fastapi-endpoint.py.template`, `pydantic-model.py.template`

- **[Implement Authentication](.ai/plugins/python/howtos/how-to-implement-authentication.md)**
  - Add JWT authentication to endpoints
  - Time: 45min | Prerequisites: API endpoint creation
  - Related: how-to-add-api-endpoint.md

- **[Add Database Model](.ai/plugins/python/howtos/how-to-add-database-model.md)**
  - Create SQLAlchemy models with migrations
  - Time: 30min | Prerequisites: Database setup
  - Templates: `sqlalchemy-model.py.template`

### Frontend Development (Intermediate)

Building UI components:

- **[Create React Component](.ai/plugins/typescript/howtos/how-to-create-react-component.md)**
  - Build React components with TypeScript
  - Time: 30min | Prerequisites: React basics
  - Templates: `react-component.tsx.template`

- **[Implement WebSocket](.ai/plugins/typescript/howtos/how-to-implement-websocket-react.md)**
  - Real-time data with WebSocket in React
  - Time: 45min | Prerequisites: React hooks, WebSocket basics
  - Templates: `websocket-service.ts.template`, `websocket-hook.ts.template`

### Testing (Intermediate)

Quality assurance:

- **[Write Unit Tests](.ai/plugins/python/howtos/how-to-write-unit-tests.md)**
  - Comprehensive pytest test coverage
  - Time: 30min | Prerequisites: pytest basics
  - Templates: `pytest-test.py.template`

- **[Write Component Tests](.ai/plugins/typescript/howtos/how-to-write-component-tests.md)**
  - Test React components with Vitest
  - Time: 30min | Prerequisites: Component creation
  - Templates: `vitest-component-test.ts.template`

### Deployment (Intermediate - Advanced)

Production deployment:

- **[Containerize Application](.ai/plugins/docker/howtos/how-to-containerize-application.md)**
  - Create Docker containers for services
  - Time: 45min | Difficulty: Intermediate
  - Templates: `Dockerfile.template`, `docker-compose.yml.template`

- **[Deploy to AWS](.ai/plugins/terraform/howtos/how-to-deploy-to-aws.md)**
  - Infrastructure as Code with Terraform
  - Time: 1hr | Difficulty: Advanced
  - Prerequisites: AWS account, Terraform knowledge

### Advanced Topics

Complex integrations and optimizations:

- **[Implement Custom Linter](.ai/plugins/python/howtos/how-to-implement-custom-linter.md)**
  - Create custom linting rules
  - Time: 1hr+ | Difficulty: Advanced
  - Prerequisites: AST understanding, linter framework

- **[Optimize Performance](.ai/plugins/python/howtos/how-to-optimize-performance.md)**
  - Profile and optimize Python code
  - Time: 1hr+ | Difficulty: Advanced
  - Prerequisites: Profiling tools, optimization strategies

## How to Use How-Tos

### For AI Agents

1. **Identify Task**: Determine what you need to accomplish
2. **Find Guide**: Search by category, difficulty, or tags
3. **Check Prerequisites**: Verify all requirements are met
4. **Follow Steps**: Execute each step sequentially
5. **Verify**: Run verification commands
6. **Troubleshoot**: Consult common issues if problems occur

### Discovery Methods

- **By Category**: Browse sections above
- **By Difficulty**: Filter beginner/intermediate/advanced
- **By Plugin**: Check `.ai/plugins/[plugin]/howtos/README.md`
- **By Search**: Look for keywords in titles/descriptions

### Template Integration

Many how-tos reference templates. Copy and customize:

```bash
# From plugin repository
cp plugins/[category]/[plugin]/templates/[name].template destination

# From installed plugin
cp .ai/plugins/[plugin]/templates/[name].template destination
```

## Related Resources

- **How-To Standards**: `.ai/docs/HOWTO_STANDARDS.md`
- **How-To Template**: `.ai/docs/HOW_TO_TEMPLATE.md`
- **Plugin Index**: `.ai/index.yaml`
- **Plugin Manifest**: `plugins/PLUGIN_MANIFEST.yaml`
```

### Best Practices for agents.md

1. **Group by Category**: Organize by functional area (API, Frontend, Testing, etc.)
2. **Show Difficulty**: Mark beginner/intermediate/advanced clearly
3. **List Prerequisites**: Help agents determine if they can proceed
4. **Include Time Estimates**: Set expectations for task duration
5. **Link Templates**: Show which templates are used
6. **Cross-Reference**: Link related how-tos
7. **Keep Updated**: Reflect current plugin installations

---

## Project-Level How-To Index

When plugins are installed in a project, maintain an index:

### .ai/index.yaml (Project)

```yaml
howtos:
  # All available how-tos across installed plugins
  available:
    - plugin: python
      name: setup-development-environment
      path: .ai/plugins/python/howtos/how-to-setup-development-environment.md
      title: "How to: Setup Development Environment"
      difficulty: beginner
      category: getting-started

    - plugin: python
      name: add-api-endpoint
      path: .ai/plugins/python/howtos/how-to-add-api-endpoint.md
      title: "How to: Add a New API Endpoint"
      difficulty: intermediate
      category: api-development

  # Organized by category
  by_category:
    getting-started:
      - .ai/plugins/python/howtos/how-to-setup-development-environment.md
      - .ai/plugins/typescript/howtos/how-to-setup-react.md

    api-development:
      - .ai/plugins/python/howtos/how-to-add-api-endpoint.md
      - .ai/plugins/python/howtos/how-to-implement-authentication.md

    testing:
      - .ai/plugins/python/howtos/how-to-write-unit-tests.md
      - .ai/plugins/typescript/howtos/how-to-write-component-tests.md

  # Organized by difficulty
  by_difficulty:
    beginner:
      - .ai/plugins/python/howtos/how-to-setup-development-environment.md
    intermediate:
      - .ai/plugins/python/howtos/how-to-add-api-endpoint.md
    advanced:
      - .ai/plugins/python/howtos/how-to-implement-custom-linter.md

  # Organized by plugin
  by_plugin:
    python:
      - .ai/plugins/python/howtos/how-to-setup-development-environment.md
      - .ai/plugins/python/howtos/how-to-add-api-endpoint.md
      - .ai/plugins/python/howtos/how-to-write-unit-tests.md

    typescript:
      - .ai/plugins/typescript/howtos/how-to-setup-react.md
      - .ai/plugins/typescript/howtos/how-to-create-react-component.md

  # Custom project how-tos
  project_specific:
    - path: .ai/howtos/how-to-deploy-this-project.md
      title: "How to: Deploy This Specific Project"
      difficulty: intermediate
      category: deployment
```

---

## Search and Filter Mechanisms

### By Difficulty

```bash
# Pseudocode for filtering by difficulty
def find_howtos_by_difficulty(difficulty):
    index = load_index(".ai/index.yaml")
    return index["howtos"]["by_difficulty"][difficulty]

# Usage
beginner_guides = find_howtos_by_difficulty("beginner")
```

### By Category

```bash
# Pseudocode for filtering by category
def find_howtos_by_category(category):
    index = load_index(".ai/index.yaml")
    return index["howtos"]["by_category"][category]

# Usage
api_guides = find_howtos_by_category("api-development")
```

### By Tags

```bash
# Pseudocode for tag-based search
def find_howtos_by_tag(tag):
    results = []
    for plugin in installed_plugins:
        manifest = load_manifest(f"plugins/{plugin}/manifest.yaml")
        for howto in manifest.get("howtos", {}).get("available", []):
            if tag in howto.get("tags", []):
                results.append(howto)
    return results

# Usage
testing_guides = find_howtos_by_tag("testing")
```

### By Prerequisites

```bash
# Pseudocode for finding guides agent can complete
def find_available_howtos(met_prerequisites):
    available = []
    for howto in all_howtos:
        if all(prereq in met_prerequisites for prereq in howto["prerequisites"]):
            available.append(howto)
    return available

# Usage
current_prereqs = ["Docker installed", "Python 3.11+"]
doable_guides = find_available_howtos(current_prereqs)
```

---

## Installation and Updates

### Plugin Installation

When a plugin is installed:

1. Copy `howtos/` directory to `.ai/plugins/[plugin]/howtos/`
2. Update `.ai/index.yaml` with new how-tos
3. Update `agents.md` with how-to references
4. Generate category and difficulty indexes

### Plugin Update

When a plugin is updated:

1. Compare old and new manifest `howtos` sections
2. Identify added, removed, or modified how-tos
3. Update `.ai/index.yaml` accordingly
4. Update `agents.md` if structure changed
5. Notify user of new how-tos available

### Removal

When a plugin is removed:

1. Remove how-tos from `.ai/index.yaml`
2. Remove directory `.ai/plugins/[plugin]/howtos/`
3. Update `agents.md` to remove references
4. Regenerate indexes

---

## Versioning and Compatibility

### How-To Versioning

Track how-to versions in manifest:

```yaml
howtos:
  version: 1.0.0  # Overall howtos collection version
  available:
    - name: add-api-endpoint
      version: 1.2.0  # Individual how-to version
      file: how-to-add-api-endpoint.md
      changelog:
        - version: 1.2.0
          changes: "Added WebSocket endpoint example"
        - version: 1.1.0
          changes: "Updated for FastAPI 0.100+"
        - version: 1.0.0
          changes: "Initial version"
```

### Compatibility Notes

Include compatibility information:

```yaml
    - name: add-api-endpoint
      file: how-to-add-api-endpoint.md
      compatible_with:
        python: ">=3.11"
        fastapi: ">=0.100"
        plugin_version: ">=1.0.0"
      breaking_changes:
        - version: 1.2.0
          description: "Requires FastAPI 0.100+ for new async patterns"
```

---

## Summary

### Key Integration Points

1. **Plugin Manifest**: Declares available how-tos with metadata
2. **.ai/index.yaml**: Project-level how-to index and categorization
3. **agents.md**: Primary presentation layer for AI agents
4. **howtos/README.md**: Plugin-level index and discovery

### Discovery Flow

```
AI Agent Task
    ↓
Check agents.md for relevant section
    ↓
Find how-to by category/difficulty/tag
    ↓
Verify prerequisites met
    ↓
Follow how-to step-by-step
    ↓
Execute verification
    ↓
Task complete
```

### Maintenance Responsibilities

**Framework Maintainers**:
- Keep HOW_TO_TEMPLATE.md current
- Update HOWTO_STANDARDS.md with best practices
- Ensure discovery mechanisms work

**Plugin Authors**:
- Create how-tos for common plugin tasks
- Maintain howtos/ directory and README
- Update manifest with accurate metadata
- Test how-tos work as documented

**Project Users**:
- Keep .ai/index.yaml current with installed plugins
- Update agents.md when plugins change
- Add project-specific how-tos as needed

---

**Version**: 1.0
**Last Updated**: 2025-10-01
**Maintained By**: ai-projen framework
