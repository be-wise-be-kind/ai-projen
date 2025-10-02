# How to Create a Custom React Hook

## Purpose
Create reusable custom React hooks with TypeScript for sharing logic across components, with proper typing and best practices.

## Scope
Custom React hooks, TypeScript types, hook composition, dependency arrays, memoization, testing hooks

## Overview
This guide teaches you how to create custom React hooks following the rules of hooks, with proper TypeScript typing, and best practices for reusability and performance.

## Dependencies
- TypeScript plugin installed
- React 16.8+ (hooks support)
- Docker (recommended) or npm

## Prerequisites
- Understanding of React hooks (useState, useEffect)
- Basic TypeScript knowledge
- Familiarity with hook rules

## Quick Start

### 1. Identify Reusable Logic
Look for logic that:
- Is used in multiple components
- Manages state or side effects
- Can be abstracted independently

### 2. Create Hook File
```bash
mkdir -p src/hooks
touch src/hooks/useLocalStorage.ts
```

### 3. Implement Hook
Use proper naming (prefix with `use`) and TypeScript types.

## Implementation Steps

### Step 1: Identify Reusable Logic

**Good candidates for custom hooks:**
- API data fetching
- Local storage management
- Window dimensions/resize handling
- Form input handling
- WebSocket connections
- Debouncing/throttling
- Authentication state
- Theme management

**Example reusable logic:**
```typescript
// Component 1
const [user, setUser] = useState(null);
useEffect(() => {
  const saved = localStorage.getItem('user');
  if (saved) setUser(JSON.parse(saved));
}, []);
useEffect(() => {
  localStorage.setItem('user', JSON.stringify(user));
}, [user]);

// Component 2 - same logic repeated
const [settings, setSettings] = useState({});
useEffect(() => {
  const saved = localStorage.getItem('settings');
  if (saved) setSettings(JSON.parse(saved));
}, []);
useEffect(() => {
  localStorage.setItem('settings', JSON.stringify(settings));
}, [settings]);

// Solution: useLocalStorage hook!
```

### Step 2: Create Hook File with Proper Naming

**Naming convention:**
- ALWAYS prefix with `use` (required by React)
- Use camelCase: `useLocalStorage`, `useFetch`, `useDebounce`
- Be descriptive: `useWindowSize` not `useWindow`

**File structure:**
```bash
src/hooks/
├── useLocalStorage.ts    # Local storage hook
├── useFetch.ts           # API fetching hook
├── useDebounce.ts        # Debouncing hook
├── index.ts              # Barrel export
└── __tests__/            # Hook tests
    └── useLocalStorage.test.ts
```

**Create hook file:**
```bash
touch src/hooks/useLocalStorage.ts
```

**Use template:**
```bash
cp /path/to/plugin/templates/react-hook.ts.template src/hooks/useLocalStorage.ts
```

### Step 3: Define Hook Signature with TypeScript

**Basic hook signature:**
```typescript
// src/hooks/useLocalStorage.ts
import { useState, useEffect } from 'react';

/**
 * Hook for managing state synced with localStorage
 *
 * @param key - localStorage key
 * @param initialValue - Initial value if no stored value exists
 * @returns Tuple of [value, setValue]
 */
export function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T | ((prev: T) => T)) => void] {
  // Implementation here
}
```

**With options object:**
```typescript
interface UseLocalStorageOptions {
  serialize?: (value: unknown) => string;
  deserialize?: (value: string) => unknown;
}

export function useLocalStorage<T>(
  key: string,
  initialValue: T,
  options?: UseLocalStorageOptions
): [T, (value: T) => void] {
  // Implementation
}
```

**Generic types explained:**
```typescript
// <T> - Generic type parameter
// T can be any type: string, number, object, etc.
// Provides type safety for both input and output

// Usage examples:
const [name, setName] = useLocalStorage<string>('name', 'John');
const [count, setCount] = useLocalStorage<number>('count', 0);
const [user, setUser] = useLocalStorage<User>('user', { id: 1 });
// TypeScript knows the types!
```

