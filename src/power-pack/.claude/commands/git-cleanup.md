# Skill: git-cleanup
Clean up git across all workspace projects — prune merged branches, remove stale remotes, compact repos.

## Auto-Trigger
**When:** "git cleanup", "clean branches", "prune branches", "repo cleanup"

## Workflow

### Step 1: Scan All Projects
```bash
for dir in ~/ClaudeCodeWorkspace/"1. Projects"/*/; do
  if [ -d "$dir/.git" ]; then
    name=$(basename "$dir")
    echo "=== $name ==="

    cd "$dir"

    # Merged branches (safe to delete)
    merged=$(git branch --merged main 2>/dev/null | grep -v '^\*\|main\|master\|develop' | wc -l | tr -d ' ')

    # Stale remote tracking branches
    stale=$(git remote prune origin --dry-run 2>/dev/null | grep -c 'prune' || echo 0)

    # Repo size
    size=$(du -sh .git 2>/dev/null | cut -f1)

    echo "  Merged branches: $merged | Stale remotes: $stale | .git size: $size"
  fi
done
```

### Step 2: Clean (Per Project)
For each project with cleanup needed:

```bash
# Delete merged branches
git branch --merged main | grep -v '^\*\|main\|master\|develop' | xargs git branch -d

# Prune stale remote refs
git remote prune origin

# Compact (if .git > 100MB)
git gc --aggressive --prune=now
```

### Step 3: Report
```markdown
## Git Cleanup Report
| Project | Branches Deleted | Remotes Pruned | Space Saved |
|---------|-----------------|----------------|-------------|
| project-a | 3 | 1 | 12MB |
```

## Safety
- Only deletes branches already merged into main
- Never touches main, master, or develop
- Shows dry-run first, asks before executing
- Skips projects with uncommitted changes

---

*Last updated: 2026-02-07*
