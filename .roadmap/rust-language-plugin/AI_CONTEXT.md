# Rust Language Plugin - AI Context

**Purpose**: AI agent context document for implementing Rust language plugin for ai-projen

**Scope**: Complete Rust development environment with linting, formatting, type checking, security scanning, testing, and documentation tools

**Overview**: Comprehensive context document for AI agents working on the Rust language plugin feature.
    This plugin provides a production-ready Rust development environment with industry-standard tooling
    including Cargo (package management), Clippy (linting), rustfmt (formatting), cargo-audit (security),
    cargo-nextest (testing), and rustdoc (documentation). Follows the ai-projen plugin architecture with
    modular components organized by tool category (core, linters, formatters, security, testing).

**Dependencies**: Rust toolchain via rustup, Cargo, plugins/languages/_template/, PLUGIN_MANIFEST.yaml

**Exports**: Complete Rust language plugin with installation instructions, configuration templates,
    Make targets, CI/CD integration, and how-to guides

**Related**: PR_BREAKDOWN.md for implementation tasks, PROGRESS_TRACKER.md for current status,
    plugins/languages/python/ for reference implementation, plugins/languages/_template/ for structure

**Implementation**: Atomic PR approach following PLUGIN_GIT_WORKFLOW_STANDARD.md with comprehensive
    testing and validation at each phase

---

## Overview

The Rust language plugin provides a complete, production-ready Rust development environment for
ai-projen repositories. Similar to the Python plugin, it follows a modular architecture where each
tool (Clippy, rustfmt, cargo-audit, etc.) is a separate sub-plugin that can be composed together.

**Key Difference from Python**: Rust's type checking is built into the compiler (rustc), so there's
no separate type checker component like MyPy for Python. Type safety is guaranteed at compile time.

## Project Background

**Current State**: ai-projen has stable Python and TypeScript language plugins, but no Rust support.

**Gap**: Teams wanting to build AI-ready Rust projects (CLIs, web servers, system tools) cannot use
ai-projen to bootstrap their repositories with Rust best practices.

**Opportunity**: Rust is increasingly popular for performance-critical applications, infrastructure
tools, and WebAssembly. Adding Rust support enables ai-projen to serve this growing community.

## Feature Vision

1. **Complete Rust Development Environment**
   - Cargo workspace setup with proper project structure
   - All essential development tools installed and configured
   - Make targets for common Rust workflows
   - Pre-commit hooks integration

2. **Industry Best Practices**
   - Based on 2025 Rust ecosystem standards
   - Cargo as the build system and package manager
   - Clippy for comprehensive linting (600+ lint rules)
   - rustfmt for consistent code formatting
   - cargo-audit and cargo-deny for security scanning
   - cargo-nextest for fast, reliable testing
   - rustdoc for documentation generation

3. **AI-Ready Patterns**
   - Clear success criteria for all operations
   - Deterministic installation and validation
   - Comprehensive how-to guides for common tasks
   - Integration with ai-projen standards plugins

4. **Modular Architecture**
   - Core plugin: Cargo setup, project structure, basic Makefile targets
   - Linters: Clippy (primary), optional additional linters
   - Formatters: rustfmt (official formatter)
   - Security: cargo-audit, cargo-deny, cargo-geiger
   - Testing: cargo-nextest, proptest (property testing), criterion (benchmarking)
   - Documentation: rustdoc with best practices

## Current Application Context

**ai-projen Framework**: Plugin-based system for creating AI-ready repositories

**Existing Language Plugins**:
- Python: Poetry + Ruff + MyPy + Bandit + Pytest
- TypeScript: npm/pnpm + ESLint + Prettier + Vitest

**Plugin Structure** (consistent across all language plugins):
```
plugins/languages/{language}/
├── core/                       # Core language setup
│   ├── AGENT_INSTRUCTIONS.md
│   ├── README.md
│   └── project-content/
│       ├── config/
│       └── makefiles/
├── linters/{tool}/            # Tool-specific linters
├── formatters/{tool}/         # Tool-specific formatters
├── security/{tool}/           # Security scanning tools
├── testing/{framework}/       # Testing frameworks
└── analysis/{tool}/           # Code analysis tools (optional)
```

