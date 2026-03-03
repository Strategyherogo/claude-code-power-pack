#!/bin/bash
# Claude Code Power Pack — Installer v2
# Copies skills, rules, hooks, config into your Claude Code workspace
# Auto-wires hooks into settings.json via jq
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACK_CLAUDE="$SCRIPT_DIR/.claude"
PACK_HOOKS="$SCRIPT_DIR/hooks"
PACK_SCRIPTS="$SCRIPT_DIR/scripts"
VERSION="2.0.0"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# --- Colors (if terminal supports them) ---
if [ -t 1 ]; then
    GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; RESET='\033[0m'
else
    GREEN=''; YELLOW=''; RED=''; RESET=''
fi

ok()   { printf "  ${GREEN}[OK]${RESET} %s\n" "$1"; }
warn() { printf "  ${YELLOW}[!!]${RESET} %s\n" "$1"; }
fail() { printf "  ${RED}[FAIL]${RESET} %s\n" "$1"; }

echo ""
echo "  Claude Code Power Pack — Installer v2"
echo "  ======================================="
echo ""

# --- Prerequisite: jq ---
if ! command -v jq >/dev/null 2>&1; then
    fail "jq is required but not installed. Install via: brew install jq"
    exit 1
fi

# --- Determine install target ---
if [ -d ".git" ] || [ -d ".claude" ]; then
    TARGET_CLAUDE="$(pwd)/.claude"
    echo "  Target: project $(pwd)"
else
    TARGET_CLAUDE="$HOME/.claude"
    echo "  Target: global $HOME/.claude"
fi
echo ""

SETTINGS_FILE="$HOME/.claude/settings.json"
MANIFEST_FILE="$TARGET_CLAUDE/.power-pack-manifest.json"

# Create .claude if it doesn't exist
mkdir -p "$TARGET_CLAUDE"

