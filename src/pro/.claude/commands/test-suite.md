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

---

## 1. UNIT TESTS

### What to Test
- Pure functions
- Business logic
- Data transformations
- Utility functions
- Individual components (isolated)

### Commands
```bash
# JavaScript/TypeScript
npm test
npm run test:unit
jest --coverage

# Python
pytest tests/unit/
pytest --cov=app tests/

# Swift
xcodebuild test -scheme MyApp -destination 'platform=iOS Simulator'
swift test
```

### Unit Test Template
```javascript
// JavaScript/Jest
describe('functionName', () => {
  it('should handle normal input', () => {
    expect(functionName('input')).toBe('expected');
  });

  it('should handle edge case', () => {
    expect(functionName('')).toBe('default');
  });

  it('should throw on invalid input', () => {
    expect(() => functionName(null)).toThrow();
  });
});
```

```python
# Python/pytest
def test_function_normal_input():
    assert function_name('input') == 'expected'

def test_function_edge_case():
    assert function_name('') == 'default'

def test_function_invalid_input():
    with pytest.raises(ValueError):
        function_name(None)
```

### Coverage Targets
| Type | Minimum | Good | Excellent |
|------|---------|------|-----------|
| Line coverage | 60% | 80% | 90%+ |
| Branch coverage | 50% | 70% | 85%+ |
| Function coverage | 70% | 85% | 95%+ |

---

## 2. INTEGRATION TESTS

### What to Test
- Database operations
- API integrations
- Service interactions
- Message queues
- Cache operations

### Commands
```bash
# With test database
DATABASE_URL=postgres://localhost/test npm run test:integration

# Docker-based
docker-compose -f docker-compose.test.yml up -d
npm run test:integration
docker-compose -f docker-compose.test.yml down
```

### Integration Test Template
```javascript
describe('User Service', () => {
  beforeAll(async () => {
    await db.connect();
    await db.migrate();
  });

  afterAll(async () => {
    await db.disconnect();
  });

  it('should create user and send welcome email', async () => {
    const user = await userService.create({ email: 'test@example.com' });

    expect(user.id).toBeDefined();
    expect(emailService.sent).toContainEqual({
      to: 'test@example.com',
      template: 'welcome'
    });
  });
});
```

---

## 3. END-TO-END (E2E) TESTS

### What to Test
- Complete user journeys
- Critical business flows
- Cross-browser compatibility
- Mobile responsiveness

### Tools
| Tool | Best For |
|------|----------|
| Playwright | Cross-browser, fast |
| Cypress | Developer experience |
| Selenium | Legacy support |
| Detox | React Native |
| XCUITest | iOS native |

### Commands
```bash
# Playwright
npx playwright test
npx playwright test --ui  # Interactive mode

# Cypress
npx cypress run
npx cypress open  # Interactive mode
```

### E2E Test Template (Playwright)
```javascript
import { test, expect } from '@playwright/test';

test.describe('User Authentication', () => {
  test('should complete login flow', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[data-testid="email"]', 'user@example.com');
    await page.fill('[data-testid="password"]', 'password123');
    await page.click('[data-testid="submit"]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="welcome"]')).toContainText('Welcome');
  });

  test('should show error on invalid credentials', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[data-testid="email"]', 'wrong@example.com');
    await page.fill('[data-testid="password"]', 'wrong');
    await page.click('[data-testid="submit"]');

    await expect(page.locator('[data-testid="error"]')).toBeVisible();
  });
});
```

### Critical Flows to Test
```
□ Sign up / Registration
□ Login / Logout
□ Password reset
□ Main feature usage
□ Payment flow (if applicable)
□ Settings update
□ Data export
□ Account deletion
```

---

## 4. API TESTS

### What to Test
- All endpoints respond correctly
- Request/response contracts
- Authentication & authorization
- Error handling
- Rate limiting

### Commands
```bash
# Using REST client
npm run test:api

# Using curl scripts
./scripts/test-api.sh

# Using Postman/Newman
newman run collection.json -e environment.json
```

### API Test Template
```javascript
describe('API: /users', () => {
  describe('GET /users', () => {
    it('returns 200 with list of users', async () => {
      const res = await request(app).get('/users');
      expect(res.status).toBe(200);
      expect(res.body).toHaveProperty('users');
      expect(Array.isArray(res.body.users)).toBe(true);
    });

    it('returns 401 without auth token', async () => {
      const res = await request(app).get('/users').unset('Authorization');
      expect(res.status).toBe(401);
    });
  });

  describe('POST /users', () => {
    it('creates user with valid data', async () => {
      const res = await request(app)
        .post('/users')
        .send({ email: 'new@example.com', name: 'Test' });
      expect(res.status).toBe(201);
      expect(res.body.user.email).toBe('new@example.com');
    });

    it('returns 400 with invalid email', async () => {
      const res = await request(app)
        .post('/users')
        .send({ email: 'invalid', name: 'Test' });
      expect(res.status).toBe(400);
    });
  });
});
```

