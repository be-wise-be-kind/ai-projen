# How to Add a Frontend Page

**Purpose**: Step-by-step guide for creating new React pages with TypeScript, routing, and component structure

**Scope**: Frontend development with React 18, TypeScript, React Router, and Vitest

**Overview**: Complete walkthrough for adding a new page to the React frontend including component creation,
    routing configuration, styling with CSS modules, state management, testing with Vitest and React Testing Library,
    and navigation integration. Covers component composition, TypeScript typing, and React best practices for
    building maintainable UI pages.

**Prerequisites**: React basics, TypeScript fundamentals, React Router concepts

**Estimated Time**: 30-45 minutes

---

## What You'll Build

By the end of this guide, you'll have:
- A new React page component (e.g., `/tasks` route)
- TypeScript interfaces for props and state
- CSS module for styling
- React Router integration
- Navigation links from other pages
- Component tests with Vitest

## Prerequisites

- Frontend running: `docker-compose up frontend`
- Basic understanding of React, TypeScript, and CSS
- React Router installed and configured

## Step 1: Create Page Component

Create a new page component in `frontend/src/pages/`:

**File**: `frontend/src/pages/Tasks.tsx`

```typescript
/**
 * Purpose: Tasks page component displaying list of user tasks
 *
 * Scope: Main tasks page with list view and create functionality
 *
 * Overview: Displays user's task list with ability to view, create, and manage tasks.
 *     Integrates with backend API for data fetching and updates. Includes loading states,
 *     error handling, and empty state handling. Provides intuitive UI for task management
 *     with responsive design.
 *
 * Dependencies: React, React Router, API client, Task components
 *
 * Exports: Tasks page component as default export
 *
 * State/Behavior: Manages tasks list, loading state, error state, and filter state
 */

import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import styles from './Tasks.module.css';

// Task type (will be replaced with API type later)
interface Task {
  id: number;
  title: string;
  description: string | null;
  completed: boolean;
  created_at: string;
  updated_at: string;
}

export default function Tasks() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<'all' | 'active' | 'completed'>('all');

  useEffect(() => {
    // TODO: Replace with actual API call
    // For now, using mock data
    setTimeout(() => {
      const mockTasks: Task[] = [
        {
          id: 1,
          title: 'Complete project documentation',
          description: 'Write comprehensive docs for the API',
          completed: false,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
        {
          id: 2,
          title: 'Review pull requests',
          description: 'Review and merge pending PRs',
          completed: true,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
      ];

      setTasks(mockTasks);
      setLoading(false);
    }, 500);
  }, []);

  const filteredTasks = tasks.filter((task) => {
    if (filter === 'active') return !task.completed;
    if (filter === 'completed') return task.completed;
    return true;
  });

  if (loading) {
    return (
      <div className={styles.container}>
        <div className={styles.loading}>Loading tasks...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className={styles.container}>
        <div className={styles.error}>
          <h2>Error</h2>
          <p>{error}</p>
          <button onClick={() => window.location.reload()}>Retry</button>
        </div>
      </div>
    );
  }

  return (
    <div className={styles.container}>
      <header className={styles.header}>
        <h1>My Tasks</h1>
        <Link to="/tasks/new" className={styles.createButton}>
          Create Task
        </Link>
      </header>

      <div className={styles.filters}>
        <button
          className={filter === 'all' ? styles.activeFilter : ''}
          onClick={() => setFilter('all')}
        >
          All ({tasks.length})
        </button>
        <button
          className={filter === 'active' ? styles.activeFilter : ''}
          onClick={() => setFilter('active')}
        >
          Active ({tasks.filter((t) => !t.completed).length})
        </button>
        <button
          className={filter === 'completed' ? styles.activeFilter : ''}
          onClick={() => setFilter('completed')}
        >
          Completed ({tasks.filter((t) => t.completed).length})
        </button>
      </div>

      {filteredTasks.length === 0 ? (
        <div className={styles.empty}>
          <p>No {filter !== 'all' ? filter : ''} tasks found.</p>
          <Link to="/tasks/new">Create your first task</Link>
        </div>
      ) : (
        <ul className={styles.taskList}>
          {filteredTasks.map((task) => (
            <li key={task.id} className={styles.taskItem}>
              <div className={styles.taskContent}>
                <h3>
                  <Link to={`/tasks/${task.id}`}>{task.title}</Link>
                </h3>
                {task.description && <p>{task.description}</p>}
                <div className={styles.taskMeta}>
                  <span className={task.completed ? styles.completed : styles.pending}>
                    {task.completed ? 'Completed' : 'Pending'}
                  </span>
                  <span className={styles.date}>
                    Created: {new Date(task.created_at).toLocaleDateString()}
                  </span>
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
```

## Step 2: Create CSS Module

Create styles for the page in `frontend/src/pages/Tasks.module.css`:

