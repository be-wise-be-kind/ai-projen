# How-To: Add a Service to docker-compose

**Purpose**: Add a new service (database, cache, queue, etc.) to your Docker Compose setup

**Scope**: Adding and configuring services in docker-compose.yml for local development

**Prerequisites**:
- Docker infrastructure plugin installed
- Existing docker-compose.yml file
- Basic understanding of the service you're adding

**Estimated Time**: 15-20 minutes

**Difficulty**: Intermediate

---

## Overview

This guide shows you how to add a new service to your docker-compose.yml file. Common services include:
- PostgreSQL database
- MySQL database
- Redis cache
- RabbitMQ/Kafka message queue
- Elasticsearch search engine
- MongoDB document database

We'll use PostgreSQL as the example, but the pattern applies to any service.

---

## Steps

### Step 1: Choose Your Service Image

Find the official Docker image for your service on [Docker Hub](https://hub.docker.com/):

**Common Services**:
- PostgreSQL: `postgres:15-alpine`
- MySQL: `mysql:8.0`
- Redis: `redis:7-alpine`
- RabbitMQ: `rabbitmq:3-management-alpine`
- Elasticsearch: `elasticsearch:8.8.0`
- MongoDB: `mongo:6.0`

**Best Practices**:
- Use official images when available
- Pin specific versions (not `latest`)
- Use alpine variants for smaller size when possible

### Step 2: Add Service to docker-compose.yml

Open `docker-compose.yml` and add the service under the `services:` section:

```yaml
services:
  # ... existing services (backend-dev, frontend-dev) ...

  postgres:
    image: postgres:15-alpine
    container_name: ${PROJECT_NAME:-app}-postgres-${BRANCH_NAME:-main}
    environment:
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
      POSTGRES_DB: ${DB_NAME:-app_db}
    ports:
      - "${DB_PORT:-5432}:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres-data:  # Define named volume at the end

networks:
  app-network:  # Reuse existing network
```

### Step 3: Update Environment Variables

Add environment variables to `.env`:

```bash
# Database Configuration
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=app_db
DB_HOST=postgres
DB_PORT=5432

# Database connection string (if using URL format)
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
```

And update `.env.example` with the same variables (but use placeholder values):

```bash
# Database Configuration
DB_USER=postgres
DB_PASSWORD=change-me-in-production
DB_NAME=app_db
DB_HOST=postgres
DB_PORT=5432
```

### Step 4: Configure Service Dependencies

If your backend depends on the database, add a `depends_on` clause:

```yaml
services:
  backend-dev:
    # ... existing config ...
    depends_on:
      postgres:
        condition: service_healthy  # Wait for health check to pass
    environment:
      - DATABASE_URL=${DATABASE_URL}
```

**Note**: `depends_on` with `condition: service_healthy` requires the service to have a health check configured.

### Step 5: Add Initialization Scripts (Optional)

For databases, you may want to add initialization scripts:

**For PostgreSQL**:
1. Create `scripts/init-db.sql`:
```sql
-- Create tables, seed data, etc.
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

2. Mount the script in docker-compose.yml:
```yaml
postgres:
  # ... existing config ...
  volumes:
    - postgres-data:/var/lib/postgresql/data
    - ./scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql:ro
```

PostgreSQL will automatically run scripts in `/docker-entrypoint-initdb.d/` on first startup.

### Step 6: Start the Service

```bash
# Start all services (including the new one)
make docker-up

# Or manually
docker compose up -d
```

### Step 7: Verify Service is Running

```bash
# Check service status
docker compose ps

# Check logs
docker compose logs postgres

# Verify health check
docker compose ps --format json | jq -r '.[] | "\(.Name): \(.Health)"'
```

### Step 8: Connect to the Service

**From Backend Container**:
```bash
# Example: Connect to PostgreSQL from Python
import psycopg2

conn = psycopg2.connect(
    host="postgres",  # Service name, not localhost!
    port=5432,
    user="postgres",
    password="postgres",
    database="app_db"
)
```

**From Host Machine** (for debugging):
```bash
# PostgreSQL
psql -h localhost -p 5432 -U postgres -d app_db

# Redis
redis-cli -p 6379

# MySQL
mysql -h localhost -P 3306 -u root -p
```

### Step 9: Test the Connection

Add a test endpoint to verify connectivity:

```python
# app/main.py (FastAPI example)
@app.get("/health/db")
async def health_db():
    try:
        # Try to connect to database
        conn = psycopg2.connect(
            host="postgres",
            port=5432,
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            database=os.getenv("DB_NAME")
        )
        conn.close()
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        return {"status": "unhealthy", "error": str(e)}
```

Test the endpoint:
```bash
curl http://localhost:8000/health/db
```

---

## Service-Specific Examples

### Redis Cache

```yaml
redis:
  image: redis:7-alpine
  container_name: ${PROJECT_NAME:-app}-redis-${BRANCH_NAME:-main}
  ports:
    - "${REDIS_PORT:-6379}:6379"
  volumes:
    - redis-data:/data
  networks:
    - app-network
  restart: unless-stopped
  healthcheck:
    test: ["CMD", "redis-cli", "ping"]
    interval: 10s
    timeout: 5s
    retries: 5

volumes:
  redis-data:
```

### RabbitMQ Message Queue

```yaml
rabbitmq:
  image: rabbitmq:3-management-alpine
  container_name: ${PROJECT_NAME:-app}-rabbitmq-${BRANCH_NAME:-main}
  environment:
    RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER:-admin}
    RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASSWORD:-admin}
  ports:
    - "${RABBITMQ_PORT:-5672}:5672"      # AMQP port
    - "${RABBITMQ_MGMT_PORT:-15672}:15672"  # Management UI
  volumes:
    - rabbitmq-data:/var/lib/rabbitmq
  networks:
    - app-network
  restart: unless-stopped
  healthcheck:
    test: ["CMD", "rabbitmq-diagnostics", "ping"]
    interval: 30s
    timeout: 10s
    retries: 5

