# Security Standards Plugin - Agent Instructions

**Purpose**: Installation and configuration guide for AI agents implementing security standards in projects

**Scope**: Secrets management, dependency scanning, code security scanning, and security best practices enforcement

**Overview**: Step-by-step instructions for AI agents to install and configure the Security Standards Plugin.
    This plugin provides comprehensive security standards including secrets management (environment variables,
    .gitignore patterns), dependency vulnerability scanning (Safety, pip-audit, npm audit), and code security
    scanning (Bandit, ESLint security plugins). Integrates with Python/TypeScript language plugins and GitHub
    Actions CI/CD plugin to enforce security at development time and in CI/CD pipelines.

**Dependencies**: Git repository, .ai folder (foundation plugin), optionally Python plugin, TypeScript plugin, GitHub Actions plugin

**Exports**: Security documentation, .gitignore patterns, .env.example template, security scanning workflows

**Related**: plugins/languages/python (Bandit integration), plugins/languages/typescript (ESLint security), plugins/infrastructure/ci-cd/github-actions (security workflows), plugins/standards/pre-commit-hooks (secret scanning hooks)

**Implementation**: Template-based installation with conditional integration based on detected language and infrastructure plugins

---

## Prerequisites

Before installing this plugin, verify:

1. **Foundation Plugin Installed**
   ```bash
   test -d .ai && echo "✓ Foundation plugin present" || echo "✗ Install foundation plugin first"
   ```

2. **Git Repository Initialized**
   ```bash
   git rev-parse --git-dir >/dev/null 2>&1 && echo "✓ Git repository" || echo "✗ Initialize git first"
   ```

3. **Optional: Language Plugins**
   - Python plugin (for Bandit, Safety, pip-audit integration)
   - TypeScript plugin (for npm audit, ESLint security integration)

4. **Optional: CI/CD Plugin**
   - GitHub Actions plugin (for automated security scanning workflows)

---

## Installation Steps

### Step 1: Copy Security Documentation

Copy security standards documentation to the project's .ai folder:

```bash
# Copy comprehensive security standards
cp plugins/standards/security/ai-content/standards/SECURITY_STANDARDS.md .ai/docs/

# Copy detailed security guides
cp plugins/standards/security/ai-content/docs/secrets-management.md .ai/docs/
cp plugins/standards/security/ai-content/docs/dependency-scanning.md .ai/docs/
cp plugins/standards/security/ai-content/docs/code-scanning.md .ai/docs/
```

### Step 2: Copy How-To Guides

Copy security how-to guides:

```bash
# Create howtos directory if it doesn't exist
mkdir -p .ai/howto

# Copy security how-tos
cp plugins/standards/security/ai-content/howtos/how-to-prevent-secrets-in-git.md .ai/howto/
cp plugins/standards/security/ai-content/howtos/how-to-setup-dependency-scanning.md .ai/howto/
cp plugins/standards/security/ai-content/howtos/how-to-configure-code-scanning.md .ai/howto/
```

### Step 3: Install Security .gitignore Patterns

Add security patterns to .gitignore:

```bash
# If .gitignore exists, append security patterns
if [ -f .gitignore ]; then
  echo "" >> .gitignore
  echo "# Security - Secrets and Credentials (added by security standards plugin)" >> .gitignore
  cat plugins/standards/security/ai-content/templates/.gitignore.security.template >> .gitignore
  echo "✓ Added security patterns to existing .gitignore"
else
  # Create new .gitignore with security patterns
  cp plugins/standards/security/ai-content/templates/.gitignore.security.template .gitignore
  echo "✓ Created .gitignore with security patterns"
fi
```

### Step 4: Create Environment Variable Template

Create .env.example if it doesn't exist:

```bash
if [ ! -f .env.example ]; then
  cp plugins/standards/security/ai-content/templates/.env.example.template .env.example
  echo "✓ Created .env.example template"
  echo "  → Customize with your project's environment variables"
else
  echo "ℹ .env.example already exists - review and merge security best practices manually"
fi
```

### Step 5: Configure Language-Specific Security Scanning

#### For Python Projects

If Python plugin is installed, configure security scanning:

```bash
# Check if Python plugin is present
if [ -f pyproject.toml ] || [ -f requirements.txt ] || [ -f setup.py ]; then
  echo "✓ Python project detected"

  # Bandit is already configured in Python plugin
  # Safety and pip-audit are in plugins/languages/python/security/

  echo "  → Bandit (security linter): Configured in Python plugin"
  echo "  → Safety (dependency CVE scanner): Available in plugins/languages/python/security/safety/"
  echo "  → pip-audit (PyPI Advisory scanner): Available in plugins/languages/python/security/pip-audit/"
  echo ""
  echo "  Run security scans:"
  echo "    make lint-bandit      # Scan for security vulnerabilities"
  echo "    make security-check   # Run Safety + pip-audit (if configured)"
fi
```

#### For TypeScript Projects

