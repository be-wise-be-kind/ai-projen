# How-Tos for {{PLUGIN_NAME}} Plugin

This directory contains step-by-step guides for common tasks using the {{PLUGIN_NAME}} plugin.

## About This Directory

How-to guides provide AI agents and developers with procedural knowledge for accomplishing
specific tasks. Each guide is self-contained with prerequisites, steps, verification, and
troubleshooting.

## Available How-Tos

### Getting Started (Beginner)
- [how-to-setup-{{PLUGIN_TYPE}}.md](how-to-setup-{{PLUGIN_TYPE}}.md) - Initial setup and configuration
- [how-to-validate-configuration.md](how-to-validate-configuration.md) - Verify configuration is correct

### Common Tasks (Intermediate)
- [how-to-add-{{WORKFLOW_OR_PIPELINE}}.md](how-to-add-{{WORKFLOW_OR_PIPELINE}}.md) - Add new workflow/pipeline
- [how-to-customize-{{FEATURE}}.md](how-to-customize-{{FEATURE}}.md) - Customize for specific needs

### Advanced Workflows (Advanced)
- [how-to-implement-{{ADVANCED_FEATURE}}.md](how-to-implement-{{ADVANCED_FEATURE}}.md) - Complex integration
- [how-to-optimize-{{ASPECT}}.md](how-to-optimize-{{ASPECT}}.md) - Performance optimization

> **Note**: Replace the above examples with actual how-tos specific to your plugin.

## Organization

This plugin organizes how-tos by **difficulty level**:
- **Beginner**: Basic tasks, minimal prerequisites, single focus
- **Intermediate**: Common workflows, requires framework understanding
- **Advanced**: Complex integrations, multiple systems, architectural decisions

Alternative organizations (choose what fits best):
- **By Topic**: Group by feature area (setup, deployment, monitoring, etc.)
- **By Use Case**: Group by user goals (getting started, maintenance, scaling, etc.)
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
cp plugins/{{PLUGIN_CATEGORY}}/{{PLUGIN_NAME}}/templates/{{TEMPLATE_NAME}}.template path/to/destination

# Or if plugin is installed in a project
cp .ai/plugins/{{PLUGIN_NAME}}/templates/{{TEMPLATE_NAME}}.template path/to/destination
```

See individual how-tos for specific template usage instructions.

## Related Resources

- **Plugin Documentation**: [../README.md](../README.md)
- **Agent Instructions**: [../AGENT_INSTRUCTIONS.md](../AGENT_INSTRUCTIONS.md)
- **Templates**: [../templates/](../templates/)
- **Configuration Examples**: [../configs/](../configs/)
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
- Tested, runnable examples
- Clear verification steps
- Troubleshooting for common issues

### 3. Test Thoroughly
- Follow your own guide from scratch
- Test on a clean environment
- Verify all commands work
- Confirm estimated time is accurate
- Test verification steps

### 4. Update This README
Add your how-to to the appropriate section above.

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
- ✅ Include complete, runnable examples (no pseudo-code)
- ✅ Show explicit file paths and locations
- ✅ Provide verification steps with expected outputs
- ✅ Document common issues and solutions
- ✅ Reference related how-tos and documentation
- ✅ Be tested on a clean environment

## Quick Reference

### Finding the Right How-To

**I want to...**
- Setup {{PLUGIN_TYPE}} → [how-to-setup-{{PLUGIN_TYPE}}.md]
- Validate configuration → [how-to-validate-configuration.md]
- Add new {{WORKFLOW}} → [how-to-add-{{WORKFLOW}}.md]
- Customize {{FEATURE}} → [how-to-customize-{{FEATURE}}.md]

**I need to understand...**
- What templates are available → [../templates/README.md](../templates/)
- Plugin configuration → [../configs/](../configs/)
- How to use this plugin → [../AGENT_INSTRUCTIONS.md](../AGENT_INSTRUCTIONS.md)

---

**Last Updated**: {{UPDATE_DATE}}
**Plugin Version**: {{PLUGIN_VERSION}}
**Maintained By**: {{PLUGIN_MAINTAINER}}
