# Workflow Templates

## Development Workflows

### Systematic Debug
```
1. REPRODUCE: exact steps, environment, error message, when last worked
2. ISOLATE: minimal repro, which component, fails in isolation, git bisect
3. HYPOTHESIZE: 3 likely causes ranked, design test for each
4. FIX: smallest fix, verify bug gone, check regressions
5. PREVENT: add test, update docs if needed
```

### TDD Cycle
```
RED: Write failing test first
  test("should [behavior]", () => expect(fn(input)).toBe(expected))

GREEN: Simplest code to pass
  Only make the test pass, no extras

REFACTOR: Clean up
  Remove duplication, improve names, extract helpers
  Tests still pass? ✓
```

### Edge Test Checklist
```
□ null / undefined / None
□ Empty: "", [], {}
□ Single item: [1], "a"
□ Max values: MAX_INT, very long strings
□ Min values: 0, -1, negative numbers
□ Unicode: "émoji 🎉", "中文", "العربية"
□ Special chars: <script>, ../../../, %00
□ Concurrent: same request twice
□ Timeout: external service slow
□ Offline: network fails mid-request
```

## Deployment Workflows

### Pre-Deploy Checklist
```
□ Environment vars set in production
□ Database migrations run and verified
□ Feature flags in correct state
□ Rollback plan documented
□ Monitoring and alerts configured
□ Smoke test scenarios ready
```

### Health Check Protocol
```
□ Web app: curl -I https://[domain] (expect 200)
□ API: curl https://api.[domain]/health
□ Database: SELECT 1 connection test
□ Cache: PING → PONG
□ SSL: openssl s_client -connect [domain]:443
□ DNS: dig [domain]

Report: ✅ [service] - [time]ms | ❌ [service] - [error]
```

## Content Workflows

### Blog Post
```
1. TOPIC: subject, angle, target reader, goal
2. OUTLINE: hook, problem, solution, evidence, CTA
3. DRAFT: ugly first draft fast, don't edit while writing
4. EDIT: cut 20%, strengthen verbs, add specifics
5. SEO: title <60 chars, meta <155 chars, H2s with keywords
6. PUBLISH: platform, schedule, promotion channels
```

### Cold Email
```
Subject: [specific observation about them]

Hi [Name],

[Observation - 1 sentence]
[Problem you solve - 1 sentence]
[Credibility/proof - 1 sentence]
[Soft CTA - question]

[Signature]

Follow-up: Day 3 bump, Day 7 new angle, Day 14 break-up
```

## Productivity Workflows

### Context Save (/cs)
```
Date: [today]
Session focus: [what worked on]

## Decisions Made
- [decision]: [reasoning]

## Completed
- [x] [task]

## Blocked On
- [ ] [blocker]: [what needed]

## Next Session
- [ ] [priority 1-3]

## Files Touched
- [file]: [change]
```

### Focus Session
```
1. DEFINE (2 min): single goal, time block, success criteria
2. PREPARE (3 min): close distractions, DND, tools ready
3. EXECUTE: work only on goal, parking lot for distractions
4. BREAK: stop at timer, 5-10 min, review goal

Pomodoro: 25 min + 5 min break × 4 = 2 hour block
```

### Reflection Framework
```
What WORKED? → keep doing
What DIDN'T? → stop or change
What LEARNED? → insight
What DIFFERENTLY? → specific change

Energy: started [1-10], ended [1-10], peak focus [when], drain [what]
```
