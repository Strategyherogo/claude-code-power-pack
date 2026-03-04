#!/bin/bash
# Session End Auto-Save — generates context save file automatically
# Runs on Stop event

# Source centralized paths
source ~/.config/claude/paths.env

INPUT=$(cat)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
[ "$HOOK_EVENT" != "Stop" ] && exit 0

WORKSPACE="$CLAUDE_WORKSPACE"
SAVES="$CLAUDE_CONTEXT_SAVES_DIR"
TODAY=$(date +%Y-%m-%d)
NOW=$(date '+%Y-%m-%d %H:%M')

# Skip if a context-save was already created this session (within last 30 min)
RECENT_SAVE=$(find "$SAVES" -name "${TODAY}*.md" -mmin -30 2>/dev/null | head -1)
[ -n "$RECENT_SAVE" ] && exit 0

# Gather state
CHANGES=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
BRANCH=$(git -C "$WORKSPACE" branch --show-current 2>/dev/null)
LAST_COMMIT=$(git -C "$WORKSPACE" log --oneline -1 2>/dev/null)
RECENT_COMMITS=$(git -C "$WORKSPACE" log --oneline --since="4 hours ago" 2>/dev/null | head -5)
MODIFIED=$(git -C "$WORKSPACE" status --porcelain 2>/dev/null | head -5 | awk '{print $2}')

# Generate auto-save file
SAVE_FILE="$SAVES/${TODAY}-auto-save.md"

cat > "$SAVE_FILE" << SAVE
# Auto-Save: $NOW

## Workspace
- Branch: \`$BRANCH\`
- Uncommitted: $CHANGES files
- Last commit: \`$LAST_COMMIT\`

## Recent Commits
$RECENT_COMMITS

## Modified Files
$MODIFIED

## Restoration
\`\`\`bash
cd $WORKSPACE
git log --oneline -5
\`\`\`
SAVE

# Auto-stage the context save so it's included in next commit
git -C "$WORKSPACE" add "$SAVE_FILE" 2>/dev/null

# --- Config sync: export portable global config into the repo ---
EXPORT_DIR="${WORKSPACE}/.claude/global-config"
SYNC_NEEDED=0

# Only sync if global config changed since last export
if [ -f "${EXPORT_DIR}/settings.json" ]; then
    # Compare checksums — only sync if settings.json or hooks changed
    CURRENT_HASH=$(cat ~/.claude/settings.json ~/.claude/hooks/*.sh 2>/dev/null | shasum -a 256 | cut -d' ' -f1)
    EXPORTED_HASH=$(cat "${EXPORT_DIR}/settings.json" "${EXPORT_DIR}/hooks/"*.sh 2>/dev/null | shasum -a 256 | cut -d' ' -f1)
    [ "$CURRENT_HASH" != "$EXPORTED_HASH" ] && SYNC_NEEDED=1
else
    SYNC_NEEDED=1  # First export
fi

if [ "$SYNC_NEEDED" -eq 1 ]; then
    # Run export silently
    mkdir -p "${EXPORT_DIR}/hooks" "${EXPORT_DIR}/lessons" "${EXPORT_DIR}/config"
    rsync -a --delete ~/.claude/hooks/ "${EXPORT_DIR}/hooks/" 2>/dev/null
    cp ~/.claude/settings.json "${EXPORT_DIR}/settings.json" 2>/dev/null
    rsync -a --delete ~/.claude/lessons/ "${EXPORT_DIR}/lessons/" 2>/dev/null
    sed "s|${HOME}|~|g" ~/.config/claude/paths.env > "${EXPORT_DIR}/config/paths.env.portable" 2>/dev/null
    git -C "$WORKSPACE" add "${EXPORT_DIR}" 2>/dev/null
    SYNC_MSG=" Config synced."
else
    SYNC_MSG=""
fi

# --- Rsync to Mac #2 (if configured and reachable) ---
RSYNC_MSG=""
SYNC_ENV="${HOME}/.config/claude/sync.env"
if [ -f "$SYNC_ENV" ]; then
    source "$SYNC_ENV"
    # Quick SSH check (1s timeout, fail silently)
    if ssh -o ConnectTimeout=1 -o BatchMode=yes "${SYNC_TARGET_USER}@${SYNC_TARGET_HOST}" "true" 2>/dev/null; then
        bash "${WORKSPACE}/.claude/scripts/sync-workspace-rsync.sh" >/dev/null 2>&1 &
        RSYNC_MSG=" Syncing to ${SYNC_TARGET_HOST}."
    fi
fi

# Notify
if [ "$CHANGES" -gt 3 ] || [ "$SYNC_NEEDED" -eq 1 ] || [ -n "$RSYNC_MSG" ]; then
    echo "{\"message\": \"Auto-saved session state. $CHANGES uncommitted files on '$BRANCH'.${SYNC_MSG}${RSYNC_MSG}\"}"
fi

exit 0
