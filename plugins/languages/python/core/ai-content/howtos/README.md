# Python Plugin How-To Guides

Comprehensive step-by-step guides for common Python development tasks using Docker-first development patterns.

## Overview

These how-to guides provide practical, actionable instructions for implementing features in Python projects. All guides follow the Docker-first development pattern established in PR7.5, with fallback support for Poetry and direct execution.

**Key Features**:
- Docker-first approach with automatic environment detection
- Complete code examples with templates
- Verification steps for each task
- Common issues and solutions
- Best practices and security considerations

## API Development

### [How to Create an API Endpoint](how-to-create-an-api-endpoint.md)
**Create FastAPI REST endpoints with automatic documentation**

- **Difficulty**: Intermediate
- **Time**: 30-45 minutes
- **Prerequisites**: Python plugin, Docker, FastAPI basics
- **What You'll Learn**:
  - FastAPI router configuration
  - Pydantic request/response models
  - Endpoint documentation
  - Docker-first testing
  - WebSocket endpoint patterns

**Use this when**: Adding new REST API endpoints to your backend service

---

### [How to Add Database Model](how-to-add-database-model.md)
**Create SQLAlchemy models with Alembic migrations**

- **Difficulty**: Advanced
- **Time**: 60-90 minutes
- **Prerequisites**: Python plugin, Docker, database basics, SQLAlchemy knowledge
- **What You'll Learn**:
  - SQLAlchemy ORM models
  - Pydantic schemas for validation
  - Alembic migration generation
  - CRUD operations
  - Database testing in Docker

**Use this when**: Adding database persistence to your application

---

### [How to Handle Authentication](how-to-handle-authentication.md)
**Implement OAuth2/JWT authentication with secure password handling**

- **Difficulty**: Advanced
- **Time**: 90-120 minutes
- **Prerequisites**: Python plugin, Docker, security concepts, user database model
- **What You'll Learn**:
  - OAuth2 password flow
  - JWT token generation/validation
  - Password hashing with bcrypt
  - Protected endpoints
  - Refresh token patterns
  - Security best practices

**Use this when**: Adding user authentication and authorization to your API

## CLI Development

### [How to Create a CLI Command](how-to-create-a-cli-command.md)
**Build command-line tools with Click or Typer**

- **Difficulty**: Intermediate
- **Time**: 45-60 minutes
- **Prerequisites**: Python plugin, Docker, CLI design basics
- **What You'll Learn**:
  - Click vs Typer framework selection
  - Command structure and arguments
  - Options and flags handling
  - Rich output formatting
  - Docker-based CLI execution

**Use this when**: Creating command-line tools or admin scripts

## Testing

### [How to Write a Test](how-to-write-a-test.md)
**Create comprehensive tests with pytest and coverage**

- **Difficulty**: Intermediate
- **Time**: 45-60 minutes
- **Prerequisites**: Python plugin, Docker, testing concepts
- **What You'll Learn**:
  - pytest test structure
  - Fixtures and parametrization
  - Async testing
  - Mocking strategies
  - Coverage reporting
  - Docker test execution

**Use this when**: Writing tests for any Python code

## Background Jobs

### [How to Add Background Job](how-to-add-background-job.md)
**Implement async tasks with Celery or RQ**

- **Difficulty**: Advanced
- **Time**: 60-90 minutes
- **Prerequisites**: Python plugin, Docker, Redis, async concepts
- **What You'll Learn**:
  - Celery vs RQ framework selection
  - Task definition and execution
  - Redis configuration in Docker
  - Task scheduling
  - Monitoring with Flower
  - Error handling and retries

**Use this when**: Implementing long-running or scheduled background tasks

## Quick Reference

### By Use Case

**Building an API?**
1. [Create an API Endpoint](how-to-create-an-api-endpoint.md)
2. [Add Database Model](how-to-add-database-model.md)
3. [Handle Authentication](how-to-handle-authentication.md)
4. [Write a Test](how-to-write-a-test.md)

**Building a CLI Tool?**
1. [Create a CLI Command](how-to-create-a-cli-command.md)
2. [Write a Test](how-to-write-a-test.md)

**Adding Background Processing?**
1. [Add Database Model](how-to-add-database-model.md) (for job state)
2. [Add Background Job](how-to-add-background-job.md)
3. [Write a Test](how-to-write-a-test.md)

### By Difficulty

**Intermediate** (Start here):
- [Create an API Endpoint](how-to-create-an-api-endpoint.md)
- [Create a CLI Command](how-to-create-a-cli-command.md)
- [Write a Test](how-to-write-a-test.md)

