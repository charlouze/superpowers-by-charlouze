#!/usr/bin/env bash
# Idempotent project setup for the supercharlouze plugin.
# Creates the document tree, archives superpowers documents, and installs the
# CLAUDE.md block from its canonical source. Adopts nothing, guesses nothing.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BLOCK_FILE="$PLUGIN_ROOT/skills/using-batches/references/claude-md-block.md"

# The markers are whole lines, never substrings. Prose that merely names them is
# not a block, and must never be treated as one.
BEGIN_MARKER='<!-- supercharlouze:begin -->'
END_MARKER='<!-- supercharlouze:end -->'

PROJECT="${1:-.}"
PROJECT="$(cd "$PROJECT" && pwd)"

if [ ! -f "$BLOCK_FILE" ]; then
    echo "error: canonical CLAUDE.md block not found at $BLOCK_FILE" >&2
    exit 1
fi

mkdir -p "$PROJECT/docs/specs" "$PROJECT/docs/batches" "$PROJECT/docs/archive"

# --- Archive migration -------------------------------------------------------

# Lists every file under docs/superpowers/<sub>, one path relative to <sub> per
# line, so that the whole subtree can be moved with its shape intact.
archive_list() {
    local from="$PROJECT/docs/superpowers/$1"
    [ -d "$from" ] || return 0
    find "$from" -type f -print | while IFS= read -r file; do
        printf '%s\n' "${file#"$from"/}"
    done
}

# A collision means an archived document already occupies the destination path.
# Overwriting it would destroy history, so the whole run is refused before
# anything moves: a half-finished migration reporting success is worse than a
# migration that did not start.
COLLISIONS=""
collect_collisions() {
    local sub="$1" to="$PROJECT/docs/archive/$1" rel
    while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        if [ -e "$to/$rel" ]; then
            COLLISIONS="$COLLISIONS  docs/archive/$sub/$rel"$'\n'
        fi
    done < <(archive_list "$sub")
}

collect_collisions specs
collect_collisions plans

if [ -n "$COLLISIONS" ]; then
    echo "error: archiving would overwrite existing documents:" >&2
    printf '%s' "$COLLISIONS" >&2
    echo "Refusing to move anything — resolve the collisions by hand, then run again." >&2
    exit 1
fi

archive_dir() {
    local sub="$1" rel
    local from="$PROJECT/docs/superpowers/$sub"
    local to="$PROJECT/docs/archive/$sub"
    [ -d "$from" ] || return 0
    mkdir -p "$to"
    while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        mkdir -p "$to/$(dirname "$rel")"
        # -n as a second line of defence; collisions were already refused above.
        mv -n "$from/$rel" "$to/$rel"
    done < <(archive_list "$sub")
    # Drop the emptied source tree, deepest first. Anything left is not ours.
    find "$from" -depth -type d -exec rmdir {} + 2>/dev/null || true
}

archive_dir specs
archive_dir plans
rmdir "$PROJECT/docs/superpowers" 2>/dev/null || true

# --- CLAUDE.md block ---------------------------------------------------------

CLAUDE_MD="$PROJECT/CLAUDE.md"
touch "$CLAUDE_MD"

# Count and locate the marker lines themselves, not the strings they contain.
count_marker() { grep -c -x -F -- "$1" "$CLAUDE_MD" || true; }
line_of_marker() { grep -n -x -F -- "$1" "$CLAUDE_MD" | head -n 1 | cut -d: -f1 || true; }

BEGIN_COUNT="$(count_marker "$BEGIN_MARKER")"
END_COUNT="$(count_marker "$END_MARKER")"

refuse() {
    echo "error: $CLAUDE_MD has broken supercharlouze markers — $1." >&2
    echo "Refusing to rewrite it — repair the markers by hand, then run again." >&2
    exit 1
}

if [ "$BEGIN_COUNT" -eq 0 ] && [ "$END_COUNT" -eq 0 ]; then
    if [ -s "$CLAUDE_MD" ]; then printf '\n' >> "$CLAUDE_MD"; fi
    cat "$BLOCK_FILE" >> "$CLAUDE_MD"
elif [ "$BEGIN_COUNT" -eq 1 ] && [ "$END_COUNT" -eq 0 ]; then
    refuse "an opening marker with no closing marker"
elif [ "$BEGIN_COUNT" -eq 0 ] && [ "$END_COUNT" -eq 1 ]; then
    refuse "a closing marker with no opening marker"
elif [ "$BEGIN_COUNT" -gt 1 ] || [ "$END_COUNT" -gt 1 ]; then
    refuse "$BEGIN_COUNT opening and $END_COUNT closing markers, expected exactly one of each"
elif [ "$(line_of_marker "$END_MARKER")" -lt "$(line_of_marker "$BEGIN_MARKER")" ]; then
    refuse "the closing marker appears before the opening marker"
else
    # Exactly one opening line followed by one closing line: replace the block in
    # place, preserving everything around it. The temp file lives next to the
    # target so the swap is atomic, carries a unique name, and is removed if awk
    # dies under set -e.
    TMP="$(mktemp "$CLAUDE_MD.XXXXXX")"
    trap 'rm -f "$TMP"' EXIT
    awk -v block="$BLOCK_FILE" -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
        $0 == begin { while ((getline line < block) > 0) print line; close(block); skip = 1; next }
        $0 == end && skip { skip = 0; next }
        !skip { print }
    ' "$CLAUDE_MD" > "$TMP"
    # mktemp creates the file as 0600; keep the mode CLAUDE.md already had.
    chmod --reference="$CLAUDE_MD" "$TMP" 2>/dev/null || true
    mv "$TMP" "$CLAUDE_MD"
fi

# --- Report ------------------------------------------------------------------

echo "supercharlouze: document tree ready under $PROJECT/docs"

ADOPTED="$(find "$PROJECT/docs/specs" -maxdepth 1 -type f -name '*.md' ! -name '*.gaps.md' -print 2>/dev/null | sort)"
echo "adopted modules:"
if [ -z "$ADOPTED" ]; then
    echo "  (none)"
else
    printf '%s\n' "$ADOPTED" | while IFS= read -r spec; do
        echo "  - $(basename "$spec" .md)"
    done
fi

ORPHANS=""
while IFS= read -r doc; do
    [ -n "$doc" ] || continue
    rel="${doc#"$PROJECT"/}"
    if ! grep -rqF "$rel" "$PROJECT/docs/specs" 2>/dev/null; then
        ORPHANS="$ORPHANS  - $rel"$'\n'
    fi
done < <(find "$PROJECT/docs/archive" -type f -name '*.md' -print 2>/dev/null | sort)

echo "archived documents not listed in any spec Sources section:"
if [ -z "$ORPHANS" ]; then
    echo "  (none)"
else
    printf '%s' "$ORPHANS"
fi
