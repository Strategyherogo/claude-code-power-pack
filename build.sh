#!/bin/bash
# Build both Free and Pro packages for Gumroad distribution
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST="$SCRIPT_DIR/distribution/gumroad"

echo "=== Building Claude Code Power Pack ==="
echo ""

# Step 1: Run genericize
echo "[1/3] Genericizing files..."
python3 "$SCRIPT_DIR/genericize.py"

# Step 2: Package Free tier
echo ""
echo "[2/3] Packaging Free Starter Pack..."
cd "$SCRIPT_DIR/src"
cp -r free claude-code-starter
tar czf "$DIST/claude-code-starter-pack.tar.gz" claude-code-starter/
rm -rf claude-code-starter
FREE_SIZE=$(du -h "$DIST/claude-code-starter-pack.tar.gz" | cut -f1)
echo "  Created: claude-code-starter-pack.tar.gz ($FREE_SIZE)"

# Step 3: Package Pro tier
echo ""
echo "[3/3] Packaging Pro Power Pack..."
cp -r pro claude-code-power-pack
tar czf "$DIST/claude-code-power-pack.tar.gz" claude-code-power-pack/
rm -rf claude-code-power-pack
PRO_SIZE=$(du -h "$DIST/claude-code-power-pack.tar.gz" | cut -f1)
echo "  Created: claude-code-power-pack.tar.gz ($PRO_SIZE)"

# Summary
echo ""
echo "=== Build Complete ==="
echo ""
echo "  Free: $DIST/claude-code-starter-pack.tar.gz ($FREE_SIZE)"
echo "  Pro:  $DIST/claude-code-power-pack.tar.gz ($PRO_SIZE)"
echo ""
echo "Upload to: techconcepts.gumroad.com"
echo "  Free product: \$0 (lead magnet)"
echo "  Pro product:  \$24 (launch \$9 with code POWERPACK75)"
