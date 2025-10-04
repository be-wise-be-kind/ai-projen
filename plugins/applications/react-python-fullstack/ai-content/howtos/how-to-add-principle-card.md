# How-To: Add Principle Card

**Purpose**: Add new numbered principle card to PrinciplesBanner with modal popup
**Scope**: Principles banner customization for project values display
**Overview**: Guide for adding principle cards using the principle-card template, including card display
    and detailed modal popup content.
**Dependencies**: UI scaffold installed, principle-card.ts.template
**Exports**: Updated principles banner with new principle
**Related**: principle-card.ts.template, principles.config.ts
**Implementation**: Template-based principle addition with configuration
**Difficulty**: beginner
**Estimated Time**: 10min

---

## Prerequisites

- UI scaffold installed
- Understanding of TypeScript configuration files

## Steps

### Step 1: Review Principle Template

```bash
cat .ai/templates/principle-card.ts.template
```

### Step 2: Edit Principles Configuration

```bash
code frontend/src/config/principles.config.ts
```

### Step 3: Add New Principle

Add to the `principles` array:

```typescript
export const principles: Principle[] = [
  // ... existing principles ...
  {
    number: 6,
    title: 'Scalability',
    shortDescription: 'Built to scale from prototype to production',
    fullDescription: `Scalable architecture supports growth:

• Horizontal scaling with containerization
• Database optimization patterns
• Caching strategies
• Load balancing ready`,
    icon: '📈'
  }
];
```

### Step 4: Verify Display

```bash
cd frontend && npm run dev
# Click new principle card to see modal
```

## Verification

- [ ] Card appears in principles banner
- [ ] Clicking card opens modal
- [ ] Modal shows full description
- [ ] Modal closes with X or backdrop click
- [ ] Mobile layout works

## Related Resources

- [Principle Card Template](.ai/templates/principle-card.ts.template)
- [PrinciplesBanner Component](../../project-content/frontend/ui-scaffold/components/PrinciplesBanner/)
