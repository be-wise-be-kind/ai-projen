/**
 * Purpose: Vitest test setup and global configuration
 *
 * Scope: Global test environment setup for all test files
 *
 * Overview: Configures test environment with necessary polyfills, global utilities,
 *     and testing library setup. This file runs before each test file.
 *
 * Dependencies: Vitest
 *
 * Implementation: Test environment initialization
 */

import { expect, afterEach } from 'vitest';

// Clean up after each test
afterEach(() => {
  // Add cleanup logic here if needed
});

// Extend Vitest's expect with custom matchers if needed
// Example: expect.extend(customMatchers);
