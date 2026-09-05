#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-command"

CMD="$REPO_ROOT/commands/init.md"

if [ -f "$CMD" ]; then
    pass "commands/init.md exists"
else
    fail "commands/init.md exists"
    exit 1
fi

if [ "$(head -1 "$CMD")" = "---" ]; then
    pass "command frontmatter opens on line 1"
else
    fail "command frontmatter opens on line 1"
fi

front="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$CMD")"
body="$(awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$CMD")"

for field in description argument-hint; do
    if printf '%s\n' "$front" | grep -q "^$field:"; then
        pass "command has $field"
    else
        fail "command has $field"
    fi
done

BODY_FLAT="$(printf '%s\n' "$body" | tr '\n' ' ')"
has() { case "$2" in *"$1"*) return 0 ;; *) return 1 ;; esac }

for needle in "scripts/init.sh" "supercharlouze:using-batches" "chore/supercharlouze-init"; do
    if has "$needle" "$BODY_FLAT"; then
        pass "command body mentions $needle"
    else
        fail "command body mentions $needle"
    fi
done

# Spec 9: init adopts nothing and proposes no module breakdown.
if has "Do not adopt" "$BODY_FLAT" && has "module breakdown" "$BODY_FLAT"; then
    pass "command forbids adopting and proposing a breakdown"
else
    fail "command forbids adopting and proposing a breakdown"
fi

exit $((FAILURES > 0))