If TypeScript plugin is installed, configure security scanning:

```bash
# Check if TypeScript plugin is present
if [ -f package.json ]; then
  echo "✓ TypeScript/Node project detected"
  echo "  → npm audit: Built into npm (run 'npm audit')"
  echo "  → ESLint security plugins: Available via eslint-plugin-security"
  echo ""
  echo "  Install ESLint security plugin:"
  echo "    npm install --save-dev eslint-plugin-security"
  echo "  Add to .eslintrc.json:"
  echo '    "plugins": ["security"]'
  echo '    "extends": ["plugin:security/recommended"]'
fi
```

### Step 6: Install Security Scanning Workflows (Optional)

If GitHub Actions plugin is installed:

```bash
# Check if GitHub Actions is present
if [ -d .github/workflows ]; then
  echo "✓ GitHub Actions detected"

  # Copy security workflow if it doesn't exist
  if [ ! -f .github/workflows/security.yml ]; then
    cp plugins/standards/security/ai-content/templates/github-workflow-security.yml.template .github/workflows/security.yml
    echo "✓ Created .github/workflows/security.yml"
    echo "  → Runs dependency scanning and code security scanning on push/PR"
  else
    echo "ℹ .github/workflows/security.yml already exists"
    echo "  → Review plugins/standards/security/ai-content/templates/github-workflow-security.yml.template"
    echo "  → Merge security scanning steps manually"
  fi
fi
```

### Step 7: Update .ai/index.yaml

Add security standards to the project's .ai index:

```yaml
# Add to .ai/index.yaml under 'standards' section
standards:
  security:
    description: "Security standards and best practices"
    documentation:
      - path: "docs/SECURITY_STANDARDS.md"
        description: "Comprehensive security standards"
      - path: "docs/secrets-management.md"
        description: "Secrets management best practices"
      - path: "docs/dependency-scanning.md"
        description: "Dependency vulnerability scanning"
      - path: "docs/code-scanning.md"
        description: "Code security scanning (SAST)"
    howtos:
      - path: "howto/how-to-prevent-secrets-in-git.md"
        description: "Prevent committing secrets to Git"
      - path: "howto/how-to-setup-dependency-scanning.md"
        description: "Setup dependency vulnerability scanning"
      - path: "howto/how-to-configure-code-scanning.md"
        description: "Configure code security scanning"
```

### Step 8: Update agents.md (Optional)

If the project has .ai/agents.md, add security standards reference:

```markdown
## Security Standards

This project follows comprehensive security standards documented in `.ai/docs/SECURITY_STANDARDS.md`.

Key security practices:
- **Never commit secrets**: Use environment variables and `.env.example` templates
- **Dependency scanning**: Automated vulnerability scanning with Safety/pip-audit (Python) and npm audit (TypeScript)
- **Code scanning**: Static analysis with Bandit (Python) and ESLint security (TypeScript)
- **CI/CD security**: Automated security checks in GitHub Actions workflows

See `.ai/howto/how-to-prevent-secrets-in-git.md` for detailed guidance.
```

---

## Post-Installation Validation

After installation, verify the security standards plugin:

### Check Documentation

```bash
# Verify security documentation is present
test -f .ai/docs/SECURITY_STANDARDS.md && echo "✓ Security standards documented"
test -f .ai/docs/secrets-management.md && echo "✓ Secrets management guide present"
test -f .ai/docs/dependency-scanning.md && echo "✓ Dependency scanning guide present"
test -f .ai/docs/code-scanning.md && echo "✓ Code scanning guide present"
```

### Check .gitignore Patterns

```bash
# Verify security patterns in .gitignore
grep -q "\.env" .gitignore && echo "✓ Environment file patterns present"
grep -q "credentials" .gitignore && echo "✓ Credential patterns present"
```

### Check Environment Template

```bash
# Verify .env.example exists
test -f .env.example && echo "✓ Environment template present"
```

### Test Security Scans (if tools configured)

```bash
# Python: Run Bandit
if command -v bandit >/dev/null 2>&1; then
  bandit -r . -ll -i 2>&1 | head -5
  echo "✓ Bandit security scanner available"
fi

# TypeScript: Run npm audit
if [ -f package.json ]; then
  npm audit --audit-level=moderate 2>&1 | head -10
  echo "✓ npm audit available"
fi
```

---

## Integration with Other Plugins

### Python Plugin Integration

The Security Standards Plugin integrates with the Python plugin:
- **Bandit**: Configured in `plugins/languages/python/linters/bandit/`
- **Safety**: Available in `plugins/languages/python/security/safety/`
- **pip-audit**: Available in `plugins/languages/python/security/pip-audit/`
- **Makefile targets**: `make lint-bandit`, `make security-check`

### TypeScript Plugin Integration

Integrates with TypeScript plugin:
- **npm audit**: Built into npm (run `npm audit`)
- **ESLint security**: Via `eslint-plugin-security`
- **Dependency checking**: Via `npm audit fix`

