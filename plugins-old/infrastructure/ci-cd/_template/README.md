# CI/CD Plugin Template

**Purpose**: Template for CI/CD platform plugins (GitLab CI, Jenkins, CircleCI, etc.)

**Use this template to**: Add support for CI/CD platforms beyond GitHub Actions

---

## How to Use This Template

1. Copy: `cp -r plugins/infrastructure/ci-cd/_template/ plugins/infrastructure/ci-cd/<platform>/`
2. Customize README.md and AGENT_INSTRUCTIONS.md
3. Add workflow/pipeline configuration templates
4. Provide Make targets for common CI operations
5. Update PLUGIN_MANIFEST.yaml

## What to Include

- ✅ Workflow/pipeline configuration files
- ✅ Lint, test, build, deploy jobs
- ✅ Matrix builds (multiple versions/platforms)
- ✅ Caching strategies
- ✅ Secret management patterns
- ✅ Badge generation for README

## Integration

- Extend agents.md with CI/CD commands
- Detect existing language plugins and add appropriate jobs
- Provide local testing commands where possible

See `plugins/infrastructure/ci-cd/github-actions/` for reference.
