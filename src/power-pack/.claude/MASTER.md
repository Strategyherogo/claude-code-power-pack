# CLAUDE MASTER CONFIG v7.0
# Compact trigger mappings — 46 active skills in commands/

---

## AUTO-EXEC (Every Session)
- Increment session counter
- Load context: YourCompany | D&S | SelfOrg
- Check pending from last session
- Arm triggers below

## AUTO-RUN (Every 10 Sessions)
- Health check services
- Verify skills intact
- Backup .claude/ and scripts/

---

# TRIGGERS

## Tier 1: BLOCKING (gate required)
- done | fixed | complete | resolved → `/gate`

## Tier 2: SUGGEST (offer, allow skip)

### Dev
- plan | approach | how should → `/plan-or-do`
- test | test suite | run tests → `/test-suite`
- api test | endpoint test → `/api-test`
- git cleanup | prune branches → `/git-cleanup`

### Ops
- health | status | is it up → `/infra-health`
- update | packages | maintenance | pkg → `/morning-check`
- system health | service check → `/system-health`
- find credentials | discover auth → `/cred-discover`

### Content & Marketing
- carousel | make slides → `/linkedin-carousel`
- linkedin | linkedin post → `/linkedin-post`
- blog | article | write post → `/c2c:blog`
- newsletter | email newsletter → `/c2c:newsletter`
- product launch | announcement → `/c2c:product-launch`
- landing | copy | sales page → `/landing-copy`
- case study | success story → `/case-study`
- content brief | content plan → `/content-brief`
- marketing assets | brand → `/marketing-assets`
- seo audit | meta tags → `/seo-audit`
- research company | account research | who is → `/sales:account-research`
- competitive intel | competitor | battlecard → `/sales:competitive-intel`
- sales asset | create deck | one-pager → `/sales:create-asset`
- draft outreach | prospect email | reach out → `/sales:draft-outreach`

### Productivity
- cs | context save | done for today → `/cs`
- save | checkpoint | end session → `/save`
- wrap | wrap up | finish session → `/wrap`
- handoff | pass to next session | brief next → `/handoff`
- restore | resume | where was I | last session → `/restore`
- preflight | feasibility | check first → `/preflight`
- session review → `/session-retro`
- retrospective | post-mortem → `/retro`
- lesson | lessons learned → `/lesson`

### Data & Integration
- validate data | check format | data quality → `/data-validate`
- find credentials | discover auth → `/cred-discover`
- publish | release to store → `/publish`
- jira | ticket | issue → `/jira-quick`
- pdf report | generate report → `/report-pdf`
- monday | monday.com → `/monday`
- forensic | investigation → `/forensic-parallel`

### App Store / Swift
- app store | submission | review → `/swift:app-store-prep`
- app store pipeline | ship apps → `/app-store-pipeline`
- rejection | rejected app | resolution center → `/asc-rejection`
- upload build | archive and upload | build pipeline → `/asc-build-upload`
- localize | i18n | translate app → `/swift:localize-bulk`
- ux patterns | swiftui | swift ui → `/swift:ux-patterns`
- swift full cycle | build and ship → `/swift:full-cycle`
- aso | keywords | app store optimization → `/aso`

### Maintenance
- auto maintain | cleanup → `/auto-maintain`
- debug prune | cleanup claude → `/debug-prune`
- fix skills | repair → `/fix-skills`
- full review | deep audit → `/full-review`
- multi project status → `/multi-project-status`
- project switch → `/project-switch`

## Tier 3: CONVENIENCE (mention if relevant)
- skill list | all skills → `/SKILL-INDEX`
- quick ref | commands → `/quick-ref`

---

# CONTEXT

## MCP Servers
atlassian · playwright · slack · postgres · fetch · sequential-thinking · gdrive · notion · github · memory · docker · filesystem · k6-load-test · Canva · claude-in-chrome

## MCP Auto-Hint (hook: auto-mcp-suggest.sh)
Keywords in user prompt auto-suggest the right MCP tool:
- pr/repo/github/issue → `mcp__github`
- slack/channel/dm/thread → `mcp__slack`
- drive/gdrive/doc → `mcp__gdrive`
- jira/confluence/sprint → `mcp__atlassian`
- notion/wiki → `mcp__notion`
- database/query/sql → `mcp__postgres`
- remember/recall/context → `mcp__memory`
- docker/container → `mcp__docker`
- projects/directory → `mcp__filesystem`
- screenshot/browse/navigate → `mcp__playwright` / `mcp__claude-in-chrome`

## Projects
- **YourCompany** — Consulting (AI automation, predictive models, NEPS)
- **D&S** — Apps Factory (MCP servers, utilities, workers)
- **SelfOrg** — Neuroperformance (biometrics DB, ANS optimization)

## Data Rules
- **Privacy policy URL for ALL apps: `yourdomain.org/{project}/privacy` — NEVER `YOUR_COMPANY.com`**
- Never delete lessons, logs, or records — archive instead
- Logs → `output/archive-logs/` · Lessons → `3. Resources/02-iterations/lessons/archive/`
- Dropbox: verify full paths, check file dates, restore ASAP (archives get cleaned up)

## Session Log Format
`[TIME] [OP] [PATH] [DETAIL]` — Ops: `+` create · `~` modify · `-` delete · `>` exec · `?` read · `!` error · `✓` ok

---

*v7.0 — Pruned 151→46 skills. Trigger mappings match active commands/ only. Archived in .claude/skills-archive/*
