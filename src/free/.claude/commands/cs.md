# Skill: cs (Session Start)
Quick session briefing — where you left off, what's unfinished, what to do next.

## Auto-Trigger
**When:** "cs", "start session", "what's going on", "where was I"

## Workflow (no menu — just do it)

### Step 1: Gather State (run ALL in parallel)

**A) Git status:**
```bash
git -C ~/ClaudeCodeWorkspace status --short | head -15
git -C ~/ClaudeCodeWorkspace branch --show-current
git -C ~/ClaudeCodeWorkspace log --oneline -5
```

**B) Latest context save (first 60 lines only):**
```bash
LATEST=$(ls -t ~/ClaudeCodeWorkspace/context-saves/*.md 2>/dev/null | head -1)
```
Read first 60 lines of this file (do NOT cat the whole thing).

**C) Multi-session scan (subagent):**
Spawn a Task subagent (model: haiku) to scan recent context saves:

```
Scan the 10 most recent .md files in ~/ClaudeCodeWorkspace/context-saves/ (by modification time).

For each file, read first 50 lines. If it contains session markers ("Accomplished", "Next Steps",
"Working on", "Left off", "Blockers", "In Progress"), extract:
- Date (from filename)
- Label (from first heading)
- Status: Done / Partial / Blocked
- Key outcome (1 sentence)
- Any unchecked [ ] items

Skip files without session markers (reference docs, business context).

Return EXACTLY:
## Sessions (X found, Y skipped)
| Date | Session | Status | Outcome |
(newest first, max 8 rows)

## Unfinished Items
| Item | From | Age |
(only [ ] unchecked items, oldest first)
```

### Step 2: Show Briefing

Present this concise dashboard — no follow-up questions, just show it:

```markdown
## Session Briefing — [date]

**Last session:** [label] — [age] ago
- [what was accomplished]
- Left off: [current state]

**Unfinished** (oldest first):
- [ ] [item] — from [session], [age] ago
- [ ] [item] — from [session], [age] ago

**Workspace:** `[branch]` — [N] uncommitted — last commit: `[hash]` [message]

**Suggested next:**
1. [oldest unfinished item or latest session's next step]
2. [second priority]
```

Then just say: "What would you like to work on?"

### Rules
- Never read whole context saves into main context — always subagent
- If file >200 lines: read first 80 + grep for markers
- Total output < 30 lines
- No menus, no multiple-choice — just the briefing
- For health checks → tell user to run `/commands:system-health`
- For saving → tell user to run `/commands:save`

---

*Last updated: 2026-02-07*
