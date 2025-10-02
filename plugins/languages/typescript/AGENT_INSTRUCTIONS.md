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

## Prerequisites

Before installing this plugin, ensure:
- Git repository is initialized
- foundation/ai-folder plugin is installed (agents.md and .ai/ exist)
- Node.js (v18 or later) is installed
- npm, yarn, or pnpm is available

## Installation Steps

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

### Step 2: Initialize Package Manager

If `package.json` doesn't exist, create it:

```bash
npm init -y
```

Update `package.json` type to module:
```json
{
  "type": "module"
}
```

### Step 3: Install TypeScript

```bash
npm install --save-dev typescript
```

### Step 4: Install and Configure Linter (ESLint)

Follow instructions in: `plugins/languages/typescript/linters/eslint/AGENT_INSTRUCTIONS.md`

This will:
1. Install ESLint and dependencies
2. Copy appropriate config (React or non-React)
3. Add lint scripts to package.json

### Step 5: Install and Configure Formatter (Prettier)

Follow instructions in: `plugins/languages/typescript/formatters/prettier/AGENT_INSTRUCTIONS.md`

This will:
1. Install Prettier
2. Copy `.prettierrc` config
3. Create `.prettierignore`
4. Add format scripts to package.json

### Step 6: Install and Configure Testing (Vitest)

Follow instructions in: `plugins/languages/typescript/testing/vitest/AGENT_INSTRUCTIONS.md`

This will:
1. Install Vitest and dependencies (React Testing Library if React project)
2. Copy appropriate vitest config (React or non-React)
3. Create test setup file
4. Add test scripts to package.json

### Step 7: Create TypeScript Configuration

**For non-React projects**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/tsconfig.json tsconfig.json
```

**For React projects**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/tsconfig.react.json tsconfig.json
```

### Step 8: Add package.json Scripts

Ensure `package.json` has these scripts (should be added by sub-steps):

```json
{
  "scripts": {
    "dev": "vite",
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

**Note**: Adjust scripts based on project type (remove Vite scripts if not using Vite).

### Step 9: Create Makefile Targets

If Makefile doesn't exist, create it. Then append TypeScript targets:

```bash
cat /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/makefile-typescript.mk >> Makefile
```

If Makefile already exists, manually merge the contents to avoid duplicates.

### Step 10: Extend agents.md

1. Read `agents.md`
2. Find the `### LANGUAGE_SPECIFIC_GUIDELINES` section
3. Insert between the markers:

```markdown
#### TypeScript (Airbnb Style Guide / Google TypeScript Style)

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

**Linting**: `make lint-ts` (runs ESLint)
**Formatting**: `make format-ts` (runs Prettier + ESLint --fix)
**Testing**: `make test-ts` (runs Vitest)
**Type Checking**: `make typecheck-ts` (runs tsc --noEmit)
**All Checks**: `make ts-check` (runs lint + typecheck + test)
```

### Step 11: Add .ai Documentation

Create `.ai/docs/TYPESCRIPT_STANDARDS.md`:

```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/standards/typescript-standards.md .ai/docs/TYPESCRIPT_STANDARDS.md
```

Update `.ai/index.yaml` to reference this documentation:

```yaml
documentation:
  - path: docs/TYPESCRIPT_STANDARDS.md
    title: TypeScript Coding Standards
    description: TypeScript development standards and best practices
```

### Step 12: Add GitHub Actions Workflows (Optional)

If `.github/workflows/` exists, add TypeScript workflows:

**Linting workflow**:
```bash
mkdir -p .github/workflows
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/github-workflow-typescript-lint.yml .github/workflows/typescript-lint.yml
```

**Testing workflow**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/github-workflow-typescript-test.yml .github/workflows/typescript-test.yml
```

### Step 13: Create Example Files (Optional)

If user requested example files (or project has no src/ directory):

```bash
mkdir -p src
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/example.ts src/example.ts
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/templates/example.test.ts src/example.test.ts
```

### Step 14: Validate Installation

Run these commands to verify everything works:

```bash
# Verify TypeScript compiler
npx tsc --version

# Verify all tools are installed
npm run typecheck
npm run lint
npm run format:check
npm run test:run

# Or use Makefile
make typecheck-ts
make lint-ts
make format-check-ts
make test-ts
```

All commands should run without errors (tests may fail if no tests exist yet).

## Post-Installation

After successful installation, inform the user:

**Installed Tools**:
- TypeScript compiler
- ESLint (linting)
- Prettier (formatting)
- Vitest (testing)

**Available Commands**:
- `npm run typecheck` - Type check TypeScript code
- `npm run lint` - Lint code with ESLint
- `npm run lint:fix` - Auto-fix linting issues
- `npm run format` - Format code with Prettier
- `npm run format:check` - Check formatting
- `npm test` - Run tests in watch mode
- `npm run test:run` - Run tests once
- `npm run test:coverage` - Run tests with coverage

**Make Targets** (if Makefile present):
- `make lint-ts` - Lint TypeScript
- `make format-ts` - Format TypeScript
- `make typecheck-ts` - Type check
- `make test-ts` - Run tests
- `make ts-check` - Run all checks

**Next Steps**:
- Start writing TypeScript code in `src/`
- Run `npm run typecheck` to verify types
- Run `make ts-check` before committing
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
Consider adding Node.js to Dockerfile:
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
```

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
- ESLint config exists and linting works
- Prettier config exists and formatting works
- Vitest installed and tests run
- TypeScript compiler works
- `tsconfig.json` exists
- Makefile targets work
- agents.md updated with TypeScript guidelines
- `.ai/docs/TYPESCRIPT_STANDARDS.md` exists
- All validation commands pass
- User can start developing with TypeScript

---

**Note**: This plugin provides modern TypeScript tooling with battle-tested configurations
extracted from production projects. All configurations are customizable to project needs.
