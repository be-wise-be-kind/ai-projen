# AI Agent Guide for ai-projen

**Purpose**: Primary entry point for AI agents working on the ai-projen framework

**Quick Start**: Read `.ai/docs/PROJECT_CONTEXT.md` for full context and architecture.

---

## Project Overview

ai-projen is a plugin-based framework for creating AI-ready repositories. We're building the **engine** that makes plugins easy to create and compose, not populating every possible plugin.

**Philosophy**: Framework over library - provide excellent reference implementations and clear extensibility patterns.

## Navigation

### Critical Documents
- **Project Context**: `.ai/docs/PROJECT_CONTEXT.md` - Architecture and philosophy
- **Plugin Architecture**: `.ai/docs/PLUGIN_ARCHITECTURE.md` - How plugins work
- **Plugin Discovery**: `.ai/docs/PLUGIN_DISCOVERY.md` - How orchestrators discover plugins
- **Manifest Validation**: `.ai/docs/MANIFEST_VALIDATION.md` - Plugin manifest schema
- **File Header Standards**: `.ai/docs/FILE_HEADER_STANDARDS.md` - File header documentation standards
- **Index**: `.ai/index.yaml` - Repository structure and navigation
- **Layout**: `.ai/layout.yaml` - Directory organization

### Plugin System
- **Plugin Manifest**: `plugins/PLUGIN_MANIFEST.yaml` - All available plugins, applications, and their options
- **Plugin Discovery**: `.ai/howto/how-to-discover-and-install-plugins.md` - Discovery and installation guide
- **Common Applications**: `plugins/applications/` - Complete application types (python-cli, react-python-fullstack)
- **Manifest Validation**: `.ai/docs/MANIFEST_VALIDATION.md` - Validation schema

## Development Guidelines

### When Working on ai-projen Itself

1. **Follow Your Own Patterns**
   - This repo is self-referential (it uses the patterns it teaches)
   - Maintain `.ai/` folder structure
   - Use file headers (see examples in `.ai/docs/`)
   - Update documentation as you code

2. **Incremental Development**
   - Keep changes atomic and testable
   - Maintain backward compatibility
   - Document breaking changes clearly

3. **Plugin Independence**
   - Every plugin must work standalone (without orchestrator)
   - Test plugins in isolation before integration
   - Clear dependency declarations in AGENT_INSTRUCTIONS.md
   - No hidden dependencies

4. **Manifest Maintenance**
   - Add new plugins to `plugins/PLUGIN_MANIFEST.yaml`
   - Validate YAML syntax before committing
   - Specify status (stable/planned/community)
   - Document all plugin options with recommended defaults

### When Creating Plugins

1. **Use Templates**
   - Start with appropriate `_template/` directory (when available in PR4+)
   - Follow existing plugin structure (see `plugins/foundation/ai-folder/`)
   - Include both AGENT_INSTRUCTIONS.md and README.md

2. **Documentation Requirements**
   - AGENT_INSTRUCTIONS.md: Step-by-step installation for AI agents
   - README.md: Human-readable purpose and usage
   - Clear prerequisites and dependencies
   - Success criteria for validation

3. **Testing**
   - Test standalone installation (no orchestrator)
   - Test in all three test repos (empty, incremental, upgrade)
   - Validate YAML files parse correctly
   - Ensure no conflicts with other plugins

## Build and Test Commands

### Validation
```bash
# Validate plugin manifest
python3 -c "import yaml; yaml.safe_load(open('plugins/PLUGIN_MANIFEST.yaml'))"

# Validate .ai/index.yaml
python3 -c "import yaml; yaml.safe_load(open('.ai/index.yaml'))"

# Validate .ai/layout.yaml
python3 -c "import yaml; yaml.safe_load(open('.ai/layout.yaml'))"
```

### Testing (when test suite exists in PR8+)
```bash
# Run all tests
make test-all

# Run specific plugin tests
make test-plugin-<plugin-name>

# Validate manifest
make validate-manifest
```

## Code Style

### File Headers
All files must include comprehensive headers following `.ai/docs/FILE_HEADER_STANDARDS.md`

### YAML Conventions
- Use spaces, not tabs (2-space indentation)
- Quote strings with special characters (`:`, `{`, `}`, etc.)
- Validate syntax before committing
- Keep arrays and objects properly indented

### Naming Conventions
- Plugin names: lowercase with hyphens (e.g., `ai-folder`)
- Directory names: lowercase with hyphens
- File names: lowercase with hyphens or underscores
- No spaces in any names

## Git Workflow

### Commit Messages
Follow conventional commits format:
```
feat(pr<N>): Brief description

Detailed description of changes.

Changes:
- Bullet point list of changes
- Be specific and clear

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Branch Strategy
- `main` - Stable releases
- Feature branches for new plugins or capabilities
- Test thoroughly before merging

### Before Committing
- [ ] All YAML files validate
- [ ] Documentation updated
- [ ] File headers present
- [ ] No breaking changes (or clearly documented)
- [ ] Plugin tests pass (if applicable)

## Key Architectural Decisions

### Why Plugin-Based?
Extensibility - easy to add new languages, clouds, tools without modifying core

### Why Standalone-First?
Flexibility - users can add capabilities incrementally, not all-or-nothing

### Why AGENT_INSTRUCTIONS.md?
AI-friendly - clear, structured instructions AI agents can follow reliably

### Why Not Code Generation?
Complexity - too many edge cases; AI agents interpret instructions better than rigid scripts

## Common Tasks

### Adding a New Plugin (After PR4)
1. Copy appropriate `_template/` directory
2. Fill in AGENT_INSTRUCTIONS.md
3. Add templates and configurations
4. Update PLUGIN_MANIFEST.yaml
5. Test standalone installation
6. Create PR following commit message format

### Resuming Work After Interruption
1. Read `roadmap/ai_projen_implementation/PROGRESS_TRACKER.md`
2. Check "Next PR to Implement" section
3. Read detailed instructions in PR_BREAKDOWN.md
4. Execute the PR steps
5. Update both tracker files when complete

### Debugging Plugin Installation
1. Check AGENT_INSTRUCTIONS.md for prerequisites
2. Validate all YAML files parse correctly
3. Verify dependencies are installed
4. Check for file path conflicts
5. Test in clean test repository

## Security Considerations

- Never commit secrets or credentials
- Validate user input in orchestrators
- Check file paths before operations
- Don't execute untrusted code
- Secrets should be in `.env` (gitignored)

## Resources

### Source Material
- **durable-code-test**: https://github.com/steve-e-jackson/durable-code-test
  - Source of all proven patterns
  - Reference for plugin implementations
  - Example of complete AI-ready repository

### Documentation
- agents.md spec: https://agents.md/
- YAML specification: https://yaml.org/spec/
- Conventional Commits: https://www.conventionalcommits.org/

## Getting Help

### When Stuck
1. Read PROJECT_CONTEXT.md for philosophy and decisions
2. Check PROGRESS_TRACKER.md for current state
3. Look at existing plugins for examples
4. Review PLUGIN_MANIFEST.yaml for available options

### Reporting Issues
- Check existing PRs and issues first
- Provide clear reproduction steps
- Include relevant file paths
- Suggest solutions when possible

---

**Remember**: We're building the framework that creates AI-ready repositories. It should exemplify the patterns it teaches. Keep plugins standalone, documentation clear, and state tracked.
