#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INIT="$REPO_ROOT/scripts/init.sh"
BLOCK="$REPO_ROOT/skills/using-batches/references/claude-md-block.md"
FAILURES=0
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }
count() { grep -c "$1" "$2" 2>/dev/null || true; }

echo "test-init"

if [ -f "$INIT" ]; then
    pass "scripts/init.sh exists"
else
    fail "scripts/init.sh exists"
    exit 1
fi

# --- Case 1: project with no CLAUDE.md ---
P1="$TEST_ROOT/fresh"
mkdir -p "$P1"
bash "$INIT" "$P1" >/dev/null

for d in docs/specs docs/batches docs/archive; do
    if [ -d "$P1/$d" ]; then pass "fresh: $d created"; else fail "fresh: $d created"; fi
done

if [ -f "$P1/CLAUDE.md" ] && grep -q "supercharlouze:using-batches" "$P1/CLAUDE.md"; then
    pass "fresh: CLAUDE.md created with the block"
else
    fail "fresh: CLAUDE.md created with the block"
fi

# --- Case 2: idempotence ---
bash "$INIT" "$P1" >/dev/null
if [ "$(count "supercharlouze:begin" "$P1/CLAUDE.md")" = "1" ]; then
    pass "idempotent: block appears exactly once after two runs"
else
    fail "idempotent: block appears exactly once after two runs"
fi

# --- Case 3: existing CLAUDE.md is preserved ---
P2="$TEST_ROOT/existing"
mkdir -p "$P2"
printf '# My project\n\nSome house rules.\n' > "$P2/CLAUDE.md"
bash "$INIT" "$P2" >/dev/null
if grep -q "Some house rules." "$P2/CLAUDE.md" && grep -q "supercharlouze:using-batches" "$P2/CLAUDE.md"; then
    pass "existing: prior content preserved and block appended"
else
    fail "existing: prior content preserved and block appended"
fi

# --- Case 4: a stale block is replaced in place, surrounding content survives ---
P3="$TEST_ROOT/stale"
mkdir -p "$P3"
printf '# P\n\nBEFORE\n\n<!-- supercharlouze:begin -->\nOLD\n<!-- supercharlouze:end -->\n\nAFTER\n' > "$P3/CLAUDE.md"
bash "$INIT" "$P3" >/dev/null
if ! grep -q "OLD" "$P3/CLAUDE.md" \
   && grep -q "BEFORE" "$P3/CLAUDE.md" \
   && grep -q "AFTER" "$P3/CLAUDE.md" \
   && [ "$(count "supercharlouze:begin" "$P3/CLAUDE.md")" = "1" ]; then
    pass "stale: block replaced, content before and after preserved"
else
    fail "stale: block replaced, content before and after preserved"
fi

# --- Case 5: unbalanced markers must abort, not eat the file ---
P4="$TEST_ROOT/unbalanced"
mkdir -p "$P4"
printf '# P\n\n<!-- supercharlouze:begin -->\nHALF\n\nUSER CONTENT THAT MUST SURVIVE\n' > "$P4/CLAUDE.md"
BEFORE="$(cat "$P4/CLAUDE.md")"
if bash "$INIT" "$P4" >/dev/null 2>&1; then
    fail "unbalanced: init exits non-zero"
else
    pass "unbalanced: init exits non-zero"
fi
if [ "$(cat "$P4/CLAUDE.md")" = "$BEFORE" ]; then
    pass "unbalanced: CLAUDE.md left untouched"
else
    fail "unbalanced: CLAUDE.md left untouched"
fi

# --- Case 6: superpowers documents are archived ---
P5="$TEST_ROOT/migrate"
mkdir -p "$P5/docs/superpowers/specs" "$P5/docs/superpowers/plans"
touch "$P5/docs/superpowers/specs/2025-01-01-thing-design.md"
touch "$P5/docs/superpowers/plans/2025-01-02-thing.md"
bash "$INIT" "$P5" >/dev/null
if [ -f "$P5/docs/archive/specs/2025-01-01-thing-design.md" ] \
   && [ -f "$P5/docs/archive/plans/2025-01-02-thing.md" ]; then
    pass "migrate: superpowers docs moved under docs/archive"
