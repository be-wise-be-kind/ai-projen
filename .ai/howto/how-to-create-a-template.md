# How-To: Create a Template File

**Purpose**: Guide AI agents and developers through creating reusable template files with proper headers and placeholders

**Scope**: All template file types including Python, TypeScript, YAML, Markdown, and configuration files across the ai-projen framework

**Overview**: Step-by-step instructions for creating well-structured template files that can be used to generate new files with consistent formatting and structure. Covers template headers, placeholder conventions, validation procedures, and integration with the plugin system.

**Dependencies**: FILE_HEADER_STANDARDS.md for header requirements, HOW_TO_TEMPLATE.md for structure reference

**Exports**: Knowledge of template creation process, placeholder naming conventions, and validation procedures

**Related**: [FILE_HEADER_STANDARDS.md](../docs/FILE_HEADER_STANDARDS.md), [HOW_TO_TEMPLATE.md](../templates/HOW_TO_TEMPLATE.md), [TEMPLATE_FILE_TEMPLATE.md](../templates/TEMPLATE_FILE_TEMPLATE.md)

**Implementation**: Template-based file generation with variable substitution and validation

**Difficulty**: intermediate

**Estimated Time**: 30min

---

## Prerequisites

Before creating a template, ensure you have:

- **FILE_HEADER_STANDARDS.md**: Understanding of file header requirements
- **Template destination**: Know where the template will be stored (`.ai/templates/` or `plugins/*/templates/`)
- **Use case clarity**: Clear understanding of what the template will generate
- **Placeholder plan**: List of variables that need to be replaced

## Overview

Templates are reusable file skeletons that allow AI agents and developers to generate new files with consistent structure, formatting, and placeholders for project-specific values. Templates are a critical part of the ai-projen framework, enabling plugins to provide standardized file patterns.

Templates serve two primary purposes:
1. **Code generation**: Provide boilerplate for new files with proper structure
2. **Consistency**: Ensure all generated files follow the same conventions

Templates use placeholder syntax like `{{VARIABLE_NAME}}` that gets replaced during file generation. The key to good templates is clear documentation of what each placeholder represents and when to use the template.

## Steps

### Step 1: Determine Template Type and Location

Decide what type of template you're creating and where it should live.

**Template Locations**:
- **Universal templates**: `.ai/templates/` - For templates used across projects
- **Plugin templates**: `plugins/{category}/{plugin}/templates/` - For plugin-specific templates
- **Category templates**: `plugins/{category}/_template/templates/` - For category-wide patterns

**Why This Matters**: Template location affects discoverability and indicates its scope. Universal templates are available to all projects, while plugin templates are specific to that plugin's functionality.

### Step 2: Create Template File with .template Extension

Create your template file with the `.template` extension.

```bash
# For universal template
touch .ai/templates/my-template.py.template

# For plugin template
touch plugins/languages/python/templates/test-file.py.template
```

**Naming Convention**:
- Include the target file extension before `.template`
- Use descriptive names: `component.tsx.template`, `api-endpoint.py.template`
- Match the final file type: `config.yaml.template`, `readme.md.template`

**Why This Matters**: The `.template` extension signals this is a template file, not a final file. Including the target extension helps identify what the template generates.

### Step 3: Add Template File Header

Every template file must have a special header documenting its placeholders and usage.

**Template Header Structure**:
```markdown
# Purpose: Brief description of what this template generates
# Scope: Where/when this template should be used
# Overview: Detailed explanation of the template's purpose, structure, and generated file characteristics
#
# Placeholders: List of all {{PLACEHOLDER}} variables and their meanings
#   {{VARIABLE_NAME}}: Description of what this should be replaced with
#   {{ANOTHER_VAR}}: Description of this variable
#
# Usage: How to use this template
#   1. Copy to destination: cp template.ext.template target.ext
#   2. Replace placeholders with actual values
#   3. Remove template header comments
#
# Related: Links to documentation, standards, or examples
```

