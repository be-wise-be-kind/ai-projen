# Security Standards Plugin

**Purpose**: Comprehensive security standards plugin providing secrets management, dependency scanning, and code security scanning

**Scope**: Security best practices, vulnerability scanning, secrets prevention, and security enforcement for Python and TypeScript projects

**Overview**: Plugin providing comprehensive security standards including secrets management (never commit
    secrets, environment variables, .gitignore patterns), dependency vulnerability scanning (Safety, pip-audit,
    npm audit), code security scanning (Bandit, ESLint security), and CI/CD security workflows. Integrates with
    language plugins (Python, TypeScript) and infrastructure plugins (GitHub Actions) to enforce security at
    development time and in CI/CD pipelines. Includes documentation, how-to guides, templates, and automated
    security scanning workflows.

**Dependencies**: Git repository, .ai folder (foundation plugin), optionally Python/TypeScript/GitHub Actions plugins

**Exports**: Security documentation (SECURITY_STANDARDS.md, secrets-management.md, dependency-scanning.md, code-scanning.md), how-to guides, .gitignore security patterns, .env.example template, GitHub Actions security workflow

**Related**: plugins/languages/python (Bandit integration), plugins/languages/typescript (ESLint security), plugins/infrastructure/ci-cd/github-actions (security workflows), plugins/standards/pre-commit-hooks (secret scanning)

**Implementation**: Template-based installation with conditional integration based on detected language and infrastructure plugins

---

## What is the Security Standards Plugin?

The Security Standards Plugin provides comprehensive security best practices and automated security scanning for AI-ready repositories. It helps prevent common security vulnerabilities by:

1. **Preventing secrets in Git**: `.gitignore` patterns and environment variable best practices
2. **Scanning dependencies**: Automated vulnerability scanning with Safety, pip-audit, npm audit
3. **Scanning code**: Static analysis with Bandit (Python) and ESLint security (TypeScript)
4. **Enforcing in CI/CD**: GitHub Actions workflows that block insecure code from merging

---

## Features

### Secrets Management
- ✅ **Never commit secrets principle**: Documentation and enforcement
- ✅ **Environment variable patterns**: `.env` / `.env.example` best practices
- ✅ **Comprehensive .gitignore**: Patterns for credentials, keys, certificates, tokens
- ✅ **Secret detection**: Pre-commit hooks for detecting potential secrets
- ✅ **CI/CD secrets**: GitHub Secrets, AWS Secrets Manager integration

### Dependency Scanning
- ✅ **Python vulnerability scanning**: Safety (CVE database), pip-audit (PyPI Advisory + OSV)
- ✅ **TypeScript vulnerability scanning**: npm audit, Snyk integration
- ✅ **Automated scans**: Weekly scheduled scans for new vulnerabilities
- ✅ **CI/CD integration**: Block PRs with critical vulnerabilities
- ✅ **Update guidance**: Documented processes for applying security patches

### Code Security Scanning (SAST)
- ✅ **Python security linting**: Bandit for detecting security vulnerabilities
- ✅ **TypeScript security linting**: ESLint security plugins
- ✅ **GitHub Code Scanning**: SARIF format integration
- ✅ **Custom security rules**: Extensible linting rules
- ✅ **Local + CI/CD**: Run security scans locally and in automation

### Integration
- ✅ **Language plugin integration**: Works with Python and TypeScript plugins
- ✅ **CI/CD integration**: GitHub Actions security workflow
- ✅ **Pre-commit integration**: Pre-commit hooks for early detection
- ✅ **Docker integration**: Security scanning in containers

---

## Quick Start

### Prerequisites

- Git repository initialized
- .ai folder present (foundation plugin)
- Optionally: Python plugin, TypeScript plugin, GitHub Actions plugin

### Installation

Point an AI agent to `plugins/standards/security/AGENT_INSTRUCTIONS.md`:

```bash
# AI agent: Install security standards plugin
Please install the security standards plugin using the instructions in:
plugins/standards/security/AGENT_INSTRUCTIONS.md
```

Or install manually:

```bash
# 1. Copy security documentation
cp plugins/standards/security/ai-content/docs/*.md .ai/docs/
cp plugins/standards/security/ai-content/standards/SECURITY_STANDARDS.md .ai/docs/

# 2. Copy how-to guides
cp plugins/standards/security/ai-content/howtos/*.md .ai/howto/

# 3. Add security patterns to .gitignore
cat plugins/standards/security/ai-content/templates/.gitignore.security.template >> .gitignore

# 4. Create .env.example template
cp plugins/standards/security/ai-content/templates/.env.example.template .env.example

# 5. Install security workflow (if using GitHub Actions)
cp plugins/standards/security/ai-content/templates/github-workflow-security.yml.template .github/workflows/security.yml
```

### Verification

```bash
# Check documentation
ls .ai/docs/SECURITY_STANDARDS.md .ai/docs/secrets-management.md

# Check .gitignore patterns
grep "\.env" .gitignore

# Check environment template
cat .env.example

# Run security scans (if tools installed)
make lint-bandit  # Python
npm audit         # TypeScript
```

---

## What Gets Installed

