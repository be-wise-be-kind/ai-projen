#!/bin/bash
# Purpose: Validates complete production-ready fullstack setup including all 15+ tools, optional features, and infrastructure
# Scope: Full-stack application validation covering backend tools, frontend tools, infrastructure, optional UI scaffold, and optional Terraform
# Overview: Comprehensive validation script that checks all components of the production-ready fullstack setup.
#     Validates all 9 backend quality tools (Ruff, Pylint, Flake8+plugins, MyPy, Bandit, Radon, Xenon, Safety, pip-audit),
#     all 6 frontend quality tools (ESLint+plugins, TypeScript, Vitest, Playwright, npm audit), Makefile targets,
#     Docker compose setup, CI/CD workflows, and optional features (UI scaffold, Terraform deployment).
#     Provides clear pass/fail status for each component and exits with appropriate status code.
#     Supports all 4 installation combinations (base, UI only, Terraform only, UI+Terraform).
# Dependencies: bash, poetry (backend tools), npm/npx (frontend tools), make, docker, git
# Exports: Validation status for all fullstack components with detailed failure reporting
# Usage: ./scripts/validate-fullstack-setup.sh [--verbose] [--skip-optional]
# Environment: Development and CI/CD validation of fullstack setup completeness
# Implementation: Component-based validation with detailed reporting, optional feature detection, and comprehensive coverage

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track validation results
VALIDATION_ERRORS=0
VALIDATION_WARNINGS=0

# Configuration
VERBOSE=false
SKIP_OPTIONAL=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --verbose)
      VERBOSE=true
      shift
      ;;
    --skip-optional)
      SKIP_OPTIONAL=true
      shift
      ;;
    --help)
      echo "Usage: $0 [--verbose] [--skip-optional]"
      echo ""
      echo "Options:"
      echo "  --verbose       Show detailed output for each check"
      echo "  --skip-optional Skip validation of optional features (UI scaffold, Terraform)"
      echo "  --help          Show this help message"
      exit 0
      ;;
  esac
done

# Utility functions
print_header() {
  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}  $1${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
  echo ""
}

print_section() {
  echo ""
  echo -e "${YELLOW}▶ $1${NC}"
  echo ""
}

check_pass() {
  echo -e "  ${GREEN}✓${NC} $1"
}

check_fail() {
  echo -e "  ${RED}✗${NC} $1"
  VALIDATION_ERRORS=$((VALIDATION_ERRORS + 1))
}

check_warn() {
  echo -e "  ${YELLOW}⚠${NC} $1"
  VALIDATION_WARNINGS=$((VALIDATION_WARNINGS + 1))
}

check_info() {
  echo -e "  ${BLUE}ℹ${NC} $1"
}

# Start validation
print_header "Production-Ready Fullstack Setup Validation"

echo "Validating complete fullstack setup..."
echo "This checks all 15+ tools, infrastructure, and optional features"
echo ""

# ============================================================================
# Phase 1: Directory Structure Validation
# ============================================================================
print_section "Phase 1: Directory Structure"

if [ -d "backend" ]; then
  check_pass "backend/ directory exists"
else
  check_fail "backend/ directory missing"
fi

if [ -d "frontend" ]; then
  check_pass "frontend/ directory exists"
else
  check_fail "frontend/ directory missing"
fi

if [ -d ".ai" ]; then
  check_pass ".ai/ directory exists (AI-ready structure)"
else
  check_fail ".ai/ directory missing"
fi

if [ -f "docker-compose.yml" ]; then
  check_pass "docker-compose.yml exists"
else
  check_fail "docker-compose.yml missing"
fi

if [ -f "Makefile" ]; then
  check_pass "Makefile exists"
else
  check_fail "Makefile missing"
fi

# ============================================================================
# Phase 2: Backend Tools Validation (9 tools)
# ============================================================================
print_section "Phase 2: Backend Tools (9 tools)"

cd backend

# Tool 1: Ruff
if poetry run ruff --version > /dev/null 2>&1; then
  check_pass "Ruff (fast linting + formatting)"
  [ "$VERBOSE" = true ] && poetry run ruff --version
else
  check_fail "Ruff not installed"
fi

# Tool 2: Pylint
if poetry run pylint --version > /dev/null 2>&1; then
  check_pass "Pylint (comprehensive quality)"
  [ "$VERBOSE" = true ] && poetry run pylint --version
else
  check_fail "Pylint not installed"
fi

