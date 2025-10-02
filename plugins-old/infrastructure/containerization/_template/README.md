# Containerization Plugin Template

**Purpose**: Template for creating new containerization plugins (Docker alternatives, Podman, etc.)

**Use this template to**: Add support for container technologies beyond Docker

---

## How to Use This Template

### Step 1: Copy This Directory

```bash
cp -r plugins/infrastructure/containerization/_template/ plugins/infrastructure/containerization/<tool-name>/
cd plugins/infrastructure/containerization/<tool-name>/
```

### Step 2: Customize Files

1. **README.md** - Replace with tool-specific documentation
2. **AGENT_INSTRUCTIONS.md** - Step-by-step installation for AI agents
3. **Add configuration files** - Compose files, Dockerfiles, etc.
4. **Add templates** - Makefile snippets, workflow files

### Step 3: What to Include

Your containerization plugin should provide:

- ✅ Container configuration files (Dockerfile, compose file, etc.)
- ✅ Multi-service support (frontend, backend, database, cache)
- ✅ Development vs production configurations
- ✅ Make targets (`docker-build`, `docker-up`, `docker-down`, etc.)
- ✅ Health checks and logging
- ✅ Volume management
- ✅ Network configuration

### Step 4: Integration Points

Your plugin should:

1. **Extend agents.md** - Add container commands between `INFRASTRUCTURE_COMMANDS` markers
2. **Provide Make targets** - Consistent naming for build, up, down, logs
3. **Work standalone** - Don't require orchestrator
4. **Integrate with languages** - Support detected language runtimes
5. **Document networking** - How services communicate

## Example: Docker Plugin

See `plugins/infrastructure/containerization/docker/` for a complete reference implementation.

**Key files**:
- `AGENT_INSTRUCTIONS.md` - How to install Docker support
- `templates/Dockerfile.frontend` - Frontend container template
- `templates/Dockerfile.backend` - Backend container template
- `templates/docker-compose.yml` - Multi-service orchestration
- `templates/makefile-docker.mk` - Make targets

## Common Patterns

### Makefile Integration
```makefile
.PHONY: docker-build docker-up docker-down docker-logs

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down

docker-logs:
	docker compose logs -f
```

### agents.md Extension
```markdown
#### <Tool Name>

**Build containers**:
```bash
make docker-build
```

**Start services**:
```bash
make docker-up
```

**Stop services**:
```bash
make docker-down
```

**View logs**:
```bash
make docker-logs
```
```

---

**Delete this README and replace with your tool-specific README when creating an actual plugin.**
