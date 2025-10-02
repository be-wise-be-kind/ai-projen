# How to Create a Component Library

## Purpose
Create a shared component library with TypeScript for reuse across multiple applications, with proper build configuration and type definitions.

## Scope
Component library setup, TypeScript configuration, npm package creation, tree-shaking, type definitions, library exports

## Overview
This guide shows you how to create a reusable component library with TypeScript. You'll learn to set up build tools, configure TypeScript for library compilation, create proper exports, and publish your library for use in other projects.

## Dependencies
- TypeScript plugin installed
- React (if building React components)
- Build tools: `tsup`, `vite`, or `rollup`
- Docker (recommended) or npm

## Prerequisites
- Understanding of TypeScript and React
- Familiarity with npm packages
- TypeScript plugin installed
- Decision on library scope (what components to include)

## Quick Start

### 1. Create Library Directory Structure
```bash
mkdir -p my-component-library/{src,dist}
cd my-component-library
npm init -y
```

### 2. Install Dependencies
```bash
# Docker-first
make typescript-install

# npm fallback
npm install --save-dev typescript tsup @types/react @types/react-dom
npm install --save-peer react react-dom
```

### 3. Configure Library Build
Use the provided templates to set up your library configuration.

## Implementation Steps

### Step 1: Create Library Directory Structure

**Directory structure:**
```
my-component-library/
├── src/
│   ├── components/
│   │   ├── Button/
│   │   │   ├── Button.tsx
│   │   │   ├── Button.module.css
│   │   │   └── index.ts
│   │   ├── Card/
│   │   │   ├── Card.tsx
│   │   │   ├── Card.module.css
│   │   │   └── index.ts
│   │   └── index.ts
│   ├── hooks/
│   │   ├── useLocalStorage.ts
│   │   └── index.ts
│   ├── utils/
│   │   ├── formatters.ts
│   │   └── index.ts
│   └── index.ts                # Main entry point
├── dist/                       # Build output (generated)
├── package.json
├── tsconfig.json
├── tsup.config.ts              # Build configuration
└── README.md
```

**Create the structure:**
```bash
mkdir -p src/{components/{Button,Card},hooks,utils}
touch src/index.ts
```

### Step 2: Configure package.json for Library

**Use template:**
```bash
cp /path/to/plugin/templates/component-library-package.json.template package.json
```

**Or create manually:**
```json
{
  "name": "@your-org/component-library",
  "version": "1.0.0",
  "description": "Reusable React component library",
  "type": "module",
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.js",
      "types": "./dist/index.d.ts"
    },
    "./components/*": {
      "import": "./dist/components/*.mjs",
      "require": "./dist/components/*.js",
      "types": "./dist/components/*.d.ts"
    }
  },
  "files": [
    "dist",
    "README.md"
  ],
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch",
    "typecheck": "tsc --noEmit",
    "lint": "eslint src --ext .ts,.tsx",
    "prepublishOnly": "npm run build"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "tsup": "^8.0.0",
    "typescript": "^5.0.0"
  },
  "keywords": [
    "react",
    "components",
    "typescript",
    "ui"
  ]
}
```

**Key fields explained:**
- `main` - CommonJS entry point
- `module` - ES Module entry point
- `types` - TypeScript type definitions
- `exports` - Modern export map for different import paths
- `files` - Which files to include in npm package
- `peerDependencies` - Required by consumer, not bundled

### Step 3: Setup TypeScript for Library Compilation

**Use template:**
```bash
cp /path/to/plugin/templates/component-library-tsconfig.json.template tsconfig.json
```

**Or create manually:**
```json
{
  "compilerOptions": {
    // Output
    "outDir": "./dist",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,

    // Module system
    "module": "ESNext",
    "moduleResolution": "bundler",
    "target": "ES2020",

    // React
    "jsx": "react-jsx",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],

    // Type checking
    "strict": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,

    // Output options
    "declarationDir": "./dist",
    "stripInternal": true,
    "removeComments": false
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts", "**/*.test.tsx"]
}
```

