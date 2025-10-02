# Xenon Complexity Enforcement - Agent Instructions

**Purpose**: Install and configure Xenon for complexity enforcement (fails build on violations)

**Scope**: Complexity gate enforcement, build-time validation

**Overview**: Xenon monitors code complexity and **fails the build** when complexity exceeds thresholds.
    It's Radon with teeth - analyzes complexity and exits with error code if violations found.

**Dependencies**: Python 3.11+, radon (Xenon uses Radon internally)

---

## What is Xenon?

Xenon = Radon + Enforcement:
- Uses Radon's complexity calculation
- **Fails build** when complexity exceeds limits
- Prevents merging overly complex code
- Configurable thresholds

## Installation

Using pip:
```bash
pip install xenon
```

Using poetry:
```bash
poetry add --group dev xenon
```

## Usage

### Enforce Complexity Limits

```bash
# Fail if any function has CC > 10 (Grade B)
xenon --max-absolute B --max-modules A --max-average A src/

# Fail if average complexity > A or any function > B
xenon -b B -m A -a A src/
```

### Common Thresholds

**Strict** (Grade A enforcement):
```bash
xenon -b A -m A -a A src/  # Everything must be Grade A
```

**Moderate** (Grade B maximum):
```bash
xenon -b B -m A -a A src/  # Allow Grade B functions, average A
```

**Lenient** (Grade C maximum):
```bash
xenon -b C -m B -a B src/  # Allow Grade C functions
```

### Makefile Integration

Already in `makefile-python.mk`:
```makefile
complexity-xenon: ## Enforce complexity limits with Xenon (fails on violations)
	xenon --max-absolute B --max-modules A --max-average A src/
```

## Configuration

Xenon uses command-line flags (no config file):

```bash
# Flags:
-b, --max-absolute B  # Max complexity for any block
-m, --max-modules A   # Max module average complexity
-a, --max-average A   # Max overall average complexity
```

## CI/CD Integration

```yaml
- name: Enforce Complexity
  run: |
    pip install xenon
    xenon -b B -m A -a A src/  # Fails build if violated
```

## Exit Codes

- **0**: All complexity within limits ✅
- **1**: Complexity violations found ❌

## Best Practices

1. **Start lenient, get strict**: Begin with `-b C`, move to `-b B`, aim for `-b A`
2. **Enforce in CI/CD**: Prevent complex code from merging
3. **Combine with Radon**: Radon for analysis, Xenon for enforcement
4. **Set team standards**: Agree on Grade A/B threshold

## Success Criteria

- ✅ `xenon --version` works
- ✅ `make complexity-xenon` enforces limits
- ✅ Build fails on Grade C+ functions
- ✅ Prevents merging overly complex code
