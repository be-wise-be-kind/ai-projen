# Standards Plugin Template

**Purpose**: Template for creating new standards/quality plugins

**Use this template to**: Add new quality standards (accessibility, performance, SOLID principles, etc.)

---

## How to Use This Template

1. Copy: `cp -r plugins/standards/_template/ plugins/standards/<standard-name>/`
2. Customize README.md and AGENT_INSTRUCTIONS.md
3. Add configuration files and validation tools
4. Provide checklist for agents.md
5. Update PLUGIN_MANIFEST.yaml

## What to Include

- ✅ Configuration files for validation tools
- ✅ Documentation of the standard and why it matters
- ✅ Automated checks/linters where possible
- ✅ Checklist for manual review
- ✅ Make targets for validation
- ✅ Examples of compliant vs non-compliant code

## Integration

- Extend agents.md with checklist between `STANDARDS_CHECKLIST` markers
- Integrate with pre-commit hooks if available
- Provide clear pass/fail criteria
- Document exceptions and how to handle them

## Examples

- **Security**: Secret scanning, dependency scanning, SAST tools
- **Documentation**: File headers, README sections, inline comments
- **Performance**: Benchmarking, profiling, load testing
- **Accessibility**: WCAG compliance, ARIA labels, contrast checking
- **SOLID Principles**: Architecture linting, dependency analysis

See `plugins/standards/security/` and `plugins/standards/documentation/` for references.
