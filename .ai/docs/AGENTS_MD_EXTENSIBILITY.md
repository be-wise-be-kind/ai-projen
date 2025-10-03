# agents.md Extensibility Pattern

**Purpose**: How plugins extend the agents.md file to add their specific instructions

**Scope**: Plugin extension markers, content injection patterns, and best practices

**Overview**: Defines how plugins programmatically extend the root agents.md file by injecting
    content between designated markers. This enables composable, plugin-based documentation where
    each plugin contributes its specific guidelines, commands, and standards to the unified agent guide.

**Dependencies**: agents.md.template (from ai-folder plugin)

**Exports**: Extension patterns, marker conventions, injection guidelines

**Related**: PLUGIN_ARCHITECTURE.md for plugin structure, ai-folder plugin for base template

**Implementation**: Marker-based content injection with clear section boundaries

---

## Overview

The `agents.md` file is the primary entry point for AI agents. It must be composable - plugins should be able to add their specific content without conflicts.

## Extension Markers

The `agents.md.template` includes special markers that plugins can target for content injection:

```markdown
### LANGUAGE_SPECIFIC_GUIDELINES
Language plugins add their specific conventions here.
### END_LANGUAGE_SPECIFIC_GUIDELINES

### INFRASTRUCTURE_COMMANDS
Infrastructure plugins add deployment/ops commands here.
### END_INFRASTRUCTURE_COMMANDS

### STANDARDS_CHECKLIST
Standards plugins add compliance checklists here.
### END_STANDARDS_CHECKLIST
```

## How Plugins Extend agents.md

### Pattern 1: Content Injection

When a plugin is installed, it should:

1. **Read** the existing `agents.md` file
2. **Find** the appropriate marker section
3. **Insert** plugin-specific content between the markers
4. **Write** the updated file back

### Example: Python Plugin

```markdown
# In Python plugin's AGENT_INSTRUCTIONS.md

Step 5: Extend agents.md

Add Python-specific guidelines to agents.md:

1. Read agents.md
2. Find the LANGUAGE_SPECIFIC_GUIDELINES section
3. Insert between markers:

### LANGUAGE_SPECIFIC_GUIDELINES

#### Python (PEP 8)
- Use 4 spaces for indentation
- Maximum line length: 88 characters (Black default)
- Follow PEP 8 naming conventions:
  - snake_case for functions and variables
  - PascalCase for classes
  - UPPER_CASE for constants
- Use type hints for function signatures
- Docstrings: Google or NumPy style

**Linting**: `make lint-python` (runs Ruff)
**Formatting**: `make format-python` (runs Black)
**Testing**: `make test-python` (runs pytest)

### END_LANGUAGE_SPECIFIC_GUIDELINES
```

### Example: Docker Plugin

```markdown
# In Docker plugin's AGENT_INSTRUCTIONS.md

Step 6: Extend agents.md

Add Docker commands to agents.md:

1. Read agents.md
2. Find the INFRASTRUCTURE_COMMANDS section
3. Insert between markers:

### INFRASTRUCTURE_COMMANDS

#### Docker

**Build containers**:
```bash
make docker-build
# or
docker-compose build
```

**Start services**:
```bash
make docker-up
# or
docker-compose up -d
```

**Stop services**:
```bash
make docker-down
# or
docker-compose down
```

**View logs**:
```bash
make docker-logs
# or
docker-compose logs -f
```

### END_INFRASTRUCTURE_COMMANDS
```

### Example: Security Standards Plugin

```markdown
# In Security plugin's AGENT_INSTRUCTIONS.md

Step 4: Extend agents.md

Add security checklist to agents.md:

1. Read agents.md
2. Find the STANDARDS_CHECKLIST section
3. Insert between markers:

### STANDARDS_CHECKLIST

#### Security Standards

Before committing:
- [ ] No secrets in code (use .env)
- [ ] No hardcoded credentials
- [ ] Dependencies scanned (make security-scan)
- [ ] No high-severity vulnerabilities
- [ ] Input validation present
- [ ] Error messages don't leak sensitive info

Run: `make security-check` to validate all standards

### END_STANDARDS_CHECKLIST
```

## Available Marker Sections

### 1. LANGUAGE_SPECIFIC_GUIDELINES
**Purpose**: Language-specific coding conventions and style guides

**Plugins that use this**:
- Python (PEP 8, type hints, docstrings)
- TypeScript (ESLint rules, naming conventions)
- Go (gofmt, naming)
- Rust (rustfmt, clippy)
- Java (Google/Oracle style)

**Content format**:
```markdown
#### <Language Name> (<Style Guide>)
- Specific conventions
- Naming patterns
- Formatting rules

**Commands**: make commands for lint/format/test
```

### 2. INFRASTRUCTURE_COMMANDS
**Purpose**: Deployment, containerization, and operational commands

**Plugins that use this**:
- Docker (build, up, down, logs)
- GitHub Actions (workflow triggers)
- Terraform (plan, apply, destroy)
- Kubernetes (kubectl commands)

**Content format**:
```markdown
#### <Infrastructure Tool>

**<Action>**:
```bash
make <command>
# or
<direct command>
```

Explanation of what it does.
```

### 3. STANDARDS_CHECKLIST
**Purpose**: Quality gates, compliance checks, and validation steps

**Plugins that use this**:
- Security (secrets, dependencies, scanning)
- Documentation (headers, README, comments)
- Pre-commit (hook validation)
- Accessibility (WCAG compliance)
- Performance (benchmarks)

