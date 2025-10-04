# How-To: Modify Hero Section

**Purpose**: Customize the hero banner on HomePage including title, subtitle, and hero cards
**Scope**: HomePage component customization for project branding and key information display
**Overview**: Guide for modifying the hero banner section including main title/subtitle text and the grid of
    hero cards that highlight key features. Learn how to add, remove, or modify hero cards using the hero-card template.
**Dependencies**: UI scaffold installed, React development environment
**Exports**: Modified HomePage with custom hero content
**Related**: .ai/templates/hero-card.tsx.template, how-to-add-hero-card.md
**Implementation**: Direct file editing with template-based card addition
**Difficulty**: beginner
**Estimated Time**: 15min

---

## Prerequisites

- UI scaffold installed during react-python-fullstack setup
- Node.js and npm installed
- Code editor open to project directory

## Overview

The hero section is the first thing users see when visiting your application. It consists of:
1. **Hero Title**: Large main heading
2. **Hero Subtitle**: Descriptive tagline below the title
3. **Hero Cards**: Grid of information cards highlighting key features

This guide shows how to customize each element to match your project's branding and messaging.

## Steps

### Step 1: Locate HomePage Component

Open the HomePage component:

```bash
# File location
frontend/src/pages/HomePage/HomePage.tsx
```

### Step 2: Modify Hero Title and Subtitle

Find the hero content section and update the text:

```typescript
<div className="hero-content">
  <h1 className="hero-title">Your Custom Title</h1>
  <p className="hero-subtitle">
    Your custom subtitle describing your application's purpose and value
  </p>
</div>
```

**Examples**:
- Title: "Customer Portal", "Analytics Dashboard", "Team Collaboration Hub"
- Subtitle: "Streamline your workflow with powerful automation and insights"

### Step 3: Modify Existing Hero Cards

Locate the `heroCards` array near the top of the file:

```typescript
const heroCards: HeroCard[] = [
  {
    title: 'Your Feature Title',
    description: 'Description of this feature and its benefits',
    icon: '🎯'  // Change emoji icon
  },
  // ... more cards
];
```

Update the title, description, and icon for each card to match your application's features.

### Step 4: Add New Hero Card (Optional)

To add a new card, use the hero-card template:

```bash
# View the template
cat .ai/templates/hero-card.tsx.template
```

Add a new card object to the `heroCards` array:

```typescript
const heroCards: HeroCard[] = [
  // ... existing cards ...
  {
    title: 'Real-Time Updates',
    description: 'Live data synchronization with WebSocket connections',
    icon: '⚡'
  }
];
```

### Step 5: Remove Hero Card (Optional)

Simply delete the card object from the `heroCards` array. The responsive grid will automatically adjust.

### Step 6: Verify Changes

Start the development server and view your changes:

```bash
cd frontend
npm run dev
```

Open http://localhost:5173 in your browser and verify:
- Hero title and subtitle display correctly
- Hero cards show updated content
- Layout is responsive (test on mobile and desktop viewports)

## Verification

Check that your modifications display correctly:

```bash
# Start dev server
cd frontend && npm run dev

# Visual checks:
# ✓ Hero title updated
# ✓ Hero subtitle updated
# ✓ Hero cards show correct content
# ✓ Icons display properly
# ✓ Layout responsive on mobile (resize browser)
```

## Common Issues

### Issue: Hero Cards Not Displaying

**Symptoms**: Cards don't appear or layout is broken

**Causes**:
- Syntax error in `heroCards` array
- Missing comma between cards
- Invalid TypeScript object structure

**Solution**:
```bash
# Check for TypeScript errors
npx tsc --noEmit

# Verify heroCards array structure matches HeroCard interface
```

### Issue: Icons Don't Display

**Symptoms**: Emoji icons appear as boxes or don't show

**Cause**: System doesn't support emoji rendering

**Solution**: Use text-based icons or replace with icon library (Font Awesome, Material Icons)

### Issue: Layout Breaks on Mobile

**Symptoms**: Cards overflow or don't stack properly on small screens

**Cause**: Custom CSS overrides responsive grid

**Solution**: Check HomePage.css and ensure you haven't modified the `.hero-cards` grid styles

## Best Practices

1. **Keep It Concise**: Limit to 4-6 hero cards for best visual impact
2. **Consistent Tone**: Use similar language style across all card descriptions
3. **Relevant Icons**: Choose emojis that clearly represent each feature
4. **Mobile First**: Always test layout on mobile viewport (≤768px width)
5. **Accessibility**: Ensure text has sufficient contrast against background

## Checklist

- [ ] Hero title updated with project-specific text
- [ ] Hero subtitle clearly describes application value
- [ ] Hero cards reflect actual application features
- [ ] Icons are relevant and display correctly
- [ ] Layout tested on desktop viewport (≥1200px)
- [ ] Layout tested on mobile viewport (≤768px)
- [ ] Text is readable and accessible
- [ ] No TypeScript or linting errors

## Related Resources

- [How to Add Hero Card](how-to-add-hero-card.md) - Detailed guide for adding cards
- [Hero Card Template](.ai/templates/hero-card.tsx.template) - Template for new cards
- [HomePage.css](../../project-content/frontend/ui-scaffold/pages/HomePage/HomePage.css.template) - Styling reference
