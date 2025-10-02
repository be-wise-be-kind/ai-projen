# Documentation Standards Plugin

**Purpose**: Comprehensive documentation standards for all file types including file headers, README templates, and API documentation guidelines

**Status**: ✅ Stable

---

## What This Plugin Provides

A complete documentation framework establishing unified standards for file headers, README files, API documentation, and general documentation practices across all file types in any project.

### Documentation Standards Included

1. **File Header Standards**
   - Comprehensive header formats for all file types
   - Atemporal documentation principles
   - Mandatory fields (Purpose, Scope, Overview)
   - File-type specific formatting guidelines
   - Template placeholder conventions

2. **README Standards**
   - Project README structure
   - Content organization guidelines
   - Essential sections and optional enhancements
   - Tech stack documentation
   - Installation and usage documentation

3. **API Documentation Standards**
   - REST API documentation best practices
   - Endpoint documentation templates
   - Request/response examples
   - Authentication and authorization docs
   - Error handling documentation

### File Types Covered

This plugin provides standards and templates for:
- **Markdown** (.md) - Documentation files
- **Python** (.py) - Python modules and scripts
- **TypeScript/JavaScript** (.ts, .tsx, .js, .jsx) - TypeScript and JavaScript files
- **YAML** (.yml, .yaml) - Configuration files
- **JSON** (.json) - Configuration and data files
- **Terraform** (.tf, .hcl) - Infrastructure as code
- **Docker** (Dockerfile, docker-compose.yml) - Container configurations
- **HTML** (.html) - Web pages
- **CSS/SCSS** (.css, .scss) - Stylesheets
- **Shell Scripts** (.sh, .ps1, .bat) - Automation scripts

---

## Quick Start

### For AI Agents

Follow the comprehensive instructions in `AGENT_INSTRUCTIONS.md`:

```bash
cat plugins/standards/documentation/AGENT_INSTRUCTIONS.md
# Then follow Steps 1-10
```

### For Manual Installation

1. **Copy documentation standards**:
   ```bash
   mkdir -p .ai/docs
   cp plugins/standards/documentation/ai-content/standards/DOCUMENTATION_STANDARDS.md .ai/docs/FILE_HEADER_STANDARDS.md
   cp plugins/standards/documentation/ai-content/docs/*.md .ai/docs/
   ```

2. **Copy how-to guides**:
   ```bash
   mkdir -p .ai/howto
   cp plugins/standards/documentation/ai-content/howtos/*.md .ai/howto/
   ```

3. **Copy templates**:
   ```bash
   mkdir -p .ai/templates
   cp plugins/standards/documentation/ai-content/templates/*.template .ai/templates/
   ```

4. **Use templates for new files**:
   ```bash
   # For a new Python file
   cat .ai/templates/file-header-python.template
   # Copy header structure and replace placeholders

   # For a new README
   cp .ai/templates/README.template README.md
   # Customize placeholders
   ```

## Core Principles

### 1. Atemporal Documentation

Documentation must be written in an atemporal manner, avoiding references to time or change:

**Avoid**:
- ❌ "Currently supports..."
- ❌ "Recently added..."
- ❌ "Will implement..."
- ❌ "Changed from X to Y"
- ❌ "Created: 2025-09-12"

**Use**:
- ✅ "Supports..."
- ✅ "Provides..."
- ✅ "Handles..."
- ✅ "Implements..."

### 2. Mandatory Header Fields

All files must include:

- **Purpose**: Brief description of file's functionality (1-2 lines)
- **Scope**: What areas/components this file covers
- **Overview**: Comprehensive summary (3-5+ lines)

### 3. File-Type Specific Formatting

Each file type has specific formatting requirements:

**Markdown**:
```markdown
# Document Title

**Purpose**: Brief description

**Scope**: Coverage area

**Overview**: Comprehensive explanation

---
```

**Python**:
```python
"""
Purpose: Brief description

Scope: Coverage area

Overview: Comprehensive explanation

Dependencies: Key dependencies
Exports: Main classes/functions
"""
```

**TypeScript**:
```typescript
/**
 * Purpose: Brief description
 *
 * Scope: Coverage area
 *
 * Overview: Comprehensive explanation
 */
```

**YAML**:
```yaml
# Purpose: Brief description
# Scope: Coverage area
# Overview: Comprehensive explanation
```

### 4. Focus on Operational Information

Headers should document:
- What the file does (functionality)
- How it fits into the system (architecture)
- What it depends on (dependencies)
- What it provides (exports/interfaces)
- Important implementation details

**Don't duplicate Git information**:
- No creation dates (Git shows this)
- No modification history (Git tracks this)
- No author names (Git commits show this)
- No version numbers (Git tags handle this)

## Available Templates

### File Header Templates

#### file-header-markdown.template
Use for: All markdown documentation files

**Placeholders**:
- `{{DOCUMENT_TITLE}}` - Document name
- `{{PURPOSE}}` - Brief description
- `{{SCOPE}}` - Coverage area
- `{{OVERVIEW}}` - Detailed explanation
- `{{DEPENDENCIES}}` - Related documents
- `{{EXPORTS}}` - Key information provided
- `{{RELATED}}` - Cross-references
- `{{IMPLEMENTATION}}` - Organizational approach

