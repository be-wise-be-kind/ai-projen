# Prettier for TypeScript - Agent Instructions

**Purpose**: Instructions for installing Prettier in TypeScript projects

**Scope**: Automatic code formatting for TypeScript/JavaScript

**Dependencies**: Node.js, npm/yarn/pnpm

---

## Installation Steps

### Step 1: Install Prettier

```bash
npm install --save-dev prettier
```

### Step 2: Copy Configuration

Copy the Prettier configuration to project root:

```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/formatters/prettier/config/.prettierrc .prettierrc
```

### Step 3: Create .prettierignore

Create `.prettierignore` in project root:

```
dist
coverage
node_modules
build
package-lock.json
*.min.js
```

### Step 4: Add Scripts to package.json

Add these scripts to `package.json`:

```json
{
  "scripts": {
    "format": "prettier --write 'src/**/*.{ts,tsx,js,jsx,json,css,md}'",
    "format:check": "prettier --check 'src/**/*.{ts,tsx,js,jsx,json,css,md}'"
  }
}
```

### Step 5: Verify Installation

```bash
npm run format:check
```

## Usage

- **Format all files**: `npm run format`
- **Check formatting**: `npm run format:check`
- **Format specific file**: `npx prettier --write src/file.ts`

## Integration with Makefile

If Makefile exists, add:

```makefile
.PHONY: format-ts

format-ts:
	npm run format

format-check-ts:
	npm run format:check
```

## Integration with ESLint

If using ESLint, install compatibility plugin:

```bash
npm install --save-dev eslint-config-prettier
```

Then update `eslint.config.js` to extend prettier config (disables conflicting rules).

## Customization

Edit `.prettierrc` to adjust formatting preferences:

- `printWidth`: Maximum line length (default 88)
- `tabWidth`: Spaces per indentation level (default 2)
- `singleQuote`: Use single quotes instead of double (default true)
- `trailingComma`: Add trailing commas where valid (default "all")
- `semi`: Add semicolons (default true)

## Success Criteria

- Prettier runs without errors: `npm run format:check`
- Config file exists: `.prettierrc`
- Scripts added to `package.json`
- Files can be formatted: `npm run format`
