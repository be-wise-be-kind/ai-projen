# TypeScript Language Plugin

**Status**: Stable
**Purpose**: Complete TypeScript development environment with linting, formatting, and testing
**Dependencies**: foundation/ai-folder plugin

---

## What This Plugin Provides

This plugin sets up a complete, production-ready TypeScript development environment with **Docker-first development** including:

### Linting
- **ESLint** with TypeScript support
- Strict TypeScript rules
- Optional React/JSX support
- Import ordering
- Best practices enforcement

### Formatting
- **Prettier** for consistent code style
- Configurable formatting rules
- Integration with ESLint
- Auto-fix capabilities

### Testing
- **Vitest** for fast unit testing
- Optional React Testing Library support
- Coverage reporting with thresholds
- Watch mode and UI mode

### Configuration
- TypeScript compiler configuration (`tsconfig.json`)
- Strict type checking enabled
- Modern ES2022+ support
- Optional path aliases
- React JSX support (if needed)

### Docker-First Development
- Multi-stage Dockerfile (dev, lint, test, prod)
- Docker Compose for development orchestration
- Hot module replacement in containers
- Automatic fallback to npm when Docker unavailable
- Zero local environment pollution

### Integration
- Docker-first Makefile targets with auto-detection
- GitHub Actions workflows for CI/CD
- Pre-commit hook support
- Comprehensive documentation

## Supported Project Types

- Standalone TypeScript projects
- Node.js applications
- React applications (with JSX/TSX)
- Vite-based projects
- Library development

## Available Tools

### Linters
- **ESLint** (recommended) - Modern TypeScript linting with strict rules

### Formatters
- **Prettier** (recommended) - Opinionated code formatter

### Test Frameworks
- **Vitest** (recommended) - Fast, Vite-powered testing
- Jest (alternative - manual configuration required)

### Additional Tools
- TypeScript compiler (tsc)
- Type checking
- Coverage reporting

## Installation

See [AGENT_INSTRUCTIONS.md](./AGENT_INSTRUCTIONS.md) for complete installation guide.

**Docker-First Quick Start** (Recommended):
1. Ensure Docker and Docker Compose are installed
2. Have an AI agent follow `AGENT_INSTRUCTIONS.md`
3. Answer preference questions (React? Example files?)
4. Build Docker images: `make typescript-install`
5. Start development: `make dev-typescript`
6. Verify: `make typescript-check`

**npm Fallback Quick Start**:
1. Ensure Node.js v18+ is installed
2. Have an AI agent follow `AGENT_INSTRUCTIONS.md`
3. Install dependencies: `npm ci`
4. Verify: `npm run typecheck && npm run lint && npm test`

**Environment Auto-Detection**: The Makefile automatically detects and uses the best available option.

## Configuration Files

After installation, you'll have:

```
project-root/
├── Dockerfile                # Multi-stage TypeScript/React build
├── docker-compose.yml        # Development orchestration
├── eslint.config.js          # ESLint configuration
├── .prettierrc               # Prettier configuration
├── .prettierignore           # Prettier ignore patterns
├── vitest.config.ts          # Vitest test configuration
├── tsconfig.json             # TypeScript compiler config
├── src/
│   ├── test-setup.ts         # Test environment setup
│   ├── example.ts            # Example TypeScript file (optional)
│   └── example.test.ts       # Example test file (optional)
├── .ai/
│   └── docs/
│       └── TYPESCRIPT_STANDARDS.md  # TypeScript standards
├── .github/
│   └── workflows/
│       ├── typescript-lint.yml      # Linting workflow
│       └── typescript-test.yml      # Testing workflow
└── Makefile                  # Docker-first Make targets
```

## Usage

### Docker-First Commands (Recommended)

```bash
# Development
make dev-typescript              # Start dev server with hot reload
make dev-typescript-stop         # Stop dev server
make dev-typescript-logs         # View dev server logs

# Linting & Formatting
make lint-typescript             # Lint TypeScript code in Docker
make lint-typescript-fix         # Auto-fix linting issues
make format-typescript           # Format with Prettier + ESLint
make format-check-typescript     # Check formatting without fixing

# Testing
make test-typescript             # Run tests once in Docker
make test-coverage-typescript    # Run tests with coverage

# Type Checking
make typecheck-typescript        # Type check in Docker

# Combined
make typescript-check            # Run all checks (lint + typecheck + test)

# Installation & Cleanup
make typescript-install          # Build Docker images
make typescript-clean            # Clean Docker resources and artifacts
```

### npm Fallback Commands

```bash
# Development
npm run dev           # Start development server

# Type checking
npm run typecheck

# Linting
npm run lint           # Check for issues
npm run lint:fix       # Auto-fix issues

# Formatting
npm run format         # Format all files
npm run format:check   # Check formatting

# Testing
npm test              # Run tests in watch mode
npm run test:run      # Run tests once
npm run test:coverage # Run with coverage report
npm run test:ui       # Interactive test UI
```

### Legacy Make Targets (Still Supported)

```bash
make lint-ts          # Alias for lint-typescript
make format-ts        # Alias for format-typescript
make typecheck-ts     # Alias for typecheck-typescript
make test-ts          # Alias for test-typescript
make ts-check         # Alias for typescript-check
```

## Standards and Conventions

This plugin enforces:

### Type Safety
- Strict mode enabled
- No implicit `any`
- Explicit return types for public APIs
- Proper error handling

