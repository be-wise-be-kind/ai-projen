# Template File Meta-Template

**Purpose**: Provides ready-to-copy template structures for creating new template files

**Scope**: All template file types - Python, TypeScript, YAML, Markdown, and configuration templates

**Overview**: This meta-template document serves as a reference for creating new template files. It contains complete, ready-to-copy template structures for different file types, showing proper header format, placeholder conventions, and documentation standards. Use these as starting points when creating new templates.

**Dependencies**: FILE_HEADER_STANDARDS.md for header requirements, how-to-create-a-template.md for process guidance

**Exports**: Template structures for Python, TypeScript, YAML, Markdown, and config files with proper headers

**Related**: [how-to-create-a-template.md](../howto/how-to-create-a-template.md), [FILE_HEADER_STANDARDS.md](../docs/FILE_HEADER_STANDARDS.md), [HOW_TO_TEMPLATE.md](./HOW_TO_TEMPLATE.md)

**Implementation**: Copy-paste ready template structures with placeholder documentation patterns

---

## How to Use This Document

This is a meta-template - a template for creating templates. Each section below contains a complete, ready-to-copy template structure for a specific file type.

**To create a new template:**
1. Find the relevant file type section below
2. Copy the entire template structure
3. Save it with `.template` extension (e.g., `my-file.py.template`)
4. Customize the header fields (Purpose, Scope, Overview, Placeholders, Usage)
5. Replace example placeholders with your actual placeholders
6. Update placeholder documentation with your specific variables
7. Test the template by generating a file and validating it

**Placeholder Naming Conventions:**
- `{{SNAKE_CASE}}` - For file names, module names, variables
- `{{PascalCase}}` - For class names, component names, types
- `{{camelCase}}` - For function names, methods, properties
- `{{SCREAMING_SNAKE_CASE}}` - For constants, environment variables
- `{{kebab-case}}` - For URLs, CSS classes, file paths

## Template Validation Checklist

Before using any template from this document, ensure:

- [ ] Template header includes: Purpose, Scope, Overview, Placeholders, Usage, Related
- [ ] All placeholders in template body are documented in the Placeholders field
- [ ] Placeholder names follow naming conventions
- [ ] Usage instructions include copy command and example
- [ ] Template can generate a valid file when placeholders are replaced
- [ ] Template is saved with `.template` extension

---

## Python Code Template Structure

