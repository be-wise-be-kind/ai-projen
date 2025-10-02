# How-Tos for {{LANGUAGE_NAME}} Plugin

This directory contains step-by-step guides for common tasks using the {{LANGUAGE_NAME}} plugin.

## About This Directory

How-to guides provide AI agents and developers with procedural knowledge for accomplishing
specific tasks. Each guide is self-contained with prerequisites, steps, verification, and
troubleshooting.

## Available How-Tos

### Getting Started (Beginner)
- [how-to-setup-development-environment.md](how-to-setup-development-environment.md) - Initial setup and configuration
- [how-to-run-tests.md](how-to-run-tests.md) - Execute unit tests and view results
- [how-to-run-linting.md](how-to-run-linting.md) - Code quality checks and formatting

### Common Development Tasks (Intermediate)
- [how-to-create-new-module.md](how-to-create-new-module.md) - Create a new code module with tests
- [how-to-add-dependency.md](how-to-add-dependency.md) - Add and manage package dependencies
- [how-to-write-unit-tests.md](how-to-write-unit-tests.md) - Write comprehensive test coverage

### Advanced Workflows (Advanced)
- [how-to-implement-custom-linter.md](how-to-implement-custom-linter.md) - Create custom linting rules
- [how-to-optimize-performance.md](how-to-optimize-performance.md) - Profile and optimize code
- [how-to-setup-ci-cd.md](how-to-setup-ci-cd.md) - Configure continuous integration

> **Note**: Replace the above examples with actual how-tos specific to your language plugin.
> Organize by difficulty level or by topic area depending on your plugin's needs.

## Organization

This plugin organizes how-tos by **difficulty level**:
- **Beginner**: Basic tasks, minimal prerequisites, single focus
- **Intermediate**: Common workflows, requires framework understanding
- **Advanced**: Complex integrations, multiple systems, architectural decisions

Alternative organizations (choose what fits best):
- **By Topic**: Group by feature area (testing, deployment, configuration, etc.)
- **By Use Case**: Group by user goals (getting started, daily development, optimization, etc.)
- **Flat**: Single directory for plugins with few how-tos

## Using How-Tos

### For AI Agents
1. Identify the task you need to accomplish
2. Find the matching how-to guide
3. Verify prerequisites are met
4. Follow steps sequentially
5. Execute verification commands
6. Consult common issues if problems occur

### For Human Developers
1. Browse available guides in this README
2. Read the overview to confirm it matches your need
3. Check prerequisites before starting
4. Follow the guide step-by-step
5. Use the checklist to track progress

## Template Integration

Many how-tos reference templates from the `../templates/` directory:

```bash
# Copy a template
cp plugins/languages/{{LANGUAGE_NAME}}/templates/{{TEMPLATE_NAME}}.template path/to/destination

# Or if plugin is installed in a project
cp .ai/plugins/{{LANGUAGE_NAME}}/templates/{{TEMPLATE_NAME}}.template path/to/destination
```

See individual how-tos for specific template usage instructions.

## Related Resources

- **Plugin Documentation**: [../README.md](../README.md)
- **Agent Instructions**: [../AGENT_INSTRUCTIONS.md](../AGENT_INSTRUCTIONS.md)
- **Templates**: [../templates/](../templates/)
- **Standards**: [../standards/](../standards/)
- **How-To Template**: [HOWTO_TEMPLATE.md](HOWTO_TEMPLATE.md)
- **How-To Standards**: `.ai/docs/HOWTO_STANDARDS.md` (in ai-projen root)

## Contributing New How-Tos

When adding a new how-to guide:

### 1. Use the Template
Copy and customize `HOWTO_TEMPLATE.md`:
```bash
cp howtos/HOWTO_TEMPLATE.md howtos/how-to-your-new-task.md
```

### 2. Follow Standards
Ensure your how-to meets the requirements in `.ai/docs/HOWTO_STANDARDS.md`:
- Complete metadata block
- All required sections
- Tested, runnable code examples
- Clear verification steps
- Troubleshooting for common issues

### 3. Test Thoroughly
- Follow your own guide from scratch
- Test on a clean environment
- Verify all commands work
- Confirm estimated time is accurate
- Test verification steps

### 4. Update This README
Add your how-to to the appropriate section above:
- Choose correct difficulty level
- Write concise, clear description
- Use consistent formatting

### 5. Reference Templates
If your how-to uses templates:
- Document which templates are used
- Show how to copy and customize them
- List all template placeholders
- Provide before/after examples

## Quality Guidelines

Every how-to in this directory should:
- ✅ Be written for AI agents as primary audience
- ✅ Use imperative mood ("Create a file" not "You should create")
- ✅ Include complete, runnable code examples (no pseudo-code)
- ✅ Show explicit file paths and locations
- ✅ Provide verification steps with expected outputs
- ✅ Document common issues and solutions
- ✅ Reference related how-tos and documentation
- ✅ Be tested on a clean environment

## Maintenance

### Regular Updates
- Review after template changes
- Update when project structure evolves
- Add newly discovered common issues
- Revise when better approaches are found

### Deprecation
If a how-to becomes obsolete:
1. Add deprecation notice at the top
2. Link to replacement guide
3. Keep for reference period
4. Mark as deprecated in this README

## Difficulty Levels Explained

### Beginner
- **Prerequisites**: Minimal (plugin installed, basic tool knowledge)
- **Steps**: 3-5 simple, sequential steps
- **Integration**: Self-contained, minimal external dependencies
- **Time**: 5-15 minutes
- **Examples**: Run tests, format code, create basic file

### Intermediate
- **Prerequisites**: Framework understanding, related plugins may be needed
- **Steps**: 5-10 steps with some decision points
- **Integration**: Connects with existing systems
- **Time**: 15-45 minutes
- **Examples**: Create API endpoint, add database model, implement feature

### Advanced
- **Prerequisites**: Deep framework knowledge, multiple plugins, architectural understanding
- **Steps**: 10+ steps, complex decision trees
- **Integration**: Multi-system, potential architectural changes
- **Time**: 45+ minutes
- **Examples**: Custom linter, performance optimization, complex integration

## Quick Reference

### Finding the Right How-To

**I want to...**
- Setup my environment → [how-to-setup-development-environment.md]
- Run tests → [how-to-run-tests.md]
- Check code quality → [how-to-run-linting.md]
- Create new code → [how-to-create-new-module.md]
- Add a package → [how-to-add-dependency.md]
- Write tests → [how-to-write-unit-tests.md]

**I need to understand...**
- What templates are available → [../templates/README.md](../templates/)
- Plugin standards → [../standards/](../standards/)
- How to use this plugin → [../AGENT_INSTRUCTIONS.md](../AGENT_INSTRUCTIONS.md)

---

**Last Updated**: {{UPDATE_DATE}}
**Plugin Version**: {{PLUGIN_VERSION}}
**Maintained By**: {{PLUGIN_MAINTAINER}}
