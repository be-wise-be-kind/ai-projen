# How to Create a Common Application

**Purpose**: Comprehensive guide for creating application plugins in ai-projen

**Scope**: Application plugin architecture, implementation patterns, and contribution guidelines

**Overview**: Complete guide for creating new common application plugins. Application plugins are
    meta-plugins that compose existing language, infrastructure, and standards plugins to deliver
    complete, functional starter applications for specific use cases. They simplify onboarding by
    providing opinionated, battle-tested architectures with application-specific documentation.

**Dependencies**: PLUGIN_ARCHITECTURE.md, existing application plugins (python-cli, react-python-fullstack)

**Exports**: Guidelines for creating well-structured, production-ready application plugins

**Related**: how-to-create-a-language-plugin.md, how-to-create-an-infrastructure-plugin.md

**Implementation**: Follow this guide to create application plugins that compose existing plugins

---

## What is a Common Application?

A **common application** is a meta-plugin that:

1. **Composes existing plugins**: Declares dependencies on foundation, language, infrastructure, and standards plugins
2. **Provides starter code**: Includes a complete, functional starter application
3. **Offers application-specific guidance**: How-tos tailored to the specific application type
4. **Simplifies onboarding**: One choice instead of selecting 10+ individual plugins

### Key Characteristics

- **Meta-plugins**: Orchestrate installation of multiple plugins
- **Opinionated**: Make sensible technology choices with battle-tested defaults
- **Complete**: Deliver working applications, not just scaffolding
- **Extensible**: Users can modify, add, or swap plugins after initial setup
- **Use-case focused**: Documentation addresses specific application patterns

### Applications vs. Individual Plugins

| Aspect | Individual Plugins | Application Plugins |
|--------|-------------------|---------------------|
| **Purpose** | Provide tooling/infrastructure | Provide complete applications |
| **Dependencies** | Few (1-2 plugins) | Many (5-15 plugins) |
| **Code Provided** | Configuration files | Functional starter application |
| **Documentation** | General tool usage | Application-specific patterns |
| **Target** | Any project type | Specific use case |
| **Example** | Python linting plugin | Python CLI application |

## When to Create an Application Plugin

### ✅ Create an Application When:

- There's a **well-defined, common application pattern** (CLI, web app, microservice, data pipeline)
- The pattern requires **5+ individual plugins working together**
- You can provide a **complete, functional starter application**
- **Application-specific how-tos** would add significant value beyond general plugin docs
- The pattern is **commonly requested** or widely adopted in the industry
- You can demonstrate **production-ready best practices**

### ❌ Don't Create an Application When:

- The pattern is **too niche or specialized** (< 100 potential users)
- It only requires **1-2 plugins** (just use those plugins directly)
- You can't provide a **complete working example**
- **General plugin documentation is sufficient**
- The pattern is **experimental** or unproven
- Requirements vary so widely that defaults provide little value

### Examples

#### ✅ Good Application Plugin Ideas

- **Python CLI Application**: Common pattern, clear requirements, proven tooling
- **React + Python Full-Stack**: Popular stack, well-established patterns
- **Go Microservice**: Standard architecture, common use case
- **Next.js Application**: Popular framework, specific patterns
- **Python Data Pipeline**: Common need, specific tooling requirements

#### ❌ Poor Application Plugin Ideas

- **My Company's Specific App**: Too specialized, not reusable
- **Python with Ruff**: Only 1 plugin, use python plugin directly
- **Experimental Framework App**: Unproven, requirements unclear
- **Every Possible Web Framework**: Too many variations, diminishing returns

## Application Plugin Structure

### Required Directory Structure

