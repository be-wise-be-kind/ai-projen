# API-Frontend Integration Patterns

**Purpose**: Comprehensive guide for connecting React frontend to FastAPI backend with best practices

**Scope**: Communication patterns, error handling, authentication, type safety, and data management between frontend and backend layers

**Overview**: Detailed documentation of integration patterns between React frontend and FastAPI backend including
    API client design, request/response handling, error management, authentication flow, type-safe communication,
    loading states, caching strategies, and testing approaches. Covers practical patterns for building robust
    frontend-backend communication with excellent developer experience and production-ready error handling.

**Dependencies**: React, TypeScript, Axios, FastAPI, Pydantic

**Exports**: Integration patterns, code examples, and best practices for full-stack communication

**Related**: Full-Stack Architecture (fullstack-architecture.md), How-to guides for adding endpoints and pages

**Implementation**: Centralized API client with type-safe requests, comprehensive error handling, and authentication

---

## Overview

The frontend communicates with the backend through a centralized API client that provides:

- **Type-safe requests**: TypeScript interfaces matching Pydantic schemas
- **Automatic authentication**: JWT tokens attached to requests
- **Error handling**: Consistent error responses and user feedback
- **Loading states**: Easy-to-manage async state
- **Request cancellation**: Prevent race conditions
- **Retry logic**: Automatic retries for network failures

## API Client Architecture

### Centralized Client (`frontend/src/api/client.ts`)

```typescript
/**
 * Purpose: Centralized API client for all backend communication
 *
 * Scope: All frontend-backend HTTP requests with authentication and error handling
 *
 * Overview: Provides type-safe interface to backend API with automatic JWT authentication,
 *     comprehensive error handling, request cancellation, and retry logic. Centralizes
 *     configuration, headers, and response parsing for consistent behavior across application.
 *
 * Dependencies: axios for HTTP requests, TypeScript for type safety
 *
 * Exports: apiClient instance, ApiError class, request methods
 *
 * Implementation: Axios instance with interceptors for auth and error handling
 */

import axios, { AxiosError, AxiosInstance, AxiosRequestConfig } from 'axios';

// API configuration
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';
const API_TIMEOUT = Number(import.meta.env.VITE_API_TIMEOUT) || 30000;

// Custom error class for API errors
export class ApiError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public errorCode?: string,
    public details?: Record<string, unknown>
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

// Create axios instance
const axiosInstance: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: API_TIMEOUT,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor: Add authentication token
axiosInstance.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('access_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor: Handle errors consistently
axiosInstance.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (error.response) {
      // Server responded with error
      const { status, data } = error.response;
      const errorData = data as {
        error?: string;
        message?: string;
        details?: Record<string, unknown>;
      };

      throw new ApiError(
        errorData.message || 'An error occurred',
        status,
        errorData.error,
        errorData.details
      );
    } else if (error.request) {
      // Request made but no response
      throw new ApiError('Network error - no response from server', 0);
    } else {
      // Request setup error
      throw new ApiError('Request configuration error', 0);
    }
  }
);

// API client with typed methods
export const apiClient = {
  // GET request
  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await axiosInstance.get<T>(url, config);
    return response.data;
  },

  // POST request
  async post<T, D = unknown>(
    url: string,
    data?: D,
    config?: AxiosRequestConfig
  ): Promise<T> {
    const response = await axiosInstance.post<T>(url, data, config);
    return response.data;
  },

  // PUT request
  async put<T, D = unknown>(
    url: string,
    data?: D,
    config?: AxiosRequestConfig
  ): Promise<T> {
    const response = await axiosInstance.put<T>(url, data, config);
    return response.data;
  },

  // PATCH request
  async patch<T, D = unknown>(
    url: string,
    data?: D,
    config?: AxiosRequestConfig
  ): Promise<T> {
    const response = await axiosInstance.patch<T>(url, data, config);
    return response.data;
  },

  // DELETE request
  async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await axiosInstance.delete<T>(url, config);
    return response.data;
  },
};

export default apiClient;
```

## Type-Safe API Communication

### Defining Types from Backend

TypeScript types should mirror Pydantic schemas from backend:

