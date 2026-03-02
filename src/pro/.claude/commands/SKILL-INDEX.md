# Skill & Workflow Reference
Complete reference: how skills trigger, when they run, and what they do.

## Auto-Trigger
**When:** "list skills", "available skills", "skill list", "what skills", "show skills"

---

## Quick Stats
| Metric | Count |
|--------|-------|
| Total Skills | 140 |
| Blocking Gates | 3 |
| Agent Workflows | 3 |
| Categories | 18 |
| Auto-Hooks | 9 |
| Trigger Mappings | ~105 |

---

## How The Trigger System Works

### Three Tiers

| Tier | Behavior | Example |
|------|----------|---------|
| **1-BLOCK** | Stops execution. Shows gate checklist. Must acknowledge before proceeding. | Say "done" → `/verify` gate appears |
| **2-SUGGEST** | Offers the workflow. You can accept or say "skip". | Say "debug this" → `/systematic-debug` suggested |
| **3-CONVENIENCE** | Mentioned only if contextually relevant. No prompt. | Skill creation tips shown when relevant |

### How Skills Are Invoked

| Method | Example | Notes |
|--------|---------|-------|
| **Slash command** | `/jira-quick` | Direct invocation, always works |
| **Natural language** | "I need to debug this error" | Trigger detector matches keywords, suggests skill |
| **Auto-trigger** | Session start, every 10 sessions | Runs without user action |
| **Chained** | `/orchestrate` calls multiple skills | Meta-skill composes workflows |

### How to Skip Gates
- `/verify` gate → say **"skip verify"**
- `/deploy-verify` gate → say **"skip deploy gate"**
- `/quick-deploy` gate → say **"skip"**
- Any Tier 2 suggestion → say **"skip"** or just continue talking

### Trigger Detection Rules
- Minimum message length: 50 characters
- Minimum keyword matches: 1
- **Skipped patterns** (to avoid false positives):
  - Past tense: "I already deployed"
  - Questions: "What is deploy?"
  - Negations: "Don't deploy"

---

## Automatic Behaviors (No User Action Required)

### Every Session (once per session via `session_id` dedup)
| What | How | Hook File |
|------|-----|-----------|
| Increment session counter | Python tracker | `startup-parallel.sh` |
| GitHub auth check | `gh auth status` | `startup-parallel.sh` |
| Uncommitted files warning | git status (warns if >5 files) | `startup-parallel.sh` |

### Every Prompt (lightweight checks)
| What | How | Hook File |
|------|-----|-----------|
| Long session nudge | After 2h with no save, suggests `/checkpoint` (checks every 10th prompt, once per session) | `session-nudge.sh` |

### Every 10 Sessions
| What | Details | Hook File |
|------|---------|-----------|
| Auto-cleanup | Prunes debug/>3d, paste-cache/>7d, raw logs/>14d, session-env/>7d | `auto-cleanup.sh` |
| Health check services | All endpoints + CLI tools | workspace-automation |
| Verify skills intact | Check commands/ file count | workspace-automation |
| Backup | `.claude/` and `scripts/` | workspace-automation |

### Post-Commit
| What | How | Hook File |
|------|-----|-----------|
| Lesson nudge | After fix/revert/hotfix commits, suggests `/lesson` | `post-commit-lesson.sh` |

### Pre-Deploy (Before Any Deploy Command)
| Detected Command | Credential Check | Hook File |
|-----------------|-----------------|-----------|
| `forge deploy/install` | `JIRA_API_TOKEN` in env | `pre-deploy-check.sh` |
| `npm publish` | `npm whoami` succeeds | `pre-deploy-check.sh` |
| `wrangler deploy` | Cloudflare config or `CLOUDFLARE_API_TOKEN` | `pre-deploy-check.sh` |
| `xcrun altool/notarytool` | `.p8` key files exist | `pre-deploy-check.sh` |
| `chrome-webstore-upload` | CWS config.json exists | `pre-deploy-check.sh` |
| `doctl apps` | `doctl account get` succeeds | `pre-deploy-check.sh` |

