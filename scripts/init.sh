#!/usr/bin/env bash
# Idempotent project setup for the supercharlouze plugin.
# Creates the document tree, archives superpowers documents, and installs the
# CLAUDE.md block from its canonical source. Adopts nothing, guesses nothing.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BLOCK_FILE="$PLUGIN_ROOT/skills/using-batches/references/claude-md-block.md"

PROJECT="${1:-.}"
PROJECT="$(cd "$PROJECT" && pwd)"

if [ ! -f "$BLOCK_FILE" ]; then
    echo "error: canonical CLAUDE.md block not found at $BLOCK_FILE" >&2
    exit 1
fi

mkdir -p "$PROJECT/docs/specs" "$PROJECT/docs/batches" "$PROJECT/docs/archive"

archive_dir() {
    local from="$PROJECT/docs/superpowers/$1"
    local to="$PROJECT/docs/archive/$1"
    [ -d "$from" ] || return 0
    mkdir -p "$to"
    find "$from" -maxdepth 1 -type f -exec mv -f {} "$to"/ \;
    rmdir "$from" 2>/dev/null || true
}

archive_dir specs
archive_dir plans
rmdir "$PROJECT/docs/superpowers" 2>/dev/null || true

CLAUDE_MD="$PROJECT/CLAUDE.md"
touch "$CLAUDE_MD"

HAS_BEGIN=0
HAS_END=0
grep -q "supercharlouze:begin" "$CLAUDE_MD" && HAS_BEGIN=1
grep -q "supercharlouze:end" "$CLAUDE_MD" && HAS_END=1

if [ "$HAS_BEGIN" -ne "$HAS_END" ]; then
    echo "error: $CLAUDE_MD has an unbalanced supercharlouze marker pair." >&2
    echo "Refusing to rewrite it — repair the markers by hand, then run again." >&2
    exit 1
fi

if [ "$HAS_BEGIN" -eq 1 ]; then
    # Replace the block in place, preserving everything around it.
    awk -v block="$BLOCK_FILE" '
        /supercharlouze:begin/ { while ((getline line < block) > 0) print line; skip=1; next }
        /supercharlouze:end/   { skip=0; next }
        !skip { print }
    ' "$CLAUDE_MD" > "$CLAUDE_MD.tmp"
    mv "$CLAUDE_MD.tmp" "$CLAUDE_MD"
else
    if [ -s "$CLAUDE_MD" ]; then printf '\n' >> "$CLAUDE_MD"; fi
    cat "$BLOCK_FILE" >> "$CLAUDE_MD"
fi

echo "supercharlouze: document tree ready under $PROJECT/docs"

echo "adopted modules:"
find "$PROJECT/docs/specs" -maxdepth 1 -name '*.md' ! -name '*.gaps.md' -print 2>/dev/null |
    while IFS= read -r spec; do
        echo "  - $(basename "$spec" .md)"
    done

echo "archived documents not listed in any spec Sources section:"
find "$PROJECT/docs/archive" -type f -name '*.md' -print 2>/dev/null |
    while IFS= read -r doc; do
        rel="${doc#"$PROJECT"/}"
        if ! grep -rqF "$rel" "$PROJECT/docs/specs" 2>/dev/null; then
            echo "  - $rel"
        fi
    done