## Target Architecture

### Core Components

#### 1. Core Plugin (`plugins/languages/rust/core/`)
**Responsibilities**:
- Install Rust via rustup (if not present)
- Create Cargo.toml with workspace configuration
- Setup basic project structure (`src/`, `tests/`, `benches/`)
- Create Makefile with common Rust targets
- Configure rust-toolchain.toml for version pinning

**Files Installed**:
- `Cargo.toml` - Package manifest
- `rust-toolchain.toml` - Toolchain specification
- `Makefile` - Common workflow targets
- `.gitignore` - Rust-specific ignore patterns

**Make Targets**:
```makefile
rust-check:        # Fast type checking (cargo check)
rust-build:        # Build project (cargo build)
rust-build-release: # Optimized build (cargo build --release)
rust-clean:        # Clean build artifacts (cargo clean)
rust-update:       # Update dependencies (cargo update)
rust-tree:         # Show dependency tree (cargo tree)
```

**Success Criteria**:
- Rust toolchain installed and accessible
- `cargo check` runs successfully
- `cargo build` completes without errors
- Makefile targets work correctly

#### 2. Clippy Plugin (`plugins/languages/rust/linters/clippy/`)
**Responsibilities**:
- Install clippy via rustup component
- Configure clippy.toml with recommended lints
- Add clippy Make targets
- Document lint configuration options

**Files Installed**:
- `clippy.toml` - Clippy configuration
- `.ai/docs/CLIPPY_STANDARDS.md` - Lint rules documentation

**Make Targets**:
```makefile
rust-lint:         # Run clippy (cargo clippy)
rust-lint-ci:      # Run clippy with -D warnings (CI mode)
rust-lint-fix:     # Auto-fix clippy suggestions (cargo clippy --fix)
```

**Default Configuration**:
```toml
# clippy.toml
msrv = "1.70.0"  # Minimum supported Rust version
cognitive-complexity-threshold = 30
too-many-arguments-threshold = 8

[lints.clippy]
pedantic = "warn"
cargo = "warn"
```

**Success Criteria**:
- Clippy installed and accessible
- `cargo clippy` runs successfully
- Configuration file recognized
- Make targets work correctly

#### 3. rustfmt Plugin (`plugins/languages/rust/formatters/rustfmt/`)
**Responsibilities**:
- Install rustfmt via rustup component
- Configure rustfmt.toml with project standards
- Add format Make targets
- Document formatting options

**Files Installed**:
- `rustfmt.toml` - rustfmt configuration
- `.ai/docs/RUSTFMT_STANDARDS.md` - Formatting standards

**Make Targets**:
```makefile
rust-format:       # Format code (cargo fmt)
rust-format-check: # Check formatting (cargo fmt -- --check)
```

**Default Configuration**:
```toml
# rustfmt.toml
max_width = 100
hard_tabs = false
tab_spaces = 4
edition = "2021"
```

**Success Criteria**:
- rustfmt installed and accessible
- `cargo fmt` runs successfully
- `cargo fmt -- --check` validates formatting
- Make targets work correctly

#### 4. Security Plugins

##### A. cargo-audit (`plugins/languages/rust/security/cargo-audit/`)
**Responsibilities**:
- Install cargo-audit tool
- Configure audit settings
- Add security audit Make targets
- Document vulnerability scanning process

**Make Targets**:
```makefile
rust-audit:        # Audit dependencies (cargo audit)
rust-audit-ci:     # Audit with --deny warnings (CI mode)
rust-audit-fix:    # Auto-update vulnerable deps (cargo audit fix)
```

**Success Criteria**:
- cargo-audit installed
- `cargo audit` runs successfully
- No known vulnerabilities in dependencies (or documented exceptions)

##### B. cargo-deny (`plugins/languages/rust/security/cargo-deny/`)
**Responsibilities**:
- Install cargo-deny tool
- Configure deny.toml with security/license policies
- Add policy enforcement Make targets
- Document policy configuration

**Files Installed**:
- `deny.toml` - Policy configuration

**Make Targets**:
```makefile
rust-deny:         # Check all policies (cargo deny check)
rust-deny-advisories: # Security vulnerabilities only
rust-deny-licenses:   # License compliance only
rust-deny-bans:       # Banned dependencies check
```

