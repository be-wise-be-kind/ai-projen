# How to Create a React Component

## Purpose
Create a React component with TypeScript using Docker-first development workflow, including proper typing, styling, and testing.

## Scope
React component creation, TypeScript interfaces, CSS modules, component architecture, Docker development workflow

## Overview
This guide walks you through creating a React component with TypeScript in a Docker-first environment. You'll learn how to structure components, define props with TypeScript, add styling, and verify your component works with hot reload.

## Dependencies
- TypeScript plugin installed
- React installed (`npm install react react-dom`)
- Vite or similar bundler configured
- Docker and Docker Compose (recommended) or npm (fallback)

## Prerequisites
- Basic understanding of React functional components
- Familiarity with TypeScript syntax
- TypeScript plugin installed in project
- Docker running (preferred) or Node.js installed

## Quick Start

### 1. Choose Component Type
Decide on your component type:
- **Functional component** - Simple, stateless component
- **Functional with hooks** - Component using useState, useEffect, etc.
- **Complex component** - Full-featured with state, effects, memoization

### 2. Create Component File
```bash
# Create component directory
mkdir -p src/components/UserCard

# Create files
touch src/components/UserCard/UserCard.tsx
touch src/components/UserCard/UserCard.module.css
touch src/components/UserCard/index.ts
```

### 3. Use Template
Copy and customize the appropriate template:

**For simple functional component:**
```bash
cp /path/to/plugin/templates/react-component.tsx.template src/components/UserCard/UserCard.tsx
```

**For component with hooks:**
```bash
cp /path/to/plugin/templates/react-component-with-hooks.tsx.template src/components/UserCard/UserCard.tsx
```

## Implementation Steps

### Step 1: Choose Component Type

**Simple Functional Component**:
- No internal state
- Receives props, renders UI
- Example: Avatar, Badge, Label

**Component with Hooks**:
- Internal state (useState)
- Side effects (useEffect)
- Memoization (useMemo, useCallback)
- Example: SearchInput, Dropdown, Modal

**When to use each:**
- Use simple functional for presentation-only components
- Use hooks when you need state, effects, or complex logic
- Start simple, add hooks as needed

### Step 2: Create Component File with Proper TypeScript Types

**Using template (recommended):**
Use `templates/react-component.tsx.template` or `templates/react-component-with-hooks.tsx.template`

**Manual creation:**
```typescript
// src/components/UserCard/UserCard.tsx
import React from 'react';
import styles from './UserCard.module.css';

interface UserCardProps {
  // Define your props here
  name: string;
  email: string;
  avatar?: string;
  onClick?: () => void;
}

export const UserCard: React.FC<UserCardProps> = ({
  name,
  email,
  avatar,
  onClick
}) => {
  return (
    <div className={styles.container}>
      {avatar && <img src={avatar} alt={name} className={styles.avatar} />}
      <div className={styles.info}>
        <h3 className={styles.name}>{name}</h3>
        <p className={styles.email}>{email}</p>
      </div>
      {onClick && (
        <button onClick={onClick} className={styles.button}>
          View Profile
        </button>
      )}
    </div>
  );
};
```

**Key TypeScript concepts:**
- `interface UserCardProps` - Type definition for props
- `React.FC<UserCardProps>` - Functional component type
- Optional props with `?`
- Destructuring props for cleaner code

### Step 3: Define Props Interface

**Best practices for props:**
```typescript
interface UserCardProps {
  // Required props (no ?)
  name: string;
  email: string;

  // Optional props (with ?)
  avatar?: string;
  className?: string;

  // Event handlers
  onClick?: () => void;
  onEdit?: (id: string) => void;

  // Children
  children?: React.ReactNode;

  // Complex types
  user?: {
    id: string;
    role: 'admin' | 'user';
  };
}
```

**Common prop types:**
- `string`, `number`, `boolean` - Primitives
- `string[]`, `number[]` - Arrays
- `() => void` - Functions with no return
- `(param: Type) => ReturnType` - Functions with params
- `React.ReactNode` - Any renderable content
- `'option1' | 'option2'` - Union types (enums)