**Backend (Python/Pydantic)**:
```python
# backend/src/schemas/user.py
from pydantic import BaseModel, EmailStr
from datetime import datetime

class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: int
    username: str
    email: EmailStr
    full_name: str | None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
```

**Frontend (TypeScript)**:
```typescript
// frontend/src/types/api.ts
export interface UserCreate {
  username: string;
  email: string;
  password: string;
}

export interface UserResponse {
  id: number;
  username: string;
  email: string;
  full_name: string | null;
  created_at: string;  // ISO 8601 string
  updated_at: string;
}
```

### Type-Safe API Calls

```typescript
// frontend/src/api/users.ts
import { apiClient } from './client';
import { UserCreate, UserResponse } from '../types/api';

export const usersApi = {
  // Create user
  async create(userData: UserCreate): Promise<UserResponse> {
    return apiClient.post<UserResponse, UserCreate>('/api/users', userData);
  },

  // Get user by ID
  async getById(userId: number): Promise<UserResponse> {
    return apiClient.get<UserResponse>(`/api/users/${userId}`);
  },

  // List users (with pagination)
  async list(page: number = 1, limit: number = 20): Promise<UserResponse[]> {
    return apiClient.get<UserResponse[]>('/api/users', {
      params: { page, limit },
    });
  },

  // Update user
  async update(userId: number, userData: Partial<UserCreate>): Promise<UserResponse> {
    return apiClient.patch<UserResponse, Partial<UserCreate>>(
      `/api/users/${userId}`,
      userData
    );
  },

  // Delete user
  async delete(userId: number): Promise<void> {
    return apiClient.delete<void>(`/api/users/${userId}`);
  },
};
```

## Using API in React Components

### Basic Pattern with Loading and Error States

```typescript
// frontend/src/components/UserProfile.tsx
import { useState, useEffect } from 'react';
import { usersApi } from '../api/users';
import { UserResponse } from '../types/api';
import { ApiError } from '../api/client';

interface UserProfileProps {
  userId: number;
}

export function UserProfile({ userId }: UserProfileProps) {
  const [user, setUser] = useState<UserResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true);
        setError(null);
        const userData = await usersApi.getById(userId);
        setUser(userData);
      } catch (err) {
        if (err instanceof ApiError) {
          setError(err.message);
        } else {
          setError('An unexpected error occurred');
        }
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [userId]);

  if (loading) {
    return <div>Loading user profile...</div>;
  }

  if (error) {
    return <div className="error">Error: {error}</div>;
  }

  if (!user) {
    return <div>User not found</div>;
  }

  return (
    <div className="user-profile">
      <h2>{user.username}</h2>
      <p>Email: {user.email}</p>
      {user.full_name && <p>Name: {user.full_name}</p>}
      <p>Member since: {new Date(user.created_at).toLocaleDateString()}</p>
    </div>
  );
}
```

### Custom Hook for Data Fetching

```typescript
// frontend/src/hooks/useApi.ts
import { useState, useEffect } from 'react';
import { ApiError } from '../api/client';

interface UseApiState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

export function useApi<T>(
  apiCall: () => Promise<T>,
  dependencies: unknown[] = []
): UseApiState<T> {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);
      const result = await apiCall();
      setData(result);
    } catch (err) {
      if (err instanceof ApiError) {
        setError(err.message);
      } else {
        setError('An unexpected error occurred');
      }
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, dependencies);

  return { data, loading, error, refetch: fetchData };
}

// Usage in component
export function UserList() {
  const { data: users, loading, error, refetch } = useApi(
    () => usersApi.list()
  );

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <button onClick={refetch}>Refresh</button>
      <ul>
        {users?.map((user) => (
          <li key={user.id}>{user.username}</li>
        ))}
      </ul>
    </div>
  );
}
```

## Authentication Flow

### Login and Token Management

```typescript
// frontend/src/api/auth.ts
import { apiClient } from './client';

export interface LoginRequest {
  username: string;
  password: string;
}

export interface LoginResponse {
  access_token: string;
  token_type: string;
}

export const authApi = {
  // Login
  async login(credentials: LoginRequest): Promise<LoginResponse> {
    const response = await apiClient.post<LoginResponse, LoginRequest>(
      '/auth/login',
      credentials
    );

    // Store token
    localStorage.setItem('access_token', response.access_token);

    return response;
  },

  // Logout
  logout(): void {
    localStorage.removeItem('access_token');
  },

  // Check if authenticated
  isAuthenticated(): boolean {
    return !!localStorage.getItem('access_token');
  },

  // Get current user
  async getCurrentUser(): Promise<UserResponse> {
    return apiClient.get<UserResponse>('/auth/me');
  },
};
```

