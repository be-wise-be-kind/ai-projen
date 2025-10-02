# ESLint for TypeScript - Agent Instructions

**Purpose**: Instructions for installing ESLint in TypeScript projects

**Scope**: TypeScript linting with optional React support

**Dependencies**: Node.js, npm/yarn/pnpm

---

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

```bash
npm run lint
```

## Usage

- **Lint code**: `npm run lint`
- **Auto-fix issues**: `npm run lint:fix`
- **Lint specific file**: `npx eslint src/file.ts`

## Integration with Makefile

If Makefile exists, add:

```makefile
.PHONY: lint-ts format-ts

lint-ts:
	npm run lint

format-ts:
	npm run lint:fix
```

## Customization

Edit `eslint.config.js` to adjust rules:

- Modify `rules` object to change severity or add rules
- Add additional plugins as needed
- Adjust `ignores` array for file patterns to skip

## Success Criteria

- ESLint runs without errors: `npm run lint`
- Config file exists: `eslint.config.js`
- Scripts added to `package.json`