### Documentation

**`.ai/docs/SECURITY_STANDARDS.md`** - Comprehensive security standards covering:
- Authentication and authorization
- Input validation and sanitization
- Secrets management
- Dependency management
- Error handling and logging (security context)
- Security testing

**`.ai/docs/secrets-management.md`** - Secrets management best practices:
- Never commit secrets principle
- Environment variable patterns
- `.env` / `.env.example` usage
- Secret rotation procedures
- Detection and remediation

**`.ai/docs/dependency-scanning.md`** - Dependency vulnerability scanning:
- Python scanning (Safety, pip-audit)
- TypeScript scanning (npm audit, Snyk)
- CI/CD integration
- Vulnerability management
- Update strategies

**`.ai/docs/code-scanning.md`** - Code security scanning (SAST):
- Bandit for Python
- ESLint security for TypeScript
- GitHub Code Scanning
- Custom security rules
- False positive management

### How-To Guides

**`.ai/howto/how-to-prevent-secrets-in-git.md`**
- Step-by-step guide to preventing secrets in Git
- `.gitignore` configuration
- `.env` / `.env.example` setup
- Pre-commit hooks for secret detection
- Remediation if secrets are committed

**`.ai/howto/how-to-setup-dependency-scanning.md`**
- Installing Safety and pip-audit (Python)
- Installing npm audit (TypeScript)
- Configuring CI/CD dependency scans
- Managing vulnerability reports
- Applying security updates

**`.ai/howto/how-to-configure-code-scanning.md`**
- Installing Bandit (Python)
- Installing ESLint security (TypeScript)
- Configuring security linters
- Integrating with CI/CD
- Managing false positives

### Templates

**`.gitignore.security.template`** - Security patterns for .gitignore:
- Environment files (`.env`, `.env.local`)
- Credentials (`credentials.json`, `*.pem`, `*.key`)
- Terraform secrets (`*.secret.tfvars`, `*.auto.tfvars`)
- Cloud credentials (AWS, GCP, Azure)
- Database files (`*.db`, `*.sqlite`)
- Certificates (`*.crt`, `*.cer`)

**`.env.example.template`** - Environment variable template:
- Application configuration
- Database configuration
- API keys and secrets
- Third-party service configuration
- Documentation for each variable

**`github-workflow-security.yml.template`** - GitHub Actions security workflow:
- Dependency scanning (Safety, pip-audit, npm audit)
- Code scanning (Bandit, ESLint security)
- Scheduled weekly scans
- PR blocking on critical vulnerabilities
- SARIF upload for GitHub Code Scanning

---

## Usage Examples

### Prevent Committing Secrets

```bash
# Create environment file (never commit this)
cp .env.example .env

# Edit with your actual secrets
vi .env

# Verify .env is in .gitignore
grep "^\.env$" .gitignore

# .env is ignored, .env.example is committed
git status
```

### Run Dependency Scans

```bash
# Python: Scan dependencies for known vulnerabilities
safety check                    # CVE database
pip-audit                       # PyPI Advisory + OSV

# TypeScript: Scan dependencies
npm audit                       # Built-in vulnerability scanner
npm audit fix                   # Auto-fix vulnerabilities

# CI/CD: Automated scans
git push  # Triggers .github/workflows/security.yml
```

### Run Code Security Scans

```bash
# Python: Scan code for security vulnerabilities
bandit -r app/ -ll -i          # Scan app directory, low confidence and above

# TypeScript: Scan code
npm run lint                    # ESLint with security plugins

# Docker: Scan in containers (Docker-first)
make lint-bandit               # Runs Bandit in container
```

### CI/CD Security Enforcement

```bash
# Push code - triggers security workflow
git push origin feature/my-feature

# GitHub Actions runs:
# 1. Dependency scanning (Safety, pip-audit, npm audit)
# 2. Code scanning (Bandit, ESLint security)
# 3. Fails PR if critical vulnerabilities found
# 4. Uploads results to GitHub Code Scanning

# Review security findings in GitHub PR
```

---

## Integration Examples

### Python Project Integration

```bash
# Security tools are configured in Python plugin
# plugins/languages/python/linters/bandit/
# plugins/languages/python/security/safety/
# plugins/languages/python/security/pip-audit/

# Run security scans
make lint-bandit              # Static analysis for vulnerabilities
make security-check           # Dependency scanning (Safety + pip-audit)

# Pre-commit integration (if pre-commit hooks plugin installed)
# Bandit runs automatically before commit
```

### TypeScript Project Integration

```bash
# Install ESLint security plugin
npm install --save-dev eslint-plugin-security

# Add to .eslintrc.json
{
  "plugins": ["security"],
  "extends": ["plugin:security/recommended"]
}

# Run security scans
npm run lint                  # ESLint with security rules
npm audit                     # Dependency vulnerability scan
```

### GitHub Actions Integration

```yaml
# .github/workflows/security.yml
name: Security Scanning

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    # Run weekly for new vulnerabilities
    - cron: '0 0 * * 0'

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Bandit
        run: bandit -r app/ -f json -o bandit-report.json
      - name: Run Safety
        run: safety check --json
      - name: Run npm audit
        run: npm audit --audit-level=moderate
```