#### file-header-python.template
Use for: Python modules, scripts, packages

**Placeholders**:
- `{{MODULE_NAME}}` - Module name in snake_case
- `{{PURPOSE}}` - Module functionality
- `{{SCOPE}}` - Module responsibilities
- `{{OVERVIEW}}` - Comprehensive description
- `{{DEPENDENCIES}}` - External dependencies
- `{{EXPORTS}}` - Classes, functions, constants
- `{{INTERFACES}}` - APIs and endpoints
- `{{IMPLEMENTATION}}` - Algorithms and patterns

#### file-header-typescript.template
Use for: React components, TypeScript modules, JavaScript files

**Placeholders**:
- `{{MODULE_NAME}}` - Component/module name
- `{{PURPOSE}}` - Component functionality
- `{{SCOPE}}` - Component responsibilities
- `{{OVERVIEW}}` - Comprehensive description
- `{{DEPENDENCIES}}` - Libraries and components
- `{{EXPORTS}}` - Exported components/functions
- `{{PROPS_INTERFACES}}` - Props and interfaces
- `{{STATE_BEHAVIOR}}` - State management

#### file-header-yaml.template
Use for: YAML configuration, docker-compose, workflows

**Placeholders**:
- `{{CONFIG_NAME}}` - Configuration name
- `{{PURPOSE}}` - Configuration purpose
- `{{SCOPE}}` - What it configures
- `{{OVERVIEW}}` - Detailed explanation
- `{{DEPENDENCIES}}` - Related configurations
- `{{EXPORTS}}` - Configuration sections
- `{{ENVIRONMENT}}` - Target environments
- `{{IMPLEMENTATION}}` - Configuration patterns

#### README.template
Use for: Project README files

**Placeholders**:
- `{{PROJECT_NAME}}` - Project name
- `{{PROJECT_DESCRIPTION}}` - Brief description
- `{{TECH_STACK}}` - Technologies used
- `{{PREREQUISITES}}` - Installation requirements
- `{{INSTALLATION_STEPS}}` - Setup instructions
- `{{USAGE_EXAMPLES}}` - Usage examples
- `{{PROJECT_STRUCTURE}}` - Directory layout
- `{{DEVELOPMENT_GUIDELINES}}` - Dev standards

## How-To Guides

### Available Guides

1. **How to Write File Headers** (15-20 min, Beginner)
   - Step-by-step header creation
   - Field-by-field guidance
   - File-type specific examples
   - Common mistakes to avoid
   - Validation checklist

2. **How to Create a README** (30-45 min, Intermediate)
   - README structure and sections
   - Essential vs optional content
   - Tech stack documentation
   - Installation instructions
   - Usage examples and project structure

3. **How to Document an API** (45-60 min, Intermediate)
   - REST API documentation patterns
   - Endpoint documentation
   - Request/response examples
   - Authentication documentation
   - Error handling and status codes

### Using the Guides

Each guide includes:
- **Prerequisites** - What you need to know first
- **Step-by-step instructions** - Clear, actionable steps
- **Examples** - Real-world examples
- **Templates** - Code and documentation templates
- **Verification steps** - How to validate your work
- **Common issues** - Troubleshooting help
- **Best practices** - Industry standards
- **Checklists** - Ensure completeness

Access guides:
```bash
# View guide index
cat .ai/howto/documentation-howtos-README.md

# View specific guide
cat .ai/howto/how-to-write-file-headers.md
```

## Documentation Reference

### File Header Standards

Complete reference: `.ai/docs/file-headers.md` or `.ai/docs/FILE_HEADER_STANDARDS.md`

Key topics:
- Atemporal documentation principle
- Standard header formats for all file types
- Line break and formatting guidelines
- Required vs optional fields
- Template file requirements
- Implementation guidelines
- Validation rules

### README Standards

Complete reference: `.ai/docs/readme-standards.md`

Key topics:
- README structure and organization
- Essential sections (overview, installation, usage)
- Optional sections (contributing, architecture, FAQ)
- Tech stack documentation
- Project structure documentation
- Development guidelines

### API Documentation

Complete reference: `.ai/docs/api-documentation.md`

Key topics:
- REST API documentation structure
- Endpoint documentation format
- Request/response documentation
- Authentication and authorization
- Error handling and status codes
- OpenAPI/Swagger integration
- Code examples and SDKs

## Integration with Other Plugins

### Python Plugin

When using with Python plugin:
- Python files automatically follow header standards
- Use file-header-python.template for consistency
- Python standards reference FILE_HEADER_STANDARDS.md
- Docstrings follow Google-style format

### TypeScript Plugin

When using with TypeScript:
- Use file-header-typescript.template for components
- Follow JSDoc conventions
- Include Props/Interfaces for React components
- Document state management patterns

### Docker Plugin

When using with Docker:
- Use file-header-yaml.template for docker-compose.yml
- Document Dockerfile stages and purposes
- Include service dependencies and networking
- Document environment variables

### Terraform Plugin