```css
/*
Purpose: Styles for Tasks page component
Scope: Tasks page layout, filters, task list, and responsive design
Overview: Provides clean, modern styling for task management page with responsive layout,
    interactive filters, and accessible UI components. Includes loading states, error states,
    and empty states with consistent color scheme and spacing.
Dependencies: None (pure CSS)
Exports: CSS modules for Tasks component
Implementation: CSS modules with BEM-like naming and mobile-first responsive design
*/

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.header h1 {
  font-size: 2rem;
  color: #1a202c;
  margin: 0;
}

.createButton {
  padding: 0.75rem 1.5rem;
  background-color: #3b82f6;
  color: white;
  text-decoration: none;
  border-radius: 0.5rem;
  font-weight: 500;
  transition: background-color 0.2s;
}

.createButton:hover {
  background-color: #2563eb;
}

.filters {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  border-bottom: 1px solid #e5e7eb;
  padding-bottom: 1rem;
}

.filters button {
  padding: 0.5rem 1rem;
  background: none;
  border: none;
  color: #6b7280;
  font-size: 1rem;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: all 0.2s;
}

.filters button:hover {
  color: #1f2937;
}

.activeFilter {
  color: #3b82f6 !important;
  border-bottom-color: #3b82f6 !important;
  font-weight: 500;
}

.taskList {
  list-style: none;
  padding: 0;
  margin: 0;
}

.taskItem {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 0.5rem;
  padding: 1.5rem;
  margin-bottom: 1rem;
  transition: box-shadow 0.2s;
}

.taskItem:hover {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.taskContent h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.25rem;
  color: #1a202c;
}

.taskContent h3 a {
  color: inherit;
  text-decoration: none;
}

.taskContent h3 a:hover {
  color: #3b82f6;
}

.taskContent p {
  margin: 0 0 1rem 0;
  color: #6b7280;
}

.taskMeta {
  display: flex;
  gap: 1rem;
  font-size: 0.875rem;
  color: #9ca3af;
}

.completed {
  color: #10b981;
  font-weight: 500;
}

.pending {
  color: #f59e0b;
  font-weight: 500;
}

.date {
  color: #9ca3af;
}

.loading,
.error,
.empty {
  text-align: center;
  padding: 3rem;
  color: #6b7280;
}

.error {
  color: #ef4444;
}

.error h2 {
  margin-top: 0;
}

.error button {
  padding: 0.5rem 1.5rem;
  background-color: #3b82f6;
  color: white;
  border: none;
  border-radius: 0.5rem;
  cursor: pointer;
  font-size: 1rem;
}

.error button:hover {
  background-color: #2563eb;
}

.empty p {
  font-size: 1.125rem;
  margin-bottom: 1rem;
}

.empty a {
  color: #3b82f6;
  text-decoration: none;
  font-weight: 500;
}

.empty a:hover {
  text-decoration: underline;
}

/* Responsive design */
@media (max-width: 768px) {
  .container {
    padding: 1rem;
  }

  .header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .filters {
    flex-direction: column;
    gap: 0.5rem;
  }

  .taskMeta {
    flex-direction: column;
    gap: 0.5rem;
  }
}
```

## Step 3: Add Route to Router

Update `frontend/src/App.tsx` to include the new route:

```typescript
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import Tasks from './pages/Tasks';  // Add this import

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/tasks" element={<Tasks />} />  {/* Add this route */}
        {/* Add more routes as needed */}
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```

## Step 4: Add Navigation Link

Update existing pages to link to the new page. For example, in `frontend/src/pages/Home.tsx`:

```typescript
import { Link } from 'react-router-dom';

export default function Home() {
  return (
    <div>
      <h1>Welcome to the App</h1>
      <nav>
        <ul>
          <li><Link to="/tasks">View Tasks</Link></li>
          {/* Other navigation links */}
        </ul>
      </nav>
    </div>
  );
}
```

## Step 5: Create Navigation Component (Optional)

Create a reusable navigation component in `frontend/src/components/Navigation.tsx`:

```typescript
/**
 * Purpose: Global navigation component for site-wide navigation
 *
 * Scope: Application-wide navigation menu
 *
 * Overview: Provides consistent navigation across all pages with active link highlighting,
 *     responsive mobile menu, and accessibility features. Integrates with React Router for
 *     client-side navigation.
 *
 * Dependencies: React Router
 *
 * Exports: Navigation component
 */

import { NavLink } from 'react-router-dom';
import styles from './Navigation.module.css';

export default function Navigation() {
  return (
    <nav className={styles.nav}>
      <ul className={styles.navList}>
        <li>
          <NavLink
            to="/"
            className={({ isActive }) => isActive ? styles.activeLink : ''}
          >
            Home
          </NavLink>
        </li>
        <li>
          <NavLink
            to="/tasks"
            className={({ isActive }) => isActive ? styles.activeLink : ''}
          >
            Tasks
          </NavLink>
        </li>
      </ul>
    </nav>
  );
}
```

