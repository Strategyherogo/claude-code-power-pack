# Skill: full-review
One command to clean, review, fix, reflect, and prioritize. The complete system maintenance + strategy session.

## Auto-Trigger
**When:** "full review", "full maintenance", "review everything", "deep review", "weekly review"

## Workflow (fully automated — just run it)

### Phase 1: System Cleanup (parallel, ~30s)
Run `~/.claude/scripts/cleanup.sh` to clear caches, old backups, stale downloads, temp files.
Show the summary line (total MB freed).

### Phase 2: Code Review (parallel agents, ~2min)
Launch 2 agents in parallel:

**Agent A — Security + Hooks:**
```
Scan all .sh files in ~/.claude/hooks/ and all .py/.sh files in ~/ClaudeCodeWorkspace/scripts/ for:
- Hardcoded secrets (API keys, tokens, passwords in source)
- Command injection (shell=True, eval, unquoted variables)
- Hardcoded paths ($HOME instead of $HOME)
- Race conditions (non-atomic lock patterns)
- Broken references (scripts that call missing files)
Return: table of findings with severity, file, line, issue. If clean, say "All clear".
```

**Agent B — Skill Catalog:**
```
Count actual skill files: ls ~/ClaudeCodeWorkspace/.claude/commands/*.md | wc -l
Count sales skills: find ~/ClaudeCodeWorkspace/.claude/commands/sales/ -name "*.md" | wc -l
Check CLAUDE.md and SKILL-INDEX.md counts match actual.
Check MASTER.md for broken trigger references (skills referenced but file doesn't exist).
Return: list of mismatches. If clean, say "Catalog in sync".
```

### Phase 3: Auto-Fix
For any issues found in Phase 2:
- Fix hardcoded paths → `$HOME`
- Fix missing timestamps → add `Last updated: [today]`
- Fix count mismatches → update numbers
- Flag but DON'T auto-fix: secrets (need manual revocation), structural changes

### Phase 4: 7-Session Retrospective (subagent)
Spawn a Task subagent (model: haiku):
```
Scan the 7 most recent .md files in ~/ClaudeCodeWorkspace/context-saves/ (by modification time).
For each file, read first 80 lines and extract:
- Date and session label
- What was accomplished (1-2 sentences)
- What was left unfinished (unchecked [ ] items)
- Any recurring patterns or frustrations

Return EXACTLY:
## Last 7 Sessions
| Date | Session | Accomplished | Left Open |
(newest first)

## Patterns
- [recurring theme 1]
- [recurring theme 2]

## Friction Points
- [repeated struggle or time sink]
```

### Phase 5: Revenue & Priority Analysis (subagent)
Spawn a Task subagent (model: sonnet):
```
Read these files for business context:
- ~/ClaudeCodeWorkspace/context-saves/ (latest 3 files, first 60 lines each)
- ~/ClaudeCodeWorkspace/.claude/MASTER.md (project list section)
- ls ~/ClaudeCodeWorkspace/1.\ Projects/ (list active projects)

Based on what you find, answer:
1. **Where is the money?** — Which projects/activities are closest to generating revenue?
2. **What's burning time?** — Which activities consumed the most sessions but aren't revenue-generating?
3. **Quick wins** — What could ship in 1-2 sessions that has business value?
4. **Stop doing** — What should be deprioritized or archived?

Format as:
## Revenue Focus
| Priority | Project/Activity | Why | Next Action |
(max 5 rows, ranked by $ potential)

## Time Sinks (consider stopping)
- [activity]: [why it's a sink]

## Quick Wins (ship this week)
1. [win] — [effort estimate]
2. [win] — [effort estimate]
```

### Phase 6: Dashboard Output
Combine all phases into one clean output:

```markdown
## Full Review — [date]

### Cleanup
[total MB freed] | [items cleaned]

### Code Health
[N issues found / all clear] | [N auto-fixed]

### Last 7 Sessions
| Date | Session | Accomplished | Left Open |
...

### Patterns & Friction
- [pattern 1]
- [friction point 1]

### Revenue Focus
| Priority | Project | Why | Next Action |
...

### Quick Wins
1. [win 1]
2. [win 2]

### Suggested Next Session
→ [highest-impact action based on all the above]
```

### Rules
- Total runtime target: <3 minutes
- Use parallel agents wherever possible
- Never read full files into main context — always subagent
- Auto-fix safe issues, flag dangerous ones
- Business analysis should be blunt and honest — no padding
- End with ONE clear recommendation for what to do next

---

Last updated: 2026-02-07
