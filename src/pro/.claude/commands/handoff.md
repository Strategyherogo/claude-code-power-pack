# Skill: handoff
Session end auto-package — generate a single structured handoff file instead of exporting raw transcripts.

## Auto-Trigger
**When:** "handoff", "wrap up", "closing out", "switching context", context window getting full

## Why This Exists
Past pattern: 5-13 transcript versions exported per session trying to preserve context. Creates noise, not signal. This skill produces ONE structured file that `/restore` can consume directly.

---

## Handoff Workflow

### Step 1: Auto-Gather (no user input needed)

Run all in parallel:
```bash
# A) Git state
DATE=$(date +%Y-%m-%d)
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
git log --oneline --since="2 hours ago" 2>/dev/null | head -10
git diff --stat HEAD 2>/dev/null | tail -5
git status --porcelain 2>/dev/null | head -15

# B) Check all projects for uncommitted work
for dir in ~/ClaudeCodeWorkspace/"1. Projects"/*/; do
  changes=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  [ "$changes" -gt 0 ] && echo "$(basename "$dir"): $changes uncommitted"
done

# C) Active task list (if any)
# Read current TaskList state
```

### Step 2: Generate Handoff File

Write to `context-saves/[DATE]-[auto-label].md`:

```markdown
## Handoff: [DATE] - [auto-generated label from git log]

### Status: [COMPLETE / IN-PROGRESS / BLOCKED]

### What Was Done
[Auto-generate from git log --since="2 hours ago"]
- [x] [commit message 1]
- [x] [commit message 2]
- [ ] [uncommitted changes summary]

### Key Files Changed
[Auto-generate from git diff --stat, top 10 files]
- `path/to/file`: [one-line description from diff]

### Current State
- Branch: `[branch]`
- Uncommitted: [count] files
- Build status: [if recently built]
- Blockers: [any known blockers]

### Next Session: Do This First
1. [Most important next action — be specific with commands]
2. [Second priority]
3. [Third priority]

### Decisions Made This Session
[Extract from conversation — key architectural or approach decisions]

### Restoration
```bash
cd ~/ClaudeCodeWorkspace
git checkout [branch]
# [any other setup commands]
```
```

### Step 3: Ask Only What Can't Be Auto-Detected

Only ask the user (max 2 questions):
1. "Any blockers or dead ends to note?" (skip if none obvious)
2. "What's the #1 priority for next session?" (skip if obvious from task list)

### Step 4: Offer Code Save
```
Uncommitted changes detected:
  1) Commit with WIP message
  2) Stash
  3) Leave as-is
```

### Step 5: Confirm
```
✅ Handoff saved: context-saves/[DATE]-[label].md
   Next session: run /restore to resume
   Uncommitted: [count] files in [branch]
```

---

## Auto-Label Generation

Generate the label from the most recent git activity:
- If commits exist: use the most common noun from commit messages
- If no commits: use the primary file directory being edited
- Examples: `monday-dashboard-build`, `vertex-ai-integration`, `lesson-consolidation`

---

## What This Replaces

| Old Pattern | New Pattern |
|---|---|
| Export transcript → 5-13 .txt versions | One `/handoff` file |
| Manual context writing | Auto-generated from git |
| Forget to save | Triggered by "end session" keyword |
| `/restore` can't find what to load | Standardized format in context-saves/ |

## Related Skills
- `/save` — simpler version (this is the enhanced replacement)
- `/restore` — reads handoff files to resume
- `/cs` — menu-based, includes this as option

---
Last updated: 2026-02-07
