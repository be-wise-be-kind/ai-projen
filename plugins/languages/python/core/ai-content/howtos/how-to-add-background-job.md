# How to Add a Background Job

**Purpose**: Step-by-step guide for creating background tasks using Celery or RQ with Docker-first development and Redis integration

**Scope**: Async task creation, Celery/RQ configuration, task scheduling, result storage, Docker-based task execution

**Overview**: Comprehensive guide for implementing background job processing with Celery or RQ task queues. Covers framework selection, worker configuration, task definition, scheduling, monitoring, and error handling in Docker containers with Redis backend. Ensures reliable async processing for long-running operations, scheduled jobs, and distributed task execution.

**Dependencies**: Celery or RQ, Redis, Docker, task queue concepts, async patterns

**Exports**: Background task workflow, Celery/RQ patterns, Docker task execution, monitoring strategies

**Related**: Async processing, distributed systems, job scheduling, task monitoring

**Implementation**: Celery/RQ task definitions, worker processes, Redis configuration, Docker Compose services

---

This guide provides step-by-step instructions for adding background jobs using Celery or RQ with Docker-first development.

## Prerequisites

- Python plugin installed in your project
- Docker and Docker Compose configured
- Redis service available
- Understanding of async task patterns
- Basic knowledge of task queues

## Docker-First Development Pattern

All background jobs should be configured and tested in Docker containers to ensure proper queue connectivity.

**Environment Priority**:
1. Docker containers with Redis service (recommended)
2. Poetry with local Redis (fallback)
3. Direct local execution (last resort)

## Framework Selection: Celery vs RQ

Choose based on your requirements:

### Celery
**Best for:**
- Complex task workflows
- Task scheduling (cron-like)
- Task chains and groups
- Multiple broker support (Redis, RabbitMQ, etc.)
- Production-grade applications

**Pros:**
- Feature-rich
- Battle-tested
- Extensive monitoring tools
- Advanced routing

**Cons:**
- More complex setup
- Heavier resource usage
- Steeper learning curve

### RQ (Redis Queue)
**Best for:**
- Simple background tasks
- Quick setup and development
- Redis-only projects
- Lightweight applications

**Pros:**
- Simple and pythonic
- Easy to understand
- Minimal configuration
- Built-in dashboard

**Cons:**
- Redis only
- Less features than Celery
- Basic scheduling

**Recommendation**: Use Celery for production apps with complex workflows, RQ for simple background tasks.

## Steps to Add a Background Job (Celery)

### 1. Install Celery Dependencies

**Add to `pyproject.toml`**:
```toml
[tool.poetry.dependencies]
celery = {extras = ["redis"], version = "^5.3.0"}
redis = "^5.0.0"

[tool.poetry.group.dev.dependencies]
flower = "^2.0.0"  # For monitoring
```

**Rebuild Docker**:
```bash
make python-install
```

### 2. Configure Redis in Docker Compose

**Update `docker-compose.yml`**:
```yaml
services:
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build: .
    environment:
      CELERY_BROKER_URL: redis://redis:6379/0
      CELERY_RESULT_BACKEND: redis://redis:6379/0
    depends_on:
      redis:
        condition: service_healthy

  celery_worker:
    build: .
    command: celery -A backend.celery_app worker --loglevel=info
    environment:
      CELERY_BROKER_URL: redis://redis:6379/0
      CELERY_RESULT_BACKEND: redis://redis:6379/0
    depends_on:
      redis:
        condition: service_healthy
    volumes:
      - .:/app

  celery_beat:
    build: .
    command: celery -A backend.celery_app beat --loglevel=info
    environment:
      CELERY_BROKER_URL: redis://redis:6379/0
      CELERY_RESULT_BACKEND: redis://redis:6379/0
    depends_on:
      redis:
        condition: service_healthy
    volumes:
      - .:/app

  flower:
    build: .
    command: celery -A backend.celery_app flower --port=5555
    ports:
      - "5555:5555"
    environment:
      CELERY_BROKER_URL: redis://redis:6379/0
      CELERY_RESULT_BACKEND: redis://redis:6379/0
    depends_on:
      redis:
        condition: service_healthy

volumes:
  redis_data:
```

### 3. Create Celery Application

