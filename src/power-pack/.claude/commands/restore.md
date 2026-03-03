# Skill: restore
Resume work from a previous context-save file. Restores working state and shows next steps.

## Auto-Trigger
**When:** "restore", "resume", "continue", "where was I", "pick up", "last session", "what was I doing"

## Overview
Reads the most recent (or specified) context-save file and restores the working environment. Prevents context loss between multi-session projects.

---

## Restore Workflow

### Step 1: Find Context Save
```bash
echo "=== AVAILABLE CONTEXT SAVES ==="
# List recent context saves, newest first
ls -lt ~/ClaudeCodeWorkspace/context-saves/*.md 2>/dev/null | head -10

echo ""
echo "Most recent:"
LATEST=$(ls -t ~/ClaudeCodeWorkspace/context-saves/*.md 2>/dev/null | head -1)
echo "  $LATEST"
echo ""
echo "Last 5 sessions:"
ls -t ~/ClaudeCodeWorkspace/context-saves/*.md 2>/dev/null | head -5 | while read f; do
  echo "  $(basename "$f"): $(head -1 "$f" 2>/dev/null)"
done
```

**Ask user:** "Restore from most recent, or specify which session?"

### Step 2: Read and Parse Context
Read the selected context-save file and extract:

```markdown
From the context-save file, identify and display:

1. **What was accomplished** (the completed items)
2. **What was in progress** (uncommitted/incomplete items)
3. **Next steps** (the planned next tasks)
4. **Blockers** (any issues that were hit)
5. **Key decisions** (so we don't re-decide)
6. **Restoration commands** (to set up the environment)
```

### Step 3: Restore Environment
Run the restoration commands from the context-save:

```bash
# Navigate to the project
cd ~/ClaudeCodeWorkspace/[project-from-context]

# Check current git state
echo "=== CURRENT STATE ==="
git branch --show-current
git status --porcelain | head -10
git stash list | head -3

# Check if there's a stash from the saved session
STASH=$(git stash list | grep "$(date -v-1d +%Y%m%d)\|$(date +%Y%m%d)" | head -1)
[ -n "$STASH" ] && echo "⚠️  Found stash from this/yesterday's session: $STASH"

# Verify files from context still exist
echo ""
echo "=== FILE STATUS ==="
# Check each file mentioned in context-save
```

### Step 4: Present Resume Plan
Show the user a clear "here's where you left off" summary:

```markdown
## Resuming: [Session Label from Context Save]

### Where You Left Off
[Summary from context-save accomplished section]

### Still In Progress
[Items from context-save that were incomplete]

### Your Planned Next Steps
[From context-save next session section]

### Current State
- Branch: [branch name]
- Uncommitted changes: [count]
- Stashes available: [list if any]

### Suggested Action
1. [First next step from context]
2. [Second next step]

Ready to continue? Which task should we start with?
```

---

## Quick Restore (no questions)
Automatically load the most recent context-save and jump straight to the next steps:

```bash
LATEST=$(ls -t ~/ClaudeCodeWorkspace/context-saves/*.md 2>/dev/null | head -1)
if [ -n "$LATEST" ]; then
  echo "Restoring from: $(basename "$LATEST")"
  cat "$LATEST"
else
  echo "No context saves found."
fi
```

---

## Restore by Project
If the user names a project, find the most recent context-save for that project:

```bash
PROJECT="$1"  # e.g., "battery", "jira", "chrome"
echo "Finding context saves for: $PROJECT"
ls -t ~/ClaudeCodeWorkspace/context-saves/*.md 2>/dev/null | while read f; do
  grep -qi "$PROJECT" "$f" && echo "  $(basename "$f")" && break
done
```

---

## Edge Cases
- **No context-save found:** Run `/morning-check` instead, show project status
- **Stale context-save (>7 days):** Warn user, suggest running `/morning-check` first
- **Multiple projects in one context-save:** Ask which project to focus on
- **Git state changed since save:** Show diff and ask user to reconcile

---

## Related Skills
- `/save` - Create a context-save (the inverse of restore)
- `/cs` - Full check & save menu
- `/morning-check` - When no context-save exists

---
Last updated: 2026-02-06
