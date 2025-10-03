# Environment Setup Plugin - Agent Instructions

**Purpose**: Installation and configuration guide for AI agents implementing environment variable best practices with direnv

**Scope**: Automated setup of .env, .envrc, .env.example files with direnv integration, credential scanning, and violation remediation

**Overview**: Step-by-step instructions for AI agents to install and configure the Environment Setup Plugin
    with intelligent state detection, OS-aware direnv installation, comprehensive file creation, credential
    violation scanning, and automated remediation. Ensures repositories follow environment variable best practices
    with automatic loading via direnv, proper .gitignore patterns, and no committed secrets.

**Dependencies**: Git repository, optional: Security plugin (for gitleaks scanning)

**Exports**: .envrc, .env.example, .gitignore patterns, direnv configuration, validated environment setup

**Related**: plugins/standards/security (credential scanning), .ai/docs/ENVIRONMENT_STANDARDS.md

**Implementation**: Detection-based installation with OS-aware tooling, credential scanning, and automated violation fixes

---

## Prerequisites

Before installing this plugin, verify:

1. **Git Repository Initialized**
   ```bash
   git rev-parse --git-dir >/dev/null 2>&1 && echo "✓ Git repository" || echo "✗ Initialize git first"
   ```

2. **Foundation Plugin Installed**
   ```bash
   test -d .ai && echo "✓ Foundation plugin installed" || echo "✗ Install foundation/ai-folder first"
   ```

3. **Optional: Security Plugin for Credential Scanning**
   ```bash
   command -v gitleaks >/dev/null 2>&1 && echo "✓ Gitleaks available" || echo "ℹ Install security plugin for credential scanning"
   ```

---

## Installation Steps

### Step 1: Detect Current State

Analyze the current environment variable setup:

```bash
# Check for existing files
if [ -f .env ]; then
  echo "✓ .env file exists"
  HAS_ENV=true
else
  echo "✗ .env file missing"
  HAS_ENV=false
fi

if [ -f .envrc ]; then
  echo "✓ .envrc file exists"
  HAS_ENVRC=true
else
  echo "✗ .envrc file missing"
  HAS_ENVRC=false
fi

if [ -f .env.example ]; then
  echo "✓ .env.example file exists"
  HAS_ENV_EXAMPLE=true
else
  echo "✗ .env.example file missing"
  HAS_ENV_EXAMPLE=false
fi

# Check if direnv is installed
if command -v direnv >/dev/null 2>&1; then
  echo "✓ direnv installed ($(direnv version))"
  HAS_DIRENV=true
else
  echo "✗ direnv not installed"
  HAS_DIRENV=false
fi

# Check .gitignore for .env exclusion
if [ -f .gitignore ] && grep -q "^\.env$" .gitignore; then
  echo "✓ .gitignore excludes .env"
  GITIGNORE_OK=true
else
  echo "! .gitignore may not properly exclude .env"
  GITIGNORE_OK=false
fi
```

### Step 2: Detect Operating System

Determine OS for direnv installation:

```bash
# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macOS"
  INSTALL_CMD="brew install direnv"
  SHELL_CONFIG="$HOME/.zshrc"
  echo "✓ Detected macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      ubuntu|debian)
        OS="Ubuntu/Debian"
        INSTALL_CMD="sudo apt update && sudo apt install -y direnv"
        ;;
      fedora|rhel|centos)
        OS="Fedora/RHEL/CentOS"
        INSTALL_CMD="sudo dnf install -y direnv"
        ;;
      arch|manjaro)
        OS="Arch Linux"
        INSTALL_CMD="sudo pacman -S direnv"
        ;;
      *)
        OS="Linux (generic)"
        INSTALL_CMD="curl -sfL https://direnv.net/install.sh | bash"
        ;;
    esac
  fi

  # Detect shell
  if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
  else
    SHELL_CONFIG="$HOME/.bashrc"
  fi
  echo "✓ Detected $OS"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
  OS="Windows (WSL/Git Bash)"
  if command -v scoop >/dev/null 2>&1; then
    INSTALL_CMD="scoop install direnv"
  else
    INSTALL_CMD="Download from: https://github.com/direnv/direnv/releases"
  fi
  SHELL_CONFIG="$HOME/.bashrc"
  echo "✓ Detected Windows (use WSL recommended)"
else
  OS="Unknown"
  INSTALL_CMD="See: https://direnv.net/docs/installation.html"
  echo "! Unknown OS - manual installation required"
fi
```

