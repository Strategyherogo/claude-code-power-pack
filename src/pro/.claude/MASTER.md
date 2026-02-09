# CLAUDE MASTER CONFIG v5.0
# Minimal trigger mappings - workflows in commands/

---

## AUTO-EXEC (Every Session)
- Increment session counter (internal)
- Load context: TechConcepts | D&S | SelfOrg
- Check pending from last session
- Arm triggers below
- **Show /cs menu** (session starter):
  ```
  What would you like to do?
  1) Context Save  - Save current work state
  2) Health Check  - System & package audit
  3) Both          - Save context + health check
  4) Quick Status  - Git status + workspace summary
  5) Skip          - Continue without action
  ```

## AUTO-RUN (Every 10 Sessions)
- Health check services
- Verify skills intact
- Backup .claude/ and scripts/

---

# TRIGGER TIERS

## TIER 1: BLOCKING (Must complete gate before proceeding)

| Trigger | Command | Gate |
|---------|---------|------|
| done, fixed, complete, resolved | /verify | Pre-completion |
| deploy, production, release, live | /deploy-verify | Pre-deployment |
| ship it, quick deploy | /quick-deploy | Rapid deploy |

## TIER 2: SUGGEST (Offer workflow, allow skip)

### Development
| Trigger | Command |
|---------|---------|
| debug, broken, error, not working, bug | /systematic-debug |
| trace, root cause, why | /root-trace |
| test, tdd, test-first | /tdd |
| build, compile, won't build | /build-test |
| edge case, boundary, what if | /edge-test |
| plan, approach, how should | /write-plan |
| parallel, concurrent, multiple agents | /parallel-agents |
| brainstorm, ideas, options | /brainstorm |
| git flow, feature branch, release branch | /git-flow |
| commit message, conventional commit | /commit-msg |
| scaffold, boilerplate, create project | /scaffold |
| docker, dockerfile, container | /docker |
| migration, database migration, schema | /migration |
| api docs, swagger, openapi | /api-docs |
| release notes, what changed | /release-notes |
| changelog, update changelog | /changelog |
| dependency audit, outdated packages, npm audit | /dependency-audit |
| perf test, load test, benchmark | /perf-test |
| secret scan, find secrets, leaked credentials | /secret-scan |
| decision log, adr, architecture decision | /decision-log |

### Deployment & Ops
| Trigger | Command |
|---------|---------|
| health, status, is it up | /infra-health |
| update, updates, packages, maintenance, pkg | /morning-check |
| errors, logs, what went wrong | /log-errors |
| env, secrets, environment | /env-sync |
| ir deploy, email monitor | /deploy-ir |
| test alert, alerting | /alert-test |

### Content Creation
| Trigger | Command |
|---------|---------|
| blog, article, write post | /c2c:blog |
| quick blog, short post | /c2c:quick-blog |
| tweet, thread, twitter | /c2c:twitter |
| linkedin, linkedin post | /linkedin-post |
| carousel, linkedin carousel, make slides | /linkedin-carousel |
| newsletter, email newsletter | /c2c:newsletter |
| video script, youtube | /c2c:video-script |
| readme, documentation | /c2c:readme |
| tutorial, how-to guide | /c2c:tutorial |
| product launch, announcement | /c2c:product-launch |
| conference, talk, presentation | /c2c:conference-talk |

### Marketing & Sales
| Trigger | Command |
|---------|---------|
| landing, copy, sales page | /landing-copy |
| case study, success story | /case-study |
| demo script, product demo | /demo-script |
| content brief, content plan | /content-brief |
| marketing assets, brand | /marketing-assets |
| website design, mockup | /design-website |
| seo audit, seo check, meta tags | /seo-audit |

### Business & Consulting
| Trigger | Command |
|---------|---------|
| invoice, bill client, billing | /invoice |
| new client, onboard client, client setup | /client-onboard |
| proposal, quote, SOW, scope of work | /proposal |
| log time, track time, billable hours | /time-track |
| standup, daily standup, scrum | /standup |

### Meetings & Collaboration
| Trigger | Command |
|---------|---------|
| 1 on 1, one on one, 1:1 | /1on1 |
| retro, retrospective, post-mortem | /retro |

### Productivity
| Trigger | Command |
|---------|---------|
| cs, context save, done for today | /cs |
| save, checkpoint, end session | /save |
| restore, resume, continue, where was I, pick up, last session | /restore |
| preflight, before we build, feasibility, check first | /preflight |
| focus, deep work | /focus |
| reflect, lessons, retro | /reflect |
| audit, cleanup, workspace | /workspace-audit |
| organize, structure | /organize |
| archive, old files | /archive |
| analyze logs, session analysis, what did I work on | /log-analysis |
| session review, retro | /session-retro |

