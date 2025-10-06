# Plugin Parameter Standard

**Purpose**: Standard for passing parameters to ai-projen plugins

**Scope**: Universal parameter passing mechanism for all plugins

**Overview**: Defines the syntax, conventions, and best practices for plugin parameters in ai-projen.
    Enables any plugin to accept configuration from callers (meta-plugins, roadmaps, direct invocation)
    while maintaining sensible defaults for standalone use. This standard ensures consistent parameter
    handling across the entire plugin ecosystem.

**Dependencies**: AGENT_INSTRUCTIONS.md pattern

**Exports**: Parameter syntax standard, naming conventions, implementation patterns

**Related**: PLUGIN_DEVELOPMENT.md for plugin authoring, individual plugin AGENT_INSTRUCTIONS.md for specific parameters

**Implementation**: Standard followed by all plugins in the ai-projen ecosystem

---

## Core Principles

1. **Every parameter has a default** - Either a value, auto-detection, or user input prompt
2. **Each plugin defines its own parameters** - No universal parameter list
3. **Parameters are explicit** - Behavior is configurable, not hardcoded
4. **Standard syntax** - Consistent across all plugins
5. **Composable** - Plugins can call other plugins with parameters

---

## Parameter Syntax

### Basic Usage

```bash
Follow: path/to/plugin/AGENT_INSTRUCTIONS.md
  with PARAM_NAME=value
```

### Multiple Parameters

```bash
Follow: path/to/plugin/AGENT_INSTRUCTIONS.md
  with PARAM_ONE=value1
  with PARAM_TWO=value2
  with PARAM_THREE=value3
```

### Standalone Usage (No Parameters)

```bash
Follow: path/to/plugin/AGENT_INSTRUCTIONS.md
```

**Result**: Plugin uses default values for all parameters

---

## Naming Conventions

### Parameter Names
- **Format**: `UPPER_SNAKE_CASE`
- **Descriptive**: Clear what the parameter controls
- **Consistent**: Similar parameters use similar names across plugins

**Examples**:
- ✅ `INSTALL_PATH` - Clear, consistent
- ✅ `DOCKER_ENABLED` - Descriptive
- ✅ `LANGUAGES` - Concise
- ❌ `path` - Wrong case
- ❌ `InstallPath` - Wrong case
- ❌ `DIR` - Too abbreviated

### Common Parameter Names

While each plugin defines its own parameters, these names are commonly used:

- **`INSTALL_PATH`** - Directory where plugin installs files (default: `.`)
- **`LANGUAGES`** - Comma-separated list of languages (default: auto-detect)
- **`DOCKER_ENABLED`** - Whether to use Docker (default: `auto`)
- **`SERVICES`** - Comma-separated service names (default: plugin-specific)
- **`DEBUG_MODE`** - Enable debug output (default: `no`)

**Note**: These are conventions, not requirements. Use names that make sense for your plugin.

---

## Implementation Pattern

### In Plugin Code

```bash
# Accept parameter with default
PARAM_NAME="${PARAM_NAME:-default_value}"

# Use parameter in logic
mkdir -p "${PARAM_NAME}"
cat > "${PARAM_NAME}/config.file" << 'EOF'
...
EOF
```

### In Plugin Documentation

Every plugin must document its parameters in `AGENT_INSTRUCTIONS.md`:

```markdown
## Parameters

This plugin accepts the following parameters:

- **PARAM_NAME** - Description of what the parameter controls
  - Default: `default_value`
  - Example: `custom_value`
  - Notes: Any important usage notes

### Usage

Standalone (uses defaults):
```
Follow: plugins/category/name/AGENT_INSTRUCTIONS.md
```

With parameters:
```
Follow: plugins/category/name/AGENT_INSTRUCTIONS.md
  with PARAM_NAME=custom_value
```
```

---

## Examples

### Example 1: Python Plugin with INSTALL_PATH

**Plugin Documentation**:
```markdown
## Parameters

- **INSTALL_PATH** - Directory to install Python tooling
  - Default: `.` (current directory)
  - Example: `backend/`, `services/api/`
```

**Standalone Usage**:
```bash
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
```
**Result**: Creates `pyproject.toml` in current directory

**With Parameter**:
```bash
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=backend/
```
**Result**: Creates `backend/pyproject.toml`

### Example 2: Docker Plugin with Multiple Parameters

**Plugin Documentation**:
```markdown
## Parameters

- **LANGUAGES** - Languages in use (default: auto-detect)
- **SERVICES** - Service names (default: `app`)
- **INSTALL_PATH** - Where to create .docker/ (default: `.`)
```

**Usage**:
```bash
Follow: plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md
  with LANGUAGES=python,typescript
  with SERVICES=backend,frontend,database
  with INSTALL_PATH=.docker/
```

### Example 3: Meta-Plugin Passing Parameters

