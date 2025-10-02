# How-To Standards

**Purpose**: Standards and guidelines for writing effective how-to guides in the ai-projen framework

**Scope**: How-to creation, structure, style, testing, and maintenance

**Overview**: Comprehensive standards for creating how-to guides that serve as AI-agent-focused,
    step-by-step instructions for common development tasks. These standards ensure consistency,
    usability, and maintainability across all how-tos in the framework and its plugins.

---

## Purpose and Philosophy

### Why How-Tos Are Essential

How-to guides are critical infrastructure for AI agents working with the ai-projen framework:

1. **Procedural Knowledge**: Capture step-by-step workflows that AI agents can follow
2. **Context Provision**: Explain "why" not just "what" for better decision-making
3. **Template Integration**: Bridge the gap between templates and implementation
4. **Troubleshooting**: Reduce iteration by addressing common issues proactively
5. **Discoverability**: Make capabilities visible to AI agents and human developers

### AI-Agent-First Design

How-tos are written primarily for AI agents:
- **Explicit Instructions**: No assumptions about implicit knowledge
- **Complete Examples**: All code must be runnable, not pseudo-code
- **Verification Steps**: Clear success criteria and testing procedures
- **Integration Points**: Explicit references to where components connect
- **Error Handling**: Common issues documented with solutions

### Human Readability

While AI-agent-focused, how-tos must remain human-readable:
- Clear structure and progressive disclosure
- Logical flow from prerequisites to completion
- Visual hierarchy (headings, code blocks, lists)
- Searchable and scannable content

---

## When to Create a How-To

### Create a How-To When:

1. **Repetitive Task**: The task will be performed multiple times across projects
2. **Multi-Step Process**: Requires 3+ sequential steps or touches multiple files
3. **Integration Required**: Involves connecting new code with existing systems
4. **Template Usage**: Demonstrates how to use one or more plugin templates
5. **Non-Obvious Workflow**: Process isn't immediately clear from code/docs alone
6. **Common Pitfalls**: Task has known gotchas or common failure modes
7. **Plugin Capability**: Showcases a core capability of a plugin

### Do NOT Create a How-To When:

1. **Single Command**: Task is literally one command (document in README instead)
2. **Self-Explanatory**: Process is obvious from code comments or interface
3. **Too Specific**: Only applies to one unique project (not generalizable)
4. **Reference Material**: Information is better suited for API docs or standards
5. **Constantly Changing**: Workflow is too unstable to document reliably

### Examples

**Good How-To Topics**:
- "How to Add a New API Endpoint" (multi-step, uses templates, integration required)
- "How to Create a React Component with TypeScript" (workflow, best practices, testing)
- "How to Set Up a Development Environment" (complex, prerequisites, verification)
- "How to Implement WebSocket in React" (non-obvious, common pitfalls)

**Bad How-To Topics**:
- "How to Run Linting" (single command: `make lint-all`)
- "How to Install Node.js" (external tool, not project-specific)
- "How to Configure Database Connection for Project X" (too specific)

---

## Structure Requirements

### Mandatory Sections

Every how-to MUST include:

#### 1. Metadata Block
```markdown
# How-To: [Task Name]

**Purpose**: One-sentence description
**Scope**: What's covered and what's not
**Overview**: 2-3 sentences providing context
**Dependencies**: Required plugins, tools, setup
**Exports**: What's created by following this guide
**Related**: Links to related resources
**Implementation**: Technical approach summary
**Difficulty**: beginner | intermediate | advanced
**Estimated Time**: 5min | 15min | 30min | 1hr
```

#### 2. Prerequisites
- List required plugins with installation references
- Specify necessary tools and versions
- Identify required knowledge or concepts
- List files or states that must exist

#### 3. Overview
- Explain the problem/task context (2-4 paragraphs)
- Describe when to use this guide
- Outline key concepts
- Show how it fits in the architecture

#### 4. Steps
- Numbered, sequential steps
- Each step has a descriptive title
- Include complete code examples
- Show expected results
- Reference templates where applicable

#### 5. Verification
- Manual testing procedures
- Automated test commands
- Expected outputs
- Success criteria

#### 6. Common Issues
- Document known problems
- Provide symptoms, causes, solutions
- Include fix commands

#### 7. Checklist
- Checkbox list of all major steps
- Verification items
- Best practice checks

### Optional Sections

Include as needed:

- **Best Practices**: Guidelines beyond basic implementation
- **Next Steps**: Related workflows or advanced usage
- **Performance Considerations**: For complex or resource-intensive tasks
- **Security Considerations**: For tasks with security implications
- **Related Resources**: Additional reading and references

### Section Ordering

Always follow this order:
1. Metadata
2. Prerequisites
3. Overview
4. Steps (bulk of content)
5. Verification
6. Common Issues
7. Best Practices (optional)
8. Next Steps (optional)
9. Checklist
10. Related Resources

---

## Writing Style

### Voice and Tone

**Imperative Mood** (commands):
- ✅ "Create a file at `src/api.py`"
- ✅ "Run `make test` to verify"
- ❌ "You should create a file"
- ❌ "It would be good to run tests"

**Direct and Explicit**:
- ✅ "Copy the template from `plugins/python/templates/api.py.template`"
- ❌ "Use the template in the plugin directory"

**Active Voice**:
- ✅ "The endpoint returns a JSON response"
- ❌ "A JSON response is returned by the endpoint"

### Code-First Approach

**Show, Don't Just Tell**:
```python
# ✅ Good - Complete example
from fastapi import APIRouter

router = APIRouter(prefix="/api/items", tags=["items"])

@router.get("/")
async def list_items():
    return {"items": []}
```

```python
# ❌ Bad - Pseudo-code
from fastapi import APIRouter
# Create a router
# Add a GET endpoint
# Return items
```

**Complete Examples Only**:
- All code must be runnable as-is
- Include all necessary imports
- Show actual values, not placeholders
- Provide context (file paths, where code goes)

**Concrete Over Abstract**:
- ✅ "Edit `src/main.py` and add `app.include_router(items_router)`"
- ❌ "Register the router in your main application file"

### File Paths and Locations

**Always Use Explicit Paths**:
- ✅ "Create `src/features/api/endpoints.py`"
- ❌ "Create a new endpoints file"

**Show Full Context**:
```markdown
### Step 3: Register the Router

Edit the main application file at `src/main.py`:

```python
# Add this import at the top
from features.api.endpoints import router as api_router

# Add this after app initialization
app.include_router(api_router)
```
```

**Use Absolute Paths in Commands**:
```bash
# ✅ Explicit
cp plugins/python/templates/api.py.template src/features/api/endpoint.py

# ❌ Ambiguous (relative to where?)
cp template.py endpoint.py
```

### Template References

**Always Show Template Usage**:
```markdown
### Using the Template

Copy the template from the plugin:

```bash
# If working in ai-projen repository
cp plugins/languages/python/templates/fastapi-endpoint.py.template src/your_endpoint.py

# If plugin is installed in a project
cp .ai/plugins/python/templates/fastapi-endpoint.py.template src/your_endpoint.py
```

Then customize by replacing:
- `{{ENDPOINT_NAME}}` with your endpoint name
- `{{ROUTER_PREFIX}}` with your route prefix
```

### Explanation Depth

**Explain "Why" Not Just "What"**:
```markdown
### Step 2: Create Pydantic Models

Define request and response models for type safety and automatic documentation.
These models serve dual purposes:
1. Runtime validation of incoming data
2. Automatic OpenAPI schema generation

```python
class ItemRequest(BaseModel):
    name: str
    quantity: int
```
```

**Balance Detail and Clarity**:
- Provide enough context for understanding
- Don't over-explain obvious concepts
- Link to detailed docs for complex topics

---

## Template Integration

### How to Reference Templates

**Standard Pattern**:
```markdown
### Step X: Use the [Template Type] Template

```bash
# Copy from plugin location
cp plugins/[category]/[plugin]/templates/[template-name].template path/to/destination
```

Customize the template by:
1. Replacing `{{PLACEHOLDER1}}` with [description]
2. Replacing `{{PLACEHOLDER2}}` with [description]
3. Adjusting [specific section] for your use case
```

### Template Documentation

**List All Placeholders**:
```markdown
**Template Placeholders**:
- `{{SERVICE_NAME}}`: Name of the service (e.g., WebSocketService)
- `{{ENDPOINT}}`: API endpoint path (e.g., /api/stream)
- `{{PORT}}`: Service port (e.g., 8000)
```

**Show Before and After**:
```markdown
**Template**:
```python
class {{SERVICE_NAME}}:
    def __init__(self):
        self.url = "http://localhost:{{PORT}}{{ENDPOINT}}"
