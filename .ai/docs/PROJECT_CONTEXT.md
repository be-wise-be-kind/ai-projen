# AI-Projen - Project Context

**Purpose**: Comprehensive project context for AI agents working on ai-projen

**Scope**: Framework architecture, development philosophy, and maintenance guidance

**Overview**: Context document for AI agents maintaining and extending the ai-projen framework. Describes
    the purpose, architecture, design decisions, and patterns that make ai-projen a plugin-based system
    for creating AI-ready repositories. Essential for understanding how to maintain the framework itself
    and how to create new plugins that integrate seamlessly with the existing ecosystem.

**Dependencies**: [durable-code-test](https://github.com/steve-e-jackson/durable-code-test) (source patterns), Git/GitHub

**Exports**: Framework context, architectural patterns, development guidelines

**Related**: PLUGIN_ARCHITECTURE.md for technical details, PLUGIN_DISCOVERY.md for orchestration logic

**Implementation**: Self-referential documentation following the same patterns the framework teaches

---

## Project Purpose

**ai-projen** is a framework for creating AI-ready repositories through composable, standalone plugins.

### The Problem
Setting up a production-ready repository with proper structure, linting, testing, containerization, CI/CD, and cloud deployment takes days or weeks and requires deep expertise across multiple technologies.

### The Solution
A plugin-based framework that:
- Transforms empty directories into production-ready environments in <30 minutes
- Works standalone (individual plugins) or orchestrated (complete setup)
- Is extensible (easy to add new languages, clouds, tools)
- Is battle-tested (patterns from production applications)

### Key Insight
**We're not building a library of every possible plugin.** We're building the **engine** that makes plugins easy to create and compose. Ship with excellent reference implementations, document extensibility, and let the framework grow organically.

## Architecture Overview

### Plugin-Based Design
Everything is a plugin:
- **applications/** - Complete application types (python-cli, react-python-fullstack)
- **foundation/** - Universal plugins (ai-folder structure)
- **languages/** - Language-specific tooling (Python, TypeScript)
- **infrastructure/** - Deployment tools (Docker, CI/CD, Terraform)
- **standards/** - Quality enforcement (Security, Documentation, Pre-commit)

### Three Entry Points
1. **CREATE-NEW-AI-REPO.md** - New repository from scratch
2. **UPGRADE-TO-AI-REPO.md** - Add patterns to existing repository
3. **ADD-CAPABILITY.md** - Add single plugin incrementally

### Plugin Structure
Each plugin contains:
- `AGENT_INSTRUCTIONS.md` - How an AI agent installs this plugin
- `README.md` - Human-readable description
- `templates/` - File templates
- `configs/` - Configuration files

### Manifest-Driven Discovery
`plugins/PLUGIN_MANIFEST.yaml` declares:
- Available plugins
- Plugin options (e.g., Python supports Ruff/Pylint/Flake8)
- Recommended defaults
- Status (stable/planned/community-requested)

## Design Philosophy

### 1. Don't Corrupt User Machine
Protect the user's system from pollution:
- **Use Poetry** for isolated virtual environments (Python)
- **Never use global pip installs** - all deps in project venv
- **Always use Make targets** - never direct python/pytest/ruff commands
- **All operations through isolated environment** (Poetry/pipenv/conda)
- Philosophy: User's machine should remain clean

### 2. Standalone First
Every plugin must work independently without requiring the orchestrator. This enables:
- Incremental adoption ("just add Python linting")
- Lower barrier to entry
- Reduced coupling
- Clear plugin boundaries

### 3. Composable
Plugins combine without conflicts:
- Isolated configurations
- Namespaced Make targets
- Non-overlapping file paths
- Clear dependency declarations

### 4. Extensible
Framework grows through community contributions:
- `_template/` directories for each plugin category
- Clear documentation (how-to-create-a-plugin.md)
- Low barrier to contribution
- Examples to follow (Python, TypeScript)

### 5. Production-Ready
Reference implementations are battle-tested:
- Extracted from [durable-code-test](https://github.com/steve-e-jackson/durable-code-test)
- Proven in production
- Comprehensive (not minimal examples)
- Best practices baked in

### 6. Agent-Friendly
Designed for AI agent consumption:
- Clear AGENT_INSTRUCTIONS.md format
- Structured metadata (YAML)
- Deterministic installation steps
- Resume capability via PROGRESS_TRACKER.md

## Source Material

All patterns extracted from **durable-code-test**:
- [.ai folder structure](https://github.com/steve-e-jackson/durable-code-test/tree/main/.ai)
- [Makefile patterns](https://github.com/steve-e-jackson/durable-code-test/blob/main/Makefile)
- [Docker setup](https://github.com/steve-e-jackson/durable-code-test/tree/main/.docker)
- [GitHub Actions](https://github.com/steve-e-jackson/durable-code-test/tree/main/.github/workflows)
- [Terraform workspaces](https://github.com/steve-e-jackson/durable-code-test/tree/main/infra/terraform)
- [Pre-commit hooks](https://github.com/steve-e-jackson/durable-code-test/blob/main/.pre-commit-config.yaml)
- [Standards documentation](https://github.com/steve-e-jackson/durable-code-test/tree/main/.ai/docs)

## Development Guidelines

### When Working on ai-projen Itself

1. **Follow Your Own Patterns**
   - ai-projen has a .ai folder (this folder)
   - Use file headers
   - Document everything
   - Dogfood the framework

2. **Maintain Plugin Independence**
   - Each plugin works standalone
   - No hidden dependencies
   - Clear prerequisite declarations
   - Test in isolation

3. **Update Manifest**
   - Add new plugins to PLUGIN_MANIFEST.yaml
   - Declare status (stable/planned)
   - Specify options and defaults
   - Document dependencies

4. **Create _templates**
   - Every plugin category has _template/
   - Templates show how to create new plugins
   - Keep templates current
   - Test template usage

5. **Document Extensibility**
   - how-to-create-a-plugin.md (master guide)
   - how-to-create-a-{category}-plugin.md (specific)
   - Real examples to follow
   - Contribution guidelines

### When Creating Plugins

1. **Start with _template/**
   - Copy appropriate category template
   - Fill in AGENT_INSTRUCTIONS.md
   - Add templates and configs
   - Test standalone installation

2. **Follow Patterns**
   - Look at existing plugins (Python, TypeScript)
   - Use same directory structure
   - Follow naming conventions
   - Match documentation style

3. **Test Thoroughly**
   - Standalone installation (no orchestrator)
   - Integration with other plugins
   - Resume capability
   - All three test repos

4. **Update Documentation**
   - Plugin README.md
   - AGENT_INSTRUCTIONS.md
   - PLUGIN_MANIFEST.yaml
   - Roadmap if needed

## Key Decisions

### Why Plugin-Based?
**Extensibility**. Easy to add new languages, clouds, tools without modifying core framework.

### Why Standalone-First?
**Flexibility**. Users can add capabilities incrementally instead of all-or-nothing.

### Why AGENT_INSTRUCTIONS.md?
**AI-Friendly**. Clear, structured instructions AI agents can follow reliably.

### Why Manifest-Driven?
**Discovery**. Single source of truth for available plugins and options.

### Why Extract from durable-code-test?
**Proven**. Patterns that work in production, not theoretical best practices.

### Why Not Code Generation?
**Complexity**. Too many edge cases. AI agents interpret instructions better than rigid scripts.

## Success Metrics

### Framework Quality
- [ ] All reference plugins work standalone
- [ ] Plugins compose without conflicts
- [ ] _templates are clear and usable
- [ ] Documentation is comprehensive
- [ ] New plugin creation takes <2 hours

### Adoption
- [ ] Framework used for new projects
- [ ] Community contributions (new plugins)
- [ ] GitHub stars/forks
- [ ] Issue resolution rate
- [ ] Plugin diversity (beyond initial set)

## Future Directions

### V1.0 Scope (Current)
- **Applications**: Python CLI, React + Python Full-Stack
- **Languages**: Python + TypeScript
- **Infrastructure**: Docker + GitHub Actions + Terraform/AWS
- **Standards**: Security + Documentation + Pre-commit

### Post-V1.0 (Community-Driven)
- Additional languages (Go, Rust, Java)
- Additional clouds (GCP, Azure)
- Additional IaC (Pulumi, CDK)
- SOLID principles linting
- Organizational standards templates

### Long-Term Vision
- Plugin marketplace/registry
- Automated plugin validation
- Multi-language linting harmonization
- Advanced orchestration features

## Maintenance Notes

### Regular Tasks
- Keep dependencies updated
- Sync patterns from durable-code-test
- Review community PRs
- Update documentation
- Test against new language/tool versions

### Breaking Changes
- Version plugins separately
- Maintain backwards compatibility in orchestrators
- Clear migration guides
- Deprecation warnings

### Community Health
- Respond to issues promptly
- Welcome new contributors
- Maintain code of conduct
- Celebrate contributions

---

**Remember**: This is the framework that creates AI-ready repositories. It should exemplify the patterns it teaches.
