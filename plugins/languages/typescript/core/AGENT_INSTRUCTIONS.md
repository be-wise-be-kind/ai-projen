# TypeScript Plugin - Agent Instructions

**Purpose**: Instructions for AI agents to install the TypeScript language plugin

**Scope**: TypeScript development environment with linting, formatting, and testing

**Overview**: Step-by-step instructions for AI agents to install and configure TypeScript tooling
    including ESLint, Prettier, Vitest, and integration with Makefile and CI/CD.

**Dependencies**: foundation/ai-folder plugin

**Exports**: TypeScript development environment with quality tooling

**Related**: Language plugin for TypeScript/JavaScript projects

**Implementation**: Option-based installation with user preferences

---

## Parameters

This plugin accepts the following parameters:

- **INSTALL_PATH** - Directory where TypeScript tooling will be installed
  - Default: `.` (current directory)
  - Example: `frontend/`, `web/client/`

### Usage

**Standalone (uses current directory)**:
```
Follow: plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md
```

**With custom path**:
```
Follow: plugins/languages/typescript/core/AGENT_INSTRUCTIONS.md
  with INSTALL_PATH=frontend/
```

---

## Environment Strategy

**IMPORTANT**: This plugin follows the Docker-first development hierarchy established in PR7.5:

1. **Docker (Preferred)** - Use containers for consistency and isolation
2. **npm/local node_modules (Fallback)** - Isolated when Docker unavailable
3. **Direct global (Last Resort)** - Only when no other option

**Benefits of Docker-First**:
- Consistent development environments across all team members
- Zero local environment pollution
- Isolated dependencies prevent version conflicts
- Works identically on macOS, Linux, and Windows
- Easy cleanup with `make typescript-clean`

**Automatic Detection**: The Makefile auto-detects your environment and uses the best available option.

## Prerequisites

Before installing this plugin, ensure:
- Git repository is initialized
- foundation/ai-folder plugin is installed (agents.md and .ai/ exist)
- **Docker & Docker Compose (recommended)** - For Docker-first development
- **OR Node.js (v18 or later)** - For npm fallback
- **OR npm, yarn, or pnpm** - For package management fallback

## Installation Steps

**Initialize INSTALL_PATH parameter**:
```bash
INSTALL_PATH="${INSTALL_PATH:-.}"
mkdir -p "${INSTALL_PATH}"
```

### Step 1: Gather User Preferences

Ask the user (or use recommended defaults):

1. **Is this a React project?**
   - Yes (use React-specific configurations)
   - No (use standard TypeScript configurations)
   - Default: No

2. **Linter**: ESLint (recommended and only option currently)
   - Default: ESLint

3. **Formatter**: Prettier (recommended and only option currently)
   - Default: Prettier

4. **Testing**: Vitest (recommended)
   - Alternative: Jest (user must configure manually)
   - Default: Vitest

5. **Create example files?**
   - Yes (create starter files with examples)
   - No (minimal setup only)
   - Default: No

### Step 2: Install Docker Templates (Docker-First Approach)

**If Docker is available**, copy Docker templates to installation path:

```bash
# Copy Dockerfile
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/Dockerfile.typescript "${INSTALL_PATH}/Dockerfile"

# Copy docker-compose configuration
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/docker-compose.typescript.yml "${INSTALL_PATH}/docker-compose.yml"
```

**Note**: These templates support multi-stage builds for dev, lint, test, and production environments.

### Step 3: Initialize Package Manager

If `package.json` doesn't exist, create it:

```bash
cd "${INSTALL_PATH}" && npm init -y
```

Update `package.json` type to module:
```json
{
  "type": "module"
}
```

### Step 4: Install TypeScript

**Docker-First (Recommended)**:
```bash
# TypeScript will be installed in the Docker image during build
# Run initial build:
make typescript-install
```

**npm Fallback**:
```bash
npm install --save-dev typescript
```

### Step 5: Install and Configure Linter (ESLint)

Follow instructions in: `plugins/languages/typescript/linters/eslint/AGENT_INSTRUCTIONS.md`

This will:
1. Install ESLint and dependencies
2. Copy appropriate config (React or non-React)
3. Add lint scripts to package.json

### Step 6: Install and Configure Formatter (Prettier)

Follow instructions in: `plugins/languages/typescript/formatters/prettier/AGENT_INSTRUCTIONS.md`

This will:
1. Install Prettier
2. Copy `.prettierrc` config
3. Create `.prettierignore`
4. Add format scripts to package.json

### Step 7: Install and Configure Testing (Vitest)

Follow instructions in: `plugins/languages/typescript/testing/vitest/AGENT_INSTRUCTIONS.md`

This will:
1. Install Vitest and dependencies (React Testing Library if React project)
2. Copy appropriate vitest config (React or non-React)
3. Create test setup file
4. Add test scripts to package.json

### Step 8: Create TypeScript Configuration

