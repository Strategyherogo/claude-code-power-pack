# CLAUDE.md v5.0 - OPTIMIZED

**PRIMARY CONFIG:** `.claude/MASTER.md` (trigger mappings only)
**SKILL FILES:** `.claude/commands/` (full workflows, loaded on-demand)

---

## SYSTEM BEHAVIOR

### Automatic (No User Action)
- Session tracking: internal counter
- Every 10 sessions: health|sync|backup|analytics
- Context loading: TechConcepts|D&S|SelfOrg
- Trigger matching: always active

### Trigger Response
| Tier | Behavior |
|------|----------|
| 1-BLOCK | Stop, show gate, require acknowledge |
| 2-SUGGEST | Offer workflow, allow skip |
| 3-CONVENIENCE | Mention if relevant |

---

## SECURITY RULES (ENFORCED)

**NEVER do these without explicit approval:**
1. **Public gists/repos** - NEVER use `--public` flag. Code contains infrastructure details (hostnames, schemas, IDs)
2. **Expose credentials** - Never output passwords, API keys, tokens
3. **Public uploads** - Always ask before any public file sharing

**Safe sharing methods:**
- Private gist (no `--public` flag)
- Zip file for direct sharing (Slack DM, email)
- Private repo

**If user says "push" or "share":**
→ Default to private/local
→ Ask before making anything public

---

## WORKFLOW PREFERENCES (from Insights)

### External Platforms
When accessing external platforms (Jira Marketplace, Chrome Web Store, Atlassian, etc.):
1. **First** check `.env` and `~/.config` for stored API keys/tokens
2. **Prefer** CLI tools over web portal access:
   - Chrome: `chrome-webstore-upload-cli`
   - Atlassian: `atlas` CLI
   - npm: `npm publish`
3. **If no credentials found**, document what's needed and where to store them

### Information Retrieval
For searching past work or iterations:
1. Local search: `Glob` and `Grep` in project directories
2. Git history: `git log --oneline --all --grep=<term>`
3. Backup locations: `~/Dropbox`, `~/Documents`, cloud sync folders
4. Shell history: `~/.zsh_history` or `~/.bash_history`

### Credential Discovery Pattern
Before accessing any authenticated service:
```
1. Check .env files in project root
2. Check ~/.config/<service>/
3. Check environment variables
4. Check macOS Keychain: security find-generic-password -s "<service>"
5. If not found → document requirements for user
```

---

## QUICK TRIGGERS

**Blocking:** done|deploy|ship → gate
**Dev:** debug|test|build → workflow
**Content:** blog|tweet|linkedin → template
**Ops:** health|logs|env → check
**Productivity:** cs|focus|reflect → framework

---

## HOW IT WORKS

1. **On session start** - Read MASTER.md (~5KB) for trigger mappings
2. **When trigger matches** - Load specific skill file from commands/
3. **Project context** - Already in memory from attached projects
4. **Skill execution** - Follow workflow in loaded skill file

---

## FILES

| File | Purpose | Size |
|------|---------|------|
| MASTER.md | Trigger mappings, MCP list, project context | ~5KB |
| CLAUDE.md | This pointer file | ~1KB |
| commands/* | 139 skill files (loaded on-demand) | ~400KB |
| state.md | Session state | ~1KB |

---

## SKILL CATEGORIES (139 total)

- **Development (10):** debug, test, verify, plan, plan-or-do
- **Deployment (11):** deploy, health, logs, env, perf-test, gate
- **Content (9):** blog, tweet, newsletter, readme
- **Marketing (8):** landing, outreach, case-study
- **Productivity (13):** cs, focus, reflect, organize, secret-scan, lesson, checkpoint, handoff, status
- **Data (7):** db-query, gws-search, lookup, migration
- **Jira (6):** jira-quick, compliance-pack, monday
- **Swift (5):** async, memory, app-store, localize, workflow
- **PM (2):** feature-prioritize, roadmap
- **Email (4):** forensic, metadata, compliance, workflow
- **Bots (3):** slack, telegram, chrome
- **Agents (3):** code-review, project-analyzer, deploy-pipeline
- **Dev Tools (9):** scaffold, docker, git-flow, changelog, api-docs, fix-skills
- **Business Ops (7):** invoice, proposal, 1on1, standup, time-track
- **Automation (8):** morning-check, orchestrate, preflight, restore
- **Publishing (7):** publish, share-code, linkedin-carousel, seo-audit
- **Sales (13):** call-summary, forecast, pipeline, research, outreach, competitive-intel, create-asset, daily-briefing, draft-outreach

---

*v5.0 - Minimal core (~6KB loaded). Full workflows on-demand.*