```python
"""
Purpose: {{TEMPLATE_PURPOSE_ONE_LINE_DESCRIPTION}}

Scope: {{WHERE_WHEN_THIS_TEMPLATE_USED}}

Overview: {{DETAILED_EXPLANATION_OF_TEMPLATE_PURPOSE_AND_GENERATED_FILE}}
    {{CONTINUE_OVERVIEW_WITH_KEY_CHARACTERISTICS}}
    {{AND_IMPORTANT_BEHAVIORAL_NOTES}}

Placeholders:
  {{MODULE_NAME}}: Python module name in snake_case
    - Type: string (valid Python identifier)
    - Example: "user_service" or "data_validator"
    - Required: yes

  {{MODULE_PURPOSE}}: Brief one-line description of module functionality
    - Type: string (sentence)
    - Example: "Handles user authentication and session management"
    - Required: yes

  {{MODULE_SCOPE}}: What this module handles in the system
    - Type: string (phrase)
    - Example: "API endpoints for user management"
    - Required: yes

  {{MODULE_OVERVIEW}}: Comprehensive explanation of module role
    - Type: string (paragraph)
    - Example: "Provides authentication services including login, logout, session validation..."
    - Required: yes

  {{KEY_DEPENDENCIES}}: Important external dependencies or internal modules
    - Type: string (comma-separated list)
    - Example: "fastapi, sqlalchemy, custom auth utilities"
    - Required: no
    - Default: "Standard library modules only"

  {{MAIN_EXPORTS}}: Classes, functions, or constants this module provides
    - Type: string (comma-separated list)
    - Example: "UserService class, authenticate() function, MAX_LOGIN_ATTEMPTS constant"
    - Required: yes

  {{ClassName}}: Main class name in PascalCase
    - Type: string (valid Python class name)
    - Example: "UserService" or "DataValidator"
    - Required: no
    - Default: None (omit class section if not needed)

  {{CLASS_DESCRIPTION}}: Brief description of what the class does
    - Type: string (sentence)
    - Example: "Manages user authentication and authorization"
    - Required: if {{ClassName}} is provided

  {{method_name}}: Primary method name in snake_case
    - Type: string (valid Python method name)
    - Example: "validate_credentials" or "process_login"
    - Required: no

Usage:
  1. Copy template to destination:
     cp .ai/templates/python-module.py.template src/{{MODULE_NAME}}.py

  2. Replace all placeholders with actual values for your module

  3. Remove this template header (delete lines 1-XX)

  4. Validate Python syntax:
     python -m py_compile src/{{MODULE_NAME}}.py

  5. Format with black (optional):
     black src/{{MODULE_NAME}}.py

  6. Verify imports:
     python -c "from src.{{MODULE_NAME}} import {{ClassName}}"

Related: FILE_HEADER_STANDARDS.md (Python section), Python plugin documentation

Example:
  For a user validation module:
    {{MODULE_NAME}} = "user_validator"
    {{MODULE_PURPOSE}} = "Validates user input and credentials"
    {{ClassName}} = "UserValidator"

  Generates:
    File: src/user_validator.py
    Contains: UserValidator class with proper docstring header
"""

from typing import List, Optional, Dict, Any
import logging

logger = logging.getLogger(__name__)


class {{ClassName}}:
    """{{CLASS_DESCRIPTION}}"""

    def __init__(self, {{constructor_params}}: {{ParamType}}):
        """Initialize {{ClassName}}.

        Args:
            {{constructor_params}}: {{PARAM_DESCRIPTION}}
        """
        self.{{attribute_name}} = {{constructor_params}}

    def {{method_name}}(self, {{method_params}}: {{ParamType}}) -> {{ReturnType}}:
        """{{METHOD_DESCRIPTION}}

        Args:
            {{method_params}}: {{PARAM_DESCRIPTION}}

        Returns:
            {{ReturnType}}: {{RETURN_DESCRIPTION}}

        Raises:
            {{ExceptionType}}: {{EXCEPTION_DESCRIPTION}}
        """
        logger.info(f"{{method_name}} called with {{{method_params}}}")

        # Implementation
        result = self._{{helper_method}}({{method_params}})

        return result

    def _{{helper_method}}(self, {{params}}: {{Type}}) -> {{ReturnType}}:
        """{{HELPER_METHOD_DESCRIPTION}}"""
        # Private helper implementation
        pass
```

---

## TypeScript/React Component Template Structure