**Example Python Template Header**:
```python
"""
Purpose: Python module template with standard file header
Scope: All new Python modules requiring proper documentation structure
Overview: Generates a Python module file with properly formatted docstring header
    following FILE_HEADER_STANDARDS.md conventions. Includes all mandatory fields
    (Purpose, Scope, Overview) and common optional fields for Python modules.

Placeholders:
  {{MODULE_NAME}}: Name of the Python module (e.g., "user_service", "data_validator")
  {{MODULE_PURPOSE}}: Brief one-line description of module functionality
  {{MODULE_SCOPE}}: What this module handles (e.g., "API endpoints", "data models")
  {{MODULE_OVERVIEW}}: Comprehensive explanation of module's role and responsibilities
  {{KEY_DEPENDENCIES}}: Important external dependencies or internal modules
  {{MAIN_EXPORTS}}: Classes, functions, or constants the module provides
  {{KEY_INTERFACES}}: APIs, endpoints, or methods exposed by the module

Usage:
  1. Copy: cp .ai/templates/python-module.py.template src/{{MODULE_NAME}}.py
  2. Replace all {{PLACEHOLDERS}} with actual values
  3. Remove this template header (lines 1-20)
  4. Verify with: python -m py_compile src/{{MODULE_NAME}}.py

Related: FILE_HEADER_STANDARDS.md, Python plugin documentation
"""

{{MODULE_NAME}} module content starts here...
"""
```

**Why This Matters**: Template headers ensure anyone using the template understands all placeholders and how to apply them correctly.

### Step 4: Define Placeholder Naming Convention

Use consistent placeholder naming that indicates the expected value type.

**Placeholder Conventions**:
- **{{SNAKE_CASE}}**: For file names, module names, variable names
  - Example: `{{MODULE_NAME}}`, `{{TEST_FILE_PATH}}`
- **{{PascalCase}}**: For class names, component names, type names
  - Example: `{{ComponentName}}`, `{{ClassName}}`, `{{ServiceName}}`
- **{{camelCase}}**: For function names, method names, property names
  - Example: `{{functionName}}`, `{{methodName}}`, `{{propertyName}}`
- **{{SCREAMING_SNAKE_CASE}}**: For constants, environment variables
  - Example: `{{API_KEY}}`, `{{MAX_RETRIES}}`, `{{DATABASE_URL}}`
- **{{kebab-case}}**: For URLs, CSS classes, file paths
  - Example: `{{component-name}}`, `{{api-endpoint}}`

**Description Format**:
Use clear, descriptive placeholder names that indicate their purpose:
- `{{PROJECT_NAME}}` not `{{NAME}}`
- `{{DATABASE_CONNECTION_STRING}}` not `{{DB}}`
- `{{PRIMARY_COLOR_HEX}}` not `{{COLOR}}`

**Why This Matters**: Consistent naming helps users understand what values to provide and in what format.

### Step 5: Create Template Content with Placeholders

Build the template content with placeholders replacing variable values.

**Python Code Template Example**:
```python
"""
Purpose: {{MODULE_PURPOSE}}

Scope: {{MODULE_SCOPE}}

Overview: {{MODULE_OVERVIEW}}

Dependencies: {{KEY_DEPENDENCIES}}

Exports: {{MAIN_EXPORTS}}

Interfaces: {{KEY_INTERFACES}}
"""

from typing import List, Optional
import logging

logger = logging.getLogger(__name__)


class {{ClassName}}:
    """{{CLASS_DESCRIPTION}}"""

    def __init__(self, {{constructor_params}}):
        """Initialize {{ClassName}}.

        Args:
            {{constructor_params}}: {{PARAM_DESCRIPTION}}
        """
        self.{{attribute_name}} = {{attribute_name}}

    def {{method_name}}(self, {{method_params}}) -> {{ReturnType}}:
        """{{METHOD_DESCRIPTION}}

        Args:
            {{method_params}}: {{PARAM_DESCRIPTION}}

        Returns:
            {{RETURN_DESCRIPTION}}
        """
        # Implementation here
        pass
```

