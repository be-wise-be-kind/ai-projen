# How to Write a Test

## Purpose
Write effective unit and component tests using Vitest and React Testing Library with TypeScript in a Docker-first environment.

## Scope
Vitest testing, React Testing Library, component testing, hook testing, test patterns, coverage, Docker testing workflow

## Overview
This guide shows you how to write comprehensive tests for React components and custom hooks using Vitest and React Testing Library, with proper TypeScript typing and Docker-first development.

## Dependencies
- TypeScript plugin installed with Vitest
- React Testing Library (if testing React)
- Docker (recommended) or npm

## Prerequisites
- Understanding of testing concepts
- React components to test
- TypeScript basics
- Vitest configured (via TypeScript plugin)

## Quick Start

### 1. Create Test File
```bash
# Component test
touch src/components/Button/Button.test.tsx

# Hook test
touch src/hooks/useLocalStorage.test.ts
```

### 2. Write Test
Use templates and testing patterns.

### 3. Run Tests
```bash
# Docker-first
make test-typescript

# npm fallback
npm test
```

## Implementation Steps

### Step 1: Create Test File

**Naming convention:**
- Component tests: `ComponentName.test.tsx`
- Hook tests: `useHookName.test.ts`
- Utility tests: `utilityName.test.ts`

**File location:**
```
src/
├── components/
│   └── Button/
│       ├── Button.tsx
│       └── Button.test.tsx       # Next to component
├── hooks/
│   ├── useLocalStorage.ts
│   └── useLocalStorage.test.ts  # Next to hook
└── utils/
    ├── formatters.ts
    └── formatters.test.ts       # Next to utility
```

**Or use __tests__ directory:**
```
src/
├── components/
│   └── Button/
│       ├── Button.tsx
│       └── __tests__/
│           └── Button.test.tsx
```

### Step 2: Setup Test with Proper Imports

**Component test setup:**
```typescript
// src/components/Button/Button.test.tsx
import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button';

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });
});
```

**Hook test setup:**
```typescript
// src/hooks/useLocalStorage.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { useLocalStorage } from './useLocalStorage';

describe('useLocalStorage', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it('returns initial value when no stored value', () => {
    const { result } = renderHook(() => useLocalStorage('key', 'initial'));
    expect(result.current[0]).toBe('initial');
  });
});
```

### Step 3: Write Test Using React Testing Library

**Testing component rendering:**
```typescript
describe('UserCard', () => {
  const mockUser = {
    name: 'John Doe',
    email: 'john@example.com',
    avatar: '/avatar.jpg',
  };

  it('renders user information', () => {
    render(<UserCard {...mockUser} />);

    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('renders avatar when provided', () => {
    render(<UserCard {...mockUser} />);

    const avatar = screen.getByAltText('John Doe');
    expect(avatar).toBeInTheDocument();
    expect(avatar).toHaveAttribute('src', '/avatar.jpg');
  });

  it('does not render avatar when not provided', () => {
    render(<UserCard name="John" email="john@example.com" />);

    expect(screen.queryByRole('img')).not.toBeInTheDocument();
  });
});
```

**Query priorities (in order of preference):**
1. `getByRole` - Accessible to screen readers
2. `getByLabelText` - Form fields
3. `getByPlaceholderText` - Form inputs
4. `getByText` - Text content
5. `getByDisplayValue` - Current value
6. `getByAltText` - Images
7. `getByTitle` - Title attribute
8. `getByTestId` - Last resort

**Query variants:**
- `getBy` - Throws if not found (use for assertions)
- `queryBy` - Returns null if not found (use for negative assertions)
- `findBy` - Async, waits for element (use for async content)

### Step 4: Add User Interactions

**Using fireEvent (simple):**
```typescript
it('calls onClick when clicked', () => {
  const handleClick = vi.fn();
  render(<Button onClick={handleClick}>Click me</Button>);

  const button = screen.getByRole('button');
  fireEvent.click(button);

  expect(handleClick).toHaveBeenCalledTimes(1);
});
```