```typescript
/**
 * Purpose: {{COMPONENT_TEMPLATE_PURPOSE}}
 *
 * Scope: {{WHERE_THIS_COMPONENT_TEMPLATE_USED}}
 *
 * Overview: {{DETAILED_EXPLANATION_OF_COMPONENT_TEMPLATE}}
 *     {{CONTINUE_WITH_KEY_CHARACTERISTICS}}
 *     {{AND_INTEGRATION_PATTERNS}}
 *
 * Placeholders:
 *   {{ComponentName}}: React component name in PascalCase
 *     - Type: string (valid React component name)
 *     - Example: "UserProfile" or "DataTable"
 *     - Required: yes
 *
 *   {{COMPONENT_PURPOSE}}: Brief description of component functionality
 *     - Type: string (sentence)
 *     - Example: "Displays user profile information with edit capabilities"
 *     - Required: yes
 *
 *   {{COMPONENT_SCOPE}}: Where this component is used in the app
 *     - Type: string (phrase)
 *     - Example: "User dashboard and settings pages"
 *     - Required: yes
 *
 *   {{COMPONENT_OVERVIEW}}: Comprehensive component description
 *     - Type: string (paragraph)
 *     - Example: "Interactive user profile component with real-time updates..."
 *     - Required: yes
 *
 *   {{KEY_DEPENDENCIES}}: Important libraries or components this uses
 *     - Type: string (comma-separated)
 *     - Example: "react-query, @/components/ui/Button, @/hooks/useUser"
 *     - Required: no
 *     - Default: "React only"
 *
 *   {{PropType}}: TypeScript type for main prop
 *     - Type: string (TypeScript type)
 *     - Example: "string" or "User" or "Array<DataItem>"
 *     - Required: yes
 *
 *   {{STATE_DESCRIPTION}}: Description of component state management
 *     - Type: string (sentence)
 *     - Example: "Uses useState for local form state and React Query for server state"
 *     - Required: no
 *     - Default: "No internal state (presentational component)"
 *
 * Usage:
 *   1. Copy template to component file:
 *      cp .ai/templates/react-component.tsx.template src/components/{{ComponentName}}.tsx
 *
 *   2. Replace all placeholders with your component details
 *
 *   3. Remove template header (lines 1-XX)
 *
 *   4. Validate TypeScript:
 *      tsc --noEmit src/components/{{ComponentName}}.tsx
 *
 *   5. Format with prettier:
 *      prettier --write src/components/{{ComponentName}}.tsx
 *
 * Related: FILE_HEADER_STANDARDS.md (TypeScript section), React best practices
 *
 * Example:
 *   {{ComponentName}} = "UserCard"
 *   {{COMPONENT_PURPOSE}} = "Displays user information in a card layout"
 *   {{PropType}} = "User"
 *
 *   Generates: src/components/UserCard.tsx with proper TypeScript types
 */

import React, { useState, useEffect } from 'react';
import { {{ImportedType}} } from '{{import_path}}';
import { {{ImportedComponent}} } from '@/components/{{component_path}}';

interface {{ComponentName}}Props {
  {{prop_name}}: {{PropType}};
  {{optional_prop}}?: {{OptionalType}};
  {{callback_prop}}?: ({{param}}: {{ParamType}}) => void;
}

export const {{ComponentName}}: React.FC<{{ComponentName}}Props> = ({
  {{prop_name}},
  {{optional_prop}},
  {{callback_prop}}
}) => {
  const [{{state_variable}}, {{setState_variable}}] = useState<{{StateType}}>({{initial_value}});

  useEffect(() => {
    // Effect logic
    {{effect_implementation}}
  }, [{{dependencies}}]);

  const {{handler_function}} = ({{event_param}}: {{EventType}}) => {
    {{event_handler_logic}}
    {{callback_prop}}?.({{callback_arg}});
  };

  return (
    <div className="{{component-class}}">
      <{{ImportedComponent}}
        {{component_prop}}={{{prop_value}}}
        {{onClick}}={{{handler_function}}}
      />
    </div>
  );
};
```

---

## YAML Configuration Template Structure

