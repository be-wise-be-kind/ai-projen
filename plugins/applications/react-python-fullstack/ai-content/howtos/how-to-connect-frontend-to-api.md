# How to Connect Frontend to API

**Purpose**: Step-by-step guide for integrating React frontend with FastAPI backend using type-safe API client

**Scope**: Frontend-backend integration with API client, error handling, loading states, and authentication

**Overview**: Complete walkthrough for connecting React components to FastAPI endpoints including API client setup,
    TypeScript type definitions from backend schemas, request/response handling, error management, loading states,
    form submissions with validation, and authentication with JWT tokens. Demonstrates practical patterns for robust
    frontend-backend communication with excellent user experience.

**Prerequisites**: Backend endpoint created, frontend page created, basic API concepts

**Estimated Time**: 45-60 minutes

---

## What You'll Build

- Type-safe API client integration
- React component connected to backend data
- Loading, error, and success states
- Form submission with backend validation
- Authentication token handling
- Real-time data updates

## Prerequisites

- Backend endpoint exists (e.g., `/api/tasks` from previous guide)
- Frontend page created (e.g., Tasks page)
- Both backend and frontend running

## Step 1: Define TypeScript Types from Backend

Create type definitions matching your Pydantic schemas:

**File**: `frontend/src/types/api.ts`

```typescript
/**
 * Purpose: TypeScript type definitions matching backend API schemas
 * Scope: All API request/response types for type-safe communication
 * Overview: Defines interfaces corresponding to backend Pydantic models ensuring type safety
 *     across frontend-backend communication. Types are manually synced with backend schemas
 *     or generated from OpenAPI specification.
 * Dependencies: None (pure TypeScript types)
 * Exports: Request and response type definitions
 */

// Task types (matching backend/src/schemas/task.py)
export interface TaskCreate {
  title: string;
  description?: string | null;
  completed?: boolean;
}

export interface TaskUpdate {
  title?: string;
  description?: string | null;
  completed?: boolean;
}

export interface TaskResponse {
  id: number;
  title: string;
  description: string | null;
  completed: boolean;
  created_at: string;
  updated_at: string;
}

// Add other resource types as needed
```

## Step 2: Create Resource-Specific API Module

**File**: `frontend/src/api/tasks.ts`

```typescript
/**
 * Purpose: API client methods for Task resource
 * Scope: All Task CRUD operations with type-safe requests
 * Overview: Provides typed methods for interacting with Task API endpoints including
 *     create, read, update, delete, and list operations. Handles request formatting,
 *     response parsing, and error propagation.
 * Dependencies: API client, Task types
 * Exports: tasksApi object with CRUD methods
 */

import { apiClient } from './client';
import { TaskCreate, TaskUpdate, TaskResponse } from '../types/api';

export const tasksApi = {
  /**
   * Get all tasks with optional filtering and pagination
   */
  async list(params?: {
    skip?: number;
    limit?: number;
    completed?: boolean;
  }): Promise<TaskResponse[]> {
    return apiClient.get<TaskResponse[]>('/api/tasks', { params });
  },

  /**
   * Get a specific task by ID
   */
  async getById(id: number): Promise<TaskResponse> {
    return apiClient.get<TaskResponse>(`/api/tasks/${id}`);
  },

  /**
   * Create a new task
   */
  async create(data: TaskCreate): Promise<TaskResponse> {
    return apiClient.post<TaskResponse, TaskCreate>('/api/tasks', data);
  },

  /**
   * Update an existing task
   */
  async update(id: number, data: TaskUpdate): Promise<TaskResponse> {
    return apiClient.put<TaskResponse, TaskUpdate>(`/api/tasks/${id}`, data);
  },

  /**
   * Delete a task
   */
  async delete(id: number): Promise<void> {
    return apiClient.delete<void>(`/api/tasks/${id}`);
  },
};
```

## Step 3: Update Page Component to Use API

Replace mock data in your Tasks page with real API calls:

**File**: `frontend/src/pages/Tasks.tsx` (updated)

