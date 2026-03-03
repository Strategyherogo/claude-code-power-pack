# CLAUDE MASTER CONFIG v6.0
# Compact trigger mappings — workflows in commands/

---

## AUTO-EXEC (Every Session)
- Increment session counter
- Load context: TechConcepts | D&S | SelfOrg
- Check pending from last session
- Arm triggers below

## AUTO-RUN (Every 10 Sessions)
- Health check services
- Verify skills intact
- Backup .claude/ and scripts/

---

# TRIGGERS

## Tier 1: BLOCKING (gate required)
- done | fixed | complete | resolved → `/verify`
- deploy | production | release | live → `/deploy-verify`
- ship it | quick deploy → `/quick-deploy`

## Tier 2: SUGGEST (offer, allow skip)

### Dev
- debug | broken | error | not working | bug → `/systematic-debug`
- trace | root cause | why → `/root-trace`
- test | tdd | test-first → `/tdd`
- build | compile | won't build → `/build-test`
- edge case | boundary | what if → `/edge-test`
- plan | approach | how should → `/write-plan`
- parallel | concurrent | multiple agents → `/parallel-agents`
- brainstorm | ideas | options → `/brainstorm`
- git flow | feature branch | release branch → `/git-flow`
- commit message | conventional commit → `/commit-msg`
- scaffold | boilerplate | create project → `/scaffold`
- docker | dockerfile | container → `/docker`
- migration | database migration | schema → `/migration`
- api docs | swagger | openapi → `/api-docs`
- release notes | what changed → `/release-notes`
- changelog | update changelog → `/changelog`
- dependency audit | outdated packages | npm audit → `/dependency-audit`
- perf test | load test | benchmark → `/perf-test`
- secret scan | find secrets | leaked credentials → `/secret-scan`
- decision log | adr | architecture decision → `/decision-log`
- code review | PR review → `/agent:code-review`
- analyze project | project structure → `/agent:project-analyzer`
- deploy pipeline | CI/CD → `/agent:deploy-pipeline`

### Ops
- health | status | is it up → `/infra-health`
- update | packages | maintenance | pkg → `/morning-check`
- errors | logs | what went wrong → `/log-errors`
- env | secrets | environment → `/env-sync`
- ir deploy | email monitor → `/deploy-ir`
- test alert | alerting → `/alert-test`
- cloudflare worker | cf deploy → `/deploy:cloudflare-worker`

### Content
- blog | article | write post → `/c2c:blog`
- quick blog | short post → `/c2c:quick-blog`
- tweet | thread | twitter → `/c2c:twitter`
- linkedin | linkedin post → `/linkedin-post`
- carousel | make slides → `/linkedin-carousel`
- newsletter | email newsletter → `/c2c:newsletter`
- video script | youtube → `/c2c:video-script`
- readme | documentation → `/c2c:readme`
- tutorial | how-to guide → `/c2c:tutorial`
- product launch | announcement → `/c2c:product-launch`
- conference | talk | presentation → `/c2c:conference-talk`
- podcast | episode prep | show notes → `/podcast-prep`

### Marketing & Sales
- landing | copy | sales page → `/landing-copy`
- case study | success story → `/case-study`
- demo script | product demo → `/demo-script`
- content brief | content plan → `/content-brief`
- marketing assets | brand → `/marketing-assets`
- website design | mockup → `/design-website`
- seo audit | meta tags → `/seo-audit`
- call summary | meeting notes | call notes → `/sales:call-summary`
- forecast | quota | pipeline forecast → `/sales:forecast`
- pipeline review | deal review → `/sales:pipeline-review`
- research company | account research | who is → `/sales:account-research`
- call prep | meeting prep → `/sales:call-prep`
- competitive intel | competitor | battlecard → `/sales:competitive-intel`
- sales asset | create deck | one-pager → `/sales:create-asset`
- morning briefing | daily briefing → `/sales:daily-briefing`
- draft outreach | prospect email | reach out → `/sales:draft-outreach`