### Step 4: Implement Component with JSX

**Component structure:**
```typescript
export const UserCard: React.FC<UserCardProps> = ({
  name,
  email,
  avatar,
  onClick
}) => {
  // 1. Hooks (if needed)
  const [isHovered, setIsHovered] = React.useState(false);

  // 2. Computed values
  const displayName = name.trim() || 'Unknown User';

  // 3. Event handlers
  const handleMouseEnter = () => setIsHovered(true);
  const handleMouseLeave = () => setIsHovered(false);

  // 4. Render
  return (
    <div
      className={styles.container}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      {avatar && <img src={avatar} alt={name} />}
      <h3>{displayName}</h3>
      <p>{email}</p>
      {onClick && <button onClick={onClick}>View</button>}
    </div>
  );
};
```

**JSX best practices:**
- Conditional rendering: `{condition && <Element />}`
- Lists: `{items.map(item => <Item key={item.id} />)}`
- Event handlers: `onClick={handleClick}` (not `onClick={handleClick()}`)
- Always include `key` prop in lists

### Step 5: Add CSS/Styled Components

**Create CSS Module:**
```css
/* src/components/UserCard/UserCard.module.css */
.container {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  background: white;
  transition: box-shadow 0.2s;
}

.container:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
}

.info {
  flex: 1;
}

.name {
  margin: 0;
  font-size: 1.125rem;
  font-weight: 600;
  color: #333;
}

.email {
  margin: 0.25rem 0 0;
  font-size: 0.875rem;
  color: #666;
}

.button {
  padding: 0.5rem 1rem;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.button:hover {
  background: #0056b3;
}
```

**Import and use:**
```typescript
import styles from './UserCard.module.css';

// Use in JSX
<div className={styles.container}>
  <h3 className={styles.name}>{name}</h3>
</div>
```

**CSS Module benefits:**
- Scoped styles (no global conflicts)
- Type-safe in TypeScript
- Works with Docker hot reload

### Step 6: Test with Hot Reload

**Start development server:**
```bash
# Docker-first (recommended)
make dev-typescript

# npm fallback
npm run dev
```

**Import and use your component:**
```typescript
// src/App.tsx
import { UserCard } from './components/UserCard/UserCard';

function App() {
  return (
    <div>
      <h1>User Directory</h1>
      <UserCard
        name="John Doe"
        email="john@example.com"
        avatar="/avatar.jpg"
        onClick={() => console.log('Clicked!')}
      />
    </div>
  );
}
```

**Test the component:**
1. Save the file
2. Check browser - component should appear
3. Make a change (e.g., change text color)
4. Save again - hot reload should update instantly
5. Check console for errors

**Hot reload works in Docker:**
- Volume mounts sync file changes
- Vite HMR updates browser automatically
- No rebuild needed for code changes

### Step 7: Create Barrel Export (Optional)

**Create index file:**
```typescript
// src/components/UserCard/index.ts
export { UserCard } from './UserCard';
export type { UserCardProps } from './UserCard';
```

**Benefits:**
```typescript
// Without barrel export
import { UserCard } from './components/UserCard/UserCard';

// With barrel export
import { UserCard } from './components/UserCard';
```

## Verification

### Check Component Renders
- [ ] Component appears in browser
- [ ] All props display correctly
- [ ] Styling is applied
- [ ] No console errors

### Check TypeScript Types
```bash
# Docker-first
make typecheck-typescript

# npm fallback
npm run typecheck
```

Expected output:
```
✓ No TypeScript errors
```

### Check Hot Reload
- [ ] Make a text change, save
- [ ] Browser updates without full refresh
- [ ] Component state preserved (if any)

### Check in Different States
- [ ] Component with all props
- [ ] Component with minimal props
- [ ] Component with missing optional props
- [ ] Event handlers work (onClick, etc.)

## Common Issues and Solutions

### Issue 1: Module not found
**Symptom**: `Cannot find module './UserCard.module.css'`

