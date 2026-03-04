# Skill & Workflow Reference
Complete reference: how skills trigger, when they run, and what they do.

## Auto-Trigger
**When:** "list skills", "available skills", "skill list", "what skills", "show skills"

---

## Quick Stats
| Metric | Count |
|--------|-------|
| Custom Skills | 60 |
| Marketplace Skills | 68 |
| Hook Scripts | 18 |
| Hook Entries (settings.json) | 20 |
| MCP Servers | 20 |
| Categories | 11 |

---

## How The Trigger System Works

### Three Tiers

| Tier | Behavior | Example |
|------|----------|---------|
| **1-BLOCK** | Stops execution. Shows gate checklist. Must acknowledge before proceeding. | Say "done" → `/verify` gate appears |
| **2-SUGGEST** | Offers the workflow. You can accept or say "skip". | Say "debug this" → skill suggested |
| **3-CONVENIENCE** | Mentioned only if contextually relevant. No prompt. | Skill creation tips shown when relevant |

### How Skills Are Invoked

| Method | Example | Notes |
|--------|---------|-------|
| **Slash command** | `/jira-quick` | Direct invocation, always works |
| **Natural language** | "I need to debug this error" | Trigger detector matches keywords, suggests skill |
| **Auto-trigger** | Session start, every 10 sessions | Runs without user action |
| **Chained** | `/app-store-pipeline` calls multiple skills | Meta-skill composes workflows |

### How to Skip Gates
- `/gate` → say **"skip"** or just continue talking
- Any Tier 2 suggestion → say **"skip"**

---

## Session Lifecycle (9 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/cs` | cs, start session, where was I | Session start briefing with git/PARA/context status |
| `/save` | save, save progress | Alias for `/handoff` — saves session state |
| `/handoff` | handoff, wrap up, closing out | Session end auto-package with structured restore file |
| `/checkpoint` | checkpoint, snapshot | Lightweight mid-session state snapshot |
| `/restore` | restore, resume, where was I | Load previous context-save file, restore environment |
| `/wrap` | wrap, done for today | End-of-session: retro + commit + handoff in one command |
| `/session-retro` | session retro, lessons learned | Session retrospective: what worked, patterns, lessons |
| `/retro` | sprint retro, post-mortem | Sprint/project retro: Start/Stop/Continue or 4Ls format |
| `/status` | status, what's going on | Current project status summary |

---

## App Store & Swift (8 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/asc-rejection` | rejected, rejection, review feedback | Handle App Store rejection: diagnose, fix, resubmit |
| `/asc-build-upload` | upload build, submit build | Build upload and submission workflow |
| `/app-store-pipeline` | app store pipeline, ship app | Full pipeline: build → screenshots → metadata → submit |
| `/aso` | aso, app store optimization | ASO analysis and keyword optimization |
| `/swift:app-store-prep` | app store prep, submission checklist | App Store submission preparation checklist |
| `/swift:full-cycle` | swift full cycle | Full Swift development cycle (build → test → submit) |
| `/swift:localize-bulk` | localize bulk, batch localize | Bulk localization across multiple languages |
| `/swift:ux-patterns` | ux patterns, swift ui patterns | SwiftUI UX pattern reference and implementation |

Umbrella: `/SWIFT-WORKFLOW` — routes to the right Swift skill based on context.

---

## Development & Quality (5 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/api-test` | test endpoint, hit api, curl | Quick API endpoint testing — hit, inspect, validate |
| `/test-suite` | test suite, run tests | Test suite management and execution |
| `/plan-or-do` | plan, should I plan | Decides whether to plan or execute immediately |
| `/full-review` | full review, code review | Comprehensive code review with quality checks |
| `/fix-skills` | fix skills, broken skills | Diagnose and repair broken skill files |

---

## Workspace & Git (6 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/multi-project-status` | project status, all projects | Scan all projects: uncommitted, stale branches, last commit |
| `/project-switch` | switch to, work on | Snapshot current state → switch project → load context |
| `/git-cleanup` | git cleanup, prune branches | Prune merged branches + stale remotes across all projects |
| `/debug-prune` | prune, cleanup claude, disk space | Clean growing dirs: debug/, paste-cache/, raw logs |
| `/auto-maintain` | auto maintain, maintenance | Automated maintenance tasks |
| `/gate` | gate, checklist | **[TIER 1]** Pre-completion gate — blocks until checklist done |

---