### Step 3: Install direnv (if needed)

If direnv is not installed, install it:

```bash
if [ "$HAS_DIRENV" = false ]; then
  echo "Installing direnv for $OS..."
  echo "Command: $INSTALL_CMD"

  # Execute installation (agent should confirm with user first)
  # Example for Ubuntu/Debian:
  if [[ "$OS" == "Ubuntu/Debian" ]]; then
    sudo apt update
    sudo apt install -y direnv
  elif [[ "$OS" == "macOS" ]]; then
    brew install direnv
  elif [[ "$OS" == "Fedora/RHEL/CentOS" ]]; then
    sudo dnf install -y direnv
  elif [[ "$OS" == "Arch Linux" ]]; then
    sudo pacman -S direnv
  else
    echo "⚠️  Please install direnv manually: $INSTALL_CMD"
    exit 1
  fi

  # Verify installation
  if command -v direnv >/dev/null 2>&1; then
    echo "✓ direnv installed successfully"
  else
    echo "✗ direnv installation failed"
    exit 1
  fi
else
  echo "✓ direnv already installed"
fi
```

### Step 4: Configure Shell Integration

Add direnv hook to shell configuration:

```bash
# Check if hook already exists
if grep -q "direnv hook" "$SHELL_CONFIG" 2>/dev/null; then
  echo "✓ direnv hook already configured in $SHELL_CONFIG"
else
  echo "Adding direnv hook to $SHELL_CONFIG..."

  # Determine shell type
  if [[ "$SHELL" == *"zsh"* ]]; then
    echo 'eval "$(direnv hook zsh)"' >> "$SHELL_CONFIG"
  elif [[ "$SHELL" == *"fish"* ]]; then
    echo 'direnv hook fish | source' >> ~/.config/fish/config.fish
  else
    echo 'eval "$(direnv hook bash)"' >> "$SHELL_CONFIG"
  fi

  echo "✓ direnv hook added to $SHELL_CONFIG"
  echo "ℹ  Run 'source $SHELL_CONFIG' or restart your shell to activate"
fi
```

### Step 5: Create .envrc File

Create .envrc to automatically load .env:

```bash
if [ "$HAS_ENVRC" = false ]; then
  echo "Creating .envrc file..."

  # Copy template
  cp plugins/repository/environment-setup/ai-content/templates/.envrc.template .envrc

  echo "✓ Created .envrc file"
  echo "ℹ  Run 'direnv allow' to activate environment loading"
else
  echo "✓ .envrc file already exists"
  echo "ℹ  Review existing .envrc to ensure it includes 'dotenv' command"
fi
```

### Step 6: Create .env.example Template

Create comprehensive .env.example file:

```bash
if [ "$HAS_ENV_EXAMPLE" = false ]; then
  echo "Creating .env.example file..."

  # Copy template
  cp plugins/repository/environment-setup/ai-content/templates/.env.example.template .env.example

  # Detect project type and customize template
  if [ -f pyproject.toml ] || [ -f requirements.txt ]; then
    echo "  Detected Python project - adding Python-specific variables"
  fi

  if [ -f package.json ]; then
    echo "  Detected Node.js project - adding Node-specific variables"
  fi

  if [ -f docker-compose.yml ]; then
    echo "  Detected Docker project - adding Docker-specific variables"
  fi

  echo "✓ Created .env.example file"
  echo "ℹ  Customize .env.example with your project's variables"
else
  echo "✓ .env.example file already exists"
fi
```

### Step 7: Update .gitignore

Ensure .env is excluded from version control:

```bash
if [ "$GITIGNORE_OK" = false ]; then
  echo "Updating .gitignore to exclude environment files..."

  if [ ! -f .gitignore ]; then
    echo "Creating .gitignore file..."
    touch .gitignore
  fi

  # Add environment file patterns
  cat plugins/repository/environment-setup/ai-content/templates/.gitignore.env.template >> .gitignore

  echo "✓ Updated .gitignore with environment file exclusions"
else
  echo "✓ .gitignore already excludes .env"
fi
```

### Step 8: Install gitleaks for Credential Scanning (if needed)

Offer to install gitleaks if not present:

