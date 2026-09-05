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
ARCHIVED_NEXT="$(awk '/^archived documents not listed/ { getline; print; exit }' "$REPORT")"
if printf '%s' "$ADOPTED_NEXT" | grep -qi "none"; then
    pass "report: an empty adopted-modules list says none"
else
    fail "report: an empty adopted-modules list says none"
fi
if printf '%s' "$ARCHIVED_NEXT" | grep -qi "none"; then
    pass "report: an empty archived-documents list says none"
else
    fail "report: an empty archived-documents list says none"
fi

# --- Case 15: only a spec's ## Sources section counts as a claim on an
# archived document. A path that merely appears in a Changelog table cell or
# in the module's .gaps.md file must NOT suppress the document from being
# reported as unclaimed — those are prose mentions, not claims. ---
P12="$TEST_ROOT/sources-scope-unclaimed"
mkdir -p "$P12/docs/specs" "$P12/docs/archive/specs"
touch "$P12/docs/archive/specs/2025-01-01-legacy-design.md"
cat > "$P12/docs/specs/2025-02-01-mything-design.md" <<'EOF'
# mything design

## Changelog

| Date | Note |
| --- | --- |
| 2025-02-01 | migrated from docs/archive/specs/2025-01-01-legacy-design.md |

## Sources

- none
EOF
cat > "$P12/docs/specs/2025-02-01-mything-design.gaps.md" <<'EOF'
# mything gaps

Still refers to docs/archive/specs/2025-01-01-legacy-design.md for context.
EOF
REPORT12="$TEST_ROOT/report12.txt"
bash "$INIT" "$P12" > "$REPORT12"
if grep -qF "docs/archive/specs/2025-01-01-legacy-design.md" "$REPORT12"; then
    pass "sources scope: a document named only in Changelog/gaps is reported as unclaimed"
else
    fail "sources scope: a document named only in Changelog/gaps is reported as unclaimed"
fi

# --- Case 16: companion to Case 15 — a path actually listed under a spec's
# ## Sources section must NOT be reported as unclaimed, so the fix cannot pass
# by simply listing every archived document regardless of content. ---
P13="$TEST_ROOT/sources-scope-claimed"
mkdir -p "$P13/docs/specs" "$P13/docs/archive/specs"
touch "$P13/docs/archive/specs/2025-01-01-legacy-design.md"
cat > "$P13/docs/specs/2025-02-01-mything-design.md" <<'EOF'
# mything design

## Changelog

| Date | Note |
| --- | --- |
| 2025-02-01 | migrated from docs/archive/specs/2025-01-01-legacy-design.md |

## Sources

- docs/archive/specs/2025-01-01-legacy-design.md
EOF
cat > "$P13/docs/specs/2025-02-01-mything-design.gaps.md" <<'EOF'
# mything gaps

Still refers to docs/archive/specs/2025-01-01-legacy-design.md for context.
EOF
REPORT13="$TEST_ROOT/report13.txt"
bash "$INIT" "$P13" > "$REPORT13"
if grep -qF "docs/archive/specs/2025-01-01-legacy-design.md" "$REPORT13"; then
    fail "sources scope: a document named under Sources is not reported as unclaimed"
else
    pass "sources scope: a document named under Sources is not reported as unclaimed"
fi

exit $((FAILURES > 0))
