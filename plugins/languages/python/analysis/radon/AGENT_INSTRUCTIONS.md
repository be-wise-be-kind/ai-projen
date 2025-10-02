# Radon Complexity Analysis - Agent Instructions

**Purpose**: Install and configure Radon for cyclomatic complexity and maintainability index analysis

**Scope**: Complexity metrics, maintainability scoring, code health analysis

**Overview**: Radon computes cyclomatic complexity, Halstead metrics, and maintainability index to assess code quality.

**Dependencies**: Python 3.11+

---

## What is Radon?

Radon analyzes Python code to compute:
- **Cyclomatic Complexity (CC)**: Measure of code paths
- **Maintainability Index (MI)**: Code maintainability score (0-100)
- **Halstead metrics**: Code volume, difficulty, effort

**Complexity Grades**:
- **A**: CC 1-5 (simple, maintainable)
- **B**: CC 6-10 (moderate)
- **C**: CC 11-20 (complex)
- **D**: CC 21-30 (very complex)
- **E**: CC 31-40 (extremely complex)
- **F**: CC 41+ (unmaintainable)

**Maintainability Index**:
- **A**: MI 20-100 (highly maintainable)
- **B**: MI 10-19 (moderately maintainable)
- **C**: MI 0-9 (difficult to maintain)

## Installation

Using pip:
```bash
pip install radon
```

Using poetry:
```bash
poetry add --group dev radon
```

## Usage

### Cyclomatic Complexity
```bash
# Show complexity
radon cc src/ -a

# Show only complex functions (C grade and above)
radon cc src/ -nc
```

### Maintainability Index
```bash
# Show maintainability
radon mi src/ -s

# Show only low-maintainability code
radon mi src/ -nb
```

### Makefile Integration
Already included in `makefile-python.mk`:
```makefile
complexity-radon: ## Analyze code complexity with Radon
	radon cc src/ -a -nb  # CC, average, grade B and lower
	radon mi src/ -s -nb  # MI, sorted, grade B and lower
```

## Configuration

Create `radon.cfg` (optional):
```ini
[radon]
cc_min = A  # Minimum acceptable complexity grade
mi_min = A  # Minimum acceptable maintainability grade
exclude = tests/*,test/*
```

## CI/CD Integration

```yaml
- name: Check Complexity
  run: |
    radon cc src/ --total-average
    radon mi src/ --min B  # Fail if below grade B
```

## Success Criteria

- ✅ `radon --version` works
- ✅ `make complexity-radon` shows metrics
- ✅ Identifies complex functions
- ✅ Tracks maintainability scores
