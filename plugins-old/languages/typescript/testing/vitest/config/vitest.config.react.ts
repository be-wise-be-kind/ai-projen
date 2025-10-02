/**
 * Purpose: Vitest testing framework configuration for React TypeScript projects
 *
 * Scope: Test runner configuration for React components and integration tests
 *
 * Overview: Configures Vitest testing framework with React Testing Library integration, JSDOM
 *     environment for browser simulation, and comprehensive coverage reporting. Optimized for
 *     React component testing with proper environment variables and CSS processing support.
 *
 * Dependencies: Vitest testing framework, React plugin for JSX support, JSDOM
 *
 * Exports: Vitest configuration object with React testing optimizations
 *
 * Implementation: Testing framework configuration with React-specific setup
 */

import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./src/test-setup.ts'],
    css: true,
    env: {
      NODE_ENV: 'test',
    },
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