### Post-Edit (after Edit/Write)
| What | How | Hook File |
|------|-----|-----------|
| Quality warnings | console.log, print(), force unwraps, TODOs | `post-edit-quality.sh` |

### Context Low (Notification)
| What | How | Hook File |
|------|-----|-----------|
| Auto-save state | Saves git state to context-saves/ (no stash) | `context-low-autosave.sh` |

### Session End
| What | Details | Hook File |
|------|---------|-----------|
| Uncommitted files warning | Shows count + branch name | `session-end-save.sh` |
| Context save reminder | Warns if no save in last hour, suggests `/save` | `session-end-save.sh` |

### Branch Protection (Pre-Edit)
| What | How | Hook File |
|------|-----|-----------|
| Block edits on main | Allows .claude/, context-saves/, .github/ only | `branch-protection.sh` |

---

## Blocking Gates (Tier 1)

### `/verify` — Pre-Completion Gate
| | |
|---|---|
| **Keywords** | done, fixed, complete, resolved |
| **Behavior** | BLOCKS — must complete checklist or say "skip verify" |
| **Checks** | Lint, typecheck, tests pass; git clean; no vulnerabilities; no secrets committed; docs updated |

### `/deploy-verify` — Pre-Deployment Gate
| | |
|---|---|
| **Keywords** | deploy, production, release, live |
| **Behavior** | BLOCKS — full deployment verification pipeline |
| **Checks** | Code quality → build → deploy (dry-run preview) → post-deploy health check → 5-min log monitor |

### `/quick-deploy` — Rapid Deploy Gate
| | |
|---|---|
| **Keywords** | ship it, quick deploy |
| **Behavior** | Soft confirmation — minimal checks, fast path |
| **Supports** | Cloudflare Workers, Vercel, Railway, Fly.io, Docker/K8s |

---

## Development & Debugging (10 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/systematic-debug` | debug, broken, error, not working, bug | 6-step process: Reproduce → Isolate → Hypothesize → Test → Fix → Prevent |
| `/root-trace` | trace, root cause, why | Trace errors backward to root cause |
| `/tdd` | test, tdd, test-first | Test-driven development workflow: Red → Green → Refactor |
| `/build-test` | build, compile, won't build | Verify build process, check for compile errors |
| `/edge-test` | edge case, boundary, what if | Systematic edge case and boundary testing |
| `/api-test` | test endpoint, hit api, curl | Quick API endpoint testing — hit, inspect, validate |
| `/write-plan` | plan, approach, how should | Implementation planning with trade-off analysis |
| `/parallel-agents` | parallel, concurrent, multiple agents | Multi-agent coordination for parallel work |
| `/brainstorm` | brainstorm, ideas, options | Structured idea generation framework |
| `/test-suite` | test suite | Test suite management and organization |

---

## Deployment & Ops (10 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/deploy-verify` | deploy, production, release, live | **[TIER 1]** Full deployment verification pipeline |
| `/quick-deploy` | ship it, quick deploy | **[TIER 1]** Rapid deploy with minimal checks |
| `/deploy-ir` | ir deploy, email monitor | Deploy IR Email Monitor specifically |
| `/infra-health` | infra health, service health, is it up | Multi-platform service health check (CF Workers, Vercel, Railway, Docker) |
| `/log-errors` | errors, logs, what went wrong | Error log analysis and pattern detection |
| `/alert-test` | test alert, alerting | Alert system testing and verification |
| `/env-sync` | env, secrets, environment | Environment variable synchronization |
| `/deploy:cloudflare-worker` | cloudflare worker, cf deploy | Cloudflare Worker deployment workflow |
| `/weekly-ops-review` | weekly review, ops review | Weekly system review and metrics |
| `/perf-test` | perf test, load test, benchmark | Performance and load testing |

---

