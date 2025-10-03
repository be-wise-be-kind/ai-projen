# ai-projen

A plugin-based framework for creating AI-ready repositories.

## What is ai-projen?

**ai-projen** is a framework that transforms empty directories into production-ready, AI-assisted development environments through composable, standalone plugins. It provides a systematic approach to building repositories that work seamlessly with AI coding assistants while following industry best practices.

**AI-Ready Definition**: A repository where AI agents can be trusted to generate code that is well-written, durable, scalable, performant, secure, and follows industry best practices.

Inspired by patterns proven in production applications like [durable-code-test](https://github.com/steve-e-jackson/durable-code-test), ai-projen extracts battle-tested configurations and workflows into reusable plugins that can be composed to match your specific needs.

## Quick Start

### For AI Agents

If you're an AI agent helping a user work with ai-projen, start by reading **[AGENTS.md](AGENTS.md)**. This document provides complete instructions for understanding user intent, routing to the appropriate workflow, and executing installations correctly.

### For Human Developers

**Prerequisites:**
Ensure your AI agent honors `AGENTS.md` files. Most AI coding assistants (Claude, GitHub Copilot, etc.) automatically read AGENTS.md. If yours doesn't, configure it to check for this file first.

**Then simply ask your AI agent:**

- "Create a new AI-ready Python API project"
- "Upgrade this repository to be AI-ready"
- "Add Docker containerization to my project"
- "Setup environment variable handling for this repo"
- "Add CI/CD with GitHub Actions"

Your AI agent will read `AGENTS.md`, understand your intent, route to the appropriate workflow, and execute the installation. You just answer questions and approve changes.

## Core Concepts

### What Makes a Repository AI-Ready?

An AI-ready repository includes:

- **Structured documentation** - Clear `.ai/` folder with how-to guides, standards, and templates that AI agents can navigate
- **Language tooling** - Linting, formatting, type checking, and testing frameworks properly configured
- **Immediate feedback loops** - Quick validation through logging, errors, monitoring, and near-instant quality gate execution
- **Development consistency** - Containerization for reproducible environments across machines
- **Automation** - CI/CD pipelines for automated testing, building, and deployment
- **Infrastructure as code** - Declarative cloud infrastructure for consistent deployments
- **Quality gates** - Security scanning, documentation standards, and pre-commit hooks
- **Clear patterns** - Established conventions that AI agents can follow reliably

### Plugin Architecture

Everything in ai-projen is a plugin. Each plugin:

- **Works standalone** - No orchestrator required, can be installed independently
- **Is composable** - Combines with other plugins without conflicts
- **Has clear instructions** - Includes `AGENT_INSTRUCTIONS.md` for AI agents and `README.md` for humans
- **Provides templates** - Contains configuration files, code templates, and examples
- **Declares dependencies** - Explicitly states prerequisites and integration points

This design enables both complete, opinionated setups and granular, incremental adoption.

## How It Works

### High-Level Flow

1. **Discovery** - User expresses need → Framework identifies relevant plugins
2. **Planning** - Framework generates installation roadmap based on selections
3. **Installation** - Plugins are installed sequentially with dependency resolution
4. **Validation** - Each plugin verifies successful installation
5. **Integration** - Plugins integrate via Makefiles, CI/CD workflows, and shared configurations

### Three Interaction Modes

ai-projen supports three approaches to repository setup:

1. **Create New Repository** - Start from an empty directory and build a complete environment
2. **Upgrade Existing Repository** - Add AI-ready patterns to your current codebase safely
3. **Add Capability** - Install individual plugins to add specific functionality

All three modes use the same underlying plugin system, giving you flexibility in how you adopt the framework.

## Plugin Categories

ai-projen organizes plugins into logical categories:

### Foundation
Universal plugins required by all AI-ready repositories. These provide the structural foundation for AI agent navigation and documentation.

### Languages
Language-specific development environments including linting, formatting, type checking, testing frameworks, and build tooling. Support for multiple languages in a single repository.

### Infrastructure
Deployment and runtime tooling including containerization platforms, CI/CD systems, and infrastructure-as-code tools for cloud deployment.

### Standards
Cross-cutting quality and governance plugins including security scanning, documentation standards, and pre-commit hooks for quality gates.

### Applications
Complete, opinionated application types that compose multiple plugins into functional starter applications. Examples include CLI tools and full-stack web applications.

### Repository
Repository-level configuration and tooling such as environment variable management and development environment setup.

**For available plugins, consult:** `plugins/PLUGIN_MANIFEST.yaml`

This manifest is the source of truth for plugin status (stable/planned), available options, recommended defaults, and dependencies.

## Philosophy

ai-projen is built on these core principles:

### 1. Framework Over Library
We build the engine for creating AI-ready repositories, not an exhaustive collection of every possible configuration. The focus is on excellent reference implementations and clear extensibility patterns that enable community contributions.

### 2. Standalone First
Every plugin works independently without requiring orchestration. This enables incremental adoption, reduces coupling, and lowers the barrier to entry.

### 3. Composable by Design
Plugins combine without conflicts through isolated configurations, namespaced build targets, non-overlapping file paths, and explicit dependency declarations.

### 4. Extensible Through Templates
The framework grows organically through community contributions. Each plugin category includes `_template/` directories showing how to create new plugins with comprehensive documentation.

### 5. Production-Ready Patterns
Reference implementations are extracted from battle-tested production applications, not theoretical best practices. Configurations are comprehensive and opinionated, reflecting real-world usage.

### 6. Agent-Friendly Design
Built specifically for AI agent consumption with structured metadata, deterministic installation steps, clear success criteria, and resume capability for long-running operations.

### 7. Protect the User's Machine
All tooling runs in isolated environments (Poetry virtual environments, Docker containers) to prevent system pollution. No global package installations that could conflict with other projects.

## Getting Started

### Understanding the System

**For AI Agents:**
- Start with [AGENTS.md](AGENTS.md)
- Understand routing between "Repository Assistant" and "Framework Developer" modes
- Follow structured workflows in `.ai/howto/` guides

**For Human Developers:**
- Read [.ai/docs/PROJECT_CONTEXT.md](.ai/docs/PROJECT_CONTEXT.md) for architecture overview
- Review [.ai/docs/PLUGIN_ARCHITECTURE.md](.ai/docs/PLUGIN_ARCHITECTURE.md) for technical details
- Explore [plugins/PLUGIN_MANIFEST.yaml](plugins/PLUGIN_MANIFEST.yaml) for available capabilities

### Common Workflows

**Quick Application Setup:**
Install complete application types for common use cases:
- Python CLI tools: `plugins/applications/python-cli/AGENT_INSTRUCTIONS.md`
- Full-stack web apps: `plugins/applications/react-python-fullstack/AGENT_INSTRUCTIONS.md`

**Custom Repository:**
Build exactly what you need by selecting individual plugins from each category based on your requirements.

**Incremental Enhancement:**
Add capabilities to existing repositories one plugin at a time without disrupting current functionality.

## Extending the Framework

Want to add support for a new language, cloud provider, tool, or application type?

**Simply ask your AI agent:**

- "Let's create a new Go language plugin with linting and testing"
- "Help me build a Rust plugin for ai-projen"
- "Create an Azure infrastructure plugin"
- "Add support for GitLab CI/CD"
- "Build a plugin for pre-commit hooks"

Your AI agent will read the plugin creation guides, use the appropriate template, walk you through the structure, and help you test it. You just provide the specifics and approve the implementation.

### Plugin Creation Guides

- **Languages**: `.ai/howto/how-to-create-a-language-plugin.md`
- **Infrastructure**: `.ai/howto/how-to-create-an-infrastructure-plugin.md`
- **Standards**: `.ai/docs/how-to-create-a-standards-plugin.md`
- **Applications**: `.ai/docs/how-to-create-a-common-application.md`

Each guide provides detailed instructions, examples from existing plugins, and best practices for that plugin category.

## Documentation

### Essential Guides
- **[.ai/index.yaml](.ai/index.yaml)** - Complete repository navigation map
- **[.ai/docs/PROJECT_CONTEXT.md](.ai/docs/PROJECT_CONTEXT.md)** - Framework architecture and philosophy
- **[.ai/docs/PLUGIN_ARCHITECTURE.md](.ai/docs/PLUGIN_ARCHITECTURE.md)** - Technical plugin specifications

### How-To Guides
- **[.ai/howto/how-to-create-new-ai-repo.md](.ai/howto/how-to-create-new-ai-repo.md)** - Create new repository from scratch
- **[.ai/howto/how-to-upgrade-to-ai-repo.md](.ai/howto/how-to-upgrade-to-ai-repo.md)** - Upgrade existing repository
- **[.ai/howto/how-to-add-capability.md](.ai/howto/how-to-add-capability.md)** - Add individual capabilities
- **[.ai/howto/how-to-discover-and-install-plugins.md](.ai/howto/how-to-discover-and-install-plugins.md)** - Plugin discovery workflow

### Plugin Documentation
Each plugin includes:
- `AGENT_INSTRUCTIONS.md` - Installation instructions for AI agents
- `README.md` - Human-readable overview and features

### Roadmap
- **[roadmap/](roadmap/)** - Framework development roadmap and progress tracking

## Contributing

Contributions are welcome! The framework is designed to grow through community additions.

### How to Contribute

**Adding a Plugin:**
1. Copy the appropriate `_template/` directory from the relevant plugin category
2. Follow the template's README and fill in all required sections
3. Test your plugin's standalone installation in a fresh repository
4. Ensure it follows the patterns established by existing plugins
5. Submit a pull request with clear description of the plugin's purpose

**Improving Documentation:**
Documentation updates are valuable contributions. Follow the standards in `.ai/docs/FILE_HEADER_STANDARDS.md` and `.ai/docs/HOWTO_STANDARDS.md`.

**Reporting Issues:**
If you encounter problems or have feature requests, please open an issue with detailed reproduction steps or use case description.

## Acknowledgments

Built on patterns proven in [durable-code-test](https://github.com/steve-e-jackson/durable-code-test), a production full-stack application demonstrating AI-ready development practices in real-world use.

---

**Remember**: We're building the engine for AI-ready repositories, not populating every possible plugin. Focus on excellent reference implementations, clear extensibility, and letting the framework grow organically through community contributions.
