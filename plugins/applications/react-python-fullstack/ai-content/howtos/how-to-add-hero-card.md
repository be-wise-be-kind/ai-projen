# How-To: Add Hero Card

**Purpose**: Add a new information card to the HomePage hero section grid
**Scope**: HomePage hero cards customization for feature highlights
**Overview**: Step-by-step guide for adding new hero cards to the hero section using the hero-card template.
    Hero cards display in a responsive grid and highlight key features or capabilities of your application.
**Dependencies**: UI scaffold installed, hero-card.tsx.template
**Exports**: Updated HomePage with new hero card
**Related**: how-to-modify-hero-section.md, hero-card.tsx.template
**Implementation**: Template-based card creation with configuration
**Difficulty**: beginner
**Estimated Time**: 10min

---

## Prerequisites

- UI scaffold installed
- Understanding of TypeScript object syntax
- Code editor open

## Overview

Hero cards appear in the hero section of your HomePage, displaying key features or capabilities. Each card includes:
- **Icon**: Emoji or icon representing the feature
- **Title**: Short, descriptive title
- **Description**: 1-2 sentence explanation

This guide shows how to add a new card using the provided template.

## Steps

### Step 1: Review Hero Card Template

View the hero card template to understand the structure:

```bash
cat .ai/templates/hero-card.tsx.template
```

The template shows the required fields:
- `title`: Feature name
- `description`: Feature description
- `icon`: Emoji icon (optional)

### Step 2: Open HomePage Component

```bash
# Edit file
code frontend/src/pages/HomePage/HomePage.tsx
```

### Step 3: Locate heroCards Array

Find the `heroCards` array definition near the top of the component:

```typescript
const heroCards: HeroCard[] = [
  {
    title: 'FastAPI Backend',
    description: 'Production-ready Python API...',
    icon: '🚀'
  },
  // ... more cards
];
```

### Step 4: Add New Hero Card

Add your new card object to the end of the array:

```typescript
const heroCards: HeroCard[] = [
  // ... existing cards ...
  {
    title: 'Real-Time Updates',
    description: 'WebSocket integration for live data synchronization and instant notifications',
    icon: '⚡'
  }
];
```

**Important**: Don't forget the comma after the previous card!

### Step 5: Choose Appropriate Icon

Select an emoji that represents your feature. Common choices:
- Data/Analytics: 📊 📈 📉 🔍
- Performance: ⚡ 🚀 💨 ⏱️
- Security: 🔒 🛡️ 🔐 🔑
- Testing: ✅ 🧪 ✓ 🎯
- Deployment: 🏭 📦 🌐 ☁️
- Real-time: ⚡ 🔄 📡 💬

### Step 6: Write Effective Card Content

**Title Guidelines**:
- 2-4 words
- Clear and specific
- Action-oriented or feature-focused

**Description Guidelines**:
- 1-2 sentences (under 150 characters)
- Focus on benefits, not implementation
- Use active voice

**Good Examples**:
```typescript
{
  title: 'Advanced Analytics',
  description: 'Comprehensive dashboards with real-time metrics and historical trends',
  icon: '📊'
}

{
  title: 'Team Collaboration',
  description: 'Built-in chat, comments, and notifications keep everyone aligned',
  icon: '👥'
}
```

**Bad Examples**:
```typescript
{
  title: 'Feature',  // Too vague
  description: 'This feature uses Redis to cache data',  // Too technical
  icon: '❓'  // Unclear icon
}
```

### Step 7: Verify Layout

Check that the responsive grid handles your new card:

```bash
cd frontend && npm run dev
```

Visual checklist:
- Card appears in grid
- Grid remains balanced (ideally 4 columns on desktop)
- Card content fits within card bounds
- Icon displays correctly
- Mobile layout stacks cards vertically

## Verification

Confirm your new hero card displays correctly:

```bash
# Start development server
cd frontend
npm run dev

# Open http://localhost:5173

# Visual verification:
# ✓ New card appears in hero section
# ✓ Icon displays correctly
# ✓ Title is clear and readable
# ✓ Description fits without overflow
# ✓ Grid layout is balanced
# ✓ Mobile layout works (resize browser to <768px)
```

## Common Issues

### Issue: Card Content Overflows

**Symptoms**: Text spills outside card boundaries

**Cause**: Description text too long

**Solution**: Shorten description to under 150 characters. Consider rephrasing for brevity.

### Issue: Grid Layout Imbalanced

**Symptoms**: Cards don't align evenly or have different heights

**Cause**: Vastly different content lengths between cards

**Solution**: Keep card descriptions similar in length. Aim for consistency across all cards.

### Issue: TypeScript Error

**Symptoms**: Red squiggles or type error in editor

**Causes**:
- Missing comma between cards
- Incorrect property names (use `title`, `description`, `icon`)
- Missing closing brace

**Solution**:
```bash
# Check for TypeScript errors
npx tsc --noEmit
```

## Best Practices

1. **Limit Total Cards**: 4-6 cards is optimal for visual balance
2. **Consistent Length**: Keep descriptions similar in length
3. **Clear Icons**: Use widely recognized emoji icons
4. **User Benefits**: Focus on what users gain, not technical details
5. **Test Responsiveness**: Always verify mobile layout

## Checklist

- [ ] Reviewed hero card template
- [ ] Added new card object to heroCards array
- [ ] Chose appropriate icon emoji
- [ ] Wrote clear, concise title (2-4 words)
- [ ] Wrote benefit-focused description (<150 chars)
- [ ] Verified proper TypeScript syntax (no errors)
- [ ] Tested on desktop viewport (card appears correctly)
- [ ] Tested on mobile viewport (card stacks properly)
- [ ] Confirmed grid layout remains balanced

## Related Resources

- [Hero Card Template](.ai/templates/hero-card.tsx.template)
- [How to Modify Hero Section](how-to-modify-hero-section.md)
- [HomePage Component](../../project-content/frontend/ui-scaffold/pages/HomePage/HomePage.tsx.template)
