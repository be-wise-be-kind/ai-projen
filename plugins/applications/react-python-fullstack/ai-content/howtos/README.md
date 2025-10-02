# Full-Stack Application How-To Guides

**Purpose**: Index of comprehensive how-to guides for React + Python full-stack application development

**Scope**: Practical, step-by-step guides for common full-stack development tasks

**Overview**: Collection of detailed how-to guides covering backend API development with FastAPI,
    frontend development with React and TypeScript, frontend-backend integration patterns, and
    production deployment to AWS. Each guide provides complete working examples with code snippets,
    testing instructions, and troubleshooting tips. Designed for developers at all skill levels to
    accomplish specific tasks efficiently.

**Dependencies**: Backend (Python, FastAPI), Frontend (React, TypeScript, Vite), Docker, AWS

**Exports**: Step-by-step guides for adding endpoints, pages, integrating layers, and deploying

**Related**: Full-Stack Architecture (../docs/fullstack-architecture.md), API-Frontend Integration (../docs/api-frontend-integration.md)

**Implementation**: Task-oriented documentation with code examples and validation steps

---

## Available Guides

### Backend Development

#### [How to Add an API Endpoint](how-to-add-api-endpoint.md)
**Difficulty**: Intermediate | **Time**: 30-45 minutes

Learn to create new FastAPI endpoints with:
- FastAPI router creation
- Pydantic request/response models
- Database operations with SQLAlchemy
- Business logic in service layer
- Comprehensive testing with pytest
- Automatic OpenAPI documentation

**When to use**: Adding new backend functionality, creating REST endpoints

---

### Frontend Development

#### [How to Add a Frontend Page](how-to-add-frontend-page.md)
**Difficulty**: Intermediate | **Time**: 30-45 minutes

Learn to add new React pages with:
- React component creation with TypeScript
- React Router configuration
- Component styling with CSS modules
- State management patterns
- Component testing with Vitest
- Navigation and links

**When to use**: Adding new UI pages, creating new routes

---

### Integration

#### [How to Connect Frontend to API](how-to-connect-frontend-to-api.md)
**Difficulty**: Intermediate | **Time**: 45-60 minutes

Learn to integrate frontend with backend:
- Type-safe API client usage
- Request/response handling
- Error handling and display
- Loading states and UX
- Authentication with JWT
- Form submission with validation
- Optimistic updates

**When to use**: Connecting new pages to backend, implementing API calls

---

### Deployment

#### [How to Deploy Full-Stack App](how-to-deploy-fullstack-app.md)
**Difficulty**: Advanced | **Time**: 60-90 minutes

Learn to deploy to production:
- AWS infrastructure setup with Terraform
- ECS container deployment
- RDS database configuration
- ALB load balancer setup
- GitHub Actions CI/CD pipeline
- Environment variable management
- Monitoring and logging
- Rollback procedures

**When to use**: Initial deployment, deploying updates, scaling infrastructure

---

## Quick Reference

### Common Tasks

| Task | Guide | Time |
|------|-------|------|
| Add a new API endpoint | [API Endpoint](how-to-add-api-endpoint.md) | 30-45 min |
| Add a new page | [Frontend Page](how-to-add-frontend-page.md) | 30-45 min |
| Connect page to API | [Frontend-API Integration](how-to-connect-frontend-to-api.md) | 45-60 min |
| Deploy to AWS | [Deployment](how-to-deploy-fullstack-app.md) | 60-90 min |

### By Skill Level

**Beginner-Friendly**:
- None yet - all current guides assume intermediate knowledge

**Intermediate**:
- How to Add an API Endpoint
- How to Add a Frontend Page
- How to Connect Frontend to API

**Advanced**:
- How to Deploy Full-Stack App

## Guide Format

Each guide follows a consistent structure:

1. **Overview**: What you'll accomplish
2. **Prerequisites**: Required knowledge and tools
3. **Step-by-Step Instructions**: Detailed walkthrough
4. **Code Examples**: Complete, working code
5. **Testing**: How to verify it works
6. **Troubleshooting**: Common issues and solutions
7. **Next Steps**: Related guides and enhancements

## Using These Guides

### For AI Agents

When asked to implement a feature, AI agents should:
1. Identify the relevant guide(s)
2. Follow the step-by-step instructions
3. Adapt code examples to the specific use case
4. Run validation steps to ensure success
5. Report completion with confirmation of tests passing

### For Human Developers

1. **Start with prerequisites**: Ensure your environment is set up
2. **Follow steps in order**: Don't skip validation steps
3. **Adapt to your needs**: Code examples are templates, not rigid rules
4. **Test as you go**: Run tests after each major step
5. **Ask for help**: If stuck, check troubleshooting sections

## Contributing

To add a new guide:
1. Follow the guide template structure
2. Include complete, working code examples
3. Add validation steps
4. Test all instructions end-to-end
5. Update this README with the new guide

## Related Documentation

- **Architecture**: [Full-Stack Architecture](../docs/fullstack-architecture.md)
- **Integration Patterns**: [API-Frontend Integration](../docs/api-frontend-integration.md)
- **Code Templates**: `../templates/` directory
- **Plugin Documentation**: `../../README.md`

---

**Start with a guide that matches your current task and build incrementally!**