**TypeScript Component Template Example**:
```typescript
/**
 * Purpose: {{COMPONENT_PURPOSE}}
 *
 * Scope: {{COMPONENT_SCOPE}}
 *
 * Overview: {{COMPONENT_OVERVIEW}}
 *
 * Dependencies: {{KEY_DEPENDENCIES}}
 *
 * Exports: {{ComponentName}} component
 *
 * Props/Interfaces: {{ComponentName}}Props
 *
 * State/Behavior: {{STATE_DESCRIPTION}}
 */

import React from 'react';
import { {{ImportedTypes}} } from '{{import_path}}';

interface {{ComponentName}}Props {
  {{prop_name}}: {{PropType}};
  {{optional_prop}}?: {{OptionalType}};
}

export const {{ComponentName}}: React.FC<{{ComponentName}}Props> = ({
  {{prop_name}},
  {{optional_prop}}
}) => {
  // Component implementation

  return (
    <div className="{{component-class}}">
      {/* Component JSX */}
    </div>
  );
};
```

**YAML Config Template Example**:
```yaml
# Purpose: {{CONFIG_PURPOSE}}
# Scope: {{CONFIG_SCOPE}}
# Overview: {{CONFIG_OVERVIEW}}
# Dependencies: {{CONFIG_DEPENDENCIES}}
# Environment: {{TARGET_ENVIRONMENT}}

version: "{{VERSION}}"

{{service_name}}:
  enabled: {{ENABLED_BOOLEAN}}

  settings:
    {{setting_key}}: {{setting_value}}
    {{another_setting}}: {{another_value}}

  {{subsection_name}}:
    - {{list_item_1}}
    - {{list_item_2}}
```

**Markdown Documentation Template Example**:
```markdown
# {{DOCUMENT_TITLE}}

**Purpose**: {{DOCUMENT_PURPOSE}}

**Scope**: {{DOCUMENT_SCOPE}}

**Overview**: {{DOCUMENT_OVERVIEW}}

**Dependencies**: {{REQUIRED_KNOWLEDGE}}

**Exports**: {{WHAT_READER_LEARNS}}

**Related**: {{RELATED_DOCS}}

**Implementation**: {{TECHNICAL_APPROACH}}

---

## Overview

{{DETAILED_OVERVIEW_2_TO_4_PARAGRAPHS}}

## {{MAIN_SECTION_TITLE}}

{{SECTION_CONTENT}}

### {{SUBSECTION_TITLE}}

{{SUBSECTION_CONTENT}}
```

**Why This Matters**: Well-placed placeholders make it easy to customize generated files while maintaining structure.

### Step 6: Document All Placeholders in Header

List every placeholder in the template header with clear descriptions.

**Placeholder Documentation Format**:
```python
# Placeholders:
#   {{VARIABLE_NAME}}: Description of what value should replace this
#     - Type: string | number | boolean | path | url
#     - Example: "user_service" or "/api/v1/users"
#     - Required: yes | no
#     - Default: value (if optional)
#
#   {{ANOTHER_VAR}}: Another placeholder description
#     - Type: string
#     - Example: "Handles user authentication"
#     - Required: yes
```

**Complete Example**:
```python
# Placeholders:
#   {{MODULE_NAME}}: Python module name in snake_case
#     - Type: string (snake_case identifier)
#     - Example: "user_authentication" or "data_processor"
#     - Required: yes
#
#   {{MODULE_PURPOSE}}: One-line description of module functionality
#     - Type: string (sentence)
#     - Example: "Handles user authentication and session management"
#     - Required: yes
#
#   {{ClassName}}: Main class name in PascalCase
#     - Type: string (PascalCase identifier)
#     - Example: "UserAuthenticator" or "DataProcessor"
#     - Required: no
#     - Default: None (omit class if not needed)
```

**Why This Matters**: Complete placeholder documentation prevents confusion and ensures correct template usage.

### Step 7: Add Usage Instructions

Provide clear step-by-step instructions for using the template.