# Tool 3: Flake8
if poetry run flake8 --version > /dev/null 2>&1; then
  check_pass "Flake8 (style checking)"
  [ "$VERBOSE" = true ] && poetry run flake8 --version

  # Check Flake8 plugins
  if poetry run flake8 --version 2>&1 | grep -q "flake8-docstrings"; then
    check_pass "  ├─ flake8-docstrings plugin"
  else
    check_warn "  ├─ flake8-docstrings plugin missing"
  fi

  if poetry run flake8 --version 2>&1 | grep -q "flake8-bugbear"; then
    check_pass "  ├─ flake8-bugbear plugin"
  else
    check_warn "  ├─ flake8-bugbear plugin missing"
  fi

  if poetry run flake8 --version 2>&1 | grep -q "flake8-comprehensions"; then
    check_pass "  ├─ flake8-comprehensions plugin"
  else
    check_warn "  ├─ flake8-comprehensions plugin missing"
  fi

  if poetry run flake8 --version 2>&1 | grep -q "flake8-simplify"; then
    check_pass "  └─ flake8-simplify plugin"
  else
    check_warn "  └─ flake8-simplify plugin missing"
  fi
else
  check_fail "Flake8 not installed"
fi

# Tool 4: MyPy
if poetry run mypy --version > /dev/null 2>&1; then
  check_pass "MyPy (type checking)"
  [ "$VERBOSE" = true ] && poetry run mypy --version
else
  check_fail "MyPy not installed"
fi

# Tool 5: Bandit
if poetry run bandit --version > /dev/null 2>&1; then
  check_pass "Bandit (security scanning)"
  [ "$VERBOSE" = true ] && poetry run bandit --version
else
  check_fail "Bandit not installed"
fi

# Tool 6: Radon
if poetry run radon --version > /dev/null 2>&1; then
  check_pass "Radon (complexity metrics)"
  [ "$VERBOSE" = true ] && poetry run radon --version
else
  check_fail "Radon not installed"
fi

# Tool 7: Xenon
if poetry run xenon --version > /dev/null 2>&1; then
  check_pass "Xenon (complexity enforcement)"
  [ "$VERBOSE" = true ] && poetry run xenon --version
else
  check_fail "Xenon not installed"
fi

# Tool 8: Safety
if poetry run safety --version > /dev/null 2>&1; then
  check_pass "Safety (CVE scanning)"
  [ "$VERBOSE" = true ] && poetry run safety --version
else
  check_fail "Safety not installed"
fi

# Tool 9: pip-audit
if poetry run pip-audit --version > /dev/null 2>&1; then
  check_pass "pip-audit (OSV scanning)"
  [ "$VERBOSE" = true ] && poetry run pip-audit --version
else
  check_fail "pip-audit not installed"
fi

cd ..

# ============================================================================
# Phase 3: Frontend Tools Validation (6 tools)
# ============================================================================
print_section "Phase 3: Frontend Tools (6 tools)"

cd frontend

# Tool 1: ESLint
if npx eslint --version > /dev/null 2>&1; then
  check_pass "ESLint (linting)"
  [ "$VERBOSE" = true ] && npx eslint --version

  # Check ESLint plugins
  if npm list eslint-plugin-react-hooks > /dev/null 2>&1; then
    check_pass "  ├─ eslint-plugin-react-hooks"
  else
    check_warn "  ├─ eslint-plugin-react-hooks missing"
  fi

  if npm list eslint-plugin-jsx-a11y > /dev/null 2>&1; then
    check_pass "  ├─ eslint-plugin-jsx-a11y"
  else
    check_warn "  ├─ eslint-plugin-jsx-a11y missing"
  fi

  if npm list eslint-plugin-import > /dev/null 2>&1; then
    check_pass "  └─ eslint-plugin-import"
  else
    check_warn "  └─ eslint-plugin-import missing"
  fi
else
  check_fail "ESLint not installed"
fi

# Tool 2: TypeScript
if npx tsc --version > /dev/null 2>&1; then
  check_pass "TypeScript (type checking)"
  [ "$VERBOSE" = true ] && npx tsc --version
else
  check_fail "TypeScript not installed"
fi

# Tool 3: Vitest
if npx vitest --version > /dev/null 2>&1; then
  check_pass "Vitest (unit testing)"
  [ "$VERBOSE" = true ] && npx vitest --version
else
  check_fail "Vitest not installed"
fi

# Tool 4: React Testing Library
if npm list @testing-library/react > /dev/null 2>&1; then
  check_pass "React Testing Library (component testing)"
else
  check_warn "React Testing Library not installed"
fi

# Tool 5: Playwright
if npx playwright --version > /dev/null 2>&1; then
  check_pass "Playwright (E2E testing)"
  [ "$VERBOSE" = true ] && npx playwright --version
else
  check_fail "Playwright not installed"
fi

# Tool 6: npm audit
if npm audit --help > /dev/null 2>&1; then
  check_pass "npm audit (security scanning)"
