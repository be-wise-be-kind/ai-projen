# ai-projen

A plugin-based framework for creating AI-ready repositories.

## What is ai-projen?

**ai-projen** transforms empty directories into production-ready, AI-assisted development environments through composable, standalone plugins. Inspired by patterns proven in [durable-code-test](https://github.com/steve-e-jackson/durable-code-test), it provides a framework for building repositories that work seamlessly with AI coding assistants.

## Quick Start

Point an AI agent to `CREATE-NEW-AI-REPO.md` and answer a few questions. In under 30 minutes, you'll have a complete development environment with:

- ✅ **Structured .ai folder** for AI agent navigation
- ✅ **Language tooling** (Python, TypeScript, or both)
- ✅ **Docker containerization** for consistent environments
- ✅ **GitHub Actions CI/CD** for automated workflows
- ✅ **Terraform/AWS infrastructure** for cloud deployment
- ✅ **Security & documentation standards** enforced via linting
- ✅ **Pre-commit hooks** for quality gates

## Features

### Production-Ready Plugins (v1.0)
- **Languages**: Python (Ruff/Black/pytest), TypeScript (ESLint/Prettier/Vitest)
- **Infrastructure**: Docker, GitHub Actions CI/CD, Terraform/AWS
- **Standards**: Security, Documentation, Pre-commit Hooks
- **Foundation**: AI folder structure (universal for all projects)

### Plugin Architecture
Everything is a plugin. Each plugin:
- Works **standalone** (no orchestrator required)
- Is **composable** (combines without conflicts)
- Has clear **AGENT_INSTRUCTIONS.md** for AI agents
- Includes **templates** and **configurations**

### Three Usage Modes

1. **CREATE-NEW-AI-REPO.md** - Build new repository from scratch
2. **UPGRADE-TO-AI-REPO.md** - Add AI patterns to existing repository
3. **ADD-CAPABILITY.md** - Add single plugin incrementally

## Architecture

```
ai-projen/
├── CREATE-NEW-AI-REPO.md          # Orchestrator for new repos
├── UPGRADE-TO-AI-REPO.md          # Orchestrator for existing repos
├── ADD-CAPABILITY.md              # Add single capability
└── plugins/                       # Plugin library
    ├── foundation/                # Universal (always required)
    │   └── ai-folder/
    ├── languages/                 # Language-specific tooling
    │   ├── python/
    │   ├── typescript/
    │   └── _template/             # Template for new languages
    ├── infrastructure/            # Deployment & tooling
    │   ├── containerization/
    │   ├── ci-cd/
    │   └── iac/
    └── standards/                 # Quality & standards
        ├── security/
        ├── documentation/
        └── pre-commit-hooks/
```

## How It Works

### Discovery & Planning
```
Agent asks questions → Generates custom roadmap → Creates PROGRESS_TRACKER.md
```

### Plugin Installation
```
Foundation (always) → Languages → Infrastructure → Standards → Integration
```

### Resume Capability
```
Read PROGRESS_TRACKER.md → Continue from last completed PR
```

## Example: Full-Stack App

```bash
# User points AI agent to CREATE-NEW-AI-REPO.md

Agent: "What languages?"
User: "Python and TypeScript"

Agent: "Need Docker?"
User: "Yes"

Agent: "Need cloud deployment?"
User: "Yes, AWS with Terraform"

Agent: "Apply standards?"
User: "Yes, all of them"

# Agent generates custom roadmap with 10 PRs
# Agent executes each PR sequentially
# Result: Production-ready full-stack repo in <30 minutes
```

## Documentation

- **Architecture**: See [.ai/docs/PLUGIN_ARCHITECTURE.md](.ai/docs/PLUGIN_ARCHITECTURE.md)
- **Plugin Discovery**: See [.ai/docs/PLUGIN_DISCOVERY.md](.ai/docs/PLUGIN_DISCOVERY.md)
- **How-tos**: See [.ai/howto/](.ai/howto/)
- **Roadmap**: See [roadmap/](roadmap/)

## Extending the Framework

Want to add support for a new language, cloud provider, or tool?

1. Copy the appropriate `_template/` directory
2. Fill in the AGENT_INSTRUCTIONS.md
3. Add templates and configurations
4. Update PLUGIN_MANIFEST.yaml
5. Test standalone installation
6. Submit PR

See [.ai/howto/how-to-create-a-plugin.md](.ai/howto/how-to-create-a-plugin.md) for details.

## Philosophy

1. **Framework Over Library** - We build the engine, not every plugin
2. **Standalone First** - Every plugin works independently
3. **Composable** - Plugins combine without conflicts
4. **Extensible** - Clear path to add new plugins
5. **Production-Ready** - Reference implementations are battle-tested
6. **Agent-Friendly** - Designed for AI agent consumption

## Contributing

Contributions are welcome! To add a new plugin:
1. Copy the appropriate `_template/` directory from `plugins/`
2. Follow the template README instructions
3. Test your plugin standalone
4. Submit a pull request

See plugin templates in `plugins/` for detailed guidance.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Acknowledgments

Built on patterns proven in [durable-code-test](https://github.com/steve-e-jackson/durable-code-test), a production full-stack application demonstrating AI-ready development practices.

---

**Remember**: We're building the engine, not populating every possible plugin. Focus on excellent reference implementations and clear extensibility.
