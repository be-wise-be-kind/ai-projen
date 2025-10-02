# TypeScript Development Makefile
# Purpose: Make targets for TypeScript linting, formatting, and testing
# Scope: TypeScript project automation

.PHONY: lint-ts format-ts format-check-ts test-ts test-coverage-ts typecheck-ts ts-check

# Lint TypeScript code with ESLint
lint-ts:
	@echo "Linting TypeScript code..."
	@npm run lint

# Auto-fix TypeScript formatting and linting issues
format-ts:
	@echo "Formatting TypeScript code..."
	@npm run format
	@npm run lint:fix

# Check TypeScript formatting without fixing
format-check-ts:
	@echo "Checking TypeScript formatting..."
	@npm run format:check

# Run TypeScript tests
test-ts:
	@echo "Running TypeScript tests..."
	@npm test

# Run TypeScript tests with coverage
test-coverage-ts:
	@echo "Running TypeScript tests with coverage..."
	@npm run test:coverage

# Run TypeScript type checking
typecheck-ts:
	@echo "Type checking TypeScript code..."
	@npm run typecheck

# Run all TypeScript checks (lint + typecheck + test)
ts-check: lint-ts typecheck-ts test-ts
	@echo "✓ All TypeScript checks passed"