**Application Plugin Code**:
```bash
# Calculate parameters based on application structure
APP_NAME="${REPO_NAME%%.*}"
BACKEND_PATH="${APP_NAME}-app/backend"
FRONTEND_PATH="${APP_NAME}-app/frontend"

# Pass to atomic plugins
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=${BACKEND_PATH}

Follow: plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=${FRONTEND_PATH}
```

**Result**:
- Python files in `teamgames-app/backend/`
- TypeScript files in `teamgames-app/frontend/`
- No files at repository root

---

## Default Value Patterns

### Simple Default
```bash
PARAM_NAME="${PARAM_NAME:-default_value}"
```

### User Input Required (No Sensible Default)
```bash
# Parameter requires user input if not provided
if [ -z "$API_KEY" ]; then
  echo "API_KEY parameter not provided."
  echo "Please provide your API key:"
  read -p "API_KEY: " API_KEY

  if [ -z "$API_KEY" ]; then
    echo "❌ Error: API_KEY is required"
    exit 1
  fi
fi
```

**When to use**:
- No sensible default exists (e.g., API keys, project names, organization IDs)
- Value is context-specific and can't be auto-detected
- User must make an explicit choice

**Documentation pattern**:
```markdown
- **API_KEY** - Your API key for service X
  - Default: `user input` (will prompt if not provided)
  - Example: `sk-abc123xyz`
```

### Auto-Detection Default
```bash
# Detect value if not provided
LANGUAGES="${LANGUAGES:-$(auto_detect_languages)}"
```

### Conditional Default
```bash
# Default depends on context
if [ -z "$INSTALL_PATH" ]; then
  if [ -d "src/" ]; then
    INSTALL_PATH="src/"
  else
    INSTALL_PATH="."
  fi
fi
```

### Comma-Separated List
```bash
# Accept list, iterate over items
LANGUAGES="${LANGUAGES:-python}"
IFS=',' read -ra LANG_ARRAY <<< "$LANGUAGES"
for lang in "${LANG_ARRAY[@]}"; do
  process_language "$lang"
done
```

---

## Best Practices

### For Plugin Authors

1. **Document all parameters** - In AGENT_INSTRUCTIONS.md Parameters section
2. **Provide defaults** - Value, auto-detect, or user input prompt
3. **Test both modes** - Standalone and with parameters
4. **Use standard names** - Follow common conventions when applicable
5. **Validate parameters** - Check paths exist, values are valid
6. **Prompt when needed** - Use `user input` default when no sensible default exists

### For Plugin Users

1. **Read plugin documentation** - Check AGENT_INSTRUCTIONS.md for available parameters
2. **Use descriptive values** - Make parameter intent clear
3. **Test parameter combinations** - Ensure values work together
4. **Document your usage** - If calling from meta-plugin, explain why
5. **Respect defaults** - Only pass parameters when needed

### For Meta-Plugin Authors

1. **Calculate parameters explicitly** - Don't guess or assume
2. **Pass only what's needed** - Don't pass unused parameters
3. **Document parameter flow** - Show where values come from
4. **Validate before passing** - Ensure parameter values are correct
5. **Test parameter chains** - Verify parameters flow correctly

---

## Common Patterns

### Pattern 1: Path-Based Installation

**Use Case**: Plugin needs to install files somewhere

**Parameter**: `INSTALL_PATH` (default: `.`)

**Implementation**:
```bash
INSTALL_PATH="${INSTALL_PATH:-.}"
mkdir -p "${INSTALL_PATH}"
cat > "${INSTALL_PATH}/config.file" << 'EOF'
...
EOF
```

### Pattern 2: Feature Toggle

**Use Case**: Optional feature user can enable

**Parameter**: `FEATURE_ENABLED` (default: `no`)

**Implementation**:
```bash
FEATURE_ENABLED="${FEATURE_ENABLED:-no}"

if [ "$FEATURE_ENABLED" = "yes" ]; then
  # Install optional feature
  install_optional_feature
fi
```

### Pattern 3: Context Awareness

**Use Case**: Plugin adapts to environment

**Parameter**: `LANGUAGES` (default: auto-detect)

**Implementation**:
```bash
LANGUAGES="${LANGUAGES:-$(auto_detect_languages)}"

if [[ "$LANGUAGES" == *"python"* ]]; then
  setup_python
fi

if [[ "$LANGUAGES" == *"typescript"* ]]; then
  setup_typescript
fi
```

### Pattern 4: User Input Required

**Use Case**: Parameter has no sensible default

**Parameter**: Requires user input if not provided

**Implementation**:
```bash
# Prompt user if parameter not provided
if [ -z "$PROJECT_NAME" ]; then
  echo "PROJECT_NAME parameter not provided."
  echo "This will be used for package naming and directory structure."
  read -p "Enter project name: " PROJECT_NAME

  # Validate non-empty
  if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: PROJECT_NAME is required"
    exit 1
  fi

  # Validate format (optional)
  if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "❌ Error: PROJECT_NAME must be lowercase with hyphens"
    exit 1
  fi
fi

# Use project name
echo "Creating project: $PROJECT_NAME"
```

