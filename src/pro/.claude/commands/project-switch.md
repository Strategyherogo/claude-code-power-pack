# Skill: project-switch
Snapshot current project state and switch context to another project cleanly.

## Auto-Trigger
**When:** "switch to", "work on", "open project", "change project"

## Workflow

### Step 1: Snapshot Current State
```bash
# Save current project state
CURRENT=$(basename "$(pwd)")
BRANCH=$(git branch --show-current 2>/dev/null)
UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

echo "Current: $CURRENT (branch: $BRANCH, $UNCOMMITTED uncommitted files)"
```

If uncommitted files > 0, offer:
1. `git stash push -m "project-switch-$(date +%H%M)"`
2. `git commit -m "WIP: switching to [target]"`
3. Leave as-is

### Step 2: Switch
```bash
cd ~/ClaudeCodeWorkspace/"1. Projects"/[TARGET_PROJECT]
git status --short
```

### Step 3: Load Context
- Read project's README.md or CLAUDE.md if present
- Show recent git log (last 5 commits)
- Show any stashed work: `git stash list`
- Check for open TODO items

### Available Projects
```bash
ls -1 ~/ClaudeCodeWorkspace/"1. Projects"/
```

## Quick Switch
For rapid switching without full context load:
```
/project-switch YOUR_PROJECT
```
Just stash + cd + branch info.

---

*Last updated: 2026-02-07*
