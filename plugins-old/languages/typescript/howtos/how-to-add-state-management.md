# How to Add State Management

## Purpose
Implement global state management in a React application using Context API, Redux Toolkit, or Zustand with TypeScript.

## Scope
State management patterns, Context API, Redux Toolkit, Zustand, TypeScript integration, state architecture, Docker development

## Overview
This guide shows you how to add global state management to your React application, comparing different approaches (Context API, Redux, Zustand) and providing step-by-step implementation with TypeScript.

## Dependencies
- TypeScript plugin installed
- React installed
- State management library (optional: zustand, @reduxjs/toolkit)
- Docker (recommended) or npm

## Prerequisites
- React application setup
- Understanding of React hooks
- TypeScript basics
- Component hierarchy understanding

## Quick Start

### Choose Your Approach

**Context API** - Built-in, good for:
- Simple global state
- Theme, authentication, user preferences
- Small to medium apps
- When you don't want external dependencies

**Redux Toolkit** - Full-featured, good for:
- Complex state logic
- Large applications
- Time-travel debugging
- Middleware requirements

**Zustand** - Lightweight, good for:
- Simple global state with less boilerplate
- Modern React apps
- When you want simplicity of Context with Redux-like features

## Implementation Steps

### Option 1: Context API

**Step 1: Create Context and Provider**

```typescript
// src/context/AuthContext.tsx
import React, { createContext, useContext, useState, useCallback } from 'react';

interface User {
  id: string;
  name: string;
  email: string;
}

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
}

interface AuthContextType extends AuthState {
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  updateUser: (user: User) => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [state, setState] = useState<AuthState>({
    user: null,
    isAuthenticated: false,
    isLoading: false,
  });

  const login = useCallback(async (email: string, password: string) => {
    setState(prev => ({ ...prev, isLoading: true }));
    try {
      // API call
      const user = await loginAPI(email, password);
      setState({
        user,
        isAuthenticated: true,
        isLoading: false,
      });
    } catch (error) {
      setState(prev => ({ ...prev, isLoading: false }));
      throw error;
    }
  }, []);

  const logout = useCallback(() => {
    setState({
      user: null,
      isAuthenticated: false,
      isLoading: false,
    });
  }, []);

  const updateUser = useCallback((user: User) => {
    setState(prev => ({ ...prev, user }));
  }, []);

  return (
    <AuthContext.Provider
      value={{
        ...state,
        login,
        logout,
        updateUser,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

// Custom hook
export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};
```

**Step 2: Provide Context at App Level**

```typescript
// src/App.tsx
import { AuthProvider } from './context/AuthContext';

export function App() {
  return (
    <AuthProvider>
      {/* Your app components */}
    </AuthProvider>
  );
}
```

**Step 3: Use in Components**

```typescript
// src/components/LoginForm.tsx
import { useAuth } from '../context/AuthContext';

export const LoginForm: React.FC = () => {
  const { login, isLoading } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await login(email, password);
    } catch (error) {
      // Handle error
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Form fields */}
    </form>
  );
};
```

### Option 2: Redux Toolkit

**Step 1: Install Dependencies**

```bash
npm install @reduxjs/toolkit react-redux
```

**Step 2: Create Store Slice**

```typescript
// src/store/slices/authSlice.ts
import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';

interface User {
  id: string;
  name: string;
  email: string;
}

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}

const initialState: AuthState = {
  user: null,
  isAuthenticated: false,
  isLoading: false,
  error: null,
};

// Async thunks
export const loginAsync = createAsyncThunk(
  'auth/login',
  async ({ email, password }: { email: string; password: string }) => {
    const user = await loginAPI(email, password);
    return user;
  }
);

// Slice
const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    logout: (state) => {
      state.user = null;
      state.isAuthenticated = false;
    },
    updateUser: (state, action: PayloadAction<User>) => {
      state.user = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(loginAsync.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(loginAsync.fulfilled, (state, action) => {
        state.user = action.payload;
        state.isAuthenticated = true;
        state.isLoading = false;
      })
      .addCase(loginAsync.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Login failed';
      });
  },
});

export const { logout, updateUser } = authSlice.actions;
export default authSlice.reducer;
```

**Step 3: Configure Store**

```typescript
// src/store/index.ts
import { configureStore } from '@reduxjs/toolkit';
import authReducer from './slices/authSlice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    // Add other slices here
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
```

**Step 4: Create Typed Hooks**

```typescript
// src/store/hooks.ts
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';
import type { RootState, AppDispatch } from './index';

export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
```

**Step 5: Provide Store**

```typescript
// src/App.tsx
import { Provider } from 'react-redux';
import { store } from './store';

export function App() {
  return (
    <Provider store={store}>
      {/* Your app */}
    </Provider>
  );
}
```

**Step 6: Use in Components**