## Content Creation (9 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/c2c:blog` | blog, article, write post | Full blog workflow: Research → Outline → Draft (with SEO checklist) |
| `/c2c:quick-blog` | quick blog, short post | Fast blog post (skip research phase) |
| `/c2c:twitter` | tweet, thread, twitter | Twitter/X thread creation |
| `/c2c:readme` | readme, documentation | README file generation |
| `/c2c:tutorial` | tutorial, how-to guide | Step-by-step tutorial creation |
| `/c2c:video-script` | video script, youtube | Video script with timing and shot notes |
| `/c2c:product-launch` | product launch, announcement | Complete launch content pack |
| `/c2c:newsletter` | newsletter, email newsletter | Email newsletter drafting |
| `/c2c:conference-talk` | conference, talk, presentation | Speaking content and slide planning |

---

## Marketing & Sales (7 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/design-website` | website design, mockup | Website planning and wireframing |
| `/marketing-assets` | marketing assets, brand | Marketing collateral generation |
| `/landing-copy` | landing, copy, sales page | Conversion-optimized landing page copy |
| `/case-study` | case study, success story | Customer success story framework |
| `/demo-script` | demo script, product demo | Product demo script with talking points |
| `/content-brief` | content brief, content plan | Article planning and brief creation |
| `/linkedin-post` | linkedin, linkedin post | LinkedIn post drafting |

---

## Workspace Management (5 skills — NEW)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/multi-project-status` | project status, all projects, what's open | Scan all 20+ projects: uncommitted, stale branches, last commit |
| `/project-switch` | switch to, work on, open project | Snapshot current state → switch project → load context |
| `/git-cleanup` | git cleanup, prune branches, repo cleanup | Prune merged branches + stale remotes across all projects |
| `/debug-prune` | prune, cleanup claude, disk space | Clean growing dirs: debug/, paste-cache/, raw logs, session-env/ |
| `/cred-discover` | credentials, find creds | Actively hunt for credentials before deploy |

---

## Productivity & Organization (9 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/cs` | cs, context save, done for today | **Menu-based:** Context Save / Health Check / Both / Quick Status / Skip |
| `/save` | save, save progress | Alias for `/handoff` — saves session state |
| `/handoff` | handoff, wrap up, closing out | Session end auto-package with structured restore file |
| `/checkpoint` | checkpoint, snapshot | Lightweight mid-session state snapshot |
| `/restore` | restore, resume, continue, where was I, pick up, last session | Load previous context-save file, restore environment |
| `/preflight` | preflight, before we build, feasibility, check first | Credential + capability check → GO / NO-GO / GO WITH CAVEAT |
| `/focus` | focus, deep work | Focus session setup: single objective, duration, success criteria |
| `/reflect` | reflect, lessons, retro | Daily (5 min) and weekly (15 min) reflection templates |
| `/workspace-audit` | audit, cleanup, workspace | File system audit, git audit, project health checklist |
| `/organize` | organize, structure | File and project organization |
| `/archive` | archive, old files | Archive items to designated locations |

---

## Data & Integration (7 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/db-query` | query, sql, database | Database query templates and execution |
| `/lookup` | lookup, search data | Quick information lookup across sources |
| `/gws-search` | gmail search, drive search, gws | Google Workspace search (Gmail + Drive) |
| `/gws-email-report` | email report, gws report | Email analytics and reporting |
| `/cred-map` | credentials, cred map | Credential inventory and mapping |
| `/mail` | email, compose | Email template composition |
| `/migration` | migration, database migration, schema | Data and schema migration workflows |

---

## Jira & Project Tracking (6 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/jira-quick` | jira, ticket, issue | Quick Jira operations: create bugs/features, JQL templates, API examples |
| `/jira-comment-check` | jira comments, check comments | Jira comment analysis |
| `/dedup-check` | duplicates, dedup | Duplicate issue detection |
| `/compliance-pack` | compliance, audit, security | Compliance documentation package |
| `/report-pdf` | pdf report, generate report | PDF report generation |
| `/monday` | monday, monday board | Monday.com GraphQL API operations |

---

