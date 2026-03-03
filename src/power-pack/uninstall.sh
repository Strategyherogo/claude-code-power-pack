#!/bin/bash
# Claude Code Power Pack — Uninstaller
# Removes only files installed by the power pack (manifest-based)
# Restores backup if available
set -e

# --- Colors ---
if [ -t 1 ]; then
    GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; RESET='\033[0m'
else
    GREEN=''; YELLOW=''; RED=''; RESET=''
fi

ok()   { printf "  ${GREEN}[OK]${RESET} %s\n" "$1"; }
warn() { printf "  ${YELLOW}[!!]${RESET} %s\n" "$1"; }
fail() { printf "  ${RED}[FAIL]${RESET} %s\n" "$1"; }

echo ""
echo "  Claude Code Power Pack — Uninstaller"
echo "  ======================================="
echo ""

# --- Prerequisite: jq ---
if ! command -v jq >/dev/null 2>&1; then
    fail "jq is required but not installed. Install via: brew install jq"
    exit 1
fi

# --- Find manifest ---
# Check project-local first, then global
if [ -f ".claude/.power-pack-manifest.json" ]; then
    MANIFEST=".claude/.power-pack-manifest.json"
elif [ -f "$HOME/.claude/.power-pack-manifest.json" ]; then
    MANIFEST="$HOME/.claude/.power-pack-manifest.json"
else
    fail "No manifest found (.power-pack-manifest.json)"
    echo "  The power pack was either not installed or the manifest was deleted."
    echo "  Cannot safely uninstall without knowing which files to remove."
    exit 1
fi

TARGET_CLAUDE=$(jq -r '.target_dir' "$MANIFEST")
BACKUP_DIR=$(jq -r '.backup_dir // empty' "$MANIFEST")
INSTALLED_AT=$(jq -r '.installed_at' "$MANIFEST")
VERSION=$(jq -r '.version' "$MANIFEST")

echo "  Manifest: $MANIFEST"
echo "  Installed: v$VERSION at $INSTALLED_AT"
echo "  Target: $TARGET_CLAUDE"
if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
    echo "  Backup available: $BACKUP_DIR"
fi
echo ""

# --- Confirm unless --yes flag ---
if [ "$1" != "--yes" ] && [ "$1" != "-y" ]; then
    printf "  Proceed with uninstall? [y/N] "
    read -r CONFIRM
    case "$CONFIRM" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "  Cancelled."; exit 0 ;;
    esac
    echo ""
fi

REMOVED=0
MISSING=0
SETTINGS_FILE="$HOME/.claude/settings.json"

# --- Step 1: Remove skills ---
echo "  Removing skills..."
while IFS= read -r file; do
    filepath="$TARGET_CLAUDE/$file"
    if [ -f "$filepath" ]; then
        rm "$filepath"
        REMOVED=$((REMOVED + 1))
    else
        MISSING=$((MISSING + 1))
    fi
done < <(jq -r '.files.skills[]' "$MANIFEST" 2>/dev/null)

# Clean up empty subdirectories in commands/
find "$TARGET_CLAUDE/commands" -type d -empty -delete 2>/dev/null || true

SKILL_COUNT=$(jq -r '.files.skills | length' "$MANIFEST")
ok "Skills: removed $SKILL_COUNT entries"

# --- Step 2: Remove rules ---
echo "  Removing rules..."
while IFS= read -r file; do
    filepath="$TARGET_CLAUDE/$file"
    if [ -f "$filepath" ]; then
        rm "$filepath"
        REMOVED=$((REMOVED + 1))
    fi
done < <(jq -r '.files.rules[]' "$MANIFEST" 2>/dev/null)

RULE_COUNT=$(jq -r '.files.rules | length' "$MANIFEST")
ok "Rules: removed $RULE_COUNT entries"

# --- Step 3: Remove hooks (files) ---
echo "  Removing hook files..."
while IFS= read -r file; do
    filepath="$TARGET_CLAUDE/$file"
    if [ -f "$filepath" ]; then
        rm "$filepath"
        REMOVED=$((REMOVED + 1))
    fi
done < <(jq -r '.files.hooks[]' "$MANIFEST" 2>/dev/null)