## Ops & Deployment (5 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/infra-health` | infra health, is it up | Multi-platform service health check |
| `/system-health` | system health, health check | Local dev environment health check |
| `/preflight` | preflight, before we build | Credential + capability check → GO / NO-GO |
| `/quick-ref` | quick ref, how do I deploy | Quick reference for deployment and VMK commands |
| `/publish` | publish, release | Publish to store/marketplace workflow |

---

## Content Creation (7 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/c2c:blog` | blog, article, write post | Full blog workflow: Research → Outline → Draft |
| `/c2c:newsletter` | newsletter, email newsletter | Email newsletter drafting |
| `/c2c:product-launch` | product launch, announcement | Complete launch content pack |
| `/linkedin-carousel` | carousel, linkedin carousel | HTML slides → screenshot → PDF (1080x1350px) |
| `/linkedin-post` | linkedin, linkedin post | LinkedIn post drafting |
| `/content-brief` | content brief, content plan | Article planning and brief creation |
| `/case-study` | case study, success story | Customer success story framework |

---

## Marketing & Sales (8 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/marketing-assets` | marketing assets, brand | Marketing collateral generation |
| `/landing-copy` | landing, copy, sales page | Conversion-optimized landing page copy |
| `/seo-audit` | seo audit, meta tags | SEO analysis and recommendations |
| `/geo-audit` | geo audit, ai seo, llms.txt | AI search visibility audit: crawlers, JSON-LD, citability |
| `/sales:account-research` | research company, who is | Company intel, key contacts, recent news |
| `/sales:competitive-intel` | competitive intel, compare to | Interactive battlecard with comparison matrix |
| `/sales:create-asset` | sales asset, create deck | Generate landing pages, decks, one-pagers |
| `/sales:draft-outreach` | draft outreach, prospect email | Research prospect → personalized outreach |

---

## Data, Integration & Reports (5 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/jira-quick` | jira, ticket, issue | Quick Jira operations: create, query, JQL templates |
| `/monday` | monday, monday board | Monday.com GraphQL API operations |
| `/data-validate` | validate data, data quality | Data validation and quality checks |
| `/report-pdf` | pdf report, generate report | PDF report generation |
| `/report-review` | report review, review report | Report analysis and review |

---

## Investigation & Forensics (2 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/forensic-audit` | forensic, investigation, audit | Full forensic investigation workflow |
| `/forensic-parallel` | parallel forensic | Multi-agent parallel forensic analysis |

---

## Automation & Learning (3 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/morning-check` | morning, updates, maintenance | 4-step: MCP health → credentials → packages → Monday |
| `/lesson` | lesson, learned, insight | Record a lesson learned for future sessions |
| `/cred-discover` | credentials, find creds | Hunt for credentials before deploy |

---

## Meta (2 skills)

| Skill | Keywords | What It Does |
|-------|----------|-------------|
| `/SKILL-INDEX` | skill list, all skills | This reference document |
| `/SWIFT-WORKFLOW` | swift workflow | Umbrella router for Swift skills |

---

## Automatic Behaviors (Hooks)

### UserPromptSubmit (7 hooks — run on every prompt)
| Hook | What It Does |
|------|-------------|
| `session-title.sh` | Sets terminal window title from context save |
| `startup-parallel.sh` | Session counter + git status + uncommitted warnings (parallel, once per session) |
| `session-permission-preflight.sh` | Detects permission issues, suggests fixes at session start |
| `session-nudge.sh` | Warns if >2h with no checkpoint/save |
| `conversation-logger.sh` | Captures conversation data to daily log files |
| `auto-mcp-suggest.sh` | Suggests MCP tools when keywords detected (~30ms) |
| `auto-compact-nudge.sh` | Estimates context usage, warns at ~80%, triggers auto-save |

### PreToolUse (4 hooks — run before tool execution)
| Hook | Matcher | What It Does |
|------|---------|-------------|
| `pre-tool-long-op.sh` | All tools | Warns before operations >5min, suggests checkpoint |
| `pre-deploy-check.sh` | Bash | Catches deploy/push/publish, verifies credentials |
| `branch-protection.sh` | Edit | Blocks edits on main (allows .claude/, .github/) |
| `branch-protection.sh` | Write | Blocks writes on main (allows .claude/, .github/) |

### PostToolUse (4 hooks — run after tool execution)
| Hook | Matcher | What It Does |
|------|---------|-------------|
| `post-tool-api-error.sh` | All tools | Auto-checkpoint on HTTP 500/502/503/504 errors |
| `post-commit-lesson.sh` | Bash | Suggests `/lesson` after fix/revert commits |
| `post-edit-quality.sh` | Edit | Checks for console.log, print(), force unwraps, TODOs |
| `post-edit-quality.sh` | Write | Same quality checks on new files |