```
plugins/applications/{{APPLICATION_NAME}}/
├── AGENT_INSTRUCTIONS.md           # Installation orchestration
├── README.md                        # Human-readable overview
├── manifest.yaml                    # Dependencies and metadata
│
├── ai-content/                      # → Goes to .ai/ in target repo
│   ├── docs/
│   │   └── {{APPLICATION_NAME}}-architecture.md
│   ├── howtos/                     # Application-specific how-tos
│   │   ├── README.md               # Index of all how-tos
│   │   ├── how-to-{{TASK_1}}.md
│   │   ├── how-to-{{TASK_2}}.md
│   │   └── how-to-{{TASK_3}}.md
│   └── templates/                  # Code generation templates
│       ├── {{TEMPLATE_1}}.template
│       └── {{TEMPLATE_2}}.template
│
└── project-content/                 # → Goes to project root
    ├── src/                        # Starter application code
    │   └── (application structure)
    ├── tests/                      # Example tests
    └── {{CONFIG_FILES}}            # Application configuration
```

### Required Files

#### 1. manifest.yaml

Plugin metadata including:

```yaml
name: {{APPLICATION_NAME}}
version: 1.0.0
type: application  # or meta-plugin
description: {{ONE_LINE_DESCRIPTION}}

metadata:
  use_case: {{USE_CASE_DESCRIPTION}}
  complexity: {{beginner|intermediate|advanced}}
  technology_stack:
    primary_language: {{LANGUAGE}}
    frameworks: [{{FRAMEWORK_LIST}}]

dependencies:
  required:
    - foundation/ai-folder
    - languages/{{LANGUAGE}}
    - infrastructure/containerization/docker
    - infrastructure/ci-cd/github-actions
    - standards/security
    - standards/documentation
    - standards/pre-commit-hooks

provides:
  starter_application:
    features: [{{FEATURE_LIST}}]
  documentation:
    howtos: [{{HOWTO_LIST}}]
  templates: [{{TEMPLATE_LIST}}]
```

#### 2. AGENT_INSTRUCTIONS.md

Step-by-step installation for AI agents:

1. **Prerequisites Check**: System requirements, tool versions
2. **Phase 1: Foundation Setup**: Install foundation/ai-folder
3. **Phase 2: Language Plugins**: Install primary/secondary languages
4. **Phase 3: Infrastructure Plugins**: Install Docker, CI/CD, IaC
5. **Phase 4: Standards Plugins**: Install security, documentation, pre-commit
6. **Phase 5: Application Installation**: Copy starter code, configure, install dependencies
7. **Post-Installation**: Validation steps, initial setup commands

Each phase should include:
- Clear installation commands
- Configuration options
- Validation checks
- Error troubleshooting

#### 3. README.md

Human-readable documentation:

- **What**: Application type and use case
- **Why**: When to use this application
- **What Gets Installed**: Complete feature list
- **Technology Stack**: All technologies included
- **Quick Start**: Getting up and running in < 5 minutes
- **Documentation**: Links to how-tos and architecture docs
- **Examples**: Common usage patterns

#### 4. ai-content/docs/{{APPLICATION}}-architecture.md

Complete architecture documentation:

- **System Overview**: High-level architecture diagram
- **Component Responsibilities**: What each piece does
- **Data Flow**: How requests/data flow through the system
- **Technology Choices**: Why these technologies were selected
- **Security Architecture**: Authentication, authorization, data protection
- **Deployment Topology**: How the application deploys
- **Scalability Considerations**: Horizontal/vertical scaling strategies

#### 5. ai-content/howtos/ (3-5 guides)

Application-specific how-to guides:

- **Focus on common tasks** for this application type
- **Reference underlying plugin documentation** when appropriate
- **Include complete working examples**
- **Address application-specific patterns**, not general tooling

**Examples**:
- CLI app: `how-to-add-cli-command.md`, `how-to-handle-config-files.md`
- Web app: `how-to-add-api-endpoint.md`, `how-to-add-frontend-page.md`
- Microservice: `how-to-add-grpc-endpoint.md`, `how-to-implement-circuit-breaker.md`

#### 6. ai-content/templates/ (2-4 templates)

Code generation templates for common patterns:

- Application-specific code patterns
- Complete placeholder documentation
- Copy-paste ready with minimal modification
- Follow application conventions

#### 7. project-content/ (Complete starter application)

Functional application demonstrating best practices:

- **Runnable**: Works immediately after installation
- **Production-grade**: Not a toy example
- **Well-structured**: Follows best practices
- **Documented**: Comments explaining key patterns
- **Tested**: Example tests demonstrating patterns
- **Configured**: All configuration files included

## Creating Your Application Plugin

### Step 1: Define Your Application

Answer these questions:

1. **What use case does this serve?**
   - Be specific: "CLI tools for data processing" not "Python apps"

2. **What is the target user?**
   - Backend developers? Data scientists? DevOps engineers?

3. **What is the technology stack?**
   - Primary language, frameworks, infrastructure, databases

4. **What dependencies are required?**
   - List ALL plugins needed (foundation, languages, infrastructure, standards)

5. **What makes this application type unique?**
   - What patterns/architecture distinguish it from other applications?

6. **What are the 3-5 most common tasks?**
   - These become your how-to guides

### Step 2: Copy the Template

```bash
# Copy application template
cp -r plugins/applications/_template plugins/applications/{{YOUR_APP_NAME}}

# Navigate to your new plugin
cd plugins/applications/{{YOUR_APP_NAME}}
```

### Step 3: Create manifest.yaml

Define your application in `manifest.yaml`:

```yaml
name: {{YOUR_APP_NAME}}
version: 1.0.0
type: application
description: {{CLEAR_DESCRIPTION}}

metadata:
  use_case: {{DETAILED_USE_CASE}}
  target_users: {{WHO_WILL_USE_THIS}}
  complexity: {{COMPLEXITY_LEVEL}}
  technology_stack:
    primary_language: {{LANGUAGE}}
    # Add all technologies

dependencies:
  required:
    - foundation/ai-folder
    # Add ALL required plugins

provides:
  starter_application:
    features:
      # List ALL features of starter app
  documentation:
    howtos:
      # List ALL how-to guides
  templates:
    # List ALL code templates
```

**Important**: Be comprehensive in dependencies. Missing a dependency means installation will fail.

### Step 4: Build the Starter Application

Create a complete, functional application in `project-content/`:

#### Best Practices

1. **Make it production-ready**, not a hello-world toy
2. **Include comprehensive comments** explaining patterns
3. **Follow framework conventions** and best practices
4. **Add example tests** demonstrating testing patterns
5. **Include all configuration files** (Docker, CI/CD, etc.)
6. **Use meaningful examples** that demonstrate real usage
7. **Document decisions** in code comments

#### Structure Guidelines

**For CLI Applications**:
```
project-content/
├── src/
│   ├── __init__.py
│   ├── cli.py          # Main CLI entry
│   ├── commands/       # Command modules
│   └── config.py       # Configuration management
├── tests/
│   └── test_*.py
└── pyproject.toml
```

**For Web Applications**:
```
project-content/
├── backend/
│   ├── src/
│   │   ├── main.py     # App entry
│   │   ├── routers/    # API endpoints
│   │   └── models/     # Data models
│   └── tests/
├── frontend/
│   ├── src/
│   │   ├── App.tsx
│   │   ├── components/
│   │   └── pages/
│   └── package.json
└── docker-compose.yml
```

### Step 5: Write Application-Specific How-Tos

Create 3-5 comprehensive how-to guides in `ai-content/howtos/`:

#### How-To Guide Structure

```markdown
# How to {{TASK}}

**Purpose**: {{WHY_THIS_GUIDE}}
**Scope**: {{WHAT_IS_COVERED}}
**Prerequisites**: {{REQUIREMENTS}}
**Estimated Time**: {{TIME_ESTIMATE}}

## Overview
{{BRIEF_EXPLANATION}}

## Steps

### Step 1: {{ACTION}}
{{DETAILED_INSTRUCTIONS}}

### Step 2: {{ACTION}}
{{MORE_INSTRUCTIONS}}

## Verification
{{HOW_TO_VERIFY_IT_WORKED}}

## Common Issues
{{TROUBLESHOOTING}}

## Next Steps
{{RELATED_GUIDES}}
```