### GitHub Actions Integration

If GitHub Actions plugin is installed:
- **Security workflow**: `.github/workflows/security.yml`
- **Dependency scanning**: Runs Safety/pip-audit (Python), npm audit (TypeScript)
- **Code scanning**: Runs Bandit (Python), ESLint security (TypeScript)
- **Scheduled scans**: Weekly dependency scans for new vulnerabilities

### Pre-commit Hooks Integration

If pre-commit hooks plugin is installed:
- **Secret scanning**: Detects potential secrets before commit
- **Bandit pre-commit**: Scans Python code for vulnerabilities
- **No-skip enforcement**: Prevents bypassing security checks

---

## Configuration Customization

### Customize .gitignore Patterns

Add project-specific secret patterns to .gitignore:

```bash
# Add custom secret patterns
echo "# Project-specific secrets" >> .gitignore
echo "config/production.yml" >> .gitignore
echo "certs/*.pem" >> .gitignore
```

### Customize .env.example

Update .env.example with your project's environment variables:

```bash
# Example environment variables
cat >> .env.example << 'EOF'
# Application Configuration
APP_NAME=my-application
APP_ENV=development

# Database Configuration
DATABASE_URL=postgresql://localhost:5432/myapp_dev

# API Keys (use actual values in .env, never commit .env)
API_KEY=your_api_key_here
SECRET_KEY=your_secret_key_here
EOF
```

### Customize Security Scanning

Configure Bandit thresholds in `pyproject.toml`:

```toml
[tool.bandit]
exclude_dirs = ["tests", "venv", ".venv"]
skips = ["B101"]  # Skip specific tests if needed
```

Configure npm audit level in package.json:

```json
{
  "scripts": {
    "audit": "npm audit --audit-level=moderate"
  }
}
```

---

## Troubleshooting

### Issue: Security patterns already in .gitignore

**Solution**: The installation appends patterns. Review .gitignore and remove duplicates if needed.

### Issue: .env.example conflicts with existing file

**Solution**: Manually merge security best practices from the template into your existing .env.example.

### Issue: Security workflow fails in GitHub Actions

**Solution**:
1. Check that Python/TypeScript dependencies are installed in workflow
2. Verify security tools (Bandit, Safety) are in requirements.txt or package.json
3. Review `.github/workflows/security.yml` for configuration errors

### Issue: Bandit reports false positives

**Solution**: Add exclusions to `pyproject.toml`:

```toml
[tool.bandit]
skips = ["B101", "B601"]  # Skip specific security checks
```

Or add inline comments to skip specific lines:

```python
password = input("Password: ")  # nosec B102
```

---

## Best Practices

### Secrets Management
1. **Never commit secrets**: Always use environment variables
2. **Use .env.example**: Document required environment variables
3. **Rotate secrets regularly**: Change API keys, passwords periodically
4. **Encrypt secrets in CI/CD**: Use GitHub Secrets, AWS Secrets Manager

### Dependency Scanning
1. **Scan weekly**: Run automated scans even without code changes
2. **Update promptly**: Apply security patches within 7 days
3. **Review advisories**: Understand the vulnerability before updating
4. **Pin versions**: Use exact versions in production (requirements.txt, package-lock.json)

### Code Scanning
1. **Run locally**: Run Bandit/ESLint security before committing
2. **Don't skip checks**: Never bypass security linters without review
3. **Fix promptly**: Address high/critical findings immediately
4. **Review medium findings**: Understand and document acceptable risks

### Security in CI/CD
1. **Fail on critical**: CI should fail for critical security vulnerabilities
2. **Block PRs**: Don't allow merging with security failures
3. **Automated scanning**: Every PR runs security scans
4. **Scheduled scans**: Weekly scans for new vulnerabilities

---

## Success Criteria

After installing the Security Standards Plugin, verify:

- ✅ Security documentation present in `.ai/docs/`
- ✅ Security how-tos present in `.ai/howto/`
- ✅ Security patterns in `.gitignore`
- ✅ `.env.example` template created
- ✅ Language-specific security scanning configured (Bandit, npm audit)
- ✅ Security workflow in `.github/workflows/` (if GitHub Actions present)
- ✅ `.ai/index.yaml` references security standards
- ✅ Security scans run successfully

---

## Next Steps

After installation:

1. **Review security documentation**: Read `.ai/docs/SECURITY_STANDARDS.md`
2. **Customize .env.example**: Add your project's environment variables
3. **Run security scans**: Execute `make lint-bandit` or `npm audit`
4. **Test workflows**: Push a commit to trigger GitHub Actions security workflow
5. **Train team**: Share `.ai/howto/how-to-prevent-secrets-in-git.md` with developers

For detailed guidance, see:
- `.ai/howto/how-to-prevent-secrets-in-git.md`
- `.ai/howto/how-to-setup-dependency-scanning.md`
- `.ai/howto/how-to-configure-code-scanning.md`
