# UI Architecture

**Purpose**: Architecture overview for UI scaffold components and navigation system
**Scope**: Frontend UI structure, routing, and component organization
**Overview**: Comprehensive explanation of UI scaffold architecture including component hierarchy,
    routing system, configuration patterns, state management approach, and design principles. Provides
    guidance for understanding and extending the UI structure.
**Dependencies**: React, React Router, UI scaffold components
**Exports**: Architectural context for UI development and modification
**Related**: COMPONENT_PATTERNS.md, STYLING_SYSTEM.md
**Implementation**: Component-based architecture with configuration-driven navigation

---

## Architecture Overview

The UI scaffold provides a modern, production-ready interface with:
- Hero banner homepage
- Tabbed navigation
- Principles display with modals
- Responsive design (mobile + desktop)

## Component Hierarchy

```
AppShell (Router, Layout)
├── Header (Branding)
├── TabNavigation (Tabs)
├── Routes
│   ├── HomePage
│   │   ├── Hero Section
│   │   ├── PrinciplesBanner
│   │   └── Getting Started
│   ├── Tab1 (Blank)
│   ├── Tab2 (Blank)
│   └── Tab3 (Blank)
└── Footer
```

## Component Responsibilities

### AppShell
- **Purpose**: Application layout and routing
- **Responsibilities**: Router setup, route definitions, layout structure
- **Dependencies**: React Router, all page components

### HomePage
- **Purpose**: Landing page with hero banner
- **Responsibilities**: Display hero content, cards, principles, getting started
- **State**: None (stateless, configuration-driven)

### PrinciplesBanner
- **Purpose**: Display numbered principle cards with modals
- **Responsibilities**: Render principle grid, modal state management, click handling
- **State**: selectedPrinciple (for modal)

### TabNavigation
- **Purpose**: Tab-based navigation bar
- **Responsibilities**: Render tabs from config, highlight active tab, routing
- **State**: React Router location (useLocation)

### Tab Components
- **Purpose**: Blank starter tabs for customization
- **Responsibilities**: Display tab content (placeholder initially)
- **State**: Add as needed for tab functionality

## Configuration System

Configuration-driven approach minimizes code changes for common customizations:

### tabs.config.ts
Defines all available tabs:
```typescript
{
  id: string,       // Unique identifier
  path: string,     // Route path
  label: string,    // Display text
  icon?: string     // Optional emoji
}
```

### principles.config.ts
Defines principle cards:
```typescript
{
  number: number,         // Sequential number
  title: string,          // Principle name
  shortDescription: string, // Card text
  fullDescription: string,  // Modal text
  icon?: string           // Optional emoji
}
```

## Routing System

React Router v6 with declarative routes:

```typescript
<Routes>
  <Route path="/" element={<HomePage />} />
  <Route path="/tab1" element={<Tab1 />} />
  ...
</Routes>
```

**Benefits**:
- Declarative route definitions
- Automatic active state management
- Easy to add new routes

## State Management

**Approach**: Minimal state, configuration-driven

**State Locations**:
- **PrinciplesBanner**: Modal state (local useState)
- **TabNavigation**: Router location (useLocation)
- **Future**: Add Context or state library as needed

## Design Principles

1. **Configuration Over Code**: Use config files for customization
2. **Responsive First**: Mobile and desktop support built-in
3. **Accessible**: Keyboard navigation, ARIA labels, focus states
4. **Modular**: Components are independent and reusable
5. **Extensible**: Easy to add tabs, modify content, extend functionality

## Adding Features

### New Tab
1. Create component in `features/`
2. Add to `tabs.config.ts`
3. Add route in `AppShell.tsx`

### New Principle
1. Add to `principles.config.ts`

### New Hero Card
1. Add to `heroCards` array in `HomePage.tsx`

## Related Documentation

- [Component Patterns](COMPONENT_PATTERNS.md)
- [Styling System](STYLING_SYSTEM.md)
- [How-To Guides](../howtos/)
