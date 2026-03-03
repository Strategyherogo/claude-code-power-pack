# Auto-Trigger Reference

## Tier 1: Blocking Gates (Must Acknowledge)

| Trigger Keywords | Action | Checklist |
|------------------|--------|-----------|
| done, fixed, complete, resolved | `/verify` | Tests pass, edge cases covered, docs updated, code reviewed, committed |
| deploy, production, release, live | `/deploy-verify` | Env vars set, migrations run, feature flags correct, rollback plan, monitoring |
| ship it, quick deploy | `/quick-deploy` | Service name, smoke test, team notification |

## Tier 2: Soft Suggestions (Offer Helpfully)

### Development
| Trigger | Workflow |
|---------|----------|
| debug, broken, error, not working, bug | Systematic debug: reproduce → isolate → hypothesize → fix → prevent |
| trace, root cause, why | Root trace: stack trace → first user code → logging → bisect |
| test, tdd, test-first | TDD: red → green → refactor |
| build, compile | Build check: deps, versions, clean build, lint |
| edge case, boundary, what if | Edge test: null, empty, max, min, unicode, special chars, concurrent |
| plan, approach, how should | Planning: goal, scope, approach, risks, steps, done criteria |

### Deployment
| Trigger | Workflow |
|---------|----------|
| health, status, is it up | Health check: endpoints, db, cache, SSL, DNS |
| errors, logs, what went wrong | Log scan: categorize, frequency, recent spike |
| env, secrets, environment | Env sync: compare local/staging/prod, identify missing |

### Content
| Trigger | Workflow |
|---------|----------|
| blog, article, write post | Blog: topic → outline → draft → edit → SEO → publish |
| tweet, thread, twitter | Tweet: hook pattern, 280 chars, thread structure |
| linkedin | LinkedIn: hook line, blank line, story, question |
| newsletter | Newsletter: subject, preview, body, PS |

### Productivity
| Trigger | Workflow |
|---------|----------|
| cs, context save, done for today | Context save: decisions, completed, blocked, next session |
| focus, deep work | Focus: define goal, prepare environment, pomodoro |
| reflect, lessons, retro | Reflect: worked, didn't work, learned, differently |
| audit, cleanup, workspace | Audit: stale branches, large files, TODOs, outdated deps |

### Data & Jira
| Trigger | Workflow |
|---------|----------|
| query, sql, database | Safe query: verify connection, limit first, review before run |
| jira, ticket, issue | Jira: create, transition, comment, search |
| compliance, audit, security | Compliance: data inventory, security controls, policies |

## Tier 3: Convenience (Mention If Relevant)

| Context | Offer |
|---------|-------|
| Writing email | `/mail` template |
| Creating new skill | `/make-skill` workflow |
| Asking about available skills | Show skill index |