**For non-React projects**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/tsconfig.json "${INSTALL_PATH}/tsconfig.json"
```

**For React projects**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/tsconfig.react.json "${INSTALL_PATH}/tsconfig.json"
```

### Step 9: Add package.json Scripts

Ensure `package.json` has these scripts (should be added by sub-steps):

```json
{
  "scripts": {
    "dev": "vite --host 0.0.0.0",
    "build": "tsc -b && vite build",
    "typecheck": "tsc --noEmit",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint . --ext ts,tsx --fix",
    "format": "prettier --write 'src/**/*.{ts,tsx,js,jsx,json,css,md}'",
    "format:check": "prettier --check 'src/**/*.{ts,tsx,js,jsx,json,css,md}'",
    "test": "vitest",
    "test:run": "vitest run",
    "test:coverage": "vitest run --coverage",
    "test:watch": "vitest --watch"
  }
}
```

**Note**:
- The `--host 0.0.0.0` flag in `dev` script is required for Docker hot reload
- Adjust scripts based on project type (remove Vite scripts if not using Vite)
- These scripts work identically in both Docker and npm environments

### Step 10: Create Makefile Targets

If Makefile doesn't exist, create it. Then append TypeScript targets:

```bash
cat /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/makefile-typescript.mk >> "${INSTALL_PATH}/Makefile"
```

If Makefile already exists, manually merge the contents to avoid duplicates.

**The Makefile provides Docker-first targets with automatic fallback**:
- Auto-detects Docker, Docker Compose, and npm availability
- Prioritizes Docker for consistency
- Falls back to npm gracefully when Docker unavailable
- Color-coded output shows which environment is being used

### Step 11: Extend agents.md

1. Read `agents.md`
2. Find the `### LANGUAGE_SPECIFIC_GUIDELINES` section
3. Insert between the markers:

```markdown
#### TypeScript (Airbnb Style Guide / Google TypeScript Style)

**Environment Strategy** (Docker-First):
- Development: `make dev-typescript` (Docker) or `npm run dev` (fallback)
- Linting: `make lint-typescript` (Docker) or `npm run lint` (fallback)
- Testing: `make test-typescript` (Docker) or `npm test` (fallback)
- Type Checking: `make typecheck-typescript` (Docker) or `npm run typecheck` (fallback)

**Type Safety**:
- Enable strict mode in tsconfig.json
- Avoid `any` type - prefer `unknown` or proper types
- Use explicit return types for public APIs
- Use type guards for runtime validation

**Naming Conventions**:
- Files: kebab-case (user-service.ts)
- Variables/Functions: camelCase (getUserById)
- Classes/Interfaces: PascalCase (UserService)
- Constants: UPPER_SNAKE_CASE (MAX_RETRIES)
- Booleans: isActive, hasPermission, shouldUpdate

**Code Organization**:
- Import order: external, internal, types, assets
- Prefer named exports over default exports
- Keep functions small and focused
- Use async/await over promise chains

**Error Handling**:
- Use proper error types
- Handle errors gracefully with try/catch
- Log errors appropriately
- Return null/undefined for expected failures

**React Patterns** (if React project):
- Use functional components with hooks
- Props: explicit interface with PascalCase name
- Custom hooks: start with 'use' prefix
- Event handlers: camelCase with 'handle' prefix

**Quick Commands**:
- **All Checks**: `make typescript-check` (lint + typecheck + test)
- **Development**: `make dev-typescript` (start dev server with hot reload)
- **Linting**: `make lint-typescript` (ESLint)
- **Formatting**: `make format-typescript` (Prettier + ESLint --fix)
- **Testing**: `make test-typescript` (Vitest)
- **Type Checking**: `make typecheck-typescript` (tsc --noEmit)
```

### Step 12: Add .ai Documentation

Create `.ai/docs/TYPESCRIPT_STANDARDS.md`:

```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/standards/typescript-standards.md "${INSTALL_PATH}/.ai/docs/TYPESCRIPT_STANDARDS.md"
```

Update `.ai/index.yaml` to reference this documentation:

```yaml
documentation:
  - path: docs/TYPESCRIPT_STANDARDS.md
    title: TypeScript Coding Standards
    description: TypeScript development standards and best practices
```

### Step 13: Add GitHub Actions Workflows (Optional)

If `.github/workflows/` exists, add TypeScript workflows:

**Linting workflow**:
```bash
mkdir -p "${INSTALL_PATH}/.github/workflows"
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/github-workflow-typescript-lint.yml "${INSTALL_PATH}/.github/workflows/typescript-lint.yml"
```

**Testing workflow**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/github-workflow-typescript-test.yml "${INSTALL_PATH}/.github/workflows/typescript-test.yml"
```

### Step 14: Create Example Files (Optional)

If user requested example files (or project has no src/ directory):

```bash
mkdir -p "${INSTALL_PATH}/src"
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/example.ts "${INSTALL_PATH}/src/example.ts"
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/example.test.ts "${INSTALL_PATH}/src/example.test.ts"
```

### Step 15: Validate Installation

**Docker-First Verification (Recommended)**:
```bash
# Build Docker images
make typescript-install