**Create Celery config** (`backend/celery_app.py`):
```python
"""Celery application configuration."""

from celery import Celery
from celery.schedules import crontab
import os

# Create Celery instance
celery_app = Celery(
    "backend",
    broker=os.getenv("CELERY_BROKER_URL", "redis://redis:6379/0"),
    backend=os.getenv("CELERY_RESULT_BACKEND", "redis://redis:6379/0"),
    include=["backend.tasks"]  # Auto-discover tasks
)

# Configure Celery
celery_app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="UTC",
    enable_utc=True,
    task_track_started=True,
    task_time_limit=30 * 60,  # 30 minutes
    task_soft_time_limit=25 * 60,  # 25 minutes
    worker_prefetch_multiplier=1,
    worker_max_tasks_per_child=1000,
)

# Configure periodic tasks (beat schedule)
celery_app.conf.beat_schedule = {
    "cleanup-old-data": {
        "task": "backend.tasks.cleanup_old_data",
        "schedule": crontab(hour=2, minute=0),  # 2 AM daily
    },
    "send-daily-reports": {
        "task": "backend.tasks.send_daily_reports",
        "schedule": crontab(hour=9, minute=0),  # 9 AM daily
    },
    "check-health-every-5-minutes": {
        "task": "backend.tasks.health_check",
        "schedule": 300.0,  # Every 5 minutes (in seconds)
    },
}
```

### 4. Create Background Tasks

**Using the template**:
```bash
cp plugins/languages/python/templates/celery-task.py.template backend/tasks.py
```

**Manual creation** (`backend/tasks.py`):
```python
"""Background tasks for async processing."""

from celery import shared_task
from celery.utils.log import get_task_logger
from typing import Any
import time

logger = get_task_logger(__name__)


@shared_task(bind=True, max_retries=3, default_retry_delay=60)
def send_email(self, to: str, subject: str, body: str) -> dict[str, Any]:
    """Send email asynchronously.

    Args:
        to: Recipient email
        subject: Email subject
        body: Email body

    Returns:
        Result dictionary with status

    Raises:
        Exception: If email sending fails after retries
    """
    try:
        logger.info(f"Sending email to {to}")

        # Simulate email sending
        time.sleep(2)

        # Actual email sending logic here
        # send_smtp_email(to, subject, body)

        logger.info(f"Email sent successfully to {to}")
        return {
            "status": "success",
            "recipient": to,
            "task_id": self.request.id
        }

    except Exception as exc:
        logger.error(f"Error sending email: {exc}")
        # Retry the task
        raise self.retry(exc=exc)


@shared_task
def process_data(data_id: int) -> dict[str, Any]:
    """Process data in background.

    Args:
        data_id: ID of data to process

    Returns:
        Processing result
    """
    logger.info(f"Processing data {data_id}")

    # Simulate processing
    time.sleep(5)

    # Actual processing logic
    result = {"processed": True, "data_id": data_id}

    logger.info(f"Data {data_id} processed")
    return result


@shared_task(bind=True)
def generate_report(self, user_id: int, report_type: str) -> str:
    """Generate report in background.

    Args:
        user_id: User requesting report
        report_type: Type of report to generate

    Returns:
        Report file path
    """
    logger.info(f"Generating {report_type} report for user {user_id}")

    # Update task state for progress tracking
    self.update_state(
        state="PROGRESS",
        meta={"current": 0, "total": 100, "status": "Starting..."}
    )

    # Simulate report generation with progress
    for i in range(100):
        time.sleep(0.1)
        if i % 10 == 0:
            self.update_state(
                state="PROGRESS",
                meta={
                    "current": i,
                    "total": 100,
                    "status": f"Processing... {i}%"
                }
            )

    report_path = f"/reports/{user_id}_{report_type}_{self.request.id}.pdf"

    logger.info(f"Report generated: {report_path}")
    return report_path


@shared_task
def cleanup_old_data() -> dict[str, int]:
    """Cleanup old data (scheduled task).

    Returns:
        Cleanup statistics
    """
    logger.info("Starting cleanup job")

    # Cleanup logic
    deleted_count = 0
    # deleted_count = db.delete_old_records()

    logger.info(f"Cleanup complete: {deleted_count} records deleted")
    return {"deleted": deleted_count}


@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_kwargs={"max_retries": 5},
    retry_backoff=True,
    retry_jitter=True
)
def fetch_external_data(self, url: str) -> dict[str, Any]:
    """Fetch data from external API with retry.

    Args:
        url: External API URL

    Returns:
        Fetched data
    """
    import requests

    logger.info(f"Fetching data from {url}")

    response = requests.get(url, timeout=30)
    response.raise_for_status()

    data = response.json()

    logger.info(f"Data fetched successfully from {url}")
    return data
```

