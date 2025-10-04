# Styling System

**Purpose**: CSS architecture and styling conventions for UI scaffold
**Scope**: CSS organization, naming conventions, responsive design patterns
**Overview**: Comprehensive guide to the styling system including CSS architecture, naming patterns,
    responsive breakpoints, color palette, typography scale, and customization guidelines.
**Dependencies**: CSS3, responsive design patterns
**Exports**: Styling guidelines and patterns for consistent UI development
**Related**: UI_ARCHITECTURE.md, COMPONENT_PATTERNS.md
**Implementation**: Component-scoped CSS with shared patterns and utilities

---

## CSS Architecture

**Approach**: Component-scoped CSS with shared patterns

Each component has its own CSS file:
```
HomePage.tsx → HomePage.css
PrinciplesBanner.tsx → PrinciplesBanner.css
Tab1.tsx → Tab1.css
```

## Naming Conventions

**Pattern**: BEM-inspired with component prefixes

```css
.component-name { }
.component-element { }
.component-element-modifier { }
```

**Examples**:
```css
.hero-section { }
.hero-card { }
.hero-card-title { }
.hero-card:hover { }
```

## Color Palette

**Primary Colors**:
```css
Primary Purple: #667eea
Secondary Purple: #764ba2
```

**Neutrals**:
```css
Background: #f5f7fa
Light Gray: #e0e0e0
Text Dark: #333
Text Medium: #666
White: #ffffff
```

**Gradients**:
```css
Hero: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
Background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)
```

## Typography

**Font Stack**: System fonts for performance
```css
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', ...
```

**Scale**:
```css
Hero Title: 3rem (48px)
Section Title: 2rem (32px)
Card Title: 1.5rem (24px)
Body: 1rem (16px)
Small: 0.875rem (14px)
```

## Responsive Breakpoints

```css
Desktop: ≥1200px
Tablet: 768px - 1199px
Mobile: <768px
Small Mobile: <480px
```

**Pattern**:
```css
/* Desktop first */
.element { }

@media (max-width: 768px) {
  /* Tablet/Mobile */
}

@media (max-width: 480px) {
  /* Small mobile */
}
```

## Layout Patterns

**Grid System**:
```css
.hero-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}
```

**Flexbox Layout**:
```css
.tab-navigation-content {
  display: flex;
  gap: 1rem;
}
```

## Common Patterns

**Card Pattern**:
```css
.card {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 12px rgba(0, 0, 0, 0.15);
}
```

**Modal Pattern**:
```css
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  max-width: 600px;
  animation: slideUp 0.3s ease;
}
```

## Customization

### Change Primary Color

Replace `#667eea` throughout CSS files:
```bash
find frontend -name "*.css" -exec sed -i 's/#667eea/#your-color/g' {} +
```

### Adjust Spacing

Modify padding/margin values:
```css
/* Before */
padding: 2rem;

/* After */
padding: 3rem; /* Increase spacing */
```

### Custom Fonts

Update font-family in root styles:
```css
body {
  font-family: 'Your Font', -apple-system, ...;
}
```

## Best Practices

1. **Scoped Styles**: Keep CSS scoped to components
2. **Mobile First**: Design for mobile, enhance for desktop
3. **Performance**: Use CSS over JavaScript for animations
4. **Accessibility**: Maintain color contrast ratios
5. **Consistency**: Reuse patterns and variables

## Related Documentation

- [UI Architecture](UI_ARCHITECTURE.md)
- [Component Patterns](COMPONENT_PATTERNS.md)