```typescript
import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { tasksApi } from '../api/tasks';
import { TaskResponse } from '../types/api';
import { ApiError } from '../api/client';
import styles from './Tasks.module.css';

export default function Tasks() {
  const [tasks, setTasks] = useState<TaskResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<'all' | 'active' | 'completed'>('all');

  // Fetch tasks from API
  useEffect(() => {
    const fetchTasks = async () => {
      try {
        setLoading(true);
        setError(null);

        // Call API based on filter
        const completed = filter === 'all' ? undefined : filter === 'completed';
        const data = await tasksApi.list({ completed });

        setTasks(data);
      } catch (err) {
        if (err instanceof ApiError) {
          setError(err.message);
        } else {
          setError('Failed to load tasks');
        }
        console.error('Error fetching tasks:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchTasks();
  }, [filter]);

  const handleDelete = async (taskId: number) => {
    if (!confirm('Are you sure you want to delete this task?')) {
      return;
    }

    try {
      await tasksApi.delete(taskId);
      // Remove from local state
      setTasks(tasks.filter((t) => t.id !== taskId));
    } catch (err) {
      if (err instanceof ApiError) {
        alert(`Error: ${err.message}`);
      } else {
        alert('Failed to delete task');
      }
    }
  };

  // ... rest of component (rendering logic stays the same)
  // Add delete button to each task:
  // <button onClick={() => handleDelete(task.id)}>Delete</button>
}
```

## Step 4: Create Task Form Component

**File**: `frontend/src/components/TaskForm.tsx`

```typescript
/**
 * Purpose: Form component for creating and editing tasks
 * Scope: Task creation and update form with validation
 * Overview: Provides form UI for task input with client-side validation, server-side error
 *     display, loading states, and optimistic updates. Handles both create and edit modes.
 * Dependencies: React, API client, Task types
 * Exports: TaskForm component
 */

import { useState, FormEvent } from 'react';
import { useNavigate } from 'react-router-dom';
import { tasksApi } from '../api/tasks';
import { TaskCreate, TaskResponse } from '../types/api';
import { ApiError } from '../api/client';
import styles from './TaskForm.module.css';

interface TaskFormProps {
  existingTask?: TaskResponse;
  onSuccess?: (task: TaskResponse) => void;
}

export default function TaskForm({ existingTask, onSuccess }: TaskFormProps) {
  const navigate = useNavigate();
  const [formData, setFormData] = useState<TaskCreate>({
    title: existingTask?.title || '',
    description: existingTask?.description || '',
    completed: existingTask?.completed || false,
  });
  const [errors, setErrors] = useState<Record<string, string[]>>({});
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setErrors({});
    setSubmitting(true);

    try {
      const task = existingTask
        ? await tasksApi.update(existingTask.id, formData)
        : await tasksApi.create(formData);

      if (onSuccess) {
        onSuccess(task);
      } else {
        navigate('/tasks');
      }
    } catch (err) {
      if (err instanceof ApiError) {
        // Handle validation errors from backend
        if (err.details) {
          setErrors(err.details as Record<string, string[]>);
        } else {
          alert(`Error: ${err.message}`);
        }
      } else {
        alert('An unexpected error occurred');
      }
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className={styles.form}>
      <div className={styles.formGroup}>
        <label htmlFor="title">Title *</label>
        <input
          id="title"
          type="text"
          value={formData.title}
          onChange={(e) => setFormData({ ...formData, title: e.target.value })}
          required
          maxLength={200}
          disabled={submitting}
        />
        {errors.title && (
          <div className={styles.error}>{errors.title.join(', ')}</div>
        )}
      </div>

      <div className={styles.formGroup}>
        <label htmlFor="description">Description</label>
        <textarea
          id="description"
          value={formData.description || ''}
          onChange={(e) => setFormData({ ...formData, description: e.target.value })}
          maxLength={1000}
          rows={4}
          disabled={submitting}
        />
        {errors.description && (
          <div className={styles.error}>{errors.description.join(', ')}</div>
        )}
      </div>

      <div className={styles.formGroup}>
        <label>
          <input
            type="checkbox"
            checked={formData.completed}
            onChange={(e) => setFormData({ ...formData, completed: e.target.checked })}
            disabled={submitting}
          />
          Mark as completed
        </label>
      </div>

      <div className={styles.actions}>
        <button type="submit" disabled={submitting} className={styles.submitButton}>
          {submitting ? 'Saving...' : existingTask ? 'Update Task' : 'Create Task'}
        </button>
        <button
          type="button"
          onClick={() => navigate('/tasks')}
          disabled={submitting}
          className={styles.cancelButton}
        >
          Cancel
        </button>
      </div>
    </form>
  );
}
```

## Step 5: Create Custom Hook for Data Fetching

**File**: `frontend/src/hooks/useTasks.ts`

