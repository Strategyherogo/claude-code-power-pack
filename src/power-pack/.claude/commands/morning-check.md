# Skill: morning-check
Quick morning health check — only issues that need attention.

## Auto-Trigger
**When:** "morning", "good morning", "start day", "daily check", "what's stuck", "maintenance"

## Workflow

Run these 4 checks in parallel (separate Bash calls, absolute paths):

1. `python3 $HOME/ClaudeCodeWorkspace/.claude/scripts/para-health-check.py`
2. `gh auth status 2>&1 | head -2`
3. Git dirty scan:
```bash
for dir in $HOME/ClaudeCodeWorkspace/"1. Projects"/*/; do
  [ -d "$dir/.git" ] || continue
  n=$(basename "$dir")
  c=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  [ "$c" -gt 0 ] && echo "  $n: $c uncommitted"
done
```
4. Uncommitted context saves:
```bash
git -C $HOME/ClaudeCodeWorkspace status --porcelain .claude/context-saves/ 2>/dev/null | grep '^\?' | sed 's|^?? .claude/context-saves/||'
```

## Output (max 15 lines)

```
## Morning Check — [date]
PARA: [summary line from health check]
Auth: [GitHub status or ⚠️]
Dirty: [list or "all clean"]
Unsaved: [list or "none"]
→ [top action if any issues, or "All clear"]
```

5. MCP health (npm-based servers):
```bash
for pkg in "@mondaydotcomorg/monday-api-mcp" "@anthropic-ai/mcp-k6"; do
  if npx -y --loglevel=error "$pkg" --version >/dev/null 2>&1; then
    echo "  $pkg: ok"
  else
    echo "  ⚠️ $pkg: BROKEN (npm resolve failed)"
  fi
done
```

Update output to include:
```
MCP: [all ok / ⚠️ list broken]
```

## Deep Checks (run only if asked)
- `/cred-discover` — full credential audit
- `/system-health` — packages, MCP servers, infra
- `/monday` — board status and blockers

---
Last updated: 2026-03-02