### Data & Integration
| Trigger | Command |
|---------|---------|
| query, sql, database | /db-query |
| lookup, search data | /lookup |
| gmail search, drive search, gws | /gws-search |
| email report, gws report | /gws-email-report |
| credentials, cred map | /cred-map |
| find credentials, discover auth, check auth | /cred-discover |
| publish, release to store, submit to marketplace | /publish |
| jira, ticket, issue | /jira-quick |
| jira comments, check comments | /jira-comment-check |
| duplicates, dedup | /dedup-check |
| compliance, audit, security | /compliance-pack |
| pdf report, generate report | /report-pdf |
| email, compose | /mail |

### Domain-Specific
| Trigger | Command |
|---------|---------|
| swift async, await, MainActor | /swift:async-troubleshoot |
| swift memory, leaks, instruments | /swift:debug-memory |
| app store, submission, review | /swift:app-store-prep |
| feature priority, RICE, scoring | /pm:feature-prioritize |
| roadmap, product roadmap | /pm:roadmap-build |
| email forensic, investigation | /email:forensic-workflow |
| email metadata, headers | /email:metadata-extract |
| email compliance, audit | /email:compliance-report |
| slack bot, slack debug | /bot:slack-debug |
| telegram bot, telegram debug | /bot:telegram-debug |
| chrome extension, extension debug | /chrome:extension-debug |
| cloudflare worker, cf deploy | /deploy:cloudflare-worker |
| hrv, stress, energy, neuro | /neuro:daily-check |
| weekly neuro, hrv summary, performance report | /neuro:weekly-report |
| weekly review, ops review | /weekly-ops-review |
| podcast, episode prep, show notes | /podcast-prep |
| build mcp, create mcp server | /mcp:build |
| localize, i18n, translate app, strings | /swift:localize |

### Agents (Complex Multi-Step)
| Trigger | Command |
|---------|---------|
| code review, review code, PR review | /agent:code-review |
| analyze project, project structure | /agent:project-analyzer |
| deploy pipeline, CI/CD | /agent:deploy-pipeline |

### Sales
| Trigger | Command |
|---------|---------|
| call summary, meeting notes, call notes, summarize call | /sales:call-summary |
| forecast, quota, pipeline forecast, sales forecast | /sales:forecast |
| pipeline review, deal review, pipeline health | /sales:pipeline-review |
| research company, account research, who is, look up company | /sales:account-research |
| call prep, prep for call, meeting prep, prepare for meeting | /sales:call-prep |
| competitive intel, competitor, how do we compare, battlecard | /sales:competitive-intel |
| sales asset, create deck, one-pager, sales collateral | /sales:create-asset |
| morning briefing, daily briefing, what's on my plate | /sales:daily-briefing |
| draft outreach, prospect email, reach out to | /sales:draft-outreach |

### Orchestration (Meta-Skills)
| Trigger | Command |
|---------|---------|
| orchestrate, run workflow, automate, full workflow | /orchestrate |

## TIER 3: CONVENIENCE (Mention if relevant)

| Trigger | Command |
|---------|---------|
| create skill, new skill | /make-skill |
| skill list, all skills | /SKILL-INDEX |
| mcp servers, recommended mcp | /mcp:recommended-servers |

---

# MCP SERVERS

| Server | Use |
|--------|-----|
| atlassian | Jira, Confluence |
| playwright | Browser automation |
| slack | Messages, channels |
| postgres | Database queries |
| fetch | HTTP requests |
| sequential-thinking | Complex reasoning |
| gdrive | Google Drive |
| notion | Notion pages |
| github | Repos, PRs, issues |
| memory | Knowledge graph |

---

# OPERATIONAL RULES

## Dropbox Operations (Critical)
- **Never delete relocation/move logs** - archive to `output/archive-logs/` instead
- **Verify full paths** - UI can be deceptive (e.g., `/01. Finance/` may actually be `/db archives/.../corporate finance/01. finance/`)
- **Check file dates** to verify restore status: recent date = restored, old date = still in archive
- **Search results can be stale** - verify file exists before copy/move operations
- **Restore ALL folder structures** - don't just track obvious shared folders
- **Archives get cleaned up** - restore ASAP, don't assume files will persist

## General Data Operations
- **Never delete lessons, logs, or records** - always archive instead
- **Archive locations:**
  - Logs: `output/archive-logs/`
  - Lessons: `3. Resources/02-iterations/lessons/archive/`
  - Session notes: `3. Resources/02-iterations/archive-transcripts/`

---

# PROJECT CONTEXT

**TechConcepts** - Consulting (AI automation, predictive models, NEPS)
**D&S** - Apps Factory (MCP servers, utilities, workers)
**SelfOrg** - Neuroperformance (biometrics DB, ANS optimization)

---

# SESSION PROTOCOL

Format: `[TIME] [OP] [PATH] [DETAIL]`
Ops: `+ create` `~ modify` `- delete` `> execute` `? read` `! error` `✓ success`

---

*v5.0 - Minimal trigger mappings. Full workflows in commands/*
