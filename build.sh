#!/bin/bash
# Build release tarball for GitHub Releases
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Building Claude Code Power Pack ==="
echo ""

# Step 1: Run genericize
echo "[1/2] Genericizing files..."
python3 "$SCRIPT_DIR/genericize.py"

# Step 2: Package release
echo ""
echo "[2/2] Packaging release..."
mkdir -p "$SCRIPT_DIR/dist"
cd "$SCRIPT_DIR/src"
cp -r pro claude-code-power-pack
tar czf "$SCRIPT_DIR/dist/claude-code-power-pack.tar.gz" claude-code-power-pack/
rm -rf claude-code-power-pack
SIZE=$(du -h "$SCRIPT_DIR/dist/claude-code-power-pack.tar.gz" | cut -f1)

echo ""
echo "=== Build Complete ==="
echo "  Release: dist/claude-code-power-pack.tar.gz ($SIZE)"
echo ""
echo "Upload via: gh release create v1.x.x dist/claude-code-power-pack.tar.gz"
