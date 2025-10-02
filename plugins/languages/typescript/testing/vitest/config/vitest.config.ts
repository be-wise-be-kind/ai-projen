/**
 * Purpose: Vitest testing framework configuration for TypeScript projects
 *
 * Scope: Test runner configuration for unit and integration tests
 *
 * Overview: Configures Vitest testing framework with optional React support, JSDOM environment
 *     for browser simulation, and comprehensive coverage reporting. Includes coverage thresholds
 *     to maintain code quality.
 *
 * Dependencies: Vitest testing framework
 *
 * Exports: Vitest configuration object
 *
 * Implementation: Testing framework configuration with coverage enforcement
 */

import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    setupFiles: ['./src/test-setup.ts'],
    coverage: {
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'dist/',
        '**/*.d.ts',
        '**/*.config.*',
        '**/coverage/**',
        '**/build/**',
      ],
      thresholds: {
        global: {
          branches: 70,
          functions: 70,
          lines: 70,
          statements: 70,
        },
      },
    },
  },
});