else
  check_fail "npm audit not available"
fi

cd ..

# ============================================================================
# Phase 4: Makefile Targets Validation
# ============================================================================
print_section "Phase 4: Makefile Targets"

# Check essential targets
REQUIRED_TARGETS=(
  "help"
  "install"
  "lint-backend"
  "lint-backend-all"
  "lint-backend-security"
  "lint-backend-complexity"
  "lint-backend-full"
  "lint-frontend"
  "lint-frontend-all"
  "lint-frontend-security"
  "lint-frontend-full"
  "lint-all"
  "lint-full"
  "test-backend"
  "test-frontend"
  "test-all"
  "format"
  "clean"
)

for target in "${REQUIRED_TARGETS[@]}"; do
  if grep -q "^${target}:" Makefile; then
    check_pass "Target: ${target}"
  else
    check_fail "Target missing: ${target}"
  fi
done

# ============================================================================
# Phase 5: Docker Setup Validation
# ============================================================================
print_section "Phase 5: Docker Setup"

if [ -f "docker-compose.yml" ]; then
  check_pass "docker-compose.yml exists"

  # Check for required services
  if grep -q "backend:" docker-compose.yml; then
    check_pass "  ├─ backend service defined"
  else
    check_fail "  ├─ backend service missing"
  fi

  if grep -q "frontend:" docker-compose.yml; then
    check_pass "  ├─ frontend service defined"
  else
    check_fail "  ├─ frontend service missing"
  fi

  if grep -q "postgres:" docker-compose.yml || grep -q "db:" docker-compose.yml; then
    check_pass "  └─ database service defined"
  else
    check_fail "  └─ database service missing"
  fi
else
  check_fail "docker-compose.yml missing"
fi

if [ -f "backend/Dockerfile" ]; then
  check_pass "backend/Dockerfile exists"
else
  check_fail "backend/Dockerfile missing"
fi

if [ -f "frontend/Dockerfile" ]; then
  check_pass "frontend/Dockerfile exists"
else
  check_fail "frontend/Dockerfile missing"
fi

# ============================================================================
# Phase 6: CI/CD Workflow Validation
# ============================================================================
print_section "Phase 6: CI/CD Workflows"

