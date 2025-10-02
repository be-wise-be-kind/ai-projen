# How-To: Add a Volume

**Purpose**: Add persistent data storage or bind mounts to Docker containers

**Scope**: Named volumes for data persistence and bind mounts for hot reload development

**Prerequisites**:
- Docker installed
- Existing docker-compose.yml
- Understanding of containers and data persistence

**Estimated Time**: 10-15 minutes

**Difficulty**: Beginner

---

## Overview

Docker volumes solve two key problems:

1. **Data Persistence**: Keep data after containers are removed
2. **Hot Reload**: Share code between host and container for instant updates

There are two types of volumes:
- **Named Volumes**: Managed by Docker, used for persistent data (databases, uploads, etc.)
- **Bind Mounts**: Map host directory to container, used for development code sharing

---

## Part 1: Named Volumes (Data Persistence)

Use named volumes for data that must persist across container restarts.

### Step 1: Define the Volume

Add to `docker-compose.yml`:

```yaml
services:
  postgres:
    image: postgres:15-alpine
    volumes:
      - postgres-data:/var/lib/postgresql/data  # Named volume

volumes:
  postgres-data:  # Define named volume
```

### Step 2: Choose Volume Location

**Database Data**:
```yaml
# PostgreSQL
- postgres-data:/var/lib/postgresql/data

# MySQL
- mysql-data:/var/lib/mysql

# MongoDB
- mongo-data:/data/db

# Redis
- redis-data:/data
```

**Application Data**:
```yaml
# File uploads
- uploads-data:/app/uploads

# Logs
- logs-data:/var/log/app

# Cache
- cache-data:/app/cache
```

### Step 3: Verify Volume Persistence

```bash
# Start service
docker compose up -d postgres

# Add some data (example: create a database)
docker compose exec postgres psql -U postgres -c "CREATE DATABASE mydb;"

# Stop and remove container
docker compose down

# Start again
docker compose up -d postgres

# Verify data persists
docker compose exec postgres psql -U postgres -l
# mydb should still exist!
```

### Step 4: Inspect Volume

```bash
# List volumes
docker volume ls

# Inspect volume details
docker volume inspect <project>_postgres-data

# View volume location
docker volume inspect <project>_postgres-data | jq -r '.[0].Mountpoint'
```

### Step 5: Backup Named Volume

```bash
# Backup volume to tar file
docker run --rm \
  -v <project>_postgres-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres-backup.tar.gz -C /data .

# Restore from backup
docker run --rm \
  -v <project>_postgres-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/postgres-backup.tar.gz -C /data
```

---

## Part 2: Bind Mounts (Hot Reload Development)

Use bind mounts to share code between host and container for instant updates.

### Step 1: Add Bind Mount to docker-compose.yml

**Backend (Python)**:
```yaml
services:
  backend-dev:
    # ... other config ...
    volumes:
      # Mount source code for hot reload
      - ./app:/app/app
      - ./src:/app/src
      - ./tests:/app/tests

      # Exclude cache directories (use container's versions)
      - /app/__pycache__
      - /app/app/__pycache__
      - /app/src/__pycache__
```

**Frontend (Node)**:
```yaml
services:
  frontend-dev:
    # ... other config ...
    volumes:
      # Mount entire frontend directory
      - ./frontend:/app

      # Exclude node_modules (use container's installed version)
      - /app/node_modules
```

### Step 2: Understand Exclusion Patterns

When mounting directories, **exclude** directories that should come from the container:

```yaml
volumes:
  # Mount source
  - ./app:/app/app

  # Exclude cache/dependencies (use container's version)
  - /app/__pycache__      # Python cache
  - /app/node_modules     # Node dependencies
  - /app/.venv            # Virtual environment
  - /app/dist             # Build artifacts
```

**Why exclude?**
- Host and container may have different architectures
- Dependencies compiled for different platforms
- Prevents permission issues
- Preserves container-specific configurations

### Step 3: Test Hot Reload

**Backend**:
1. Start service: `docker compose up -d backend-dev`
2. Edit Python file: `echo "# test change" >> app/main.py`
3. Watch logs: `docker compose logs -f backend-dev`
4. Verify server auto-reloads

**Frontend**:
1. Start service: `docker compose up -d frontend-dev`
2. Edit React component: `touch frontend/src/App.tsx`
3. Open browser: `http://localhost:5173`
4. Verify HMR (Hot Module Replacement) updates

### Step 4: Handle Permission Issues

**Problem**: Container writes files as root, host can't modify them.

**Solution 1**: Run container as your user ID
```yaml
services:
  backend-dev:
    user: "${UID:-1000}:${GID:-1000}"
    volumes:
      - ./app:/app/app
```

Set in `.env`:
```bash
UID=1000  # Your user ID (run `id -u` to find)
GID=1000  # Your group ID (run `id -g` to find)
```

**Solution 2**: Fix permissions after creation
```bash
# Fix ownership
sudo chown -R $USER:$USER ./app

# Or fix permissions
chmod -R 755 ./app
```

---

## Part 3: Combining Named Volumes and Bind Mounts

A typical service uses both:

```yaml
services:
  backend-dev:
    volumes:
      # Bind mounts for development (hot reload)
      - ./app:/app/app
      - ./src:/app/src

      # Exclude cache directories
      - /app/__pycache__

      # Named volume for persistent data
      - uploads-data:/app/uploads

volumes:
  uploads-data:  # Persist user uploads across restarts
```

---

## Part 4: Volume Management

### List All Volumes

```bash
# List volumes
docker volume ls

# Filter by project
docker volume ls --filter name=<project>
```

### Remove Volumes

```bash
# Remove unused volumes
docker volume prune

# Remove specific volume
docker volume rm <volume-name>

# Remove all project volumes (WARNING: deletes data!)
docker compose down -v
```

### Volume Size and Location

```bash
# Check volume size
docker system df -v

# Find volume location
docker volume inspect <volume-name> | jq -r '.[0].Mountpoint'

# View volume contents (read-only)
docker run --rm -v <volume-name>:/data alpine ls -lah /data
```

---

## Common Patterns

### Pattern 1: Development + Production Volumes

```yaml
services:
  backend-dev:
    volumes:
      # Development: bind mounts for hot reload
      - ./app:/app/app
      - /app/__pycache__

  backend-prod:
    volumes:
      # Production: only persistent data
      - uploads-data:/app/uploads
      - logs-data:/var/log/app

volumes:
  uploads-data:
  logs-data:
```

### Pattern 2: Read-Only Mounts

Prevent container from modifying host files:

```yaml
volumes:
  # Read-only configuration
  - ./config:/app/config:ro

  # Read-only initialization scripts
  - ./scripts/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
```

### Pattern 3: Shared Volumes

Multiple services accessing the same volume:

```yaml
services:
  backend:
    volumes:
      - shared-uploads:/app/uploads

  worker:
    volumes:
      - shared-uploads:/app/uploads  # Same volume

volumes:
  shared-uploads:  # Shared between services
```

---

## Best Practices

### 1. Use Named Volumes for Data

✅ **DO**:
```yaml
volumes:
  - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

❌ **DON'T**:
```yaml
volumes:
  - ./data:/var/lib/postgresql/data  # Bind mount for database
```

**Why?** Named volumes:
- Managed by Docker
- Better performance
- Avoid permission issues
- Easy to backup/restore

### 2. Use Bind Mounts for Code

✅ **DO**:
```yaml
volumes:
  - ./app:/app/app  # Development hot reload
```

❌ **DON'T** (for development):
```yaml
volumes:
  - app-code:/app/app  # Can't edit code on host
```

### 3. Always Exclude Dependencies

✅ **DO**:
```yaml
volumes:
  - ./frontend:/app
  - /app/node_modules  # Exclude
```

❌ **DON'T**:
```yaml
volumes:
  - ./frontend:/app  # Overwrites container's node_modules
```

### 4. Document Volume Purpose

```yaml
volumes:
  # Persistent database storage
  - postgres-data:/var/lib/postgresql/data

  # User uploaded files
  - uploads-data:/app/uploads

  # Application logs
  - logs-data:/var/log/app
```

---

## Verification

Check your volume configuration:

- [ ] Named volumes defined in `volumes:` section
- [ ] Bind mounts use correct host paths
- [ ] Dependencies excluded (node_modules, __pycache__)
- [ ] Database data persists after `docker compose down`
- [ ] Code changes trigger hot reload
- [ ] No permission issues when editing files
- [ ] Read-only mounts used for config files
- [ ] Volume sizes are reasonable

Test data persistence:

```bash
# Add data
docker compose exec <service> <command to add data>

# Remove container
docker compose down

# Start again
docker compose up -d

# Verify data still exists
docker compose exec <service> <command to check data>
```

---

## Common Issues

### Issue: Hot reload not working

**Solutions**:
- Verify volume mount path matches container structure
- Check dev server is configured for hot reload
- Ensure files are actually being modified
- Check polling vs file watching (may need polling on some systems)

### Issue: Permission denied

**Solutions**:
- Run container with your user ID: `user: "${UID}:${GID}"`
- Fix ownership: `sudo chown -R $USER:$USER ./app`
- Use named volumes instead of bind mounts for persistent data

### Issue: Data disappears after restart

**Solutions**:
- Verify using named volume, not anonymous volume
- Don't use `docker compose down -v` (removes volumes)
- Check volume is defined in `volumes:` section

### Issue: Slow performance (macOS/Windows)

**Solutions**:
- Use named volumes instead of bind mounts for node_modules
- Use Docker Desktop with VirtioFS (macOS) or WSL2 (Windows)
- Consider using `:cached` or `:delegated` for bind mounts:
  ```yaml
  volumes:
    - ./app:/app/app:delegated
  ```

---

## Next Steps

After configuring volumes:

1. Test data persistence with database restarts
2. Verify hot reload works for all source code
3. Set up volume backups for production data
4. Document volume locations and purposes
5. Configure volume monitoring for production

---

## Related Documentation

- [Docker Standards](../standards/docker-standards.md)
- [How to Add a Service](how-to-add-a-service.md)
- [Docker Volumes Documentation](https://docs.docker.com/storage/volumes/)

---

**Last Updated**: 2025-10-01
**Difficulty**: Beginner
**Estimated Time**: 10-15 minutes