HOOK_COUNT=$(jq -r '.files.hooks | length' "$MANIFEST")
ok "Hook files: removed $HOOK_COUNT entries"

# --- Step 4: Remove scripts ---
echo "  Removing scripts..."
while IFS= read -r file; do
    filepath="$TARGET_CLAUDE/$file"
    if [ -f "$filepath" ]; then
        rm "$filepath"
        REMOVED=$((REMOVED + 1))
    fi
done < <(jq -r '.files.scripts[]' "$MANIFEST" 2>/dev/null)

SCRIPT_COUNT=$(jq -r '.files.scripts | length' "$MANIFEST")
ok "Scripts: removed $SCRIPT_COUNT entries"

# --- Step 5: Remove configs (only if they were installed by us) ---
echo "  Removing config templates..."
while IFS= read -r file; do
    filepath="$TARGET_CLAUDE/$file"
    if [ -f "$filepath" ]; then
        rm "$filepath"
        REMOVED=$((REMOVED + 1))
        ok "Removed $file"
    fi
done < <(jq -r '.files.configs[]' "$MANIFEST" 2>/dev/null)

# --- Step 6: Unwire hooks from settings.json ---
echo ""
echo "  Unwiring hooks from settings.json..."

if [ -f "$SETTINGS_FILE" ] && jq empty "$SETTINGS_FILE" 2>/dev/null; then
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.pre-uninstall-$TIMESTAMP"

    # Remove each hook command that we installed
    while IFS= read -r cmd; do
        [ -z "$cmd" ] && continue
        # For each event key in .hooks, filter out entries matching this command
        jq --arg cmd "$cmd" '
            if .hooks then
                .hooks |= with_entries(
                    .value |= map(select(.command != $cmd))
                )
                # Remove empty arrays
                | .hooks |= with_entries(select(.value | length > 0))
                # Remove empty hooks object
                | if (.hooks | length) == 0 then del(.hooks) else . end
            else . end
        ' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && \
            mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    done < <(jq -r '.hook_commands[]' "$MANIFEST" 2>/dev/null)

    ok "Hooks unwired from settings.json"
    ok "Settings backup: settings.json.pre-uninstall-$TIMESTAMP"
else
    warn "settings.json not found or invalid — skipping hook removal"
fi

# --- Step 7: Restore backup if available ---
if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
    echo ""
    printf "  Restore commands backup from $BACKUP_DIR? [y/N] "
    if [ "$1" = "--yes" ] || [ "$1" = "-y" ]; then
        RESTORE_CONFIRM="y"
    else
        read -r RESTORE_CONFIRM
    fi

    case "$RESTORE_CONFIRM" in
        [yY]|[yY][eE][sS])
            # Only restore files that don't currently exist (don't clobber user's new files)
            RESTORED=0
            for file in "$BACKUP_DIR/"*.md; do
                [ -f "$file" ] || continue
                name=$(basename "$file")
                if [ ! -f "$TARGET_CLAUDE/commands/$name" ]; then
                    cp "$file" "$TARGET_CLAUDE/commands/$name"
                    RESTORED=$((RESTORED + 1))
                fi
            done
            ok "Restored $RESTORED skills from backup"
            ;;
        *)
            ok "Backup preserved at $BACKUP_DIR (restore manually if needed)"
            ;;
    esac
fi

# --- Step 8: Remove manifest ---
rm "$MANIFEST"
ok "Manifest removed"

# --- Clean up empty directories ---
for dir in "$TARGET_CLAUDE/commands" "$TARGET_CLAUDE/rules" "$TARGET_CLAUDE/hooks" "$TARGET_CLAUDE/scripts"; do
    if [ -d "$dir" ] && [ -z "$(ls -A "$dir" 2>/dev/null)" ]; then
        rmdir "$dir" 2>/dev/null || true
    fi
done

# --- Summary ---
echo ""
echo "  ======================================="
echo "  Uninstall complete."
echo "  Removed $REMOVED files total ($MISSING already missing)."
echo ""
echo "  Settings.json hooks have been unwired."
if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
    echo "  Your backup is still at: $BACKUP_DIR"
fi
echo ""