**Build configuration (tsup.config.ts):**
```typescript
import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  splitting: true,
  sourcemap: true,
  clean: true,
  external: ['react', 'react-dom'],
  treeshake: true,
  minify: true,
});
```

### Step 4: Create index.ts for Exports

**Main entry point (src/index.ts):**
```typescript
// Components
export { Button } from './components/Button';
export type { ButtonProps } from './components/Button';

export { Card } from './components/Card';
export type { CardProps } from './components/Card';

// Hooks
export { useLocalStorage } from './hooks/useLocalStorage';

// Utils
export * from './utils/formatters';

// Version
export const VERSION = '1.0.0';
```

**Component barrel export (src/components/Button/index.ts):**
```typescript
export { Button } from './Button';
export type { ButtonProps } from './Button';
```

**Use template:**
```bash
cp /path/to/plugin/templates/component-library-index.ts.template src/index.ts
```

**Best practices for exports:**
- Export components and their props types separately
- Group related exports together
- Use barrel exports (index.ts) for cleaner imports
- Avoid `export *` unless exporting utilities
- Document exported API in main index.ts

### Step 5: Build Library

**Docker-first:**
```bash
make build-typescript
```

**npm fallback:**
```bash
npm run build
```

**What gets built:**
- `dist/index.js` - CommonJS bundle
- `dist/index.mjs` - ES Module bundle
- `dist/index.d.ts` - TypeScript type definitions
- `dist/components/` - Individual component bundles (if configured)
- Source maps for debugging

**Build output structure:**
```
dist/
├── index.js           # CommonJS
├── index.mjs          # ES Module
├── index.d.ts         # Types
├── index.d.ts.map     # Type source map
├── index.js.map       # Source map
└── components/        # Individual components (optional)
    ├── Button.js
    ├── Button.mjs
    └── Button.d.ts
```

### Step 6: Use Library in Application

**Install in consuming application:**
```bash
# If published to npm
npm install @your-org/component-library

# If local development
npm install ../path/to/my-component-library

# Or use npm link
cd my-component-library
npm link
cd ../my-app
npm link @your-org/component-library
```

**Use in application:**
```typescript
// Import from library
import { Button, Card } from '@your-org/component-library';
import type { ButtonProps } from '@your-org/component-library';

function App() {
  return (
    <div>
      <Card>
        <Button variant="primary">Click me</Button>
      </Card>
    </div>
  );
}
```

**TypeScript auto-completion works:**
- IntelliSense shows available props
- Type checking catches errors
- Jump to definition works
- JSDoc comments appear in hover tooltips

## Verification

### Check Library Builds
```bash
# Build the library
npm run build

# Verify output files exist
ls -la dist/

# Expected output:
# - index.js (CommonJS)
# - index.mjs (ES Module)
# - index.d.ts (types)
```

### Check Type Definitions
```bash
# Type check the library
npm run typecheck

# Should show no errors
```

### Check Exports
```bash
# Check what's exported
node -e "console.log(Object.keys(require('./dist/index.js')))"

# Should list all exported components/functions
```

### Check Library in App
- [ ] Library installs without errors
- [ ] Imports work correctly
- [ ] TypeScript types available
- [ ] Components render properly
- [ ] No bundling errors
- [ ] Tree-shaking works (only used components bundled)

## Common Issues and Solutions

### Issue 1: Types not found
**Symptom**: `Cannot find module '@your-org/component-library' or its corresponding type declarations`

**Solution**:
1. Check `types` field in package.json points to correct file
2. Ensure `.d.ts` files are generated during build
3. Rebuild library: `npm run build`
4. In consuming app: `rm -rf node_modules && npm install`

### Issue 2: Peer dependency warnings
**Symptom**: `npm WARN requires a peer of react@^18.0.0`

