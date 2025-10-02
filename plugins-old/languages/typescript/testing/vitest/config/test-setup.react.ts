/**
 * Purpose: Vitest test setup for React projects
 *
 * Scope: Global test environment setup with React Testing Library
 *
 * Overview: Configures test environment with React Testing Library, JSDOM polyfills,
 *     and necessary testing utilities. Includes cleanup and custom matchers.
 *
 * Dependencies: Vitest, React Testing Library, jest-dom
 *
 * Implementation: React test environment initialization
 */

import { expect, afterEach } from 'vitest';
import { cleanup } from '@testing-library/react';
import '@testing-library/jest-dom';

// Cleanup after each test automatically
afterEach(() => {
  cleanup();
});