**Using userEvent (recommended):**
```typescript
it('handles user interaction', async () => {
  const user = userEvent.setup();
  const handleClick = vi.fn();

  render(<Button onClick={handleClick}>Click me</Button>);

  const button = screen.getByRole('button');
  await user.click(button);

  expect(handleClick).toHaveBeenCalledTimes(1);
});

it('handles form input', async () => {
  const user = userEvent.setup();
  render(<LoginForm />);

  const emailInput = screen.getByLabelText('Email');
  const passwordInput = screen.getByLabelText('Password');

  await user.type(emailInput, 'test@example.com');
  await user.type(passwordInput, 'password123');

  expect(emailInput).toHaveValue('test@example.com');
  expect(passwordInput).toHaveValue('password123');
});
```

**Why userEvent over fireEvent:**
- More realistic user interactions
- Triggers all related events (focus, blur, etc.)
- Better for form interactions
- Recommended by Testing Library

### Step 5: Run Tests in Docker

**Run all tests:**
```bash
make test-typescript
```

**Run tests in watch mode:**
```bash
make test-typescript-watch
```

**Run specific test file:**
```bash
docker exec typescript-dev npm test Button.test.tsx
```

**Run tests matching pattern:**
```bash
docker exec typescript-dev npm test -- --grep "user interaction"
```

### Step 6: Check Coverage

**Run with coverage:**
```bash
make test-coverage-typescript
```

**View coverage report:**
```bash
# Open coverage/index.html in browser
open coverage/index.html
```

**Coverage thresholds (vitest.config.ts):**
```typescript
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      thresholds: {
        branches: 80,
        functions: 80,
        lines: 80,
        statements: 80,
      },
    },
  },
});
```

## Testing Patterns

### Testing Async Behavior

**Using findBy queries:**
```typescript
it('loads and displays data', async () => {
  render(<UserProfile userId="123" />);

  // Loading state
  expect(screen.getByText('Loading...')).toBeInTheDocument();

  // Wait for data to load
  const userName = await screen.findByText('John Doe');
  expect(userName).toBeInTheDocument();

  // Loading should be gone
  expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
});
```

**Using waitFor:**
```typescript
it('handles async updates', async () => {
  render(<SearchResults query="test" />);

  await waitFor(() => {
    expect(screen.getByText('Results loaded')).toBeInTheDocument();
  });
});
```

### Testing Hooks

**Basic hook test:**
```typescript
describe('useCounter', () => {
  it('initializes with default value', () => {
    const { result } = renderHook(() => useCounter(0));
    expect(result.current.count).toBe(0);
  });

  it('increments count', () => {
    const { result } = renderHook(() => useCounter(0));

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});
```

**Hook with dependencies:**
```typescript
describe('useLocalStorage', () => {
  it('stores value in localStorage', () => {
    const { result } = renderHook(() =>
      useLocalStorage('test-key', 'initial')
    );

    act(() => {
      result.current[1]('updated');
    });

    expect(localStorage.getItem('test-key')).toBe('"updated"');
    expect(result.current[0]).toBe('updated');
  });

  it('loads value from localStorage', () => {
    localStorage.setItem('test-key', '"stored"');

    const { result } = renderHook(() =>
      useLocalStorage('test-key', 'initial')
    );

    expect(result.current[0]).toBe('stored');
  });
});
```

### Mocking

**Mock functions:**
```typescript
it('calls onSubmit with form data', async () => {
  const mockSubmit = vi.fn();
  render(<ContactForm onSubmit={mockSubmit} />);

  // Fill form and submit
  await userEvent.click(screen.getByRole('button', { name: /submit/i }));

  expect(mockSubmit).toHaveBeenCalledWith({
    name: 'John',
    email: 'john@example.com',
  });
});
```

**Mock modules:**
```typescript
import { vi } from 'vitest';

// Mock API module
vi.mock('../api/users', () => ({
  fetchUser: vi.fn(() => Promise.resolve({ id: 1, name: 'John' })),
}));

// Mock React Router
vi.mock('react-router-dom', () => ({
  useNavigate: () => vi.fn(),
  useParams: () => ({ userId: '123' }),
}));
```

**Mock timers:**
```typescript
import { vi } from 'vitest';

it('debounces input', () => {
  vi.useFakeTimers();

  const handleChange = vi.fn();
  render(<DebouncedInput onChange={handleChange} delay={500} />);

  const input = screen.getByRole('textbox');
  fireEvent.change(input, { target: { value: 'test' } });

  expect(handleChange).not.toHaveBeenCalled();

  vi.advanceTimersByTime(500);
  expect(handleChange).toHaveBeenCalledWith('test');

  vi.useRealTimers();
});
```