### API Test Checklist
```
For each endpoint:
□ Happy path (200/201)
□ Validation errors (400)
□ Authentication required (401)
□ Authorization check (403)
□ Not found (404)
□ Server error handling (500)
□ Rate limiting (429)
```

---

## 5. PERFORMANCE TESTS

### What to Test
- Response times
- Concurrent users
- Database query performance
- Memory usage
- CPU usage

### Commands
```bash
# Load testing with k6
k6 run load-test.js

# Load testing with wrk
wrk -t12 -c400 -d30s http://localhost:3000/api/users

# Lighthouse
lighthouse http://localhost:3000 --output json
```

### Performance Test Template (k6)
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 50 },   // Ramp up
    { duration: '3m', target: 50 },   // Stay at 50 users
    { duration: '1m', target: 100 },  // Spike to 100
    { duration: '2m', target: 100 },  // Stay at 100
    { duration: '1m', target: 0 },    // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% under 500ms
    http_req_failed: ['rate<0.01'],    // <1% errors
  },
};

export default function () {
  const res = http.get('http://localhost:3000/api/users');

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });

  sleep(1);
}
```

### Performance Targets
| Metric | Target |
|--------|--------|
| Page load (LCP) | < 2.5s |
| Time to interactive | < 3s |
| API response (p95) | < 200ms |
| API response (p99) | < 500ms |
| Error rate | < 0.1% |
| Concurrent users | 100+ |

---

## 6. SECURITY TESTS

### What to Test
- Authentication bypass
- SQL injection
- XSS vulnerabilities
- CSRF protection
- Secrets exposure
- Dependency vulnerabilities

### Commands
```bash
# Dependency audit
npm audit
pip-audit
snyk test

# Secret scanning
gitleaks detect --source .

# OWASP ZAP (automated scan)
docker run -t owasp/zap2docker-stable zap-baseline.py -t http://localhost:3000

# SQLMap (SQL injection)
sqlmap -u "http://localhost:3000/api/users?id=1" --batch
```

### Security Test Checklist
```
Authentication:
□ Password hashing (bcrypt/argon2)
□ Brute force protection
□ Session management
□ JWT expiration & refresh

Authorization:
□ Role-based access control
□ Resource ownership checks
□ Admin routes protected

Input Validation:
□ SQL injection prevention
□ XSS prevention
□ Command injection prevention
□ File upload validation

Data Protection:
□ HTTPS only
□ Sensitive data encrypted
□ PII handling compliant
□ Secrets not in code

Dependencies:
□ No critical vulnerabilities
□ Dependencies up to date
□ Lock files committed
```

### Security Test Template
```javascript
describe('Security', () => {
  describe('SQL Injection', () => {
    it('should escape user input', async () => {
      const malicious = "'; DROP TABLE users; --";
      const res = await request(app).get(`/users?search=${malicious}`);
      expect(res.status).not.toBe(500);
      // Verify table still exists
      const users = await db.query('SELECT * FROM users LIMIT 1');
      expect(users).toBeDefined();
    });
  });

  describe('XSS', () => {
    it('should escape HTML in output', async () => {
      const xss = '<script>alert("xss")</script>';
      await request(app).post('/users').send({ name: xss });
      const res = await request(app).get('/users/1');
      expect(res.body.name).not.toContain('<script>');
    });
  });

  describe('Authentication', () => {
    it('should rate limit login attempts', async () => {
      for (let i = 0; i < 10; i++) {
        await request(app).post('/login').send({ email: 'test@test.com', password: 'wrong' });
      }
      const res = await request(app).post('/login').send({ email: 'test@test.com', password: 'wrong' });
      expect(res.status).toBe(429);
    });
  });
});
```

---

## 7. ACCESSIBILITY TESTS

### What to Test
- Screen reader compatibility
- Keyboard navigation
- Color contrast
- Focus management
- ARIA labels

### Commands
```bash
# Axe-core (automated)
npx @axe-core/cli http://localhost:3000

# Pa11y
npx pa11y http://localhost:3000