**Documentation**:
```markdown
- **PROJECT_NAME** - Name of your project
  - Default: `user input` (will prompt if not provided)
  - Format: lowercase-with-hyphens
  - Example: `my-awesome-app`
```

### Pattern 5: Composition

**Use Case**: Plugin calls another plugin

**Parameter**: Pass parameters down the chain

**Implementation**:
```bash
# Meta-plugin calculates parameters
BACKEND_PATH="app/backend"

# Passes to atomic plugin
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=${BACKEND_PATH}

# Python plugin receives and uses
INSTALL_PATH="${INSTALL_PATH:-.}"
cat > "${INSTALL_PATH}/pyproject.toml" << 'EOF'
...
EOF
```

---

## Validation

### Parameter Value Validation

```bash
# Validate path exists
if [ ! -z "$INSTALL_PATH" ] && [ ! -d "$(dirname "$INSTALL_PATH")" ]; then
  echo "❌ Error: Parent directory of INSTALL_PATH doesn't exist"
  exit 1
fi

# Validate enum value
VALID_VALUES="yes|no|auto"
if [[ ! "$DOCKER_ENABLED" =~ ^($VALID_VALUES)$ ]]; then
  echo "❌ Error: DOCKER_ENABLED must be one of: $VALID_VALUES"
  exit 1
fi
```

### Testing Parameters

```bash
# Test 1: Standalone (uses defaults)
Follow: plugins/your-plugin/AGENT_INSTRUCTIONS.md
test -f expected_file && echo "✅ Standalone works"

# Test 2: With parameter
Follow: plugins/your-plugin/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=custom/
test -f custom/expected_file && echo "✅ Custom path works"

# Test 3: Multiple parameters
Follow: plugins/your-plugin/AGENT_INSTRUCTIONS.md
  with PARAM_ONE=value1
  with PARAM_TWO=value2
test_conditions && echo "✅ Multiple parameters work"
```

---

## Anti-Patterns

### ❌ Don't: Require Parameters

```bash
# BAD: Forces user to provide parameter
if [ -z "$INSTALL_PATH" ]; then
  echo "Error: INSTALL_PATH required"
  exit 1
fi
```

**Why**: Violates "plugins work standalone" principle

**Instead**: Provide default
```bash
INSTALL_PATH="${INSTALL_PATH:-.}"
```

### ❌ Don't: Hardcode Behavior

```bash
# BAD: Hardcoded assumption
cat > backend/pyproject.toml << 'EOF'
```

**Why**: Can't be used in different contexts

**Instead**: Use parameter
```bash
INSTALL_PATH="${INSTALL_PATH:-.}"
cat > "${INSTALL_PATH}/pyproject.toml" << 'EOF'
```

### ❌ Don't: Use Lowercase Parameter Names

```bash
# BAD: Wrong naming convention
install_path="${install_path:-.}"
```

**Why**: Inconsistent with standard

**Instead**: Use UPPER_SNAKE_CASE
```bash
INSTALL_PATH="${INSTALL_PATH:-.}"
```

### ❌ Don't: Pass Undocumented Parameters

```bash
# BAD: Using parameter not in plugin's docs
Follow: plugins/some-plugin/AGENT_INSTRUCTIONS.md
  with SECRET_PARAM=value
```

**Why**: Plugin doesn't know about this parameter, will ignore it

**Instead**: Read plugin's AGENT_INSTRUCTIONS.md, use documented parameters

---

## Migration Guide

### For Existing Plugins

1. **Add Parameters section** to AGENT_INSTRUCTIONS.md
2. **Identify hardcoded values** that should be parameterized
3. **Add default pattern**: `PARAM="${PARAM:-default}"`
4. **Update file operations** to use parameters
5. **Test standalone mode** (must still work)
6. **Add usage examples** to documentation

### For Existing Meta-Plugins

1. **Calculate parameter values** based on structure
2. **Update plugin calls** to pass parameters
3. **Update roadmap templates** with parameter placeholders
4. **Test parameter flow** end-to-end
5. **Validate file locations** are correct

---

## Summary

**Key Takeaways**:
1. Parameter syntax: `Follow: plugin with PARAM=value`
2. All parameters must have defaults
3. Plugins work standalone (no parameters required)
4. Each plugin decides its own parameters
5. Document parameters in AGENT_INSTRUCTIONS.md
6. Use UPPER_SNAKE_CASE naming

**Next Steps**:
- See `PLUGIN_DEVELOPMENT.md` for implementing parameters in plugins
- See individual plugin AGENT_INSTRUCTIONS.md for available parameters
- See `roadmap/plugin-parameter-system/` for implementation roadmap
