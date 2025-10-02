/**
 * Purpose: Example TypeScript file demonstrating project structure
 *
 * Scope: Sample code showcasing TypeScript conventions
 *
 * Overview: This is a starter file showing recommended TypeScript patterns including
 *     type definitions, function documentation, and export conventions.
 *
 * Dependencies: None
 *
 * Exports: Example function and type definitions
 *
 * Implementation: Sample TypeScript code following best practices
 */

/**
 * Example interface demonstrating type definitions
 */
export interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}

/**
 * Example function with type annotations and documentation
 *
 * @param name - The user's name
 * @param email - The user's email address
 * @returns A new User object
 */
export function createUser(name: string, email: string): User {
  return {
    id: crypto.randomUUID(),
    name,
    email,
    createdAt: new Date(),
  };
}

/**
 * Example async function demonstrating promise handling
 *
 * @param userId - The user ID to fetch
 * @returns Promise resolving to User or null
 */
export async function fetchUser(userId: string): Promise<User | null> {
  try {
    // Simulate API call
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      return null;
    }
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch user:', error);
    return null;
  }
}
