# How to Create a Standards Plugin

**Purpose**: Step-by-step guide for creating new standards plugins for ai-projen

**Scope**: Complete workflow from template copying to PR submission for cross-cutting standards (security, documentation, pre-commit hooks, code quality)

**Overview**: Comprehensive, actionable guide for developers who want to add standards enforcement to ai-projen.
    Standards plugins differ from language and infrastructure plugins by providing cross-cutting concerns that
    apply to all languages and infrastructure setups. Covers documentation standards, security standards,
    code quality standards, testing standards, and process standards (pre-commit hooks, PR templates).
    Uses Security, Documentation, and Pre-commit Hooks plugins as reference implementations.

**Dependencies**: foundation/ai-folder plugin, PLUGIN_MANIFEST.yaml, optionally language plugins for integration

**Exports**: Knowledge for creating security, documentation, testing, accessibility, performance, or any standards plugin

**Related**: PLUGIN_ARCHITECTURE.md for structure requirements, how-to-create-a-language-plugin.md, how-to-create-an-infrastructure-plugin.md

**Implementation**: Template-based plugin creation with conditional integration based on detected project context

---

## Overview

### What is a Standards Plugin?

A standards plugin provides cross-cutting standards and enforcement mechanisms including:
- **Security Standards** - Secrets management, dependency scanning, code scanning, vulnerability management
- **Documentation Standards** - API docs, README templates, docstring standards, changelog requirements
- **Code Quality Standards** - Code review guidelines, complexity limits, test coverage requirements
- **Process Standards** - Pre-commit hooks, PR templates, branch naming, commit message formats
- **Accessibility Standards** - WCAG compliance, semantic HTML, ARIA labels, keyboard navigation
- **Performance Standards** - Load time targets, bundle size limits, resource optimization

### Why Create a Standards Plugin?

Standards plugins enable:
- **Consistent Quality** - Enforce standards across all projects
- **Early Detection** - Catch issues before CI/CD or code review
- **Cross-Language Applicability** - Apply to Python, TypeScript, Go, etc.
- **AI Agent Compatibility** - Clear instructions for automated enforcement
- **Standalone Functionality** - Works without orchestrator
- **Community Contributions** - Easy to share best practices

### Architecture Philosophy

Each standards plugin must:
1. **Work Standalone** - Install and function without orchestrator
2. **Be Language-Agnostic** - Apply to any language (or detect and adapt)
3. **Provide Documentation** - Comprehensive standards documentation
4. **Offer Automation** - Scripts, hooks, or CI/CD for enforcement
5. **Integrate Cleanly** - Detect existing plugins and adapt
6. **Document Clearly** - Provide AGENT_INSTRUCTIONS.md for AI agents
7. **Support Gradual Adoption** - Allow incremental rollout

---

## Standards Plugin Categories

### 1. Security Standards Plugins

**Location**: `plugins/standards/security/`

**Purpose**: Prevent security vulnerabilities and enforce security best practices

**Key Components**:
- Secrets management (never commit secrets, .env patterns)
- Dependency vulnerability scanning (Safety, npm audit)
- Code security scanning (Bandit, ESLint security)
- CI/CD security workflows
- Security documentation and how-tos

**Example**: Security Standards Plugin (PR13)

### 2. Documentation Standards Plugins

**Location**: `plugins/standards/documentation/`

**Purpose**: Enforce documentation quality and completeness

**Key Components**:
- File header standards (purpose, scope, overview)
- API documentation requirements (OpenAPI, JSDoc)
- README templates (project overview, installation, usage)
- Docstring standards (Google style, NumPy style)
- Changelog requirements (Keep a Changelog format)

**Example**: Documentation Standards Plugin (PR14)

### 3. Process Standards Plugins

**Location**: `plugins/standards/pre-commit-hooks/`, `plugins/standards/pr-templates/`

**Purpose**: Enforce development process standards

**Key Components**:
- Pre-commit hooks (secret scanning, linting, formatting)
- PR templates (description, testing, breaking changes)
- Commit message format (Conventional Commits)
- Branch naming conventions
- Code review checklists

**Example**: Pre-commit Hooks Plugin (PR15)

### 4. Code Quality Standards Plugins

**Location**: `plugins/standards/code-quality/`

**Purpose**: Enforce code quality metrics and best practices

**Key Components**:
- Test coverage requirements (80%+ target)
- Code complexity limits (cyclomatic complexity)
- Duplicate code detection (jscpd, PMD-CPD)
- Code review standards
- Refactoring guidelines

### 5. Accessibility Standards Plugins

**Location**: `plugins/standards/accessibility/`

**Purpose**: Enforce web accessibility standards (WCAG)

**Key Components**:
- WCAG compliance checking (axe-core, Pa11y)
- Semantic HTML enforcement
- ARIA label validation
- Keyboard navigation testing
- Color contrast checking

### 6. Performance Standards Plugins

**Location**: `plugins/standards/performance/`

**Purpose**: Enforce performance budgets and optimization

**Key Components**:
- Load time targets (Lighthouse)
- Bundle size limits (webpack-bundle-analyzer)
- Image optimization (ImageOptim, Squoosh)
- Resource hints (preload, prefetch)
- Performance monitoring (Web Vitals)

---

## Prerequisites

Before creating a standards plugin, ensure you have:

### Technical Requirements
- ✅ **Git repository** - ai-projen cloned locally
- ✅ **Understanding of standard** - Deep knowledge of the practice you're enforcing
- ✅ **Tools identified** - Know which tools enforce the standard
- ✅ **Examples collected** - Real-world examples of good/bad practices

### Knowledge Requirements
- ✅ **Industry best practices** - Understand widely-adopted standards
- ✅ **Tool ecosystem** - Know enforcement tools and their tradeoffs
- ✅ **Integration patterns** - How to integrate with language/infrastructure plugins
- ✅ **Documentation writing** - Ability to write clear, actionable guides