#### How-To Best Practices

- ✅ **Focus on application-specific patterns**, not general tool usage
- ✅ **Include complete working examples** that users can copy
- ✅ **Reference underlying plugin docs** when appropriate
- ✅ **Show the "why" not just the "what"**
- ✅ **Include troubleshooting** for common issues
- ✅ **Link to related guides** for next steps
- ❌ **Don't duplicate general plugin documentation**
- ❌ **Don't assume expert knowledge** of the technology
- ❌ **Don't skip validation steps**

### Step 6: Create Code Generation Templates

Create 2-4 templates in `ai-content/templates/`:

#### Template Requirements

1. **Comprehensive placeholder documentation**:
   ```python
   # Placeholders:
   # - {{MODULE_NAME}}: Name of the module (e.g., "users", "orders")
   #   Type: snake_case string
   #   Example: "products"
   #   Required: Yes
   ```

2. **Usage instructions**:
   ```markdown
   # Usage:
   # 1. Copy: cp .ai/templates/api-router.py.template src/routers/{{MODULE_NAME}}.py
   # 2. Replace: {{MODULE_NAME}} with your module name
   # 3. Replace: {{MODEL_NAME}} with your model class
   # 4. Validate: python -m py_compile src/routers/{{MODULE_NAME}}.py
   ```

3. **Complete working code**: Template should be functional after placeholder replacement

4. **Follow application conventions**: Match the patterns in your starter application

### Step 7: Write Architecture Documentation

Create `ai-content/docs/{{APPLICATION}}-architecture.md`:

#### Architecture Document Structure

1. **System Overview**
   - High-level architecture diagram
   - Main components and their responsibilities

2. **Technology Stack**
   - Why each technology was chosen
   - Alternatives considered and rejected

3. **Component Architecture**
   - Detailed breakdown of each component
   - Interfaces and dependencies

4. **Data Flow**
   - How requests/data flow through the system
   - Authentication and authorization flow

5. **Security Architecture**
   - Authentication mechanisms
   - Authorization patterns
   - Data protection strategies
   - Common vulnerabilities and mitigations

6. **Deployment Topology**
   - How the application deploys
   - Infrastructure requirements
   - Scaling strategies

7. **Development Workflow**
   - Local development setup
   - Testing strategies
   - Deployment process

### Step 8: Write AGENT_INSTRUCTIONS.md

Create comprehensive installation instructions for AI agents:

#### Installation Flow

```markdown
## Installation Steps

### Prerequisites Check
- System requirements
- Tool versions
- Docker status

### Phase 1: Foundation Setup
- Install foundation/ai-folder
- Validation

### Phase 2: Language Plugin Installation
- Install primary language plugin
- Install secondary language (if needed)
- Configure language tooling
- Validation

### Phase 3: Infrastructure Plugin Installation
- Install containerization plugin
- Install CI/CD plugin
- Install IaC plugin (if needed)
- Validation for each

### Phase 4: Standards Plugin Installation
- Install security standards
- Install documentation standards
- Install pre-commit hooks
- Validation for each

### Phase 5: Application-Specific Installation
- Copy starter application code
- Copy documentation and how-tos
- Copy templates
- Configure application
- Install dependencies
- Update .ai/index.yaml
- Validation

## Post-Installation
- Initial setup commands
- Complete validation checklist
- Next steps guidance

## Success Criteria
- [ ] All dependencies installed
- [ ] Application code copied
- [ ] Application runs successfully
- [ ] Tests pass
- [ ] CI/CD configured
- [ ] Documentation available
```

#### Best Practices

