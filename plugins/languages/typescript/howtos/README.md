# TypeScript Plugin How-To Guides

Comprehensive, step-by-step guides for common TypeScript/React development tasks. Each guide includes code examples, templates, Docker-first workflows, and troubleshooting.

## Overview

These how-tos are designed for AI agents and developers working with TypeScript and React. They emphasize Docker-first development, type safety, and best practices.

## Component Development

### [How to Create a Component](how-to-create-a-component.md)
**Purpose**: Create React components with TypeScript and CSS Modules

**What you'll learn**:
- Functional component creation
- TypeScript prop typing
- CSS Module integration
- Hot reload in Docker
- Component best practices

**Difficulty**: Beginner
**Estimated time**: 15 minutes
**Templates used**:
- `react-component.tsx.template`
- `react-component-with-hooks.tsx.template`
- `component.module.css.template`

### [How to Create a Component Library](how-to-create-a-component-library.md)
**Purpose**: Build reusable component libraries with proper build configuration

**What you'll learn**:
- Library project structure
- TypeScript build configuration
- NPM package setup
- Tree-shaking and exports
- Type definition generation

**Difficulty**: Intermediate
**Estimated time**: 30 minutes
**Templates used**:
- `component-library-package.json.template`
- `component-library-tsconfig.json.template`
- `component-library-index.ts.template`

## Routing & Navigation

### [How to Add a Route](how-to-add-a-route.md)
**Purpose**: Add routes using React Router with lazy loading

**What you'll learn**:
- React Router v6 setup
- Lazy-loaded page components
- Typed route parameters
- Navigation patterns
- Protected routes

**Difficulty**: Beginner
**Estimated time**: 20 minutes
**Templates used**:
- `react-page-component.tsx.template`
- `react-router-config.tsx.template`

## Custom Hooks

### [How to Create a Hook](how-to-create-a-hook.md)
**Purpose**: Build custom React hooks with proper TypeScript typing

**What you'll learn**:
- Hook naming conventions
- TypeScript generics in hooks
- Rules of hooks
- Dependency arrays
- Testing hooks

**Difficulty**: Intermediate
**Estimated time**: 25 minutes
**Templates used**:
- `react-hook.ts.template`
- `react-hook-with-state.ts.template`

## State Management

### [How to Add State Management](how-to-add-state-management.md)
**Purpose**: Implement global state with Context API, Redux, or Zustand

**What you'll learn**:
- Comparing state management solutions
- Context API implementation
- Redux Toolkit setup
- Zustand store creation
- TypeScript state typing

**Difficulty**: Intermediate
**Estimated time**: 30 minutes
**Templates used**:
- `react-context.tsx.template`
- `redux-slice.ts.template`
- `zustand-store.ts.template`

## Testing

### [How to Write a Test](how-to-write-a-test.md)
**Purpose**: Write comprehensive tests with Vitest and React Testing Library

**What you'll learn**:
- Component testing patterns
- Hook testing with renderHook
- User interaction testing
- Async testing
- Coverage requirements

**Difficulty**: Beginner
**Estimated time**: 25 minutes
**Templates used**:
- `vitest-component-test.tsx.template`
- `vitest-hook-test.tsx.template`

## Getting Started

### Prerequisites
1. TypeScript plugin installed in your project
2. Docker running (recommended) or Node.js installed
3. Basic understanding of React and TypeScript

### Docker-First Workflow

All how-tos follow the Docker-first development pattern:

```bash
# Start development environment
make dev-typescript

# Run tests
make test-typescript

# Run linting
make lint-typescript

# Type checking
make typecheck-typescript

# All checks
make typescript-check
```

**Benefits**:
- Consistent environment across team
- Zero local environment pollution
- Isolated dependencies
- Works on macOS, Linux, Windows

**Fallback to npm**: If Docker unavailable, all commands automatically fallback to npm.

### Quick Reference

| Task | How-To | Time | Difficulty |
|------|--------|------|------------|
| Create a component | [Guide](how-to-create-a-component.md) | 15 min | Beginner |
| Add a route | [Guide](how-to-add-a-route.md) | 20 min | Beginner |
| Write a test | [Guide](how-to-write-a-test.md) | 25 min | Beginner |
| Create a hook | [Guide](how-to-create-a-hook.md) | 25 min | Intermediate |
| Add state management | [Guide](how-to-add-state-management.md) | 30 min | Intermediate |
| Create component library | [Guide](how-to-create-a-component-library.md) | 30 min | Intermediate |

## How-To Structure

Each how-to follows a consistent structure:

1. **Purpose** - What you'll accomplish
2. **Scope** - Topics covered
3. **Overview** - High-level introduction
4. **Dependencies** - Required tools/libraries
5. **Prerequisites** - Required knowledge
6. **Quick Start** - Fast-track instructions
7. **Implementation Steps** - Detailed walkthrough
8. **Verification** - How to confirm it works
9. **Common Issues** - Troubleshooting guide
10. **Best Practices** - Expert tips
11. **Templates Reference** - Related templates
12. **Related How-Tos** - Connected guides
13. **Additional Resources** - External documentation

## Templates

All templates are located in `../templates/` and follow these conventions:

**Template Format**:
- Placeholders: `{{PLACEHOLDER_NAME}}`
- Purpose comment at top
- Usage instructions at bottom
- Complete, working examples

**How to use templates**:
1. Copy template file
2. Replace all `{{PLACEHOLDERS}}` with actual values
3. Remove placeholder comments
4. Customize as needed

**Available Templates**:

**Components**:
- `react-component.tsx.template` - Basic functional component
- `react-component-with-hooks.tsx.template` - Component with hooks
- `component.module.css.template` - CSS Module styles

**Routing**:
- `react-page-component.tsx.template` - Page component
- `react-router-config.tsx.template` - Router setup

**Hooks**:
- `react-hook.ts.template` - Custom hook
- `react-hook-with-state.ts.template` - Stateful hook

**State Management**:
- `react-context.tsx.template` - Context API
- `redux-slice.ts.template` - Redux Toolkit
- `zustand-store.ts.template` - Zustand

**Testing**:
- `vitest-component-test.tsx.template` - Component test
- `vitest-hook-test.tsx.template` - Hook test

**Library**:
- `component-library-package.json.template` - Package config
- `component-library-tsconfig.json.template` - TypeScript config
- `component-library-index.ts.template` - Exports

## Common Workflows

### Creating a New Feature

1. **Create page component** - [How to Add a Route](how-to-add-a-route.md)
2. **Create UI components** - [How to Create a Component](how-to-create-a-component.md)
3. **Add custom hooks** - [How to Create a Hook](how-to-create-a-hook.md)
4. **Add state if needed** - [How to Add State Management](how-to-add-state-management.md)
5. **Write tests** - [How to Write a Test](how-to-write-a-test.md)

### Building a Component Library

1. **Setup library** - [How to Create a Component Library](how-to-create-a-component-library.md)
2. **Create components** - [How to Create a Component](how-to-create-a-component.md)
3. **Create hooks** - [How to Create a Hook](how-to-create-a-hook.md)
4. **Write tests** - [How to Write a Test](how-to-write-a-test.md)
5. **Build and publish** - Follow library guide

## Best Practices

### Type Safety
- Always define prop interfaces
- Use TypeScript strict mode
- Avoid `any` - use `unknown` or proper types
- Export types with components

### Docker Workflow
- Use `make dev-typescript` for development
- Hot reload works in Docker containers
- Test in Docker before committing
- Clean up with `make typescript-clean`

### Testing
- Test user behavior, not implementation
- Use semantic queries (getByRole preferred)
- Mock external dependencies
- Achieve 80%+ coverage

### Code Organization
- Colocate tests with components
- Use barrel exports (index.ts)
- Group by feature, not type
- Keep components small and focused

## Troubleshooting

### Common Issues Across All How-Tos

**Docker not working**:
- Check Docker is running: `docker ps`
- Rebuild images: `make typescript-install`
- Check docker-compose.yml exists

**TypeScript errors**:
- Run type check: `make typecheck-typescript`
- Check tsconfig.json configuration
- Ensure all dependencies have types

**Hot reload not working**:
- Check volume mounts in docker-compose.yml
- Restart dev server: `make dev-typescript-stop && make dev-typescript`
- Verify `--host 0.0.0.0` in dev script

**Import errors**:
- Check file paths are correct
- Use barrel exports for cleaner imports
- Ensure file extensions match (.tsx for JSX)

## Contributing

To improve these how-tos:

1. Test the guide end-to-end
2. Update with learnings
3. Add troubleshooting for new issues
4. Keep examples current with latest React/TypeScript
5. Maintain Docker-first focus

## Additional Resources

### Official Documentation
- [React](https://react.dev/)
- [TypeScript](https://www.typescriptlang.org/)
- [React Router](https://reactrouter.com/)
- [Vitest](https://vitest.dev/)
- [React Testing Library](https://testing-library.com/react)

### Community Resources
- [TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [Patterns.dev](https://www.patterns.dev/)
- [Testing Library Guides](https://testing-library.com/docs/react-testing-library/example-intro)

### Plugin Documentation
- [TypeScript Plugin README](../README.md)
- [TypeScript Standards](../standards/typescript-standards.md)
- [Agent Instructions](../AGENT_INSTRUCTIONS.md)

---

**Last Updated**: 2025-10-01
**Plugin Version**: 1.0
**Maintained By**: ai-projen framework