if [ -d ".github/workflows" ]; then
  check_pass ".github/workflows/ directory exists"

  # Check for workflow files
  WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" | wc -l)
  if [ "$WORKFLOW_COUNT" -gt 0 ]; then
    check_pass "Found ${WORKFLOW_COUNT} workflow file(s)"

    # Check for CI workflow
    if ls .github/workflows/*ci*.yml > /dev/null 2>&1 || ls .github/workflows/*test*.yml > /dev/null 2>&1; then
      check_pass "  ├─ CI/test workflow exists"
    else
      check_warn "  ├─ CI/test workflow not found"
    fi

    # Check for deploy workflow
    if ls .github/workflows/*deploy*.yml > /dev/null 2>&1 || ls .github/workflows/*cd*.yml > /dev/null 2>&1; then
      check_pass "  └─ Deploy workflow exists"
    else
      check_warn "  └─ Deploy workflow not found"
    fi
  else
    check_warn "No workflow files found in .github/workflows/"
  fi
else
  check_fail ".github/workflows/ directory missing"
fi

# ============================================================================
# Phase 7: Optional Features Validation
# ============================================================================
if [ "$SKIP_OPTIONAL" = false ]; then
  print_section "Phase 7: Optional Features"

  # Check for UI Scaffold (optional)
  if [ -d "frontend/src/components/AppShell" ]; then
    check_info "UI Scaffold: INSTALLED"

    # Validate UI scaffold components
    if [ -f "frontend/src/pages/HomePage.tsx" ]; then
      check_pass "  ├─ HomePage component"
    else
      check_warn "  ├─ HomePage component missing"
    fi

    if [ -f "frontend/src/components/AppShell/AppShell.tsx" ]; then
      check_pass "  ├─ AppShell component"
    else
      check_warn "  ├─ AppShell component missing"
    fi

    if [ -f "frontend/src/components/PrinciplesBanner/PrinciplesBanner.tsx" ]; then
      check_pass "  ├─ PrinciplesBanner component"
    else
      check_warn "  ├─ PrinciplesBanner component missing"
    fi

    if [ -f "frontend/src/components/TabNavigation/TabNavigation.tsx" ]; then
      check_pass "  └─ TabNavigation component"
    else
      check_warn "  └─ TabNavigation component missing"
    fi
  else
    check_info "UI Scaffold: NOT INSTALLED (optional)"
  fi

  # Check for Terraform (optional)
  if [ -d "infra/terraform" ]; then
    check_info "Terraform Deployment: INSTALLED"

    # Validate Terraform structure
    if [ -d "infra/terraform/workspaces/base" ]; then
      check_pass "  ├─ Base workspace"
    else
      check_warn "  ├─ Base workspace missing"
    fi

    if [ -d "infra/terraform/workspaces/bootstrap" ]; then
      check_pass "  ├─ Bootstrap workspace"
    else
      check_warn "  ├─ Bootstrap workspace missing"
    fi

    if [ -d "infra/terraform/modules" ]; then
      check_pass "  ├─ Terraform modules"
    else
      check_warn "  ├─ Terraform modules missing"
    fi

    if [ -f "Makefile.infra" ]; then
      check_pass "  └─ Makefile.infra"
    else
      check_warn "  └─ Makefile.infra missing"
    fi
  else
    check_info "Terraform Deployment: NOT INSTALLED (optional)"
  fi
else
  print_section "Phase 7: Optional Features (SKIPPED)"
  check_info "Use without --skip-optional to validate UI scaffold and Terraform"
fi

# ============================================================================
# Phase 8: Documentation Validation
# ============================================================================
print_section "Phase 8: Documentation"

if [ -f "README.md" ]; then
  check_pass "README.md exists"

  # Check for key sections
  if grep -q "What You Get" README.md; then
    check_pass "  ├─ 'What You Get' section found"
  else
    check_warn "  ├─ 'What You Get' section missing"
  fi

  if grep -q "Quick Start" README.md || grep -q "Getting Started" README.md; then
    check_pass "  └─ Quick Start section found"
  else
    check_warn "  └─ Quick Start section missing"
  fi
else
  check_fail "README.md missing"
fi

if [ -f ".ai/AGENTS.md" ]; then
  check_pass ".ai/AGENTS.md exists (AI agent guide)"
else
  check_warn ".ai/AGENTS.md missing (recommended for AI agents)"
fi

if [ -d ".ai/howto" ]; then
  HOWTO_COUNT=$(find .ai/howto -name "*.md" | wc -l)
  if [ "$HOWTO_COUNT" -gt 0 ]; then
    check_pass "Found ${HOWTO_COUNT} how-to guide(s) in .ai/howto/"
  else
    check_warn "No how-to guides found in .ai/howto/"
  fi
else
  check_warn ".ai/howto/ directory missing"
fi

if [ -d ".ai/docs" ]; then
  DOCS_COUNT=$(find .ai/docs -name "*.md" | wc -l)
  if [ "$DOCS_COUNT" -gt 0 ]; then
    check_pass "Found ${DOCS_COUNT} documentation file(s) in .ai/docs/"
  else
    check_warn "No documentation files found in .ai/docs/"
  fi
else
  check_warn ".ai/docs/ directory missing"
fi

# ============================================================================
# Final Summary
# ============================================================================
print_header "Validation Summary"

TOTAL_CHECKS=$((VALIDATION_ERRORS + VALIDATION_WARNINGS))

if [ "$VALIDATION_ERRORS" -eq 0 ] && [ "$VALIDATION_WARNINGS" -eq 0 ]; then
  echo -e "${GREEN}✓ All validation checks passed!${NC}"
  echo ""
  echo "Your production-ready fullstack setup is complete and ready to use."
  echo ""
  echo "Backend Tools (9): Ruff, Pylint, Flake8+plugins, MyPy, Bandit, Radon, Xenon, Safety, pip-audit"
  echo "Frontend Tools (6): ESLint+plugins, TypeScript, Vitest, React Testing Library, Playwright, npm audit"
  echo ""
  echo "Next steps:"
  echo "  1. Run 'make lint-all' for thorough quality check"
  echo "  2. Run 'make test-all' to run all tests"
  echo "  3. Run 'make lint-full' for complete quality gate (all 15+ tools)"
  echo ""
  exit 0
elif [ "$VALIDATION_ERRORS" -eq 0 ]; then
  echo -e "${YELLOW}⚠ Validation completed with ${VALIDATION_WARNINGS} warning(s)${NC}"
  echo ""
  echo "Your setup is functional but has some optional components missing."
  echo "Review warnings above for details."
  echo ""
  exit 0
else
  echo -e "${RED}✗ Validation failed with ${VALIDATION_ERRORS} error(s) and ${VALIDATION_WARNINGS} warning(s)${NC}"
  echo ""
  echo "Please fix the errors above and run validation again."
  echo ""
  echo "Common fixes:"
  echo "  - Missing tools: Run 'make install' to install all dependencies"
  echo "  - Missing directories: Ensure you're in the project root directory"
  echo "  - Missing Makefile targets: Verify Makefile is from latest template"
  echo ""
  exit 1
fi
