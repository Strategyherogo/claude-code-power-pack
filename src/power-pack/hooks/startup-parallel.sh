#!/bin/bash
# Claude Code Startup Hook (merged: startup + auto-cleanup)
# Runs once per session using session_id from hook JSON input

# Source centralized paths
source ~/.config/claude/paths.env

INPUT=$(cat)
WORKSPACE="$CLAUDE_WORKSPACE"
LOCK_DIR="/tmp/claude-sessions"
mkdir -p "$LOCK_DIR"

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
if [ -z "$SESSION_ID" ]; then
    exit 0
fi

# Skip if this session already ran startup (atomic locking)
LOCK_FILE="$LOCK_DIR/$SESSION_ID"
mkdir "$LOCK_FILE" 2>/dev/null || exit 0

# Clean up lock files older than 24h
find "$LOCK_DIR" -type d -mtime +1 -delete 2>/dev/null &

# --- Only runs once per session below this line ---

# Session tracking
if [ -f ~/.claude/skills/workspace-automation/scripts/session_tracker.py ]; then
    python3 ~/.claude/skills/workspace-automation/scripts/session_tracker.py start 2>/dev/null &
fi

ISSUES=""

# Check GitHub auth
if ! gh auth status 2>/dev/null >/dev/null; then
    ISSUES="$ISSUES\n  - GitHub: not authenticated"
fi

# Check for uncommitted work
UNCOMMITTED=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$UNCOMMITTED" -gt 5 ]; then
    ISSUES="$ISSUES\n  - $UNCOMMITTED uncommitted files in workspace"
fi

# === Auto-Cleanup (every 10 sessions) ===
COUNTER_FILE="$WORKSPACE/.claude/.session-counter.json"
if [ -f "$COUNTER_FILE" ]; then
  COUNT=$(python3 -c "import json; print(json.load(open('$COUNTER_FILE')).get('total_sessions', 0))" 2>/dev/null)
else
  COUNT=$(cat "$HOME/.claude/session-env/session-counter" 2>/dev/null | tr -d '[:space:]')
fi

if [ -n "$COUNT" ] && [ $((COUNT % 10)) -eq 0 ]; then
  {
    TOTAL_SAVED=0
    DETAILS=""

    # Claude internals
    BEFORE=$(du -sm ~/.claude/debug/ ~/.claude/paste-cache/ ~/.claude/conversation-logs/ 2>/dev/null | awk '{sum+=$1} END{print sum+0}')
    find ~/.claude/debug/ -type f -mtime +3 -delete 2>/dev/null
    find ~/.claude/paste-cache/ -type f -mtime +7 -delete 2>/dev/null
    find ~/.claude/conversation-logs/ -name "*-raw.jsonl" -mtime +14 -delete 2>/dev/null
    find ~/.claude/session-env/ -type d -empty -delete 2>/dev/null
    find /tmp/claude-sessions/ -type f -mtime +1 -delete 2>/dev/null
    find /tmp/claude-nudge-* -mtime +1 -delete 2>/dev/null
    find /tmp/claude-nudged-* -mtime +1 -delete 2>/dev/null
    AFTER=$(du -sm ~/.claude/debug/ ~/.claude/paste-cache/ ~/.claude/conversation-logs/ 2>/dev/null | awk '{sum+=$1} END{print sum+0}')
    P1=$((BEFORE - AFTER))
    [ "$P1" -gt 0 ] && TOTAL_SAVED=$((TOTAL_SAVED + P1)) && DETAILS="$DETAILS claude:${P1}MB"

    # Remove old config backups
    BACKUP_COUNT=$(ls ~/.claude.json.backup.* 2>/dev/null | wc -l | tr -d ' ')
    if [ "$BACKUP_COUNT" -gt 0 ]; then
      rm -f ~/.claude.json.backup.*
      DETAILS="$DETAILS backups:${BACKUP_COUNT}files"
    fi

    # npm cache (>500MB)
    NPM_SIZE=$(du -sm ~/.npm 2>/dev/null | awk '{print $1+0}')
    if [ "$NPM_SIZE" -gt 500 ]; then
      npm cache clean --force 2>/dev/null
      TOTAL_SAVED=$((TOTAL_SAVED + NPM_SIZE))
      DETAILS="$DETAILS npm:${NPM_SIZE}MB"
    fi

    # Stale downloads (installers >14 days)
    DL_DIR="$HOME/Downloads"
    if [ -d "$DL_DIR" ]; then
      STALE_DL=$(find "$DL_DIR" -maxdepth 1 \( -name "*.dmg" -o -name "*.pkg" \) -mtime +14 -print0 2>/dev/null)
      if [ -n "$STALE_DL" ]; then
        DL_SIZE=$(echo "$STALE_DL" | xargs -0 du -sm 2>/dev/null | awk '{sum+=$1} END{print sum+0}')
        echo "$STALE_DL" | xargs -0 rm -f 2>/dev/null
        [ "$DL_SIZE" -gt 0 ] && TOTAL_SAVED=$((TOTAL_SAVED + DL_SIZE)) && DETAILS="$DETAILS downloads:${DL_SIZE}MB"
      fi
    fi

    if [ "$TOTAL_SAVED" -gt 0 ]; then
      ISSUES="$ISSUES\n  - Auto-cleanup freed ${TOTAL_SAVED}MB ($DETAILS)"
    fi
  } 2>/dev/null
fi

# === MCP Connectivity (lightweight) ===
# Check if key wrapper scripts exist and are executable
MCP_ISSUES=""
[ ! -x ~/.claude/hooks/mcp-github-wrapper.sh ] && MCP_ISSUES="${MCP_ISSUES} github-wrapper"
[ ! -x ~/.claude/hooks/mcp-postgres-wrapper.sh ] && MCP_ISSUES="${MCP_ISSUES} postgres-wrapper"
# Check gh auth (needed for GitHub MCP)
if ! gh auth token >/dev/null 2>&1; then
  MCP_ISSUES="${MCP_ISSUES} gh-auth"
fi
if [ -n "$MCP_ISSUES" ]; then
  ISSUES="$ISSUES\n  - MCP issues:$MCP_ISSUES"
fi

# Only show output if there are real issues
if [ -n "$ISSUES" ]; then
    echo -e "{\"message\": \"Startup:$ISSUES\"}"
fi

exit 0
