# TypeScript Standards

**Purpose**: TypeScript coding standards and best practices

**Scope**: TypeScript development conventions and quality guidelines

**Overview**: Comprehensive standards for writing clean, maintainable TypeScript code including
    naming conventions, type safety, file organization, and testing practices.

---

## Environment Strategy

### Docker-First Development Hierarchy

This plugin follows the Docker-first development pattern established in PR7.5:

1. **Docker (Preferred)** - Use containers for consistency
   - Isolated environment with no local pollution
   - Consistent Node.js version across team
   - Hot module replacement works identically for everyone
   - Easy cleanup: `make typescript-clean`

2. **npm/local node_modules (Fallback)** - When Docker unavailable
   - Project-isolated dependencies via package.json
   - Local Node.js installation required
   - Some platform-dependent behavior possible

3. **Direct global (Last Resort)** - Avoid this
   - Global npm packages pollute system
   - Version conflicts between projects
   - "Works on my machine" problems

### Development Workflow

**Docker-First (Recommended)**:
```bash
# One-time setup
make typescript-install       # Build Docker images

# Daily development
make dev-typescript          # Start dev server (http://localhost:5173)
# Edit code - changes hot reload automatically
make typescript-check        # Run all checks before commit
```

**npm Fallback**:
```bash
# One-time setup
npm ci                       # Install dependencies

# Daily development
npm run dev                  # Start dev server
# Edit code - changes hot reload automatically
npm run typecheck && npm run lint && npm test  # Checks before commit
```

**Environment Auto-Detection**: The Makefile automatically detects Docker/npm availability and uses the best option. No manual configuration needed.

## Type Safety

### Always Use Strict Mode
- Enable `strict: true` in `tsconfig.json`
- Avoid `any` type - use `unknown` if type is truly unknown
- Use explicit return types for public APIs
- Enable `noImplicitAny`, `strictNullChecks`, and other strict flags

### Type Annotations
```typescript
// Good - explicit types for function parameters and returns
function calculateTotal(items: Item[], tax: number): number {
  return items.reduce((sum, item) => sum + item.price, 0) * (1 + tax);
}

// Avoid - implicit any
function calculateTotal(items, tax) {
  return items.reduce((sum, item) => sum + item.price, 0) * (1 + tax);
}
```

### Use Type Guards
```typescript
function isUser(obj: unknown): obj is User {
  return typeof obj === 'object' && obj !== null && 'id' in obj;
}
```

## Naming Conventions

### Files
- Use kebab-case for file names: `user-service.ts`
- Use `.test.ts` or `.spec.ts` for test files
- Use `.d.ts` for type declaration files
- Group related files in directories

### Variables and Functions
- Use camelCase: `firstName`, `getUserById`
- Use descriptive names: `calculateTotal` not `calc`
- Boolean variables start with `is`, `has`, `should`: `isActive`, `hasPermission`

### Classes and Interfaces
- Use PascalCase: `UserService`, `ApiResponse`
- Interface names don't need `I` prefix: `User` not `IUser`
- Type aliases use PascalCase: `type UserId = string`

### Constants
- Use UPPER_SNAKE_CASE for true constants: `MAX_RETRY_COUNT`
- Use camelCase for configuration objects: `apiConfig`

### Enums
- Use PascalCase for enum names: `UserRole`
- Use PascalCase for enum members: `UserRole.Admin`

## File Organization

### Import Order
1. External dependencies (React, third-party libraries)
2. Internal modules (project code)
3. Type imports
4. CSS/asset imports

```typescript
// External
import { useState, useEffect } from 'react';
import axios from 'axios';

// Internal
import { UserService } from '@/services/user-service';
import { formatDate } from '@/utils/date';

// Types
import type { User, ApiResponse } from '@/types';

// Assets
import './styles.css';
```

### Export Conventions
- Prefer named exports over default exports
- Export types and interfaces from dedicated type files
- Keep exports at the bottom of the file

```typescript
// Good - named exports
export { UserService };
export type { User, UserRole };

// Use default exports only for single-responsibility modules
export default UserService;
```

## Function Guidelines

### Arrow Functions vs Regular Functions
- Use arrow functions for callbacks and inline functions
- Use regular functions for methods and standalone functions
- Use arrow functions for React components

```typescript
// Good - arrow function for callbacks
const numbers = [1, 2, 3].map((n) => n * 2);

// Good - regular function for standalone
function calculateDiscount(price: number, rate: number): number {
  return price * (1 - rate);
}

// Good - arrow function for React components
const UserProfile = ({ user }: Props) => {
  return <div>{user.name}</div>;
};
```

### Function Documentation
```typescript
/**
 * Fetches user by ID from the API
 *
 * @param userId - The unique user identifier
 * @returns Promise resolving to User or null if not found
 * @throws {ApiError} When the API request fails
 */
async function fetchUser(userId: string): Promise<User | null> {
  // Implementation
}
```

## Error Handling

### Use Proper Error Types
```typescript
class ApiError extends Error {
  constructor(
    message: string,
    public statusCode: number,
  ) {
    super(message);
    this.name = 'ApiError';
  }
}
```

