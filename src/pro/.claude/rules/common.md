# Common Coding Rules

## Git Workflow
- Always work on feature branches, never directly on main
- Write meaningful commit messages following conventional commits
- Keep PRs focused — one feature/fix per PR

## Code Quality
- No hardcoded secrets, API keys, or credentials in source code
- No TODO/FIXME in committed production code (use issue tracker)
- Remove debug statements (console.log, print) before committing
- Keep functions under 50 lines — extract if longer
- Maximum file length: 500 lines (split if larger)

## Testing
- New features require tests
- Bug fixes require regression tests
- Aim for 80% coverage on critical paths

## Documentation
- Public APIs need docstrings/JSDoc
- Complex logic needs inline comments explaining WHY, not WHAT
- Update README when adding new features or changing setup

## Security
- Validate all user input at system boundaries
- Use parameterized queries (never string concatenation for SQL)
- Escape output in templates (prevent XSS)
- Use HTTPS for all external API calls
- Never log sensitive data (passwords, tokens, PII)

## Performance
- Avoid N+1 queries — use batch/eager loading
- Don't block the main thread with heavy computation
- Use pagination for list endpoints
- Cache expensive computations when appropriate
