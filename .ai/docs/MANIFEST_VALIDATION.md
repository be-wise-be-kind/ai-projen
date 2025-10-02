# Plugin Manifest Validation

**Purpose**: Schema and validation rules for PLUGIN_MANIFEST.yaml

**Scope**: Required fields, data types, validation logic, and error handling

**Overview**: Defines the structure and validation requirements for the plugin manifest file.
    Ensures manifest integrity, consistency, and usability for AI agents and orchestrators.
    Includes schema definition, validation rules, and examples of valid/invalid configurations.

**Dependencies**: PLUGIN_MANIFEST.yaml, YAML parser

**Exports**: Validation schema, validation logic, error handling guidelines

**Related**: PLUGIN_DISCOVERY.md for usage patterns, PLUGIN_ARCHITECTURE.md for plugin structure

**Implementation**: Schema-based validation with clear error messages and recovery options

---

## Schema Definition

### Root Level

```yaml
version: string (required)
  - Format: "X.Y" (e.g., "1.0")
  - Supported versions: "1.0"

foundation: object (required)
languages: object (optional)
infrastructure: object (optional)
standards: object (optional)
_templates: object (optional)
metadata: object (optional)
```

### Foundation Plugin Schema

```yaml
foundation:
  <plugin-name>:
    status: enum (required)
      - Values: "stable" | "planned" | "community"

    required: boolean or enum (required)
      - Values: true | false | "recommended"

    description: string (required)
      - Min length: 10 characters
      - Max length: 200 characters

    location: string (required)
      - Format: "plugins/foundation/<plugin-name>/"
      - Must be relative path

    dependencies: array (required, can be empty)
      - Format: ["category/plugin-name", ...]
      - Each dependency must exist in manifest

    installation_guide: string (required)
      - Format: "plugins/foundation/<plugin-name>/AGENT_INSTRUCTIONS.md"
      - File must exist for status=stable
```

### Language Plugin Schema

```yaml
languages:
  <language-name>:
    status: enum (required)
      - Values: "stable" | "planned" | "community"

    description: string (required)
      - Min length: 10 characters
      - Max length: 200 characters

    location: string (required)
      - Format: "plugins/languages/<language-name>/"

    dependencies: array (required, can be empty)
      - Format: ["category/plugin-name", ...]

    options: object (optional)
      - Each option has:
        - available: array (required) - List of choices
        - recommended: string or array (required) - Default choice(s)
        - description: string (required) - What this configures

    installation_guide: string (required for status=stable)
      - Format: "plugins/languages/<language-name>/AGENT_INSTRUCTIONS.md"
```

### Infrastructure Plugin Schema

```yaml
infrastructure:
  <category>:
    <tool-name>:
      status: enum (required)
        - Values: "stable" | "planned" | "community"

      description: string (required)
        - Min length: 10 characters
        - Max length: 200 characters

      location: string (required)
        - Format: "plugins/infrastructure/<category>/<tool-name>/"

      dependencies: array (required, can be empty)

      options: object (optional)
        - Same structure as language options

      installation_guide: string (required for status=stable)
        - Format: "plugins/infrastructure/<category>/<tool-name>/AGENT_INSTRUCTIONS.md"
```

### Standards Plugin Schema

```yaml
standards:
  <standard-name>:
    status: enum (required)
      - Values: "stable" | "planned" | "community"

    required: boolean or enum (optional)
      - Values: true | false | "recommended"
      - Default: false

    description: string (required)
      - Min length: 10 characters
      - Max length: 200 characters

    location: string (required)
      - Format: "plugins/standards/<standard-name>/"

    dependencies: array (required, can be empty)

    options: object (optional)
      - Same structure as language options

    installation_guide: string (required for status=stable)
      - Format: "plugins/standards/<standard-name>/AGENT_INSTRUCTIONS.md"
```

## Validation Rules

### Rule 1: Version Compatibility
```
- Manifest must have 'version' field
- Version must be "1.0"
- Future: Support multiple versions with backward compatibility
```

### Rule 2: Required Categories
```
- 'foundation' category is required
- At least one foundation plugin must be present
- Other categories are optional
```

### Rule 3: Plugin Status
```
- status must be one of: stable, planned, community
- status=stable: installation_guide must exist and be accessible
- status=planned: installation_guide is optional
- status=community: installation_guide should exist
```

### Rule 4: Dependencies
```
- Each dependency must reference existing plugin
- Format: "category/plugin-name"
- No circular dependencies allowed
- Foundation plugins cannot depend on non-foundation plugins
```

### Rule 5: Options Structure
```
- If options exist, each option must have:
  - available: non-empty array
  - recommended: must be in available array
  - description: non-empty string
- recommended can be string (single) or array (multiple)
```

### Rule 6: Path Consistency
```
- location must match pattern: plugins/<category>/<name>/
- installation_guide must match pattern: plugins/<category>/<name>/AGENT_INSTRUCTIONS.md
- Paths must be relative (no leading /)
```

### Rule 7: Naming Conventions
```
- Plugin names: lowercase, hyphens allowed (e.g., "ai-folder")
- Category names: lowercase, hyphens allowed
- No spaces in names
- No special characters except hyphens
```

## Validation Implementation

### Python Validation Example

