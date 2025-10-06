# Documentation Standards Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install comprehensive documentation standards including file headers, README templates, and API documentation guidelines

**Scope**: Installation and configuration of documentation standards for all file types in any project

**Overview**: Step-by-step instructions for AI agents to install the documentation standards plugin that establishes
    unified documentation practices across all file types. This plugin provides file header templates, README
    documentation standards, API documentation guidelines, and comprehensive how-to guides for creating consistent,
    high-quality documentation throughout the codebase. The standards enforce atemporal documentation principles
    and provide templates for markdown, Python, TypeScript, YAML, and other file types.

**Dependencies**: .ai folder structure (ai-folder plugin), git repository initialized

**Exports**: Documentation standards, file header templates, README templates, API documentation guidelines, and how-to guides

**Related**: FILE_HEADER_STANDARDS.md, ai-folder plugin, language plugins (Python, TypeScript)

**Implementation**: Template-based installation with comprehensive standards documentation and validation guidelines

---

## Prerequisites

Before installing this plugin, ensure:
- ✅ Git repository is initialized (`git init` has been run)
- ✅ .ai folder structure exists (ai-folder plugin installed)
- ✅ You understand the project's file types and documentation needs

## Installation Steps

### Step 1: Understand Documentation Requirements

Assess the project's documentation needs:
1. **File Types**: What file types need headers? (Python, TypeScript, YAML, Terraform, etc.)
2. **Documentation Scope**: README only, or comprehensive documentation?
3. **API Documentation**: Does the project expose APIs that need documentation?
4. **Team Size**: Single developer or team needing consistent standards?

### Step 2: Copy Documentation Standards

Copy the comprehensive documentation standards to the project:

```bash
# Copy the main standards document
cp plugins/standards/documentation/ai-content/standards/DOCUMENTATION_STANDARDS.md .ai/docs/

# If FILE_HEADER_STANDARDS.md doesn't exist, copy it
if [ ! -f .ai/docs/FILE_HEADER_STANDARDS.md ]; then
  cp plugins/standards/documentation/ai-content/standards/DOCUMENTATION_STANDARDS.md .ai/docs/FILE_HEADER_STANDARDS.md
fi
```

### Step 3: Copy Documentation Guides

Copy the documentation reference guides to .ai/docs/:

```bash
# Create docs directory if it doesn't exist
mkdir -p .ai/docs

# Copy documentation guides
# Note: file-headers.md not copied - FILE_HEADER_STANDARDS.md already installed in Step 2
cp plugins/standards/documentation/ai-content/docs/readme-standards.md .ai/docs/
cp plugins/standards/documentation/ai-content/docs/api-documentation.md .ai/docs/
```

### Step 4: Copy How-To Guides

Copy the practical how-to guides to .ai/howto/:

```bash
# Create howto directory if it doesn't exist
mkdir -p .ai/howto

# Copy how-to guides
cp plugins/standards/documentation/ai-content/howtos/README.md .ai/howto/documentation-howtos-README.md
cp plugins/standards/documentation/ai-content/howtos/how-to-write-file-headers.md .ai/howto/
cp plugins/standards/documentation/ai-content/howtos/how-to-create-readme.md .ai/howto/
cp plugins/standards/documentation/ai-content/howtos/how-to-document-api.md .ai/howto/
```

### Step 5: Copy File Header Templates

Copy the file header templates to .ai/templates/:

```bash
# Create templates directory if it doesn't exist
mkdir -p .ai/templates

# Copy file header templates
cp plugins/standards/documentation/ai-content/templates/file-header-markdown.template .ai/templates/
cp plugins/standards/documentation/ai-content/templates/file-header-python.template .ai/templates/
cp plugins/standards/documentation/ai-content/templates/file-header-typescript.template .ai/templates/
cp plugins/standards/documentation/ai-content/templates/file-header-yaml.template .ai/templates/

# Copy README template
cp plugins/standards/documentation/ai-content/templates/README.template .ai/templates/
```

### Step 6: Update Project Index (Optional)

Update .ai/index.yaml to include documentation standards:

```yaml
standards:
  documentation:
    file_headers: .ai/docs/FILE_HEADER_STANDARDS.md
    readme_standards: .ai/docs/readme-standards.md
    api_documentation: .ai/docs/api-documentation.md

templates:
  documentation:
    - .ai/templates/file-header-markdown.template
    - .ai/templates/file-header-python.template
    - .ai/templates/file-header-typescript.template
    - .ai/templates/file-header-yaml.template
    - .ai/templates/README.template

howto:
  documentation:
    - .ai/howto/how-to-write-file-headers.md
    - .ai/howto/how-to-create-readme.md
    - .ai/howto/how-to-document-api.md
```