### Step 4: Implement Hook Logic

**Complete implementation:**
```typescript
import { useState, useEffect, useCallback } from 'react';

export function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T | ((prev: T) => T)) => void] {
  // State to store our value
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.warn(`Error loading localStorage key "${key}":`, error);
      return initialValue;
    }
  });

  // Return a wrapped version of useState's setter function that
  // persists the new value to localStorage
  const setValue = useCallback(
    (value: T | ((prev: T) => T)) => {
      try {
        // Allow value to be a function (for useState compatibility)
        const valueToStore =
          value instanceof Function ? value(storedValue) : value;

        setStoredValue(valueToStore);
        window.localStorage.setItem(key, JSON.stringify(valueToStore));
      } catch (error) {
        console.warn(`Error setting localStorage key "${key}":`, error);
      }
    },
    [key, storedValue]
  );

  return [storedValue, setValue];
}
```

**Key patterns:**
- Lazy initialization with function in useState
- Error handling (localStorage can fail)
- useCallback for stable function reference
- Support for functional updates: `setValue(prev => prev + 1)`

### Step 5: Add Return Type

**Explicit return type:**
```typescript
interface UseLocalStorageReturn<T> {
  value: T;
  setValue: (value: T | ((prev: T) => T)) => void;
  remove: () => void;
}

export function useLocalStorage<T>(
  key: string,
  initialValue: T
): UseLocalStorageReturn<T> {
  const [storedValue, setStoredValue] = useState<T>(/* ... */);

  const setValue = useCallback(/* ... */);

  const remove = useCallback(() => {
    try {
      window.localStorage.removeItem(key);
      setStoredValue(initialValue);
    } catch (error) {
      console.warn(`Error removing localStorage key "${key}":`, error);
    }
  }, [key, initialValue]);

  return {
    value: storedValue,
    setValue,
    remove
  };
}
```

**Benefits of explicit return type:**
- Clear API documentation
- Type safety for consumers
- IntelliSense autocomplete
- Easier refactoring

### Step 6: Use Hook in Component

**In a component:**
```typescript
// src/components/UserProfile.tsx
import { useLocalStorage } from '../hooks/useLocalStorage';

interface User {
  name: string;
  email: string;
}

export const UserProfile = () => {
  const [user, setUser] = useLocalStorage<User>('user', {
    name: '',
    email: ''
  });

  const handleNameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setUser(prev => ({ ...prev, name: e.target.value }));
  };

  return (
    <div>
      <input
        value={user.name}
        onChange={handleNameChange}
        placeholder="Name"
      />
      <input
        value={user.email}
        onChange={(e) => setUser(prev => ({ ...prev, email: e.target.value }))}
        placeholder="Email"
      />
      <p>Saved in localStorage!</p>
    </div>
  );
};
```

**Test in Docker:**
```bash
make dev-typescript
```

Changes to input persist across page refreshes!

## Verification

### Check Hook Works
- [ ] Hook can be imported
- [ ] TypeScript types are correct
- [ ] No TypeScript errors
- [ ] Hook returns expected values
- [ ] State updates correctly

### Check Type Safety
```bash
# Docker-first
make typecheck-typescript

# npm fallback
npm run typecheck
```

### Test Hook Behavior
```bash
# Run tests
make test-typescript

# Or with npm
npm test
```

### Manual Testing
- [ ] Use hook in a component
- [ ] Verify state persists
- [ ] Check edge cases (empty values, errors)
- [ ] Test in different components

## Common Issues and Solutions

### Issue 1: Hook called conditionally
**Symptom**: `React Hook "useHook" is called conditionally`

**Wrong:**
```typescript
if (someCondition) {
  const [value] = useLocalStorage('key', '');
}
```