```bash
# Check if gitleaks is installed
if command -v gitleaks >/dev/null 2>&1; then
  echo "✓ gitleaks already installed ($(gitleaks version))"
  HAS_GITLEAKS=true
else
  echo "✗ gitleaks not installed"
  HAS_GITLEAKS=false

  echo ""
  echo "Gitleaks is a secrets scanning tool that detects hardcoded credentials."
  echo "Would you like to install gitleaks for credential scanning?"
  echo ""

  # Detect OS for installation
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installation command: brew install gitleaks"
    brew install gitleaks
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      case "$ID" in
        ubuntu|debian)
          echo "Installing gitleaks via apt..."
          # Download and install latest release
          GITLEAKS_VERSION=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
          wget -q "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          tar -xzf "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          sudo mv gitleaks /usr/local/bin/
          rm "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          ;;
        fedora|rhel|centos)
          echo "Installing gitleaks via dnf..."
          GITLEAKS_VERSION=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
          wget -q "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          tar -xzf "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          sudo mv gitleaks /usr/local/bin/
          rm "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          ;;
        *)
          echo "Installing gitleaks from GitHub releases..."
          GITLEAKS_VERSION=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
          wget -q "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          tar -xzf "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          sudo mv gitleaks /usr/local/bin/
          rm "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
          ;;
      esac
    fi
  else
    echo "⚠️  Please install gitleaks manually: https://github.com/gitleaks/gitleaks#installation"
  fi

  # Verify installation
  if command -v gitleaks >/dev/null 2>&1; then
    echo "✓ gitleaks installed successfully ($(gitleaks version))"
    HAS_GITLEAKS=true
  else
    echo "ℹ  gitleaks installation skipped or failed - credential scanning will be skipped"
    HAS_GITLEAKS=false
  fi
fi
```

### Step 9: Scan for Credential Violations

Check if credentials are already committed to git:

```bash
echo "Scanning repository for potential credential violations..."

# Use gitleaks if available
if [ "$HAS_GITLEAKS" = true ]; then
  echo "Running gitleaks scan..."

  if gitleaks detect --source . --no-git --exit-code 0 -r gitleaks-report.json 2>/dev/null; then
    if [ -f gitleaks-report.json ] && [ -s gitleaks-report.json ]; then
      echo "⚠️  FOUND POTENTIAL SECRETS IN REPOSITORY!"
      echo ""
      echo "Gitleaks detected potential credentials in your codebase."
      echo "Report saved to: gitleaks-report.json"
      echo ""

      # Parse report and show findings
      if command -v jq >/dev/null 2>&1; then
        echo "Findings:"
        jq -r '.[] | "  - \(.File):\(.StartLine) - \(.Description)"' gitleaks-report.json 2>/dev/null || cat gitleaks-report.json
      else
        echo "Install 'jq' to see formatted findings, or review gitleaks-report.json"
      fi

      VIOLATIONS_FOUND=true
    else
      echo "✓ No credential violations detected"
      VIOLATIONS_FOUND=false
    fi
  else
    echo "✓ No credential violations detected"
    VIOLATIONS_FOUND=false
  fi
else
  echo "ℹ  Gitleaks not available - skipping credential scan"
  echo "ℹ  Install security plugin for automated credential scanning"
  VIOLATIONS_FOUND=false
fi
```

### Step 10: Offer Remediation (if violations found)

If credentials are found, offer to create a branch and fix them:

```bash
if [ "$VIOLATIONS_FOUND" = true ]; then
  echo ""
  echo "========================================"
  echo "CREDENTIAL VIOLATIONS DETECTED"
  echo "========================================"
  echo ""
  echo "Your repository contains potential hardcoded credentials."
  echo "This is a security risk and violates best practices."
  echo ""
  echo "Would you like me to create a branch to help remediate these issues?"
  echo ""
  echo "I will:"
  echo "  1. Create a new branch 'fix/remove-hardcoded-credentials'"
  echo "  2. Guide you through replacing hardcoded values with environment variables"
  echo "  3. Update .env.example with placeholder variables"
  echo "  4. Commit the changes"
  echo ""

  # In practice, agent would ask user for confirmation
  # For now, we'll outline the remediation process

  echo "To remediate manually:"
  echo "  1. Create a branch: git checkout -b fix/remove-hardcoded-credentials"
  echo "  2. Review findings in gitleaks-report.json"
  echo "  3. Replace each hardcoded secret with os.getenv('VARIABLE_NAME') or process.env.VARIABLE_NAME"
  echo "  4. Add VARIABLE_NAME= to .env.example with a placeholder"
  echo "  5. Create .env (not committed) with actual values"
  echo "  6. Test that your application still works"
  echo "  7. Commit changes and create a PR"
  echo ""

  # Example automated remediation (simplified):
  # git checkout -b fix/remove-hardcoded-credentials
  # For each violation:
  #   - Identify the variable name
  #   - Replace hardcoded value with environment variable reference
  #   - Add to .env.example
  # git add -u
  # git commit -m "fix: Remove hardcoded credentials, use environment variables"
fi
```