### Framework Familiarity
- ✅ Read `PLUGIN_ARCHITECTURE.md` - Understand plugin structure
- ✅ Read `PLUGIN_MANIFEST.yaml` - See existing plugin definitions
- ✅ Review `plugins/standards/security/` - See reference implementation
- ✅ Check existing standards plugins - Understand patterns

---

## Step-by-Step Guide

### Step 1: Choose Your Standards Category

Determine what type of standards plugin you're creating:

```bash
# Security standards (secrets, vulnerabilities, security scanning)
cd plugins/standards/

# Create your standards plugin directory
mkdir -p <standard-name>/
cd <standard-name>/

# Examples:
# mkdir -p security/              # Security standards (PR13)
# mkdir -p documentation/         # Documentation standards (PR14)
# mkdir -p pre-commit-hooks/      # Pre-commit hooks (PR15)
# mkdir -p accessibility/         # Accessibility standards
# mkdir -p performance/           # Performance standards
```

**Naming Convention**:
- Use lowercase with hyphens: `security`, `documentation`, `pre-commit-hooks`
- Use descriptive names: `accessibility` not `a11y`, `performance` not `perf`
- Focus on the standard, not the tool: `security` not `bandit-plugin`

### Step 2: Understand Standards Plugin Structure

Standards plugins have a specific internal organization:

```
plugins/standards/<standard-name>/
├── AGENT_INSTRUCTIONS.md              # AI installation guide
├── README.md                          # Human documentation
│
├── ai-content/                        # → Goes to .ai/ in target repo
│   ├── docs/                         # Standards documentation
│   │   ├── <STANDARD>_STANDARDS.md   # Main standards doc
│   │   └── *.md                      # Detailed guides
│   ├── howtos/                       # Task-specific how-tos
│   │   ├── README.md                 # How-to index
│   │   └── how-to-*.md              # Individual guides
│   ├── templates/                    # Templates for standards
│   │   ├── *.template               # Various templates
│   │   └── *.example                # Example files
│   └── standards/                    # Additional standards docs
│
└── project-content/                   # → Goes to repo root
    ├── config/                       # Config files if needed
    ├── scripts/                      # Enforcement scripts
    └── workflows/                    # CI/CD workflows
```

### Step 3: Create Plugin README.md

Write a comprehensive README for human readers:

**File**: `README.md`

```markdown
# <Standard Name> Standards Plugin

**Purpose**: Brief description of what standards this plugin enforces

**Scope**: What areas/languages this plugin covers

**Overview**: Comprehensive description of the standards, enforcement mechanisms,
    integration points, and benefits. Should include what problems this solves
    and how it helps maintain quality/security/consistency.

**Dependencies**: Required plugins (typically foundation/ai-folder)

**Exports**: Documentation files, templates, enforcement scripts, CI/CD workflows

**Related**: Related plugins (language plugins, infrastructure plugins)

**Implementation**: How the plugin works and integrates

---

## What is the <Standard Name> Standards Plugin?

Explain the plugin's purpose and value proposition.

---

## Features

List key features with checkboxes:

### <Feature Category 1>
- ✅ Feature 1 description
- ✅ Feature 2 description
- ✅ Feature 3 description

### <Feature Category 2>
- ✅ Feature 1 description
- ✅ Feature 2 description

### Integration
- ✅ Language plugin integration
- ✅ Infrastructure plugin integration
- ✅ CI/CD integration

---

## Quick Start

### Prerequisites

List prerequisites

### Installation

Provide quick installation instructions

### Verification

Show how to verify installation

---

## What Gets Installed

### Documentation

List all documentation files and their purposes

### How-To Guides

List all how-to guides

### Templates

List all templates

### Scripts/Workflows

List any scripts or workflows

---

## Usage Examples

Provide concrete usage examples

---

## Integration Examples

Show integration with other plugins

---

## Configuration

Explain customization options

---

## Best Practices

List best practices for using the standard

---

## Troubleshooting

Common issues and solutions

---

## Security Checklist / Standards Checklist

Provide a checklist for compliance

---

## Additional Resources

Links to documentation and external resources
```

### Step 4: Create AGENT_INSTRUCTIONS.md

Write step-by-step installation instructions for AI agents:

**File**: `AGENT_INSTRUCTIONS.md`

```markdown
# <Standard Name> Standards Plugin - Agent Instructions

**Purpose**: Installation and configuration guide for AI agents implementing <standard> in projects

**Scope**: <Brief description of what the standard covers>

**Overview**: Step-by-step instructions for AI agents to install and configure the <Standard Name> Plugin.
    Explain what the plugin provides, how it integrates with other plugins, and what enforcement
    mechanisms it includes.

**Dependencies**: List required plugins (foundation, language plugins, etc.)

**Exports**: List what files/docs this plugin creates

**Related**: Related plugins and documentation

**Implementation**: Template-based installation with conditional integration

---

## Prerequisites

Before installing this plugin, verify:

1. **Foundation Plugin Installed**
   ```bash
   test -d .ai && echo "✓ Foundation plugin present" || echo "✗ Install foundation plugin first"
   ```

2. **Git Repository Initialized**
   ```bash
   git rev-parse --git-dir >/dev/null 2>&1 && echo "✓ Git repository" || echo "✗ Initialize git first"
   ```

3. **Optional: Related Plugins**
   List optional plugins that enhance this standard

---

## Installation Steps

### Step 1: Copy Standards Documentation

```bash
# Copy main standards document
cp plugins/standards/<standard-name>/ai-content/standards/<STANDARD>_STANDARDS.md .ai/docs/

