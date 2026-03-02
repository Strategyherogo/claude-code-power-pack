# Skill: test-suite
Comprehensive testing: design, prepare, and run all tests to ensure app quality.

## Auto-Trigger
**When:** "test everything", "full test", "test suite", "qa", "quality assurance", "make sure it works", "test my app"

---

## Master Test Checklist

```
┌─────────────────────────────────────────────────────────────┐
│                    FULL TEST SUITE                          │
├─────────────────────────────────────────────────────────────┤
│ □ 1. Unit Tests          - Individual functions/components  │
│ □ 2. Integration Tests   - Components working together      │
│ □ 3. E2E Tests           - Full user flows                  │
│ □ 4. API Tests           - Endpoints & contracts            │
│ □ 5. Performance Tests   - Speed & load handling            │
│ □ 6. Security Tests      - Vulnerabilities & auth           │
│ □ 7. Accessibility Tests - A11y compliance                  │
│ □ 8. Visual Tests        - UI regression                    │
│ □ 9. Smoke Tests         - Critical path quick check        │
│ □ 10. Edge Case Tests    - Boundary conditions              │
└─────────────────────────────────────────────────────────────┘
```

> **Detailed templates for each test type:** See `test-suite:templates.md`

---

## RUN ALL TESTS

### Full Test Suite Command
```bash
#!/bin/bash
# run-all-tests.sh

echo "🧪 Running Full Test Suite..."
echo ""

FAILED=0

run_test() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📋 $1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if eval "$2"; then
    echo "✅ $1 PASSED"
  else
    echo "❌ $1 FAILED"
    FAILED=$((FAILED + 1))
  fi
  echo ""
}

run_test "Unit Tests" "npm run test:unit"
run_test "Integration Tests" "npm run test:integration"
run_test "API Tests" "npm run test:api"
run_test "E2E Tests" "npm run test:e2e"
run_test "Security Scan" "npm audit --audit-level=high"
run_test "Secret Scan" "gitleaks detect --source . -v"
run_test "Lint" "npm run lint"
run_test "Type Check" "npm run typecheck"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAILED -eq 0 ]; then
  echo "✅ ALL TESTS PASSED"
  exit 0
else
  echo "❌ $FAILED TEST SUITE(S) FAILED"
  exit 1
fi
```

---

## TEST REPORT TEMPLATE

```markdown
# Test Report: [App Name]
**Date:** [YYYY-MM-DD]
**Version:** [version]
**Environment:** [staging/production]

## Summary
| Suite | Passed | Failed | Skipped | Coverage |
|-------|--------|--------|---------|----------|
| Unit | XX | X | X | XX% |
| Integration | XX | X | X | - |
| E2E | XX | X | X | - |
| API | XX | X | X | - |
| Security | ✅/❌ | - | - | - |

## Coverage
- Lines: XX%
- Branches: XX%
- Functions: XX%

## Failed Tests
| Test | Error | Priority |
|------|-------|----------|
| [test name] | [error message] | P1/P2/P3 |

## Performance
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| API p95 | XXms | <200ms | ✅/❌ |
| Load capacity | XX users | 100 | ✅/❌ |

## Security
- [ ] Dependency audit: X vulnerabilities
- [ ] Secret scan: Clean
- [ ] OWASP top 10: Checked

## Recommendations
1. [High priority fix]
2. [Medium priority improvement]
3. [Low priority enhancement]
```

---

## Quick Commands
```
/test-suite full          # Run everything
/test-suite unit          # Unit tests only
/test-suite e2e           # E2E tests only
/test-suite security      # Security tests only
/test-suite smoke         # Quick smoke test
/test-suite report        # Generate report
```

---
Last updated: 2026-02-17