else
    fail "migrate: superpowers docs moved under docs/archive"
fi

# --- Case 7: the inserted block matches the canonical source byte for byte ---
CANON="$(cat "$BLOCK")"
INSERTED="$(sed -n '/supercharlouze:begin/,/supercharlouze:end/p' "$P1/CLAUDE.md")"
if [ "$CANON" = "$INSERTED" ]; then
    pass "inserted block is byte-identical to the canonical source"
else
    fail "inserted block is byte-identical to the canonical source"
fi

# --- Case 8: prose that merely names both markers is not a block ---
# Only the anchored comment lines are markers. A sentence mentioning both names
# must not be mistaken for a balanced pair, and must not be treated as a block
# opening either — everything after it has to survive.
P6="$TEST_ROOT/prose"
mkdir -p "$P6"
printf '# P\n\nNever hand-edit between supercharlouze:begin and supercharlouze:end.\n\nUSER CONTENT THAT MUST SURVIVE\n' > "$P6/CLAUDE.md"
if bash "$INIT" "$P6" >/dev/null 2>&1; then
    pass "prose markers: init succeeds"
else
    fail "prose markers: init succeeds"
fi
if grep -q "USER CONTENT THAT MUST SURVIVE" "$P6/CLAUDE.md" \
   && grep -q "Never hand-edit between" "$P6/CLAUDE.md"; then
    pass "prose markers: user content survives"
else
    fail "prose markers: user content survives"
fi
if [ "$(count "<!-- supercharlouze:begin -->" "$P6/CLAUDE.md")" = "1" ]; then
    pass "prose markers: the real block is appended exactly once"
else
    fail "prose markers: the real block is appended exactly once"
fi

# --- Case 9: a closing marker before an opening one must abort ---
P7="$TEST_ROOT/inverted"
mkdir -p "$P7"
printf '# P\n\n<!-- supercharlouze:end -->\nMIDDLE\n<!-- supercharlouze:begin -->\n\nUSER CONTENT THAT MUST SURVIVE\n' > "$P7/CLAUDE.md"
BEFORE7="$(cat "$P7/CLAUDE.md")"
if bash "$INIT" "$P7" >/dev/null 2>&1; then
    fail "inverted markers: init exits non-zero"
else
    pass "inverted markers: init exits non-zero"
fi
if [ "$(cat "$P7/CLAUDE.md")" = "$BEFORE7" ]; then
    pass "inverted markers: CLAUDE.md left untouched"
else
    fail "inverted markers: CLAUDE.md left untouched"
fi

# --- Case 10: duplicated markers must abort ---
P8="$TEST_ROOT/duplicated"
mkdir -p "$P8"
printf '# P\n\n<!-- supercharlouze:begin -->\nA\n<!-- supercharlouze:end -->\n\n<!-- supercharlouze:begin -->\nB\n<!-- supercharlouze:end -->\n' > "$P8/CLAUDE.md"
BEFORE8="$(cat "$P8/CLAUDE.md")"
if bash "$INIT" "$P8" >/dev/null 2>&1; then
    fail "duplicated markers: init exits non-zero"
else
    pass "duplicated markers: init exits non-zero"
fi
if [ "$(cat "$P8/CLAUDE.md")" = "$BEFORE8" ]; then
    pass "duplicated markers: CLAUDE.md left untouched"
else
    fail "duplicated markers: CLAUDE.md left untouched"
fi

