# Skill: status
Cross-project progress dashboard — see all in-progress work in one view.

## Auto-Trigger
**When:** "status", "what's open", "what am I working on", "open items", "progress", "dashboard"

---

## Status Dashboard Workflow

### Step 1: Scan All Sources (run in parallel)

**A) Project iteration files:**
```bash
# Find all iterations with non-complete status
for dir in ~/ClaudeCodeWorkspace/"1. Projects"/*/iterations/; do
  [ -d "$dir" ] || continue
  project=$(basename "$(dirname "$dir")")
  for f in "$dir"*.md; do
    [ -f "$f" ] || continue
    status=$(grep -i "status:" "$f" | head -1)
    echo "$project|$(basename "$f")|$status"
  done
done
```

**B) Context saves with open items:**
```bash
# Find context saves with unchecked items (next steps)
for f in ~/ClaudeCodeWorkspace/context-saves/*.md; do
  [ -f "$f" ] || continue
  unchecked=$(grep -c "^\- \[ \]" "$f" 2>/dev/null)
  [ "$unchecked" -gt 0 ] && echo "$(basename "$f")|$unchecked open items"
done
```

**C) Git uncommitted across projects:**
```bash
for dir in ~/ClaudeCodeWorkspace/"1. Projects"/*/; do
  [ -d "$dir/.git" ] || continue
  name=$(basename "$dir")
  changes=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  [ "$changes" -gt 0 ] && echo "$name|$branch|$changes files"
done
```

**D) Stale context saves:**
```bash
# Saves older than 7 days with open items
find ~/ClaudeCodeWorkspace/context-saves/ -name "*.md" -mtime +7 -exec grep -l "\- \[ \]" {} \;
```

### Step 2: Generate Dashboard

```markdown
## 📊 Status Dashboard — [DATE]

### In-Progress Projects
| Project | Status | Blocker | Last Activity | Next Action |
|---------|--------|---------|---------------|-------------|
| [project] | [status] | [blocker or —] | [date] | [next step] |

### Uncommitted Work
| Project | Branch | Files | Age |
|---------|--------|-------|-----|
| [project] | [branch] | [count] | [last modified] |

### Open Items (from context saves)
| Save File | Open Items | Age |
|-----------|------------|-----|
| [filename] | [count] | [days] |

### Stale Items (>7 days, needs decision)
| Item | Age | Action Needed |
|------|-----|---------------|
| [item] | [days] | Close / Resume / Archive |

### Summary
- **Active projects:** [count]
- **Total open items:** [count]
- **Uncommitted files:** [count across all projects]
- **Stale items:** [count needing attention]
```

### Step 3: Offer Actions

```
What would you like to do?
  1) Work on [highest priority item]
  2) Close stale items
  3) Commit uncommitted work
  4) View specific project details
  5) Continue with current task
```

---

## Quick Status Mode

When invoked as part of `/cs` Option 5 or session start, show condensed version:

```markdown
📊 [X] active projects | [Y] open items | [Z] uncommitted files
Top priority: [most urgent item from context saves]
```

---

## Related Skills
- `/cs` — includes quick status as Option 5
- `/restore` — resume a specific project
- `/morning-check` — daily health check (different focus)
- `/organize` — if status reveals organizational issues

---
Last updated: 2026-02-07