```yaml
# Purpose: {{CONFIG_TEMPLATE_PURPOSE}}
# Scope: {{WHERE_THIS_CONFIG_TEMPLATE_USED}}
# Overview: {{DETAILED_EXPLANATION_OF_CONFIG_TEMPLATE}}
#     {{CONTINUE_WITH_CONFIGURATION_DETAILS}}
#     {{AND_USAGE_PATTERNS}}
#
# Placeholders:
#   {{CONFIG_NAME}}: Name of the configuration
#     - Type: string (identifier)
#     - Example: "production-settings" or "dev-environment"
#     - Required: yes
#
#   {{VERSION}}: Configuration version number
#     - Type: string (semver)
#     - Example: "1.0.0" or "2.3.1"
#     - Required: yes
#
#   {{SERVICE_NAME}}: Name of the service being configured
#     - Type: string (identifier)
#     - Example: "api-gateway" or "user-service"
#     - Required: yes
#
#   {{ENABLED_BOOLEAN}}: Whether feature is enabled
#     - Type: boolean
#     - Example: true or false
#     - Required: yes
#
#   {{SETTING_KEY}}: Configuration setting key
#     - Type: string (snake_case)
#     - Example: "max_connections" or "timeout_seconds"
#     - Required: yes
#
#   {{SETTING_VALUE}}: Configuration setting value
#     - Type: string | number | boolean
#     - Example: 100 or "high" or true
#     - Required: yes
#
#   {{TARGET_ENVIRONMENT}}: Deployment environment
#     - Type: string (enum)
#     - Example: "development" or "staging" or "production"
#     - Required: yes
#
# Usage:
#   1. Copy template to config location:
#      cp .ai/templates/config.yaml.template config/{{CONFIG_NAME}}.yaml
#
#   2. Replace all placeholders with actual configuration values
#
#   3. Remove template header (lines 1-XX)
#
#   4. Validate YAML syntax:
#      yamllint config/{{CONFIG_NAME}}.yaml
#
#   5. Test configuration load:
#      python -c "import yaml; yaml.safe_load(open('config/{{CONFIG_NAME}}.yaml'))"
#
# Related: FILE_HEADER_STANDARDS.md (Configuration section)
#
# Example:
#   {{CONFIG_NAME}} = "api-production"
#   {{SERVICE_NAME}} = "user-api"
#   {{VERSION}} = "1.0.0"
#
#   Generates: config/api-production.yaml for user-api service

version: "{{VERSION}}"

metadata:
  name: {{CONFIG_NAME}}
  environment: {{TARGET_ENVIRONMENT}}
  description: {{CONFIG_DESCRIPTION}}

{{SERVICE_NAME}}:
  enabled: {{ENABLED_BOOLEAN}}

  settings:
    {{SETTING_KEY}}: {{SETTING_VALUE}}
    {{ANOTHER_SETTING}}: {{ANOTHER_VALUE}}
    {{TIMEOUT_MS}}: {{TIMEOUT_VALUE}}

  {{SUBSECTION_NAME}}:
    {{NESTED_KEY}}:
      {{DEEP_KEY}}: {{DEEP_VALUE}}

  {{LIST_SECTION}}:
    - {{LIST_ITEM_1}}
    - {{LIST_ITEM_2}}
    - {{LIST_ITEM_3}}

  {{ENVIRONMENT_VARS}}:
    {{VAR_NAME}}: {{VAR_VALUE}}
    {{ANOTHER_VAR}}: {{ANOTHER_VAR_VALUE}}
```

---

## Markdown Documentation Template Structure