### Business
- invoice | bill client | billing → `/invoice`
- new client | onboard client → `/client-onboard`
- proposal | quote | SOW → `/proposal`
- log time | track time | billable hours → `/time-track`
- standup | daily standup | scrum → `/standup`
- 1 on 1 | one on one | 1:1 → `/1on1`
- retrospective | post-mortem → `/retro`

### Productivity
- cs | context save | done for today → `/cs`
- save | checkpoint | end session → `/save`
- wrap | wrap up | finish session → `/wrap`
- handoff | pass to next session | brief next → `/handoff`
- restore | resume | where was I | last session → `/restore`
- preflight | feasibility | check first → `/preflight`
- focus | deep work → `/focus`
- reflect | lessons learned → `/reflect`
- workspace audit | cleanup → `/workspace-audit`
- organize | structure → `/organize`
- archive | old files → `/archive`
- analyze logs | session analysis → `/log-analysis`
- session review → `/session-retro`
- weekly review | ops review → `/weekly-ops-review`
- orchestrate | run workflow | automate → `/orchestrate`

### Data & Integration
- query | sql | database → `/db-query`
- lookup | search data → `/lookup`
- validate data | check format | data quality → `/data-validate`
- gmail search | drive search | gws → `/gws-search`
- email report | gws report → `/gws-email-report`
- credentials | cred map → `/cred-map`
- find credentials | discover auth → `/cred-discover`
- publish | release to store → `/publish`
- jira | ticket | issue → `/jira-quick`
- jira comments | check comments → `/jira-comment-check`
- duplicates | dedup → `/dedup-check`
- compliance | security audit → `/compliance-pack`
- pdf report | generate report → `/report-pdf`
- email | compose → `/mail`
- monday | monday.com → `/monday`

### Domain-Specific
- swift async | await | MainActor → `/swift:async-troubleshoot`
- swift memory | leaks | instruments → `/swift:debug-memory`
- app store | submission | review → `/swift:app-store-prep`
- rejection | rejected app | resolution center → `/asc-rejection`
- upload build | archive and upload | build pipeline → `/asc-build-upload`
- localize | i18n | translate app → `/swift:localize`
- feature priority | RICE | scoring → `/pm:feature-prioritize`
- roadmap | product roadmap → `/pm:roadmap-build`
- email forensic | investigation → `/email:forensic-workflow`
- email metadata | headers → `/email:metadata-extract`
- email compliance report → `/email:compliance-report`
- slack bot | slack debug → `/bot:slack-debug`
- telegram bot | telegram debug → `/bot:telegram-debug`
- chrome extension | extension debug → `/chrome:extension-debug`
- hrv | stress | energy | neuro → `/neuro:daily-check`
- weekly neuro | hrv summary → `/neuro:weekly-report`
- build mcp | create mcp server → `/mcp:build`

## Tier 3: CONVENIENCE (mention if relevant)
- create skill | new skill → `/make-skill`
- skill list | all skills → `/SKILL-INDEX`
- mcp servers | recommended mcp → `/mcp:recommended-servers`

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
- **TechConcepts** — Consulting (AI automation, predictive models, NEPS)
- **D&S** — Apps Factory (MCP servers, utilities, workers)
- **SelfOrg** — Neuroperformance (biometrics DB, ANS optimization)

## Data Rules
- Never delete lessons, logs, or records — archive instead
- Logs → `output/archive-logs/` · Lessons → `3. Resources/02-iterations/lessons/archive/`
- Dropbox: verify full paths, check file dates, restore ASAP (archives get cleaned up)

## Session Log Format
`[TIME] [OP] [PATH] [DETAIL]` — Ops: `+` create · `~` modify · `-` delete · `>` exec · `?` read · `!` error · `✓` ok

---

*v6.0 — Compact triggers. Full workflows in commands/*