# --- Step 0: Backup existing commands/ if present ---
BACKED_UP=""
if [ -d "$TARGET_CLAUDE/commands" ]; then
    EXISTING_COUNT=$(find "$TARGET_CLAUDE/commands" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$EXISTING_COUNT" -gt 0 ]; then
        BACKUP_DIR="$TARGET_CLAUDE/commands-backup-$TIMESTAMP"
        cp -R "$TARGET_CLAUDE/commands" "$BACKUP_DIR"
        BACKED_UP="$BACKUP_DIR"
        ok "Backed up $EXISTING_COUNT existing skills to commands-backup-$TIMESTAMP/"
    fi
fi

# --- Initialize manifest ---
INSTALLED_SKILLS=()
INSTALLED_RULES=()
INSTALLED_HOOKS=()
INSTALLED_CONFIGS=()
INSTALLED_SCRIPTS=()
ERRORS=0

# --- Step 1: Skills (.claude/commands/) ---
mkdir -p "$TARGET_CLAUDE/commands"
SKILL_TOTAL=0
SKILL_COPIED=0
SKILL_SKIPPED=0

if [ -d "$PACK_CLAUDE/commands" ]; then
    # Top-level skill files
    for skill in "$PACK_CLAUDE/commands/"*.md; do
        [ -f "$skill" ] || continue
        SKILL_TOTAL=$((SKILL_TOTAL + 1))
        name=$(basename "$skill")
        if [ -f "$TARGET_CLAUDE/commands/$name" ] && [ -z "$FORCE" ]; then
            SKILL_SKIPPED=$((SKILL_SKIPPED + 1))
        else
            cp "$skill" "$TARGET_CLAUDE/commands/$name"
            SKILL_COPIED=$((SKILL_COPIED + 1))
            INSTALLED_SKILLS+=("commands/$name")
        fi
    done

    # Subdirectory skills (e.g., sales/)
    for subdir in "$PACK_CLAUDE/commands"/*/; do
        [ -d "$subdir" ] || continue
        dirname=$(basename "$subdir")
        mkdir -p "$TARGET_CLAUDE/commands/$dirname"
        for skill in "$subdir"*.md; do
            [ -f "$skill" ] || continue
            SKILL_TOTAL=$((SKILL_TOTAL + 1))
            name=$(basename "$skill")
            if [ -f "$TARGET_CLAUDE/commands/$dirname/$name" ] && [ -z "$FORCE" ]; then
                SKILL_SKIPPED=$((SKILL_SKIPPED + 1))
            else
                cp "$skill" "$TARGET_CLAUDE/commands/$dirname/$name"
                SKILL_COPIED=$((SKILL_COPIED + 1))
                INSTALLED_SKILLS+=("commands/$dirname/$name")
            fi
        done
    done
fi

if [ "$SKILL_SKIPPED" -gt 0 ]; then
    ok "Skills: $SKILL_COPIED copied, $SKILL_SKIPPED skipped (already exist). Use FORCE=1 to overwrite."
else
    ok "Skills: $SKILL_COPIED/$SKILL_TOTAL copied"
fi

# --- Step 2: Rules (.claude/rules/) ---
RULE_COUNT=0
if [ -d "$PACK_CLAUDE/rules" ]; then
    mkdir -p "$TARGET_CLAUDE/rules"
    for rule in "$PACK_CLAUDE/rules/"*.md; do
        [ -f "$rule" ] || continue
        name=$(basename "$rule")
        cp "$rule" "$TARGET_CLAUDE/rules/$name"
        INSTALLED_RULES+=("rules/$name")
        RULE_COUNT=$((RULE_COUNT + 1))
    done
    ok "Rules: $RULE_COUNT copied"
else
    warn "Rules: none found in pack"
fi

# --- Step 3: Config templates (CLAUDE.md, MASTER.md) ---
for config in CLAUDE.md MASTER.md; do
    if [ -f "$PACK_CLAUDE/$config" ]; then
        if [ -f "$TARGET_CLAUDE/$config" ] && [ -z "$FORCE" ]; then
            warn "Config: $config exists (skipped). Use FORCE=1 to overwrite."
        else
            cp "$PACK_CLAUDE/$config" "$TARGET_CLAUDE/$config"
            INSTALLED_CONFIGS+=("$config")
            ok "Config: $config installed"
        fi
    fi
done

# --- Step 4: Hooks ---
HOOK_COUNT=0
if [ -d "$PACK_HOOKS" ]; then
    mkdir -p "$TARGET_CLAUDE/hooks"
    for hook in "$PACK_HOOKS/"*.sh; do
        [ -f "$hook" ] || continue
        name=$(basename "$hook")
        cp "$hook" "$TARGET_CLAUDE/hooks/$name"
        chmod +x "$TARGET_CLAUDE/hooks/$name"
        INSTALLED_HOOKS+=("hooks/$name")
        HOOK_COUNT=$((HOOK_COUNT + 1))
    done
    ok "Hooks: $HOOK_COUNT copied"
else
    warn "Hooks: none found in pack"
fi

# --- Step 5: Scripts ---
SCRIPT_COUNT=0
if [ -d "$PACK_SCRIPTS" ]; then
    mkdir -p "$TARGET_CLAUDE/scripts"
    for script in "$PACK_SCRIPTS/"*; do
        [ -f "$script" ] || continue
        name=$(basename "$script")
        cp "$script" "$TARGET_CLAUDE/scripts/$name"
        chmod +x "$TARGET_CLAUDE/scripts/$name"
        INSTALLED_SCRIPTS+=("scripts/$name")
        SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
    done
    ok "Scripts: $SCRIPT_COUNT copied"
fi

# --- Step 6: Context saves directory ---
mkdir -p "$TARGET_CLAUDE/context-saves"
ok "Context saves directory ready"

# --- Step 7: Wire hooks into settings.json ---
echo ""
echo "  Hook Wiring"
echo "  -----------"

if [ "${#INSTALLED_HOOKS[@]}" -gt 0 ]; then
    # Define the hook configuration
    # Each hook: event|matcher|command
    HOOK_DEFS=(
        "UserPromptSubmit||bash $TARGET_CLAUDE/hooks/startup-parallel.sh"
        "PreToolUse|Bash|bash $TARGET_CLAUDE/hooks/pre-deploy-check.sh"
        "Stop||bash $TARGET_CLAUDE/hooks/session-end-save.sh"
    )

    # Ensure settings.json exists with at least {}
    if [ ! -f "$SETTINGS_FILE" ]; then
        mkdir -p "$(dirname "$SETTINGS_FILE")"
        echo '{}' > "$SETTINGS_FILE"
        ok "Created $SETTINGS_FILE"
    fi

    # Validate it's valid JSON
    if ! jq empty "$SETTINGS_FILE" 2>/dev/null; then
        fail "settings.json is not valid JSON. Skipping hook wiring."
        ERRORS=$((ERRORS + 1))
    else
        # Backup settings.json
        cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup-$TIMESTAMP"

        HOOKS_ADDED=0
        HOOKS_SKIPPED=0

        for hookdef in "${HOOK_DEFS[@]}"; do
            IFS='|' read -r event matcher command <<< "$hookdef"

            # Build the hook object
            if [ -n "$matcher" ]; then
                HOOK_OBJ=$(jq -n --arg cmd "$command" --arg m "$matcher" \
                    '{"type": "command", "command": $cmd, "matcher": $m}')
            else
                HOOK_OBJ=$(jq -n --arg cmd "$command" \
                    '{"type": "command", "command": $cmd}')
            fi

            # Check if this hook command already exists in the event array
            EXISTING=$(jq -r --arg event "$event" --arg cmd "$command" \
                '.hooks[$event] // [] | map(select(.command == $cmd)) | length' \
                "$SETTINGS_FILE" 2>/dev/null)

            if [ "$EXISTING" = "0" ] || [ -z "$EXISTING" ]; then
                # Merge: ensure .hooks exists, ensure .hooks[$event] is an array, append
                jq --arg event "$event" --argjson hook "$HOOK_OBJ" \
                    '.hooks //= {} | .hooks[$event] //= [] | .hooks[$event] += [$hook]' \
                    "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && \
                    mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
                HOOKS_ADDED=$((HOOKS_ADDED + 1))
            else
                HOOKS_SKIPPED=$((HOOKS_SKIPPED + 1))
            fi
        done

        if [ "$HOOKS_ADDED" -gt 0 ]; then
            ok "Wired $HOOKS_ADDED hooks into settings.json"
        fi
        if [ "$HOOKS_SKIPPED" -gt 0 ]; then
            ok "Skipped $HOOKS_SKIPPED hooks (already registered)"
        fi
        ok "Settings backup: settings.json.backup-$TIMESTAMP"
    fi
else
    HOOK_DEFS=()
    ok "No hooks to wire (hooks/ directory not present in pack)"
fi

# --- Step 8: Write manifest ---
# Build JSON manifest for uninstaller
SKILLS_JSON=$(printf '%s\n' "${INSTALLED_SKILLS[@]}" | jq -R . | jq -s .)
RULES_JSON=$(printf '%s\n' "${INSTALLED_RULES[@]}" | jq -R . | jq -s .)
HOOKS_JSON=$(printf '%s\n' "${INSTALLED_HOOKS[@]}" | jq -R . | jq -s .)
CONFIGS_JSON=$(printf '%s\n' "${INSTALLED_CONFIGS[@]}" | jq -R . | jq -s .)
SCRIPTS_JSON=$(printf '%s\n' "${INSTALLED_SCRIPTS[@]}" | jq -R . | jq -s .)

# Build hook commands list for uninstaller
HOOK_CMDS_JSON=$(printf '%s\n' "${HOOK_DEFS[@]}" | while IFS='|' read -r event matcher cmd; do
    echo "$cmd"
done | jq -R . | jq -s .)

jq -n \
    --arg version "$VERSION" \
    --arg timestamp "$TIMESTAMP" \
    --arg target "$TARGET_CLAUDE" \
    --arg backup "$BACKED_UP" \
    --argjson skills "$SKILLS_JSON" \
    --argjson rules "$RULES_JSON" \
    --argjson hooks "$HOOKS_JSON" \
    --argjson configs "$CONFIGS_JSON" \
    --argjson scripts "$SCRIPTS_JSON" \
    --argjson hook_commands "$HOOK_CMDS_JSON" \
    '{
        version: $version,
        installed_at: $timestamp,
        target_dir: $target,
        backup_dir: $backup,
        files: {
            skills: $skills,
            rules: $rules,
            hooks: $hooks,
            configs: $configs,
            scripts: $scripts
        },
        hook_commands: $hook_commands
    }' > "$MANIFEST_FILE"

ok "Manifest written: .power-pack-manifest.json"

# --- Validation ---
echo ""
echo "  Validation"
echo "  ----------"

# Check skill count matches
ACTUAL_SKILLS=$(find "$TARGET_CLAUDE/commands" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [ "$ACTUAL_SKILLS" -ge "$SKILL_TOTAL" ]; then
    ok "Skills: $ACTUAL_SKILLS files present (expected >= $SKILL_TOTAL)"
else
    fail "Skills: only $ACTUAL_SKILLS present (expected $SKILL_TOTAL)"
    ERRORS=$((ERRORS + 1))
fi

# Check hooks exist and are executable
for hook in "${INSTALLED_HOOKS[@]}"; do
    hookfile="$TARGET_CLAUDE/$hook"
    if [ -x "$hookfile" ]; then
        ok "Hook executable: $(basename "$hookfile")"
    else
        fail "Hook not executable: $hookfile"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check hooks in settings.json
for hookdef in "${HOOK_DEFS[@]}"; do
    IFS='|' read -r event matcher command <<< "$hookdef"
    COUNT=$(jq -r --arg event "$event" --arg cmd "$command" \
        '.hooks[$event] // [] | map(select(.command == $cmd)) | length' \
        "$SETTINGS_FILE" 2>/dev/null)
    if [ "$COUNT" -ge 1 ]; then
        ok "Hook registered: $event -> $(basename "$command" | sed 's/bash //')"
    else
        fail "Hook NOT registered: $event -> $command"
        ERRORS=$((ERRORS + 1))
    fi
done

# --- Summary ---
echo ""
echo "  ======================================="
if [ "$ERRORS" -gt 0 ]; then
    echo "  Installation completed with $ERRORS error(s)."
else
    echo "  Installation complete. No errors."
fi
echo ""
echo "  Installed:"
echo "    Skills:  $SKILL_TOTAL"
echo "    Rules:   $RULE_COUNT"
echo "    Hooks:   $HOOK_COUNT (auto-wired)"
echo "    Scripts: $SCRIPT_COUNT"
echo ""
echo "  Quick start:"
echo "    1. Open Claude Code in your project"
echo "    2. Type /commands:cs for your first session briefing"
echo "    3. Type /commands:systematic-debug to debug an issue"
echo "    4. Type /commands:SKILL-INDEX to see all available skills"
echo ""
echo "  To uninstall: bash $(dirname "$0")/uninstall.sh"
echo ""
