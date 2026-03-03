---
name: workspace-automation
description: Automated workspace management with session tracking, auto-triggers, and workflow orchestration. Use when starting a new session, when keywords trigger workflows (debug, deploy, done, blog, jira, test, etc.), when checking health/status, or when needing project context. Triggers on session start, every 10 sessions for maintenance, and whenever trigger keywords appear in conversation.
---

# Workspace Automation

Session-based automation with keyword triggers, project context, and MCP integration.

## Auto-Execution Protocol

### Session Start (Every Session)
1. Increment session counter via `scripts/session_tracker.py start`
2. Load active project context from [references/projects.md](references/projects.md)
3. Check if maintenance triggers (every 10 sessions)
4. Arm keyword triggers

### Maintenance (Every 10 Sessions)
- Run health checks via `scripts/health_check.py`
- Verify workspace integrity
- Log to session protocol

## Trigger System

### Tier 1: Blocking Gates
Stop workflow, require acknowledgment:

| Keywords | Gate | Checklist |
|----------|------|-----------|
| done, fixed, complete | Verify | Tests, edge cases, docs, reviewed, committed |
| deploy, production, release | Deploy | Env vars, migrations, flags, rollback, monitoring |
| ship it | Quick Deploy | Service, smoke test, notify |

### Tier 2: Suggestions
Offer workflow, allow skip:

| Keywords | Workflow |
|----------|----------|
| debug, error, broken | reproduce → isolate → hypothesize → fix → prevent |
| test, tdd | red → green → refactor |
| blog, article | topic → outline → draft → edit → SEO → publish |
| jira, ticket | create/update/transition/comment |
| health, status | endpoint + command checks |
| cs, done for today | context save template |

Full trigger list: [references/triggers.md](references/triggers.md)

## Scripts

### Session Tracker
```bash
python3 scripts/session_tracker.py start   # New session
python3 scripts/session_tracker.py status  # Current state
```

### Health Check
```bash
python3 scripts/health_check.py            # Default checks
python3 scripts/health_check.py config.json # Custom config
```

## References

| File | Content |
|------|---------|
| [triggers.md](references/triggers.md) | Complete trigger-workflow mappings |
| [workflows.md](references/workflows.md) | Step-by-step workflow templates |
| [mcp-config.md](references/mcp-config.md) | MCP server configs and patterns |
| [projects.md](references/projects.md) | TechConcepts, D&S, SelfOrg context |
| [skills-catalog.md](references/skills-catalog.md) | **612 skills** indexed from resources |

## Skill Catalog (612 Skills)

Full catalog in [references/skills-catalog.md](references/skills-catalog.md).
Source: `3. Resources/CONSOLIDATED-RESOURCES.txt` (18MB, 1012 files)

### Quick Skill Lookup by Task

| Task Type | Skills |
|-----------|--------|
| Testing | `tdd`, `test-loop`, `test-coverage`, `smoke-test` |
| Debugging | `smart-debug`, `systematic-debug`, `bug-detective` |
| Deployment | `deploy`, `cloudflare-deploy`, `release-notes` |
| API Dev | `api-scaffold`, `api-mock`, `api-security-audit` |
| Content | `blog-post`, `newsletter`, `linkedin-post` |
| Project Mgmt | `sprint-planning`, `sync-issues-to-linear` |
| Code Quality | `architecture-review`, `tech-debt`, `audit` |
| AI/ML | `ai-agent-create`, `ai-review`, `ai-monitoring-setup` |

### Skill-to-MCP Mapping

| MCP Server | Relevant Skills |
|------------|-----------------|
| atlassian | sync-issues-to-linear, sprint-planning |
| playwright | browser-test, e2e-test |
| postgres | sql-query-builder, stored-proc |
| cloudflare | cloudflare-deploy, workers |
| github | sync-pr-to-task, changelog |

## Project Quick Reference

- **TechConcepts**: AI consulting, €5-15k/mo, NEPS, podcast
- **D&S**: MCP servers, Mac apps, Chrome extensions, Cloudflare Workers
- **SelfOrg**: Neuroperformance DB (621 days), HRV/stress/energy metrics
