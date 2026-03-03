# Skill: Verify
Comprehensive verification before proceeding.

## Auto-Trigger
**When:** "verify", "check", "confirm", "validate", "make sure"

## Gate Type: BLOCKING
This skill triggers a blocking verification gate.

## Verification Checklist

### Code Quality
```
□ Linting passes: npm run lint
□ Type check passes: npm run typecheck
□ Tests pass: npm test
□ No console.log in production code
□ No TODO/FIXME in committed code
□ No hardcoded secrets
```

### Git Status
```
□ On correct branch
□ Working directory clean
□ No untracked files that should be tracked
□ Commit messages follow convention
□ No merge conflicts
```

### Dependencies
```
□ No vulnerable dependencies: npm audit
□ No outdated critical deps
□ Lockfile up to date
□ No unused dependencies
```

### Environment
```
□ .env.example updated if new vars added
□ All required env vars documented
□ No secrets in .env committed
```

### Documentation
```
□ README updated if needed
□ API docs updated if endpoints changed
□ CHANGELOG updated
□ Version bumped if releasing
```

## Quick Verify Command
```bash
#!/bin/bash
echo "🔍 Running verification..."

# Lint
npm run lint || exit 1
echo "✅ Lint passed"

# Types
npm run typecheck || exit 1
echo "✅ Types passed"

# Tests
npm test || exit 1
echo "✅ Tests passed"

# Security
npm audit --audit-level=high || exit 1
echo "✅ Security check passed"

echo "🎉 All verifications passed!"
```

## Output Format
```markdown
## Verification Report

**Status:** ✅ PASSED / ❌ FAILED
**Date:** 2026-01-27

### Checks
| Check | Status | Notes |
|-------|--------|-------|
| Lint | ✅ | No issues |
| Types | ✅ | Clean |
| Tests | ✅ | 45/45 pass |
| Security | ⚠️ | 2 low severity |

### Blockers
- [list any blocking issues]

### Warnings
- [list any non-blocking warnings]
```

---
Last updated: 2026-01-27