## Step 6: Write Component Tests

Create tests in `frontend/src/pages/__tests__/Tasks.test.tsx`:

```typescript
/**
 * Purpose: Test suite for Tasks page component
 *
 * Scope: Unit and integration tests for Tasks page
 *
 * Overview: Tests Tasks page rendering, filtering, loading states, error states, and user
 *     interactions. Validates component behavior with different data scenarios and ensures
 *     accessibility standards are met.
 *
 * Dependencies: Vitest, React Testing Library
 *
 * Exports: Test cases for Tasks page
 */

import { describe, it, expect, vi } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import userEvent from '@testing-library/user-event';
import Tasks from '../Tasks';

// Wrapper for React Router
const renderWithRouter = (component: React.ReactElement) => {
  return render(<BrowserRouter>{component}</BrowserRouter>);
};

describe('Tasks Page', () => {
  it('renders loading state initially', () => {
    renderWithRouter(<Tasks />);
    expect(screen.getByText(/loading tasks/i)).toBeInTheDocument();
  });

  it('renders tasks after loading', async () => {
    renderWithRouter(<Tasks />);

    await waitFor(() => {
      expect(screen.getByText(/complete project documentation/i)).toBeInTheDocument();
      expect(screen.getByText(/review pull requests/i)).toBeInTheDocument();
    });
  });

  it('filters tasks when filter buttons are clicked', async () => {
    renderWithRouter(<Tasks />);
    const user = userEvent.setup();

    // Wait for tasks to load
    await waitFor(() => {
      expect(screen.getByText(/complete project documentation/i)).toBeInTheDocument();
    });

    // Click "Completed" filter
    const completedButton = screen.getByText(/completed/i);
    await user.click(completedButton);

    // Should only show completed tasks
    expect(screen.queryByText(/complete project documentation/i)).not.toBeInTheDocument();
    expect(screen.getByText(/review pull requests/i)).toBeInTheDocument();
  });

  it('shows empty state when no tasks match filter', async () => {
    renderWithRouter(<Tasks />);
    const user = userEvent.setup();

    await waitFor(() => {
      expect(screen.getByText(/complete project documentation/i)).toBeInTheDocument();
    });

    // Click "Active" filter
    const activeButton = screen.getByText(/active/i);
    await user.click(activeButton);

    // Should show tasks (mock data has active tasks)
    expect(screen.getByText(/complete project documentation/i)).toBeInTheDocument();
  });

  it('has a link to create new task', async () => {
    renderWithRouter(<Tasks />);

    await waitFor(() => {
      const createLinks = screen.getAllByText(/create task/i);
      expect(createLinks.length).toBeGreaterThan(0);
    });
  });
});
```

## Step 7: Run Tests

```bash
# Run all tests
docker-compose run frontend npm test

# Run specific test file
docker-compose run frontend npm test Tasks.test

# Run with coverage
docker-compose run frontend npm run test:coverage
```

## Step 8: Test in Browser

1. **Start the frontend**:
   ```bash
   docker-compose up frontend
   ```

2. **Visit the page**: http://localhost:5173/tasks

3. **Test functionality**:
   - Page loads without errors
   - Tasks are displayed
   - Filters work correctly
   - Links navigate properly
   - Responsive design works on mobile

## Validation

✅ **Success Criteria**:
- [ ] Page component created in `frontend/src/pages/Tasks.tsx`
- [ ] CSS module created in `frontend/src/pages/Tasks.module.css`
- [ ] Route added to `App.tsx`
- [ ] Navigation links added
- [ ] Component tests written and passing
- [ ] Page accessible at `/tasks` route
- [ ] Styling looks good and is responsive
- [ ] No console errors in browser

## Troubleshooting

### Issue: "Module not found"
**Solution**: Check import paths and ensure files are in correct directories

### Issue: "Route not working"
**Solution**: Verify route is added to `App.tsx` and path matches

### Issue: "Styles not applied"
**Solution**: Check CSS module import and className usage

### Issue: "Tests failing"
**Solution**: Ensure React Router wrapper is used in tests

## Next Steps

1. **Connect to API**: Replace mock data with actual API calls - See [How to Connect Frontend to API](how-to-connect-frontend-to-api.md)
2. **Add form page**: Create a page to add/edit tasks
3. **Add detail page**: Show individual task details
4. **Add state management**: Use Context API or state library
5. **Add loading skeletons**: Improve loading UX
6. **Add error boundaries**: Handle errors gracefully

## Best Practices

1. **Component Organization**: Keep pages simple, extract complex logic to custom hooks
2. **TypeScript**: Define interfaces for all props and state
3. **CSS Modules**: Use scoped styles to avoid conflicts
4. **Accessibility**: Use semantic HTML and ARIA attributes
5. **Responsive Design**: Test on multiple screen sizes
6. **Testing**: Test user interactions and edge cases

---

**Congratulations!** You've created a complete React page with routing, styling, and tests.