**Usage Section Format**:
```python
# Usage:
#   1. Copy template to destination:
#      cp .ai/templates/template-name.ext.template path/to/destination.ext
#
#   2. Replace placeholders:
#      - {{VARIABLE_1}}: Replace with actual value
#      - {{VARIABLE_2}}: Replace with actual value
#
#   3. Remove template header (lines 1-25)
#
#   4. Validate generated file:
#      [validation command]
#
#   5. Optional: Run formatter
#      [formatter command]
```

**Detailed Example**:
```python
# Usage:
#   1. Copy template to your module location:
#      cp .ai/templates/python-module.py.template src/services/my_service.py
#
#   2. Replace all placeholders with actual values:
#      - {{MODULE_NAME}}: "my_service"
#      - {{MODULE_PURPOSE}}: "Provides business logic for X feature"
#      - {{MODULE_SCOPE}}: "Service layer for X functionality"
#      - (continue for all placeholders)
#
#   3. Delete this template header (lines 1-30)
#
#   4. Validate Python syntax:
#      python -m py_compile src/services/my_service.py
#
#   5. Format with black:
#      black src/services/my_service.py
#
#   6. Verify imports work:
#      python -c "from src.services.my_service import MyClass"
```

**Why This Matters**: Clear usage instructions ensure templates are applied correctly and consistently.

### Step 8: Create Template Examples

For complex templates, provide a complete example showing placeholder replacement.

**Example Section** (in template header):
```python
# Example:
#   Input placeholders:
#     {{MODULE_NAME}} = "user_validator"
#     {{MODULE_PURPOSE}} = "Validates user input data"
#     {{ClassName}} = "UserValidator"
#
#   Generated file preview:
#     """
#     Purpose: Validates user input data
#
#     Scope: Input validation layer
#
#     class UserValidator:
#         def validate_email(self, email: str) -> bool:
#             ...
#     """
```

**Why This Matters**: Examples clarify expected results and help users understand the template output.

### Step 9: Validate Template

Test the template to ensure it generates valid files.

**Validation Checklist**:
```bash
# 1. Check template has proper header
grep -q "Placeholders:" template.ext.template

# 2. Verify all placeholders are documented
# Extract placeholders from template
grep -oE '\{\{[A-Za-z_][A-Za-z0-9_-]*\}\}' template.ext.template | sort -u

# 3. Create test file from template
cp template.ext.template test-output.ext

# 4. Replace placeholders manually or with script
sed -i 's/{{MODULE_NAME}}/test_module/g' test-output.ext

# 5. Validate generated file syntax
python -m py_compile test-output.ext  # For Python
tsc --noEmit test-output.ts           # For TypeScript
yamllint test-output.yaml             # For YAML

# 6. Clean up test file
rm test-output.ext
```

**Why This Matters**: Validation ensures templates generate syntactically correct and usable files.

### Step 10: Update Plugin Manifest (if plugin template)

If creating a plugin template, update the plugin's manifest to reference it.

**In plugin manifest** (`plugins/{category}/{plugin}/manifest.yaml`):
```yaml
templates:
  - name: python-module
    file: templates/python-module.py.template
    description: Standard Python module template with proper headers
    target_extension: .py
    placeholders:
      - MODULE_NAME
      - MODULE_PURPOSE
      - ClassName
```

**Why This Matters**: Manifest entries make templates discoverable by the plugin system and orchestrators.

## Verification

Verify your template is complete and correct:

**Check 1: Template Header Validation**
```bash
# Verify template has all required header fields
head -20 template.ext.template | grep -E "Purpose:|Placeholders:|Usage:"
```

**Expected Output**:
```
# Purpose: [description]
# Placeholders:
# Usage:
```

**Check 2: Placeholder Documentation**
```bash
# Extract all placeholders from template content
grep -oE '\{\{[A-Za-z_][A-Za-z0-9_-]*\}\}' template.ext.template | sort -u

# Compare with documented placeholders in header
grep "{{" template.ext.template | head -15
```