```markdown
<!--
Purpose: {{DOC_TEMPLATE_PURPOSE}}

Scope: {{WHERE_THIS_DOC_TEMPLATE_USED}}

Overview: {{DETAILED_EXPLANATION_OF_DOC_TEMPLATE}}
    {{CONTINUE_WITH_DOCUMENTATION_DETAILS}}
    {{AND_STRUCTURE_PATTERNS}}

Placeholders:
  {{DOCUMENT_TITLE}}: Main title of the document
    - Type: string (title case)
    - Example: "API Integration Guide" or "User Authentication Flow"
    - Required: yes

  {{DOCUMENT_PURPOSE}}: Brief description of document purpose
    - Type: string (sentence)
    - Example: "Guide developers through API integration process"
    - Required: yes

  {{DOCUMENT_SCOPE}}: What the document covers
    - Type: string (phrase)
    - Example: "REST API endpoints and authentication"
    - Required: yes

  {{DOCUMENT_OVERVIEW}}: Comprehensive document description
    - Type: string (paragraph)
    - Example: "Complete guide covering API setup, authentication, endpoints..."
    - Required: yes

  {{SECTION_TITLE}}: Main section heading
    - Type: string (title case)
    - Example: "Getting Started" or "Configuration Options"
    - Required: yes

  {{SECTION_CONTENT}}: Content for the section
    - Type: string (markdown text)
    - Example: Paragraphs, code blocks, lists, etc.
    - Required: yes

  {{CODE_LANGUAGE}}: Programming language for code blocks
    - Type: string (language identifier)
    - Example: "python" or "typescript" or "bash"
    - Required: for code blocks

Usage:
  1. Copy template to docs location:
     cp .ai/templates/documentation.md.template docs/{{document-name}}.md

  2. Replace all placeholders with actual content

  3. Remove template header (this HTML comment)

  4. Validate markdown:
     markdownlint docs/{{document-name}}.md

  5. Preview rendering in markdown viewer

Related: FILE_HEADER_STANDARDS.md (Markdown section), HOWTO_STANDARDS.md

Example:
  {{DOCUMENT_TITLE}} = "Database Setup Guide"
  {{DOCUMENT_PURPOSE}} = "Guide developers through database configuration"

  Generates: docs/database-setup-guide.md
-->

# {{DOCUMENT_TITLE}}

**Purpose**: {{DOCUMENT_PURPOSE}}

**Scope**: {{DOCUMENT_SCOPE}}

**Overview**: {{DOCUMENT_OVERVIEW}}

**Dependencies**: {{REQUIRED_KNOWLEDGE_OR_TOOLS}}

**Exports**: {{WHAT_READER_LEARNS}}

**Related**: {{RELATED_DOCUMENTATION_LINKS}}

**Implementation**: {{TECHNICAL_APPROACH_OR_PATTERNS}}

---

## Overview

{{DETAILED_OVERVIEW_2_TO_4_PARAGRAPHS}}

{{EXPLAIN_CONTEXT_AND_MOTIVATION}}

{{DESCRIBE_KEY_CONCEPTS}}

{{OUTLINE_DOCUMENT_STRUCTURE}}

## {{MAIN_SECTION_TITLE}}

{{SECTION_CONTENT_PARAGRAPHS}}

### {{SUBSECTION_TITLE}}

{{SUBSECTION_CONTENT}}

**{{IMPORTANT_CONCEPT}}**:
{{CONCEPT_EXPLANATION}}

**Code Example**:
```{{CODE_LANGUAGE}}
{{CODE_EXAMPLE}}
```

### {{ANOTHER_SUBSECTION}}

{{MORE_CONTENT}}

## {{ANOTHER_MAIN_SECTION}}

{{CONTENT_FOR_THIS_SECTION}}

**{{KEY_POINT}}**: {{EXPLANATION}}

## Best Practices

- **{{PRACTICE_1}}**: {{EXPLANATION}}
- **{{PRACTICE_2}}**: {{EXPLANATION}}
- **{{PRACTICE_3}}**: {{EXPLANATION}}

## Common Issues

### Issue: {{PROBLEM_DESCRIPTION}}

**Symptoms**: {{HOW_TO_RECOGNIZE}}

**Cause**: {{WHY_IT_HAPPENS}}

**Solution**:
```{{CODE_LANGUAGE}}
{{SOLUTION_CODE_OR_STEPS}}
```

## Related Documentation

- [{{RELATED_DOC_1}}]({{PATH_OR_URL}}) - {{DESCRIPTION}}
- [{{RELATED_DOC_2}}]({{PATH_OR_URL}}) - {{DESCRIPTION}}

---

**Notes**: {{ADDITIONAL_NOTES_OR_CAVEATS}}
```

---

## Shell Script Template Structure

