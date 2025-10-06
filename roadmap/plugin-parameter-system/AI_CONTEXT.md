# Plugin Parameter System - AI Context

**Purpose**: AI agent context document for implementing Plugin Parameter System

**Scope**: Universal parameter passing mechanism for all ai-projen plugins

**Overview**: Comprehensive context document for AI agents working on the Plugin Parameter System feature.
    This system enables any plugin to accept configuration parameters from callers (meta-plugins, roadmaps, direct invocation)
    while maintaining sensible defaults for standalone use. Solves the core problem of plugins needing adjustable behavior
    without hardcoded assumptions about context.

**Dependencies**: Existing plugin architecture, AGENT_INSTRUCTIONS.md pattern

**Exports**: Parameter standard, updated plugins with parameter support, integration testing framework

**Related**: PR_BREAKDOWN.md for implementation tasks, PROGRESS_TRACKER.md for current status

**Implementation**: Incremental rollout across plugin ecosystem with backward compatibility

---

## Overview

The Plugin Parameter System establishes a universal mechanism for passing configuration to plugins. Currently, plugins make assumptions about their execution context (e.g., "install files at repository root"), which breaks when used in different scenarios (e.g., full-stack apps needing files in subdirectories).

This system enables flexible, composable plugins that work standalone or in orchestrated contexts.

## Project Background

### The Problem
During testing of the `react-python-fullstack` application plugin, we discovered that language plugins (Python, TypeScript) create configuration files at the repository root. However, full-stack applications need these files in subdirectories:
- `teamgames-app/backend/pyproject.toml` (not `pyproject.toml`)
- `teamgames-app/frontend/package.json` (not `package.json`)

### Root Cause Analysis
Plugins have no mechanism to receive context from callers. They make hardcoded assumptions:
- "Create files in current directory"
- "Use default tool configuration"
- "Assume single-language repository"

These assumptions break in multi-language, multi-service scenarios.

### Initial Workarounds Considered
1. ❌ **Cleanup step in roadmap**: Delete root files after copying app structure
   - Problem: Band-aid solution, doesn't address root cause
2. ❌ **Application plugin bundles configs**: Don't use language plugins
   - Problem: Duplication, hard to maintain
3. ✅ **Parameter system**: Enable plugins to accept configuration
   - Chosen: Proper architectural solution

## Feature Vision

1. **Flexible Plugins**: Work standalone or in any orchestrated context
2. **Explicit Configuration**: Parameters make behavior explicit, not implicit
3. **Sensible Defaults**: All parameters optional, plugins "just work"
4. **Composable**: Plugins can call plugins, passing parameters as needed
5. **No Breaking Changes**: Existing usage continues to work

## Current Application Context

### ai-projen Plugin Architecture
```
plugins/
├── foundation/
│   └── ai-folder/              # Creates .ai/ structure
├── languages/
│   ├── python/
│   │   └── core/               # Installs Python tooling
│   └── typescript/
│       └── core/               # Installs TypeScript tooling
├── infrastructure/
│   ├── containerization/
│   │   └── docker/             # Sets up Docker
│   └── ci-cd/
│       └── github-actions/     # Sets up CI/CD
└── applications/
    └── react-python-fullstack/ # Meta-plugin (orchestrates others)
```

### Current Plugin Execution
```bash
# Language plugin assumes it owns repository
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
# → Creates pyproject.toml at repository root

# Problem: Full-stack app needs it elsewhere
# Desired: backend/pyproject.toml
```

### Current Workaround (Broken)
```bash
# PR2: Install language plugins at root
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
# → Creates pyproject.toml

# PR5: Copy app structure (has its own pyproject.toml)
cp -r PROJECT_NAME-app/* teamgames-app/
# → Now we have TWO pyproject.toml files!

# Missing: Cleanup step to remove root file
```

## Target Architecture

### Core Components

#### 1. Parameter Standard
```markdown
# .ai/docs/PLUGIN_PARAMETER_STANDARD.md

## Syntax
Follow: path/to/plugin/AGENT_INSTRUCTIONS.md
  with PARAM_NAME=value

## In Plugin
PARAM_NAME="${PARAM_NAME:-default_value}"
```

#### 2. Parameter-Aware Plugins
Every plugin documents and accepts parameters:
```markdown
# In plugin's AGENT_INSTRUCTIONS.md

## Parameters
- INSTALL_PATH - Where to install (default: .)
```

