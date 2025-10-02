# Pre-commit Hooks How-to Guides

**Purpose**: Index of practical guides for installing, configuring, and troubleshooting pre-commit hooks

**Scope**: Step-by-step instructions for common pre-commit hook tasks and workflows

**Overview**: This directory contains practical how-to guides for working with pre-commit hooks in Docker-first
    development environments. Covers installation, custom hook creation, and debugging common issues. Each
    guide provides step-by-step instructions with examples, testing procedures, and troubleshooting tips.
    Guides are organized by difficulty level and common use cases.

**Dependencies**: Pre-commit framework, Docker, Docker Compose, project-specific linting tools

**Exports**: Comprehensive how-to documentation for pre-commit hooks workflows

**Related**: ../standards/PRE_COMMIT_STANDARDS.md, ../../README.md, ../../AGENT_INSTRUCTIONS.md

**Implementation**: Collection of task-focused guides with practical examples

---

## Available Guides

### Beginner

#### [How to: Install Pre-commit Hooks](how-to-install-pre-commit.md)
**Difficulty**: Beginner
**Time**: 15-20 minutes
**Prerequisites**: Git repository, Docker running

Install and configure the pre-commit framework with Docker integration. Covers:
- Prerequisites verification
- Framework installation
- Configuration copying
- Git hooks installation
- Container setup
- Testing and validation

**When to use**: First-time setup of pre-commit hooks in a project.

---

### Intermediate

#### [How to: Add a Custom Hook](how-to-add-custom-hook.md)
**Difficulty**: Intermediate
**Time**: 30-45 minutes
**Prerequisites**: Pre-commit installed, basic shell scripting

Create custom pre-commit hooks for project-specific validation. Covers:
- Understanding hook structure
- Writing validation scripts
- Docker integration
- File filtering
- Error handling
- Testing custom hooks

**When to use**: Need project-specific validation rules not covered by standard linters.

**Examples included**:
- Check for TODO comments
- Enforce file naming conventions
- Require documentation headers
- Check for hardcoded secrets
- Docker-integrated validation

---

#### [How to: Debug Failing Hooks](how-to-debug-failing-hooks.md)
**Difficulty**: Intermediate
**Time**: 20-30 minutes
**Prerequisites**: Pre-commit installed, Docker running

Troubleshoot and fix pre-commit hook failures. Covers:
- Understanding hook output
- Systematic debugging workflow
- Common issues and solutions
- Docker container troubleshooting
- Advanced debugging techniques
- When to skip hooks

**When to use**: Hooks are failing and you need to diagnose the issue.

**Common issues covered**:
- Docker container not found
- Command not found
- Permission denied
- Hook times out
- Branch protection not working
- Auto-fix not working

---

## Quick Reference

### Installation
```bash
# Install pre-commit framework
pip install pre-commit

# Copy configuration
cp plugins/standards/pre-commit-hooks/ai-content/templates/.pre-commit-config.yaml.template .pre-commit-config.yaml

# Install hooks
pre-commit install
pre-commit install --hook-type pre-push
```

### Usage
```bash
# Run all hooks
pre-commit run --all-files

# Run specific hook
pre-commit run <hook-id> --all-files

# Skip pre-commit (emergency only)
git commit --no-verify -m "Emergency fix"

# Skip pre-push (emergency only)
PRE_PUSH_SKIP=1 git push
```

### Debugging
```bash
# Run with verbose output
pre-commit run <hook-id> --verbose --all-files

# Check Docker containers
docker ps | grep linter

# Test in container
docker exec <container> <command>

# Clear cache
pre-commit clean
```

---

## Guide Selection

### I want to...

**Install pre-commit hooks**
→ [How to: Install Pre-commit Hooks](how-to-install-pre-commit.md)

**Add a custom validation rule**
→ [How to: Add a Custom Hook](how-to-add-custom-hook.md)

**Fix a failing hook**
→ [How to: Debug Failing Hooks](how-to-debug-failing-hooks.md)

**Understand pre-commit standards**
→ [Pre-commit Standards](../standards/PRE_COMMIT_STANDARDS.md)

**Configure for my project**
→ [Agent Instructions](../../AGENT_INSTRUCTIONS.md)

---

## Learning Path

### For New Users

1. **Start here**: [How to: Install Pre-commit Hooks](how-to-install-pre-commit.md)
   - Learn installation process
   - Understand basic concepts
   - Test workflow

2. **Then**: [Pre-commit Standards](../standards/PRE_COMMIT_STANDARDS.md)
   - Understand standards and best practices
   - Learn about hook stages
   - Review integration patterns

3. **When needed**: [How to: Debug Failing Hooks](how-to-debug-failing-hooks.md)
   - Troubleshoot issues
   - Learn debugging techniques
   - Fix common problems

4. **Advanced**: [How to: Add a Custom Hook](how-to-add-custom-hook.md)
   - Create project-specific hooks
   - Understand hook design patterns
   - Integrate with Docker

### For Experienced Users

1. **Review**: [Pre-commit Standards](../standards/PRE_COMMIT_STANDARDS.md)
   - Refresh on best practices
   - Check for new patterns

