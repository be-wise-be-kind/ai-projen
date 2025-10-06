# Rust Language Plugin - PR Breakdown

**Purpose**: Detailed implementation breakdown of Rust language plugin into manageable, atomic pull requests

**Scope**: Complete Rust plugin implementation from core setup through testing, security, and documentation tools

**Overview**: Comprehensive breakdown of the Rust language plugin feature into 8 manageable, atomic
    pull requests. Each PR is designed to be self-contained, testable, and maintains plugin functionality
    while incrementally building toward the complete Rust development environment. Includes detailed
    implementation steps, file structures, testing requirements, and success criteria for each PR.

**Dependencies**: Rust toolchain (rustup), Cargo, existing ai-projen plugin infrastructure

**Exports**: PR implementation plans, file structures, testing strategies, and success criteria for each development phase

**Related**: AI_CONTEXT.md for feature overview, PROGRESS_TRACKER.md for status tracking

**Implementation**: Atomic PR approach with detailed step-by-step implementation guidance and comprehensive testing validation

---

## Overview

This document breaks down the Rust language plugin into 8 manageable, atomic PRs. Each PR is designed to:
- Be self-contained and independently testable
- Maintain a working plugin at each stage
- Incrementally build toward the complete feature
- Be revertible if issues are discovered

**Total Scope**: 8 PRs across 4-6 weeks of development

---

## PR1: Core Rust Plugin - Project Structure & Cargo Setup

**Status**: 🔴 Not Started
**Estimated Effort**: 8-12 hours
**Complexity**: Medium
**Priority**: P0 (Required for all other PRs)

### Summary

Create the foundational Rust plugin that sets up project structure, installs Rust toolchain via rustup,
configures Cargo workspace, and provides basic Make targets for common Rust workflows.

### Goals

1. Establish plugin directory structure following ai-projen standards
2. Create AGENT_INSTRUCTIONS.md with Rust installation steps
3. Implement Cargo.toml template with workspace configuration
4. Create rust-toolchain.toml for version pinning
5. Add basic Makefile targets for Rust workflows
6. Ensure Rust toolchain installation via rustup

### File Structure

```
plugins/languages/rust/
├── core/
│   ├── AGENT_INSTRUCTIONS.md           # Installation instructions for AI agents
│   ├── README.md                       # Human documentation
│   ├── ai-content/
│   │   └── docs/
│   │       └── RUST_CORE_SETUP.md     # Core setup documentation
│   └── project-content/
│       ├── config/
│       │   ├── Cargo.toml.template    # Package manifest template
│       │   ├── rust-toolchain.toml.template  # Toolchain version pinning
│       │   └── .gitignore.rust        # Rust-specific gitignore patterns
│       └── makefiles/
│           └── Makefile.rust.core     # Core Make targets
```

### Implementation Steps

#### Step 1: Create Plugin Directory Structure

```bash
mkdir -p plugins/languages/rust/core/{ai-content/docs,project-content/{config,makefiles}}
```

#### Step 2: Create AGENT_INSTRUCTIONS.md

**Content**:
```markdown
# Rust Core Plugin - Agent Instructions

## Overview
This plugin installs the Rust toolchain via rustup, sets up Cargo workspace, and provides
basic project structure and Make targets for Rust development.

## Prerequisites
- Git repository initialized
- Make installed
- curl installed (for rustup installation)

## Step 1: Detect Existing State

Check if plugin is already installed:
```bash
HAS_RUST=false
HAS_CARGO_TOML=false

if [ -f "Cargo.toml" ]; then
  HAS_CARGO_TOML=true
fi

if command -v rustc &> /dev/null; then
  HAS_RUST=true
fi
```

## Step 2: Determine if Changes Needed

```bash
CHANGES_NEEDED=false

if [ "$HAS_CARGO_TOML" = false ]; then
  CHANGES_NEEDED=true
fi

if [ "$HAS_RUST" = false ]; then
  echo "Note: Rust not installed - will be installed via rustup"
  CHANGES_NEEDED=true
fi
```

## Step 3: Create Feature Branch

```bash
if [ "$CHANGES_NEEDED" = true ]; then
  CURRENT_BRANCH=$(git branch --show-current)
  if [[ "$CURRENT_BRANCH" == "main" ]] || [[ "$CURRENT_BRANCH" == "master" ]]; then
    git checkout -b "feature/add-rust-core"
  fi