### Stop (3 hooks — run when session ends)
| Hook | What It Does |
|------|-------------|
| `session-end-save.sh` | Auto-saves state, syncs config, rsyncs to Mac #2 |
| `conversation-logger.sh` | Final conversation capture |
| `session-title.sh` | Updates terminal title |

### Notification (2 hooks — run on system notifications)
| Hook | What It Does |
|------|-------------|
| `context-low-autosave.sh` | Auto-saves when context window runs low |
| `conversation-logger.sh` | Captures notification events |

---

## MCP Servers (20 connected)

### Local / Self-Hosted
| Server | Purpose |
|--------|---------|
| asc-mcp | App Store Connect API (apps, builds, versions, reviews, screenshots) |
| aso-mcp | App Store Optimization (keywords, competitors, metadata) |
| atlassian | Jira + Confluence (local instance) |
| claude-in-chrome | Browser automation (clicks, fills, screenshots, GIFs) |
| docker | Container management |
| fetch | HTTP requests (imageFetch) |
| filesystem | File operations outside workspace |
| gdrive | Google Drive (search, read, write, share) |
| github | Repos, PRs, issues, code search |
| memory | Knowledge graph (entities, relations, observations) |
| notion | Notion pages, databases, comments |
| playwright | Browser automation (navigate, click, fill, screenshot, PDF) |
| postgres | SQL queries (read-only) |
| sequential-thinking | Complex multi-step reasoning |
| slack | Messages, channels, reactions, threads |

### Cloud (via Claude.ai integrations)
| Server | Purpose |
|--------|---------|
| Gmail | Search, read, draft emails |
| Google Calendar | Events, free time, meeting scheduling |
| Figma | Design screenshots, Code Connect, FigJam diagrams |
| Stripe | Customers, products, invoices, subscriptions, payments |
| PubMed | Article search, metadata, citations |

---

## Marketplace Skills (68 — installed via `npx skills`)

### Eronred ASO Pack (15 skills)
`aso-audit`, `aso-keyword-research`, `aso-competitor-analysis`, `metadata-optimization`, `screenshot-optimization`, `localization`, `app-launch`, `app-analytics`, `app-store-featured`, `review-management`, `retention-optimization`, `monetization-strategy`, `ua-campaign`, `ab-test-store-listing`, `app-marketing-context`

### Aaron-He-Zhu SEO + GEO Pack (21 skills)
`geo-content-optimizer`, `entity-optimizer`, `schema-markup-generator`, `rank-tracker`, `serp-analysis`, `backlink-analyzer`, `content-gap-analysis`, `content-quality-auditor`, `content-refresher`, `domain-authority-auditor`, `internal-linking-optimizer`, `keyword-research`, `competitor-analysis`, `meta-tags-optimizer`, `on-page-seo-auditor`, `performance-reporter`, `seo-content-writer`, `technical-seo-checker`, `alert-manager`, `memory-management`, `ai-seo`

### CoreyHaines Marketing Pack (32 skills)
`cold-email`, `email-sequence`, `programmatic-seo`, `copywriting`, `copy-editing`, `content-strategy`, `ad-creative`, `paid-ads`, `pricing-strategy`, `launch-strategy`, `referral-program`, `churn-prevention`, `marketing-ideas`, `marketing-psychology`, `product-marketing-context`, `competitor-alternatives`, `sales-enablement`, `revops`, `social-content`, `ab-test-setup`, `analytics-tracking`, `form-cro`, `page-cro`, `popup-cro`, `onboarding-cro`, `signup-flow-cro`, `paywall-upgrade-cro`, `free-tool-strategy`, `schema-markup`, `seo-audit`, `site-architecture`, `find-skills`

Location: `~/.agents/skills/`

---

## File Locations

| Type | Location |
|------|----------|
| Custom skill files (60) | `.claude/commands/*.md` |
| Hook scripts (18) | `~/.claude/hooks/*.sh` |
| Marketplace skills (68) | `~/.agents/skills/` |
| Trigger mappings | `.claude/MASTER.md` |
| Config pointer | `.claude/CLAUDE.md` |
| Session state | `.claude/state.md` |
| Hook config | `~/.claude/settings.json` → `hooks` key |
| Context saves | `.claude/context-saves/*.md` |

---

*Last updated: 2026-03-03 — full rewrite with verified counts*