### Testing Context/State

**Testing with Context:**
```typescript
const wrapper = ({ children }: { children: React.ReactNode }) => (
  <AuthProvider>
    {children}
  </AuthProvider>
);

it('uses auth context', () => {
  render(<ProtectedComponent />, { wrapper });

  expect(screen.getByText('Logged in')).toBeInTheDocument();
});
```

**Testing Redux:**
```typescript
import { Provider } from 'react-redux';
import { configureStore } from '@reduxjs/toolkit';

function renderWithStore(
  component: React.ReactElement,
  initialState = {}
) {
  const store = configureStore({
    reducer: { /* reducers */ },
    preloadedState: initialState,
  });

  return render(
    <Provider store={store}>
      {component}
    </Provider>
  );
}

it('dispatches action', () => {
  renderWithStore(<UserList />, {
    users: { list: [], loading: false },
  });

  // Test component with store
});
```

## Verification

### All Tests Pass
```bash
make test-typescript

# Expected output:
# ✓ All tests passed
```

### Coverage Meets Threshold
```bash
make test-coverage-typescript

# Expected output:
# Branches: 85%
# Functions: 90%
# Lines: 88%
# Statements: 88%
```

### Test Quality Checklist
- [ ] Tests are readable and maintainable
- [ ] Tests cover happy path and edge cases
- [ ] Tests use proper queries (getByRole preferred)
- [ ] Async tests use findBy or waitFor
- [ ] User interactions use userEvent
- [ ] No implementation details tested
- [ ] Good test descriptions

## Common Issues and Solutions

### Issue 1: "not wrapped in act()"
**Symptom**: Warning about state updates not wrapped in act()

**Solution:**
```typescript
// Wrong
const { result } = renderHook(() => useCounter());
result.current.increment();  // Not wrapped!

// Right
const { result } = renderHook(() => useCounter());
act(() => {
  result.current.increment();
});
```

### Issue 2: Query not finding element
**Symptom**: `Unable to find element`

**Solution:**
```typescript
// Check if element is actually rendered
screen.debug();  // Prints DOM

// Use correct query
screen.getByRole('button', { name: /click me/i });  // ✓
screen.getByText('Click me');  // Might fail if button text is nested

// For async content
await screen.findByText('Loaded content');
```

### Issue 3: Tests pass locally, fail in CI
**Symptom**: Tests work in Docker, fail in GitHub Actions

**Solution:**
1. Ensure CI runs in Docker: `make test-typescript`
2. Check timezone differences
3. Mock Date.now() if time-sensitive
4. Check for race conditions in async tests

## Best Practices

### Test User Behavior, Not Implementation
```typescript
// ✗ Bad - Testing implementation
expect(component.state.count).toBe(1);
expect(mockFunction).toHaveBeenCalled();

// ✓ Good - Testing behavior
expect(screen.getByText('Count: 1')).toBeInTheDocument();
expect(screen.getByRole('button')).toHaveAttribute('aria-pressed', 'true');
```

### Use Semantic Queries
```typescript
// ✓ Good - Semantic, accessible
screen.getByRole('button', { name: /submit/i });
screen.getByLabelText('Email');

// ✗ Bad - Not accessible
screen.getByTestId('submit-button');
screen.getByClassName('email-input');
```

### Descriptive Test Names
```typescript
// ✓ Good - Describes behavior
it('displays error message when email is invalid', () => {});
it('calls onSubmit with form data when submit button clicked', () => {});

// ✗ Bad - Vague
it('works', () => {});
it('test button', () => {});
```

## Templates Reference

This how-to references the following templates:

- `templates/vitest-component-test.tsx.template` - Component test
- `templates/vitest-hook-test.tsx.template` - Hook test
- `templates/vitest-setup.ts.template` - Test setup file

## Related How-Tos

- [How to Create a Component](how-to-create-a-component.md) - Components to test
- [How to Create a Hook](how-to-create-a-hook.md) - Hooks to test

## Additional Resources

- [Vitest Documentation](https://vitest.dev/)
- [React Testing Library](https://testing-library.com/react)
- [Testing Library Queries](https://testing-library.com/docs/queries/about)
- [Common Testing Mistakes](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)