# Lighthouse accessibility
lighthouse http://localhost:3000 --only-categories=accessibility
```

### Accessibility Checklist
```
□ All images have alt text
□ Form inputs have labels
□ Color contrast ratio ≥ 4.5:1
□ Keyboard navigation works
□ Focus indicators visible
□ Skip navigation link
□ Heading hierarchy correct
□ ARIA landmarks present
□ Error messages announced
□ No keyboard traps
```

---

## 8. VISUAL/UI TESTS

### What to Test
- Component appearance
- Layout consistency
- Responsive breakpoints
- Theme variations

### Tools
| Tool | Type |
|------|------|
| Percy | Visual regression |
| Chromatic | Storybook visual |
| BackstopJS | Screenshot diff |
| Playwright | Screenshot comparison |

### Commands
```bash
# Percy with Playwright
npx percy exec -- playwright test

# BackstopJS
backstop test

# Playwright screenshots
npx playwright test --update-snapshots
```

### Visual Test Template
```javascript
test('homepage visual regression', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveScreenshot('homepage.png', {
    maxDiffPixels: 100,
  });
});

test('responsive layouts', async ({ page }) => {
  const viewports = [
    { width: 375, height: 667, name: 'mobile' },
    { width: 768, height: 1024, name: 'tablet' },
    { width: 1440, height: 900, name: 'desktop' },
  ];

  for (const vp of viewports) {
    await page.setViewportSize({ width: vp.width, height: vp.height });
    await page.goto('/');
    await expect(page).toHaveScreenshot(`homepage-${vp.name}.png`);
  }
});
```

---

## 9. SMOKE TESTS

### What to Test
- App starts successfully
- Critical features work
- External services connected
- Database accessible

### Smoke Test Script
```bash
#!/bin/bash
# smoke-test.sh

echo "🔥 Running Smoke Tests..."

# 1. Health check
echo "Checking health endpoint..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health)
if [ "$STATUS" != "200" ]; then
  echo "❌ Health check failed"
  exit 1
fi
echo "✓ Health check passed"

# 2. Database connection
echo "Checking database..."
DB_STATUS=$(curl -s http://localhost:3000/health/db | jq -r '.status')
if [ "$DB_STATUS" != "ok" ]; then
  echo "❌ Database check failed"
  exit 1
fi
echo "✓ Database connected"

# 3. Authentication
echo "Checking auth..."
TOKEN=$(curl -s -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123"}' | jq -r '.token')
if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo "❌ Auth check failed"
  exit 1
fi
echo "✓ Authentication working"

# 4. Core feature
echo "Checking core feature..."
FEATURE=$(curl -s -H "Authorization: Bearer $TOKEN" http://localhost:3000/api/main-feature)
if [ -z "$FEATURE" ]; then
  echo "❌ Core feature failed"
  exit 1
fi
echo "✓ Core feature working"

echo ""
echo "✅ All smoke tests passed!"
```

---

## 10. EDGE CASE TESTS

### What to Test
- Empty inputs
- Maximum lengths
- Special characters
- Concurrent operations
- Network failures
- Timezone handling

### Edge Case Checklist
```
Input Edge Cases:
□ Empty string ""
□ Null/undefined
□ Very long strings (>10000 chars)
□ Special characters (!@#$%^&*)
□ Unicode/emoji (👋🏽)
□ HTML/script tags
□ SQL special chars ('; --)
□ Negative numbers
□ Zero
□ Very large numbers
□ Floating point precision
□ Invalid dates
□ Future dates
□ Past dates (1900)

State Edge Cases:
□ First user (empty database)
□ Maximum capacity
□ Concurrent modifications
□ Race conditions
□ Session expired mid-action
□ Network timeout
□ Partial data submission

Error Edge Cases:
□ Database connection lost
□ External API down
□ Disk full
□ Memory pressure
□ Invalid configuration
```

### Edge Case Test Template
```javascript
describe('Edge Cases', () => {
  describe('Input Validation', () => {
    const edgeCases = [
      { input: '', expected: 'empty' },
      { input: null, expected: 'null' },
      { input: 'a'.repeat(10001), expected: 'truncated' },
      { input: '<script>alert(1)</script>', expected: 'escaped' },
      { input: "'; DROP TABLE users;--", expected: 'escaped' },
      { input: '👋🏽', expected: 'valid' },
      { input: -1, expected: 'error' },
      { input: Number.MAX_SAFE_INTEGER + 1, expected: 'error' },
    ];

    edgeCases.forEach(({ input, expected }) => {
      it(`handles ${JSON.stringify(input)} correctly`, async () => {
        const result = await processInput(input);
        expect(result.status).toBe(expected);
      });
    });
  });

  describe('Concurrent Operations', () => {
    it('handles simultaneous updates', async () => {
      const promises = Array(10).fill().map(() =>
        updateResource(1, { value: Math.random() })
      );
      const results = await Promise.allSettled(promises);
      const successes = results.filter(r => r.status === 'fulfilled');
      expect(successes.length).toBeGreaterThan(0);
    });
  });
});
```

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
Last updated: 2026-01-29
