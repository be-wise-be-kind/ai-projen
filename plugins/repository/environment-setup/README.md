# Environment Setup Plugin

**Purpose**: Automated environment variable management with direnv, .env files, and credential protection

**Category**: Repository Configuration

**Status**: Stable

**Use Case**: Ensure consistent, secure environment variable handling across development, CI/CD, and production environments

---

## What This Plugin Does

The Environment Setup Plugin automates the configuration of best-practice environment variable management for your repository. It:

- **Installs direnv** - Automatically loads environment variables when you `cd` into your project
- **Creates .env structure** - Sets up .env (gitignored), .env.example (committed), and .envrc files
- **Scans for violations** - Detects hardcoded credentials in your codebase
- **Fixes security issues** - Helps remediate committed secrets by creating a fix branch
- **Updates .gitignore** - Ensures .env files never get committed to version control
- **Validates setup** - Confirms everything is configured correctly

---

## Why You Need This

### The Problem

Without proper environment variable management:
- ❌ Secrets get hardcoded in source files
- ❌ Different developers have different configurations
- ❌ Environment variables aren't loaded consistently
- ❌ Credentials accidentally get committed to git
- ❌ Production vs development configs are mixed
- ❌ Team members don't know what variables are needed

### The Solution

This plugin automates:
- ✅ Automatic environment loading with direnv
- ✅ Secure .env file handling (never committed)
- ✅ .env.example template (committed for team reference)
- ✅ Credential scanning to prevent secrets in git
- ✅ .gitignore patterns to protect sensitive files
- ✅ OS-aware installation (macOS, Linux, Windows/WSL)
- ✅ Integration with security plugin for scanning

---

## What Gets Installed

### Files Created

```
your-repo/
├── .envrc                  # Direnv config (auto-loads .env)
├── .env                    # Your secrets (gitignored)
├── .env.example            # Template with placeholders (committed)
├── .gitignore              # Updated with .env exclusions
└── .ai/
    └── docs/repository/
        ├── environment-variables-best-practices.md
        └── ENVIRONMENT_STANDARDS.md
```

### System Configuration

- direnv installed (OS-specific: brew, apt, dnf, etc.)
- Shell hook configured (~/.bashrc or ~/.zshrc)
- Repository allowed for direnv auto-loading

---

## How It Works

### Automatic Environment Loading

```bash
# Before: Manual loading required
$ export API_KEY=secret123
$ export DATABASE_URL=postgres://...
$ python app.py

# After: Automatic with direnv
$ cd your-repo
direnv: loading .envrc
direnv: export +API_KEY +DATABASE_URL
$ python app.py  # Environment already loaded!
```

### Template-Based Configuration

```.env.example
# API Keys
API_KEY=your_api_key_here
API_SECRET=your_api_secret_here

# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname

# AWS Credentials
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

Team members copy `.env.example` to `.env` and fill in real values.

### Credential Scanning

Automatically scans your repository for accidentally committed secrets:

```
⚠️  FOUND POTENTIAL SECRETS IN REPOSITORY!

Findings:
  - config/settings.py:23 - Hardcoded API key detected
  - src/database.py:45 - Potential password in code

Would you like to create a branch to fix these violations?
```

---

## Installation

This plugin is installed via the standard plugin orchestrator:

### Via Agent (Recommended)

```
User: "Please configure my environment variable handling"

Agent will:
1. Recognize capability addition request
2. Route to how-to-add-capability.md
3. Discover environment-setup plugin
4. Execute AGENT_INSTRUCTIONS.md
5. Complete automated setup
```

### Manual Installation

If you want to install manually:

1. Ensure foundation/ai-folder plugin is installed
2. Follow `AGENT_INSTRUCTIONS.md` step-by-step
3. Run validation script: `bash plugins/repository/environment-setup/scripts/validate-env-setup.sh`

---

## Requirements

### Required

- Git repository initialized
- Foundation plugin (`plugins/foundation/ai-folder`) installed
- One of: macOS, Linux (Ubuntu/Debian/Fedora/Arch), Windows WSL

### Optional

- Security plugin (for credential scanning with gitleaks)
- Pre-commit hooks plugin (for automated validation)

---

## Features

### OS-Aware Installation

Automatically detects your operating system and uses the appropriate package manager:

- **macOS**: `brew install direnv`
- **Ubuntu/Debian**: `apt install direnv`
- **Fedora/RHEL/CentOS**: `dnf install direnv`
- **Arch Linux**: `pacman -S direnv`
- **Windows**: Recommends WSL or provides Scoop instructions

### Smart State Detection

Before making changes, analyzes current setup:
- Checks if direnv is already installed
- Detects existing .env, .envrc, .env.example files
- Verifies .gitignore patterns
- Scans for committed credentials

### Automated Remediation

If hardcoded credentials are found:
1. Creates a fix branch: `fix/remove-hardcoded-credentials`
2. Guides you through replacing hardcoded values with `os.getenv()` or `process.env`
3. Adds placeholders to .env.example
4. Commits changes for PR review

### Validation

Runs comprehensive checks:
- ✓ direnv installed and in PATH
- ✓ Shell hook configured
- ✓ .envrc exists and is allowed
- ✓ .env.example exists
- ✓ .gitignore excludes .env
- ✓ No recent credential violations

---

## Usage Examples

### Basic Setup

```bash
# Let the agent install the plugin
"Configure environment variables for this project"