# --- Case 11: nested archive content migrates, relative paths preserved ---
P9="$TEST_ROOT/nested"
mkdir -p "$P9/docs/superpowers/specs/nested" "$P9/docs/superpowers/plans/2025"
touch "$P9/docs/superpowers/specs/flat.md"
touch "$P9/docs/superpowers/specs/nested/deep.md"
touch "$P9/docs/superpowers/plans/2025/old.md"
bash "$INIT" "$P9" >/dev/null
if [ -f "$P9/docs/archive/specs/flat.md" ] \
   && [ -f "$P9/docs/archive/specs/nested/deep.md" ] \
   && [ -f "$P9/docs/archive/plans/2025/old.md" ]; then
    pass "nested: the whole subtree migrates under docs/archive"
else
    fail "nested: the whole subtree migrates under docs/archive"
fi
if [ ! -d "$P9/docs/superpowers" ]; then
    pass "nested: docs/superpowers is gone once emptied"
else
    fail "nested: docs/superpowers is gone once emptied"
fi

# --- Case 12: a destination collision must not silently overwrite ---
P10="$TEST_ROOT/collision"
mkdir -p "$P10/docs/superpowers/specs" "$P10/docs/archive/specs"
printf 'INCOMING\n' > "$P10/docs/superpowers/specs/foo.md"
printf 'EXISTING\n' > "$P10/docs/archive/specs/foo.md"
if bash "$INIT" "$P10" >/dev/null 2>&1; then
    fail "collision: init exits non-zero"
else
    pass "collision: init exits non-zero"
fi
if grep -q "EXISTING" "$P10/docs/archive/specs/foo.md"; then
    pass "collision: the archived file is not overwritten"
else
    fail "collision: the archived file is not overwritten"
fi
if [ -f "$P10/docs/superpowers/specs/foo.md" ]; then
    pass "collision: the incoming file is left in place"
else
    fail "collision: the incoming file is left in place"
fi

# --- Case 13: a pre-existing CLAUDE.md.tmp is not clobbered ---
P11="$TEST_ROOT/tmpfile"
mkdir -p "$P11"
printf '# P\n\n<!-- supercharlouze:begin -->\nOLD\n<!-- supercharlouze:end -->\n' > "$P11/CLAUDE.md"
printf 'PRECIOUS\n' > "$P11/CLAUDE.md.tmp"
bash "$INIT" "$P11" >/dev/null
if [ -f "$P11/CLAUDE.md.tmp" ] && grep -q "PRECIOUS" "$P11/CLAUDE.md.tmp"; then
    pass "tempfile: a pre-existing CLAUDE.md.tmp survives"
else
    fail "tempfile: a pre-existing CLAUDE.md.tmp survives"
fi

# --- Case 14: empty report lists say so instead of showing a bare heading ---
REPORT="$TEST_ROOT/report.txt"
bash "$INIT" "$P1" > "$REPORT"
ADOPTED_NEXT="$(awk '/^adopted modules:/ { getline; print; exit }' "$REPORT")"
if printf '%s' "$ADOPTED_NEXT" | grep -qi "none"; then
    pass "report: an empty adopted-modules list says none"
else
    fail "report: an empty adopted-modules list says none"
fi

# --- Case 15: a spec carries no list of sources, so the report ties no archived
# document to a spec. Archived documents are dead once adopted from; a living
# spec that pointed at them would drift from them. ---
P12="$TEST_ROOT/archive-only"
mkdir -p "$P12/docs/specs" "$P12/docs/archive/specs"
touch "$P12/docs/archive/specs/2025-01-01-legacy-design.md"
REPORT12="$TEST_ROOT/report12.txt"
bash "$INIT" "$P12" > "$REPORT12"
if grep -qiE "sources|claim|2025-01-01-legacy-design" "$REPORT12"; then
    fail "report: no archived document is tied to a spec"
else
    pass "report: no archived document is tied to a spec"
fi