**Solution**:
1. Ensure CSS file exists
2. Check file name matches import exactly (case-sensitive)
3. Add type declaration for CSS modules:

```typescript
// src/vite-env.d.ts
/// <reference types="vite/client" />

declare module '*.module.css' {
  const classes: { [key: string]: string };
  export default classes;
}
```

### Issue 2: Type errors on props
**Symptom**: `Type 'string' is not assignable to type 'number'`

**Solution**:
1. Check prop types in interface match usage
2. Provide correct type when using component
3. Use optional props with `?` if prop may not exist

```typescript
// Wrong
<UserCard name={123} />

// Right
<UserCard name="John Doe" />
```

### Issue 3: CSS not loading
**Symptom**: Component renders but has no styling

**Solution**:
1. Check CSS Module import: `import styles from './File.module.css'`
2. Ensure file ends with `.module.css` not just `.css`
3. Use `className={styles.className}` not `class=`
4. Check Docker volume mounts include CSS files
5. Restart dev server: `make dev-typescript-stop && make dev-typescript`

### Issue 4: Hot reload not working
**Symptom**: Changes require manual refresh

**Solution**:
1. Check Docker volume mounts are correct
2. Ensure dev server runs with `--host 0.0.0.0` flag
3. Verify docker-compose has volume mounts for src/
4. Check no syntax errors in file
5. Try: `make dev-typescript-stop && make dev-typescript`

### Issue 5: Props not working
**Symptom**: Component doesn't respond to props

**Solution**:
1. Check destructuring: `{ name }` not `props.name` unless you meant to
2. Ensure prop names match interface
3. Pass props correctly: `<UserCard name="John" />` not `<UserCard name=John />`

## Best Practices

### Props Interface
```typescript
// ✓ Good - Descriptive interface name
interface UserCardProps {
  userId: string;
  userName: string;
  onUserClick?: (id: string) => void;
}

// ✗ Bad - Generic name
interface Props {
  id: string;
  name: string;
  onClick?: () => void;
}
```

### Default Props
```typescript
// Modern approach with destructuring defaults
export const UserCard: React.FC<UserCardProps> = ({
  name,
  email,
  avatar = '/default-avatar.png',  // Default value
  onClick
}) => {
  // ...
};

// Or use optional chaining
<img src={avatar || '/default-avatar.png'} alt={name} />
```

### React.memo for Performance
```typescript
// Use React.memo for expensive components
import React, { memo } from 'react';

export const UserCard = memo<UserCardProps>(({
  name,
  email,
  avatar,
  onClick
}) => {
  // Component implementation
});

// Component only re-renders when props change
```

**When to use React.memo:**
- Component renders often with same props
- Component has expensive calculations
- Parent re-renders frequently
- NOT needed for simple components

### Event Handler Naming
```typescript
// ✓ Good - Descriptive, follows convention
const handleUserClick = () => { };
const handleEmailChange = (e: React.ChangeEvent<HTMLInputElement>) => { };
const handleSubmit = (e: React.FormEvent) => { };

// ✗ Bad - Unclear naming
const click = () => { };
const onChange = () => { };
```

### File Organization
```
src/components/UserCard/
├── UserCard.tsx              # Component implementation
├── UserCard.module.css       # Styles
├── UserCard.test.tsx         # Tests
├── UserCard.types.ts         # Type definitions (if complex)
└── index.ts                  # Barrel export
```

## Templates Reference

This how-to references the following templates:

- `templates/react-component.tsx.template` - Basic functional component
- `templates/react-component-with-hooks.tsx.template` - Component with hooks
- `templates/component.module.css.template` - CSS Module template

## Related How-Tos

- [How to Write a Test](how-to-write-a-test.md) - Testing your component
- [How to Create a Hook](how-to-create-a-hook.md) - Custom hooks for logic
- [How to Add State Management](how-to-add-state-management.md) - Global state

## Additional Resources

- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [React Documentation](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [CSS Modules Documentation](https://github.com/css-modules/css-modules)
