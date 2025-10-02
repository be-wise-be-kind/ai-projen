# Docker Infrastructure How-To Guides

Step-by-step guides for common Docker infrastructure tasks.

## Available Guides

### [How to Add a Service](how-to-add-a-service.md)
**Add a new service (database, cache, queue) to docker-compose**

- **Difficulty**: Intermediate
- **Time**: 15-20 minutes
- **What You'll Learn**:
  - Adding services to docker-compose.yml
  - Configuring environment variables
  - Setting up health checks
  - Volume configuration for data persistence
  - Service networking and dependencies
  - Examples: PostgreSQL, Redis, RabbitMQ, Elasticsearch

**Use this when**: Adding databases, caches, or other infrastructure services to your Docker setup

---

### [How to Create Multi-Stage Dockerfile](how-to-create-multi-stage-dockerfile.md)
**Build optimized Docker images with separate dev, test, and production stages**

- **Difficulty**: Intermediate
- **Time**: 30-45 minutes
- **What You'll Learn**:
  - Multi-stage build patterns
  - Base stage with shared dependencies
  - Development stage with hot reload
  - Test stage for CI/CD
  - Minimal production stage
  - Layer caching optimization
  - Image size reduction (50-70%)

**Use this when**: Creating new Dockerfiles or optimizing existing ones for better performance

---

### [How to Add a Volume](how-to-add-volume.md)
**Configure persistent data storage and hot reload development**

- **Difficulty**: Beginner
- **Time**: 10-15 minutes
- **What You'll Learn**:
  - Named volumes for data persistence
  - Bind mounts for hot reload
  - Volume exclusion patterns
  - Permission management
  - Backup and restore
  - Volume troubleshooting

**Use this when**: Configuring data persistence or development hot reload

---

## Quick Reference

### By Use Case

**Setting up a new project?**
1. [Create Multi-Stage Dockerfile](how-to-create-multi-stage-dockerfile.md)
2. [Add a Volume](how-to-add-volume.md) (for hot reload)
3. [Add a Service](how-to-add-a-service.md) (if you need database/cache)

**Adding infrastructure?**
1. [Add a Service](how-to-add-a-service.md) (PostgreSQL, Redis, etc.)
2. [Add a Volume](how-to-add-volume.md) (for data persistence)

**Optimizing builds?**
1. [Create Multi-Stage Dockerfile](how-to-create-multi-stage-dockerfile.md)

### By Difficulty

**Beginner** (Start here):
- [How to Add a Volume](how-to-add-volume.md)

**Intermediate**:
- [How to Add a Service](how-to-add-a-service.md)
- [How to Create Multi-Stage Dockerfile](how-to-create-multi-stage-dockerfile.md)

### By Time Commitment

**Quick (10-15 minutes)**:
- [How to Add a Volume](how-to-add-volume.md)

**Medium (15-30 minutes)**:
- [How to Add a Service](how-to-add-a-service.md)

**Longer (30-45 minutes)**:
- [How to Create Multi-Stage Dockerfile](how-to-create-multi-stage-dockerfile.md)

## Common Patterns

All guides follow best practices:
- Multi-stage builds for optimization
- Non-root users for security
- Health checks for reliability
- Environment variables for configuration
- Named volumes for data persistence
- Bind mounts for hot reload

## Related Documentation

- [Docker Plugin README](../README.md) - Plugin overview
- [Docker Standards](../standards/docker-standards.md) - Best practices
- [Agent Instructions](../AGENT_INSTRUCTIONS.md) - Installation guide
- [Official Docker Documentation](https://docs.docker.com/)

## Contributing

To add a new how-to guide:

1. Follow the structure of existing guides
2. Include: Purpose, Scope, Prerequisites, Steps, Verification, Common Issues
3. Provide complete code examples
4. Test all commands in Docker
5. Update this README with the new guide

---

**Last Updated**: 2025-10-01
**Plugin Version**: 1.0.0
**Maintained By**: ai-projen framework
