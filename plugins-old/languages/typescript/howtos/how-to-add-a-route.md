# How to Add a Route

## Purpose
Add a new route to a React application using React Router with lazy loading, TypeScript route parameters, and proper navigation.

## Scope
React Router setup, route configuration, lazy loading, route parameters, navigation, protected routes, Docker development

## Overview
This guide shows you how to add new routes to a React application using React Router, including lazy-loaded pages, typed route parameters, and navigation between routes.

## Dependencies
- TypeScript plugin installed
- React Router installed (`npm install react-router-dom`)
- Docker (recommended) or npm

## Prerequisites
- React application with routing configured
- Understanding of React components
- TypeScript basics
- Docker running or Node.js installed

## Quick Start

### 1. Create Page Component
```bash
mkdir -p src/pages/UserProfile
touch src/pages/UserProfile/UserProfile.tsx
touch src/pages/UserProfile/index.ts
```

### 2. Define Route
Add route to your router configuration.

### 3. Test Navigation
```bash
make dev-typescript
```

## Implementation Steps

### Step 1: Create Page Component

**Use template:**
```bash
cp /path/to/plugin/templates/react-page-component.tsx.template src/pages/UserProfile/UserProfile.tsx
```

**Or create manually:**
```typescript
// src/pages/UserProfile/UserProfile.tsx
import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import styles from './UserProfile.module.css';

interface UserProfileParams {
  userId: string;
}

export const UserProfile: React.FC = () => {
  const { userId } = useParams<UserProfileParams>();
  const navigate = useNavigate();

  const handleBack = () => {
    navigate('/users');
  };

  return (
    <div className={styles.container}>
      <h1>User Profile</h1>
      <p>User ID: {userId}</p>
      <button onClick={handleBack}>Back to Users</button>
    </div>
  );
};

export default UserProfile;
```

**Barrel export (src/pages/UserProfile/index.ts):**
```typescript
export { UserProfile } from './UserProfile';
export default UserProfile;
```

### Step 2: Define Route in Router Configuration

**React Router v6 (current):**
```typescript
// src/App.tsx or src/routes.tsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { lazy, Suspense } from 'react';

// Lazy load pages
const HomePage = lazy(() => import('./pages/Home'));
const UserProfile = lazy(() => import('./pages/UserProfile'));
const UsersPage = lazy(() => import('./pages/Users'));
const NotFound = lazy(() => import('./pages/NotFound'));

export function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<div>Loading...</div>}>
        <Routes>
          {/* Home route */}
          <Route path="/" element={<HomePage />} />

          {/* Users routes */}
          <Route path="/users" element={<UsersPage />} />
          <Route path="/users/:userId" element={<UserProfile />} />

          {/* 404 */}
          <Route path="*" element={<NotFound />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
```

**Use template:**
```bash
cp /path/to/plugin/templates/react-router-config.tsx.template src/routes.tsx
```

**Nested routes:**
```typescript
<Routes>
  <Route path="/" element={<Layout />}>
    <Route index element={<HomePage />} />
    <Route path="users">
      <Route index element={<UsersPage />} />
      <Route path=":userId" element={<UserProfile />} />
      <Route path=":userId/edit" element={<EditUserProfile />} />
    </Route>
  </Route>
</Routes>
```

### Step 3: Add Route Parameters (if needed)

**Define route with parameters:**
```typescript
// Route definition
<Route path="/users/:userId" element={<UserProfile />} />
<Route path="/posts/:postId/comments/:commentId" element={<Comment />} />
```

**Use parameters in component:**
```typescript
import { useParams } from 'react-router-dom';

interface RouteParams {
  userId: string;
  // If you have multiple params
  postId?: string;
  commentId?: string;
}

export const UserProfile: React.FC = () => {
  const params = useParams<RouteParams>();

  // params.userId is typed as string | undefined
  // Convert to number if needed
  const userId = params.userId ? parseInt(params.userId, 10) : null;

  if (!userId) {
    return <div>Invalid user ID</div>;
  }

  return <div>User {userId}</div>;
};
```

