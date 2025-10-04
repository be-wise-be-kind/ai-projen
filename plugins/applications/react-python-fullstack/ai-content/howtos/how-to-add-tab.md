# How-To: Add New Tab

**Purpose**: Add a new tab to the tabbed navigation system with routing
**Scope**: Tab creation and navigation configuration for fullstack application
**Overview**: Complete guide for adding new tabs to your application including creating the tab component,
    registering in tabs configuration, adding routing in AppShell, and verifying navigation works correctly.
**Dependencies**: UI scaffold installed, tab-component.tsx.template, React Router
**Exports**: New tab page accessible through navigation
**Related**: tab-component.tsx.template, tabs.config.ts, AppShell.tsx, how-to-modify-tab-content.md
**Implementation**: Template-based tab creation with configuration and routing setup
**Difficulty**: intermediate
**Estimated Time**: 20min

---

## Prerequisites

- UI scaffold installed
- Understanding of React components and TypeScript
- Familiarity with React Router
- Code editor open

## Overview

Adding a new tab involves four steps:
1. Create the tab component using the template
2. Register the tab in tabs configuration
3. Add the route in AppShell
4. Verify navigation and content display

This guide walks through each step with examples.

## Steps

### Step 1: Review Tab Component Template

View the template to understand the structure:

```bash
cat .ai/templates/tab-component.tsx.template
```

Note the placeholders:
- `{{TAB_NAME}}`: Component name (PascalCase)
- `{{TAB_TITLE}}`: Display title
- `{{TAB_DESCRIPTION}}`: Tab purpose description
- `{{TAB_ICON}}`: Emoji icon

### Step 2: Create Tab Component File

Create the new tab component directory and file:

```bash
# Create directory
mkdir -p frontend/src/features/Analytics

# Copy template
cp .ai/templates/tab-component.tsx.template frontend/src/features/Analytics/Analytics.tsx
```

### Step 3: Customize Tab Component

Edit the new file and replace placeholders:

```typescript
/**
 * Purpose: Analytics dashboard showing application metrics and insights
 * Scope: Analytics tab page in tabbed navigation system
 * ...
 */

import React from 'react';
import './Analytics.css';

const Analytics: React.FC = () => {
  return (
    <div className="tab-page">
      <div className="tab-content">
        <h1 className="tab-title">Analytics Dashboard</h1>
        <p className="tab-description">
          View comprehensive metrics, user activity, and performance insights
        </p>

        <div className="tab-placeholder">
          <div className="placeholder-icon">📊</div>
          <h2>Analytics Dashboard Content</h2>
          <p>
            Add charts, metrics, and data visualizations here.
          </p>
        </div>
      </div>
    </div>
  );
};

export default Analytics;
```

### Step 4: Create Tab CSS File

Create a CSS file for tab-specific styles:

```bash
# Option 1: Import shared styles
echo "@import url('../Tab1/Tab1.css');" > frontend/src/features/Analytics/Analytics.css

# Option 2: Create custom styles (copy from Tab1.css and customize)
```

### Step 5: Register Tab in Configuration

Edit `frontend/src/config/tabs.config.ts`:

```typescript
export const tabs: TabConfig[] = [
  {
    id: 'home',
    path: '/',
    label: 'Home',
    icon: '🏠'
  },
  // ... existing tabs ...
  {
    id: 'analytics',
    path: '/analytics',
    label: 'Analytics',
    icon: '📊'
  }
];
```

**Configuration Fields**:
- `id`: Unique identifier (lowercase, no spaces)
- `path`: URL route path (starts with `/`)
- `label`: Display text in navigation
- `icon`: Emoji icon (optional)

### Step 6: Add Route in AppShell

Edit `frontend/src/components/AppShell/AppShell.tsx`:

```typescript
// Add import at top
import Analytics from '../../features/Analytics/Analytics';

// Add route in <Routes> section
<Routes>
  <Route path="/" element={<HomePage />} />
  <Route path="/tab1" element={<Tab1 />} />
  <Route path="/tab2" element={<Tab2 />} />
  <Route path="/tab3" element={<Tab3 />} />
  <Route path="/analytics" element={<Analytics />} />
</Routes>
```

### Step 7: Verify Tab Navigation

Start development server and test:

```bash
cd frontend
npm run dev
```

Check:
1. New tab appears in navigation bar
2. Clicking tab navigates to correct path
3. Tab content displays correctly
4. Active state highlights current tab
5. URL updates to `/analytics`

## Verification

Comprehensive verification checklist:

```bash
# Start dev server
cd frontend && npm run dev

# Manual testing:
# ✓ Tab appears in navigation bar
# ✓ Tab icon displays correctly
# ✓ Clicking tab navigates to correct route
# ✓ Tab content renders properly
# ✓ Active state highlights selected tab
# ✓ Browser URL updates correctly
# ✓ Direct URL navigation works (refresh on /analytics)
# ✓ Mobile navigation works (test on small viewport)

# TypeScript check
npx tsc --noEmit

# Linting check
npm run lint
```

## Common Issues

### Issue: Tab Doesn't Appear in Navigation

**Symptoms**: New tab not visible in navigation bar

**Causes**:
- Tab not registered in `tabs.config.ts`
- TypeScript error preventing compilation

**Solution**:
```bash
# Check for errors
npx tsc --noEmit

# Verify tabs.config.ts has new entry
cat frontend/src/config/tabs.config.ts | grep "analytics"
```

### Issue: Clicking Tab Shows Blank Page

**Symptoms**: Navigation works but content doesn't display

**Causes**:
- Route not added in AppShell.tsx
- Component import missing or incorrect
- Component has runtime error

**Solution**:
```bash
# Check browser console for errors
# Verify AppShell.tsx has:
# 1. Import statement for component
# 2. <Route> element with correct path and element
```

### Issue: Active State Doesn't Highlight

**Symptoms**: Clicked tab doesn't show as active

**Cause**: Route path in `tabs.config.ts` doesn't match route in AppShell

**Solution**: Ensure paths match exactly (case-sensitive)

## Best Practices

1. **Consistent Naming**: Use same name for component, file, directory, and route
2. **Clear Labels**: Tab labels should be short (1-2 words)
3. **Relevant Icons**: Choose icons that represent tab content
4. **Logical Ordering**: Place related tabs next to each other
5. **Test Navigation**: Verify tab works from all other tabs

## Checklist

- [ ] Created tab component using template
- [ ] Customized component with appropriate content
- [ ] Created CSS file (shared or custom)
- [ ] Registered tab in tabs.config.ts
- [ ] Added import in AppShell.tsx
- [ ] Added route in AppShell.tsx
- [ ] Verified tab appears in navigation
- [ ] Verified clicking tab navigates correctly
- [ ] Verified active state highlights properly
- [ ] Tested direct URL navigation
- [ ] No TypeScript errors
- [ ] No linting errors
- [ ] Mobile navigation tested

## Related Resources

- [Tab Component Template](.ai/templates/tab-component.tsx.template)
- [How to Modify Tab Content](how-to-modify-tab-content.md)
- [tabs.config.ts](../../project-content/frontend/ui-scaffold/config/tabs.config.ts.template)
- [AppShell.tsx](../../project-content/frontend/ui-scaffold/components/AppShell/AppShell.tsx.template)
