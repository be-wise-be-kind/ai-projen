# Radon Plugin

Cyclomatic complexity and maintainability analysis for Python code.

## What This Does

- **Cyclomatic Complexity (CC)**: Measures code paths and decision points
- **Maintainability Index (MI)**: Scores code maintainability (0-100)
- **Halstead Metrics**: Volume, difficulty, effort calculations
- **Code Health**: Identifies complex, hard-to-maintain code

## Complexity Grades

| Grade | CC Range | Maintainability | Risk |
|-------|----------|-----------------|------|
| **A** | 1-5 | Excellent (MI 20-100) | Low |
| **B** | 6-10 | Good | Low |
| **C** | 11-20 | Moderate | Medium |
| **D** | 21-30 | Poor | High |
| **E** | 31-40 | Very Poor | Very High |
| **F** | 41+ | Unmaintainable | Extreme |

## Usage

```bash
# Complexity analysis
make complexity-radon

# Or directly
radon cc src/ -a  # Average complexity
radon mi src/ -s  # Maintainability, sorted
```

## Target: Grade A

Best practice: Keep all functions at **Grade A (CC 1-5)** and **MI 20-100**.

```bash
# Show only problematic code (Grade B and lower)
radon cc src/ -nb
radon mi src/ -nb
```

## Integration

- ✅ Makefile target: `make complexity-radon`
- ✅ Docker-first execution
- ✅ CI/CD validation
- ✅ Pre-commit optional
