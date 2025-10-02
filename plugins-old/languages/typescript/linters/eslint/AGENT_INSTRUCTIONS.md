# ESLint for TypeScript - Agent Instructions

**Purpose**: Instructions for installing ESLint in TypeScript projects

**Scope**: TypeScript linting with optional React support

**Dependencies**: Docker (preferred), Node.js, npm/yarn/pnpm

---

## Environment Strategy

**IMPORTANT**: Follow the Docker-first development hierarchy:

1. **Docker (Preferred)** - `make lint-typescript`
   - Runs ESLint in isolated container
   - Consistent across all environments
   - No local Node.js pollution

2. **npm (Fallback)** - `npm run lint`
   - Uses local node_modules
   - Works when Docker unavailable
   - Requires Node.js installed

3. **Global (Last Resort)** - Not recommended
   - Avoid `npm install -g eslint`
   - Use project-local installation only

## Installation Steps

### Step 1: Install ESLint and Dependencies

```bash
npm install --save-dev \
  eslint \
  @eslint/js \
  typescript-eslint \
  globals
```

### Step 2: Choose Configuration

Ask the user: "Is this a React project?"

**If YES (React project)**:
```bash
npm install --save-dev \
  eslint-plugin-react-hooks \
  eslint-plugin-react-refresh
```

Copy `/home/stevejackson/Projects/ai-projen/plugins/languages/typescript/linters/eslint/config/eslint.config.react.js` to project root as `eslint.config.js`

**If NO (non-React project)**:

Copy `/home/stevejackson/Projects/ai-projen/plugins/languages/typescript/linters/eslint/config/eslint.config.js` to project root as `eslint.config.js`

### Step 3: Add Scripts to package.json

Add these scripts to `package.json`:

```json
{
  "scripts": {
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint . --ext ts,tsx --fix"
  }
}
```

### Step 4: Create .eslintignore (Optional)

Create `.eslintignore` in project root:

```
dist
coverage
node_modules
build
*.config.js
```

### Step 5: Verify Installation

**Docker-First (Recommended)**:
```bash
# Build Docker image with ESLint
make typescript-install

# Run ESLint in Docker
make lint-typescript

# Auto-fix with Docker
make lint-typescript-fix
```

**npm Fallback**:
```bash
npm run lint
```

## Usage

**Docker-First (Recommended)**:
- **Lint code**: `make lint-typescript`
- **Auto-fix issues**: `make lint-typescript-fix`
- **View logs**: Check Docker output for detailed errors

**npm Fallback**:
- **Lint code**: `npm run lint`
- **Auto-fix issues**: `npm run lint:fix`
- **Lint specific file**: `npx eslint src/file.ts`

## Integration with Makefile

The TypeScript Makefile (from `makefile-typescript.mk`) already includes Docker-first ESLint targets:

```makefile
# Auto-detects Docker vs npm
lint-typescript:
ifdef HAS_DOCKER
	@docker compose run --rm frontend-dev npm run lint
else
	@npm run lint
endif

lint-typescript-fix:
ifdef HAS_DOCKER
	@docker compose run --rm frontend-dev npm run lint:fix
else
	@npm run lint:fix
endif
```

**No manual Makefile edits needed** - the template handles everything.

## Customization

Edit `eslint.config.js` to adjust rules:

- Modify `rules` object to change severity or add rules
- Add additional plugins as needed
- Adjust `ignores` array for file patterns to skip

## Success Criteria

- ESLint runs without errors: `npm run lint`
- Config file exists: `eslint.config.js`
- Scripts added to `package.json`