**Default Configuration**:
```toml
# deny.toml
[advisories]
vulnerability = "deny"
unmaintained = "warn"

[licenses]
unlicensed = "deny"
allow = ["MIT", "Apache-2.0", "BSD-3-Clause"]

[bans]
multiple-versions = "warn"
```

**Success Criteria**:
- cargo-deny installed
- All policy checks pass
- Configuration file recognized

#### 5. Testing Plugins

##### A. cargo-nextest (`plugins/languages/rust/testing/cargo-nextest/`)
**Responsibilities**:
- Install cargo-nextest test runner
- Configure nextest.toml for test execution
- Add testing Make targets
- Document testing best practices

**Files Installed**:
- `nextest.toml` - Test configuration
- `.ai/docs/RUST_TESTING_GUIDE.md` - Testing best practices

**Make Targets**:
```makefile
rust-test:         # Run tests (cargo nextest run)
rust-test-ci:      # Run tests with retries (CI mode)
rust-test-coverage: # Generate coverage report
```

**Default Configuration**:
```toml
# nextest.toml
[profile.default]
retries = 0

[profile.ci]
retries = 2
slow-timeout = { period = "60s", terminate-after = 3 }
```

**Success Criteria**:
- cargo-nextest installed
- `cargo nextest run` executes successfully
- Test failures reported clearly
- Coverage reports generated

##### B. Criterion (Optional - Benchmarking)
**Make Targets**:
```makefile
rust-bench:        # Run benchmarks (cargo bench)
```

#### 6. Documentation Plugin (`plugins/languages/rust/documentation/rustdoc/`)
**Responsibilities**:
- Configure rustdoc settings
- Add documentation Make targets
- Provide doc comment templates
- Document rustdoc best practices

**Make Targets**:
```makefile
rust-doc:          # Generate docs (cargo doc)
rust-doc-open:     # Generate and open docs (cargo doc --open)
rust-doc-check:    # Check doc tests (cargo test --doc)
```

**Files Installed**:
- `.ai/docs/RUSTDOC_GUIDE.md` - Documentation best practices
- `.ai/templates/rust-doc-comment.template` - Doc comment template

**Success Criteria**:
- `cargo doc` generates documentation
- Doc tests run successfully
- Documentation opens in browser

### User Journey

**Scenario**: Developer wants to create a new Rust CLI application using ai-projen

1. **Initialize Repository**:
   ```bash
   # User runs ai-projen orchestrator
   # Selects "Create new AI-ready repository"
   # Chooses Rust as primary language
   ```

2. **Core Installation**:
   - Core Rust plugin detects Rust toolchain (installs via rustup if missing)
   - Creates Cargo.toml with workspace configuration
   - Sets up project structure (src/, tests/, benches/)
   - Creates Makefile with basic targets

3. **Tool Selection** (Interactive):
   ```
   Select Rust linters:
   [x] Clippy (recommended)
   [ ] Additional linters

   Select Rust formatters:
   [x] rustfmt (standard)

   Select security tools:
   [x] cargo-audit (recommended)
   [x] cargo-deny (recommended)
   [ ] cargo-geiger

   Select testing frameworks:
   [x] cargo-nextest (recommended)
   [ ] Proptest (property testing)
   [ ] Criterion (benchmarking)
   ```

4. **Installation Execution**:
   - Each selected plugin installs sequentially
   - Validates installation after each plugin
   - Adds Make targets incrementally
   - Updates .gitignore and other shared files

5. **Validation**:
   ```bash
   # Orchestrator runs validation
   make rust-check        # ✓ Type checking passes
   make rust-format-check # ✓ Formatting valid
   make rust-lint         # ✓ No lint errors
   make rust-audit        # ✓ No vulnerabilities
   make rust-test         # ✓ Tests pass (or no tests yet)
   ```

6. **Developer Workflow** (Post-installation):
   ```bash
   # Development cycle
   make rust-check        # Fast feedback during development
   make rust-test         # Run tests
   make rust-format       # Format code
   make rust-lint         # Check lints

   # Pre-commit (automated via pre-commit hooks)
   make rust-format
   make rust-lint

   # CI/CD (automated)
   make rust-format-check
   make rust-lint-ci
   make rust-test-ci
   make rust-audit-ci
   ```