# Copy additional documentation
cp plugins/standards/<standard-name>/ai-content/docs/*.md .ai/docs/
```

### Step 2: Copy How-To Guides

```bash
# Create howtos directory if it doesn't exist
mkdir -p .ai/howto

# Copy how-to guides
cp plugins/standards/<standard-name>/ai-content/howtos/how-to-*.md .ai/howto/
```

### Step 3: Install Templates

```bash
# Copy templates to appropriate locations
cp plugins/standards/<standard-name>/ai-content/templates/*.template ./
```

### Step 4: Configure Language-Specific Integration (if applicable)

```bash
# Detect language plugins and configure accordingly
if [ -f pyproject.toml ]; then
  echo "✓ Python project detected"
  # Python-specific configuration
fi

if [ -f package.json ]; then
  echo "✓ TypeScript/Node project detected"
  # TypeScript-specific configuration
fi
```

### Step 5: Install Enforcement Mechanisms (Optional)

```bash
# Install pre-commit hooks, CI/CD workflows, or scripts
if [ -d .git/hooks ]; then
  # Configure enforcement
fi

if [ -d .github/workflows ]; then
  # Copy CI/CD workflow
  cp plugins/standards/<standard-name>/project-content/workflows/*.yml .github/workflows/
fi
```

### Step 6: Update .ai/index.yaml

```yaml
# Add to .ai/index.yaml under 'standards' section
standards:
  <standard-name>:
    description: "Brief description"
    documentation:
      - path: "docs/<STANDARD>_STANDARDS.md"
        description: "Main standards document"
    howtos:
      - path: "howto/how-to-*.md"
        description: "Task-specific guide"
```

### Step 7: Update agents.md (Optional)

If the project has agents.md, add standards reference:

```markdown
## <Standard Name> Standards

This project follows <standard> standards documented in `.ai/docs/<STANDARD>_STANDARDS.md`.

Key practices:
- Practice 1
- Practice 2
- Practice 3

See `.ai/howto/how-to-*.md` for detailed guidance.
```

---

## Post-Installation Validation

### Check Documentation

```bash
test -f .ai/docs/<STANDARD>_STANDARDS.md && echo "✓ Standards documented"
```

### Check Templates

```bash
test -f <template-file> && echo "✓ Templates present"
```

### Test Enforcement (if applicable)

```bash
# Run enforcement tools
<command-to-test>
```

---

## Integration with Other Plugins

### <Plugin Type> Integration

Explain how this standard integrates with language plugins, infrastructure plugins, etc.

---

## Configuration Customization

Explain how to customize the standard for specific projects

---

## Troubleshooting

Common issues and solutions

---

## Best Practices

Key practices for using this standard

---

## Success Criteria

After installation, verify:
- ✅ Documentation present in `.ai/docs/`
- ✅ How-tos present in `.ai/howto/`
- ✅ Templates installed
- ✅ Enforcement configured (if applicable)
- ✅ `.ai/index.yaml` references standard

---

## Next Steps

After installation:
1. Review standards documentation
2. Customize templates
3. Test enforcement
4. Train team
```

### Step 5: Create Standards Documentation

Create the main standards document:

**File**: `ai-content/standards/<STANDARD>_STANDARDS.md`

**Example Structure (Security Standards)**:

```markdown
# <Standard Name> Standards

**Purpose**: Define comprehensive <standard> requirements for consistent <quality/security/etc> across projects

**Scope**: All <code/documentation/processes> in the project

**Overview**: Establishes unified <standard> standards ensuring <benefit>. Covers <topic1>,
    <topic2>, <topic3>, and enforcement mechanisms. Integrates with language plugins and
    CI/CD for automated validation.

**Dependencies**: Related standards and tools

**Exports**: Standards specifications, validation rules, enforcement guidelines

**Related**: Related documentation

**Implementation**: How standards are implemented and enforced

---

## Overview

Explain the standard and why it matters

## Standard Requirements

### Requirement Category 1

**Requirement 1.1**: Description
- What: What is required
- Why: Why it matters
- How: How to implement
- Validation: How to validate

**Requirement 1.2**: Description
- What: What is required
- Why: Why it matters
- How: How to implement
- Validation: How to validate

### Requirement Category 2

Similar structure...

## Enforcement

Explain how standards are enforced:
- Local development (pre-commit hooks, linters)
- CI/CD (automated checks)
- Code review (manual verification)

## Validation

Explain how to validate compliance

## Exceptions

Explain when exceptions are acceptable and how to document them

## Examples

### Good Examples

Show compliant examples

### Bad Examples

Show non-compliant examples with explanations

## Tools

List tools that help enforce the standard

## Checklist

Provide a compliance checklist

## Additional Resources

Links to external standards, documentation, etc.
```

### Step 6: Create How-To Guides

Create task-specific how-to guides:

**File**: `ai-content/howtos/README.md`

```markdown
# <Standard Name> How-To Guides

**Purpose**: Index of task-specific guides for implementing <standard>

**Scope**: Practical guides for common <standard> tasks

This directory contains step-by-step guides for specific tasks:

## Available Guides

1. **[how-to-<task1>.md](./how-to-<task1>.md)**
   - Brief description of task 1

2. **[how-to-<task2>.md](./how-to-<task2>.md)**
   - Brief description of task 2

3. **[how-to-<task3>.md](./how-to-<task3>.md)**
   - Brief description of task 3

## When to Use These Guides

- **Initial Setup**: Use guides 1 and 2 when first setting up <standard>
- **Ongoing Maintenance**: Use guide 3 for regular maintenance
- **Troubleshooting**: See individual guides for troubleshooting sections

## Related Documentation

- Main standards: `.ai/docs/<STANDARD>_STANDARDS.md`
- Plugin README: `plugins/standards/<standard-name>/README.md`
```

**File**: `ai-content/howtos/how-to-<task>.md`

```markdown
# How to <Task>

**Purpose**: Step-by-step guide for <task> in <standard> context

**Scope**: <What this guide covers>

**Overview**: Practical guide for <task> including prerequisites, step-by-step instructions,
    verification, troubleshooting, and examples.

**Prerequisites**: What you need before starting

**Expected Time**: Estimated time to complete

---

## Overview

Explain what this task accomplishes and why it's important

## Prerequisites

List prerequisites:
- ✅ Prerequisite 1
- ✅ Prerequisite 2
- ✅ Prerequisite 3

## Step-by-Step Instructions

### Step 1: <Action>

Detailed instructions for step 1

```bash
# Example commands
<command>
```

Expected output:
```
<output>
```

### Step 2: <Action>

Detailed instructions for step 2

### Step 3: <Action>

Continue with all steps...

## Verification

How to verify the task was completed successfully:

```bash
# Verification commands
<command>
```

Expected result: <description>

## Common Issues

### Issue 1: <Description>

**Symptom**: What you see when this issue occurs

**Cause**: Why this happens

**Solution**: How to fix it

```bash
# Solution commands
<command>
```

### Issue 2: <Description>

Similar structure...

## Examples

### Example 1: <Scenario>

Complete example showing the task in context

### Example 2: <Scenario>

Another example

## Best Practices

- ✅ Best practice 1
- ✅ Best practice 2
- ✅ Best practice 3

## Related Guides

- Link to related how-to guide 1
- Link to related how-to guide 2

## Additional Resources

External links and references
```

### Step 7: Create Templates

Create templates that users will copy to their projects:

**File**: `ai-content/templates/<template-name>.template`

For example, `.gitignore.security.template`:

```
# Security - Secrets and Credentials
# Added by security standards plugin

# Environment files
.env
.env.local
.env.*.local
*.env

# Credentials
credentials.json
credentials.yml
secrets.json
secrets.yml

# SSH keys
*.pem
*.key
id_rsa
id_dsa

# Certificates
*.crt
*.cer
*.p12
*.pfx

# Cloud credentials
.aws/credentials
.gcp/credentials.json
.azure/credentials

# Terraform secrets
*.secret.tfvars
*.auto.tfvars

# Database files
*.db
*.sqlite
*.sqlite3

# Configuration files with secrets
config/production.yml
config/secrets.yml
```

### Step 8: Create Enforcement Scripts (Optional)

If your standard requires active enforcement:

**File**: `project-content/scripts/<script-name>.sh`

```bash
#!/bin/bash
# <Script Name>
# Purpose: Enforce <standard> in project

set -e

echo "Checking <standard> compliance..."

# Check 1
if [ -f <file> ]; then
  echo "✓ Check 1 passed"
else
  echo "✗ Check 1 failed: <reason>"
  exit 1
fi

# Check 2
<command> || {
  echo "✗ Check 2 failed: <reason>"
  exit 1
}

echo "✓ All <standard> checks passed"
```

### Step 9: Create CI/CD Workflow (Optional)

If your standard should be enforced in CI/CD:

**File**: `project-content/workflows/<standard>-check.yml`

```yaml
name: <Standard> Compliance Check

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  <standard>-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Check <Standard> Requirement 1
        run: |
          # Check implementation
          <command>

      - name: Check <Standard> Requirement 2
        run: |
          # Check implementation
          <command>

      - name: Report Results
        if: failure()
        run: |
          echo "::error::<Standard> compliance check failed"
          echo "See .ai/docs/<STANDARD>_STANDARDS.md for requirements"
          exit 1
```

### Step 10: Update PLUGIN_MANIFEST.yaml

Add your plugin to the manifest:

**File**: `plugins/PLUGIN_MANIFEST.yaml`

```yaml
standards:
  <standard-name>:
    status: community  # or 'stable' if officially supported
    description: <Brief description of the standard>
    location: plugins/standards/<standard-name>/
    dependencies:
      - foundation/ai-folder

    features:
      documentation:
        - <STANDARD>_STANDARDS.md
        - Additional documentation files
      howtos:
        - how-to-<task1>.md
        - how-to-<task2>.md
      templates:
        - <template1>
        - <template2>
      enforcement:
        - CI/CD workflows
        - Pre-commit hooks
        - Validation scripts

    integration:
      language_plugins:
        - python
        - typescript
      infrastructure_plugins:
        - github-actions
        - docker

    installation_guide: plugins/standards/<standard-name>/AGENT_INSTRUCTIONS.md
```

---

## File Structure Summary

A complete standards plugin should have this structure:

```
plugins/standards/<standard-name>/
├── AGENT_INSTRUCTIONS.md              # AI installation guide
├── README.md                          # Human documentation
│
├── ai-content/                        # → Goes to .ai/ in target repo
│   ├── docs/                         # Standards documentation
│   │   ├── <topic1>.md               # Detailed guides
│   │   ├── <topic2>.md
│   │   └── <topic3>.md
│   │
│   ├── howtos/                       # Task-specific how-tos
│   │   ├── README.md                 # How-to index
│   │   ├── how-to-<task1>.md
│   │   ├── how-to-<task2>.md
│   │   └── how-to-<task3>.md
│   │
│   ├── standards/                    # Main standards docs
│   │   └── <STANDARD>_STANDARDS.md   # Primary standards doc
│   │
│   └── templates/                    # Templates and examples
│       ├── <template1>.template
│       ├── <template2>.template
│       └── <example>.example
│
└── project-content/                   # → Goes to repo root
    ├── config/                       # Config files (if needed)
    ├── scripts/                      # Enforcement scripts
    │   └── check-<standard>.sh
    └── workflows/                    # CI/CD workflows
        └── <standard>-check.yml
```

---

## Integration Points

### 1. Language Plugin Integration

Standards plugins should detect and adapt to language plugins:

**Pattern**:
```bash
# In AGENT_INSTRUCTIONS.md
if [ -f pyproject.toml ] || [ -f requirements.txt ]; then
  echo "✓ Python project detected"
  # Python-specific standard configuration
  <python-specific-commands>
fi

if [ -f package.json ]; then
  echo "✓ TypeScript/Node project detected"
  # TypeScript-specific standard configuration
  <typescript-specific-commands>
fi
```

**Example: Security Standards with Python**:
- Integrate with Bandit (Python security linter)
- Use Safety for dependency scanning
- Configure Python-specific .gitignore patterns

**Example: Security Standards with TypeScript**:
- Integrate with ESLint security plugins
- Use npm audit for dependency scanning
- Configure Node-specific .gitignore patterns

### 2. Infrastructure Plugin Integration

Standards plugins may integrate with infrastructure plugins:

**Example: Security with GitHub Actions**:
```bash
# Check if GitHub Actions is present
if [ -d .github/workflows ]; then
  echo "✓ GitHub Actions detected"
  # Copy security workflow
  cp plugins/standards/security/project-content/workflows/security.yml .github/workflows/
fi
```

**Example: Documentation with Docker**:
```bash
# Check if Docker is present
if [ -f Dockerfile ]; then
  echo "✓ Docker detected"
  # Add documentation about container architecture
fi
```

### 3. Cross-Standards Integration

Standards plugins may reference or depend on other standards:

**Example: Pre-commit Hooks referencing Security**:
```markdown
## Pre-commit Hooks

This plugin integrates with the Security Standards Plugin:
- Runs secret detection before commit
- Runs security linters (Bandit, ESLint security)
- Prevents commits with security violations

See `.ai/docs/SECURITY_STANDARDS.md` for security requirements.
```

### 4. agents.md Extension

Standards plugins should document their presence in agents.md:

**Pattern**:
```markdown
### Standards

This project follows these standards:

#### <Standard Name>
Brief description of the standard

**Documentation**: `.ai/docs/<STANDARD>_STANDARDS.md`
**How-tos**: `.ai/howto/how-to-*-<standard>.md`
**Enforcement**: <How the standard is enforced>

Key requirements:
- Requirement 1
- Requirement 2
- Requirement 3
```

### 5. .ai/index.yaml Integration

All documentation should be registered:

```yaml
standards:
  <standard-name>:
    description: "Brief description"
    documentation:
      - path: "docs/<STANDARD>_STANDARDS.md"
        description: "Main standards document"
      - path: "docs/<topic1>.md"
        description: "Detailed guide for topic 1"
    howtos:
      - path: "howto/how-to-<task1>.md"
        description: "Guide for task 1"
      - path: "howto/how-to-<task2>.md"
        description: "Guide for task 2"
    enforcement:
      - type: "ci-cd"
        location: ".github/workflows/<standard>-check.yml"
      - type: "pre-commit"
        location: ".git/hooks/pre-commit"
```

---

## Detailed Examples

### Example 1: Security Standards Plugin (PR13)

**Purpose**: Enforce security best practices across all projects

**Key Components**:

1. **Documentation** (`ai-content/standards/SECURITY_STANDARDS.md`):
   - Authentication and authorization
   - Input validation
   - Secrets management
   - Dependency scanning
   - Code security scanning

2. **How-To Guides**:
   - `how-to-prevent-secrets-in-git.md` - Secrets prevention
   - `how-to-setup-dependency-scanning.md` - Vulnerability scanning
   - `how-to-configure-code-scanning.md` - SAST configuration

3. **Templates**:
   - `.gitignore.security.template` - Security patterns
   - `.env.example.template` - Environment variable template
   - `github-workflow-security.yml.template` - Security CI/CD

4. **Integration**:
   - Python: Bandit, Safety, pip-audit
   - TypeScript: ESLint security, npm audit
   - GitHub Actions: Automated security scans

**Usage**:
```bash
# Install security standards
# AI agent follows plugins/standards/security/AGENT_INSTRUCTIONS.md

# Result:
# - .ai/docs/SECURITY_STANDARDS.md created
# - .ai/docs/secrets-management.md created
# - .ai/howto/how-to-prevent-secrets-in-git.md created
# - Security patterns added to .gitignore
# - .env.example created
# - .github/workflows/security.yml created (if GitHub Actions present)
```

### Example 2: Documentation Standards Plugin (PR14)

**Purpose**: Enforce documentation quality and completeness

**Key Components**:

1. **Documentation** (`ai-content/standards/DOCUMENTATION_STANDARDS.md`):
   - File header requirements
   - API documentation standards
   - README requirements
   - Docstring conventions
   - Changelog format

2. **How-To Guides**:
   - `how-to-write-file-headers.md` - File header guide
   - `how-to-document-apis.md` - API documentation
   - `how-to-write-readmes.md` - README guide

3. **Templates**:
   - `README.template.md` - README template
   - `CHANGELOG.template.md` - Changelog template
   - `API_DOCS.template.md` - API docs template
   - `file-header.template` - File header template

4. **Integration**:
   - Python: Docstring linting (pydocstyle)
   - TypeScript: JSDoc validation
   - All languages: File header linter

**Usage**:
```bash
# Install documentation standards
# AI agent follows plugins/standards/documentation/AGENT_INSTRUCTIONS.md

# Result:
# - .ai/docs/DOCUMENTATION_STANDARDS.md created
# - .ai/docs/file-headers.md created (file header standards)
# - .ai/howto/how-to-write-file-headers.md created
# - README template available
# - File header linter configured
```

### Example 3: Pre-commit Hooks Plugin (PR15)

**Purpose**: Enforce standards before commits reach version control

**Key Components**:

1. **Documentation** (`ai-content/standards/PRE_COMMIT_STANDARDS.md`):
   - Pre-commit hook requirements
   - Hook configuration
   - Hook bypass policies
   - CI/CD integration

2. **How-To Guides**:
   - `how-to-setup-pre-commit-hooks.md` - Installation guide
   - `how-to-add-custom-hooks.md` - Custom hooks
   - `how-to-bypass-hooks.md` - When and how to bypass

3. **Configuration**:
   - `.pre-commit-config.yaml` - Pre-commit configuration
   - Custom hooks in `.git/hooks/`

4. **Integration**:
   - Security: Secret scanning, Bandit
   - Code quality: Linting, formatting
   - Documentation: File header checks
   - Git: Commit message format

**Usage**:
```bash
# Install pre-commit hooks
# AI agent follows plugins/standards/pre-commit-hooks/AGENT_INSTRUCTIONS.md

# Result:
# - .pre-commit-config.yaml created
# - Hooks installed in .git/hooks/
# - Integration with existing linters/formatters
# - Documentation in .ai/docs/
```

---

## Common Patterns

### Pattern 1: Conditional Installation

Standards plugins should detect project context:

```markdown
### Step X: Configure for Project Type

#### For Python Projects
```bash
if [ -f pyproject.toml ] || [ -f requirements.txt ]; then
  echo "✓ Python project detected"
  # Python-specific configuration
fi
```

#### For TypeScript Projects
```bash
if [ -f package.json ]; then
  echo "✓ TypeScript project detected"
  # TypeScript-specific configuration
fi
```

#### For Docker Projects
```bash
if [ -f Dockerfile ] || [ -f docker-compose.yml ]; then
  echo "✓ Docker setup detected"
  # Docker-specific configuration
fi
```
```

### Pattern 2: Progressive Enhancement

Allow gradual adoption of standards:

```markdown
## Installation Modes

### Minimal Installation
Install only documentation:
```bash
cp plugins/standards/<standard>/ai-content/standards/*.md .ai/docs/
```

### Standard Installation
Install documentation + templates:
```bash
cp plugins/standards/<standard>/ai-content/standards/*.md .ai/docs/
cp plugins/standards/<standard>/ai-content/templates/*.template ./
```

### Full Installation
Install documentation + templates + enforcement:
```bash
cp plugins/standards/<standard>/ai-content/standards/*.md .ai/docs/
cp plugins/standards/<standard>/ai-content/templates/*.template ./
cp plugins/standards/<standard>/project-content/workflows/*.yml .github/workflows/
```
```

### Pattern 3: Documentation Hierarchy

Organize documentation by detail level:

```
ai-content/
├── standards/
│   └── <STANDARD>_STANDARDS.md        # High-level overview and requirements
├── docs/
│   ├── <topic1>-deep-dive.md         # Detailed topic guides
│   ├── <topic2>-deep-dive.md
│   └── <topic3>-deep-dive.md
└── howtos/
    ├── how-to-<task1>.md              # Task-specific instructions
    ├── how-to-<task2>.md
    └── how-to-<task3>.md
```

**User Journey**:
1. Start with `<STANDARD>_STANDARDS.md` for overview
2. Deep dive into relevant topic guides
3. Follow how-tos for specific tasks

### Pattern 4: Template Naming

Use consistent template naming:

```
templates/
├── .gitignore.<category>.template     # Configuration files
├── .env.example.template
├── README.template.md                 # Markdown templates
├── CHANGELOG.template.md
└── <tool>-config.template.yml        # Tool-specific configs
```

**Naming Convention**:
- `.template` suffix for files to be copied and customized
- `.example` suffix for reference implementations
- Include category/purpose in filename

### Pattern 5: Enforcement Levels

Provide multiple enforcement levels:

```markdown
## Enforcement Options

### Level 1: Documentation Only
- ✅ Standards documented in `.ai/docs/`
- ✅ How-to guides available
- ❌ No automated enforcement

### Level 2: Local Enforcement
- ✅ Standards documented
- ✅ Pre-commit hooks installed
- ✅ Local validation before commit
- ❌ No CI/CD enforcement

### Level 3: CI/CD Enforcement
- ✅ Standards documented
- ✅ Pre-commit hooks installed
- ✅ CI/CD workflow enforces standards
- ✅ PRs blocked on violations

### Level 4: Strict Enforcement
- ✅ All of Level 3
- ✅ No hook bypass allowed
- ✅ Branch protection rules
- ✅ Required code review for exceptions
```

---

## Testing Your Plugin

### Standalone Testing

Test your plugin works without other plugins:

```bash
# 1. Create test directory
mkdir -p /tmp/test-<standard>-plugin
cd /tmp/test-<standard>-plugin

# 2. Initialize git
git init

# 3. Install foundation plugin
mkdir -p .ai/docs .ai/howto
touch .ai/index.yaml

# 4. Install your standards plugin
# Follow your AGENT_INSTRUCTIONS.md step-by-step

# 5. Verify documentation created
ls -la .ai/docs/<STANDARD>_STANDARDS.md
ls -la .ai/howto/how-to-*.md

# 6. Verify templates installed
ls -la <template-files>

# 7. Test enforcement (if applicable)
<enforcement-command>

# 8. Check .ai/index.yaml updated
grep "<standard-name>" .ai/index.yaml
```

### Integration Testing with Language Plugins

Test with Python:

```bash
# 1. Install Python plugin
# Follow Python plugin AGENT_INSTRUCTIONS.md

# 2. Install your standards plugin
# Follow your AGENT_INSTRUCTIONS.md

# 3. Verify language-specific integration
# Check that your standard adapts to Python

# 4. Test enforcement with Python code
# Create sample Python files and test
```

Test with TypeScript:

```bash
# Similar process for TypeScript
```

### Integration Testing with Infrastructure Plugins

Test with GitHub Actions:

```bash
# 1. Install GitHub Actions plugin
mkdir -p .github/workflows

# 2. Install your standards plugin
# Follow your AGENT_INSTRUCTIONS.md

# 3. Verify CI/CD workflow created
ls -la .github/workflows/<standard>-check.yml

# 4. Test workflow locally (if possible)
# Use act or similar tools
```

### Enforcement Testing

Test pre-commit hooks:

```bash
# 1. Install pre-commit-hooks plugin (if applicable)

# 2. Create a violation
# Write code/content that violates the standard

# 3. Attempt to commit
git add .
git commit -m "Test commit"

# 4. Verify hook blocks commit
# Should see error message with guidance
```

Test CI/CD enforcement:

```bash
# 1. Push code with violation
git push origin test-branch

# 2. Check GitHub Actions
# Should see workflow fail with clear error

# 3. Fix violation
# Update code to comply

# 4. Push again
# Workflow should pass
```

---

## Real Examples to Reference

### Security Standards Plugin (PR13)

**Location**: `plugins/standards/security/`

**Key Features**:
- Secrets management (.gitignore patterns, .env.example)
- Dependency scanning (Safety, pip-audit, npm audit)
- Code scanning (Bandit, ESLint security)
- CI/CD security workflows
- Integration with Python and TypeScript

**Documentation Structure**:
```
security/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   ├── docs/
│   │   ├── secrets-management.md
│   │   ├── dependency-scanning.md
│   │   └── code-scanning.md
│   ├── howtos/
│   │   ├── how-to-prevent-secrets-in-git.md
│   │   ├── how-to-setup-dependency-scanning.md
│   │   └── how-to-configure-code-scanning.md
│   ├── standards/
│   │   └── SECURITY_STANDARDS.md
│   └── templates/
│       ├── .gitignore.security.template
│       ├── .env.example.template
│       └── github-workflow-security.yml.template
```

### Documentation Standards Plugin (PR14)

**Location**: `plugins/standards/documentation/`

**Key Features**:
- File header standards
- API documentation requirements
- README templates
- Docstring conventions
- Changelog requirements

**Documentation Structure**:
```
documentation/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   ├── docs/
│   │   ├── file-headers.md
│   │   ├── api-documentation.md
│   │   └── readme-standards.md
│   ├── howtos/
│   │   ├── how-to-write-file-headers.md
│   │   ├── how-to-document-api.md
│   │   └── how-to-create-readme.md
│   ├── standards/
│   │   └── DOCUMENTATION_STANDARDS.md
│   └── templates/
│       ├── README.template
│       ├── file-header-markdown.template
│       ├── file-header-python.template
│       └── file-header-typescript.template
```

### Pre-commit Hooks Plugin (PR15)

**Location**: `plugins/standards/pre-commit-hooks/`

**Key Features**:
- Pre-commit hook configuration
- Integration with linters/formatters
- Secret scanning hooks
- Commit message format validation
- CI/CD integration

**Documentation Structure**:
```
pre-commit-hooks/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   ├── docs/
│   │   ├── hook-configuration.md
│   │   └── custom-hooks.md
│   ├── howtos/
│   │   ├── how-to-setup-pre-commit-hooks.md
│   │   ├── how-to-add-custom-hooks.md
│   │   └── how-to-bypass-hooks.md
│   ├── standards/
│   │   └── PRE_COMMIT_STANDARDS.md
│   └── templates/
│       └── .pre-commit-config.yaml.template
└── project-content/
    └── config/
        └── .pre-commit-config.yaml
```

---

## Best Practices

### Do's

✅ **Provide comprehensive documentation** - Standards require clear explanation

✅ **Make standards language-agnostic** - Or clearly state language requirements

✅ **Include practical examples** - Show good and bad examples

✅ **Offer enforcement options** - Documentation-only, local, or CI/CD enforcement

✅ **Detect existing plugins** - Adapt to Python, TypeScript, Docker, etc.

✅ **Provide how-tos for common tasks** - Make standards actionable

✅ **Create useful templates** - Save time with boilerplate

✅ **Document exceptions** - Explain when standards can be relaxed

✅ **Integrate with CI/CD** - Automate enforcement where possible

✅ **Support gradual adoption** - Allow progressive implementation

### Don'ts

❌ **Don't be overly prescriptive** - Allow flexibility where appropriate

❌ **Don't assume tools are installed** - Check and provide installation guidance

❌ **Don't skip rationale** - Explain why each standard matters

❌ **Don't ignore edge cases** - Document exceptions and special cases

❌ **Don't make enforcement all-or-nothing** - Offer levels of enforcement

❌ **Don't duplicate language plugin functionality** - Integrate, don't replace

❌ **Don't forget about documentation** - Standards without docs are useless

❌ **Don't create conflicts** - Test with existing plugins

❌ **Don't skip examples** - Abstract standards need concrete examples

❌ **Don't ignore feedback** - Standards should evolve based on usage

---

## Troubleshooting

### Issue: Standard conflicts with language plugin

**Symptom**: Language plugin and standards plugin have overlapping configurations

**Solution**:
1. Detect language plugin presence in AGENT_INSTRUCTIONS.md
2. Coordinate configuration (merge, don't replace)
3. Document the integration in both plugins

```markdown
### Step X: Integrate with Language Plugins

#### If Python Plugin Detected
```bash
if [ -f .ai/docs/PYTHON_STANDARDS.md ]; then
  echo "✓ Python plugin detected"
  echo "  → Integrating <standard> with Python tools"
  # Coordinate configuration
fi
```
```

### Issue: Template conflicts with existing files

**Symptom**: User already has .gitignore, README.md, etc.

**Solution**: Append or merge rather than replace

```bash
# Check if file exists
if [ -f .gitignore ]; then
  echo "✓ .gitignore exists"
  echo "  → Appending <standard> patterns"
  echo "" >> .gitignore
  echo "# <Standard> patterns" >> .gitignore
  cat <template> >> .gitignore
else
  cp <template> .gitignore
fi
```

### Issue: Enforcement too strict for new projects

**Symptom**: New projects can't pass enforcement immediately

**Solution**: Provide "onboarding mode"

```markdown
## Onboarding Mode

For new projects adopting this standard:

1. **Initial setup**: Install documentation only
2. **Review period**: Team reviews standards for 1 sprint
3. **Local enforcement**: Add pre-commit hooks
4. **CI/CD enforcement**: Add workflow after team is comfortable

Use `--onboarding` flag to skip enforcement during initial adoption.
```

### Issue: Standards documentation too long

**Symptom**: Users overwhelmed by documentation length

**Solution**: Use hierarchical documentation

```markdown
## Documentation Structure

**Start here**: `.ai/docs/<STANDARD>_STANDARDS.md` (overview)

**Deep dives** (read as needed):
- `.ai/docs/<topic1>-deep-dive.md`
- `.ai/docs/<topic2>-deep-dive.md`

**Task guides** (when you need to do something):
- `.ai/howto/how-to-<task1>.md`
- `.ai/howto/how-to-<task2>.md`
```

---

## Submitting Your Plugin

### Step 1: Create Feature Branch

```bash
git checkout -b feat/add-<standard>-standards-plugin
```

### Step 2: Commit Your Changes

```bash
# Add all plugin files
git add plugins/standards/<standard>/

# Add manifest update
git add plugins/PLUGIN_MANIFEST.yaml

# Commit with descriptive message
git commit -m "feat(standards): Add <Standard> standards plugin

- Add <Standard> plugin directory structure
- Include comprehensive standards documentation
- Add task-specific how-to guides
- Include templates for common files
- Add enforcement mechanisms (CI/CD, pre-commit)
- Integrate with language plugins (Python, TypeScript)
- Integrate with infrastructure plugins (GitHub Actions, Docker)
- Update PLUGIN_MANIFEST.yaml with <standard> entry

Follows plugin template structure for standards plugins
"
```

### Step 3: Push and Create PR

```bash
# Push to GitHub
git push -u origin feat/add-<standard>-standards-plugin

# Create PR
gh pr create --title "feat(standards): Add <Standard> standards plugin" --body "$(cat <<'EOF'
## Summary
Adds <Standard> standards plugin with comprehensive documentation and enforcement.

## Changes
- ✅ <Standard> plugin directory structure
- ✅ Standards documentation (<STANDARD>_STANDARDS.md)
- ✅ Detailed topic guides (3+ guides)
- ✅ Task-specific how-tos (3+ guides)
- ✅ Templates for common files
- ✅ Enforcement mechanisms (CI/CD workflows, scripts)
- ✅ Integration with language plugins
- ✅ Integration with infrastructure plugins
- ✅ PLUGIN_MANIFEST.yaml entry

## Standards Covered
**Main Standard**: <Primary standard or requirement>
**Additional Topics**: <Topic1>, <Topic2>, <Topic3>

## Enforcement
**Local**: <Pre-commit hooks, scripts, etc.>
**CI/CD**: <GitHub Actions workflows>
**Documentation**: Comprehensive guides in .ai/docs/

## Integration
**Language Plugins**: Python, TypeScript
**Infrastructure Plugins**: GitHub Actions, Docker
**Other Standards**: <Related standards>

## Testing
Tested standalone installation in clean directory:
- ✅ All documentation created correctly
- ✅ Templates installed
- ✅ Enforcement works (pre-commit, CI/CD)
- ✅ Integration with Python plugin tested
- ✅ Integration with TypeScript plugin tested
- ✅ AGENTS.md updated correctly
- ✅ .ai/index.yaml references standard
- ✅ No conflicts with existing plugins

## Reference
Follows structure from `plugins/standards/security/` (PR13)
Pattern matches Documentation (PR14) and Pre-commit Hooks (PR15) plugins

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Step 4: Address Review Feedback

Reviewers will check:
- ✅ Follows standards plugin structure
- ✅ AGENT_INSTRUCTIONS.md is clear and complete
- ✅ Standards documentation is comprehensive
- ✅ How-to guides are actionable
- ✅ Templates are useful and well-documented
- ✅ Enforcement mechanisms work
- ✅ Integration with language plugins tested
- ✅ Integration with infrastructure plugins tested
- ✅ Tested standalone (without orchestrator)
- ✅ Documentation is clear and complete
- ✅ No conflicts with existing plugins
- ✅ Manifest entry is correct

### Step 5: Merge and Celebrate!

Once approved and merged:
- Your plugin becomes available to all ai-projen users
- Orchestrators can discover and install it
- Community can use it as reference for similar standards

---

## Next Steps

After creating your standards plugin:

1. **Test in real projects** - Apply to actual repositories
2. **Gather feedback** - Find pain points and improve
3. **Create integration examples** - Show combinations with other plugins
4. **Write blog post** - Share your standards approach
5. **Help others** - Review community plugin PRs
6. **Expand coverage** - Add more how-tos, templates, enforcement

---

## Additional Resources

### Documentation
- `PLUGIN_ARCHITECTURE.md` - Plugin structure requirements
- `PLUGIN_MANIFEST.yaml` - All available plugins
- `plugins/standards/documentation/ai-content/docs/file-headers.md` - File header standards
- `HOWTO_STANDARDS.md` - How-to guide standards

### Reference Implementations
- `plugins/standards/security/` - Security standards (PR13)
- `plugins/standards/documentation/` - Documentation standards (PR14)
- `plugins/standards/pre-commit-hooks/` - Pre-commit hooks (PR15)

### Related Guides
- `how-to-create-a-language-plugin.md` - Language plugin guide
- `how-to-create-an-infrastructure-plugin.md` - Infrastructure plugin guide
- `how-to-discover-and-install-plugins.md` - Plugin discovery

### External Resources
- [OWASP Top 10](https://owasp.org/www-project-top-ten/) - Security standards
- [Keep a Changelog](https://keepachangelog.com/) - Changelog standards
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit message standards
- [WCAG](https://www.w3.org/WAI/WCAG21/quickref/) - Accessibility standards

---

**Questions?** Open an issue on GitHub or check existing standards plugins for examples.

**Ready to contribute?** Follow this guide to add security, documentation, accessibility, performance, or any standards to ai-projen!