### Naming Conventions
- Files: kebab-case (`user-service.ts`)
- Variables/Functions: camelCase (`getUserById`)
- Classes/Interfaces: PascalCase (`UserService`)
- Constants: UPPER_SNAKE_CASE (`MAX_RETRIES`)

### Code Quality
- Line length: 88 characters
- Indentation: 2 spaces
- Single quotes for strings
- Trailing commas
- Semicolons required
- Import ordering

See [standards/typescript-standards.md](./standards/typescript-standards.md) for complete standards.

## React Support

When React mode is enabled, you get:

- React hooks ESLint rules
- React refresh support
- JSX/TSX linting
- React Testing Library
- JSDOM environment for tests
- React-specific TypeScript config

## How-To Guides

The TypeScript plugin includes comprehensive step-by-step guides for common development tasks. All guides emphasize Docker-first development and include code templates.

### Component Development
- **[Create a Component](howtos/how-to-create-a-component.md)** - React components with TypeScript and CSS Modules
- **[Create a Component Library](howtos/how-to-create-a-component-library.md)** - Build reusable component libraries with proper packaging

### Routing & Navigation
- **[Add a Route](howtos/how-to-add-a-route.md)** - React Router setup with lazy loading and typed parameters

### Custom Hooks
- **[Create a Hook](howtos/how-to-create-a-hook.md)** - Build custom React hooks with proper TypeScript types

### State Management
- **[Add State Management](howtos/how-to-add-state-management.md)** - Implement global state with Context API, Redux, or Zustand

### Testing
- **[Write a Test](howtos/how-to-write-a-test.md)** - Comprehensive testing with Vitest and React Testing Library

**See [howtos/README.md](howtos/README.md) for the complete guide index.**

Each how-to includes:
- Step-by-step instructions with code examples
- Code templates you can copy and customize
- Docker-first development workflow
- Verification steps to confirm it works
- Common issues and solutions
- Best practices and tips

**Quick workflow example**:
```bash
# 1. Create a new component
cp templates/react-component.tsx.template src/components/Button/Button.tsx
# Edit and replace {{PLACEHOLDERS}}

# 2. Start development with hot reload
make dev-typescript

# 3. Write tests
cp templates/vitest-component-test.tsx.template src/components/Button/Button.test.tsx

# 4. Run tests
make test-typescript
```

## Customization

All configurations are customizable:

### Adjust ESLint Rules
Edit `eslint.config.js` to modify linting rules.

### Adjust Formatting
Edit `.prettierrc` to change formatting preferences.

### Adjust Type Checking
Edit `tsconfig.json` to modify TypeScript compiler options.

### Adjust Test Configuration
Edit `vitest.config.ts` to change test settings.

## Integration with Other Plugins

### Pre-commit Hooks
This plugin integrates with the pre-commit-hooks plugin to run checks before commits.

### CI/CD
Includes GitHub Actions workflows for automated linting and testing.

### Docker
Docker templates are included by default:
- Multi-stage Dockerfile with dev, lint, test, and prod targets
- Docker Compose configuration for development
- Automatic hot reload support
- Production-ready nginx serving

## Example Project Structure

```
my-typescript-project/
├── src/
│   ├── services/
│   │   ├── user-service.ts
│   │   └── user-service.test.ts
│   ├── utils/
│   │   ├── helpers.ts
│   │   └── helpers.test.ts
│   ├── types/
│   │   └── index.ts
│   └── index.ts
├── eslint.config.js
├── .prettierrc
├── vitest.config.ts
├── tsconfig.json
├── package.json
└── Makefile
```

## Troubleshooting

### ESLint not working
- Verify `eslint.config.js` exists
- Check file patterns match your source files
- Run `npm run lint` to see specific errors

### Tests not running
- Ensure test files match pattern `*.test.ts` or `*.spec.ts`
- Check `vitest.config.ts` exists
- Verify Vitest is installed: `npm list vitest`

### Type errors
- Run `npm run typecheck` to see all type errors
- Check `tsconfig.json` settings
- Ensure all dependencies have type definitions

## Performance

- **Vitest**: 10x faster than Jest
- **ESLint**: Modern flat config for better performance
- **Prettier**: Fast formatting with caching
- **TypeScript**: Incremental compilation support

## Configurations Based On

Configurations extracted from production projects:
- ESLint: Modern flat config with TypeScript strict rules
- Prettier: Consistent with Python Black formatter (88 char line length)
- Vitest: Optimized for React and Node.js projects
- TypeScript: Strict mode with modern ES2022+ features

## Resources

- [TypeScript Documentation](https://www.typescriptlang.org/)
- [ESLint Documentation](https://eslint.org/)
- [Prettier Documentation](https://prettier.io/)
- [Vitest Documentation](https://vitest.dev/)
- [Plugin Standards](./standards/typescript-standards.md)
- [Installation Guide](./AGENT_INSTRUCTIONS.md)

## Contributing

To improve this plugin:
1. Follow the template structure in `plugins/languages/_template/`
2. Test configurations in real projects
3. Update documentation
4. Submit PR with changes

## Version

**Plugin Version**: 1.0
**Last Updated**: 2025-10-01
**Maintained By**: ai-projen framework

---

**Note**: This plugin is designed to work both standalone and as part of the ai-projen
framework. It provides battle-tested configurations for TypeScript projects with or
without React.
