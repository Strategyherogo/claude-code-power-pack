# Skill: workspace-audit
Audit and clean up workspace.

## Auto-Trigger
**When:** "audit", "cleanup", "organize workspace", "clean up"

## Audit Checklist

### File System Audit
```bash
# Find large files
find . -type f -size +100M -exec ls -lh {} \;

# Find old files (not modified in 90 days)
find . -type f -mtime +90 -name "*.md" | head -20

# Find duplicate files
fdupes -r .

# Check disk usage
du -sh */

# Find temp files
find . -name "*.tmp" -o -name "*.log" -o -name ".DS_Store"
```

### Git Audit
```bash
# Untracked files
git status --porcelain | grep "^??"

# Large files in history
git rev-list --objects --all | \
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
  awk '/^blob/ {print $3, $4}' | sort -rn | head -20

# Stale branches
git branch -a --merged

# Old branches
git for-each-ref --sort=committerdate refs/heads/ \
  --format='%(committerdate:short) %(refname:short)'
```

### Project Health Audit
```markdown
## Project Audit: [Project Name]

### Documentation
- [ ] README up to date
- [ ] CHANGELOG current
- [ ] API docs accurate
- [ ] Installation instructions work

### Dependencies
- [ ] No vulnerable packages: `npm audit`
- [ ] No outdated critical deps: `npm outdated`
- [ ] Unused deps removed
- [ ] Lock file committed

### Code Quality
- [ ] No linting errors
- [ ] Tests passing
- [ ] Coverage adequate
- [ ] No TODO/FIXME in production code

### Configuration
- [ ] .env.example updated
- [ ] Config documented
- [ ] Secrets not committed
- [ ] CI/CD working

### Deployment
- [ ] Deploy process documented
- [ ] Rollback tested
- [ ] Monitoring in place
- [ ] Alerts configured
```

### Workspace Structure Audit
```markdown
## Ideal Structure

ClaudeCodeWorkspace/
├── 1. Projects/           # Active projects
│   ├── [project-name]/
│   └── ...
├── 2. Areas/              # Ongoing responsibilities
│   ├── consulting/
│   ├── podcast/
│   └── health-data/
├── 3. Resources/          # Reference materials
│   ├── templates/
│   ├── docs/
│   └── work-journals/
├── 4. Archive/            # Completed/inactive
│   ├── 2025/
│   └── 2026/
├── .claude/               # Claude configuration
│   ├── CLAUDE.md
│   └── commands/
├── scripts/               # Automation
└── analytics/             # Metrics/logs
```

### Audit Report Template
```markdown
## Workspace Audit Report
**Date:** [date]
**Auditor:** Claude

### Summary
- Total files: [X]
- Total size: [X GB]
- Projects: [X active] / [X archived]
- Issues found: [X]

### Issues

#### Critical
- [ ] [issue requiring immediate action]

#### High
- [ ] [issue to address this week]

#### Medium
- [ ] [issue to address this month]

#### Low
- [ ] [nice to fix eventually]

### Recommendations
1. [recommendation 1]
2. [recommendation 2]
3. [recommendation 3]

### Cleanup Actions Taken
- [x] [action completed]
- [ ] [action pending]
```

## Auto-Cleanup Commands
```bash
# Remove common junk
find . -name ".DS_Store" -delete
find . -name "*.pyc" -delete
find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "node_modules" -type d -prune -exec rm -rf {} +

# Clear caches
npm cache clean --force
pip cache purge

# Remove old logs
find ./logs -name "*.log" -mtime +30 -delete
```

---
Last updated: 2026-01-27
