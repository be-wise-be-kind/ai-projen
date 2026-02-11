# Plugin Parameter System - PR Breakdown

**Purpose**: Detailed implementation breakdown of Plugin Parameter System into manageable, atomic pull requests

**Scope**: Complete parameter system from standard definition through integration testing

**Overview**: Comprehensive breakdown of the Plugin Parameter System feature into 10 manageable, atomic
    pull requests. Each PR is designed to be self-contained, testable, and maintains plugin functionality
    while incrementally building toward the complete parameter system. Includes detailed implementation steps, file
    structures, testing requirements, and success criteria for each PR.

**Dependencies**: Existing plugin architecture, AGENT_INSTRUCTIONS.md pattern

**Exports**: PR implementation plans, file structures, testing strategies, and success criteria for each development phase

**Related**: AI_CONTEXT.md for architectural overview, PROGRESS_TRACKER.md for status tracking

**Implementation**: Atomic PR approach with detailed step-by-step implementation guidance and comprehensive testing validation

---

## Overview
This document breaks down the Plugin Parameter System into manageable, atomic PRs. Each PR is designed to be:
- Self-contained and testable
- Maintains working plugins
- Incrementally builds toward complete parameter system
- Revertible if needed

---

## PR1: Define Plugin Parameter Standard

**Branch**: `feature/pr1-parameter-standard`

**Objective**: Create the foundational standard for parameter passing across all plugins

**Files to Create**:
- `.ai/docs/PLUGIN_PARAMETER_STANDARD.md`

**Implementation Steps**:

1. Create standard document with sections:
   - **Parameter Syntax**: `Follow: path/to/plugin with PARAM=value`
   - **Naming Convention**: UPPER_SNAKE_CASE
   - **Default Pattern**: `${PARAM:-default_value}`
   - **Documentation Requirement**: Parameters must be documented in AGENT_INSTRUCTIONS.md
   - **Flexibility Principle**: Each plugin decides its own parameters

2. Include examples:
   ```markdown
   ## Example Usage

   ### Standalone (uses defaults)
   Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md

   ### With parameters
   Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
     with INSTALL_PATH=backend/
     with DEBUG_MODE=yes
   ```

3. Document best practices:
   - All parameters must have sensible defaults
   - Plugins should work without any parameters
   - Parameters enable flexibility, not replace defaults

**Testing**:
- [ ] Standard document is clear and comprehensive
- [ ] Examples are correct and runnable

**Success Criteria**:
- [x] `.ai/docs/PLUGIN_PARAMETER_STANDARD.md` exists
- [x] Syntax is well-defined
- [x] Examples demonstrate usage
- [x] Best practices documented

---

## PR2: Update Python Plugin for Parameters

**Branch**: `feature/pr2-python-plugin-parameters`

**Objective**: Add INSTALL_PATH parameter to Python plugin

**Files to Modify**:
- `plugins/languages/python/core/AGENT_INSTRUCTIONS.md`

**Implementation Steps**:

1. Add Parameters section at top of AGENT_INSTRUCTIONS.md:
   ```markdown
   ## Parameters

   This plugin accepts the following parameters:

   - **INSTALL_PATH** - Directory where Python tooling will be installed
     - Default: `.` (current directory)
     - Example: `backend/`, `services/api/`

   ### Usage

   Standalone (uses current directory):
   ```
   Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
   ```

   With custom path:
   ```
   Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
     with INSTALL_PATH=backend/
   ```
   ```

2. Update all file operations to use INSTALL_PATH:
   ```bash
   # At beginning of installation steps
   INSTALL_PATH="${INSTALL_PATH:-.}"
   mkdir -p "${INSTALL_PATH}"

   # When creating pyproject.toml
   cat > "${INSTALL_PATH}/pyproject.toml" << 'EOF'
   ...

   # When creating other config files
   cat > "${INSTALL_PATH}/.flake8" << 'EOF'
   ```

3. Update validation commands:
   ```bash
   test -f "${INSTALL_PATH}/pyproject.toml" && echo "✅ Python configured"
   ```

**Testing**:
- [ ] Test standalone: Creates files in current directory
- [ ] Test with INSTALL_PATH=backend/: Creates files in backend/
- [ ] Test with INSTALL_PATH=services/api/: Creates files in services/api/

**Success Criteria**:
- [x] Parameter documented in AGENT_INSTRUCTIONS.md
- [x] Default to current directory works
- [x] Custom paths work correctly
- [x] No breaking changes to existing usage

---

## PR3: Update TypeScript Plugin for Parameters

**Branch**: `feature/pr3-typescript-plugin-parameters`

**Objective**: Add INSTALL_PATH parameter to TypeScript plugin

