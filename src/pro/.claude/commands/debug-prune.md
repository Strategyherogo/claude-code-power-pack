# Skill: debug-prune
Clean up growing directories in ~/.claude/ to prevent disk bloat.

## Auto-Trigger
**When:** "prune", "cleanup claude", "disk space", "debug cleanup"

## Targets

| Directory | Retention | Typical Growth |
|-----------|-----------|----------------|
| `~/.claude/debug/` | 3 days | ~30MB/day |
| `~/.claude/paste-cache/` | 7 days | ~400KB/day |
| `~/.claude/conversation-logs/*-raw.jsonl` | 14 days | ~5MB/day |
| `~/.claude/session-env/` | 7 days | minimal |
| `/tmp/claude-sessions/` | 1 day | minimal |
| `~/ClaudeCodeWorkspace/context-saves/*.md` | 14 days | ~7KB/day |
| `~/ClaudeCodeWorkspace/logs/` | 7 days | ~5KB/day |

**Exception:** Always keep `context-saves/.checkpoint-latest.md`.

## Workflow

```bash
echo "=== Claude Cleanup ==="

# Before
echo "Before:"
du -sh ~/.claude/debug/ ~/.claude/paste-cache/ ~/.claude/conversation-logs/ ~/.claude/session-env/ 2>/dev/null

# Debug files > 3 days
find ~/.claude/debug/ -type f -mtime +3 -delete 2>/dev/null
echo "✓ debug/ pruned (>3 days)"

# Paste cache > 7 days
find ~/.claude/paste-cache/ -type f -mtime +7 -delete 2>/dev/null
echo "✓ paste-cache/ pruned (>7 days)"

# Raw JSONL conversation logs > 14 days
find ~/.claude/conversation-logs/ -name "*-raw.jsonl" -mtime +14 -delete 2>/dev/null
echo "✓ raw conversation logs pruned (>14 days)"

# Session env > 7 days
find ~/.claude/session-env/ -type f -mtime +7 -delete 2>/dev/null
echo "✓ session-env/ pruned (>7 days)"

# Session lock files > 1 day
find /tmp/claude-sessions/ -type f -mtime +1 -delete 2>/dev/null
echo "✓ session locks pruned (>1 day)"

# Workspace context-saves > 14 days (keep checkpoint-latest)
find ~/ClaudeCodeWorkspace/context-saves/ -name "*.md" -not -name ".checkpoint-latest.md" -mtime +14 -delete 2>/dev/null
echo "✓ context-saves/ pruned (>14 days)"

# Workspace logs > 7 days
find ~/ClaudeCodeWorkspace/logs/ -type f -mtime +7 -delete 2>/dev/null
echo "✓ logs/ pruned (>7 days)"

# After
echo ""
echo "After:"
du -sh ~/.claude/debug/ ~/.claude/paste-cache/ ~/.claude/conversation-logs/ ~/.claude/session-env/ 2>/dev/null
```

## Auto-Run
This cleanup runs automatically every 10 sessions via the workspace-automation hook.
Manual: `/debug-prune`

---

*Last updated: 2026-02-07*