### 5. Trigger Tasks from API

**Integrate with FastAPI** (`backend/api/jobs.py`):
```python
"""Background job API endpoints."""

from fastapi import APIRouter, BackgroundTasks
from pydantic import BaseModel
from backend.tasks import send_email, process_data, generate_report
from celery.result import AsyncResult
from backend.celery_app import celery_app

router = APIRouter(prefix="/api/jobs", tags=["jobs"])


class EmailRequest(BaseModel):
    """Email request model."""
    to: str
    subject: str
    body: str


class TaskResponse(BaseModel):
    """Task response model."""
    task_id: str
    status: str


@router.post("/send-email", response_model=TaskResponse)
def create_email_task(request: EmailRequest) -> TaskResponse:
    """Queue email sending task.

    Args:
        request: Email request data

    Returns:
        Task ID for tracking
    """
    # Queue the task
    task = send_email.delay(
        to=request.to,
        subject=request.subject,
        body=request.body
    )

    return TaskResponse(
        task_id=task.id,
        status="queued"
    )


@router.post("/process-data/{data_id}", response_model=TaskResponse)
def create_processing_task(data_id: int) -> TaskResponse:
    """Queue data processing task.

    Args:
        data_id: ID of data to process

    Returns:
        Task ID for tracking
    """
    task = process_data.delay(data_id)

    return TaskResponse(
        task_id=task.id,
        status="queued"
    )


@router.get("/tasks/{task_id}")
def get_task_status(task_id: str) -> dict:
    """Get task status and result.

    Args:
        task_id: Celery task ID

    Returns:
        Task status and result
    """
    task_result = AsyncResult(task_id, app=celery_app)

    response = {
        "task_id": task_id,
        "status": task_result.state,
    }

    if task_result.state == "PROGRESS":
        response["progress"] = task_result.info
    elif task_result.state == "SUCCESS":
        response["result"] = task_result.result
    elif task_result.state == "FAILURE":
        response["error"] = str(task_result.info)

    return response


@router.post("/cancel/{task_id}")
def cancel_task(task_id: str) -> dict:
    """Cancel a running task.

    Args:
        task_id: Task ID to cancel

    Returns:
        Cancellation status
    """
    celery_app.control.revoke(task_id, terminate=True)

    return {
        "task_id": task_id,
        "status": "cancelled"
    }
```

### 6. Start Celery Workers

**In Docker**:
```bash
# Start all services (including workers)
make dev-python

# Check worker logs
docker logs celery_worker -f

# Check beat scheduler logs
docker logs celery_beat -f

# View Flower monitoring dashboard
open http://localhost:5555
```

**Manual worker start** (if not using docker-compose):
```bash
# Start worker
docker exec -it python-backend-container celery -A backend.celery_app worker --loglevel=info

# Start beat scheduler
docker exec -it python-backend-container celery -A backend.celery_app beat --loglevel=info

# Start flower
docker exec -it python-backend-container celery -A backend.celery_app flower
```

### 7. Monitor Tasks

**Using Flower**:
```bash
# Access Flower dashboard
open http://localhost:5555

# View:
# - Active tasks
# - Task history
# - Worker status
# - Task statistics
```

**Using Celery CLI**:
```bash
# Inspect active tasks
docker exec -it celery_worker celery -A backend.celery_app inspect active

# Inspect scheduled tasks
docker exec -it celery_worker celery -A backend.celery_app inspect scheduled

# Inspect registered tasks
docker exec -it celery_worker celery -A backend.celery_app inspect registered

# Get worker stats
docker exec -it celery_worker celery -A backend.celery_app inspect stats
```

## Steps to Add Background Job (RQ)

### 1. Install RQ Dependencies

**Add to `pyproject.toml`**:
```toml
[tool.poetry.dependencies]
rq = "^1.15.0"
redis = "^5.0.0"

[tool.poetry.group.dev.dependencies]
rq-dashboard = "^0.6.0"
```

### 2. Create RQ Configuration

**Create RQ setup** (`backend/rq_config.py`):
```python
"""RQ (Redis Queue) configuration."""

from redis import Redis
import os

# Redis connection
redis_conn = Redis(
    host=os.getenv("REDIS_HOST", "redis"),
    port=int(os.getenv("REDIS_PORT", "6379")),
    db=int(os.getenv("REDIS_DB", "0")),
    decode_responses=True
)
```