2. **Extend**: [How to: Add a Custom Hook](how-to-add-custom-hook.md)
   - Add custom validation
   - Share patterns with team

3. **Optimize**: [How to: Debug Failing Hooks](how-to-debug-failing-hooks.md)
   - Improve hook performance
   - Advanced debugging techniques

---

## Common Tasks

### Initial Setup
1. Read [Installation guide](how-to-install-pre-commit.md)
2. Install framework and hooks
3. Test on existing codebase
4. Document project-specific configuration

### Adding Custom Validation
1. Identify validation need
2. Read [Custom hook guide](how-to-add-custom-hook.md)
3. Write validation script
4. Test thoroughly
5. Document for team

### Troubleshooting
1. Identify failing hook
2. Read [Debug guide](how-to-debug-failing-hooks.md)
3. Follow debugging workflow
4. Fix issue
5. Document solution

### Team Onboarding
1. Share [Installation guide](how-to-install-pre-commit.md)
2. Review [Standards document](../standards/PRE_COMMIT_STANDARDS.md)
3. Demonstrate workflow
4. Provide [Debug guide](how-to-debug-failing-hooks.md) as reference

---

## Best Practices

### For All Users

1. **Read before acting**: Review relevant guide completely before starting
2. **Test incrementally**: Test each step as you go
3. **Document changes**: Note customizations for your project
4. **Share knowledge**: Help team members with same issues

### For Teams

1. **Standardize configuration**: Use same `.pre-commit-config.yaml` across team
2. **Document custom hooks**: Explain purpose and usage
3. **Share debugging tips**: Document solutions to common issues
4. **Update regularly**: Keep hooks and framework up to date

### For Projects

1. **Version control**: Commit `.pre-commit-config.yaml` changes
2. **CI/CD integration**: Run same hooks in continuous integration
3. **Documentation**: Keep guides updated with project changes
4. **Regular review**: Audit hooks periodically for relevance

---

## Related Documentation

### Plugin Documentation
- **README**: [../../README.md](../../README.md) - Plugin overview and features
- **Agent Instructions**: [../../AGENT_INSTRUCTIONS.md](../../AGENT_INSTRUCTIONS.md) - AI agent installation guide
- **Manifest**: [../../manifest.yaml](../../manifest.yaml) - Plugin metadata

### Standards
- **Pre-commit Standards**: [../standards/PRE_COMMIT_STANDARDS.md](../standards/PRE_COMMIT_STANDARDS.md) - Comprehensive standards document

### Templates
- **Configuration Template**: [../templates/.pre-commit-config.yaml.template](../templates/.pre-commit-config.yaml.template) - Base configuration

---

## External Resources

### Pre-commit Framework
- **Official Documentation**: https://pre-commit.com/
- **Hooks Repository**: https://github.com/pre-commit/pre-commit-hooks
- **Plugin Development**: https://pre-commit.com/#creating-new-hooks

### Git Hooks
- **Git Hooks Documentation**: https://git-scm.com/docs/githooks
- **Git Book**: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks

### Docker
- **Docker Documentation**: https://docs.docker.com/
- **Docker Compose**: https://docs.docker.com/compose/

---

## Contributing

### Adding New Guides

When creating new how-to guides:

1. **Use template structure**:
   - Purpose, Scope, Overview header
   - Prerequisites section
   - Step-by-step instructions
   - Testing procedures
   - Troubleshooting section
   - Summary and next steps

2. **Follow naming convention**:
   - `how-to-<action>-<subject>.md`
   - Example: `how-to-configure-python-hooks.md`

3. **Include examples**:
   - Code samples
   - Command outputs
   - Common scenarios

4. **Test thoroughly**:
   - Verify all steps work
   - Test on clean environment
   - Check for missing prerequisites

5. **Update this README**:
   - Add to Available Guides section
   - Update Quick Reference if needed
   - Add to Guide Selection

---

## Support

### Getting Help

1. **Check documentation**: Review relevant guide thoroughly
2. **Search for similar issues**: Check troubleshooting sections
3. **Gather information**: Collect error messages, configurations, versions
4. **Ask team**: Someone may have encountered same issue
5. **Review standards**: Ensure following best practices

### Providing Feedback

- **Report issues**: Note errors or missing information
- **Suggest improvements**: Share ideas for better guides
- **Contribute fixes**: Submit corrections or enhancements
- **Share success**: Document working solutions for others

---

## Summary

This directory provides comprehensive how-to guides for:

- ✅ **Installing** pre-commit hooks with Docker
- ✅ **Creating** custom validation hooks
- ✅ **Debugging** hook failures systematically
- ✅ **Understanding** best practices and patterns
- ✅ **Integrating** with team workflows

Each guide is:
- **Task-focused**: Solves specific problems
- **Step-by-step**: Clear instructions with examples
- **Tested**: Verified procedures that work
- **Complete**: Prerequisites, steps, testing, troubleshooting

Choose the guide that matches your task and follow the instructions. All guides assume Docker-first development patterns with pre-commit framework.