```bash
#!/bin/bash
# Purpose: {{SCRIPT_TEMPLATE_PURPOSE}}
# Scope: {{WHERE_THIS_SCRIPT_TEMPLATE_USED}}
# Overview: {{DETAILED_EXPLANATION_OF_SCRIPT_TEMPLATE}}
#     {{CONTINUE_WITH_SCRIPT_DETAILS}}
#     {{AND_OPERATIONAL_PATTERNS}}
#
# Placeholders:
#   {{SCRIPT_NAME}}: Name of the script file
#     - Type: string (kebab-case)
#     - Example: "deploy-app" or "backup-database"
#     - Required: yes
#
#   {{SCRIPT_PURPOSE}}: Brief description of script functionality
#     - Type: string (sentence)
#     - Example: "Deploys application to staging environment"
#     - Required: yes
#
#   {{REQUIRED_TOOLS}}: Tools/commands required by script
#     - Type: string (comma-separated)
#     - Example: "docker, kubectl, aws-cli"
#     - Required: yes
#
#   {{VARIABLE_NAME}}: Script variable name in SCREAMING_SNAKE_CASE
#     - Type: string (valid bash variable)
#     - Example: "DATABASE_URL" or "MAX_RETRIES"
#     - Required: yes
#
#   {{DEFAULT_VALUE}}: Default value for variable
#     - Type: string | number
#     - Example: "localhost" or 3
#     - Required: no
#     - Default: empty string
#
#   {{FUNCTION_NAME}}: Function name in snake_case
#     - Type: string (valid bash function name)
#     - Example: "validate_input" or "backup_database"
#     - Required: yes
#
# Usage:
#   1. Copy template to scripts directory:
#      cp .ai/templates/script.sh.template scripts/{{SCRIPT_NAME}}.sh
#
#   2. Replace all placeholders with actual script details
#
#   3. Remove template header (lines 1-XX)
#
#   4. Make executable:
#      chmod +x scripts/{{SCRIPT_NAME}}.sh
#
#   5. Validate bash syntax:
#      bash -n scripts/{{SCRIPT_NAME}}.sh
#
#   6. Test script:
#      ./scripts/{{SCRIPT_NAME}}.sh --help
#
# Related: FILE_HEADER_STANDARDS.md (Script section)
#
# Example:
#   {{SCRIPT_NAME}} = "deploy-staging"
#   {{SCRIPT_PURPOSE}} = "Deploys application to staging environment"
#   {{REQUIRED_TOOLS}} = "docker, kubectl"

set -euo pipefail

# Configuration
{{VARIABLE_NAME}}="${{{VARIABLE_NAME}}:-{{DEFAULT_VALUE}}}"
{{ANOTHER_VAR}}="${{{ANOTHER_VAR}}:-{{ANOTHER_DEFAULT}}}"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Functions
{{FUNCTION_NAME}}() {
    local {{param_name}}="$1"

    {{FUNCTION_IMPLEMENTATION}}

    return 0
}

print_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

{{SCRIPT_DESCRIPTION}}

Options:
    -h, --help              Show this help message
    -e, --environment ENV   Target environment ({{ENV_OPTIONS}})
    --{{option_name}}       {{OPTION_DESCRIPTION}}

Examples:
    $0 --environment staging
    $0 --{{option_name}} {{example_value}}

EOF
}

validate_requirements() {
    local requirements=({{REQUIRED_TOOLS}})

    for tool in "${requirements[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${RED}Error: Required tool '$tool' not found${NC}" >&2
            exit 1
        fi
    done
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_usage
                exit 0
                ;;
            -e|--environment)
                {{ENVIRONMENT_VAR}}="$2"
                shift 2
                ;;
            --{{option_name}})
                {{OPTION_VAR}}="$2"
                shift 2
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}" >&2
                print_usage
                exit 1
                ;;
        esac
    done

    # Validate
    validate_requirements

    # Execute
    echo -e "${GREEN}{{SCRIPT_ACTION_MESSAGE}}${NC}"
    {{FUNCTION_NAME}} "{{PARAM_VALUE}}"

    echo -e "${GREEN}{{SUCCESS_MESSAGE}}${NC}"
}

main "$@"
```

---

## JSON Configuration Template Structure