### 3. Create RQ Tasks

**Create tasks** (`backend/rq_tasks.py`):
```python
"""RQ background tasks."""

import time
from typing import Any


def send_email_rq(to: str, subject: str, body: str) -> dict[str, Any]:
    """Send email via RQ.

    Args:
        to: Recipient
        subject: Subject
        body: Body

    Returns:
        Result dictionary
    """
    print(f"Sending email to {to}")
    time.sleep(2)
    print(f"Email sent to {to}")

    return {
        "status": "success",
        "recipient": to
    }


def process_data_rq(data_id: int) -> dict[str, Any]:
    """Process data via RQ.

    Args:
        data_id: Data ID

    Returns:
        Processing result
    """
    print(f"Processing data {data_id}")
    time.sleep(5)
    print(f"Data {data_id} processed")

    return {
        "processed": True,
        "data_id": data_id
    }
```

### 4. Queue Tasks with RQ

**In FastAPI** (`backend/api/rq_jobs.py`):
```python
"""RQ job endpoints."""

from fastapi import APIRouter
from rq import Queue
from rq.job import Job
from backend.rq_config import redis_conn
from backend.rq_tasks import send_email_rq, process_data_rq

router = APIRouter(prefix="/api/rq-jobs", tags=["rq-jobs"])

# Create queue
queue = Queue(connection=redis_conn)


@router.post("/send-email")
def queue_email(to: str, subject: str, body: str) -> dict:
    """Queue email with RQ.

    Args:
        to: Recipient
        subject: Subject
        body: Body

    Returns:
        Job ID
    """
    job = queue.enqueue(
        send_email_rq,
        to,
        subject,
        body,
        job_timeout="5m"
    )

    return {
        "job_id": job.id,
        "status": "queued"
    }


@router.get("/jobs/{job_id}")
def get_job_status(job_id: str) -> dict:
    """Get RQ job status.

    Args:
        job_id: Job ID

    Returns:
        Job status and result
    """
    job = Job.fetch(job_id, connection=redis_conn)

    return {
        "job_id": job.id,
        "status": job.get_status(),
        "result": job.result if job.is_finished else None,
        "error": str(job.exc_info) if job.is_failed else None
    }
```

### 5. Start RQ Worker

**In docker-compose.yml**:
```yaml
services:
  rq_worker:
    build: .
    command: rq worker --url redis://redis:6379/0
    environment:
      REDIS_HOST: redis
      REDIS_PORT: 6379
    depends_on:
      - redis
    volumes:
      - .:/app

  rq_dashboard:
    build: .
    command: rq-dashboard --redis-url redis://redis:6379/0
    ports:
      - "9181:9181"
    environment:
      REDIS_HOST: redis
    depends_on:
      - redis
```

## Templates Reference

This guide references the following templates:

- `plugins/languages/python/templates/celery-task.py.template` - Celery task patterns
- `plugins/languages/python/templates/celery-config.py.template` - Celery configuration
- `plugins/languages/python/templates/rq-task.py.template` - RQ task patterns

## Verification Steps

### 1. Check Redis Connection

```bash
# Connect to Redis
docker exec -it redis redis-cli

# Test connection
127.0.0.1:6379> PING
PONG

# List keys
127.0.0.1:6379> KEYS *

# Monitor activity
127.0.0.1:6379> MONITOR
```

### 2. Test Task Execution

**Celery**:
```bash
# Queue a task
curl -X POST http://localhost:8000/api/jobs/send-email \
  -H "Content-Type: application/json" \
  -d '{"to": "test@example.com", "subject": "Test", "body": "Hello"}'

# Get task status
curl http://localhost:8000/api/jobs/tasks/{task_id}

# Watch worker logs
docker logs celery_worker -f
```

**RQ**:
```bash
# Queue a task
curl -X POST "http://localhost:8000/api/rq-jobs/send-email?to=test@example.com&subject=Test&body=Hello"

# Get job status
curl http://localhost:8000/api/rq-jobs/jobs/{job_id}

# View RQ dashboard
open http://localhost:9181
```

### 3. Monitor Performance

**Celery Flower**:
```bash
open http://localhost:5555
# Check:
# - Task throughput
# - Worker health
# - Task success/failure rates
# - Task execution time
```

### 4. Test Scheduled Tasks