## Swift & iOS (5 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/swift:async-troubleshoot` | swift async, await, MainActor | Swift concurrency debugging (async/await, actors) |
| `/swift:debug-memory` | swift memory, leaks, instruments | Memory leak and retain cycle debugging |
| `/swift:app-store-prep` | app store, submission, review | App Store submission checklist |
| `/swift:localize` | localize, i18n, translate app, strings | Localization workflow |
| `/SWIFT-WORKFLOW` | swift workflow | Full Swift development workflow (umbrella) |

---

## Email Investigation (4 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/email:forensic-workflow` | email forensic, investigation | 5-step email forensic investigation |
| `/email:metadata-extract` | email metadata, headers | Email header analysis |
| `/email:compliance-report` | email compliance, audit | Investigation report generation |
| `/COMPLIANCE-WORKFLOW` | compliance workflow | Full compliance & email investigation workflow |

---

## Product Management (2 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/pm:feature-prioritize` | feature priority, RICE, scoring | RICE scoring framework with templates |
| `/pm:roadmap-build` | roadmap, product roadmap | Product roadmap planning |

---

## Bot & Extension Debugging (3 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/bot:slack-debug` | slack bot, slack debug | Slack bot debugging workflow |
| `/bot:telegram-debug` | telegram bot, telegram debug | Telegram bot debugging workflow |
| `/chrome:extension-debug` | chrome extension, extension debug | Chrome extension debugging |

---

## Developer Tools (8 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/scaffold` | scaffold, boilerplate, create project | Project scaffolding with templates |
| `/docker` | docker, dockerfile, container | Dockerfile templates (Node, Python, Go) with multi-stage builds |
| `/git-flow` | git flow, feature branch, release branch | Git branching workflow management |
| `/dependency-audit` | dependency audit, outdated packages, npm audit | Dependency analysis and vulnerability check |
| `/api-docs` | api docs, swagger, openapi | API documentation generation |
| `/changelog` | changelog, update changelog | Changelog generation from git history |
| `/commit-msg` | commit message, conventional commit | Conventional commit message helper |
| `/release-notes` | release notes, what changed | Release note generation |

---

## Business Operations (7 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/invoice` | invoice, bill client, billing | Invoice generation |
| `/proposal` | proposal, quote, SOW, scope of work | Business proposal drafting |
| `/1on1` | 1 on 1, one on one, 1:1 | 1:1 meeting prep with agenda templates |
| `/standup` | standup, daily standup, scrum | Daily standup notes |
| `/time-track` | log time, track time, billable hours | Time tracking |
| `/client-onboard` | new client, onboard client, client setup | Client onboarding checklist |
| `/decision-log` | decision log, adr, architecture decision | Decision documentation (ADR format) |

---

## Automation & Workflows (8 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/morning-check` | update, updates, packages, maintenance | 4-step morning check: MCP health → credentials → package updates → Monday stuck items |
| `/orchestrate` | orchestrate, run workflow, automate, full workflow | Meta-skill: analyzes context, builds skill chain, executes in order |
| `/preflight` | preflight, before we build, feasibility | Pre-build credential and capability verification |
| `/restore` | restore, resume, continue, where was I | Load and restore previous session context |
| `/session-retro` | session retro, session review, lessons learned | Session retrospective: what worked, patterns, lessons |
| `/retro` | sprint retro, project retro, post-mortem | Sprint/project retro: Start/Stop/Continue or 4Ls format |
| `/system-health` | system health, health check | Local dev environment health check |
| `/log-analysis` | analyze logs, session analysis, what did I work on | Log file analysis and session review |

---

## Publishing & Sharing (7 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/publish` | publish, release to store, submit to marketplace | Publish to store/marketplace workflow |
| `/share-code` | share code, snippet | Code sharing (private gist default) |
| `/linkedin-carousel` | carousel, linkedin carousel, make slides | HTML slides → screenshot → combine to PDF (1080x1350px) |
| `/podcast-prep` | podcast, episode prep, show notes | Podcast episode preparation |
| `/seo-audit` | seo audit, seo check, meta tags | SEO analysis and recommendations |
| `/quick-ref` | quick ref, cheat sheet | Quick reference card generation |
| `/secret-scan` | secret scan, find secrets, leaked credentials | Security scanning (Gitleaks, truffleHog, git-secrets) |