```

**After Customization**:
```python
class WebSocketService:
    def __init__(self):
        self.url = "http://localhost:8000/api/stream"
```
```

### Multiple Templates

**Show Workflow**:
```markdown
This task uses three templates:

1. **Service Class**: `websocket-service.ts.template`
2. **React Hook**: `websocket-hook.ts.template`
3. **Type Definitions**: `websocket-types.ts.template`

Follow these steps in order:

### Step 1: Create Service Class
```bash
cp plugins/typescript/templates/websocket-service.ts.template src/services/WebSocketService.ts
```

### Step 2: Create React Hook
```bash
cp plugins/typescript/templates/websocket-hook.ts.template src/hooks/useWebSocket.ts
```

### Step 3: Create Type Definitions
```bash
cp plugins/typescript/templates/websocket-types.ts.template src/types/websocket.types.ts
```
```

---

## Testing How-Tos

### Validation Requirements

Before considering a how-to complete, it MUST be tested:

#### 1. Self-Validation
- Author follows their own guide from scratch
- Document any steps that were unclear
- Time the process for accuracy
- Verify all code examples work

#### 2. Clean Environment Testing
- Test on a fresh clone of the repository
- Verify all dependencies are listed in prerequisites
- Confirm all file paths are correct
- Test all commands execute successfully

#### 3. Common Issues Discovery
- Test with missing prerequisites
- Test with common configuration errors
- Document all errors encountered
- Provide solutions for each

#### 4. Verification Step Testing
- Ensure verification steps actually work
- Confirm expected outputs match reality
- Test all provided commands
- Verify tests pass as claimed

### Testing Checklist

- [ ] All commands execute without errors
- [ ] All file paths are correct and accessible
- [ ] All code examples are complete and runnable
- [ ] Template references point to existing templates
- [ ] Verification steps confirm successful completion
- [ ] Common issues section addresses real problems
- [ ] Estimated time is accurate (±25%)
- [ ] Difficulty level matches actual complexity
- [ ] Prerequisites are complete and accurate
- [ ] Related resources are up-to-date

---

## File Naming and Organization

### Naming Convention

**Format**: `how-to-[action]-[object].md`

**Examples**:
- `how-to-add-api-endpoint.md`
- `how-to-create-react-component.md`
- `how-to-setup-development-environment.md`
- `how-to-implement-websocket.md`
- `how-to-write-unit-tests.md`

**Rules**:
- All lowercase
- Hyphens for word separation (not underscores)
- Start with `how-to-`
- Use verbs for actions (add, create, implement, setup, configure)
- Be specific but concise

### Directory Structure

**Plugin How-Tos**:
```
plugins/
└── [category]/
    └── [plugin]/
        └── howtos/
            ├── README.md              # Index of available how-tos
            ├── how-to-basic-task.md   # Beginner guides
            ├── how-to-advanced-task.md
            └── HOWTO_TEMPLATE.md      # Template for new guides
```

**Project How-Tos** (when plugin is installed):
```
.ai/
├── plugins/
│   └── [plugin]/
│       └── howtos/              # Copied from plugin
└── howtos/                      # Project-specific guides
    └── how-to-custom-task.md
```

### Organization Categories

**Within Plugin howtos/ Directory**:

Organize by complexity or topic:

**Option 1: By Difficulty** (recommended for language plugins):
```
howtos/
├── README.md
├── beginner/
│   ├── how-to-create-basic-endpoint.md
│   └── how-to-run-tests.md
├── intermediate/
│   ├── how-to-implement-authentication.md
│   └── how-to-add-database-model.md
└── advanced/
    └── how-to-implement-caching-layer.md
```

**Option 2: By Topic** (recommended for infrastructure plugins):
```
howtos/
├── README.md
├── deployment/
│   ├── how-to-deploy-to-aws.md
│   └── how-to-setup-blue-green-deployment.md
├── monitoring/
│   └── how-to-configure-logging.md
└── security/
    └── how-to-setup-secrets-management.md
```

**Option 3: Flat** (recommended for small plugin sets):
```
howtos/
├── README.md
├── how-to-task-1.md
├── how-to-task-2.md
└── how-to-task-3.md
```

### README.md Template

Each `howtos/` directory must have a README.md:

```markdown
# How-Tos for [Plugin Name]

This directory contains step-by-step guides for common tasks using the [Plugin Name] plugin.

## Available How-Tos

### Beginner
- [How to Create a Basic API Endpoint](how-to-create-basic-endpoint.md) - Create a simple REST endpoint with FastAPI
- [How to Run Tests](how-to-run-tests.md) - Execute unit tests with pytest

### Intermediate
- [How to Add Database Model](how-to-add-database-model.md) - Create SQLAlchemy models with migrations
- [How to Implement Authentication](how-to-implement-authentication.md) - Add JWT authentication to endpoints

### Advanced
- [How to Implement Caching](how-to-implement-caching-layer.md) - Add Redis caching for performance

## Using How-Tos

1. Check prerequisites in each guide before starting
2. Follow steps sequentially
3. Use referenced templates from `../templates/`
4. Verify implementation using provided tests
5. Consult common issues section if problems arise

## Contributing

When adding a new how-to:
1. Use the template in `HOWTO_TEMPLATE.md`
2. Follow standards in `.ai/docs/HOWTO_STANDARDS.md`
3. Reference templates where applicable
4. Test all steps work as documented
5. Add entry to this README
```

---

## Cross-References and Links

### Linking to Other How-Tos

**Use Relative Paths**:
```markdown
## Next Steps

- [How to Write Tests](how-to-write-tests.md) - Add test coverage
- [How to Deploy](../infrastructure/howtos/how-to-deploy.md) - Deploy to production
```

**Provide Context**:
```markdown
## Related How-Tos

- **[Create Database Model](how-to-create-database-model.md)** - Required before creating API endpoints that access data
- **[Setup Authentication](how-to-setup-authentication.md)** - Recommended for protecting API endpoints
```

### Linking to Documentation

**Link to Standards**:
```markdown
Follow the coding standards in `.ai/docs/STANDARDS.md` when implementing.
```

**Link to Plugin Docs**:
```markdown
For more details on the Python plugin, see `plugins/languages/python/README.md`.
```

**Link to Templates**:
```markdown
This guide uses the FastAPI endpoint template.
See `plugins/languages/python/templates/fastapi-endpoint.py.template` for details.
```

### Linking to External Resources

**Provide Official Documentation**:
```markdown
## Related Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/) - Official FastAPI docs
- [Pydantic Models](https://docs.pydantic.dev/) - Request/response validation
- [pytest Guide](https://docs.pytest.org/) - Testing framework
```

**Keep Links Current**:
- Use stable documentation URLs
- Prefer official sources
- Update links when they break

---

## Maintenance

### Keeping How-Tos Current

#### Update When:

1. **Templates Change**: Update how-to if referenced templates are modified
2. **Structure Changes**: Revise if project organization evolves
3. **Tool Updates**: Update commands/syntax for tool version changes
4. **New Issues Discovered**: Add to common issues section
5. **Better Approaches Found**: Revise steps with improved methods

#### Review Schedule

- **After Template Updates**: Immediately review affected how-tos
- **Quarterly**: Review all how-tos for accuracy
- **Before Major Releases**: Comprehensive validation
- **When Reported**: Fix issues reported by users

#### Deprecation Process

When a how-to becomes obsolete:

1. **Add Deprecation Notice** at the top:
```markdown
> **DEPRECATED**: This guide is outdated. See [New Guide](new-guide.md) instead.
```

2. **Keep for Reference**: Don't delete immediately
3. **Update Index**: Mark as deprecated in README.md
4. **Create Migration Path**: Provide link to replacement
5. **Remove After Grace Period**: Delete after 2 major versions

### Version Compatibility

**Document Tool Versions**:
```markdown
**Dependencies**:
- Python 3.11+
- FastAPI 0.100+
- Docker 24.0+
```

**Note Breaking Changes**:
```markdown
> **Note**: For FastAPI versions before 0.100, use the legacy pattern shown in [Legacy Guide](legacy/how-to-old-pattern.md).
```

---

## Quality Guidelines

### Checklist for High-Quality How-Tos

#### Content Quality
- [ ] Title clearly describes the task
- [ ] Metadata is complete and accurate
- [ ] Prerequisites are comprehensive
- [ ] Overview provides sufficient context
- [ ] Steps are logical and sequential
- [ ] All code examples are complete and tested
- [ ] Verification steps confirm success
- [ ] Common issues section is useful

#### Technical Accuracy
- [ ] All commands execute successfully
- [ ] All file paths are correct
- [ ] All code is syntactically correct
- [ ] All templates exist and are current
- [ ] Dependencies are correct and available
- [ ] Estimated time is realistic

