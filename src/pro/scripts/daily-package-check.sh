#!/bin/bash
# Daily Package Check - Quick status of all package managers
# Usage: pkg-check or ~/.claude/scripts/daily-package-check.sh

echo "═══════════════════════════════════════════════════════════"
echo "📦 PACKAGE STATUS"
echo "═══════════════════════════════════════════════════════════"

# Homebrew
brew_count=$(brew outdated 2>/dev/null | wc -l | tr -d ' ')
if [ "$brew_count" -gt 0 ]; then
    echo "🍺 Homebrew: $brew_count outdated"
else
    echo "🍺 Homebrew: ✅ up to date"
fi

# npm global
npm_count=$(npm outdated -g 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
if [ "$npm_count" -gt 0 ]; then
    echo "📦 npm (global): $npm_count outdated"
else
    echo "📦 npm (global): ✅ up to date"
fi

# Mac App Store
mas_count=$(mas outdated 2>/dev/null | wc -l | tr -d ' ')
if [ "$mas_count" -gt 0 ]; then
    echo "🍎 App Store: $mas_count outdated"
else
    echo "🍎 App Store: ✅ up to date"
fi

echo "═══════════════════════════════════════════════════════════"

# System stats
disk_usage=$(df -h / | tail -1 | awk '{print $5}')
memory_used=$(top -l 1 -s 0 2>/dev/null | grep PhysMem | awk '{print $2}')
echo "💻 Disk: $disk_usage used | Memory: $memory_used"
echo "═══════════════════════════════════════════════════════════"

# Total count
total=$((brew_count + npm_count + mas_count))
if [ "$total" -gt 0 ]; then
    echo ""
    echo "⚠️  $total packages need updates"
    echo "   Run 'update-all' to update everything"
else
    echo ""
    echo "✅ All packages up to date!"
fi