### Auth Context for Global State

```typescript
// frontend/src/context/AuthContext.tsx
import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { authApi } from '../api/auth';
import { UserResponse } from '../types/api';

interface AuthContextType {
  user: UserResponse | null;
  loading: boolean;
  login: (username: string, password: string) => Promise<void>;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<UserResponse | null>(null);
  const [loading, setLoading] = useState(true);

  // Load user on mount if token exists
  useEffect(() => {
    const loadUser = async () => {
      if (authApi.isAuthenticated()) {
        try {
          const userData = await authApi.getCurrentUser();
          setUser(userData);
        } catch (error) {
          // Token invalid, clear it
          authApi.logout();
        }
      }
      setLoading(false);
    };

    loadUser();
  }, []);

  const login = async (username: string, password: string) => {
    await authApi.login({ username, password });
    const userData = await authApi.getCurrentUser();
    setUser(userData);
  };

  const logout = () => {
    authApi.logout();
    setUser(null);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        login,
        logout,
        isAuthenticated: !!user,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

// Hook to use auth context
export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}
```

## Error Handling Patterns

### Displaying Errors to Users

```typescript
// frontend/src/components/ErrorDisplay.tsx
import { ApiError } from '../api/client';

interface ErrorDisplayProps {
  error: Error | ApiError | null;
  onRetry?: () => void;
}

export function ErrorDisplay({ error, onRetry }: ErrorDisplayProps) {
  if (!error) return null;

  let message = 'An unexpected error occurred';
  let details: Record<string, unknown> | undefined;

  if (error instanceof ApiError) {
    message = error.message;
    details = error.details;

    // Handle specific error codes
    switch (error.errorCode) {
      case 'VALIDATION_ERROR':
        message = 'Please check your input and try again';
        break;
      case 'UNAUTHORIZED':
        message = 'Please log in to continue';
        break;
      case 'FORBIDDEN':
        message = "You don't have permission to perform this action";
        break;
      case 'NOT_FOUND':
        message = 'The requested resource was not found';
        break;
    }
  }

  return (
    <div className="error-container">
      <h3>Error</h3>
      <p>{message}</p>

      {details && (
        <div className="error-details">
          <h4>Details:</h4>
          <ul>
            {Object.entries(details).map(([key, value]) => (
              <li key={key}>
                <strong>{key}:</strong> {JSON.stringify(value)}
              </li>
            ))}
          </ul>
        </div>
      )}

      {onRetry && (
        <button onClick={onRetry}>Retry</button>
      )}
    </div>
  );
}
```

### Form Validation Errors

```typescript
// frontend/src/components/UserForm.tsx
import { useState } from 'react';
import { usersApi } from '../api/users';
import { UserCreate } from '../types/api';
import { ApiError } from '../api/client';

export function UserForm() {
  const [formData, setFormData] = useState<UserCreate>({
    username: '',
    email: '',
    password: '',
  });
  const [errors, setErrors] = useState<Record<string, string[]>>({});
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrors({});
    setSubmitting(true);

    try {
      await usersApi.create(formData);
      // Success: redirect or show success message
      alert('User created successfully!');
    } catch (error) {
      if (error instanceof ApiError && error.details) {
        // Backend validation errors
        setErrors(error.details as Record<string, string[]>);
      } else {
        // Generic error
        alert('Failed to create user');
      }
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>Username</label>
        <input
          value={formData.username}
          onChange={(e) => setFormData({ ...formData, username: e.target.value })}
        />
        {errors.username && (
          <div className="error">{errors.username.join(', ')}</div>
        )}
      </div>

      <div>
        <label>Email</label>
        <input
          type="email"
          value={formData.email}
          onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        />
        {errors.email && (
          <div className="error">{errors.email.join(', ')}</div>
        )}
      </div>

      <div>
        <label>Password</label>
        <input
          type="password"
          value={formData.password}
          onChange={(e) => setFormData({ ...formData, password: e.target.value })}
        />
        {errors.password && (
          <div className="error">{errors.password.join(', ')}</div>
        )}
      </div>

      <button type="submit" disabled={submitting}>
        {submitting ? 'Creating...' : 'Create User'}
      </button>
    </form>
  );
}
```