**Success Criteria**:
- [ ] Template file has `.template` extension
- [ ] Template header includes Purpose, Placeholders, Usage, Related fields
- [ ] All placeholders in template body are documented in header
- [ ] Placeholder naming follows conventions (SNAKE_CASE, PascalCase, etc.)
- [ ] Usage instructions are clear and complete
- [ ] Template generates valid files when placeholders are replaced
- [ ] Template is placed in appropriate directory (.ai/templates/ or plugin/templates/)
- [ ] Plugin manifest updated (if applicable)

## Common Issues

### Issue: Placeholder not replaced during generation

**Symptoms**: Generated file still contains `{{PLACEHOLDER}}` text

**Cause**: Placeholder name mismatch or incorrect replacement logic

**Solution**:
```bash
# Check exact placeholder format in template
grep -oE '\{\{[A-Za-z_][A-Za-z0-9_-]*\}\}' template.ext.template

# Ensure replacement uses exact same name and format
sed -i 's/{{EXACT_NAME}}/value/g' output.ext
```

### Issue: Template generates invalid file syntax

**Symptoms**: Generated file has syntax errors when validated

**Cause**: Template structure issues or incorrect placeholder placement

**Solution**:
1. Manually create a valid file first
2. Replace actual values with placeholders
3. Validate template generates identical structure
4. Test with multiple placeholder values

### Issue: Undocumented placeholders

**Symptoms**: Template contains placeholders not listed in header

**Cause**: Forgot to document new placeholders when updating template

**Solution**:
```bash
# Find all placeholders in template
grep -oE '\{\{[A-Za-z_][A-Za-z0-9_-]*\}\}' template.ext.template | sort -u

# Add missing ones to Placeholders section in header
# Verify all are documented
```

### Issue: Template header too verbose

**Symptoms**: Template header is longer than the actual template content

**Cause**: Over-documentation or redundant information

**Solution**:
- Keep Purpose, Scope, Overview concise
- Document only non-obvious placeholders
- Move detailed docs to separate file if needed
- Link to external documentation for complex templates

## Best Practices

- **Keep templates focused**: One template should generate one type of file
- **Use semantic placeholders**: Names should clearly indicate what value goes there
- **Document edge cases**: Note any special handling or optional sections
- **Provide defaults**: Include sensible defaults for optional placeholders
- **Test thoroughly**: Generate files from templates and validate them
- **Version templates**: Track template versions if they evolve significantly
- **Reference standards**: Link to FILE_HEADER_STANDARDS.md and other relevant docs

## Next Steps

After creating a template:

- **Create how-to guide**: See [HOWTO_STANDARDS.md](../docs/HOWTO_STANDARDS.md) for guide creation
- **Add to plugin**: Integrate template into plugin templates/ directory
- **Update index**: Add reference in `.ai/index.yaml` if universal template
- **Write tests**: Create validation tests for template generation
- **Document patterns**: Add template to TEMPLATE_FILE_TEMPLATE.md examples

## Checklist

Use this checklist to ensure template completeness:

- [ ] Template filename includes target extension before `.template`
- [ ] Template header has Purpose, Scope, Overview, Placeholders, Usage, Related
- [ ] All placeholders follow naming conventions
- [ ] Every placeholder in template body is documented in header
- [ ] Usage instructions are clear with copy commands and examples
- [ ] Template validated by generating test file
- [ ] Syntax validation passes for generated files
- [ ] Template placed in correct directory
- [ ] Plugin manifest updated (if plugin template)
- [ ] Related documentation updated (index.yaml)

## Related Documentation

- [FILE_HEADER_STANDARDS.md](../docs/FILE_HEADER_STANDARDS.md) - Standard file headers
- [HOW_TO_TEMPLATE.md](../templates/HOW_TO_TEMPLATE.md) - How-to guide template structure
- [TEMPLATE_FILE_TEMPLATE.md](../templates/TEMPLATE_FILE_TEMPLATE.md) - Meta-template for templates
- [PLUGIN_ARCHITECTURE.md](../docs/PLUGIN_ARCHITECTURE.md) - Plugin system overview

---

**Notes**:
- Always test templates before committing
- Keep placeholder naming consistent across related templates
- Update template documentation when template structure changes
- Consider creating template generators for complex templates