else
  echo "Rust core plugin already installed"
  exit 0
fi
```

## Step 4: Install Rust Toolchain (if needed)

```bash
if [ "$HAS_RUST" = false ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
fi

# Verify installation
rustc --version
cargo --version
```

## Step 5: Install Project Files

```bash
# Copy Cargo.toml template
cp plugins/languages/rust/core/project-content/config/Cargo.toml.template ./Cargo.toml

# Ask user for project name
read -p "Enter project name: " PROJECT_NAME
sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" Cargo.toml

# Copy rust-toolchain.toml
cp plugins/languages/rust/core/project-content/config/rust-toolchain.toml.template ./rust-toolchain.toml

# Copy Rust gitignore patterns
cat plugins/languages/rust/core/project-content/config/.gitignore.rust >> .gitignore

# Copy Makefile
cat plugins/languages/rust/core/project-content/makefiles/Makefile.rust.core >> Makefile
```

## Step 6: Create Project Structure

```bash
mkdir -p src tests benches examples

# Create main.rs or lib.rs based on project type
read -p "Project type (binary/library): " PROJECT_TYPE
if [ "$PROJECT_TYPE" = "binary" ]; then
  echo 'fn main() { println!("Hello, world!"); }' > src/main.rs
else
  echo '// Add your library code here' > src/lib.rs
fi
```

## Step 7: Validate Installation

```bash
# Check project compiles
cargo check

# Verify Make targets work
make rust-check
make rust-build
```

## Success Criteria

- [ ] Rust toolchain installed and accessible (rustc, cargo)
- [ ] Cargo.toml exists with correct project name
- [ ] rust-toolchain.toml exists
- [ ] Rust gitignore patterns added
- [ ] Makefile targets added and functional
- [ ] `cargo check` runs successfully
- [ ] `make rust-check` works correctly
- [ ] Project structure created (src/, tests/, benches/)
```

#### Step 3: Create Cargo.toml.template

```toml
[package]
name = "{{PROJECT_NAME}}"
version = "0.1.0"
edition = "2021"
rust-version = "1.70.0"  # MSRV

[dependencies]

[dev-dependencies]

[profile.release]
overflow-checks = true  # Security best practice

[workspace]
members = []

# Lint configuration
[lints.rust]
unsafe_code = "forbid"

[lints.clippy]
# Will be configured by clippy plugin
```

#### Step 4: Create rust-toolchain.toml.template

```toml
[toolchain]
channel = "stable"
components = ["rustfmt", "clippy"]
profile = "minimal"
```

#### Step 5: Create .gitignore.rust

```
# Rust build artifacts
/target/
Cargo.lock  # Only for libraries - binaries should commit this

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

#### Step 6: Create Makefile.rust.core

```makefile
# Rust Core Targets

.PHONY: rust-check rust-build rust-build-release rust-clean rust-update rust-tree

rust-check:
	@echo "Running Rust type checking..."
	cargo check

rust-build:
	@echo "Building Rust project (debug)..."
	cargo build

rust-build-release:
	@echo "Building Rust project (release - optimized)..."
	cargo build --release

rust-clean:
	@echo "Cleaning Rust build artifacts..."
	cargo clean

rust-update:
	@echo "Updating Rust dependencies..."
	cargo update

rust-tree:
	@echo "Showing Rust dependency tree..."
	cargo tree
```

#### Step 7: Create README.md

Document what the plugin does, why it's needed, what gets installed, and how to use it.

### Validation

1. **Plugin Structure**:
   - All required files present
   - Follows ai-projen plugin structure standards

2. **Installation Test**:
   - Create test repository
   - Run AGENT_INSTRUCTIONS.md steps
   - Verify all files installed correctly

3. **Functional Test**:
   - `cargo check` runs successfully
   - `make rust-check` works
   - `make rust-build` produces binary/library
   - `make rust-clean` removes artifacts

4. **Integration Test**:
   - Works with existing ai-projen foundation plugin
   - Doesn't conflict with Python/TypeScript plugins
   - Makefile targets don't collide

### Success Criteria

- [ ] Plugin directory structure created
- [ ] AGENT_INSTRUCTIONS.md complete with all steps
- [ ] README.md documents plugin usage
- [ ] Cargo.toml template configured properly
- [ ] rust-toolchain.toml template works
- [ ] Makefile targets functional
- [ ] Rust toolchain installs via rustup
- [ ] `cargo check` validates project
- [ ] All tests pass

### Notes

- This PR establishes the foundation for all other Rust plugins
- Must be installed before any other Rust tool plugins
- Should work standalone (without other language plugins)

---

## PR2: Clippy Plugin - Linting Integration

**Status**: 🔴 Not Started
**Estimated Effort**: 4-6 hours
**Complexity**: Low
**Priority**: P0 (Core functionality)

### Summary

Add Clippy linter integration with configuration, Make targets, and documentation.

### Goals

1. Create Clippy plugin structure
2. Configure clippy.toml with recommended lints
3. Add Clippy Make targets
4. Document lint rules and configuration options
5. Integrate with pre-commit hooks

### File Structure

```
plugins/languages/rust/linters/clippy/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   └── docs/
│       └── CLIPPY_STANDARDS.md
└── project-content/
    ├── config/
    │   └── clippy.toml.template
    └── makefiles/
        └── Makefile.rust.clippy
```

### Implementation Steps

1. Create plugin directory structure
2. Write AGENT_INSTRUCTIONS.md with installation steps
3. Create clippy.toml with recommended configuration:
   ```toml
   # clippy.toml
   msrv = "1.70.0"
   cognitive-complexity-threshold = 30
   too-many-arguments-threshold = 8

   [lints.clippy]
   pedantic = "warn"
   cargo = "warn"
   ```
4. Create Makefile.rust.clippy:
   ```makefile
   rust-lint:
       cargo clippy

   rust-lint-ci:
       cargo clippy -- -D warnings

   rust-lint-fix:
       cargo clippy --fix
   ```
5. Create CLIPPY_STANDARDS.md documenting lint groups and rules
6. Write README.md

### Validation

- [ ] Clippy installed via `rustup component add clippy`
- [ ] `cargo clippy` runs successfully
- [ ] `make rust-lint` works
- [ ] `make rust-lint-ci` fails on warnings (correct for CI)
- [ ] Configuration file recognized by Clippy
- [ ] Documentation complete

### Success Criteria

- [ ] Plugin installs independently
- [ ] Clippy configuration applied
- [ ] Make targets functional
- [ ] Integration with core plugin successful
- [ ] Pre-commit hook ready (for standards plugin)

---

## PR3: rustfmt Plugin - Code Formatting

**Status**: 🔴 Not Started
**Estimated Effort**: 3-5 hours
**Complexity**: Low
**Priority**: P0 (Core functionality)

### Summary

Add rustfmt formatter integration with configuration, Make targets, and documentation.

### Goals

1. Create rustfmt plugin structure
2. Configure rustfmt.toml with project standards
3. Add rustfmt Make targets
4. Document formatting options
5. Integrate with pre-commit hooks

### File Structure

```
plugins/languages/rust/formatters/rustfmt/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   └── docs/
│       └── RUSTFMT_STANDARDS.md
└── project-content/
    ├── config/
    │   └── rustfmt.toml.template
    └── makefiles/
        └── Makefile.rust.rustfmt
```

### Implementation Steps

1. Create plugin directory structure
2. Write AGENT_INSTRUCTIONS.md
3. Create rustfmt.toml:
   ```toml
   max_width = 100
   hard_tabs = false
   tab_spaces = 4
   edition = "2021"
   ```
4. Create Makefile.rust.rustfmt:
   ```makefile
   rust-format:
       cargo fmt

   rust-format-check:
       cargo fmt -- --check
   ```
5. Create RUSTFMT_STANDARDS.md
6. Write README.md

### Validation

- [ ] rustfmt installed via `rustup component add rustfmt`
- [ ] `cargo fmt` formats code
- [ ] `make rust-format` works
- [ ] `make rust-format-check` validates formatting (CI mode)
- [ ] Configuration file recognized

### Success Criteria

- [ ] Plugin installs independently
- [ ] rustfmt configuration applied
- [ ] Make targets functional
- [ ] Integration with core and clippy plugins successful

---

## PR4: cargo-audit Plugin - Security Vulnerability Scanning

**Status**: 🔴 Not Started
**Estimated Effort**: 4-6 hours
**Complexity**: Medium
**Priority**: P1 (Security critical)

### Summary

Add cargo-audit integration for dependency vulnerability scanning with Make targets and CI integration.

### Goals

1. Create cargo-audit plugin structure
2. Install cargo-audit tool
3. Add security scanning Make targets
4. Document vulnerability scanning process
5. Integrate with GitHub Actions

### File Structure

```
plugins/languages/rust/security/cargo-audit/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   └── docs/
│       └── RUST_SECURITY_AUDIT.md
└── project-content/
    └── makefiles/
        └── Makefile.rust.audit
```

### Implementation Steps

1. Create plugin directory structure
2. Write AGENT_INSTRUCTIONS.md including:
   ```bash
   cargo install cargo-audit
   ```
3. Create Makefile.rust.audit:
   ```makefile
   rust-audit:
       cargo audit

   rust-audit-ci:
       cargo audit --deny warnings

   rust-audit-fix:
       cargo audit fix
   ```
4. Create RUST_SECURITY_AUDIT.md documentation
5. Write README.md

### Validation

- [ ] cargo-audit installed successfully
- [ ] `cargo audit` runs and reports vulnerabilities
- [ ] `make rust-audit` works
- [ ] `make rust-audit-ci` fails on vulnerabilities (CI mode)
- [ ] Documentation explains vulnerability remediation

### Success Criteria

- [ ] Plugin installs independently
- [ ] Security scanning functional
- [ ] Make targets work correctly
- [ ] Integration with GitHub Actions ready
- [ ] Documentation complete

---

## PR5: cargo-deny Plugin - Policy Enforcement

**Status**: 🔴 Not Started
**Estimated Effort**: 5-7 hours
**Complexity**: Medium
**Priority**: P1 (Security & compliance)

### Summary

Add cargo-deny integration for comprehensive dependency policy enforcement (security, licenses, bans, sources).

### Goals

1. Create cargo-deny plugin structure
2. Install cargo-deny tool
3. Configure deny.toml with policies
4. Add policy enforcement Make targets
5. Document policy configuration

### File Structure

```
plugins/languages/rust/security/cargo-deny/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   └── docs/
│       └── CARGO_DENY_POLICIES.md
└── project-content/
    ├── config/
    │   └── deny.toml.template
    └── makefiles/
        └── Makefile.rust.deny
```

### Implementation Steps

1. Create plugin directory structure
2. Write AGENT_INSTRUCTIONS.md including:
   ```bash
   cargo install cargo-deny
   ```
3. Create deny.toml.template:
   ```toml
   [advisories]
   vulnerability = "deny"
   unmaintained = "warn"

   [licenses]
   unlicensed = "deny"
   allow = ["MIT", "Apache-2.0", "BSD-3-Clause"]

   [bans]
   multiple-versions = "warn"

   [sources]
   unknown-registry = "deny"
   unknown-git = "deny"
   ```
4. Create Makefile.rust.deny:
   ```makefile
   rust-deny:
       cargo deny check

   rust-deny-advisories:
       cargo deny check advisories

   rust-deny-licenses:
       cargo deny check licenses

   rust-deny-bans:
       cargo deny check bans
   ```
5. Create CARGO_DENY_POLICIES.md documentation
6. Write README.md

### Validation

- [ ] cargo-deny installed
- [ ] `cargo deny check` runs successfully
- [ ] All policy checks (advisories, licenses, bans, sources) work
- [ ] Make targets functional
- [ ] Configuration file recognized

### Success Criteria

- [ ] Plugin installs independently
- [ ] Policy enforcement functional
- [ ] Make targets work correctly
- [ ] Integration with CI ready
- [ ] Documentation explains all policies

---

## PR6: cargo-nextest Plugin - Advanced Test Runner

**Status**: 🔴 Not Started
**Estimated Effort**: 5-7 hours
**Complexity**: Medium
**Priority**: P1 (Testing critical)

### Summary

Add cargo-nextest integration for fast, reliable test execution with better CI integration.

### Goals

1. Create cargo-nextest plugin structure
2. Install cargo-nextest tool
3. Configure nextest.toml for test execution
4. Add testing Make targets
5. Document testing best practices

### File Structure

```
plugins/languages/rust/testing/cargo-nextest/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   └── docs/
│       └── RUST_TESTING_GUIDE.md
└── project-content/
    ├── config/
    │   └── nextest.toml.template
    └── makefiles/
        └── Makefile.rust.nextest
```

### Implementation Steps

1. Create plugin directory structure
2. Write AGENT_INSTRUCTIONS.md including:
   ```bash
   cargo install cargo-nextest
   ```
3. Create nextest.toml.template:
   ```toml
   [profile.default]
   retries = 0

   [profile.ci]
   retries = 2
   slow-timeout = { period = "60s", terminate-after = 3 }
   failure-output = "immediate"
   ```
4. Create Makefile.rust.nextest:
   ```makefile
   rust-test:
       cargo nextest run

   rust-test-ci:
       cargo nextest run --profile ci

   rust-test-doc:
       cargo test --doc
   ```
5. Create RUST_TESTING_GUIDE.md with best practices
6. Write README.md

### Validation

- [ ] cargo-nextest installed
- [ ] `cargo nextest run` executes tests
- [ ] Configuration profiles work (default, ci)
- [ ] Make targets functional
- [ ] Faster than `cargo test` (verify speed improvement)

### Success Criteria

- [ ] Plugin installs independently
- [ ] Test execution functional
- [ ] CI profile configured correctly
- [ ] Make targets work
- [ ] Documentation explains testing strategies

---

## PR7: rustdoc Plugin - Documentation Generation

**Status**: 🔴 Not Started
**Estimated Effort**: 4-6 hours
**Complexity**: Low
**Priority**: P2 (Documentation)

### Summary

Add rustdoc integration for generating comprehensive code documentation with best practices.

### Goals

1. Create rustdoc plugin structure
2. Add documentation Make targets
3. Provide doc comment templates
4. Document rustdoc best practices
5. Configure doc tests

### File Structure

```
plugins/languages/rust/documentation/rustdoc/
├── AGENT_INSTRUCTIONS.md
├── README.md
├── ai-content/
│   ├── docs/
│   │   └── RUSTDOC_GUIDE.md
│   └── templates/
│       ├── function-doc-comment.template
│       └── module-doc-comment.template
└── project-content/
    └── makefiles/
        └── Makefile.rust.rustdoc
```

### Implementation Steps

1. Create plugin directory structure
2. Write AGENT_INSTRUCTIONS.md
3. Create Makefile.rust.rustdoc:
   ```makefile
   rust-doc:
       cargo doc --no-deps

   rust-doc-open:
       cargo doc --no-deps --open

   rust-doc-check:
       cargo test --doc
   ```
4. Create function-doc-comment.template:
   ```rust
   /// {{BRIEF_DESCRIPTION}}
   ///
   /// # Examples
   /// ```
   /// {{EXAMPLE_CODE}}
   /// ```
   ///
   /// # Errors
   /// {{ERROR_DESCRIPTION}}
   ///
   /// # Panics
   /// {{PANIC_DESCRIPTION}}
   ```
5. Create RUSTDOC_GUIDE.md with best practices
6. Write README.md

### Validation

- [ ] `cargo doc` generates documentation
- [ ] `make rust-doc-open` opens docs in browser
- [ ] Doc tests run with `cargo test --doc`
- [ ] Make targets functional
- [ ] Templates follow Rust API guidelines

### Success Criteria

- [ ] Plugin installs independently
- [ ] Documentation generation works
- [ ] Make targets functional
- [ ] Templates provided
- [ ] Best practices documented

---

## PR8: Update PLUGIN_MANIFEST.yaml & Integration Testing

**Status**: 🔴 Not Started
**Estimated Effort**: 6-8 hours
**Complexity**: Medium
**Priority**: P0 (Required for discovery)

### Summary

Update PLUGIN_MANIFEST.yaml with Rust plugin entries, create comprehensive integration tests,
and validate the complete Rust plugin system.

### Goals

1. Add Rust entry to PLUGIN_MANIFEST.yaml
2. Define plugin options and defaults
3. Create integration test suite
4. Validate all plugins work together
5. Test with other language plugins (Python, TypeScript)

### Implementation Steps

#### Step 1: Update PLUGIN_MANIFEST.yaml

Add Rust language plugin entry:

```yaml
languages:
  rust:
    status: stable
    description: Rust development environment with linting, formatting, security, and testing
    location: plugins/languages/rust/
    dependencies:
      - foundation/ai-folder

    options:
      rust_version:
        available: ["stable", "beta", "nightly", "1.70", "1.75", "1.80"]
        recommended: "stable"
        description: Rust toolchain version
        ask_user: false

      linter:
        available: [clippy]
        recommended: clippy
        description: Code linting
        note: Clippy is the official Rust linter with 600+ rules

      formatter:
        available: [rustfmt]
        recommended: rustfmt
        description: Code formatting
        note: rustfmt is the official Rust formatter

      security:
        available: [cargo-audit, cargo-deny, both, none]
        recommended: both
        description: Security vulnerability scanning
        note: cargo-audit for CVEs, cargo-deny for policies

      testing:
        available: [cargo-nextest, cargo-test]
        recommended: cargo-nextest
        description: Test runner
        note: nextest is 3x faster than cargo test

      documentation:
        available: [rustdoc, none]
        recommended: rustdoc
        description: Documentation generation

    philosophy:
      - "Use Cargo as the universal build tool"
      - "Type checking is mandatory (built into rustc)"
      - "rustfmt is the only standard formatter"
      - "Clippy is the recommended linter"
      - "MSRV (Minimum Supported Rust Version) should be declared"

    tools_provided:
      - name: Cargo
        purpose: Build system and package manager
        features: [compilation, dependencies, testing, publishing]

      - name: Clippy
        purpose: Linting
        rules: 600+ lint rules across 7 groups

      - name: rustfmt
        purpose: Code formatting
        features: [consistent style, RFC-compliant]

      - name: cargo-audit
        purpose: Security scanning
        detects: [CVEs in dependencies, yanked crates]

      - name: cargo-deny
        purpose: Policy enforcement
        features: [license compliance, dependency bans, source verification]

      - name: cargo-nextest
        purpose: Testing
        features: [3x faster, process-per-test, retry flaky tests]

      - name: rustdoc
        purpose: Documentation
        features: [doc comments, doc tests, HTML generation]

    installation_guide: plugins/languages/rust/core/AGENT_INSTRUCTIONS.md
```

#### Step 2: Create Integration Test Suite

Create `tests/integration/test_rust_plugin.sh`:

```bash
#!/bin/bash
set -e

# Test Rust plugin installation in isolation
echo "Testing Rust plugin installation..."

# Create test repository
TEST_DIR=$(mktemp -d)
cd $TEST_DIR
git init

# Install foundation plugin first
# (assuming foundation plugin is already tested)

# Install Rust core plugin
echo "Installing Rust core plugin..."
# Follow AGENT_INSTRUCTIONS.md steps

# Verify core plugin
cargo check
make rust-check
make rust-build

# Install Clippy plugin
echo "Installing Clippy plugin..."
# Follow clippy AGENT_INSTRUCTIONS.md

# Verify Clippy
make rust-lint

# Install rustfmt plugin
echo "Installing rustfmt plugin..."
# Follow rustfmt AGENT_INSTRUCTIONS.md

# Verify rustfmt
make rust-format
make rust-format-check

# Install security plugins
echo "Installing security plugins..."
# Install cargo-audit and cargo-deny

# Verify security
make rust-audit
make rust-deny

# Install testing plugin
echo "Installing cargo-nextest plugin..."
# Follow nextest AGENT_INSTRUCTIONS.md

# Verify testing
make rust-test

# Install rustdoc plugin
echo "Installing rustdoc plugin..."
# Follow rustdoc AGENT_INSTRUCTIONS.md

# Verify documentation
make rust-doc

# Cleanup
cd -
rm -rf $TEST_DIR

echo "All Rust plugin tests passed!"
```

#### Step 3: Test Multi-Language Integration

Create `tests/integration/test_rust_python_combo.sh`:

```bash
#!/bin/bash
# Test Rust + Python in same repository

# Create test repo
# Install foundation plugin
# Install Python core + plugins
# Install Rust core + plugins
# Verify both work without conflicts
# Verify Makefile targets don't collide
```

#### Step 4: Validation Checklist

- [ ] PLUGIN_MANIFEST.yaml validates (YAML syntax)
- [ ] All plugin paths exist
- [ ] All AGENT_INSTRUCTIONS.md files present
- [ ] All README.md files present
- [ ] Integration tests pass
- [ ] Multi-language tests pass
- [ ] Documentation complete

### Success Criteria

- [ ] PLUGIN_MANIFEST.yaml updated correctly
- [ ] All plugins discoverable via manifest
- [ ] Integration tests pass (all plugins together)
- [ ] Multi-language tests pass (Rust + Python, Rust + TypeScript)
- [ ] No conflicts between plugins
- [ ] Documentation complete and accurate

### Notes

- This PR ties together all previous PRs
- Must pass comprehensive testing before merge
- Serves as final validation of complete Rust plugin system

---

## Implementation Guidelines

### Code Standards

1. **File Headers**: All files must have headers per FILE_HEADER_STANDARDS.md
2. **Markdown**: Follow ai-projen markdown standards
3. **YAML**: Validate all YAML files before committing
4. **Makefiles**: Use tabs, not spaces; follow ai-projen naming conventions

### Testing Requirements

1. **Plugin Independence**: Each plugin must install and work standalone
2. **Integration**: All plugins must work together without conflicts
3. **Multi-Language**: Must coexist with Python and TypeScript plugins
4. **Validation**: All Make targets must work correctly

### Documentation Standards

1. **AGENT_INSTRUCTIONS.md**:
   - Prerequisites clearly stated
   - State detection step included
   - Branching step included (PLUGIN_GIT_WORKFLOW_STANDARD.md)
   - Step-by-step installation instructions
   - Validation steps with success criteria

2. **README.md**:
   - What the plugin does
   - Why it's needed
   - What gets installed
   - How to install standalone
   - How to customize
   - Integration points

3. **How-to Guides**:
   - Follow HOWTO_STANDARDS.md
   - Include examples
   - Provide clear success criteria

### Progress Tracking Standards

After completing each PR:
1. **Record commit hash in PROGRESS_TRACKER.md**:
   - Get the short commit hash: `git log --oneline -1`
   - Add to Notes column in PR Status Dashboard
   - Format: "Brief description (commit abc1234)"
   - Example: "Rust core plugin added (commit a1b2c3d)"
2. This creates a clear audit trail of when each PR was completed
3. Makes it easy to reference specific changes or revert if needed

### Security Considerations

1. **Dependency Scanning**: All dependencies scanned for vulnerabilities
2. **Supply Chain**: Only use crates.io packages (no arbitrary git dependencies)
3. **Tool Verification**: Verify tool integrity before installation
4. **Secrets**: No hardcoded secrets in templates or configs

### Performance Targets

1. **Installation Time**: Core plugin < 5 minutes (including rustup installation)
2. **Compilation Time**: `cargo check` < 5 seconds for small projects
3. **CI Time**: Full CI pipeline < 10 minutes with caching
4. **Test Execution**: cargo-nextest 3x faster than cargo test

## Rollout Strategy

### Phase 1: Core Foundation (PR1-3)
**Duration**: 2 weeks
**PRs**: PR1 (Core), PR2 (Clippy), PR3 (rustfmt)

**Deliverables**:
- Basic Rust project setup
- Linting and formatting functional
- Make targets working

**Validation**:
- Can create new Rust project from scratch
- Code quality tools functional

### Phase 2: Security & Testing (PR4-6)
**Duration**: 2 weeks
**PRs**: PR4 (cargo-audit), PR5 (cargo-deny), PR6 (cargo-nextest)

**Deliverables**:
- Security scanning operational
- Testing infrastructure complete
- CI integration ready

**Validation**:
- Security vulnerabilities detected and reported
- Tests run reliably and fast
- CI pipeline functional

### Phase 3: Documentation & Integration (PR7-8)
**Duration**: 1-2 weeks
**PRs**: PR7 (rustdoc), PR8 (Manifest & Integration)

**Deliverables**:
- Documentation generation working
- Complete plugin system integrated
- Multi-language support validated

**Validation**:
- All plugins work together
- Documentation comprehensive
- Ready for production use

## Success Metrics

### Launch Metrics

1. **Plugin Completeness**:
   - ✓ All 8 PRs merged
   - ✓ All plugins independently installable
   - ✓ PLUGIN_MANIFEST.yaml complete

2. **Quality Metrics**:
   - ✓ All integration tests pass
   - ✓ Multi-language tests pass
   - ✓ Documentation complete
   - ✓ No known bugs

3. **Performance Metrics**:
   - ✓ Installation time < 5 minutes
   - ✓ CI time < 10 minutes (with caching)
   - ✓ Test execution 3x faster with nextest

### Ongoing Metrics

1. **Adoption**:
   - Number of projects using Rust plugin
   - Feedback from users
   - Bug reports and resolution rate

2. **Maintenance**:
   - Tool version updates applied
   - Rust version compatibility maintained
   - Documentation kept current

3. **Expansion**:
   - Additional Rust tools added
   - Rust-specific application plugins created
   - Community contributions