**Files to Modify**:
- `plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md`

**Implementation Steps**:
Same pattern as PR2, but for TypeScript plugin:
1. Add Parameters section with INSTALL_PATH
2. Update all file operations to use INSTALL_PATH
3. Update validation commands

**Testing**:
- [ ] Test standalone: Creates files in current directory
- [ ] Test with INSTALL_PATH=frontend/: Creates files in frontend/
- [ ] Test with INSTALL_PATH=web/client/: Creates files in web/client/

**Success Criteria**:
- [x] Parameter documented
- [x] Default works
- [x] Custom paths work
- [x] No breaking changes

---

## PR4: Update Docker Plugin for Parameters

**Branch**: `feature/pr4-docker-plugin-parameters`

**Objective**: Add context parameters to Docker plugin

**Files to Modify**:
- `plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md`

**Parameters to Add** (plugin decides):
- `LANGUAGES` - Languages in use (default: auto-detect)
- `SERVICES` - Service names (default: `app`)
- `INSTALL_PATH` - Where to create .docker/ (default: `.`)

**Implementation Steps**:
1. Document parameters in AGENT_INSTRUCTIONS.md
2. Add auto-detection logic for LANGUAGES if not provided
3. Generate Dockerfiles based on LANGUAGES parameter
4. Create docker-compose files with specified SERVICES

**Testing**:
- [ ] Auto-detect works when no LANGUAGES provided
- [ ] LANGUAGES=python generates Python Dockerfile
- [ ] LANGUAGES=python,typescript generates both
- [ ] SERVICES parameter creates correct compose structure

**Success Criteria**:
- [x] Parameters documented
- [x] Auto-detection works
- [x] Custom parameters respected
- [x] Backward compatible

---

## PR5: Update Foundation Plugin for Parameters

**Branch**: `feature/pr5-foundation-plugin-parameters`

**Objective**: Add INSTALL_PATH to foundation plugin

**Files to Modify**:
- `plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md`

**Parameters to Add**:
- `INSTALL_PATH` - Where to create .ai/ (default: `.`)

**Implementation Steps**:
1. Document INSTALL_PATH parameter
2. Update .ai/ creation to use INSTALL_PATH
3. Update all template copying to use INSTALL_PATH

**Testing**:
- [ ] Standalone creates .ai/ in current directory
- [ ] INSTALL_PATH=backend/ creates backend/.ai/
- [ ] INSTALL_PATH=custom/path/ creates custom/path/.ai/

**Success Criteria**:
- [x] Parameter documented
- [x] Default works
- [x] Custom paths work
- [x] Consistent with other plugins

---

## PR6: Update Application Plugin to Pass Parameters

**Branch**: `feature/pr6-application-plugin-parameters`

**Objective**: Meta-plugin calculates and passes parameters to atomic plugins

**Files to Modify**:
- `plugins/applications/react-python-fullstack/AGENT_INSTRUCTIONS.md`

**Implementation Steps**:

1. In PR0 (roadmap creation), calculate parameters:
   ```bash
   # Calculate structure
   APP_NAME="${REPO_NAME%%.*}"
   BACKEND_PATH="${APP_NAME}-app/backend"
   FRONTEND_PATH="${APP_NAME}-app/frontend"
   DOCKER_ENABLED="${user_docker_choice}"

   # Fill template variables
   {{PYTHON_INSTALL_PATH}} → ${BACKEND_PATH}
   {{TYPESCRIPT_INSTALL_PATH}} → ${FRONTEND_PATH}
   {{DOCKER_ENABLED}} → ${DOCKER_ENABLED}
   {{LANGUAGES}} → "python,typescript"
   ```

2. Update PR2 instructions to pass parameters:
   ```markdown
   Execute Python plugin:
   ```
   Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
     with INSTALL_PATH={{PYTHON_INSTALL_PATH}}
   ```

   Execute TypeScript plugin:
   ```
   Follow: plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md
     with INSTALL_PATH={{TYPESCRIPT_INSTALL_PATH}}
   ```
   ```

3. Update PR3 (Docker) to pass parameters:
   ```markdown
   Follow: plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md
     with LANGUAGES={{LANGUAGES}}
     with SERVICES=backend,frontend,database
     with INSTALL_PATH=.docker/
   ```

**Testing**:
- [ ] Roadmap generation includes correct parameter values
- [ ] Parameters flow to atomic plugins correctly
- [ ] Files created in subdirectories, not root

**Success Criteria**:
- [x] Application plugin calculates parameters
- [x] Roadmap template receives parameter values
- [x] Parameters passed to all called plugins
- [x] Integration works end-to-end

---

