# Agent: Automated Code Review
Multi-step agent workflow for comprehensive code review.

## Auto-Trigger
**When:** "review this code", "check my PR", "code review", or before merge

## Agent Workflow

### Step 1: Gather Context
```
AGENT TASK: Understand the codebase
- Read README.md
- Check package.json / requirements.txt
- Identify language and framework
- Note existing patterns and conventions
```

### Step 2: Static Analysis
```
AGENT TASK: Run linters and formatters
- ESLint / Pylint / SwiftLint
- Prettier / Black
- Type checking (TypeScript, mypy)
- Report findings
```

### Step 3: Security Scan
```
AGENT TASK: Check for vulnerabilities
- Hardcoded secrets (grep for API keys, passwords)
- SQL injection patterns
- XSS vulnerabilities
- Dependency vulnerabilities (npm audit, pip-audit)
```

### Step 4: Logic Review
```
AGENT TASK: Review business logic
- Edge cases handled?
- Error handling complete?
- Null/undefined checks?
- Race conditions?
```

### Step 5: Performance Review
```
AGENT TASK: Check performance
- N+1 queries?
- Unnecessary re-renders (React)?
- Memory leaks (closures, event listeners)?
- Large bundle imports?
```

### Step 6: Test Coverage
```
AGENT TASK: Verify tests
- Are there tests?
- Do tests cover the changes?
- Are tests meaningful (not just coverage padding)?
- Run tests and report results
```

### Step 7: Documentation
```
AGENT TASK: Check documentation
- Functions documented?
- README updated if needed?
- API changes documented?
- Breaking changes noted?
```

## Output Format

### Summary
```markdown
## Code Review Summary

**Overall:** 🟢 APPROVE / 🟡 CHANGES REQUESTED / 🔴 REJECT

### Findings
| Severity | Count | Category |
|----------|-------|----------|
| 🔴 Critical | 0 | Security, Data Loss |
| 🟠 Major | 2 | Logic, Performance |
| 🟡 Minor | 5 | Style, Docs |
| 🔵 Info | 3 | Suggestions |

### Critical Issues
1. [File:Line] Description of issue

### Recommended Changes
1. [File:Line] Suggestion

### Positive Notes
- Well-structured error handling
- Good test coverage
```

## Quick Commands
```bash
# Run full review
/agent:code-review

# Review specific file
/agent:code-review src/main.ts

# Review PR
/agent:code-review --pr 123
```

---
Last updated: 2026-01-27