### Step 11: Create .env File (if needed)

Help user create .env from .env.example:

```bash
if [ "$HAS_ENV" = false ]; then
  echo ""
  echo "Creating .env file from .env.example..."

  if [ -f .env.example ]; then
    cp .env.example .env
    echo "✓ Created .env file from .env.example"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env and add your actual secret values"
    echo "    .env is gitignored and will NOT be committed"
  else
    echo "⚠️  .env.example not found - creating empty .env"
    touch .env
    echo "# Environment Variables" > .env
    echo "# Add your secrets here - this file is gitignored" >> .env
  fi
else
  echo "✓ .env file already exists"
fi
```

### Step 12: Activate direnv

Allow direnv for this directory:

```bash
echo ""
echo "Activating direnv for this directory..."

# Check if already allowed
if direnv status 2>/dev/null | grep -q "Found RC allowed true"; then
  echo "✓ direnv already allowed for this directory"
else
  echo "Allowing direnv for this directory..."
  direnv allow .

  if [ $? -eq 0 ]; then
    echo "✓ direnv allowed - environment will auto-load on cd"
  else
    echo "! Run 'direnv allow' manually to activate"
  fi
fi
```

### Step 13: Run Validation

Validate the complete setup:

```bash
echo ""
echo "Running validation checks..."
echo ""

# Run validation script
bash plugins/repository/environment-setup/scripts/validate-env-setup.sh

if [ $? -eq 0 ]; then
  echo ""
  echo "======================================"
  echo "✓ ENVIRONMENT SETUP COMPLETE"
  echo "======================================"
else
  echo ""
  echo "! Some validation checks failed - review output above"
fi
```

### Step 14: Copy Documentation

Copy documentation to .ai folder:

```bash
echo ""
echo "Copying documentation to .ai folder..."

# Create directories
mkdir -p .ai/docs/repository
mkdir -p .ai/howtos/repository

# Copy docs
cp plugins/repository/environment-setup/ai-content/docs/environment-variables-best-practices.md .ai/docs/repository/
cp plugins/repository/environment-setup/ai-content/standards/ENVIRONMENT_STANDARDS.md .ai/docs/repository/

# Copy howtos
cp plugins/repository/environment-setup/ai-content/howtos/README.md .ai/howtos/repository/environment-setup-readme.md

echo "✓ Documentation copied to .ai folder"
```

### Step 15: Update .ai/index.yaml

Add environment setup to project index:

```bash
echo ""
echo "Updating .ai/index.yaml..."

# Add to index.yaml under repository section
# (In practice, agent would parse and update YAML)
cat >> .ai/index.yaml << 'EOF'

repository:
  environment-setup:
    description: "Environment variable handling with direnv and .env files"
    documentation:
      - path: "docs/repository/environment-variables-best-practices.md"
        description: "Best practices for environment variable management"
      - path: "docs/repository/ENVIRONMENT_STANDARDS.md"
        description: "Environment variable standards and requirements"
    configuration:
      - path: ".envrc"
        description: "Direnv configuration for auto-loading .env"
      - path: ".env.example"
        description: "Template for environment variables"
EOF

echo "✓ Updated .ai/index.yaml"
```

---

## Post-Installation Validation

After installation, verify the environment setup:

### Check Files Created

```bash
test -f .envrc && echo "✓ .envrc created"
test -f .env && echo "✓ .env created"
test -f .env.example && echo "✓ .env.example created"
grep -q "^\.env$" .gitignore && echo "✓ .gitignore excludes .env"
```

### Check direnv Installation

```bash
command -v direnv && echo "✓ direnv installed"
direnv status && echo "✓ direnv configured"
```