**Content format**:
```markdown
#### <Standard Name>

Before <event>:
- [ ] Checklist item
- [ ] Checklist item

Run: `make <validation-command>` to validate
```

## Implementation Guidelines

### For Plugin Authors

1. **Read First**: Always read the current agents.md before modifying
2. **Find Markers**: Locate the appropriate section markers
3. **Insert Between**: Add content BETWEEN markers, not replacing them
4. **Preserve Structure**: Keep the markdown structure consistent
5. **Avoid Conflicts**: Don't modify other plugins' content
6. **Clear Commands**: Provide exact commands (preferably Make targets)
7. **Test**: Verify the updated agents.md renders correctly

### Content Structure

Each plugin's contribution should:
- Start with a clear heading (#### Plugin Name)
- Be self-contained
- Include actionable commands
- Be concise (prefer bullet points)
- Link to detailed docs in `.ai/docs/` if needed

### Example Implementation (Pseudocode)

```python
def extend_agents_md(plugin_name, section_marker, content):
    """Extend AGENTS.md with plugin-specific content"""

    # Read current AGENTS.md
    with open('AGENTS.md', 'r') as f:
        current_content = f.read()

    # Find the marker section
    start_marker = f"### {section_marker}"
    end_marker = f"### END_{section_marker}"

    # Check if markers exist
    if start_marker not in current_content:
        raise ValueError(f"Marker {start_marker} not found in AGENTS.md")

    # Extract existing content between markers
    start_idx = current_content.find(start_marker) + len(start_marker)
    end_idx = current_content.find(end_marker)
    existing_section = current_content[start_idx:end_idx]

    # Check if plugin already added content
    if f"#### {plugin_name}" in existing_section:
        # Update existing content or skip
        return

    # Insert new content before end marker
    new_content = content.strip() + "\n\n"
    updated_content = (
        current_content[:end_idx] +
        new_content +
        current_content[end_idx:]
    )

    # Write back
    with open('AGENTS.md', 'w') as f:
        f.write(updated_content)
```

## Multiple Languages/Tools

When multiple plugins of the same type are installed:

```markdown
### LANGUAGE_SPECIFIC_GUIDELINES

#### Python (PEP 8)
- Python conventions
**Commands**: make lint-python, make test-python

#### TypeScript (ESLint)
- TypeScript conventions
**Commands**: make lint-ts, make test-ts

#### Go (gofmt)
- Go conventions
**Commands**: make lint-go, make test-go

### END_LANGUAGE_SPECIFIC_GUIDELINES
```

Each plugin adds its section without interfering with others.

## Custom Markers

Plugins can propose new markers if needed:

```markdown
### CUSTOM_MARKER_NAME
Description of what goes here.
### END_CUSTOM_MARKER_NAME
```

To add a custom marker:
1. Propose it in the plugin's README
2. Add it to agents.md.template in ai-folder plugin
3. Document it in this file
4. Update PLUGIN_ARCHITECTURE.md

## Best Practices

### Do's
- ✅ Add content between markers, not outside
- ✅ Use clear heading for your plugin (#### Plugin Name)
- ✅ Provide exact, runnable commands
- ✅ Keep content concise
- ✅ Link to detailed docs if needed
- ✅ Test that markdown renders correctly
- ✅ Preserve existing plugin content

### Don'ts
- ❌ Don't modify content from other plugins
- ❌ Don't remove markers
- ❌ Don't add content outside marker sections
- ❌ Don't use vague commands ("run tests")
- ❌ Don't duplicate content that's in .ai/docs/
- ❌ Don't assume specific tools (provide alternatives)

## Validation

Plugins should validate their extensions:

```bash
# Check AGENTS.md still parses as valid markdown
# Check all command examples are syntactically correct
# Check links to .ai/docs/ resolve
# Check no duplicate headings
```

## Example: Complete Flow

**User installs Python + TypeScript + Docker**:

1. **ai-folder plugin**: Creates agents.md from template with markers
2. **Python plugin**: Adds PEP 8 guidelines and commands to LANGUAGE_SPECIFIC_GUIDELINES
3. **TypeScript plugin**: Adds ESLint guidelines and commands to LANGUAGE_SPECIFIC_GUIDELINES
4. **Docker plugin**: Adds container commands to INFRASTRUCTURE_COMMANDS

**Result**: Unified agents.md with all relevant information

```markdown
# AI Agent Guide for my-project

## Navigation
...

## Development Guidelines

### LANGUAGE_SPECIFIC_GUIDELINES

#### Python (PEP 8)
- Use 4 spaces for indentation
- Maximum line length: 88 characters
**Commands**: make lint-python, make format-python, make test-python

#### TypeScript (ESLint)
- Use 2 spaces for indentation
- Prefer interfaces over types
**Commands**: make lint-ts, make format-ts, make test-ts

### END_LANGUAGE_SPECIFIC_GUIDELINES

### INFRASTRUCTURE_COMMANDS

#### Docker
**Build**: `make docker-build`
**Start**: `make docker-up`
**Stop**: `make docker-down`

### END_INFRASTRUCTURE_COMMANDS
```

## Future Extensions

Potential additional markers:
- `### API_DOCUMENTATION` - API endpoint listings
- `### DATABASE_MIGRATIONS` - Migration commands
- `### MONITORING_COMMANDS` - Observability commands
- `### PERFORMANCE_TESTING` - Benchmark commands

---

**Remember**: agents.md is the first file AI agents read. Keep it actionable, accurate, and up-to-date through composable plugin extensions.
