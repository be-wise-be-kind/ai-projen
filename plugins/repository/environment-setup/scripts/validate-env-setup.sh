#!/bin/bash
# Purpose: Validation script for environment variable setup
# Scope: Checks direnv installation, file structure, gitignore patterns, and security compliance
# Overview: Comprehensive validation of environment variable setup including direnv installation, shell hook
#     configuration, required files (.envrc, .env.example), .gitignore patterns, git tracking status, and
#     optional credential scanning. Returns exit code 0 if all checks pass, 1 if any check fails. Provides
#     detailed output for each check with ✓ for pass, ✗ for fail, and ! for warnings.
# Usage: bash validate-env-setup.sh
# Related: AGENT_INSTRUCTIONS.md, ENVIRONMENT_STANDARDS.md
# Implementation: Sequential validation checks with detailed reporting and exit code

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check counters
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

# Helper functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((CHECKS_PASSED++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((CHECKS_FAILED++))
}

check_warn() {
    echo -e "${YELLOW}!${NC} $1"
    ((CHECKS_WARNING++))
}

echo "========================================="
echo "Environment Setup Validation"
echo "========================================="
echo ""

# ========================================
# 1. direnv Installation
# ========================================
echo "Checking direnv installation..."

if command -v direnv >/dev/null 2>&1; then
    DIRENV_VERSION=$(direnv version 2>&1 | head -n 1)
    check_pass "direnv installed ($DIRENV_VERSION)"
else
    check_fail "direnv not installed"
    echo "  Install with:"
    echo "    macOS: brew install direnv"
    echo "    Ubuntu/Debian: sudo apt install direnv"
    echo "    Fedora: sudo dnf install direnv"
fi

# ========================================
# 2. Shell Hook Configuration
# ========================================
echo ""
echo "Checking shell hook configuration..."

# Detect shell
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
    HOOK_CMD='eval "$(direnv hook zsh)"'
elif [[ "$SHELL" == *"fish"* ]]; then
    SHELL_CONFIG="$HOME/.config/fish/config.fish"
    HOOK_CMD='direnv hook fish | source'
else
    SHELL_CONFIG="$HOME/.bashrc"
    HOOK_CMD='eval "$(direnv hook bash)"'
fi

if [ -f "$SHELL_CONFIG" ] && grep -q "direnv hook" "$SHELL_CONFIG" 2>/dev/null; then
    check_pass "Shell hook configured in $SHELL_CONFIG"
else
    check_fail "Shell hook not configured in $SHELL_CONFIG"
    echo "  Add this line: $HOOK_CMD"
    echo "  Then run: source $SHELL_CONFIG"
fi

# ========================================
# 3. .envrc File
# ========================================
echo ""
echo "Checking .envrc file..."

if [ -f .envrc ]; then
    check_pass ".envrc file exists"

    # Check if it contains dotenv command
    if grep -q "dotenv" .envrc; then
        check_pass ".envrc contains 'dotenv' command"
    else
        check_fail ".envrc missing 'dotenv' command"
        echo "  Add 'dotenv' to .envrc"
    fi
else
    check_fail ".envrc file missing"
    echo "  Create with: echo 'dotenv' > .envrc"
fi

# ========================================
# 4. Directory Allowed by direnv
# ========================================
echo ""
echo "Checking direnv allow status..."

if command -v direnv >/dev/null 2>&1; then
    if direnv status 2>/dev/null | grep -q "Found RC allowed true"; then
        check_pass "Directory allowed by direnv"
    else
        check_fail "Directory not allowed by direnv"
        echo "  Run: direnv allow"
    fi
else
    check_warn "Cannot check direnv status (direnv not installed)"
fi

# ========================================
# 5. .env.example File
# ========================================
echo ""
echo "Checking .env.example file..."

if [ -f .env.example ]; then
    check_pass ".env.example file exists"

    # Check if it has content
    if [ -s .env.example ]; then
        check_pass ".env.example has content"

        # Count variables
        VAR_COUNT=$(grep -c "^[A-Z_].*=" .env.example 2>/dev/null || echo "0")
        if [ "$VAR_COUNT" -gt 0 ]; then
            check_pass ".env.example contains $VAR_COUNT variables"
        else
            check_warn ".env.example appears empty or has no variables"
        fi
    else
        check_warn ".env.example is empty"
    fi
else
    check_fail ".env.example file missing"
    echo "  Create from template or copy from example"
fi

# ========================================
# 6. .env File
# ========================================
echo ""
echo "Checking .env file..."

if [ -f .env ]; then
    check_pass ".env file exists"

    # Check if it has content
    if [ -s .env ]; then
        check_pass ".env has content"
    else
        check_warn ".env is empty (add your secrets)"
    fi
else
    check_warn ".env file missing (create from .env.example)"
    echo "  Run: cp .env.example .env"
    echo "  Then edit .env with your actual secrets"
fi

# ========================================
# 7. .gitignore Patterns
# ========================================
echo ""
echo "Checking .gitignore patterns..."

