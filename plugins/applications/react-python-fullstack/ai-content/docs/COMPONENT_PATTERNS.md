# Component Patterns

**Purpose**: Reusable patterns and best practices for UI components
**Scope**: Component design patterns, TypeScript patterns, React best practices
**Overview**: Collection of proven patterns for building components in the UI scaffold including
    component structure, props patterns, state management, event handling, and accessibility.
**Dependencies**: React, TypeScript, UI scaffold components
**Exports**: Component design patterns and implementation examples
**Related**: UI_ARCHITECTURE.md, STYLING_SYSTEM.md
**Implementation**: Pattern catalog with examples and usage guidance

---

## Component Structure Pattern

**Standard Structure**:
```typescript
/**
 * File header with purpose, scope, overview
 */

import React from 'react';
import './Component.css';

interface ComponentProps {
  // Props definition
}

const Component: React.FC<ComponentProps> = ({ props }) => {
  // State
  // Effects
  // Handlers
  
  return (
    <div className="component">
      {/* JSX */}
    </div>
  );
};

export default Component;
```

## Configuration-Driven Pattern

**Use Case**: Content that changes frequently

**Pattern**:
```typescript
// config/items.config.ts
export const items = [
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' }
];

// Component.tsx
import { items } from '../config/items.config';

const Component = () => (
  <div>
    {items.map(item => (
      <div key={item.id}>{item.name}</div>
    ))}
  </div>
);
```

**Benefits**:
- Easy to modify without code changes
- Centralized configuration
- Type-safe with TypeScript

## Modal Pattern

**Use Case**: Popup dialogs, detail views

**Pattern**:
```typescript
const Component = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [selected, setSelected] = useState(null);

  const openModal = (item) => {
    setSelected(item);
    setIsOpen(true);
  };

  const closeModal = () => {
    setIsOpen(false);
    setSelected(null);
  };

  return (
    <>
      {/* Trigger */}
      <button onClick={() => openModal(item)}>Open</button>

      {/* Modal */}
      {isOpen && (
        <div className="modal-backdrop" onClick={closeModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button onClick={closeModal}>×</button>
            {/* Content */}
          </div>
        </div>
      )}
    </>
  );
};
```

## Responsive Grid Pattern

**Use Case**: Cards, items that should stack on mobile

**Pattern**:
```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}
```

**Behavior**:
- Desktop: Multiple columns
- Mobile: Single column (auto-stacks)

## Navigation Pattern

**Use Case**: Tab navigation with routing

**Pattern**:
```typescript
import { Link, useLocation } from 'react-router-dom';

const Navigation = () => {
  const location = useLocation();

  return (
    <nav>
      {tabs.map(tab => (
        <Link
          key={tab.id}
          to={tab.path}
          className={location.pathname === tab.path ? 'active' : ''}
        >
          {tab.label}
        </Link>
      ))}
    </nav>
  );
};
```

## Accessibility Patterns

**Keyboard Navigation**:
```typescript
<div
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      handleClick();
    }
  }}
>
  Clickable Element
</div>
```

**ARIA Labels**:
```typescript
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
>
  <h2 id="dialog-title">Dialog Title</h2>
</div>
```

## Best Practices

1. **TypeScript**: Always define prop interfaces
2. **Keys**: Use unique, stable keys in lists
3. **Event Handlers**: Use descriptive names (handleClick, not onClick)
4. **Accessibility**: Include keyboard navigation and ARIA labels
5. **Performance**: Use React.memo for expensive components
6. **State**: Keep state as local as possible

## Anti-Patterns to Avoid

❌ **Inline Styles**: Use CSS classes instead
❌ **Prop Drilling**: Use Context for deep prop passing
❌ **Index as Key**: Use unique IDs for list keys
❌ **Direct DOM Manipulation**: Use React state and refs
❌ **Missing Dependencies**: Include all dependencies in useEffect

## Related Documentation

- [UI Architecture](UI_ARCHITECTURE.md)
- [Styling System](STYLING_SYSTEM.md)
- [React Documentation](https://react.dev)
