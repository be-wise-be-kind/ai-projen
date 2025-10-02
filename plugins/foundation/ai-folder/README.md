# AI Folder Plugin

**Purpose**: Create the foundational .ai directory structure for AI-ready repositories

**Scope**: Universal plugin that every AI-ready repository needs

**Overview**: The ai-folder plugin creates a structured .ai directory that enables AI agents to navigate,
    understand, and work with your codebase effectively. This is the cornerstone of AI-ready repositories,
    providing organized documentation, templates, and navigation files.

**Dependencies**: Git repository

**Exports**: .ai/ directory with docs/, features/, howto/, templates/, index.yaml, and layout.yaml

**Related**: Foundation for all other ai-projen plugins

**Implementation**: Template-based installation with project-specific variable substitution

---

## What This Plugin Does

The ai-folder plugin creates a standardized `.ai/` directory structure that:

1. **Helps AI agents navigate** your codebase through structured metadata
2. **Documents project context** for AI understanding
3. **Provides templates** for common files and patterns
4. **Organizes how-to guides** for common tasks
5. **Tracks features** and their implementation status

## Why Every Project Needs This

AI coding assistants work best when they have:
- Clear project structure and organization
- Documented context and architecture
- Templates for common patterns
- Navigation metadata

The .ai folder provides all of this in a standardized format that any AI agent can understand.

## Directory Structure Created

```
.ai/
├── docs/                    # Project documentation
│   └── PROJECT_CONTEXT.md   # Main project context
├── features/                # Feature-specific docs
├── howto/                   # How-to guides
├── templates/               # Reusable templates
├── index.yaml              # Navigation index
└── layout.yaml             # Directory layout map
```

### What Each Directory Contains

#### `.ai/docs/`
Project documentation for AI understanding:
- `PROJECT_CONTEXT.md` - Overall project context and architecture
- Feature-specific documentation
- Technical design documents
- API documentation

#### `.ai/features/`
Feature-specific documentation:
- Implementation status
- Dependencies
- Related files
- Testing notes

#### `.ai/howto/`
How-to guides for common tasks:
- Setup instructions
- Development workflows
- Deployment procedures
- Troubleshooting guides

#### `.ai/templates/`
Reusable file templates:
- Code templates
- Documentation templates
- Configuration templates
- Boilerplate files

#### `index.yaml`
Navigation index providing:
- Project metadata
- Available commands
- Key files and locations
- Entry points

#### `layout.yaml`
Directory layout mapping:
- Source code location
- Test location
- Documentation location
- Build artifacts location

## Installation

### Standalone (Without Orchestrator)

An AI agent can install this plugin by following the instructions in [AGENT_INSTRUCTIONS.md](./AGENT_INSTRUCTIONS.md).

Quick summary:
1. Create `.ai/` directory structure
2. Copy and customize `index.yaml.template`
3. Copy and customize `layout.yaml.template`
4. Create initial `PROJECT_CONTEXT.md`
5. Validate YAML files

### With Orchestrator

When using `CREATE-NEW-AI-REPO.md` or `UPGRADE-TO-AI-REPO.md`, this plugin is automatically installed first as the foundation for all other plugins.

## What Gets Installed

After installation, you'll have:

```
.ai/
├── docs/
│   └── PROJECT_CONTEXT.md    # Project overview and architecture
├── features/                 # Empty initially
├── howto/                    # Empty initially
├── templates/                # Empty initially
├── index.yaml               # Project navigation metadata
└── layout.yaml              # Directory structure mapping
```

Other plugins will populate the empty directories with relevant content.

## Integration with Other Plugins

The ai-folder plugin is the foundation. Other plugins integrate by:

1. **Adding Documentation**
   - Language plugins add their docs to `.ai/docs/`
   - Infrastructure plugins document their setup
   - Standards plugins explain their requirements

2. **Adding How-Tos**
   - "How to run tests"
   - "How to deploy"
   - "How to add a new feature"

3. **Adding Templates**
   - Code file templates
   - Configuration templates
   - Documentation templates

4. **Updating Metadata**
   - Adding commands to `index.yaml`
   - Updating structure in `layout.yaml`
   - Registering new resources

## Benefits

### For AI Agents
- **Clear navigation** through structured metadata
- **Context understanding** via documentation
- **Pattern reuse** through templates
- **Consistent structure** across projects

### For Developers
- **Onboarding acceleration** with clear documentation
- **Pattern consistency** through templates
- **Knowledge retention** in structured docs
- **AI assistance** works better with clear structure

### For Teams
- **Standardization** across projects
- **Knowledge sharing** through documented patterns
- **Reduced setup time** for new projects
- **Better AI tooling** integration

## Examples

### Example index.yaml

```yaml
version: "1.0"
project:
  name: my-awesome-app
  type: full-stack
  purpose: E-commerce platform

commands:
  test: make test
  lint: make lint
  dev: make dev

key_files:
  readme: README.md
  makefile: Makefile
```

### Example layout.yaml

```yaml
version: "1.0"

directories:
  source: src/
  tests: tests/
  docs: docs/

ai_navigation:
  index: .ai/index.yaml
  docs: .ai/docs/
```

## Customization

You can customize the .ai folder by:
1. Adding more documentation to `.ai/docs/`
2. Creating how-to guides in `.ai/howto/`
3. Adding templates to `.ai/templates/`
4. Updating `index.yaml` with project-specific metadata
5. Updating `layout.yaml` with your directory structure

## Best Practices

1. **Keep PROJECT_CONTEXT.md updated** as the project evolves
2. **Document major features** in `.ai/features/`
3. **Create how-to guides** for complex tasks
4. **Use templates** for consistency
5. **Update index.yaml** when adding new commands
6. **Update layout.yaml** when restructuring directories

## Troubleshooting

### .ai folder already exists
If a `.ai` folder already exists:
- Check if it follows this structure
- Merge if compatible
- Replace if incompatible (backup first!)

### YAML files not parsing
Common YAML issues:
- Use spaces, not tabs for indentation
- Quote special characters
- Validate syntax with a YAML linter

### Integration issues
If other plugins don't see the .ai folder:
- Ensure it's in the repository root
- Check file permissions
- Validate YAML syntax

## Version History

- v1.0 - Initial release with core .ai folder structure

## Contributing

To improve this plugin:
1. Follow the template structure
2. Update AGENT_INSTRUCTIONS.md for changes
3. Test standalone installation
4. Update this README

## License

Part of ai-projen framework - MIT License
