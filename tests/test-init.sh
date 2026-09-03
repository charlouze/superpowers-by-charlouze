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

exit $((FAILURES > 0))
