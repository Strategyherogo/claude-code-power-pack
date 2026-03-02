#!/bin/bash
# Claude Code Power Pack — Installer
# Copies skills, rules, hooks, and config into your Claude Code workspace
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
WORKSPACE_CLAUDE="${WORKSPACE_CLAUDE:-.claude}"

echo ""
echo "  Claude Code Power Pack — Installer"
echo "  ===================================="
echo ""

# Detect if we're inside a project directory
if [ -d ".git" ] || [ -d ".claude" ]; then
    INSTALL_DIR="$(pwd)/$WORKSPACE_CLAUDE"
    echo "  Installing to project: $(pwd)"
else
    INSTALL_DIR="$CLAUDE_DIR"
    echo "  Installing to global: $CLAUDE_DIR"
fi

echo ""

# Step 1: Skills
if [ -d "$SCRIPT_DIR/.claude/commands" ]; then
    mkdir -p "$INSTALL_DIR/commands"
    SKILL_COUNT=$(find "$SCRIPT_DIR/.claude/commands" -name "*.md" | wc -l | tr -d ' ')
    cp -n "$SCRIPT_DIR/.claude/commands/"*.md "$INSTALL_DIR/commands/" 2>/dev/null || true

    # Handle subdirectories (sales/, etc.)
    for subdir in "$SCRIPT_DIR/.claude/commands"/*/; do
        [ -d "$subdir" ] || continue
        dirname=$(basename "$subdir")
        mkdir -p "$INSTALL_DIR/commands/$dirname"
        cp -n "$subdir"*.md "$INSTALL_DIR/commands/$dirname/" 2>/dev/null || true
    done
    echo "  [1/5] Skills:  $SKILL_COUNT installed (skipped existing)"
else
    echo "  [1/5] Skills:  none found"
fi

# Step 2: Rules
if [ -d "$SCRIPT_DIR/.claude/rules" ]; then
    mkdir -p "$INSTALL_DIR/rules"
    RULE_COUNT=$(find "$SCRIPT_DIR/.claude/rules" -name "*.md" | wc -l | tr -d ' ')
    cp -n "$SCRIPT_DIR/.claude/rules/"*.md "$INSTALL_DIR/rules/" 2>/dev/null || true
    echo "  [2/5] Rules:   $RULE_COUNT installed"
else
    echo "  [2/5] Rules:   none found"
fi

# Step 3: Config templates (CLAUDE.md, MASTER.md)
for config in CLAUDE.md MASTER.md; do
    if [ -f "$SCRIPT_DIR/.claude/$config" ]; then
        if [ ! -f "$INSTALL_DIR/$config" ]; then
            cp "$SCRIPT_DIR/.claude/$config" "$INSTALL_DIR/$config"
            echo "  [3/5] Config:  $config installed"
        else
            echo "  [3/5] Config:  $config exists (skipped)"
        fi
    fi
done

# Step 4: Hooks
if [ -d "$SCRIPT_DIR/hooks" ]; then
    mkdir -p "$INSTALL_DIR/hooks"
    HOOK_COUNT=$(find "$SCRIPT_DIR/hooks" -name "*.sh" | wc -l | tr -d ' ')
    for hook in "$SCRIPT_DIR/hooks/"*.sh; do
        [ -f "$hook" ] || continue
        hookname=$(basename "$hook")
        cp -n "$hook" "$INSTALL_DIR/hooks/$hookname" 2>/dev/null || true
        chmod +x "$INSTALL_DIR/hooks/$hookname"
    done
    echo "  [4/5] Hooks:   $HOOK_COUNT installed"
    echo ""
    echo "  NOTE: Hooks require wiring in ~/.claude/settings.json"
    echo "  See README.md for hook configuration instructions."
else
    echo "  [4/5] Hooks:   none found"
fi

# Step 5: Context saves directory
mkdir -p "$INSTALL_DIR/../context-saves" 2>/dev/null || mkdir -p "$INSTALL_DIR/context-saves"
echo "  [5/5] Context: saves directory created"

# Summary
echo ""
echo "  ===================================="
echo "  Installation complete."
echo ""
echo "  Quick start:"
echo "    1. Open Claude Code in your project"
echo "    2. Type /commands:cs for your first session briefing"
echo "    3. Type /commands:systematic-debug to debug an issue"
echo "    4. Type /commands:SKILL-INDEX to see all available skills"
echo ""
echo "  Tip: Skills use the /commands: prefix."
echo "  Example: /commands:tdd, /commands:git-flow, /commands:deploy-verify"
echo ""