```typescript
/**
 * Purpose: Custom React hook for managing tasks data and operations
 * Scope: Task data fetching, caching, and mutations
 * Overview: Provides reusable hook for task operations with loading states, error handling,
 *     and automatic refetching. Simplifies task management in components.
 * Dependencies: React, tasks API
 * Exports: useTasks hook
 */

import { useState, useEffect, useCallback } from 'react';
import { tasksApi } from '../api/tasks';
import { TaskResponse, TaskCreate, TaskUpdate } from '../types/api';
import { ApiError } from '../api/client';

interface UseTasksOptions {
  completed?: boolean;
  autoFetch?: boolean;
}

export function useTasks(options: UseTasksOptions = {}) {
  const { completed, autoFetch = true } = options;
  const [tasks, setTasks] = useState<TaskResponse[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchTasks = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await tasksApi.list({ completed });
      setTasks(data);
    } catch (err) {
      const message = err instanceof ApiError ? err.message : 'Failed to fetch tasks';
      setError(message);
    } finally {
      setLoading(false);
    }
  }, [completed]);

  useEffect(() => {
    if (autoFetch) {
      fetchTasks();
    }
  }, [autoFetch, fetchTasks]);

  const createTask = async (data: TaskCreate): Promise<TaskResponse> => {
    const task = await tasksApi.create(data);
    setTasks((prev) => [...prev, task]);
    return task;
  };

  const updateTask = async (id: number, data: TaskUpdate): Promise<TaskResponse> => {
    const task = await tasksApi.update(id, data);
    setTasks((prev) => prev.map((t) => (t.id === id ? task : t)));
    return task;
  };

  const deleteTask = async (id: number): Promise<void> => {
    await tasksApi.delete(id);
    setTasks((prev) => prev.filter((t) => t.id !== id));
  };

  return {
    tasks,
    loading,
    error,
    refetch: fetchTasks,
    createTask,
    updateTask,
    deleteTask,
  };
}
```

**Usage in component**:

```typescript
import { useTasks } from '../hooks/useTasks';

export default function Tasks() {
  const { tasks, loading, error, deleteTask, refetch } = useTasks();

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <button onClick={refetch}>Refresh</button>
      <ul>
        {tasks.map((task) => (
          <li key={task.id}>
            {task.title}
            <button onClick={() => deleteTask(task.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## Step 6: Add Optimistic Updates

For better UX, update UI immediately before API call completes:

```typescript
const handleToggleComplete = async (task: TaskResponse) => {
  // Optimistic update
  setTasks((prev) =>
    prev.map((t) =>
      t.id === task.id ? { ...t, completed: !t.completed } : t
    )
  );

  try {
    await tasksApi.update(task.id, { completed: !task.completed });
  } catch (err) {
    // Revert on error
    setTasks((prev) =>
      prev.map((t) =>
        t.id === task.id ? { ...t, completed: task.completed } : t
      )
    );
    alert('Failed to update task');
  }
};
```

## Step 7: Test Integration

```bash
# Start both backend and frontend
docker-compose up

# In browser:
# 1. Visit http://localhost:5173/tasks
# 2. Create a task - verify it appears in list
# 3. Update a task - verify changes persist
# 4. Delete a task - verify it's removed
# 5. Check browser network tab - verify API calls
# 6. Check backend logs - verify requests received
```

## Validation

✅ **Success Criteria**:
- [ ] Types defined matching backend schemas
- [ ] API module created for resource
- [ ] Component fetches data from backend
- [ ] Loading states display correctly
- [ ] Errors display user-friendly messages
- [ ] Form submissions work
- [ ] Validation errors from backend display
- [ ] Optimistic updates provide smooth UX
- [ ] Browser network tab shows API calls
- [ ] Backend logs show requests

## Troubleshooting

### Issue: CORS errors in browser console
**Solution**: Check backend CORS configuration in `backend/src/config.py`
```python
CORS_ORIGINS = ["http://localhost:5173"]
```

### Issue: "Network Error"
**Solution**: Verify backend is running and `VITE_API_URL` is correct
```bash
# Check .env
cat frontend/.env
# Should have: VITE_API_URL=http://localhost:8000
```

### Issue: Type mismatches
**Solution**: Ensure TypeScript types match Pydantic schemas exactly

### Issue: Validation errors not displaying
**Solution**: Check ApiError.details structure matches expected format

## Next Steps

1. **Add authentication**: Protect endpoints with JWT tokens
2. **Add caching**: Use React Query or SWR for better performance
3. **Add real-time updates**: WebSocket integration
4. **Add pagination**: Handle large data sets efficiently
5. **Deploy**: Follow [How to Deploy Full-Stack App](how-to-deploy-fullstack-app.md)

---

**Congratulations!** Your frontend and backend are now fully integrated with type-safe communication.