When using with Terraform:
- Adapt file-header-yaml.template for .tf files
- Document resource dependencies
- Include environment-specific notes
- Document outputs and variables

### AI Folder Plugin

Required integration:
- Copies templates to .ai/templates/
- Adds standards to .ai/docs/
- Adds how-to guides to .ai/howto/
- Updates .ai/index.yaml with documentation references

## Validation

### Manual Validation

Check files against standards:

```bash
# Check for temporal language
grep -r "currently\|now\|recently\|will be" src/ --include="*.py"

# Check for Purpose field in Python files
grep -L "^Purpose:" src/**/*.py

# Validate README sections
grep "^## " README.md
```

### Template Validation

When using templates:
1. Verify all `{{PLACEHOLDERS}}` are replaced
2. Check mandatory fields are present
3. Validate formatting for file type
4. Ensure no temporal language

### Automated Validation (Future)

If header linter is available:
```bash
# Validate all files
python tools/design_linters/header_linter.py --path .

# Validate specific file
python tools/design_linters/header_linter.py --file src/module.py
```

## Common Use Cases

### Starting a New Project

1. Install ai-folder plugin first
2. Install documentation plugin
3. Create README.md from template
4. Use file header templates for all new files

### Documenting Existing Project

1. Install documentation plugin
2. Add header to README.md (if missing sections)
3. Prioritize headers for:
   - Main source files
   - Configuration files
   - Documentation files
4. Use templates for new files going forward

### Team Standardization

1. Install documentation plugin
2. Share .ai/docs/ standards with team
3. Add pre-commit hooks for validation
4. Reference how-to guides for training
5. Use templates for all new files

### API-Focused Project

1. Install documentation plugin
2. Review .ai/docs/api-documentation.md
3. Document all endpoints using standards
4. Create OpenAPI/Swagger spec
5. Include API examples in README

## Best Practices

### File Headers

1. **Always include mandatory fields**: Purpose, Scope, Overview
2. **Use atemporal language**: Describe current state, not history
3. **Be comprehensive in Overview**: Explain role and operation
4. **List key dependencies**: Help readers understand requirements
5. **Document exports**: What does this file provide?

### README Files

1. **Start with clear purpose**: What does this project do?
2. **Include installation steps**: Make it easy to get started
3. **Provide usage examples**: Show how to use the project
4. **Document tech stack**: List all major technologies
5. **Keep it updated**: Review README when making major changes

### API Documentation

1. **Document all endpoints**: No undocumented APIs
2. **Include examples**: Request and response examples
3. **Document errors**: All error codes and messages
4. **Show authentication**: How to authenticate requests
5. **Provide SDKs**: Link to client libraries if available

## Troubleshooting

### Issue: Don't know which template to use

**Solution**:
- .md files → file-header-markdown.template
- .py files → file-header-python.template
- .ts, .tsx, .js, .jsx → file-header-typescript.template
- .yml, .yaml → file-header-yaml.template
- New README → README.template

### Issue: Template has placeholders in code

**Solution**: Templates are meant to be copied and customized. Replace all `{{PLACEHOLDER}}` values with actual content.

### Issue: Existing files missing headers

**Solution**:
1. Prioritize critical files (main source, configs, docs)
2. Add headers gradually using templates
3. Focus on new files going forward
4. Consider automated migration scripts

### Issue: README doesn't match standards

**Solution**:
1. Review .ai/docs/readme-standards.md
2. Compare with .ai/templates/README.template
3. Add missing sections incrementally
4. Focus on essential sections first

### Issue: Headers too verbose

**Solution**:
- Overview can be 3-5 lines for simple files
- Adjust verbosity to project size
- Keep mandatory fields concise
- Focus on operational information

## Why These Standards?

### Benefits

1. **Clarity**: Easy to understand what each file does
2. **Maintainability**: Clear documentation helps maintenance
3. **Onboarding**: New developers quickly understand codebase
4. **Consistency**: Uniform documentation across project
5. **Self-documenting**: Code documents itself
6. **AI-friendly**: AI agents can understand and work with code better
7. **No redundancy**: Don't duplicate Git information

### Atemporal Approach

Avoiding temporal language ensures:
- Documentation stays accurate without updates
- No obsolete references to "current" state
- Focus on functionality, not history
- Easier to maintain long-term
- Clear and concise descriptions

### Comprehensive but Practical

Standards are thorough but:
- Templates make them easy to apply
- How-to guides provide step-by-step help
- Mandatory fields are minimal
- Additional fields are optional
- Adaptable to project needs

## Dependencies

- **Git**: Version control system
- **AI Folder Plugin**: .ai directory structure
- **Text Editor**: For editing templates and documentation

## Support and Contribution

- **Documentation**: See AGENT_INSTRUCTIONS.md for detailed setup
- **Standards**: See .ai/docs/ for complete standards
- **Examples**: See templates/ for templates and examples
- **Issues**: Report issues to ai-projen repository

## License

Part of the ai-projen framework. See main repository for license details.

---

**Version**: 1.0.0
**Last Updated**: 2025-10-02
**Reference**: Based on FILE_HEADER_STANDARDS.md and durable-code-test patterns