- **Clear validation steps** after each phase
- **Specific commands** that agents can execute
- **Error troubleshooting** for common failures
- **Comprehensive success criteria** checklist

### Step 9: Write README.md

Create human-readable overview documentation:

```markdown
# {{APPLICATION_NAME}}

**Purpose**: {{ONE_SENTENCE_DESCRIPTION}}

## What This Application Provides

{{DETAILED_DESCRIPTION}}

## Use Cases

- {{USE_CASE_1}}
- {{USE_CASE_2}}
- {{USE_CASE_3}}

## Technology Stack

- **Language**: {{LANGUAGE_WITH_VERSION}}
- **Framework**: {{FRAMEWORK_LIST}}
- **Infrastructure**: {{INFRA_LIST}}
- **Database**: {{DATABASE}} (if applicable)

## Features

- {{FEATURE_1}}
- {{FEATURE_2}}
- ...

## Quick Start

\`\`\`bash
# Installation steps
# Running the application
\`\`\`

## Documentation

- **Architecture**: \`.ai/docs/{{APPLICATION}}-architecture.md\`
- **How-Tos**: \`.ai/howtos/{{APPLICATION}}/\`
- **Templates**: \`.ai/templates/{{APPLICATION}}/\`

## Dependencies

This application requires these plugins:
- {{LIST_ALL_DEPENDENCIES}}

## What Gets Installed

### Application Structure
\`\`\`
{{DIRECTORY_STRUCTURE}}
\`\`\`

### Configuration Files
- {{CONFIG_FILE_LIST}}

## Customization

{{HOW_TO_CUSTOMIZE}}

## Examples

{{USAGE_EXAMPLES}}
```

### Step 10: Update PLUGIN_MANIFEST.yaml

Add your application to `/home/stevejackson/Projects/ai-projen/plugins/PLUGIN_MANIFEST.yaml`:

```yaml
applications:
  {{your-app-name}}:
    status: stable
    description: {{ONE_LINE_DESCRIPTION}}
    location: plugins/applications/{{your-app-name}}/
    type: meta-plugin
    use_case: {{USE_CASE}}

    dependencies:
      - {{LIST_ALL_DEPENDENCIES}}

    provides:
      - {{FEATURE_LIST}}

    installation_guide: plugins/applications/{{your-app-name}}/AGENT_INSTRUCTIONS.md
```

### Step 11: Test Thoroughly

Create test plan and execute:

#### Installation Testing

```bash
# Test 1: Fresh Installation
mkdir -p /tmp/test-{{APP_NAME}}-fresh
cd /tmp/test-{{APP_NAME}}-fresh
git init

# Follow AGENT_INSTRUCTIONS.md step-by-step
# Document any issues

# Validate all success criteria pass
```

#### Functional Testing

```bash
# Test 2: Application Runs
cd /tmp/test-{{APP_NAME}}-fresh

# Start application per quick start guide
# Verify all features work
# Run test suite
# Run linting
# Build for production
```

#### Documentation Testing

```bash
# Test 3: Follow All How-Tos
cd /tmp/test-{{APP_NAME}}-fresh

# Follow each how-to guide
# Verify instructions are correct
# Verify examples work
# Document any confusion
```

#### Template Testing

```bash
# Test 4: Use All Templates
cd /tmp/test-{{APP_NAME}}-fresh

# Use each template to generate code
# Verify placeholders are documented
# Verify generated code works
# Run tests on generated code
```

### Step 12: Submit for Review

Create pull request with:

1. **Complete implementation**: All files created and tested
2. **Documentation**: README, architecture, how-tos, templates
3. **Testing evidence**: Screenshots or logs showing successful installation
4. **PLUGIN_MANIFEST.yaml updated**: Application added to manifest

## Reference Examples

### Python CLI Application

Location: `plugins/applications/python-cli/`

**Key Features**:
- Click framework integration
- Config file management
- Docker packaging
- 3 comprehensive how-tos
- Production-ready starter