**Advanced** (Requires intermediate knowledge):
- [Add Database Model](how-to-add-database-model.md)
- [Add Background Job](how-to-add-background-job.md)
- [Handle Authentication](how-to-handle-authentication.md)

### By Time Commitment

**Quick (30-45 minutes)**:
- [Create an API Endpoint](how-to-create-an-api-endpoint.md)
- [Create a CLI Command](how-to-create-a-cli-command.md)
- [Write a Test](how-to-write-a-test.md)

**Medium (60-90 minutes)**:
- [Add Database Model](how-to-add-database-model.md)
- [Add Background Job](how-to-add-background-job.md)

**Long (90-120 minutes)**:
- [Handle Authentication](how-to-handle-authentication.md)

## Docker-First Philosophy

All how-to guides follow the Docker-first development pattern:

### Environment Priority
1. **Docker containers** (recommended) - Consistent across all machines
2. **Poetry virtual environment** (fallback) - When Docker unavailable
3. **Direct local execution** (last resort) - For special cases

### Common Docker Commands

```bash
# Start development environment
make dev-python

# Run tests
make test-python

# Run linting
make lint-python

# Execute command in container
docker exec -it python-backend-container <command>

# View logs
docker logs python-backend-container -f

# Stop environment
make dev-stop-python
```

See `.ai/docs/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` for complete details.

## Template Integration

Each how-to guide references code templates available in `plugins/languages/python/templates/`:

- `fastapi-router.py.template` - FastAPI router module
- `fastapi-endpoint.py.template` - Individual endpoint pattern
- `sqlalchemy-model.py.template` - Database model
- `pydantic-schema.py.template` - Pydantic schemas
- `pytest-test.py.template` - Test file structure
- `pytest-conftest.py.template` - Pytest fixtures
- `click-command.py.template` - Click CLI command
- `typer-command.py.template` - Typer CLI command
- `celery-task.py.template` - Celery background task
- `fastapi-auth.py.template` - Authentication endpoints
- `jwt-handler.py.template` - JWT utilities

**Using templates**:
```bash
# Copy template
cp plugins/languages/python/templates/fastapi-router.py.template backend/app/your_module.py

# Edit placeholders ({{VARIABLE_NAME}})
# Follow template comments for customization
```

## Best Practices Across All Guides

### Code Quality
- ✓ Use type hints for all functions
- ✓ Write comprehensive docstrings
- ✓ Follow PEP 8 style guide
- ✓ Keep functions focused (single responsibility)
- ✓ Use meaningful variable names

### Security
- ✓ Never log passwords or tokens
- ✓ Use environment variables for secrets
- ✓ Validate all input
- ✓ Use parameterized queries
- ✓ Hash passwords with bcrypt

### Testing
- ✓ Write tests for all features
- ✓ Aim for 80%+ code coverage
- ✓ Use AAA pattern (Arrange-Act-Assert)
- ✓ Test edge cases and errors
- ✓ Run tests in Docker

### Docker Development
- ✓ Test in containers first
- ✓ Use docker-compose for services
- ✓ Map volumes for live code reload
- ✓ Check logs for debugging
- ✓ Use health checks for dependencies

## Getting Help

### Common Issues
Each how-to guide includes a "Common Issues and Solutions" section with troubleshooting steps.

### Related Documentation
- [Python Plugin README](../README.md) - Plugin overview
- [Python Standards](../standards/python-standards.md) - Coding standards
- [Agent Instructions](../AGENT_INSTRUCTIONS.md) - Setup guide for AI agents
- [Development Philosophy](.ai/docs/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md) - Docker-first approach

### External Resources
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [pytest Documentation](https://docs.pytest.org/)
- [Celery Documentation](https://docs.celeryq.dev/)
- [Click Documentation](https://click.palletsprojects.com/)
- [Typer Documentation](https://typer.tiangolo.com/)

## Contributing

To add a new how-to guide:

1. Follow the structure of existing guides
2. Include all sections: Purpose, Scope, Overview, Prerequisites, Steps, Verification, Best Practices, Common Issues, Checklist
3. Emphasize Docker-first approach
4. Provide complete code examples
5. Create corresponding templates if needed
6. Test all commands in Docker
7. Update this README with the new guide

## Checklist for New Projects

When starting a new Python project with this plugin:

- [ ] Install Python plugin
- [ ] Configure Docker Compose
- [ ] Set up database (if needed)
- [ ] Implement authentication (if needed)
- [ ] Create API endpoints
- [ ] Add background jobs (if needed)
- [ ] Write comprehensive tests
- [ ] Set up CI/CD
- [ ] Review all how-to guides relevant to your project

---

**Last Updated**: 2025-10-01
**Plugin Version**: 1.0.0
**Maintained By**: ai-projen framework