**Solution**:
1. Ensure consuming app has React installed
2. Check versions match peer dependency requirements
3. Install missing peer dependencies: `npm install react react-dom`

### Issue 3: CSS not loading
**Symptom**: Components have no styling

**Solution**:
1. Include CSS in build: configure tsup to handle CSS
2. Or: Document that consuming app needs to import CSS
3. Or: Use CSS-in-JS solution (styled-components, emotion)

```typescript
// tsup.config.ts
export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  external: ['react', 'react-dom'],
  injectStyle: true,  // Inject CSS into JS
});
```

### Issue 4: Large bundle size
**Symptom**: Library bundle is very large

**Solution**:
1. Enable tree-shaking: `treeshake: true` in tsup config
2. Mark dependencies as external (React, lodash, etc.)
3. Use named exports instead of default exports
4. Split components into separate entry points

```typescript
// tsup.config.ts
export default defineConfig({
  entry: {
    index: 'src/index.ts',
    Button: 'src/components/Button/index.ts',
    Card: 'src/components/Card/index.ts',
  },
  // ... other config
});
```

### Issue 5: Module resolution errors
**Symptom**: `Module not found` when importing from library

**Solution**:
1. Check `exports` field in package.json
2. Use modern bundler (Vite, webpack 5+)
3. Ensure `moduleResolution: "bundler"` in consuming app's tsconfig

## Best Practices

### Exports Best Practices
```typescript
// ✓ Good - Named exports with types
export { Button } from './components/Button';
export type { ButtonProps } from './components/Button';

// ✓ Good - Group by category
export * from './components';
export * from './hooks';

// ✗ Bad - Default exports (harder to tree-shake)
export default Button;

// ✗ Bad - Re-exporting everything (no tree-shaking)
export * from './components/Button';
```

### Tree-Shaking Support
```typescript
// Ensure each component is independently importable
// ✓ Good - Consumer can import only what they need
import { Button } from '@your-org/component-library';

// Structure your library for this:
// - Separate component files
// - Named exports only
// - No side effects in module code
// - External dependencies marked in build config
```

### Type Definitions
```typescript
// ✓ Good - Export props types
export interface ButtonProps {
  variant?: 'primary' | 'secondary';
  size?: 'small' | 'medium' | 'large';
  onClick?: () => void;
}

export const Button: React.FC<ButtonProps>;

// ✓ Good - Use JSDoc for documentation
/**
 * A customizable button component
 *
 * @example
 * ```tsx
 * <Button variant="primary" onClick={handleClick}>
 *   Click me
 * </Button>
 * ```
 */
export const Button: React.FC<ButtonProps>;
```

### Documentation
Create a README.md for your library:

```markdown
# Component Library

## Installation

\`\`\`bash
npm install @your-org/component-library
\`\`\`

## Usage

\`\`\`tsx
import { Button, Card } from '@your-org/component-library';

function App() {
  return (
    <Card>
      <Button variant="primary">Click me</Button>
    </Card>
  );
}
\`\`\`

## Components

### Button
- Props: variant, size, onClick
- Variants: primary, secondary
- Sizes: small, medium, large
```

## Templates Reference

This how-to references the following templates:

- `templates/component-library-package.json.template` - Package configuration
- `templates/component-library-tsconfig.json.template` - TypeScript config
- `templates/component-library-index.ts.template` - Main exports
- `templates/component-library-tsup-config.ts.template` - Build configuration

## Related How-Tos

- [How to Create a Component](how-to-create-a-component.md) - Creating components for the library
- [How to Write a Test](how-to-write-a-test.md) - Testing library components

## Additional Resources

- [tsup Documentation](https://tsup.egoist.dev/)
- [Publishing to npm](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [TypeScript Library Best Practices](https://www.typescriptlang.org/docs/handbook/declaration-files/library-structures.html)
- [Tree Shaking](https://developer.mozilla.org/en-US/docs/Glossary/Tree_shaking)
