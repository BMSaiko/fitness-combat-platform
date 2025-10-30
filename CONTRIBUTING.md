# Contributing Guide

We love your input! We want to make contributing to this project as easy and transparent as possible.

## Development Process

1. Fork the repo and create your branch from `main`
2. Make your changes
3. Add tests if applicable
4. Ensure the test suite passes
5. Make sure your code lints
6. Issue that pull request!

## Pull Request Process

1. Update the README.md with details of changes if applicable
2. Update the documentation if you changed APIs
3. The PR will be merged once you have the sign-off of at least one maintainer

## Code Style

### TypeScript/JavaScript
- Use TypeScript for all new code
- 2 space indentation
- Semicolons
- Single quotes for strings
- Use functional components with hooks

### Naming Conventions
- Components: PascalCase (`UserProfile`)
- Files: kebab-case (`user-profile.tsx`)
- Variables: camelCase (`userData`)
- Constants: UPPER_SNAKE_CASE (`API_BASE_URL`)

### Commit Messages
Follow conventional commits format:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance

## Setting Up Development Environment

[Same as README installation instructions]

## Testing

Run the test suite:
```bash
npm test
```

Write tests for new features:

- Unit tests with Jest
- Integration tests for APIs
- E2E tests for critical user flows


## Reporting Bugs

Use GitHub Issues and include:

Description of the bug

Steps to reproduce

Expected behavior

Actual behavior

Screenshots if applicable

Environment information

Feature Requests
We welcome feature requests! Please explain:

The problem you're trying to solve

Your proposed solution

Alternative solutions considered
