# Vitest for TypeScript - Agent Instructions

**Purpose**: Instructions for installing Vitest in TypeScript projects

**Scope**: Fast unit testing framework for TypeScript/JavaScript

**Dependencies**: Node.js, npm/yarn/pnpm

---

## Installation Steps

### Step 1: Ask User About Project Type

Ask: "Is this a React project?"

### Step 2: Install Vitest

**For non-React projects**:
```bash
npm install --save-dev vitest @vitest/coverage-v8
```

**For React projects**:
```bash
npm install --save-dev \
  vitest \
  @vitest/coverage-v8 \
  @vitejs/plugin-react \
  jsdom \
  @testing-library/react \
  @testing-library/jest-dom \
  @testing-library/user-event
```

### Step 3: Copy Configuration

**For non-React projects**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/testing/vitest/config/vitest.config.ts vitest.config.ts
```

**For React projects**:
```bash
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/testing/vitest/config/vitest.config.react.ts vitest.config.ts
```

### Step 4: Create Test Setup File

Create `src/test-setup.ts`:

**For non-React projects**:
```bash
mkdir -p src
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/testing/vitest/config/test-setup.ts src/test-setup.ts
```

**For React projects**:
```bash
mkdir -p src
cp /home/stevejackson/Projects/ai-projen/plugins/languages/typescript/testing/vitest/config/test-setup.react.ts src/test-setup.ts
```

### Step 5: Add Scripts to package.json

Add these scripts to `package.json`:

```json
{
  "scripts": {
    "test": "vitest",
    "test:run": "vitest run",
    "test:coverage": "vitest run --coverage",
    "test:watch": "vitest --watch",
    "test:ui": "vitest --ui"
  }
}
```

### Step 6: Create Example Test (Optional)

Create `src/example.test.ts`:

```typescript
import { describe, it, expect } from 'vitest';

describe('Example Test Suite', () => {
  it('should pass a basic test', () => {
    expect(true).toBe(true);
  });
});
```

### Step 7: Verify Installation

```bash
npm run test:run
```

## Usage

- **Run tests (watch mode)**: `npm test`
- **Run tests once**: `npm run test:run`
- **Run with coverage**: `npm run test:coverage`
- **Interactive UI**: `npm run test:ui`

## Integration with Makefile

If Makefile exists, add:

```makefile
.PHONY: test-ts test-coverage-ts

test-ts:
	npm test

test-coverage-ts:
	npm run test:coverage
```

## Test File Conventions

- Test files: `*.test.ts`, `*.test.tsx`, `*.spec.ts`, `*.spec.tsx`
- Place tests next to source files or in `__tests__/` directories
- Use descriptive test names

## Customization

Edit `vitest.config.ts` to adjust:

- `coverage.thresholds`: Adjust minimum coverage percentages
- `coverage.exclude`: Add patterns to exclude from coverage
- `test.globals`: Enable/disable global test functions
- `test.environment`: Change test environment (node, jsdom, happy-dom)

## Success Criteria

- Vitest runs without errors: `npm run test:run`
- Config file exists: `vitest.config.ts`
- Test setup file exists: `src/test-setup.ts`
- Scripts added to `package.json`
- Example test passes