# --- Case 17: what the plugin does not own is neither moved nor removed ---
# The spec says docs/superpowers is dropped once emptied, and *only* once
# emptied. Case 11 covers the first half; nothing covered the second.
P14="$TEST_ROOT/foreign"
mkdir -p "$P14/docs/superpowers/specs" "$P14/docs/superpowers/notes"
touch "$P14/docs/superpowers/specs/moved.md"
printf 'KEEP\n' > "$P14/docs/superpowers/notes/keep.md"
bash "$INIT" "$P14" >/dev/null
if [ -f "$P14/docs/archive/specs/moved.md" ]; then
    pass "foreign: the plugin's own documents still migrate"
else
    fail "foreign: the plugin's own documents still migrate"
fi
if [ -f "$P14/docs/superpowers/notes/keep.md" ] \
   && grep -q "KEEP" "$P14/docs/superpowers/notes/keep.md"; then
    pass "foreign: a document the plugin does not own is left untouched"
else
    fail "foreign: a document the plugin does not own is left untouched"
fi
if [ -d "$P14/docs/superpowers" ]; then
    pass "foreign: docs/superpowers survives while it still holds something"
else
    fail "foreign: docs/superpowers survives while it still holds something"
fi

# --- Case 18: the CLAUDE.md file mode survives the temp-file swap ---
# The rewrite goes through a file mktemp creates as 0600, so the target's mode
# has to be restored explicitly. This filesystem does not carry every mode bit
# — it tracks the write bit and little else, so 600, 644 and 755 all read back
# as 644 — but a read-only fixture discriminates cleanly, which is enough to
# tell a restored mode from a lost one. The mode is captured rather than
# hard-coded, so the assertion holds wherever the suite runs.
file_mode() { stat -c '%a' "$1" 2>/dev/null || stat -f '%Lp' "$1"; }
P17="$TEST_ROOT/mode"
mkdir -p "$P17"
printf '# P\n\n<!-- supercharlouze:begin -->\nOLD\n<!-- supercharlouze:end -->\n' > "$P17/CLAUDE.md"
chmod 555 "$P17/CLAUDE.md"
MODE17_BEFORE="$(file_mode "$P17/CLAUDE.md")"
bash "$INIT" "$P17" >/dev/null
if [ "$(file_mode "$P17/CLAUDE.md")" = "$MODE17_BEFORE" ]; then
    pass "init preserves the CLAUDE.md mode across the temp-file swap"
else
    fail "init preserves the CLAUDE.md mode across the temp-file swap"
fi

# --- Case 19: a closing marker with no opening one must abort ---
# Of the broken-marker forms the script refuses, the only one no fixture
# reached. Its branch in the script looks like a near-duplicate of the one
# above it, which is exactly the kind of line a later simplification deletes.
P18="$TEST_ROOT/endonly"
mkdir -p "$P18"
printf '# P\n\n<!-- supercharlouze:end -->\n\nUSER CONTENT THAT MUST SURVIVE\n' > "$P18/CLAUDE.md"
BEFORE18="$(cat "$P18/CLAUDE.md")"
if bash "$INIT" "$P18" >/dev/null 2>&1; then
    fail "end-only marker: init exits non-zero"
else
    pass "end-only marker: init exits non-zero"
fi
if [ "$(cat "$P18/CLAUDE.md")" = "$BEFORE18" ]; then
    pass "end-only marker: CLAUDE.md left untouched"
else
    fail "end-only marker: CLAUDE.md left untouched"
fi

# --- Case 20: every occupied destination is named before anything moves ---
P19="$TEST_ROOT/collisions"
mkdir -p "$P19/docs/superpowers/specs" "$P19/docs/superpowers/plans" \
         "$P19/docs/archive/specs" "$P19/docs/archive/plans"
printf 'INCOMING\n' > "$P19/docs/superpowers/specs/a.md"
printf 'INCOMING\n' > "$P19/docs/superpowers/plans/b.md"
printf 'FREE\n' > "$P19/docs/superpowers/specs/c.md"
printf 'EXISTING\n' > "$P19/docs/archive/specs/a.md"
printf 'EXISTING\n' > "$P19/docs/archive/plans/b.md"
ERR19="$TEST_ROOT/collisions.err"
if bash "$INIT" "$P19" >/dev/null 2>"$ERR19"; then
    fail "collisions: init exits non-zero"