**Query parameters:**
```typescript
import { useSearchParams } from 'react-router-dom';

export const SearchPage: React.FC = () => {
  const [searchParams, setSearchParams] = useSearchParams();

  const query = searchParams.get('q') || '';
  const page = parseInt(searchParams.get('page') || '1', 10);

  const handleSearch = (newQuery: string) => {
    setSearchParams({ q: newQuery, page: '1' });
  };

  return (
    <div>
      <input
        value={query}
        onChange={(e) => handleSearch(e.target.value)}
      />
      <p>Page: {page}</p>
    </div>
  );
};
```

### Step 4: Implement Navigation

**Navigate programmatically:**
```typescript
import { useNavigate } from 'react-router-dom';

export const UsersPage: React.FC = () => {
  const navigate = useNavigate();

  const handleUserClick = (userId: string) => {
    navigate(`/users/${userId}`);
  };

  const handleBack = () => {
    navigate(-1);  // Go back
  };

  const handleHome = () => {
    navigate('/');  // Go to home
  };

  return (
    <div>
      <button onClick={() => handleUserClick('123')}>View User</button>
      <button onClick={handleBack}>Back</button>
      <button onClick={handleHome}>Home</button>
    </div>
  );
};
```

**Navigate with Link:**
```typescript
import { Link, NavLink } from 'react-router-dom';

export const Navigation: React.FC = () => {
  return (
    <nav>
      {/* Basic link */}
      <Link to="/">Home</Link>

      {/* Link with state */}
      <Link to="/users/123" state={{ from: 'navigation' }}>
        User 123
      </Link>

      {/* NavLink - active class automatically applied */}
      <NavLink
        to="/users"
        className={({ isActive }) => isActive ? 'active' : ''}
      >
        Users
      </NavLink>
    </nav>
  );
};
```

### Step 5: Add Route Guards/Protection (Optional)

**Protected routes:**
```typescript
// src/components/ProtectedRoute.tsx
import { Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';

interface ProtectedRouteProps {
  children: React.ReactNode;
}

export const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children }) => {
  const { isAuthenticated } = useAuth();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
};
```

**Use in routes:**
```typescript
<Routes>
  <Route path="/login" element={<LoginPage />} />
  <Route
    path="/dashboard"
    element={
      <ProtectedRoute>
        <DashboardPage />
      </ProtectedRoute>
    }
  />
</Routes>
```

### Step 6: Test Navigation in Docker

**Start development server:**
```bash
make dev-typescript
```

**Test the route:**
1. Navigate to `http://localhost:5173/users/123`
2. Verify component renders
3. Check parameters work
4. Test navigation buttons
5. Verify lazy loading (check Network tab)

**Hot reload:**
- Make changes to page component
- Save file
- Browser updates automatically
- Route state preserved

## Verification

### Check Route Works
- [ ] Navigate to route in browser
- [ ] Page component renders
- [ ] URL matches route definition
- [ ] No console errors

### Check Route Parameters
- [ ] Parameters extracted correctly
- [ ] TypeScript types work
- [ ] Invalid params handled gracefully

### Check Navigation
- [ ] Links navigate correctly
- [ ] Programmatic navigation works
- [ ] Back button works
- [ ] Active link styling applied

### Check Lazy Loading
```bash
# Open browser DevTools > Network tab
# Navigate to route
# Should see separate chunk loaded
```

## Common Issues and Solutions

### Issue 1: 404 on page refresh
**Symptom**: Route works in app, but refresh shows 404

**Solution**: Configure your server for SPA routing

**Docker with nginx (production):**
```nginx
# nginx.conf
location / {
  try_files $uri $uri/ /index.html;
}
```

**Vite dev server (development):**
Already configured for SPA routing!

### Issue 2: Parameters undefined
**Symptom**: `useParams()` returns undefined

