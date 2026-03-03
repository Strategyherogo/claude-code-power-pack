# Skill: plan-or-do
Smart task sizing — automatically decide whether to plan first or execute directly.

## Auto-Trigger
**When:** Beginning of any non-trivial task. Evaluate silently, don't ask unless needed.

---

## Decision Logic

When a new task arrives, evaluate these criteria:

### Count Estimated Steps
```
Steps include:
- Each API call or integration point
- Each file that needs modification
- Each deployment or build step
- Each external service interaction
- Each test/verification step
```

### Decision Matrix

| Steps | External APIs | Deployment? | Decision |
|-------|-------------|-------------|----------|
| 1-3 | 0 | No | **DO** — execute directly |
| 1-3 | 1+ | No | **GATE then DO** — run /gate, then execute |
| 4+ | 0 | No | **PLAN then DO** — run /write-plan first |
| 4+ | 1+ | No | **GATE + PLAN then DO** |
| Any | Any | Yes | **GATE + PLAN + DEPLOY-VERIFY** |

### Auto-Chain Rules

**If DO:**
- Proceed immediately, no overhead

**If GATE then DO:**
- Run `/gate` checks silently
- If all pass → proceed
- If any fail → show gate report, wait for user

**If PLAN then DO:**
- Tell user: "This task has [N] steps — creating a plan first."
- Run `/write-plan` or use EnterPlanMode
- After approval → execute

**If GATE + PLAN then DO:**
- Run `/gate` first (parallel with initial exploration)
- If gate passes → create plan
- If gate fails → show blocker before planning

---

## Examples

### Direct Execution (1-3 steps, no APIs)
```
User: "Fix the typo in README.md"
→ Steps: 1 (edit file)
→ Decision: DO
→ Just fix it
```

### Gate Then Execute (1-3 steps, has API)
```
User: "Check if our Jira token works"
→ Steps: 2 (check token, test API)
→ Decision: GATE then DO
→ Run /gate for Jira → execute
```

### Plan Then Execute (4+ steps)
```
User: "Add dark mode to the app"
→ Steps: 8+ (theme system, component updates, persistence, testing)
→ Decision: PLAN then DO
→ Run /write-plan → get approval → execute
```

### Full Pipeline (4+ steps, API, deployment)
```
User: "Add Vertex AI to LLM Hub"
→ Steps: 6+ (check API, code, test, deploy, verify)
→ APIs: GCP Vertex AI
→ Deployment: DigitalOcean
→ Decision: GATE + PLAN + DEPLOY-VERIFY
→ /gate → /write-plan → execute → /deploy-verify
```

---

## Silent vs Visible

- **DO:** completely silent, no overhead
- **GATE:** runs checks silently unless a failure is found
- **PLAN:** visible — tells user "planning first" and shows plan
- **DEPLOY-VERIFY:** visible — shows deployment checklist

---

## Override
User can always say:
- "just do it" → skip to DO regardless
- "plan this" → force PLAN even for simple tasks
- "skip gate" → bypass /gate checks

## Related Skills
- `/gate` — pre-build feasibility check
- `/write-plan` — implementation planning
- `/deploy-verify` — post-deploy verification
- `/orchestrate` — meta-skill for complex chains

---
Last updated: 2026-02-07