**Right:**
```typescript
const [value] = useLocalStorage('key', '');
if (someCondition) {
  // use value
}
```

**Rules of Hooks:**
- Only call hooks at top level
- Don't call hooks in loops, conditions, or nested functions
- Only call hooks in React functions

### Issue 2: Infinite loop
**Symptom**: Component re-renders infinitely

**Wrong:**
```typescript
const [data, setData] = useState([]);
useEffect(() => {
  setData([...data, newItem]);  // Creates new array every time
}, [data]);  // Triggers effect again!
```

**Right:**
```typescript
const [data, setData] = useState([]);
useEffect(() => {
  setData(prev => [...prev, newItem]);
}, []);  // Only run once
```

### Issue 3: Stale closures
**Symptom**: Hook uses old values

**Wrong:**
```typescript
export function useInterval(callback: () => void, delay: number) {
  useEffect(() => {
    const id = setInterval(callback, delay);
    return () => clearInterval(id);
  }, [delay]);  // Missing callback in deps!
}
```

**Right:**
```typescript
export function useInterval(callback: () => void, delay: number) {
  const savedCallback = useRef(callback);

  useEffect(() => {
    savedCallback.current = callback;
  });

  useEffect(() => {
    const id = setInterval(() => savedCallback.current(), delay);
    return () => clearInterval(id);
  }, [delay]);
}
```

### Issue 4: Dependency array warnings
**Symptom**: ESLint warns about missing dependencies

**Solution:**
1. Add the dependency if it should trigger re-run
2. Use useCallback/useMemo if dependency changes too often
3. Use ref if value shouldn't trigger re-run
4. Disable lint only if absolutely sure (rare!)

## Best Practices

### Single Responsibility
```typescript
// ✓ Good - Does one thing well
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);
  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(handler);
  }, [value, delay]);
  return debouncedValue;
}

// ✗ Bad - Does too much
export function useEverything() {
  // Handles auth, fetching, local storage, theme...
  // Too complex!
}
```

### Proper Types
```typescript
// ✓ Good - Full type safety
export function useFetch<T>(url: string): {
  data: T | null;
  loading: boolean;
  error: Error | null;
} {
  // ...
}

// ✗ Bad - No types
export function useFetch(url) {
  // ...
}
```

### Memoization When Needed
```typescript
// ✓ Good - Stable function reference
const setValue = useCallback((value: T) => {
  // Implementation
}, [key]);

// ✓ Good - Expensive computation
const expensiveValue = useMemo(() => {
  return complexCalculation(data);
}, [data]);

// ✗ Bad - Unnecessary memoization
const simpleValue = useMemo(() => {
  return x + y;
}, [x, y]);
```

### Cleanup Functions
```typescript
// ✓ Good - Cleanup subscriptions
export function useWebSocket(url: string) {
  useEffect(() => {
    const ws = new WebSocket(url);

    ws.onmessage = (event) => {
      // Handle message
    };

    return () => {
      ws.close();  // Cleanup!
    };
  }, [url]);
}

// ✗ Bad - No cleanup (memory leak!)
export function useWebSocket(url: string) {
  useEffect(() => {
    const ws = new WebSocket(url);
    ws.onmessage = (event) => { /* ... */ };
  }, [url]);
}
```

## Templates Reference

This how-to references the following templates:

- `templates/react-hook.ts.template` - Basic hook template
- `templates/react-hook-with-state.ts.template` - Hook with state management

## Related How-Tos

- [How to Create a Component](how-to-create-a-component.md) - Using hooks in components
- [How to Write a Test](how-to-write-a-test.md) - Testing hooks
- [How to Add State Management](how-to-add-state-management.md) - Complex state patterns

## Additional Resources

- [React Hooks Documentation](https://react.dev/reference/react)
- [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks)
- [usehooks-ts](https://usehooks-ts.com/) - Collection of TypeScript hooks
- [React Hook Testing](https://react-hooks-testing-library.com/)