else
    pass "collisions: init exits non-zero"
fi
if grep -qF "docs/archive/specs/a.md" "$ERR19" && grep -qF "docs/archive/plans/b.md" "$ERR19"; then
    pass "collisions: every occupied destination is named"
else
    fail "collisions: every occupied destination is named"
fi
if [ -f "$P19/docs/superpowers/specs/c.md" ] && [ ! -e "$P19/docs/archive/specs/c.md" ]; then
    pass "collisions: nothing moves, not even a free document"
else
    fail "collisions: nothing moves, not even a free document"
fi

# --- Case 21: specs/ and plans/ move whole, empty directories included ---
P20="$TEST_ROOT/emptydirs"
mkdir -p "$P20/docs/superpowers/specs/empty" "$P20/docs/superpowers/plans/2025/empty"
touch "$P20/docs/superpowers/plans/2025/old.md"
bash "$INIT" "$P20" >/dev/null
if [ -d "$P20/docs/archive/specs/empty" ] && [ -d "$P20/docs/archive/plans/2025/empty" ]; then
    pass "empty directories: they move with their tree"
else
    fail "empty directories: they move with their tree"
fi
if [ ! -d "$P20/docs/superpowers" ]; then
    pass "empty directories: docs/superpowers is gone once emptied"
else
    fail "empty directories: docs/superpowers is gone once emptied"
fi

# --- Case 22: the report lists the ADRs docs/adr/ already carries ---
# An ADR is a .md file placed directly in docs/adr/: another file, a directory
# named *.md, or a .md file deeper down is not one.
adr_list() { awk '/^existing ADRs:/ { f = 1; next } f && /^  / { print; next } f { exit }' "$1"; }
P21="$TEST_ROOT/adrs"
mkdir -p "$P21/docs/adr/drafts" "$P21/docs/adr/folder.md"
printf '# A\n' > "$P21/docs/adr/a-decision.md"
printf '# B\n' > "$P21/docs/adr/b decision.md"
printf 'notes\n' > "$P21/docs/adr/notes.txt"
printf '# C\n' > "$P21/docs/adr/drafts/c-decision.md"
REPORT21="$TEST_ROOT/report21.txt"
bash "$INIT" "$P21" > "$REPORT21"
EXPECTED21="$(printf '  - docs/adr/a-decision.md\n  - docs/adr/b decision.md')"
if [ "$(adr_list "$REPORT21")" = "$EXPECTED21" ]; then
    pass "report: the ADRs listed are the .md files placed directly in docs/adr/"
else
    fail "report: the ADRs listed are the .md files placed directly in docs/adr/"
fi

# --- Case 23: a project without docs/adr/ has no ADR, and gets no docs/adr/ ---
# Case 14 ran the script on P1, which has no docs/adr/.
if [ "$(adr_list "$REPORT")" = "  (none)" ]; then
    pass "report: no docs/adr/ lists the ADRs as none"
else
    fail "report: no docs/adr/ lists the ADRs as none"
fi
if [ ! -e "$P1/docs/adr" ]; then
    pass "init does not create docs/adr/"
else
    fail "init does not create docs/adr/"
fi

# --- Case 24: an empty docs/adr/ has no ADR ---
P22="$TEST_ROOT/adr-empty"
mkdir -p "$P22/docs/adr"
REPORT22="$TEST_ROOT/report22.txt"
bash "$INIT" "$P22" > "$REPORT22"
if [ "$(adr_list "$REPORT22")" = "  (none)" ]; then
    pass "report: an empty docs/adr/ lists the ADRs as none"
else
    fail "report: an empty docs/adr/ lists the ADRs as none"
fi

exit $((FAILURES > 0))