#### AI-Agent Usability
- [ ] Instructions are explicit and unambiguous
- [ ] No assumed knowledge beyond prerequisites
- [ ] Integration points are clearly marked
- [ ] Success criteria are measurable
- [ ] Error states are documented

#### Human Readability
- [ ] Structure is clear and scannable
- [ ] Language is concise and direct
- [ ] Code blocks are properly formatted
- [ ] Links are descriptive and working
- [ ] Checklist summarizes the process

### Common Pitfalls to Avoid

**❌ Vague Instructions**:
```markdown
# Bad
Update the configuration file with appropriate settings.
```

**✅ Specific Instructions**:
```markdown
# Good
Edit `config/settings.yaml` and set:
```yaml
database:
  host: localhost
  port: 5432
```
```

**❌ Incomplete Code**:
```python
# Bad
# Import necessary modules
# Create the router
# Add endpoints
```

**✅ Complete Code**:
```python
# Good
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter(prefix="/api/items", tags=["items"])

class Item(BaseModel):
    name: str
    quantity: int

@router.get("/")
async def list_items():
    return {"items": []}
```

**❌ Missing Context**:
```markdown
# Bad
Run the tests.
```

**✅ Contextual Instructions**:
```markdown
# Good
Run the unit tests to verify the endpoint works:
```bash
make test-component COMPONENT=test/unit_test/api/test_items.py
```

Expected output:
```
===== 5 passed in 0.3s =====
```
```

---

## Examples

### Good How-To Example (Concise)

```markdown
# How-To: Run Unit Tests

**Purpose**: Execute unit tests using Make targets and verify code quality
**Scope**: Unit test execution, coverage analysis
**Overview**: Guide for running unit tests with consistent Docker-based execution.
**Dependencies**: Docker, Make, pytest
**Exports**: Test results, coverage reports
**Related**: .ai/docs/TESTING_STANDARDS.md
**Implementation**: Make-based test automation
**Difficulty**: beginner
**Estimated Time**: 5min

---

## Prerequisites

- Docker installed and running
- Project initialized (`make init`)

## Overview

This guide shows how to run unit tests using Make targets that ensure consistent
test execution across all development environments.

## Steps

### Step 1: Run All Tests

```bash
make test
```

Expected output:
```
===== 42 passed in 2.3s =====
```

### Step 2: Run with Coverage

```bash
make test-coverage
```

## Verification

Check that tests pass:
```bash
make test
# Should show: ===== X passed in Y.Ys =====
```

## Common Issues

### Issue: Docker Not Running

**Symptoms**: Error "Cannot connect to Docker daemon"

**Solution**:
```bash
# Start Docker
sudo systemctl start docker
```

## Checklist

- [ ] Docker is running
- [ ] Tests execute successfully
- [ ] Coverage report generated

## Related Resources

- [Testing Standards](.ai/docs/TESTING_STANDARDS.md)
- [Make Targets Reference](README.md#development-commands)
```

### Bad How-To Example (What to Avoid)

```markdown
# Running Tests

You can run tests using the test command.

## How to Do It

Just use the make command for testing. Make sure you have everything set up first.

```bash
make test
```

If it doesn't work, check your setup.

## More Info

See the docs for more information about testing.
```

**Problems**:
- Missing metadata
- Vague instructions ("everything set up")
- No prerequisites listed
- No verification steps
- No troubleshooting
- No complete examples
- Unhelpful "see the docs"

---

## Summary

### Key Principles

1. **AI-Agent First**: Write for automated consumption
2. **Complete Examples**: No pseudo-code, all code must run
3. **Explicit Paths**: Always show exact file locations
4. **Template Integration**: Show how to use plugin templates
5. **Verification**: Always include testing/validation steps
6. **Troubleshooting**: Document common issues proactively
7. **Maintenance**: Keep guides current as code evolves

### Quality Metrics

A high-quality how-to:
- Can be followed by an AI agent without human intervention
- Works on a clean environment without modifications
- Completes in the estimated time (±25%)
- Results in working, tested code
- Addresses the most common failure modes
- Integrates properly with the larger system

### Review Process

Before publishing a how-to:
1. ✅ Self-validate by following it yourself
2. ✅ Test on clean environment
3. ✅ Have peer review (human or AI)
4. ✅ Verify all links work
5. ✅ Confirm all templates exist
6. ✅ Check difficulty and time estimates
7. ✅ Validate against this standards document
