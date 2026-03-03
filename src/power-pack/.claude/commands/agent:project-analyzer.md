# Agent: Project Analyzer
Comprehensive analysis of a project's state and next steps.

## Auto-Trigger
**When:** "analyze project", "what's the state of X", "project status"

## Agent Workflow

### Step 1: Project Discovery
```
AGENT TASK: Understand project structure
- Read all config files (package.json, tsconfig, etc.)
- Map directory structure
- Identify entry points
- List dependencies
```

### Step 2: Code Health Assessment
```
AGENT TASK: Evaluate code quality
- Count lines of code by language
- Calculate complexity metrics
- Check for TODO/FIXME comments
- Identify dead code
- Check test coverage percentage
```

### Step 3: Dependency Analysis
```
AGENT TASK: Review dependencies
- List outdated packages
- Identify security vulnerabilities
- Check for unused dependencies
- Note heavy dependencies (bundle size impact)
```

### Step 4: Documentation Status
```
AGENT TASK: Review documentation
- README completeness
- API documentation
- Inline comments quality
- Architecture diagrams exist?
```

### Step 5: Deployment Readiness
```
AGENT TASK: Check deployment state
- Environment configs present?
- CI/CD pipeline configured?
- Secrets management in place?
- Monitoring/logging setup?
```

### Step 6: Roadmap Extraction
```
AGENT TASK: Identify next steps
- Open issues/TODOs
- Incomplete features
- Technical debt items
- Performance improvements needed
```

## Output Format

### Project Health Report
```markdown
## Project: [Name]

### Quick Stats
| Metric | Value |
|--------|-------|
| Languages | TypeScript (80%), Python (20%) |
| Lines of Code | 12,450 |
| Test Coverage | 67% |
| Dependencies | 45 (3 outdated, 1 vulnerable) |
| Last Commit | 2 days ago |

### Health Score: 7.5/10 🟢

### Strengths
- Well-structured codebase
- Good test coverage
- CI/CD configured

### Concerns
- 3 outdated dependencies
- Missing API documentation
- No error tracking configured

### Recommended Next Steps
1. **HIGH:** Update vulnerable dependency (lodash)
2. **MEDIUM:** Add API documentation
3. **LOW:** Refactor utils/helpers.ts (complexity: 45)

### Technical Debt
- [ ] Migrate from callbacks to async/await in api/
- [ ] Add TypeScript strict mode
- [ ] Remove deprecated React lifecycle methods
```

## Quick Commands
```bash
# Analyze current project
/agent:project-analyzer

# Analyze specific project
/agent:project-analyzer ~/ClaudeCodeWorkspace/1.\ Projects/YOUR_PROJECT

# Quick health check only
/agent:project-analyzer --quick
```

## Integration with Your Projects
This agent can analyze any of your 20+ projects:
- YOUR_PROJECT
- 06-slack-jira-bot
- 20-email-converter-app
- etc.

---
Last updated: 2026-01-27