### Step 7: Create or Update README.md

If the project doesn't have a README.md, create one using the template:

```bash
# Check if README.md exists
if [ ! -f README.md ]; then
  # Copy template and customize
  cp .ai/templates/README.template README.md
  # Inform user to customize placeholders
  echo "README.md created from template. Please customize {{PLACEHOLDERS}}."
else
  # Inform user that README exists
  echo "README.md already exists. Review .ai/docs/readme-standards.md for standards."
fi
```

**Variables to replace in README.template:**
- `{{PROJECT_NAME}}` → Actual project name
- `{{PROJECT_DESCRIPTION}}` → Brief project description
- `{{TECH_STACK}}` → Technologies used
- `{{PREREQUISITES}}` → Prerequisites for installation
- `{{INSTALLATION_STEPS}}` → Installation instructions
- `{{USAGE_EXAMPLES}}` → Usage examples
- `{{PROJECT_STRUCTURE}}` → Directory structure
- `{{DEVELOPMENT_GUIDELINES}}` → Development standards

### Step 8: Apply Headers to Existing Files (Optional)

For existing projects, apply file headers to key files:

**Priority files for headers:**
1. All files in .ai/docs/
2. All files in .ai/howto/
3. Configuration files (pyproject.toml, package.json, docker-compose.yml)
4. Main source files
5. Test files

**Example - Add header to Python file:**
```bash
# Review the file
cat src/main.py

# Manually add header using file-header-python.template as reference
# Or use an AI agent to add headers following the template
```

### Step 9: Validate Installation

Verify the following structure exists:

```
.ai/
├── docs/
│   ├── FILE_HEADER_STANDARDS.md
│   ├── readme-standards.md
│   └── api-documentation.md
├── howto/
│   ├── how-to-write-file-headers.md
│   ├── how-to-create-readme.md
│   └── how-to-document-api.md
└── templates/
    ├── file-header-markdown.template
    ├── file-header-python.template
    ├── file-header-typescript.template
    ├── file-header-yaml.template
    └── README.template

README.md (created or reviewed)
```

### Step 10: Verify Documentation Standards

Check that the standards are accessible:

```bash
# Check main standards document
cat .ai/docs/FILE_HEADER_STANDARDS.md | head -50

# Check templates exist
ls -la .ai/templates/file-header-*.template

# Check how-to guides exist
ls -la .ai/howto/how-to-*.md
```

## Post-Installation

After successful installation:

1. **Inform the user** about the installed documentation standards
2. **Explain file header requirements** for new files
3. **Reference the how-to guides** for practical guidance
4. **Suggest next steps**:
   - Review .ai/docs/FILE_HEADER_STANDARDS.md for header standards
   - Use templates when creating new files
   - Apply headers to existing critical files
   - Review README.md against readme-standards.md

## Using the Documentation Standards

### For New Files

When creating new files, always start with the appropriate header template:

**Markdown files:**
```bash
# Copy template
cat .ai/templates/file-header-markdown.template

# Use template structure and replace placeholders
```

**Python files:**
```bash
# Copy template
cat .ai/templates/file-header-python.template

# Use template structure and replace placeholders
```

**TypeScript/JavaScript files:**
```bash
# Copy template
cat .ai/templates/file-header-typescript.template

# Use template structure and replace placeholders
```

**YAML configuration files:**
```bash
# Copy template
cat .ai/templates/file-header-yaml.template

# Use template structure and replace placeholders
```

### File Header Key Principles

From FILE_HEADER_STANDARDS.md, always follow these principles:

1. **Atemporal Documentation**: Never use temporal language
   - ❌ "Currently supports...", "Recently added...", "Will implement..."
   - ✅ "Supports...", "Provides...", "Handles..."

2. **Mandatory Fields**:
   - **Purpose**: Brief description (1-2 lines)
   - **Scope**: What areas/components this file covers
   - **Overview**: Comprehensive summary (3-5+ lines)

3. **File-Type Specific Formatting**:
   - Markdown: Use `**Field**:` format with double line breaks
   - Python: Use `"""` docstrings with blank lines between fields
   - TypeScript: Use `/** */` JSDoc format with asterisk continuation
   - YAML: Use `# Field:` comment format

4. **Focus on What, Not When**:
   - Describe current capabilities
   - Explain purpose and role
   - Document interfaces and dependencies
   - Avoid historical context or future plans

### For README Files

When creating or updating README.md:

1. Review .ai/docs/readme-standards.md for structure
2. Use .ai/templates/README.template as starting point
3. Include these sections:
   - Project title and description
   - Tech stack
   - Installation instructions
   - Usage examples
   - Project structure
   - Development guidelines
   - License