**What to Learn**:
- How to structure CLI applications
- Config management patterns
- Testing CLI tools
- Packaging and distribution

### React + Python Full-Stack

Location: `plugins/applications/react-python-fullstack/`

**Key Features**:
- FastAPI backend
- React TypeScript frontend
- Docker orchestration
- Database integration patterns
- AWS deployment configuration

**What to Learn**:
- Full-stack architecture
- Frontend-backend integration
- Multi-service Docker composition
- Deployment strategies

## Best Practices

### Application Design

#### ✅ Do:

- **Provide production-ready code**, not toy examples
- **Use battle-tested technology stacks**
- **Include comprehensive how-to guides**
- **Make applications extensible** (easy to customize)
- **Document all dependencies clearly**
- **Test end-to-end in clean environment**
- **Follow framework conventions** and best practices
- **Include security considerations** from the start
- **Provide clear upgrade paths**
- **Document architectural decisions**

#### ❌ Don't:

- **Duplicate plugin functionality** - compose, don't replace
- **Create toy examples** - make it production-ready
- **Assume expert knowledge** - document clearly
- **Skip testing in clean environments**
- **Make applications too rigid** - allow customization
- **Ignore security concerns**
- **Provide minimal documentation**
- **Use experimental/unproven technologies**

### Documentation Writing

#### ✅ Do:

- **Write for the target audience** (beginners, intermediate, advanced)
- **Include complete working examples**
- **Show the "why" not just the "what"**
- **Link to related documentation**
- **Include troubleshooting sections**
- **Use consistent terminology**
- **Provide validation steps**

#### ❌ Don't:

- **Assume prior knowledge** without stating prerequisites
- **Use jargon without explanation**
- **Skip error handling examples**
- **Forget to link related guides**
- **Leave out validation steps**

### Code Quality

#### ✅ Do:

- **Include comprehensive file headers** per FILE_HEADER_STANDARDS.md
- **Add type hints** (Python) or type annotations (TypeScript)
- **Write docstrings** for all functions/classes
- **Include comments** explaining complex logic
- **Follow language idioms** and conventions
- **Add comprehensive tests**
- **Handle errors gracefully**
- **Log appropriately**

#### ❌ Don't:

- **Skip file headers**
- **Leave code uncommented**
- **Ignore error handling**
- **Skip tests**
- **Use outdated patterns**

## Common Pitfalls

### Pitfall 1: Incomplete Dependencies

**Problem**: Application fails to install because dependencies are missing

**Solution**: List ALL required plugins in `manifest.yaml` and test in clean environment

### Pitfall 2: Toy Example Starter

**Problem**: Starter application is too simple to be useful

**Solution**: Build production-ready application with real patterns

### Pitfall 3: General Plugin Documentation

**Problem**: How-tos just duplicate general plugin docs

**Solution**: Focus on application-specific patterns and integration

### Pitfall 4: Undocumented Assumptions

**Problem**: Instructions assume knowledge not stated in prerequisites

**Solution**: Explicitly list all prerequisites and explain concepts

### Pitfall 5: No Testing

**Problem**: Application doesn't work in clean environment

**Solution**: Test thoroughly in multiple environments

### Pitfall 6: Too Specialized

**Problem**: Application is too specific to be useful to others

**Solution**: Generalize patterns, make customization easy

## Getting Help

### Resources

- **PLUGIN_ARCHITECTURE.md**: Plugin structure and requirements
- **_template/ directory**: Starting point for new applications
- **python-cli/**: Reference implementation for CLI apps
- **react-python-fullstack/**: Reference implementation for web apps

### Questions?

- Review existing application plugins for patterns
- Check PLUGIN_ARCHITECTURE.md for structure requirements
- Open an issue for questions or clarifications

---

**Remember**: Application plugins simplify onboarding by providing complete, opinionated, production-ready starter applications. They compose existing plugins to deliver maximum value with minimal decisions.