---

## Specialized (8 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/neuro:daily-check` | hrv, stress, energy, neuro | Neuroperformance daily assessment with biometric queries |
| `/neuro:weekly-report` | weekly neuro, hrv summary, performance report | Weekly neuroperformance report |
| `/mcp:recommended-servers` | mcp servers, recommended mcp | MCP server configuration recommendations |
| `/mcp:build` | build mcp, create mcp server | MCP server development workflow |
| `/vmk:screenshot` | vmk screenshot | VMK screenshot capture |
| `/vmk:enhance` | vmk enhance | VMK content enhancement |
| `/vmk:process` | vmk process | VMK processing workflow |
| `/vmk:source` | vmk source | VMK source management |

---

## Sales (9 skills — colon-namespaced flat files)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/sales:call-summary` | call summary, meeting notes | Process call notes → action items + follow-up email |
| `/sales:forecast` | forecast, quota, sales forecast | Weighted forecast with best/likely/worst scenarios |
| `/sales:pipeline-review` | pipeline review, deal review | Pipeline health score, risk flags, weekly action plan |
| `/sales:account-research` | research company, who is | Company intel, key contacts, recent news, hiring signals |
| `/sales:call-prep` | call prep, meeting prep | Account context, attendee research, discovery questions |
| `/sales:competitive-intel` | competitive intel, compare to | Product comparison, pricing intel, differentiation matrix |
| `/sales:create-asset` | sales asset, create deck | Generate landing pages, decks, one-pagers for prospects |
| `/sales:daily-briefing` | morning briefing, what's on my plate | Pipeline alerts, meeting prep, email priorities |
| `/sales:draft-outreach` | draft outreach, prospect email | Research prospect first, then personalized outreach |

Supporting files: `sales:README.md` (overview), `sales:connectors.md` (MCP integration guide).

---

## Agent Workflows (3 skills — Complex Multi-Step)

| Agent | Keywords | What It Does |
|-------|----------|-------------|
| `/agent:code-review` | code review, review code, PR review | Comprehensive automated code review |
| `/agent:project-analyzer` | analyze project, project structure | Project health assessment and architecture analysis |
| `/agent:deploy-pipeline` | deploy pipeline, CI/CD | Full deployment pipeline automation |

---

## Meta Skills (2 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/make-skill` | create skill, new skill | **[TIER 3]** Create new skill files |
| `/SKILL-INDEX` | skill list, all skills | **[TIER 3]** This reference document |

---

## Credential Discovery (used by `/preflight` and pre-deploy hook)

Before accessing any authenticated service, the system checks in order:
1. `.env` files in project root
2. `~/.config/<service>/` config directories
3. Environment variables
4. macOS Keychain: `security find-generic-password -s "<service>"`
5. If not found → documents what's needed

---

## File Locations

| Type | Location |
|------|----------|
| Skill files (140) | `.claude/commands/*.md` (flat, colon-namespaced) |
| Hook scripts (10) | `~/.claude/hooks/*.sh` |
| Trigger mappings | `.claude/MASTER.md` |
| Pointer config | `.claude/CLAUDE.md` |
| Session state | `.claude/state.md` |
| Hook scripts | `~/.claude/hooks/` |
| Hook config | `~/.claude/settings.json` → `hooks` key |
| Session tracker | `~/.claude/skills/workspace-automation/scripts/session_tracker.py` |
| Trigger detector | `~/.claude/skills/workspace-automation/scripts/trigger_detector.py` |
| Compiled triggers | `~/.claude/skills/workspace-automation/data/compiled_triggers.json` |
| Context saves | `context-saves/*.md` |

---

## MCP Servers Available

| Server | Purpose |
|--------|---------|
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

*Last updated: 2026-02-17*