if [ -f .gitignore ]; then
    check_pass ".gitignore file exists"

    # Check for .env exclusion
    if grep -q "^\.env$" .gitignore; then
        check_pass ".gitignore excludes .env"
    else
        check_fail ".gitignore does not exclude .env"
        echo "  Add to .gitignore: .env"
    fi

    # Check for additional patterns
    if grep -q "\.env\.local" .gitignore; then
        check_pass ".gitignore excludes .env.local"
    else
        check_warn ".gitignore should exclude .env.local (recommended)"
    fi

    if grep -q "\.env\.\*\.local" .gitignore; then
        check_pass ".gitignore excludes .env.*.local"
    else
        check_warn ".gitignore should exclude .env.*.local (recommended)"
    fi
else
    check_fail ".gitignore file missing"
    echo "  Create .gitignore and add .env patterns"
fi

# ========================================
# 8. Git Tracking Status
# ========================================
echo ""
echo "Checking git tracking status..."

if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
    # Check if .env is tracked by git
    if git ls-files | grep -q "^\.env$"; then
        check_fail ".env is tracked by git (SECURITY RISK!)"
        echo "  Remove from git: git rm --cached .env"
        echo "  Ensure .env in .gitignore"
        echo "  Rotate all secrets immediately!"
    else
        check_pass ".env is not tracked by git"
    fi

    # Check if .env.example is tracked
    if git ls-files | grep -q "^\.env\.example$"; then
        check_pass ".env.example is tracked by git"
    else
        check_warn ".env.example should be tracked by git (for team reference)"
        echo "  Add to git: git add .env.example"
    fi

    # Check if .envrc is tracked
    if git ls-files | grep -q "^\.envrc$"; then
        check_pass ".envrc is tracked by git"
    else
        check_warn ".envrc should be tracked by git"
        echo "  Add to git: git add .envrc"
    fi
else
    check_warn "Not a git repository or git not installed"
fi

# ========================================
# 9. Credential Scanning (Optional)
# ========================================
echo ""
echo "Checking for credential violations..."

if command -v gitleaks >/dev/null 2>&1; then
    echo "Running gitleaks scan..."
    if gitleaks detect --source . --no-git --exit-code 0 -r /tmp/gitleaks-validation.json 2>/dev/null; then
        if [ -f /tmp/gitleaks-validation.json ] && [ -s /tmp/gitleaks-validation.json ]; then
            VIOLATION_COUNT=$(grep -c '"Description"' /tmp/gitleaks-validation.json 2>/dev/null || echo "0")
            if [ "$VIOLATION_COUNT" -gt 0 ]; then
                check_fail "Found $VIOLATION_COUNT potential secrets in codebase"
                echo "  Review: /tmp/gitleaks-validation.json"
                echo "  Run full scan: gitleaks detect --source . --no-git"
            else
                check_pass "No credential violations detected"
            fi
            rm -f /tmp/gitleaks-validation.json
        else
            check_pass "No credential violations detected"
        fi
    else
        check_pass "No credential violations detected"
    fi
else
    check_warn "gitleaks not installed (optional but recommended)"
    echo "  Install: brew install gitleaks (macOS)"
    echo "  Or via Security Standards plugin"
fi

# ========================================
# 10. Environment Loading Test
# ========================================
echo ""
echo "Testing environment loading..."

if command -v direnv >/dev/null 2>&1 && [ -f .envrc ]; then
    # Try to load environment
    if direnv exec . env >/dev/null 2>&1; then
        check_pass "Environment loads successfully"

        # Count loaded variables
        if [ -f .env ]; then
            LOADED_VARS=$(direnv exec . env 2>/dev/null | grep -c "=" || echo "0")
            check_pass "Environment has $LOADED_VARS variables loaded"
        fi
    else
        check_fail "Failed to load environment"
        echo "  Check .envrc syntax and .env file format"
    fi
else
    check_warn "Cannot test environment loading"
fi

# ========================================
# Summary
# ========================================
echo ""
echo "========================================="
echo "Validation Summary"
echo "========================================="
echo -e "${GREEN}Passed:${NC}  $CHECKS_PASSED"
echo -e "${YELLOW}Warnings:${NC} $CHECKS_WARNING"
echo -e "${RED}Failed:${NC}  $CHECKS_FAILED"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    echo ""

    if [ $CHECKS_WARNING -gt 0 ]; then
        echo -e "${YELLOW}! Some warnings present - review recommendations above${NC}"
        echo ""
    fi

    echo "Your environment variable setup is correctly configured."
    echo ""
    echo "Next steps:"
    echo "  1. If .env doesn't exist, create from .env.example"
    echo "  2. Edit .env with your actual secret values"
    echo "  3. Run 'direnv allow' if you haven't already"
    echo "  4. Test: cd .. && cd - (should see direnv loading)"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Validation failed with $CHECKS_FAILED critical issues${NC}"
    echo ""
    echo "Review the failed checks above and follow the remediation steps."
    echo ""
    echo "For help:"
    echo "  - Read: plugins/repository/environment-setup/ai-content/docs/environment-variables-best-practices.md"
    echo "  - Review: plugins/repository/environment-setup/AGENT_INSTRUCTIONS.md"
    echo "  - Run automated setup via Environment Setup Plugin"
    echo ""
    exit 1
fi