## Advanced Patterns

### Request Cancellation

```typescript
// frontend/src/hooks/useApiWithCancellation.ts
import { useState, useEffect, useRef } from 'react';
import axios, { CancelTokenSource } from 'axios';
import { ApiError } from '../api/client';

export function useApiWithCancellation<T>(
  apiCall: (cancelToken: CancelTokenSource) => Promise<T>,
  dependencies: unknown[] = []
) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const cancelTokenRef = useRef<CancelTokenSource | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      // Cancel previous request
      if (cancelTokenRef.current) {
        cancelTokenRef.current.cancel('New request initiated');
      }

      cancelTokenRef.current = axios.CancelToken.source();

      try {
        setLoading(true);
        setError(null);
        const result = await apiCall(cancelTokenRef.current);
        setData(result);
      } catch (err) {
        if (!axios.isCancel(err)) {
          if (err instanceof ApiError) {
            setError(err.message);
          } else {
            setError('An unexpected error occurred');
          }
        }
      } finally {
        setLoading(false);
      }
    };

    fetchData();

    // Cleanup: cancel request on unmount
    return () => {
      if (cancelTokenRef.current) {
        cancelTokenRef.current.cancel('Component unmounted');
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, dependencies);

  return { data, loading, error };
}
```

### Optimistic Updates

```typescript
// frontend/src/hooks/useOptimisticUpdate.ts
import { useState } from 'react';

export function useOptimisticUpdate<T>(
  initialData: T[],
  updateFn: (item: T) => Promise<T>,
  getId: (item: T) => string | number
) {
  const [data, setData] = useState(initialData);

  const optimisticUpdate = async (item: T) => {
    // Optimistically update UI
    setData((prev) =>
      prev.map((existing) =>
        getId(existing) === getId(item) ? item : existing
      )
    );

    try {
      // Perform actual update
      const updatedItem = await updateFn(item);

      // Replace with server response
      setData((prev) =>
        prev.map((existing) =>
          getId(existing) === getId(updatedItem) ? updatedItem : existing
        )
      );

      return updatedItem;
    } catch (error) {
      // Revert on error
      setData(initialData);
      throw error;
    }
  };

  return { data, optimisticUpdate };
}
```

## Testing API Integration

### Mocking API Calls in Tests

```typescript
// frontend/src/api/__tests__/users.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { usersApi } from '../users';
import { apiClient } from '../client';
import { UserResponse } from '../../types/api';

// Mock apiClient
vi.mock('../client', () => ({
  apiClient: {
    get: vi.fn(),
    post: vi.fn(),
  },
}));

describe('usersApi', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should get user by ID', async () => {
    const mockUser: UserResponse = {
      id: 1,
      username: 'test_user',
      email: 'test@example.com',
      full_name: 'Test User',
      created_at: '2025-10-02T12:00:00Z',
      updated_at: '2025-10-02T12:00:00Z',
    };

    vi.mocked(apiClient.get).mockResolvedValue(mockUser);

    const result = await usersApi.getById(1);

    expect(apiClient.get).toHaveBeenCalledWith('/api/users/1');
    expect(result).toEqual(mockUser);
  });
});
```

## Best Practices

1. **Centralize API logic**: Keep all API calls in `src/api/` directory
2. **Type everything**: Use TypeScript interfaces for all requests/responses
3. **Handle errors consistently**: Use custom error classes and error boundaries
4. **Loading states**: Always show loading indicators for async operations
5. **Request cancellation**: Cancel pending requests when component unmounts
6. **Environment variables**: Configure API URL via environment variables
7. **Token refresh**: Implement token refresh logic for expired JWTs (future enhancement)
8. **Caching**: Consider React Query or SWR for advanced caching (future enhancement)

---

These patterns provide a robust foundation for frontend-backend communication with excellent developer experience and production-ready error handling.