**Celery Beat**:
```bash
# Check beat scheduler logs
docker logs celery_beat -f

# Verify scheduled tasks are registered
docker exec -it celery_beat celery -A backend.celery_app inspect scheduled
```

## Best Practices

### 1. Idempotent Tasks

Make tasks safe to retry:

```python
@shared_task
def process_order(order_id: int) -> None:
    """Process order idempotently."""
    order = get_order(order_id)

    # Check if already processed
    if order.status == "processed":
        logger.info(f"Order {order_id} already processed")
        return

    # Process order
    process(order)

    # Mark as processed
    order.status = "processed"
    order.save()
```

### 2. Proper Error Handling

```python
@shared_task(bind=True, max_retries=3)
def risky_task(self, data: dict) -> None:
    """Task with proper error handling."""
    try:
        # Risky operation
        result = process_data(data)
    except TemporaryError as exc:
        # Retry on temporary errors
        raise self.retry(exc=exc, countdown=60)
    except PermanentError as exc:
        # Log and fail on permanent errors
        logger.error(f"Permanent error: {exc}")
        raise
    except Exception as exc:
        # Catch unexpected errors
        logger.exception(f"Unexpected error: {exc}")
        raise
```

### 3. Task Time Limits

```python
@shared_task(time_limit=300, soft_time_limit=270)
def long_running_task() -> None:
    """Task with time limits."""
    try:
        # Long operation
        process()
    except SoftTimeLimitExceeded:
        # Graceful cleanup
        cleanup()
        raise
```

### 4. Result Storage

```python
@shared_task(ignore_result=True)
def fire_and_forget_task() -> None:
    """Task that doesn't store result (saves memory)."""
    send_notification()


@shared_task(result_expires=3600)
def task_with_expiring_result() -> dict:
    """Result expires after 1 hour."""
    return process_data()
```

### 5. Task Prioritization

```python
# High priority task
send_urgent_email.apply_async(
    args=[to, subject, body],
    priority=9
)

# Low priority task
cleanup_logs.apply_async(
    priority=1
)
```

## Common Issues and Solutions

### Worker Not Processing Tasks

**Issue**: Tasks queued but not executing

**Solutions**:
```bash
# Check worker is running
docker ps | grep celery_worker

# Check worker logs
docker logs celery_worker

# Verify Redis connection
docker exec -it celery_worker python -c "from backend.celery_app import celery_app; print(celery_app.control.inspect().active())"

# Restart worker
docker restart celery_worker
```

### Tasks Failing Silently

**Issue**: Tasks fail without errors

**Solution**:
```python
# Add result backend
CELERY_RESULT_BACKEND = "redis://redis:6379/0"

# Enable task tracking
CELERY_TASK_TRACK_STARTED = True

# Check task result
result = task.delay()
try:
    result.get(timeout=10)
except Exception as exc:
    logger.error(f"Task failed: {exc}")
```

### Memory Leaks

**Issue**: Worker memory grows over time

**Solution**:
```python
# Restart worker after N tasks
CELERY_WORKER_MAX_TASKS_PER_CHILD = 1000

# Disable result storage for fire-and-forget tasks
@shared_task(ignore_result=True)
def task():
    pass
```

## Checklist

- [ ] Framework chosen (Celery or RQ)
- [ ] Dependencies added to pyproject.toml
- [ ] Redis service configured in docker-compose.yml
- [ ] Celery/RQ configuration created
- [ ] Background tasks implemented
- [ ] Tasks are idempotent
- [ ] Error handling implemented
- [ ] Time limits set
- [ ] Worker service configured
- [ ] Beat scheduler configured (if using scheduled tasks)
- [ ] Monitoring dashboard setup (Flower/RQ Dashboard)
- [ ] Tasks tested in Docker
- [ ] Worker logs verified
- [ ] Integration tests written

## Related Documentation

- [How to Create an API Endpoint](how-to-create-an-api-endpoint.md) - Trigger tasks from API
- [How to Write a Test](how-to-write-a-test.md) - Test background tasks
- [Celery Documentation](https://docs.celeryq.dev/)
- [RQ Documentation](https://python-rq.org/)

## Related Templates

- `plugins/languages/python/templates/celery-task.py.template`
- `plugins/languages/python/templates/celery-config.py.template`
- `plugins/languages/python/templates/rq-task.py.template`

---

**Difficulty**: Advanced
**Estimated Time**: 60-90 minutes
**Last Updated**: 2025-10-01