```python
import yaml
from pathlib import Path

def validate_manifest(manifest_path):
    """Validate PLUGIN_MANIFEST.yaml"""

    # Load manifest
    try:
        with open(manifest_path) as f:
            manifest = yaml.safe_load(f)
    except yaml.YAMLError as e:
        return False, f"YAML parsing error: {e}"

    # Check version
    if 'version' not in manifest:
        return False, "Missing 'version' field"
    if manifest['version'] != '1.0':
        return False, f"Unsupported version: {manifest['version']}"

    # Check foundation category exists
    if 'foundation' not in manifest:
        return False, "Missing 'foundation' category (required)"
    if not manifest['foundation']:
        return False, "'foundation' category is empty"

    # Validate each plugin
    errors = []
    for category in ['foundation', 'languages', 'infrastructure', 'standards']:
        if category not in manifest:
            continue

        category_errors = validate_category(category, manifest[category])
        errors.extend(category_errors)

    if errors:
        return False, "\n".join(errors)

    return True, "Manifest is valid"

def validate_category(category, plugins):
    """Validate plugins in a category"""
    errors = []

    for plugin_name, plugin_data in plugins.items():
        # Check required fields
        required = ['status', 'description', 'location']
        for field in required:
            if field not in plugin_data:
                errors.append(f"{category}/{plugin_name}: Missing '{field}'")

        # Validate status
        if 'status' in plugin_data:
            valid_statuses = ['stable', 'planned', 'community']
            if plugin_data['status'] not in valid_statuses:
                errors.append(f"{category}/{plugin_name}: Invalid status '{plugin_data['status']}'")

        # Check installation guide for stable plugins
        if plugin_data.get('status') == 'stable':
            if 'installation_guide' not in plugin_data:
                errors.append(f"{category}/{plugin_name}: Missing installation_guide (required for stable)")
            else:
                guide_path = Path(plugin_data['installation_guide'])
                if not guide_path.exists():
                    errors.append(f"{category}/{plugin_name}: installation_guide not found: {guide_path}")

        # Validate options structure
        if 'options' in plugin_data:
            for option_name, option_data in plugin_data['options'].items():
                if 'available' not in option_data:
                    errors.append(f"{category}/{plugin_name}.{option_name}: Missing 'available'")
                if 'recommended' not in option_data:
                    errors.append(f"{category}/{plugin_name}.{option_name}: Missing 'recommended'")

                # Check recommended is in available
                if 'available' in option_data and 'recommended' in option_data:
                    available = option_data['available']
                    recommended = option_data['recommended']
                    if isinstance(recommended, str):
                        if recommended not in available:
                            errors.append(f"{category}/{plugin_name}.{option_name}: recommended '{recommended}' not in available")
                    elif isinstance(recommended, list):
                        for rec in recommended:
                            if rec not in available:
                                errors.append(f"{category}/{plugin_name}.{option_name}: recommended '{rec}' not in available")

    return errors
```

### Usage

```bash
# Validate manifest
python3 -c "
import yaml
with open('plugins/PLUGIN_MANIFEST.yaml') as f:
    manifest = yaml.safe_load(f)
print('✓ Manifest is valid YAML')
print(f'Version: {manifest[\"version\"]}')
print(f'Foundation plugins: {len(manifest[\"foundation\"])}')
print(f'Language plugins: {len(manifest.get(\"languages\", {}))}')
"
```

## Common Validation Errors

### Error: "Missing required field"
```
Problem: Plugin missing status, description, or location
Fix: Add the missing field to the plugin definition
```

### Error: "Invalid status"
```
Problem: status is not one of: stable, planned, community
Fix: Change status to valid value
```

### Error: "Installation guide not found"
```
Problem: Stable plugin's AGENT_INSTRUCTIONS.md doesn't exist
Fix: Either create the file or change status to "planned"
```

### Error: "Dependency not found"
```
Problem: Plugin depends on non-existent plugin
Fix: Either add the dependency plugin or remove the dependency reference
```

### Error: "Circular dependency"
```
Problem: Plugin A depends on B, B depends on A
Fix: Restructure dependencies to be acyclic
```

### Error: "Recommended option not in available"
```
Problem: recommended value not in available array
Fix: Add recommended value to available array or change recommended
```

## Validation Checklist

Before committing changes to PLUGIN_MANIFEST.yaml:

- [ ] YAML syntax is valid (parses without errors)
- [ ] Version is "1.0"
- [ ] Foundation category exists and has plugins
- [ ] All stable plugins have installation_guide
- [ ] All installation_guide paths exist
- [ ] All dependencies reference existing plugins
- [ ] No circular dependencies
- [ ] All options have available, recommended, description
- [ ] All recommended values are in available arrays
- [ ] Plugin names follow naming conventions
- [ ] Paths are relative and consistent

## Automated Validation

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Validate manifest if it changed
if git diff --cached --name-only | grep -q "plugins/PLUGIN_MANIFEST.yaml"; then
    echo "Validating PLUGIN_MANIFEST.yaml..."
    python3 validate_manifest.py
    if [ $? -ne 0 ]; then
        echo "❌ Manifest validation failed"
        exit 1
    fi
    echo "✓ Manifest is valid"
fi
```

## Best Practices

1. **Always validate** before committing manifest changes
2. **Test stable plugins** - Ensure installation guides exist
3. **Document options** - Clear descriptions for each option
4. **Use recommended** - Set sensible defaults
5. **Keep dependencies minimal** - Only declare what's truly required
6. **Version carefully** - Don't break existing orchestrators
7. **Status progression** - planned → stable (never backward)

---

**Remember**: The manifest is the source of truth. Keep it valid, accurate, and well-documented.