#### 3. Parameter-Passing Orchestrators
Meta-plugins and roadmaps pass parameters:
```bash
# Application plugin calculates parameters
BACKEND_PATH="teamgames-app/backend"

# Passes to language plugin
Follow: plugins/languages/python/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=${BACKEND_PATH}
```

### Call Chain Flow

```
User Request
    ↓
Application Plugin (decides structure)
    ↓
    Calculates: BACKEND_PATH=teamgames-app/backend
    ↓
Roadmap Creation (documents parameters)
    ↓
    Template: {{PYTHON_INSTALL_PATH}} → teamgames-app/backend
    ↓
Agent Reads Roadmap (sees parameters)
    ↓
    Executes: Follow: python plugin with INSTALL_PATH=teamgames-app/backend
    ↓
Python Plugin (uses parameter)
    ↓
    INSTALL_PATH="${INSTALL_PATH:-.}"  # Gets teamgames-app/backend
    Creates: teamgames-app/backend/pyproject.toml
    ↓
Result: Files in correct location from the start
```

### User Journey

#### Developer Using Plugin Directly
```bash
# 1. User wants Python tooling
# 2. Follows standalone instructions
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md

# 3. Plugin uses defaults (current directory)
INSTALL_PATH="${INSTALL_PATH:-.}"  # → .

# 4. Files created in current directory
# ✅ Works without any parameters
```

#### Developer Using Plugin in Subdirectory
```bash
# 1. User wants Python in backend/
# 2. Passes parameter
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=backend/

# 3. Plugin uses provided value
INSTALL_PATH="${INSTALL_PATH:-.}"  # → backend/

# 4. Files created in backend/
# ✅ Explicit, flexible
```

#### Developer Using Meta-Plugin
```bash
# 1. User wants full-stack app
# 2. Runs application plugin
Follow: plugins/applications/react-python-fullstack/AGENT_INSTRUCTIONS.md

# 3. Application plugin calculates structure
BACKEND_PATH="teamgames-app/backend"
FRONTEND_PATH="teamgames-app/frontend"

# 4. Passes parameters to atomic plugins
Follow: python plugin with INSTALL_PATH=${BACKEND_PATH}
Follow: typescript plugin with INSTALL_PATH=${FRONTEND_PATH}

# 5. Files created in correct locations
# ✅ Automatic, correct
```

## Key Decisions Made

### Decision 1: Generic Parameter System, Not Prescribed Parameters
**Choice**: Each plugin decides its own parameters
**Rationale**: Different plugins have different needs. Python needs INSTALL_PATH, Docker might need LANGUAGES, Foundation might need PROJECT_TYPE. No universal set makes sense.
**Impact**: Plugins are self-documenting; callers read AGENT_INSTRUCTIONS.md to know what's available

### Decision 2: All Parameters Must Have Defaults
**Choice**: Every parameter requires a default value
**Rationale**: Plugins must work standalone without any parameters (most common use case)
**Impact**: Parameters enable flexibility, don't require configuration

### Decision 3: Syntax: `with PARAM=value`
**Choice**: `Follow: plugin with PARAM=value` syntax
**Rationale**: Clear, explicit, self-documenting
**Impact**: Easy for agents to parse and understand