### Handle Errors Gracefully
```typescript
// Good - proper error handling
async function fetchData(): Promise<Data | null> {
  try {
    const response = await api.get('/data');
    return response.data;
  } catch (error) {
    console.error('Failed to fetch data:', error);
    return null;
  }
}

// Avoid - swallowing errors silently
async function fetchData(): Promise<Data> {
  try {
    const response = await api.get('/data');
    return response.data;
  } catch {
    return {} as Data; // Bad - returns invalid data
  }
}
```

## Async/Await Patterns

### Prefer async/await over Promises
```typescript
// Good - async/await
async function loadUser(id: string): Promise<User> {
  const user = await fetchUser(id);
  const profile = await fetchProfile(user.id);
  return { ...user, profile };
}

// Avoid - promise chains
function loadUser(id: string): Promise<User> {
  return fetchUser(id).then((user) =>
    fetchProfile(user.id).then((profile) => ({ ...user, profile })),
  );
}
```

## Testing Conventions

### Test File Naming
- Place tests next to source: `user-service.ts` → `user-service.test.ts`
- Or use `__tests__/` directory

### Test Structure
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', () => {
      // Test implementation
    });

    it('should throw error for invalid email', () => {
      // Test implementation
    });
  });
});
```

### Use Descriptive Test Names
```typescript
// Good - descriptive
it('should return null when user is not found', () => {});

// Avoid - vague
it('should work', () => {});
```

## React-Specific Patterns (if using React)

### Component Props
```typescript
interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
  className?: string;
}

const UserCard = ({ user, onEdit, className }: UserCardProps) => {
  // Component implementation
};
```

### Hooks
- Use hooks at the top level
- Custom hooks start with `use`: `useUserData`
- Extract complex logic into custom hooks

### Event Handlers
```typescript
// Good - typed event handlers
const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
  event.preventDefault();
  // Handle click
};

// Good - callback props
interface Props {
  onSubmit: (data: FormData) => void;
}
```

## Code Quality

### Avoid Magic Numbers
```typescript
// Bad
if (user.age > 18) { }

// Good
const LEGAL_AGE = 18;
if (user.age > LEGAL_AGE) { }
```

### Use Optional Chaining and Nullish Coalescing
```typescript
// Good
const userName = user?.profile?.name ?? 'Guest';

// Avoid
const userName = user && user.profile && user.profile.name ? user.profile.name : 'Guest';
```

### Prefer Immutability
```typescript
// Good
const updatedUser = { ...user, name: 'New Name' };

// Avoid
user.name = 'New Name';
```

## Linting Rules

### ESLint Configuration
- No unused variables
- No explicit `any` (warn)
- Prefer `const` over `let`
- No `var`
- Consistent import order
- Proper error handling

### Code Formatting
- Line length: 88 characters (matches Black Python formatter)
- Indentation: 2 spaces
- Single quotes for strings
- Trailing commas
- Semicolons required

## Documentation

### File Headers
Every TypeScript file should include a documentation header:

```typescript
/**
 * Purpose: Brief description of file purpose
 *
 * Scope: What this file covers
 *
 * Overview: Detailed explanation of implementation, patterns used,
 *     and important considerations.
 *
 * Dependencies: List key dependencies
 *
 * Exports: What this file exports
 *
 * Implementation: Technical approach and patterns
 */
```

### Function Documentation
- Document all public functions
- Include parameter descriptions
- Document return types
- Note any thrown errors

## Performance Considerations

### Avoid Premature Optimization
- Write clear code first
- Profile before optimizing
- Use memoization (`useMemo`, `useCallback`) only when needed

### Lazy Loading
```typescript
// Good - lazy load components
const HeavyComponent = lazy(() => import('./HeavyComponent'));
```

## Security

### Sanitize User Input
- Validate all user input
- Use type guards for runtime validation
- Escape HTML when rendering user content

### Avoid Dangerous Patterns
```typescript
// Bad - eval is dangerous
eval(userInput);

// Bad - innerHTML with user input
element.innerHTML = userInput;

// Good - use textContent
element.textContent = userInput;
```

## Tools and Commands

### Docker-First Commands (Recommended)

**Development**:
- Start dev server: `make dev-typescript`
- Stop dev server: `make dev-typescript-stop`
- View logs: `make dev-typescript-logs`

**Linting**:
- Run linting: `make lint-typescript`
- Auto-fix: `make lint-typescript-fix`

**Formatting**:
- Format code: `make format-typescript`
- Check formatting: `make format-check-typescript`

**Testing**:
- Run tests: `make test-typescript`
- With coverage: `make test-coverage-typescript`

**Type Checking**:
- Type check: `make typecheck-typescript`

**Combined**:
- All checks: `make typescript-check`

**Cleanup**:
- Clean all: `make typescript-clean`

### npm Fallback Commands

**Linting**:
- Run linting: `npm run lint`
- Auto-fix: `npm run lint:fix`

**Formatting**:
- Format code: `npm run format`
- Check formatting: `npm run format:check`

**Testing**:
- Run tests: `npm test`
- Coverage: `npm run test:coverage`

**Type Checking**:
- Type check: `npm run typecheck`

### Legacy Aliases (Backward Compatible)
- `make lint-ts` → `make lint-typescript`
- `make format-ts` → `make format-typescript`
- `make test-ts` → `make test-typescript`
- `make typecheck-ts` → `make typecheck-typescript`
- `make ts-check` → `make typescript-check`

---

**Note**: These standards are enforced through ESLint, Prettier, and TypeScript compiler options.
Follow these guidelines to maintain code quality and consistency across the project.