```json
{
  "_header": {
    "purpose": "{{JSON_TEMPLATE_PURPOSE}}",
    "scope": "{{WHERE_THIS_JSON_TEMPLATE_USED}}",
    "overview": "{{DETAILED_EXPLANATION_OF_JSON_TEMPLATE}} {{CONTINUE_WITH_STRUCTURE_DETAILS}} {{AND_USAGE_PATTERNS}}",
    "placeholders": {
      "{{CONFIG_KEY}}": {
        "description": "{{PLACEHOLDER_DESCRIPTION}}",
        "type": "string | number | boolean | object | array",
        "example": "{{EXAMPLE_VALUE}}",
        "required": true
      },
      "{{ANOTHER_KEY}}": {
        "description": "{{ANOTHER_DESCRIPTION}}",
        "type": "{{TYPE}}",
        "example": "{{EXAMPLE}}",
        "required": false,
        "default": "{{DEFAULT_VALUE}}"
      }
    },
    "usage": [
      "1. Copy template: cp .ai/templates/config.json.template config/{{CONFIG_NAME}}.json",
      "2. Replace all placeholders with actual values",
      "3. Remove _header section",
      "4. Validate JSON: python -c 'import json; json.load(open(\"config/{{CONFIG_NAME}}.json\"))'",
      "5. Test configuration load in application"
    ],
    "related": "FILE_HEADER_STANDARDS.md (JSON section)"
  },
  "{{CONFIG_SECTION}}": {
    "{{SETTING_KEY}}": "{{SETTING_VALUE}}",
    "{{ANOTHER_SETTING}}": {{NUMERIC_VALUE}},
    "{{BOOLEAN_SETTING}}": {{BOOLEAN_VALUE}}
  },
  "{{NESTED_SECTION}}": {
    "{{NESTED_KEY}}": {
      "{{DEEP_KEY}}": "{{DEEP_VALUE}}",
      "{{ANOTHER_DEEP_KEY}}": [
        "{{ARRAY_ITEM_1}}",
        "{{ARRAY_ITEM_2}}"
      ]
    }
  }
}
```

---

## Template Header Best Practices

### Required Fields in All Templates

Every template file must include these fields in the header:

1. **Purpose**: What this template generates (1 line)
2. **Scope**: Where/when to use this template (1 line)
3. **Overview**: Detailed explanation of template purpose and output (2-4 sentences)
4. **Placeholders**: Complete list of all placeholders with:
   - Description of what the placeholder represents
   - Type of value expected
   - Example value
   - Whether required or optional
   - Default value (if optional)
5. **Usage**: Step-by-step instructions including:
   - Copy command with destination
   - Placeholder replacement instructions
   - Header removal step
   - Validation command
   - Optional formatting/testing steps
6. **Related**: Links to relevant documentation

### Placeholder Documentation Format

For each placeholder, document:

```
{{PLACEHOLDER_NAME}}: Brief description
  - Type: string | number | boolean | path | etc.
  - Example: "concrete example value"
  - Required: yes | no
  - Default: "value" (if optional)
```

### Usage Instructions Format

Always include:
1. Copy command with actual file paths
2. List of all placeholders to replace
3. Header removal instruction
4. Validation command specific to file type
5. Optional formatting/linting commands
6. Testing or verification steps

---

## Quick Reference

### When Creating Python Template:
- Use `"""docstring"""` for header
- Document all {{PLACEHOLDERS}} in header
- Include imports section
- Add class/function structure with proper typing
- Provide validation command: `python -m py_compile`

### When Creating TypeScript/React Template:
- Use `/** JSDoc */` for header
- Define interfaces for props/types
- Include proper imports
- Use functional components with TypeScript
- Provide validation: `tsc --noEmit`

### When Creating YAML Template:
- Use `#` comments for header
- Document configuration structure
- Include version field
- Provide yamllint validation
- Show nested structure examples

### When Creating Markdown Template:
- Use `<!-- HTML comment -->` for header
- Follow standard markdown header format
- Include all standard fields (Purpose, Scope, etc.)
- Provide markdownlint validation
- Show section structure

### When Creating Shell Script Template:
- Start with `#!/bin/bash` shebang
- Use `#` comments for header
- Include `set -euo pipefail` for safety
- Provide bash syntax check: `bash -n`
- Add usage/help function

---

## Related Documentation

- [how-to-create-a-template.md](../howto/how-to-create-a-template.md) - Complete guide to template creation
- [FILE_HEADER_STANDARDS.md](../docs/FILE_HEADER_STANDARDS.md) - Header requirements for all files
- [HOW_TO_TEMPLATE.md](./HOW_TO_TEMPLATE.md) - Template for creating how-to guides
- [PLUGIN_ARCHITECTURE.md](../docs/PLUGIN_ARCHITECTURE.md) - Plugin system and template usage

---

**Usage Note**: This meta-template is a reference document. Copy individual template structures from this file when creating new templates, then customize them for your specific use case.
