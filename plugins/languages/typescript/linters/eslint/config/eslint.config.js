/**
 * Purpose: ESLint configuration for TypeScript projects with optional React support
 *
 * Scope: Linting configuration for TypeScript code quality and style standards
 *
 * Overview: Modern ESLint flat config setup for TypeScript projects. Provides comprehensive
 *     linting with TypeScript-specific rules, optional React/JSX support, and best practices
 *     enforcement. Configurable for both standalone TypeScript and React TypeScript projects.
 *
 * Dependencies: ESLint, TypeScript ESLint, optional React plugins
 *
 * Exports: ESLint configuration array for flat config format
 *
 * Implementation: Flat config format with extensible rule sets
 */

import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';

export default tseslint.config([
  {
    ignores: ['dist', 'coverage', 'node_modules', 'build', '*.config.js'],
  },
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      js.configs.recommended,
      ...tseslint.configs.recommended,
      ...tseslint.configs.strict,
    ],
    languageOptions: {
      ecmaVersion: 2022,
      globals: globals.browser,
      parserOptions: {
        project: true,
      },
    },
    rules: {
      // TypeScript rules
      '@typescript-eslint/no-unused-vars': ['error', {
        'argsIgnorePattern': '^_',
        'varsIgnorePattern': '^_',
        'caughtErrorsIgnorePattern': '^_',
      }],
      '@typescript-eslint/explicit-function-return-type': 'off',
      '@typescript-eslint/explicit-module-boundary-types': 'off',
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/no-non-null-assertion': 'warn',
      '@typescript-eslint/prefer-nullish-coalescing': 'warn',
      '@typescript-eslint/prefer-optional-chain': 'warn',

      // General rules
      'no-console': ['warn', { allow: ['warn', 'error'] }],
      'prefer-const': 'error',
      'no-debugger': 'warn',
      'no-var': 'error',
      'eqeqeq': ['error', 'always'],

      // Import ordering (basic)
      'sort-imports': ['error', {
        'ignoreCase': true,
        'ignoreDeclarationSort': true,
      }],
    },
  },
]);