# Verify all tools work in Docker
make typecheck-typescript
make lint-typescript
make format-check-typescript
make test-typescript

# Run all checks at once
make typescript-check
```

**npm Fallback Verification**:
```bash
# Verify TypeScript compiler
npx tsc --version

# Verify all tools are installed
npm run typecheck
npm run lint
npm run format:check
npm run test:run
```

All commands should run without errors (tests may fail if no tests exist yet).

**What to Expect**:
- Docker mode: Colored output showing "Docker" for each command
- npm mode: Colored output showing "npm (Docker not available)"
- All checks should pass or show expected failures only

## Post-Installation

After successful installation, inform the user:

**Installed Tools**:
- TypeScript compiler
- ESLint (linting)
- Prettier (formatting)
- Vitest (testing)
- Docker multi-stage build (dev, lint, test, prod)

**Docker-First Commands** (Recommended):
- `make dev-typescript` - Start development server with hot reload
- `make lint-typescript` - Lint code with ESLint in Docker
- `make format-typescript` - Format code with Prettier in Docker
- `make test-typescript` - Run tests in Docker
- `make typecheck-typescript` - Type check in Docker
- `make typescript-check` - Run all checks in Docker
- `make typescript-clean` - Clean Docker resources and build artifacts

**npm Fallback Commands**:
- `npm run dev` - Start development server
- `npm run typecheck` - Type check TypeScript code
- `npm run lint` - Lint code with ESLint
- `npm run lint:fix` - Auto-fix linting issues
- `npm run format` - Format code with Prettier
- `npm run format:check` - Check formatting
- `npm test` - Run tests in watch mode
- `npm run test:run` - Run tests once
- `npm run test:coverage` - Run tests with coverage

**Environment Detection**:
The Makefile automatically detects your environment:
- If Docker is available: Uses Docker containers (preferred)
- If only npm is available: Uses local npm (fallback)
- Color-coded output shows which mode is active

**Next Steps**:
- Start writing TypeScript code in `src/`
- Use `make dev-typescript` to start development server
- Run `make typescript-check` before committing
- Docker workflow: Code changes trigger hot reload automatically
- npm workflow: Same experience, just using local node_modules
- Consider adding pre-commit hooks (see pre-commit-hooks plugin)

## Integration with Other Plugins

### With Pre-commit Hooks Plugin
Add to `.pre-commit-config.yaml`:
```yaml
- repo: local
  hooks:
    - id: typescript-lint
      name: TypeScript Linting
      entry: make lint-ts
      language: system
      pass_filenames: false
      files: \\.tsx?$
    - id: typescript-typecheck
      name: TypeScript Type Check
      entry: make typecheck-ts
      language: system
      pass_filenames: false
      files: \\.tsx?$
```

### With CI/CD Plugin
Workflows already created in Step 12 if GitHub Actions present.

### With Docker Plugin
Docker templates are automatically included in Step 2 of installation.

The provided `Dockerfile.typescript` includes:
- Multi-stage build (base, dependencies, dev, lint, test, builder, prod)
- Hot reload support for development
- Optimized production nginx serving
- Layer caching for fast rebuilds

The `docker-compose.typescript.yml` provides:
- Development service with volume mounts
- Hot module replacement support
- Optional linting service
- Network isolation

## Troubleshooting

### Issue: ESLint not finding files
**Solution**: Check `eslint.config.js` file patterns match your src directory

### Issue: TypeScript errors in config files
**Solution**: Add `*.config.*` to `tsconfig.json` exclude array

### Issue: Tests not running
**Solution**: Ensure test files match pattern `*.test.ts` or `*.spec.ts`

### Issue: Module resolution errors
**Solution**: Check `tsconfig.json` moduleResolution is set to "bundler" or "node"

## Standalone Usage

This plugin works standalone without the orchestrator:

```bash
# Manual installation
1. Copy this plugin directory to your project
2. Follow steps 1-14 above
3. Validate with step 14
```

## Success Criteria

Installation is successful when:
- ESLint config exists at `${INSTALL_PATH}` and linting works
- Prettier config exists at `${INSTALL_PATH}` and formatting works
- Vitest installed and tests run
- TypeScript compiler works
- `${INSTALL_PATH}/tsconfig.json` exists
- `${INSTALL_PATH}/Makefile` targets work
- `${INSTALL_PATH}/agents.md` updated with TypeScript guidelines
- `${INSTALL_PATH}/.ai/docs/TYPESCRIPT_STANDARDS.md` exists
- All validation commands pass
- User can start developing with TypeScript

---

**Note**: This plugin provides modern TypeScript tooling with battle-tested configurations
extracted from production projects. All configurations are customizable to project needs.