**Solution:**
```typescript
// Wrong route definition
<Route path="/users" element={<UserProfile />} />

// Correct - with parameter
<Route path="/users/:userId" element={<UserProfile />} />

// In component
const { userId } = useParams();
// Always check if userId exists
if (!userId) {
  return <div>User not found</div>;
}
```

### Issue 3: Lazy loading errors
**Symptom**: `ChunkLoadError` or blank page

**Solution:**
1. Check import path is correct
2. Ensure component has default export
3. Wrap in Suspense:

```typescript
<Suspense fallback={<Loading />}>
  <Routes>
    {/* routes */}
  </Routes>
</Suspense>
```

### Issue 4: Route conflicts
**Symptom**: Wrong route matches

**Solution:**
```typescript
// Wrong order
<Route path="/users/:userId" element={<UserProfile />} />
<Route path="/users/new" element={<NewUser />} />
// "/users/new" matches first route!

// Correct order - specific routes first
<Route path="/users/new" element={<NewUser />} />
<Route path="/users/:userId" element={<UserProfile />} />
```

### Issue 5: Active link not highlighting
**Symptom**: NavLink active class not applied

**Solution:**
```typescript
// Use className as function
<NavLink
  to="/users"
  className={({ isActive }) => isActive ? 'active' : ''}
>
  Users
</NavLink>

// Or use end prop for exact matching
<NavLink to="/" end>
  Home
</NavLink>
```

## Best Practices

### Route Organization
```typescript
// ✓ Good - Organized by feature
src/
├── pages/
│   ├── Home/
│   │   ├── Home.tsx
│   │   └── index.ts
│   ├── Users/
│   │   ├── UsersList.tsx
│   │   ├── UserProfile.tsx
│   │   └── index.ts
│   └── Dashboard/
└── routes.tsx

// ✗ Bad - Flat structure
src/
├── Home.tsx
├── UsersList.tsx
├── UserProfile.tsx
└── Dashboard.tsx
```

### Lazy Loading
```typescript
// ✓ Good - Lazy load pages
const UserProfile = lazy(() => import('./pages/UserProfile'));

<Suspense fallback={<Loading />}>
  <Routes>
    <Route path="/users/:userId" element={<UserProfile />} />
  </Routes>
</Suspense>

// ✗ Bad - Eager loading (large initial bundle)
import { UserProfile } from './pages/UserProfile';
```

### Typed Parameters
```typescript
// ✓ Good - Type-safe parameters
interface RouteParams {
  userId: string;
}

const { userId } = useParams<RouteParams>();
if (!userId) {
  return <NotFound />;
}

// ✗ Bad - No type safety
const { userId } = useParams();
// userId could be anything!
```

### Route Constants
```typescript
// ✓ Good - Centralized route paths
export const ROUTES = {
  HOME: '/',
  USERS: '/users',
  USER_PROFILE: (id: string) => `/users/${id}`,
  USER_EDIT: (id: string) => `/users/${id}/edit`,
} as const;

// Use in navigation
navigate(ROUTES.USER_PROFILE('123'));

// Use in route definition
<Route path={ROUTES.USER_PROFILE(':userId')} element={<UserProfile />} />

// ✗ Bad - Hardcoded strings everywhere
navigate('/users/123');
<Route path="/users/:userId" />
```

## Templates Reference

This how-to references the following templates:

- `templates/react-page-component.tsx.template` - Page component template
- `templates/react-router-config.tsx.template` - Router configuration

## Related How-Tos

- [How to Create a Component](how-to-create-a-component.md) - Creating page components
- [How to Add State Management](how-to-add-state-management.md) - Global state with routing
- [How to Write a Test](how-to-write-a-test.md) - Testing routes

## Additional Resources

- [React Router Documentation](https://reactrouter.com/)
- [React Router Tutorial](https://reactrouter.com/en/main/start/tutorial)
- [Lazy Loading](https://react.dev/reference/react/lazy)
- [Code Splitting](https://react.dev/learn/code-splitting)