### Integration with ai-projen Standards

**Pre-commit Hooks Plugin** (`plugins/standards/pre-commit-hooks/`):
- Adds Rust-specific hooks to `.pre-commit-config.yaml`
- Runs rustfmt before commits
- Runs clippy before commits
- Prevents commits with lint errors

**Example `.pre-commit-config.yaml` additions**:
```yaml
repos:
  - repo: local
    hooks:
      - id: rust-fmt
        name: rust-fmt
        entry: make rust-format
        language: system
        files: \.rs$
        pass_filenames: false

      - id: rust-clippy
        name: rust-clippy
        entry: make rust-lint-ci
        language: system
        files: \.rs$
        pass_filenames: false
```

**GitHub Actions Plugin** (`plugins/infrastructure/ci-cd/github-actions/`):
- Adds Rust-specific workflow or extends existing workflow
- Caches cargo registry and target directory (critical for speed)
- Runs full test suite, linting, security checks
- Generates coverage reports

**Example `.github/workflows/rust.yml`**:
```yaml
name: Rust CI

on: [push, pull_request]

env:
  CARGO_TERM_COLOR: always

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - uses: Swatinem/rust-cache@v2

      - name: Check
        run: make rust-check

      - name: Format
        run: make rust-format-check

      - name: Clippy
        run: make rust-lint-ci

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - uses: Swatinem/rust-cache@v2

      - uses: taiki-e/install-action@nextest
      - name: Test
        run: make rust-test-ci

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: EmbarkStudios/cargo-deny-action@v1
      - uses: actions-rs/audit-check@v1
```

**Docker Plugin** (`plugins/infrastructure/containerization/docker/`):
- Provides Rust-specific Dockerfile template
- Multi-stage builds for minimal image size
- Cargo caching for faster builds

**Example Dockerfile.rust.template**:
```dockerfile
# Build stage
FROM rust:1.75 as builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
# Cache dependencies
RUN mkdir src && echo "fn main() {}" > src/main.rs && cargo build --release && rm -rf src
COPY src ./src
RUN cargo build --release

# Runtime stage
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/myapp /usr/local/bin/myapp
CMD ["myapp"]
```

## Key Decisions Made

### 1. Cargo as Primary Build System
**Decision**: Use Cargo exclusively, no alternative build systems

**Rationale**:
- Cargo is the official, universally-adopted build tool for Rust
- Unlike Python (Poetry vs pip vs pipenv), Rust ecosystem has converged on Cargo
- Cargo handles building, dependencies, testing, documentation, and publishing
- No fragmentation means simpler plugin architecture

**Implications**:
- No "build system" option in plugin manifest (always Cargo)
- Simplified installation process
- Consistent tooling across all Rust projects

### 2. rustfmt as Only Formatter
**Decision**: rustfmt is the only formatter plugin

**Rationale**:
- rustfmt is the official Rust formatter
- Unlike Python (Black, Blue, YAPF, autopep8), Rust has one standard formatter
- Community consensus around rustfmt eliminates choice paralysis
- Follows Rust's philosophy of "one obvious way to do it"

**Implications**:
- No formatter selection needed
- No formatters subdirectory structure (just `formatters/rustfmt/`)
- Simpler plugin manifest

### 3. Clippy as Primary Linter
**Decision**: Clippy is the primary and recommended linter

**Rationale**:
- Clippy is the official Rust linter (600+ lint rules)
- Integrated with Rust toolchain via rustup
- Unlike Python (Ruff, Pylint, Flake8), Rust ecosystem has standardized on Clippy
- Other linters exist but are specialty tools, not general-purpose

**Implications**:
- Clippy plugin is always recommended
- `linters/` directory exists for extensibility but Clippy is primary
- Simpler plugin manifest (fewer options)

### 4. No Type Checker Plugin
**Decision**: Do NOT create a separate type checking plugin