### Decision 4: Install Comprehensive, Run Selectively
**Choice**: Plugins always install all tools; Makefiles control which run when
**Rationale**: Prevents surprises in production (CI runs tools dev didn't use)
**Impact**: No tool choice parameters in language plugins; execution context in Makefile

### Decision 5: Backward Compatibility Required
**Choice**: Existing usage must continue to work unchanged
**Rationale**: Don't break existing plugins or workflows
**Impact**: Defaults must preserve current behavior

## Integration Points

### With Existing Features

#### Foundation Plugin
- Add INSTALL_PATH parameter
- Create .ai/ at specified location
- Default: current directory

#### Language Plugins (Python, TypeScript)
- Add INSTALL_PATH parameter
- Create config files at specified location
- Default: current directory
- Always install comprehensive tooling

#### Docker Plugin
- Add LANGUAGES parameter (auto-detect if not provided)
- Add SERVICES parameter (default: app)
- Add INSTALL_PATH parameter (default: .)
- Generate Dockerfiles based on LANGUAGES

#### Application Plugin (react-python-fullstack)
- Calculate directory structure
- Pass INSTALL_PATH to all atomic plugins
- Pass LANGUAGES to Docker plugin
- Update roadmap template with parameters

#### Roadmap Template
- Support parameter placeholders ({{PYTHON_INSTALL_PATH}})
- Generate parameter passing syntax
- Validate files at correct locations

## Success Metrics

### Technical Metrics
- [ ] All core plugins accept parameters
- [ ] 100% of parameters have defaults
- [ ] 0 breaking changes to existing usage
- [ ] Files created in correct locations (no root orphans)

### Developer Experience Metrics
- [ ] Standalone plugins work without parameters
- [ ] Custom paths work when specified
- [ ] Meta-plugin chains work correctly
- [ ] Documentation is clear and complete

### Integration Metrics
- [ ] Full-stack apps create files in subdirectories
- [ ] No cleanup steps needed
- [ ] Parameters flow through call chain
- [ ] Validation catches incorrect placements

## Technical Constraints

### Must Maintain
- Backward compatibility with existing plugins
- Standalone plugin usage (no parameters required)
- AGENT_INSTRUCTIONS.md pattern
- Git workflow (feature branches, etc.)

### Bash Limitations
- No true "types" (all parameters are strings)
- Default pattern: `${PARAM:-default}` only way to handle optional params
- Environment variable scoping (parameters are env vars)

### Agent Parsing
- Agents must understand `with PARAM=value` syntax
- Must set environment variables before executing plugin
- Must read parameter documentation from AGENT_INSTRUCTIONS.md

## AI Agent Guidance

### When Implementing a Plugin Parameter
1. **Document first**: Add parameter to AGENT_INSTRUCTIONS.md
2. **Provide default**: `PARAM="${PARAM:-default_value}"`
3. **Use consistently**: Apply parameter in all relevant places
4. **Test both modes**: Standalone (default) and with parameter
5. **Update README**: Add usage examples

### When Calling a Plugin with Parameters
1. **Read plugin docs**: Check AGENT_INSTRUCTIONS.md for available parameters
2. **Calculate values**: Determine appropriate parameter values for context
3. **Pass explicitly**: Use `with PARAM=value` syntax
4. **Validate**: Check files created in expected locations

### Common Patterns

#### Adding INSTALL_PATH to Plugin
```bash
# 1. Document parameter
## Parameters
- INSTALL_PATH - Installation directory (default: .)

# 2. Use in plugin
INSTALL_PATH="${INSTALL_PATH:-.}"
mkdir -p "${INSTALL_PATH}"
cat > "${INSTALL_PATH}/config.file" << 'EOF'
...
EOF

# 3. Update validation
test -f "${INSTALL_PATH}/config.file" && echo "✅"
```

#### Passing Parameters from Meta-Plugin
```bash
# 1. Calculate parameter value
TARGET_PATH="myapp-app/backend"

# 2. Fill template variable
{{PYTHON_INSTALL_PATH}} → ${TARGET_PATH}

# 3. Template uses variable
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH={{PYTHON_INSTALL_PATH}}
```

#### Auto-Detect with Parameter Override
```bash
# 1. Provide default via auto-detection
LANGUAGES="${LANGUAGES:-$(auto_detect_languages)}"

# 2. Use detected or provided value
if [[ "$LANGUAGES" == *"python"* ]]; then
  # Generate Python Dockerfile
fi
```

## Risk Mitigation

### Risk: Breaking Existing Plugins
**Mitigation**: All parameters have defaults; existing usage (no parameters) continues to work

### Risk: Inconsistent Parameter Names
**Mitigation**: Parameter standard defines naming convention (UPPER_SNAKE_CASE)

### Risk: Complex Parameter Chains
**Mitigation**: Each plugin documents its parameters; callers read docs before passing

### Risk: Path Traversal
**Mitigation**: Validate paths don't escape repository; mkdir -p safely creates paths

### Risk: Agent Confusion
**Mitigation**: Clear documentation, examples in every plugin, parameter standard reference

## Future Enhancements

### Phase 2 Capabilities
- **Type validation**: Validate parameter values (e.g., path exists)
- **Required parameters**: Some plugins might need mandatory params
- **Parameter presets**: Named bundles (e.g., QUALITY_LEVEL=production)
- **Nested parameters**: Pass parameters to transitively called plugins

### Advanced Features
- **Parameter discovery**: Tool to list all available parameters for a plugin
- **Parameter validation**: Schema for parameter values
- **Parameter templates**: Reusable parameter sets for common scenarios
- **Multi-value parameters**: Arrays or complex structures (currently just strings)

### Ecosystem Growth
- More plugins adopt parameter pattern
- Community plugins follow standard
- Parameter best practices emerge
- Plugin catalog shows parameter capabilities