### For API Documentation

When documenting APIs:

1. Review .ai/docs/api-documentation.md for best practices
2. Document each endpoint with:
   - HTTP method and path
   - Purpose and description
   - Request parameters and body
   - Response format and status codes
   - Authentication requirements
   - Example requests and responses

## Integration with Language Plugins

### Python Plugin Integration

If using the Python plugin:
- Python file headers already follow these standards
- Use file-header-python.template for consistency
- Python standards document references FILE_HEADER_STANDARDS.md

### TypeScript Plugin Integration

If using TypeScript/JavaScript:
- Use file-header-typescript.template for components and modules
- Follow JSDoc conventions in the template
- Include Props/Interfaces and State/Behavior sections for React components

### Docker Plugin Integration

For Docker configuration files:
- Use file-header-yaml.template for docker-compose.yml
- Include Purpose, Scope, Overview in Dockerfile comments
- Document service dependencies and networking

### Terraform Plugin Integration

For infrastructure as code:
- Use file-header-yaml.template adapted for .tf files
- Document resource dependencies
- Include environment-specific notes

## Validation and Linting

The documentation standards can be validated using linters:

### Manual Validation

Check files manually against standards:
```bash
# Check for temporal language
grep -r "currently\|now\|recently\|will be\|was" src/ --include="*.py" --include="*.ts" --include="*.md"

# Check for Purpose field in Python files
grep -L "^Purpose:" src/**/*.py

# Check README sections
grep "^## " README.md
```

### Automated Validation (Future)

If header_linter.py is available:
```bash
# Validate all files
python tools/design_linters/header_linter.py --path .

# Validate specific file
python tools/design_linters/header_linter.py --file src/module.py
```

## Troubleshooting

### Issue: Templates contain placeholders in project files

**Solution**: Templates are meant to be copied and customized. Replace all `{{PLACEHOLDER}}` values with actual content.

### Issue: Existing files don't have headers

**Solution**:
1. Prioritize critical files first (main source, configs, docs)
2. Add headers gradually using templates as reference
3. Focus on new files going forward

### Issue: README doesn't match standards

**Solution**:
1. Review .ai/docs/readme-standards.md
2. Compare current README with .ai/templates/README.template
3. Add missing sections incrementally

### Issue: Unclear which template to use

**Solution**:
- .md files → file-header-markdown.template
- .py files → file-header-python.template
- .ts, .tsx, .js, .jsx → file-header-typescript.template
- .yml, .yaml → file-header-yaml.template
- New README → README.template

## Customization

### Adapting Templates for Your Project

Templates can be customized:

1. **Add project-specific fields**:
   - Add custom fields to templates (e.g., "Security Notes", "Performance")
   - Keep mandatory fields (Purpose, Scope, Overview)

2. **Adjust verbosity**:
   - Smaller projects: Brief headers
   - Large teams: More detailed headers

3. **Create custom templates**:
   - Copy existing template
   - Modify for specific use case (e.g., API endpoints, database models)
   - Save in .ai/templates/ with .template extension

### Creating New Templates

Follow the template creation guide at .ai/howto/how-to-create-a-template.md:

1. Start with TEMPLATE_FILE_TEMPLATE.md as reference
2. Document all placeholders with:
   - Type (string, number, path, etc.)
   - Example value
   - Required/optional status
3. Include usage instructions
4. Test template by creating a real file

## Success Criteria

Installation is successful when:
- ✅ All documentation standards files exist in .ai/docs/
- ✅ All how-to guides exist in .ai/howto/
- ✅ All templates exist in .ai/templates/
- ✅ README.md exists and follows standards (or user knows how to update it)
- ✅ User understands how to apply headers to new files
- ✅ Templates are accessible and documented

## Reference Documentation

After installation, users should reference:

1. **File Headers**: .ai/docs/FILE_HEADER_STANDARDS.md
2. **README Standards**: .ai/docs/readme-standards.md
3. **API Documentation**: .ai/docs/api-documentation.md
4. **How-To Guides**: .ai/howto/how-to-write-file-headers.md, how-to-create-readme.md, how-to-document-api.md
5. **Templates**: All templates in .ai/templates/

## Next Steps

After installing documentation standards:

1. **Apply to new files**: Use templates for all new files
2. **Update README**: Review and improve README.md
3. **Backfill headers**: Add headers to existing critical files
4. **Team training**: Share standards with team members
5. **CI/CD integration**: Consider adding header validation to CI/CD
6. **Install complementary plugins**: Python, TypeScript, Docker plugins for language-specific standards
