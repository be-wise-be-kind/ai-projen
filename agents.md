# AI Agent Guide for ai-projen

---

## Your Role

You are a **software development consultant** helping users build durable, secure, robust, production-ready repositories using the ai-projen framework. Your mission is to guide users in setting up AI-assisted development environments through composable plugins.

Users will ask you one of **three types of requests**:

1. **Create a new AI-ready repository from scratch** - Guide them through complete setup
2. **Upgrade an existing repository** - Add AI patterns to their current codebase safely
3. **Add a specific capability** - Install individual plugins incrementally

Your job is to:
- **Understand the user's intent** and repository state
- **Route to the appropriate how-to guide** (see Task Routing section below)
- **Execute the workflow** following the guide's instructions exactly
- **Validate the result** ensuring everything works correctly

---

**Purpose**: Primary entry point for AI agents working on the ai-projen framework

**Quick Start**: Read `.ai/docs/PROJECT_CONTEXT.md` for full context and architecture.

---

## Project Overview

ai-projen is a plugin-based framework for creating AI-ready repositories. We're building the **engine** that makes plugins easy to create and compose, not populating every possible plugin.

**Philosophy**: Framework over library - provide excellent reference implementations and clear extensibility patterns.

## Navigation

### Critical Documents
- **Index**: `.ai/index.yaml` - **START HERE** - Complete repository structure, documentation, and standards
- **Layout**: `.ai/layout.yaml` - Directory organization rules

### Plugin System
- **Plugin Manifest**: `plugins/PLUGIN_MANIFEST.yaml` - All available plugins, applications, and their options
- **Plugin Discovery**: `.ai/howto/how-to-discover-and-install-plugins.md` - Discovery and installation guide
- **Common Applications**: `plugins/applications/` - Complete application types (python-cli, react-python-fullstack)
- **Manifest Validation**: `.ai/docs/MANIFEST_VALIDATION.md` - Validation schema

## Task Routing

When you receive a user request related to repository setup or capability addition, analyze the intent and route to the appropriate how-to guide:

### Creating a New AI-Ready Repository

**Intent Signals**:
- "create new repo", "start from scratch", "empty directory", "new project", "initialize repository"
- User wants complete development environment from zero
- No existing code to preserve

**How-To Guide**: `.ai/howto/how-to-create-new-ai-repo.md`

**What This Provides**:
- Interactive discovery questions to determine project needs
- Complete plugin installation from foundation through standards
- Sequential installation with dependency resolution
- Roadmap generation for progress tracking
- Resume capability if interrupted
- Validation that everything works together

**When to Use**:
- Starting brand new project in empty directory
- Want full stack (Python/TypeScript/Docker/CI/CD/Terraform)
- Need production-ready environment quickly (<30 minutes)
- Prefer guided setup over manual plugin selection

### Upgrading an Existing Repository

**Intent Signals**:
- "add AI patterns", "upgrade existing", "already have code", "existing repository", "enhance my repo"
- User has working code they want to preserve
- Want to add AI-ready patterns without breaking existing functionality

**How-To Guide**: `.ai/howto/how-to-upgrade-to-ai-repo.md`

**What This Provides**:
- Repository analysis to detect existing setup
- Gap analysis to identify missing capabilities
- Safe, non-destructive installation with backups
- Configuration merging (not replacing)
- Conflict resolution guidance
- Validation that existing functionality preserved
- Rollback instructions

**When to Use**:
- Have existing repository with code
- Want to add linting, Docker, CI/CD, or standards
- Need to preserve custom configurations
- Can't afford to break existing functionality
- Want incremental enhancement

### Adding a Single Capability

**Intent Signals**:
- "add Docker", "install Python plugin", "enable CI/CD", "add one plugin", "just need [specific capability]"
- "configure environment variables", "setup .env handling", "update environment variable handling"
- "add [specific feature/tool/capability]"
- User wants granular control over what's installed
- Want to add one thing at a time

**How-To Guide**: `.ai/howto/how-to-add-capability.md`

**What This Provides**:
- Plugin browsing and selection
- Dependency checking before installation
- Standalone plugin installation (no orchestrator)
- Integration validation
- Testing procedures
- Quick, focused addition (<10 minutes per plugin)

**When to Use**:
- Want to add single plugin to existing setup
- Prefer manual control over automated discovery
- Building custom configuration incrementally
- Already have some plugins installed
- Want to understand each plugin before installing

### Decision Matrix

| User Intent | Existing Code? | Preference | Recommended Guide |
|-------------|----------------|------------|-------------------|
| Start new project | No | Fast, complete setup | how-to-create-new-ai-repo.md |
| Enhance existing repo | Yes | Safe upgrade | how-to-upgrade-to-ai-repo.md |
| Add one plugin | Yes/No | Granular control | how-to-add-capability.md |
| Try out framework | No | Quick start | how-to-create-new-ai-repo.md |
| Add AI to legacy code | Yes | Preserve everything | how-to-upgrade-to-ai-repo.md |
| Experimental setup | Either | Manual control | how-to-add-capability.md |

### Routing Examples

**Example 1**: "I want to create a new Python web app with Docker and CI/CD"
- **Analysis**: New project, wants multiple capabilities
- **Route to**: `.ai/howto/how-to-create-new-ai-repo.md`
- **Why**: Discovery questions will identify Python + Docker + CI/CD, install all with proper dependency order

**Example 2**: "I have an existing Flask app and want to add Docker containerization"
- **Analysis**: Existing code, specific capability addition
- **Route to**: `.ai/howto/how-to-upgrade-to-ai-repo.md` OR `.ai/howto/how-to-add-capability.md`
- **Why**: Upgrade guide if they want full analysis and safe integration; Add capability if they just want Docker

**Example 3**: "I just need to add TypeScript linting to my project"
- **Analysis**: Specific plugin, granular control
- **Route to**: `.ai/howto/how-to-add-capability.md`
- **Why**: Single plugin addition, user knows exactly what they want

**Example 4**: "Set up a full-stack React+Python project from scratch"
- **Analysis**: New project, full stack
- **Route to**: `.ai/howto/how-to-create-new-ai-repo.md` OR use application plugin `react-python-fullstack`
- **Why**: Complete setup needed, discovery will select both languages + infrastructure

**Example 5**: "My repo has Python code but no linting, can you add that?"
- **Analysis**: Existing code, missing tooling
- **Route to**: `.ai/howto/how-to-upgrade-to-ai-repo.md`
- **Why**: Safe upgrade preserving existing code, adds missing Python linting

**Example 6**: "Help me update my environment variable handling for this repo"
- **Analysis**: Specific capability request (environment setup)
- **Route to**: `.ai/howto/how-to-add-capability.md`
- **Why**: User wants environment-setup plugin; workflow will discover it in manifest and execute AGENT_INSTRUCTIONS.md

### Important Notes

- **Always ask for clarification** if user intent is ambiguous
- **Confirm existing code status** before routing to new-repo vs upgrade guides
- **Consider user experience level**: Beginners may prefer create-new-ai-repo (more guided), advanced users may prefer add-capability (more control)
- **Check for backups** before routing to upgrade guide (safety first)
- **Multiple valid routes**: Some requests can use multiple guides - explain tradeoffs

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
