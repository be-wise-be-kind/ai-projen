# Prettier for TypeScript - Agent Instructions

**Purpose**: Instructions for installing Prettier in TypeScript projects

**Scope**: Automatic code formatting for TypeScript/JavaScript

**Dependencies**: Docker (preferred), Node.js, npm/yarn/pnpm

---

## Environment Strategy

**IMPORTANT**: Follow the Docker-first development hierarchy:

1. **Docker (Preferred)** - `make format-typescript`
   - Runs Prettier in isolated container
   - Consistent formatting across all environments
   - No local Node.js pollution

2. **npm (Fallback)** - `npm run format`
   - Uses local node_modules
   - Works when Docker unavailable
   - Requires Node.js installed

3. **Global (Last Resort)** - Not recommended
   - Avoid `npm install -g prettier`
   - Use project-local installation only

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

**Docker-First (Recommended)**:
```bash
# Build Docker image with Prettier
make typescript-install

# Check formatting in Docker
make format-check-typescript

# Auto-format with Docker
make format-typescript
```

**npm Fallback**:
```bash
npm run format:check
```

## Usage

**Docker-First (Recommended)**:
- **Format all files**: `make format-typescript`
- **Check formatting**: `make format-check-typescript`
- **Combined with linting**: `make format-typescript` (runs Prettier + ESLint fix)

**npm Fallback**:
- **Format all files**: `npm run format`
- **Check formatting**: `npm run format:check`
- **Format specific file**: `npx prettier --write src/file.ts`

## Integration with Makefile

The TypeScript Makefile (from `makefile-typescript.mk`) already includes Docker-first Prettier targets:

```makefile
# Auto-detects Docker vs npm
format-typescript:
ifdef HAS_DOCKER
	@docker compose run --rm frontend-dev npm run format
	@docker compose run --rm frontend-dev npm run lint:fix
else
	@npm run format && npm run lint:fix
endif

format-check-typescript:
ifdef HAS_DOCKER
	@docker compose run --rm frontend-dev npm run format:check
else
	@npm run format:check
endif
```

**No manual Makefile edits needed** - the template handles everything.

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