## PR7: Update Roadmap Template for Parameters

**Branch**: `feature/pr7-roadmap-template-parameters`

**Objective**: Template supports parameter placeholders

**Files to Modify**:
- `.ai/templates/roadmap-meta-plugin-installation.md.template`

**Implementation Steps**:

1. Update PR1 section to create directories:
   ```markdown
   ### PR1: Install Foundation Plugin

   **Key Steps**:
   1. Create installation directory:
      ```bash
      mkdir -p {{FOUNDATION_INSTALL_PATH}}
      ```

   2. Execute foundation plugin:
      ```
      Follow: plugins/foundation/ai-folder/AGENT_INSTRUCTIONS.md
        with INSTALL_PATH={{FOUNDATION_INSTALL_PATH}}
      ```
   ```

2. Update PR2 section with parameter passing:
   ```markdown
   ### PR2: Install Language Plugins

   **Key Steps**:
   1. Create language directories:
      ```bash
      mkdir -p {{PYTHON_INSTALL_PATH}}
      mkdir -p {{TYPESCRIPT_INSTALL_PATH}}
      ```

   2. Install Python:
      ```
      Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
        with INSTALL_PATH={{PYTHON_INSTALL_PATH}}
      ```

   3. Install TypeScript:
      ```
      Follow: plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md
        with INSTALL_PATH={{TYPESCRIPT_INSTALL_PATH}}
      ```

   **Validation**:
   ```bash
   test -f {{PYTHON_INSTALL_PATH}}/pyproject.toml && echo "✅"
   test -f {{TYPESCRIPT_INSTALL_PATH}}/package.json && echo "✅"
   ! test -f pyproject.toml && echo "✅ No root config"
   ! test -f package.json && echo "✅ No root config"
   ```
   ```

3. Update PR3 (Docker) section:
   ```markdown
   ### PR3: Install Docker Infrastructure

   **Key Steps**:
   1. Execute Docker plugin:
      ```
      Follow: plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md
        with LANGUAGES={{LANGUAGES}}
        with SERVICES={{SERVICES}}
        with INSTALL_PATH={{DOCKER_INSTALL_PATH}}
      ```
   ```

**Testing**:
- [ ] Template variables get replaced correctly
- [ ] Generated roadmap has correct parameter syntax
- [ ] Validation checks files in correct locations

**Success Criteria**:
- [x] Template uses parameter placeholders
- [x] PR instructions include parameter passing
- [x] Validation checks correct locations
- [x] No hardcoded paths in template

---

## PR8: Update How-To Guides

**Branch**: `feature/pr8-howto-guides-parameters`

**Objective**: Document parameter usage in user-facing guides

**Files to Modify**:
- `.ai/howto/how-to-create-new-ai-repo.md`
- `.ai/howto/how-to-add-capability.md`
- `.ai/howto/how-to-upgrade-to-ai-repo.md`

**Implementation Steps**:

1. Add parameter section to each guide:
   ```markdown
   ## Using Plugin Parameters

   Plugins accept parameters to customize installation:

   ```
   Follow: plugins/path/to/plugin/AGENT_INSTRUCTIONS.md
     with PARAM_NAME=value
     with ANOTHER_PARAM=value
   ```

   Each plugin documents its accepted parameters in its AGENT_INSTRUCTIONS.md file.
   All parameters have defaults, so they're optional.
   ```

2. Add examples for common scenarios:
   ```markdown
   ### Installing Python in a Subdirectory

   ```
   Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
     with INSTALL_PATH=services/api/
   ```

   This creates `services/api/pyproject.toml` instead of root-level.
   ```

**Testing**:
- [ ] Examples in guides are correct
- [ ] Examples actually work when followed
- [ ] Clear explanation of parameter system

**Success Criteria**:
- [x] All guides explain parameter usage
- [x] Examples demonstrate common patterns
- [x] Links to PLUGIN_PARAMETER_STANDARD.md

---

## PR9: Update Plugin Development Docs

**Branch**: `feature/pr9-plugin-dev-docs-parameters`

**Objective**: Guide plugin developers on adding parameters

**Files to Modify**:
- `.ai/docs/PLUGIN_DEVELOPMENT.md`

**Implementation Steps**:

1. Add section on implementing parameters:
   ```markdown
   ## Adding Parameters to Your Plugin

   ### 1. Document Parameters

   In your plugin's AGENT_INSTRUCTIONS.md, add a Parameters section:

   ```markdown
   ## Parameters

   - **PARAM_NAME** - Description of parameter
     - Default: `default_value`
     - Example: `example_value`
   ```

   ### 2. Use Parameters with Defaults

   In your plugin code:
   ```bash
   PARAM_NAME="${PARAM_NAME:-default_value}"
   ```

   ### 3. Test Both Modes

   Test your plugin:
   - Without parameters (uses defaults)
   - With parameters (uses provided values)

   ### 4. Document in README

   Add parameter examples to your plugin's README.md
   ```