volumes:
  rabbitmq-data:
```

### Elasticsearch

```yaml
elasticsearch:
  image: elasticsearch:8.8.0
  container_name: ${PROJECT_NAME:-app}-elasticsearch-${BRANCH_NAME:-main}
  environment:
    - discovery.type=single-node
    - xpack.security.enabled=false
    - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
  ports:
    - "${ES_PORT:-9200}:9200"
  volumes:
    - elasticsearch-data:/usr/share/elasticsearch/data
  networks:
    - app-network
  restart: unless-stopped
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:9200/_cluster/health || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 5

volumes:
  elasticsearch-data:
```

---

## Best Practices

### Use Environment Variables

✅ **DO**:
```yaml
postgres:
  environment:
    POSTGRES_USER: ${DB_USER:-postgres}
    POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
```

❌ **DON'T**:
```yaml
postgres:
  environment:
    POSTGRES_USER: postgres  # Hardcoded
    POSTGRES_PASSWORD: mypassword  # Hardcoded secret!
```

### Use Named Volumes

✅ **DO**:
```yaml
volumes:
  - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:  # Named volume (persists data)
```

❌ **DON'T**:
```yaml
volumes:
  - ./data:/var/lib/postgresql/data  # Bind mount (permission issues)
```

### Always Add Health Checks

✅ **DO**:
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
  interval: 10s
  timeout: 5s
  retries: 5
```

### Use Service Names for Connection

From backend code:
```python
# ✅ CORRECT - Use service name
DATABASE_URL = "postgresql://user:pass@postgres:5432/db"

# ❌ WRONG - Don't use localhost
DATABASE_URL = "postgresql://user:pass@localhost:5432/db"
```

---

## Common Issues and Solutions

### Issue: Service won't start

**Symptoms**: Service keeps restarting
```bash
docker compose logs postgres
```

**Solutions**:
1. Check logs for error messages
2. Verify environment variables are set
3. Check port conflicts: `lsof -i :5432`
4. Ensure volume has correct permissions

### Issue: Backend can't connect to service

**Symptoms**: Connection refused or timeout errors

**Solutions**:
1. Use service name, not `localhost`: `postgres` not `127.0.0.1`
2. Use internal port (5432), not published port
3. Ensure services are on the same network
4. Wait for service health check: use `depends_on` with `condition: service_healthy`

### Issue: Data not persisting

**Symptoms**: Data disappears after `docker compose down`

**Solutions**:
1. Use named volumes, not bind mounts
2. Don't use `docker compose down -v` (removes volumes)
3. Verify volume is defined in `volumes:` section

### Issue: Permission denied errors

**Symptoms**: Database can't write to volume

**Solutions**:
1. Use named volumes instead of bind mounts
2. If using bind mounts, set correct permissions:
   ```bash
   mkdir -p ./data
   chmod 777 ./data  # Or use appropriate user/group
   ```

---

## Verification

After adding the service, verify:

- [ ] Service starts successfully: `docker compose ps`
- [ ] Health check passes: `docker compose ps` shows "healthy"
- [ ] Logs show no errors: `docker compose logs <service>`
- [ ] Can connect from backend using service name
- [ ] Can connect from host using localhost (for debugging)
- [ ] Data persists after restart: `docker compose restart <service>`
- [ ] Environment variables are used (no hardcoded values)
- [ ] Health check is configured
- [ ] Named volume is defined

---

## Next Steps

After adding a service:

1. Update backend code to use the new service
2. Add service-specific dependencies (e.g., `psycopg2` for PostgreSQL)
3. Configure connection pooling for production
4. Add database migrations (e.g., Alembic for PostgreSQL)
5. Document service usage in README.md
6. Add service-specific testing

---

## Related Documentation

- [Docker Standards](../standards/DOCKER_STANDARDS.md) - Best practices
- [How to Create Multi-Stage Dockerfile](how-to-create-multi-stage-dockerfile.md)
- [How to Add a Volume](how-to-add-volume.md)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

**Last Updated**: 2025-10-01
**Difficulty**: Intermediate
**Estimated Time**: 15-20 minutes