**Rationale**:
- Rust's type system is enforced by the compiler (rustc)
- Type checking is mandatory, not optional (unlike Python's MyPy)
- No runtime type errors possible in safe Rust
- `cargo check` is the type checking command (built into core plugin)

**Implications**:
- No `type-checking/` subdirectory
- Type checking covered by core plugin's `rust-check` target
- Documentation emphasizes this difference from Python

### 5. Multiple Security Tools
**Decision**: Provide cargo-audit, cargo-deny, and cargo-geiger as separate plugins

**Rationale**:
- Each tool serves different purposes:
  - cargo-audit: Vulnerability scanning (analogous to Safety/Bandit for Python)
  - cargo-deny: Policy enforcement (licenses, bans, sources)
  - cargo-geiger: Unsafe code detection (unique to Rust)
- Users may want some but not all
- Modular approach allows granular selection

**Implications**:
- `security/` subdirectory with multiple plugins
- cargo-audit recommended for all projects
- cargo-deny recommended for production projects
- cargo-geiger optional (for security-critical projects)

### 6. cargo-nextest as Test Runner
**Decision**: cargo-nextest is the recommended test runner (not built-in `cargo test`)

**Rationale**:
- cargo-nextest is 3x faster than `cargo test` (process-per-test isolation)
- Better CI integration (XML/JSON output, retries for flaky tests)
- Drop-in replacement for `cargo test` (easy migration)
- Industry adoption is strong (used by major Rust projects)

**Implications**:
- Core plugin installs cargo-nextest
- Make targets use `cargo nextest run` not `cargo test`
- Documentation explains differences from built-in test runner
- Fallback to `cargo test` if nextest unavailable

### 7. MSRV Declaration
**Decision**: Require minimum supported Rust version (MSRV) declaration in Cargo.toml

**Rationale**:
- MSRV is critical for library compatibility
- Increasing MSRV is a breaking change (SemVer)
- Cargo 2024 resolver can enforce MSRV in dependencies
- Best practice in Rust ecosystem

**Implications**:
- Core plugin creates Cargo.toml with `rust-version` field
- Default MSRV: 1.70.0 (conservative but not ancient)
- Clippy configured to respect MSRV
- CI tests against MSRV version

### 8. Task Runner Choice
**Decision**: Integrate with Makefiles (ai-projen standard) rather than cargo-make/just

**Rationale**:
- Consistency with other ai-projen language plugins (Python, TypeScript use Make)
- Makefile is cross-language (supports polyglot projects)
- cargo-make would add another tool dependency
- Make targets can wrap Cargo commands effectively

**Implications**:
- All Rust commands exposed via Make targets (`make rust-*`)
- Documentation shows Cargo equivalents for direct use
- Optional: Provide cargo-make configuration template in how-to guide

## Integration Points

### With Existing Features

#### 1. Foundation Plugin (`plugins/foundation/ai-folder/`)
**Integration**:
- Rust plugin adds files to `.ai/docs/` (CLIPPY_STANDARDS.md, RUSTFMT_STANDARDS.md, etc.)
- Rust plugin adds how-to guides to `.ai/howtos/` (how-to-add-rust-dependency.md, etc.)
- Rust plugin assumes `.ai/` directory structure exists

**Dependency**: Foundation plugin must be installed first

#### 2. Standards Plugins
**Pre-commit Hooks** (`plugins/standards/pre-commit-hooks/`):
- Rust plugins add hooks to `.pre-commit-config.yaml`
- Hooks run rustfmt and clippy before commits

**Security Standards** (`plugins/standards/security/`):
- Integrates cargo-audit into security scanning workflow
- May extend security documentation with Rust-specific guidance

**Documentation Standards** (`plugins/standards/documentation/`):
- Rustdoc standards align with file header requirements
- Doc comment templates follow documentation standards

#### 3. Infrastructure Plugins
**Docker** (`plugins/infrastructure/containerization/docker/`):
- Rust Dockerfile template uses multi-stage builds
- Optimized for Rust binary size and build caching

**GitHub Actions** (`plugins/infrastructure/ci-cd/github-actions/`):
- Rust workflow integrates with existing CI pipeline
- Shares caching strategies with other languages

**Terraform AWS** (`plugins/infrastructure/iac/terraform-aws/`):
- Rust binaries can be deployed to ECS/Lambda
- May need Rust-specific deployment configuration

### Language Plugin Composition

**Python + Rust** (Example: FastAPI backend + Rust compute module):
- Both plugins coexist in same repository
- Separate Makefile sections (`make python-*`, `make rust-*`)
- Shared standards plugins (pre-commit, security, documentation)
- Dockerfile may include both Python and Rust build stages

**TypeScript + Rust** (Example: React frontend + Rust WASM backend):
- Both languages in same monorepo
- Rust compiled to WebAssembly for browser
- Shared CI/CD pipeline
- Docker may package both TypeScript and Rust artifacts

## Success Metrics

### Technical Metrics

1. **Plugin Installation Success Rate**
   - ✓ Core plugin installs without errors
   - ✓ All selected tool plugins install successfully
   - ✓ Make targets work correctly
   - ✓ Validation passes after installation

2. **Tool Coverage**
   - ✓ Linting: Clippy with 600+ lint rules
   - ✓ Formatting: rustfmt with consistent style
   - ✓ Security: cargo-audit + cargo-deny detecting vulnerabilities
   - ✓ Testing: cargo-nextest running tests 3x faster
   - ✓ Documentation: rustdoc generating comprehensive docs

3. **Performance**
   - ✓ `cargo check` completes in < 5s for small projects
   - ✓ CI pipeline with caching completes in < 10 minutes
   - ✓ Incremental builds 10x faster than full rebuilds

4. **Compatibility**
   - ✓ Works with Rust 1.70+ (MSRV)
   - ✓ Cross-platform (Linux, macOS, Windows)
   - ✓ Integrates with existing ai-projen plugins

### Feature Metrics

1. **Developer Experience**
   - ✓ Zero-to-coding in < 10 minutes (installation time)
   - ✓ Clear error messages from all tools
   - ✓ Comprehensive how-to guides available
   - ✓ Pre-commit hooks catch issues before CI

2. **Code Quality**
   - ✓ No Clippy warnings in default configuration
   - ✓ Consistent code formatting across project
   - ✓ No known security vulnerabilities
   - ✓ 80%+ test coverage (when tests exist)

3. **CI/CD Integration**
   - ✓ GitHub Actions workflow runs successfully
   - ✓ Caching reduces CI time by 70%+
   - ✓ Security scans run on every PR
   - ✓ Documentation published to docs.rs (for libraries)

## Technical Constraints

1. **Rust Toolchain Requirement**
   - Minimum Rust version: 1.70.0 (Debian stable compatibility)
   - Must work with both stable and nightly channels
   - rustup must be available for component installation

2. **Platform Compatibility**
   - Must work on Linux (Ubuntu 20.04+, Debian 11+)
   - Must work on macOS (10.15+)
   - Should work on Windows (WSL2 or native)
   - May have platform-specific tool limitations (e.g., tarpaulin Linux-only)

3. **Tool Availability**
   - All tools must be installable via `cargo install` or `rustup component add`
   - No proprietary tools (all open-source)
   - Tools must be actively maintained (no abandoned projects)

4. **Plugin Independence**
   - Each tool plugin must work standalone (without other Rust plugins)
   - Must not conflict with existing language plugins (Python, TypeScript)
   - Must follow ai-projen plugin architecture standards

5. **Makefile Integration**
   - All Rust commands must be namespaced (`rust-*`)
   - Must not conflict with existing Make targets
   - Must work with `make -j` (parallel execution)

## AI Agent Guidance

### When Installing Core Plugin

1. **Check Rust Toolchain**:
   ```bash
   # Check if Rust is installed
   if command -v rustc &> /dev/null; then
     echo "Rust already installed: $(rustc --version)"
   else
     echo "Installing Rust via rustup..."
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
     source $HOME/.cargo/env
   fi
   ```

2. **Create Cargo.toml**:
   - Use workspace structure for multi-crate projects
   - Set MSRV to 1.70.0 (or user's preference)
   - Include recommended metadata fields

3. **Setup Project Structure**:
   ```
   src/
     lib.rs or main.rs (depending on library vs binary)
   tests/
     integration_tests.rs
   benches/
     benchmarks.rs
   examples/
     example.rs
   ```

4. **Validation**:
   - Run `cargo check` to verify project builds
   - Run `cargo build` to ensure compilation works
   - Verify Make targets are functional

### When Installing Tool Plugins

1. **Install Tool**:
   ```bash
   # For rustup components (clippy, rustfmt)
   rustup component add clippy rustfmt

   # For cargo plugins
   cargo install cargo-nextest cargo-audit cargo-deny
   ```

2. **Create Configuration**:
   - Use recommended defaults from research
   - Document all configuration options
   - Provide examples in how-to guides

3. **Add Make Targets**:
   - Follow naming convention: `rust-{action}`
   - Support both developer and CI modes
   - Include help text in Makefile

4. **Validation**:
   - Run tool command directly
   - Run via Make target
   - Verify output is as expected

### When Integrating with Standards

1. **Pre-commit Hooks**:
   - Add Rust hooks to existing `.pre-commit-config.yaml`
   - Use Make targets (not direct cargo commands) for consistency
   - Test hooks run correctly

2. **GitHub Actions**:
   - Use established Rust actions (dtolnay/rust-toolchain, Swatinem/rust-cache)
   - Configure caching for optimal CI speed
   - Run security scans on every PR

3. **Docker**:
   - Use multi-stage builds (builder + runtime)
   - Minimize image size (use slim/alpine base)
   - Cache dependencies for faster builds

### Common Patterns

1. **Error Handling**:
   - Rust errors are verbose and helpful - preserve them
   - Don't suppress compiler output
   - Guide users to Rust documentation for complex errors

2. **Dependency Management**:
   - Use `cargo add` (modern) not manual Cargo.toml editing
   - Prefer crates.io packages (avoid git dependencies in production)
   - Lock versions with Cargo.lock (commit for binaries, gitignore for libraries)

3. **Testing**:
   - Organize tests in `#[cfg(test)]` modules for unit tests
   - Use `tests/` directory for integration tests
   - Use `benches/` for benchmarks (not in main source)

4. **Documentation**:
   - Use `///` for outer doc comments (functions, structs)
   - Use `//!` for inner doc comments (modules, crates)
   - Include at least one code example per public function

## Risk Mitigation

1. **Risk**: Rust installation fails on older systems
   - **Mitigation**: Document minimum OS versions, provide manual installation steps
   - **Fallback**: Detect failure and provide clear error message with resolution steps

2. **Risk**: Tool installation via `cargo install` is slow
   - **Mitigation**: Cache installed tools, detect if already installed before attempting
   - **Alternative**: Use binary releases from GitHub (faster than compiling)

3. **Risk**: Cargo.lock conflicts in multi-language projects
   - **Mitigation**: Educate users on when to commit Cargo.lock (binaries) vs gitignore (libraries)
   - **Guidance**: Provide clear documentation on Cargo.lock best practices

4. **Risk**: CI runs out of cache space with multiple Rust versions
   - **Mitigation**: Use rust-cache action with appropriate cache keys
   - **Optimization**: Only cache target/release, not target/debug in CI

5. **Risk**: Tool versions drift over time
   - **Mitigation**: Pin tool versions in documentation
   - **Update Strategy**: Provide upgrade guide when new tool versions release

## Future Enhancements

1. **Additional Testing Tools**
   - Proptest plugin (property-based testing)
   - Criterion plugin (benchmarking)
   - Coverage tools (cargo-tarpaulin, cargo-llvm-cov)

2. **Advanced Analysis**
   - cargo-expand (macro expansion)
   - cargo-geiger (unsafe code detection)
   - cargo-udeps (unused dependencies)

3. **Rust-Specific Applications**
   - Rust CLI application plugin (Clap/Typer framework)
   - Rust web service plugin (Axum/Actix framework)
   - Rust WASM plugin (wasm-bindgen integration)

4. **Optimization Tools**
   - cargo-bloat (binary size analysis)
   - cargo-flamegraph (performance profiling)
   - mold/lld linker integration (faster linking)

5. **IDE Integration**
   - rust-analyzer configuration templates
   - VS Code settings for Rust
   - IntelliJ Rust plugin configuration
