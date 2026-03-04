# Skill: multi-project-status
Scan all workspace projects for uncommitted work, stale branches, and overall health.

## Auto-Trigger
**When:** "project status", "all projects", "workspace status", "what's open"

## Workflow

### Full Scan
```bash
echo "=== Workspace Project Status ==="
echo ""

for dir in ~/ClaudeCodeWorkspace/"1. Projects"/*/; do
  [ ! -d "$dir/.git" ] && continue

  name=$(basename "$dir")
  branch=$(git -C "$dir" branch --show-current 2>/dev/null || echo "detached")
  uncommitted=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  stashes=$(git -C "$dir" stash list 2>/dev/null | wc -l | tr -d ' ')
  last_commit=$(git -C "$dir" log -1 --format="%cr" 2>/dev/null || echo "never")
  branches=$(git -C "$dir" branch 2>/dev/null | wc -l | tr -d ' ')

  # Status icon
  if [ "$uncommitted" -gt 0 ]; then
    icon="!!"
  elif [ "$branch" != "main" ] && [ "$branch" != "master" ]; then
    icon=">>"
  else
    icon="ok"
  fi

  echo "[$icon] $name"
  echo "     branch: $branch | uncommitted: $uncommitted | stashes: $stashes | branches: $branches"
  echo "     last commit: $last_commit"
  echo ""
done
```

### Report Format
```
[!!] YOUR_PROJECT
     branch: feat/oauth | uncommitted: 3 | stashes: 1 | branches: 4
     last commit: 2 hours ago

[ok] YOUR_PROJECT
     branch: main | uncommitted: 0 | stashes: 0 | branches: 2
     last commit: 3 days ago

[>>] 21-jira-ai-classifier
     branch: feature/panel | uncommitted: 0 | stashes: 0 | branches: 5
     last commit: 1 week ago
```

### Legend
- `!!` — Has uncommitted changes (needs attention)
- `>>` — On a feature branch (work in progress)
- `ok` — Clean on main

### Actions
After scan, suggest:
- Projects with uncommitted work → offer to commit/stash
- Projects with stale feature branches (>7 days) → offer cleanup
- Projects not touched in 30+ days → flag for archiving

---

*Last updated: 2026-02-07*
