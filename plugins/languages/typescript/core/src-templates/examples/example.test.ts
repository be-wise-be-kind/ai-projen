/**
 * Purpose: Example test file demonstrating Vitest patterns
 *
 * Scope: Sample tests for example.ts
 *
 * Overview: Demonstrates recommended testing patterns including test organization,
 *     mocking, and assertion styles.
 *
 * Dependencies: Vitest
 *
 * Implementation: Unit tests following Vitest best practices
 */

import { describe, it, expect, beforeEach, vi } from 'vitest';
import { createUser, fetchUser, type User } from './example';

describe('createUser', () => {
  it('should create a user with provided name and email', () => {
    const user = createUser('John Doe', 'john@example.com');

    expect(user).toMatchObject({
      name: 'John Doe',
      email: 'john@example.com',
    });
    expect(user.id).toBeTruthy();
    expect(user.createdAt).toBeInstanceOf(Date);
  });

  it('should generate unique IDs for different users', () => {
    const user1 = createUser('John Doe', 'john@example.com');
    const user2 = createUser('Jane Doe', 'jane@example.com');

    expect(user1.id).not.toBe(user2.id);
  });
});

describe('fetchUser', () => {
  beforeEach(() => {
    // Reset mocks before each test
    vi.restoreAllMocks();
  });

  it('should fetch user successfully', async () => {
    const mockUser: User = {
      id: '123',
      name: 'John Doe',
      email: 'john@example.com',
      createdAt: new Date(),
    };

    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => mockUser,
    });

    const user = await fetchUser('123');

    expect(user).toEqual(mockUser);
    expect(fetch).toHaveBeenCalledWith('/api/users/123');
  });

  it('should return null when user not found', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      ok: false,
    });

    const user = await fetchUser('999');

    expect(user).toBeNull();
  });

  it('should handle fetch errors gracefully', async () => {
    global.fetch = vi.fn().mockRejectedValue(new Error('Network error'));

    const user = await fetchUser('123');

    expect(user).toBeNull();
  });
});