2. Add best practices:
   ```markdown
   ## Parameter Best Practices

   1. **Always provide defaults** - Plugins must work without parameters
   2. **Document all parameters** - Users need to know what's available
   3. **Use meaningful names** - INSTALL_PATH better than PATH or DIR
   4. **Test standalone mode** - Most important use case
   5. **Consider composition** - Your plugin might call others
   ```

**Testing**:
- [ ] Documentation is clear
- [ ] Examples are correct
- [ ] Best practices are actionable

**Success Criteria**:
- [x] Clear instructions for adding parameters
- [x] Examples demonstrate patterns
- [x] Best practices documented
- [x] Links to parameter standard

---

## PR10: Integration Testing

**Branch**: `feature/pr10-integration-testing`

**Objective**: Validate entire parameter system works end-to-end

**Test Scenarios**:

### Scenario 1: Standalone Python Plugin
```bash
# Test in empty directory
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md

# Validate
test -f pyproject.toml && echo "✅ Works standalone"
```

### Scenario 2: Python Plugin with Path
```bash
# Test with custom path
Follow: plugins/languages/python/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=backend/

# Validate
test -f backend/pyproject.toml && echo "✅ Custom path works"
! test -f pyproject.toml && echo "✅ No root file"
```

### Scenario 3: TypeScript Plugin with Path
```bash
Follow: plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=frontend/

# Validate
test -f frontend/package.json && echo "✅ Custom path works"
! test -f package.json && echo "✅ No root file"
```

### Scenario 4: Full-Stack Meta-Plugin
```bash
# Run complete react-python-fullstack installation
Follow: plugins/applications/react-python-fullstack/AGENT_INSTRUCTIONS.md

# Validate structure
test -f teamgames-app/backend/pyproject.toml && echo "✅ Backend config correct"
test -f teamgames-app/frontend/package.json && echo "✅ Frontend config correct"
! test -f pyproject.toml && echo "✅ No root Python config"
! test -f package.json && echo "✅ No root Node config"
```

### Scenario 5: Docker Plugin with Languages
```bash
Follow: plugins/infrastructure/containerization/docker/AGENT_INSTRUCTIONS.md
  with LANGUAGES=python,typescript
  with SERVICES=backend,frontend,database

# Validate
test -f .docker/dockerfiles/Dockerfile.backend && echo "✅"
test -f .docker/dockerfiles/Dockerfile.frontend && echo "✅"
grep "backend" docker-compose.yml && echo "✅"
```

**Success Criteria**:
- [x] All standalone tests pass
- [x] All parameter tests pass
- [x] Meta-plugin integration works
- [x] No orphaned files at root
- [x] Files in correct locations

---

## Implementation Guidelines

### Code Standards
- Follow existing plugin structure
- Use consistent parameter naming (UPPER_SNAKE_CASE)
- Always provide defaults
- Document all parameters

### Testing Requirements
- Test standalone mode (no parameters)
- Test with parameters
- Test in meta-plugin context
- Validate file locations

### Documentation Standards
- Parameters section in AGENT_INSTRUCTIONS.md
- Usage examples (standalone and with parameters)
- Best practices noted
- Links to parameter standard

### Security Considerations
- Parameters should not accept arbitrary code
- Validate paths don't escape repository
- No sensitive data in parameters

### Performance Targets
- Parameter parsing should be negligible overhead
- No impact on plugin execution time
- Templates render efficiently

## Rollout Strategy

### Phase 1: Foundation (PR1)
- Standard defined
- Team aligned on approach

### Phase 2: Core Plugins (PR2-5)
- Language plugins updated
- Infrastructure plugins updated
- Tested independently

### Phase 3: Orchestration (PR6-7)
- Meta-plugins pass parameters
- Templates support parameters
- End-to-end flow works

### Phase 4: Documentation (PR8-9)
- Users understand how to use
- Developers understand how to implement

### Phase 5: Validation (PR10)
- Integration tests confirm functionality
- Edge cases covered
- Production ready

## Success Metrics

### Launch Metrics
- [ ] 100% of core plugins support parameters
- [ ] 0 breaking changes to existing usage
- [ ] Full-stack apps create files in correct locations
- [ ] Documentation complete

### Ongoing Metrics
- [ ] New plugins follow parameter pattern
- [ ] Users successfully use parameters
- [ ] No issues with file placement
- [ ] Positive developer experience
