# Xenon Plugin

Complexity enforcement - **fails build** when code exceeds complexity thresholds.

## What This Does

Xenon = Radon + Build Enforcement:
- Measures cyclomatic complexity
- **Exits with error** if thresholds exceeded
- Prevents merging overly complex code
- Configurable Grade A/B/C limits

## Why You Need It

**Radon shows complexity → Xenon enforces it**

- Radon: "Your function has CC=15 (Grade C)"
- Xenon: "Your function has CC=15 (Grade C) → **BUILD FAILED**"

## Usage

```bash
# Enforce Grade B maximum
make complexity-xenon

# Or directly
xenon --max-absolute B --max-modules A --max-average A src/
```

## Thresholds

| Flag | Meaning | Example |
|------|---------|---------|
| `-b B` | Max absolute: Any function ≤ Grade B | No function > CC 10 |
| `-m A` | Max modules: Module average ≤ Grade A | Module avg ≤ CC 5 |
| `-a A` | Max average: Overall average ≤ Grade A | Total avg ≤ CC 5 |

## Exit Codes

```bash
xenon -b B src/
# Exit 0: ✅ All functions Grade B or better
# Exit 1: ❌ At least one function Grade C or worse → BUILD FAILS
```

## CI/CD Enforcement

```yaml
- name: Enforce Complexity
  run: xenon -b B -m A -a A src/
```

If **any** function exceeds Grade B, the build fails and PR is blocked.

## Progression Strategy

1. **Assess current state**: `radon cc src/ -a`
2. **Set initial threshold**: `xenon -b C src/` (lenient)
3. **Improve gradually**: Refactor Grade D/E/F to Grade C
4. **Tighten threshold**: `xenon -b B src/`
5. **Aim for Grade A**: `xenon -b A src/` (ultimate goal)

## Integration

- ✅ CI/CD: Fails build on violations
- ✅ Pre-commit: Optional (can be slow)
- ✅ Makefile: `make complexity-xenon`
- ✅ Docker-first execution