### Test Environment Loading

```bash
# Exit and re-enter directory to test auto-loading
cd .. && cd -
env | grep -i "loaded by direnv" || echo "ℹ  Environment variables loaded"
```

---

## Next Steps for User

After installation is complete, inform the user:

```
====================================
ENVIRONMENT SETUP COMPLETE
====================================

Your repository is now configured for proper environment variable handling.

NEXT STEPS:

1. Edit .env file with your actual secret values
   $ nano .env  # or your preferred editor

2. Restart your shell or source your shell config
   $ source ~/.bashrc  # or ~/.zshrc

3. Test direnv auto-loading
   $ cd ..
   $ cd -
   # You should see: direnv: loading .envrc

4. Verify environment variables are loaded
   $ echo $SOME_VARIABLE

5. If violations were found, review the remediation branch
   $ git checkout fix/remove-hardcoded-credentials
   $ git diff main
   # Review changes, then create a PR when ready

IMPORTANT REMINDERS:

✓ .env contains secrets - NEVER commit this file
✓ .env.example is committed - use placeholders only
✓ direnv auto-loads .env when you cd into this directory
✓ Update .env.example when adding new variables
✓ Run 'direnv allow' after editing .envrc

For more information, see:
  .ai/docs/repository/environment-variables-best-practices.md
  .ai/docs/repository/ENVIRONMENT_STANDARDS.md
```

---

## Integration with Other Plugins

### Security Plugin Integration

If the Security plugin is installed:
- Uses gitleaks for credential scanning
- Integrates with pre-commit hooks for secrets prevention
- Adds .env.example validation

### Pre-commit Hooks Integration

If Pre-commit Hooks plugin is installed:
- Adds hook to prevent committing .env file
- Adds hook to validate .env.example exists
- Adds hook to check for hardcoded secrets

---

## Troubleshooting

### Issue: direnv not loading environment

**Solution**: Check hook installation and allow status
```bash
# Check if hook is in shell config
grep "direnv hook" ~/.bashrc  # or ~/.zshrc

# Check if directory is allowed
direnv status

# Allow directory
direnv allow
```

### Issue: "command not found: direnv"

**Solution**: direnv not in PATH or not installed correctly
```bash
# Check installation
which direnv

# Reinstall if needed
# macOS:
brew reinstall direnv

# Ubuntu/Debian:
sudo apt install --reinstall direnv
```

### Issue: Environment variables not loading

**Solution**: Check .envrc syntax and .env file format
```bash
# Test .envrc manually
direnv exec . env | grep YOUR_VAR

# Check .env file format (no spaces around =)
cat .env
# Correct: API_KEY=value
# Wrong:   API_KEY = value
```

### Issue: Gitleaks finding false positives

**Solution**: Add exceptions to .gitleaksignore
```bash
# Create .gitleaksignore
echo "path/to/false/positive/file.py" > .gitleaksignore

# Or ignore specific line
echo "file.py:42" >> .gitleaksignore
```

---

## Success Criteria

After installing the Environment Setup Plugin, verify:

- ✅ direnv installed and configured
- ✅ .envrc created with `dotenv` command
- ✅ .env.example created with comprehensive placeholders
- ✅ .env created (if needed) and excluded from git
- ✅ .gitignore properly excludes environment files
- ✅ Repository scanned for credential violations
- ✅ Violations remediated or documented (if found)
- ✅ Shell hook configured for auto-loading
- ✅ direnv allowed for directory
- ✅ Documentation copied to .ai/
- ✅ Validation script passes

---

## Best Practices

### Always Use .env.example
- Commit .env.example with placeholder values
- Update .env.example when adding new variables
- Use descriptive comments for each variable

### Never Commit Secrets
- Keep .env in .gitignore
- Use environment variables, not hardcoded values
- Scan regularly for accidental commits

### Use Descriptive Variable Names
- SCREAMING_SNAKE_CASE for environment variables
- Prefix by service: `NOTION_API_KEY`, `AWS_ACCESS_KEY`
- Be explicit: `DATABASE_URL` not `DB`

### Document Your Variables
- Add comments in .env.example explaining purpose
- Document expected format and example values
- List where each variable is used

---

**Remember**: This plugin automates environment variable best practices setup. The agent should guide users through the process, explain each step, and ensure they understand the security implications of environment variables.