---

## Configuration

### Customize .gitignore Security Patterns

```bash
# Add project-specific secret patterns
cat >> .gitignore << 'EOF'
# Project-specific secrets
config/production.yml
certs/*.pem
keys/*.key
EOF
```

### Customize .env.example

```bash
# Document required environment variables
cat >> .env.example << 'EOF'
# Application
APP_NAME=my-app
APP_ENV=development

# Database
DATABASE_URL=postgresql://localhost:5432/myapp_dev

# API Keys
OPENAI_API_KEY=your_openai_api_key_here
STRIPE_API_KEY=your_stripe_api_key_here
EOF
```

### Configure Bandit

```toml
# pyproject.toml
[tool.bandit]
exclude_dirs = ["tests", "venv", ".venv"]
skips = ["B101"]  # Skip assert_used check
```

### Configure npm audit

```json
// package.json
{
  "scripts": {
    "audit": "npm audit --audit-level=moderate",
    "audit:fix": "npm audit fix"
  }
}
```

---

## Best Practices

### Development Workflow

1. **Create feature branch**: `git checkout -b feature/my-feature`
2. **Run security scans locally**: `make lint-bandit`, `npm audit`
3. **Fix vulnerabilities**: Address findings before committing
4. **Commit changes**: Pre-commit hooks run security checks
5. **Push to GitHub**: CI/CD runs comprehensive security scans
6. **Review findings**: Address any CI/CD security failures
7. **Merge PR**: Only after security checks pass

### Secrets Management

1. ✅ **DO**: Use environment variables for secrets
2. ✅ **DO**: Commit `.env.example` with placeholder values
3. ✅ **DO**: Add `.env` to `.gitignore`
4. ✅ **DO**: Use GitHub Secrets for CI/CD
5. ❌ **DON'T**: Commit secrets to Git ever
6. ❌ **DON'T**: Share `.env` files via email/Slack
7. ❌ **DON'T**: Hardcode secrets in code

### Vulnerability Management

1. **Critical vulnerabilities**: Fix immediately (same day)
2. **High vulnerabilities**: Fix within 7 days
3. **Medium vulnerabilities**: Fix within 30 days or document acceptable risk
4. **Low vulnerabilities**: Address during regular maintenance
5. **Weekly scans**: Run automated scans even without code changes

---

## Troubleshooting

### Bandit False Positives

```python
# Skip specific line
password = input("Password: ")  # nosec B102

# Skip specific check in pyproject.toml
[tool.bandit]
skips = ["B101", "B601"]
```

### npm audit Fails with Non-Critical Issues

```bash
# Set audit level to moderate (ignore low severity)
npm audit --audit-level=moderate

# Or in package.json
{
  "scripts": {
    "audit": "npm audit --audit-level=high"
  }
}
```

### Secrets Accidentally Committed

1. **Immediately rotate the secret**: Change the compromised credential
2. **Remove from Git history**: Use `git filter-branch` or BFG Repo-Cleaner
3. **Force push**: `git push --force` (coordinate with team)
4. **Document incident**: Record what happened and remediation steps

```bash
# Remove file from Git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/secret/file" \
  --prune-empty --tag-name-filter cat -- --all
```

---

## Security Checklist

Before deploying to production, verify:

- ✅ No secrets committed to Git
- ✅ All dependencies scanned for vulnerabilities
- ✅ All high/critical vulnerabilities fixed
- ✅ Bandit security scan passes
- ✅ ESLint security scan passes (if TypeScript)
- ✅ `.env` file not committed (in `.gitignore`)
- ✅ `.env.example` documents all required variables
- ✅ GitHub Actions security workflow enabled
- ✅ Security documentation reviewed by team

---

## Additional Resources

### Documentation
- `.ai/docs/SECURITY_STANDARDS.md` - Comprehensive security standards
- `.ai/docs/secrets-management.md` - Secrets management guide
- `.ai/docs/dependency-scanning.md` - Dependency scanning guide
- `.ai/docs/code-scanning.md` - Code scanning guide

### How-To Guides
- `.ai/howto/how-to-prevent-secrets-in-git.md` - Prevent secrets in Git
- `.ai/howto/how-to-setup-dependency-scanning.md` - Setup dependency scanning
- `.ai/howto/how-to-configure-code-scanning.md` - Configure code scanning

### External Resources
- [OWASP Top 10](https://owasp.org/www-project-top-ten/) - Web application security risks
- [CWE Top 25](https://cwe.mitre.org/top25/) - Most dangerous software weaknesses
- [Bandit Documentation](https://bandit.readthedocs.io/) - Python security linter
- [npm audit](https://docs.npmjs.com/cli/v8/commands/npm-audit) - Node.js dependency scanning

---

## Contributing

Found a security issue or want to improve security standards?

1. **Security vulnerabilities**: Report privately via GitHub Security Advisories
2. **Improvements**: Open an issue or PR with your suggestions
3. **New patterns**: Add `.gitignore` patterns or security rules

---

## License

This plugin is part of the ai-projen framework and follows the same license as the main project.