```typescript
// src/components/LoginForm.tsx
import { useAppDispatch, useAppSelector } from '../store/hooks';
import { loginAsync } from '../store/slices/authSlice';

export const LoginForm: React.FC = () => {
  const dispatch = useAppDispatch();
  const { isLoading, error } = useAppSelector(state => state.auth);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await dispatch(loginAsync({ email, password }));
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Form */}
      {error && <div>{error}</div>}
    </form>
  );
};
```

### Option 3: Zustand

**Step 1: Install Zustand**

```bash
npm install zustand
```

**Step 2: Create Store**

```typescript
// src/store/authStore.ts
import { create } from 'zustand';

interface User {
  id: string;
  name: string;
  email: string;
}

interface AuthStore {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  updateUser: (user: User) => void;
}

export const useAuthStore = create<AuthStore>((set) => ({
  user: null,
  isAuthenticated: false,
  isLoading: false,

  login: async (email, password) => {
    set({ isLoading: true });
    try {
      const user = await loginAPI(email, password);
      set({ user, isAuthenticated: true, isLoading: false });
    } catch (error) {
      set({ isLoading: false });
      throw error;
    }
  },

  logout: () => {
    set({ user: null, isAuthenticated: false });
  },

  updateUser: (user) => {
    set({ user });
  },
}));
```

**Step 3: Use in Components**

```typescript
// src/components/LoginForm.tsx
import { useAuthStore } from '../store/authStore';

export const LoginForm: React.FC = () => {
  const login = useAuthStore(state => state.login);
  const isLoading = useAuthStore(state => state.isLoading);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await login(email, password);
    } catch (error) {
      // Handle error
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Form */}
    </form>
  );
};
```

## Verification

### Test State Updates
```bash
make dev-typescript
```

- [ ] State updates correctly
- [ ] Components re-render when state changes
- [ ] No console errors
- [ ] TypeScript types work

### Test Across Components
- [ ] Multiple components can access state
- [ ] Updates in one component reflect in others
- [ ] State persists during navigation

### Check Performance
- [ ] No unnecessary re-renders
- [ ] Selectors optimized (Redux/Zustand)
- [ ] Context doesn't cause cascade re-renders

## Common Issues and Solutions

### Issue 1: Unnecessary re-renders (Context)
**Symptom**: All consumers re-render on any state change

**Solution**: Split contexts by concern
```typescript
// Instead of one large context
<AuthContext.Provider>
  <ThemeContext.Provider>
    <SettingsContext.Provider>
      {/* ... */}
    </SettingsContext.Provider>
  </ThemeContext.Provider>
</AuthContext.Provider>

// Or use multiple contexts
const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [settings, setSettings] = useState({});

  // Split into two contexts
  return (
    <UserContext.Provider value={[user, setUser]}>
      <SettingsContext.Provider value={[settings, setSettings]}>
        {children}
      </SettingsContext.Provider>
    </UserContext.Provider>
  );
};
```

### Issue 2: TypeScript errors
**Symptom**: Type errors when using state

**Solution**: Export and use proper types
```typescript
// Store
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

// Hooks
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
export const useAppDispatch = () => useDispatch<AppDispatch>();
```

### Issue 3: State not persisting
**Symptom**: State resets on page refresh

**Solution**: Add persistence middleware
```typescript
// Zustand with persistence
import { persist } from 'zustand/middleware';

export const useAuthStore = create(
  persist<AuthStore>(
    (set) => ({
      // store implementation
    }),
    {
      name: 'auth-storage',
    }
  )
);
```

## Best Practices

### Choose the Right Tool
- **Context API**: Simple state, few updates
- **Redux**: Complex state, many actions, debugging needs
- **Zustand**: Simple API, good performance, middle ground

### Type Everything
```typescript
// ✓ Good - Fully typed
interface State {
  user: User | null;
  isLoading: boolean;
}

const initialState: State = {
  user: null,
  isLoading: false,
};

// ✗ Bad - No types
const initialState = {
  user: null,
  isLoading: false,
};
```

### Avoid Prop Drilling
```typescript
// ✗ Bad - Prop drilling
<Parent user={user}>
  <Child user={user}>
    <GrandChild user={user} />
  </Child>
</Parent>

// ✓ Good - Use state management
const GrandChild = () => {
  const user = useAuthStore(state => state.user);
  // ...
};
```

## Templates Reference

This how-to references the following templates:

- `templates/react-context.tsx.template` - Context API setup
- `templates/redux-slice.ts.template` - Redux Toolkit slice
- `templates/zustand-store.ts.template` - Zustand store

## Related How-Tos

- [How to Create a Component](how-to-create-a-component.md) - Using state in components
- [How to Create a Hook](how-to-create-a-hook.md) - Custom hooks with state
- [How to Write a Test](how-to-write-a-test.md) - Testing state management

## Additional Resources

- [Context API](https://react.dev/reference/react/useContext)
- [Redux Toolkit](https://redux-toolkit.js.org/)
- [Zustand](https://zustand-demo.pmnd.rs/)
- [State Management Comparison](https://react.dev/learn/scaling-up-with-reducer-and-context)