# Result: Complete setup in ~2 minutes
✓ direnv installed
✓ .envrc created
✓ .env.example created
✓ .gitignore updated
✓ No violations found
```

### With Credential Violations

```bash
# Setup detects hardcoded secrets
⚠️  Found API key in src/config.py:15

# Agent creates fix branch
git checkout fix/remove-hardcoded-credentials

# Changes made:
- src/config.py:15: API_KEY = os.getenv('API_KEY')
+ .env.example: API_KEY=your_api_key_here

# Review and merge
git diff main
git push origin fix/remove-hardcoded-credentials
```

### Adding New Variables

```bash
# Add to .env (not committed)
echo "NEW_SERVICE_TOKEN=secret123" >> .env

# Add to .env.example (committed)
echo "NEW_SERVICE_TOKEN=your_token_here" >> .env.example

# direnv automatically reloads
direnv: loading .envrc
direnv: export +NEW_SERVICE_TOKEN
```

---

## Integration with Other Plugins

### Security Plugin

If installed, enables:
- Gitleaks credential scanning
- Pre-commit hooks for secrets prevention
- Automated violation detection

### Pre-commit Hooks Plugin

If installed, adds hooks for:
- Preventing .env from being committed
- Ensuring .env.example stays in sync
- Validating environment variable format

### Language Plugins (Python/TypeScript)

Integrates with:
- Python: Uses `os.getenv()` patterns
- TypeScript: Uses `process.env` patterns
- Provides language-specific .env.example templates

---

## Configuration

### Customize .env.example Template

Edit the template for project-specific variables:

```bash
# plugins/repository/environment-setup/ai-content/templates/.env.example.template

# Add project-specific sections
# Notion API
NOTION_API_KEY=

# Slack Integration
SLACK_WEBHOOK_URL=
SLACK_CHANNEL=
```

### Customize .envrc

By default, `.envrc` contains just:
```bash
dotenv
```

You can extend it:
```bash
dotenv

# Load path extensions
PATH_add bin

# Set project-specific variables
export PROJECT_ROOT=$(pwd)
```

---

## Troubleshooting

### direnv not loading

```bash
# Check installation
which direnv

# Check hook in shell config
grep "direnv hook" ~/.bashrc  # or ~/.zshrc

# Reload shell
source ~/.bashrc

# Allow directory
direnv allow
```

### Environment variables not available

```bash
# Check .env format (no spaces around =)
# Correct: API_KEY=value
# Wrong:   API_KEY = value

# Check .envrc syntax
cat .envrc
# Should contain: dotenv

# Test manually
direnv exec . env | grep YOUR_VAR
```

### False positive in credential scan

```bash
# Add to .gitleaksignore
echo "path/to/false/positive.py" >> .gitleaksignore

# Or ignore specific line
echo "file.py:42" >> .gitleaksignore
```

---

## Best Practices

### ✅ DO

- Commit .env.example with placeholder values
- Update .env.example when adding new variables
- Use descriptive variable names (SCREAMING_SNAKE_CASE)
- Add comments in .env.example explaining each variable
- Run `direnv allow` after editing .envrc
- Keep .env files out of version control
- Use prefix naming: `SERVICE_VAR_NAME` (e.g., `NOTION_API_KEY`)

### ❌ DON'T

- Never commit .env file
- Never hardcode secrets in source code
- Don't use spaces around = in .env files
- Don't store .env files in cloud storage
- Don't share .env files via Slack/email
- Don't mix production and development credentials

---

## Security

This plugin helps enforce environment variable security:

### Prevents Common Vulnerabilities

- **Committed Secrets**: Scans for and remediates hardcoded credentials
- **Exposed Keys**: Ensures .env is never committed via .gitignore
- **Inconsistent Configs**: Standardizes environment loading across team

### Security Checklist

After installation:
- ✅ .env in .gitignore
- ✅ No secrets in git history
- ✅ .env.example has only placeholders
- ✅ Credentials loaded from environment, not hardcoded
- ✅ Production credentials separate from development

---

## Documentation

Full documentation available in `.ai/docs/repository/`:

- `environment-variables-best-practices.md` - Comprehensive guide
- `ENVIRONMENT_STANDARDS.md` - Standards and requirements

---

## Support

For issues or questions:

1. Check `.ai/docs/repository/environment-variables-best-practices.md`
2. Run validation: `bash plugins/repository/environment-setup/scripts/validate-env-setup.sh`
3. Review AGENT_INSTRUCTIONS.md for detailed installation steps
4. Check direnv docs: https://direnv.net

---

## Success Story

**Before**:
```python
# config.py
API_KEY = "sk-1234567890abcdef"  # ❌ Hardcoded!
DATABASE_URL = "postgres://admin:password@prod-db:5432/app"  # ❌ In source!
```

**After**:
```python
# config.py
import os
API_KEY = os.getenv('API_KEY')  # ✅ From environment
DATABASE_URL = os.getenv('DATABASE_URL')  # ✅ Secure

# .env (gitignored)
API_KEY=sk-1234567890abcdef
DATABASE_URL=postgres://admin:password@prod-db:5432/app

# .env.example (committed)
API_KEY=your_openai_api_key_here
DATABASE_URL=postgresql://user:pass@host:port/dbname
```

**Result**:
- ✅ Secrets never committed
- ✅ Team knows what variables are needed
- ✅ Environment loads automatically
- ✅ Production vs development configs separate

---

**Remember**: Environment variables are the foundation of secure application configuration. This plugin makes it easy to get them right from the start.
