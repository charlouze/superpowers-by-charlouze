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

BODY_FLAT="$(printf '%s\n' "$body" | tr '\n' ' ' | tr -s ' ')"
has() { case "$2" in *"$1"*) return 0 ;; *) return 1 ;; esac }

for needle in "scripts/init.sh" "supercharlouze:using-batches" "chore/supercharlouze-init"; do
    if has "$needle" "$BODY_FLAT"; then
        pass "command body mentions $needle"
    else
        fail "command body mentions $needle"
    fi
done

# The command adopts nothing and proposes no module breakdown.
if has "Do not adopt" "$BODY_FLAT" && has "module breakdown" "$BODY_FLAT"; then
    pass "command forbids adopting and proposing a breakdown"
else
    fail "command forbids adopting and proposing a breakdown"
fi

# The command puts to the human each ADR the script lists, under the heading
# the script prints, before committing; it tells them the code to come holds
# the ADRs they keep, and deletes the abandoned ones in a commit of its own
# that says why.
if has '`existing ADRs:`' "$BODY_FLAT" \
   && grep -qxF 'echo "existing ADRs:"' "$REPO_ROOT/scripts/init.sh"; then
    pass "command names the ADR heading the script prints"
else
    fail "command names the ADR heading the script prints"
fi

case "$BODY_FLAT" in
    *'Before committing, put each ADR the script lists under `existing ADRs:` to your human partner.'*"Commit what the script changed."*)
        pass "command puts the listed ADRs to the human before committing" ;;
    *)  fail "command puts the listed ADRs to the human before committing" ;;
esac

if has "Tell them that the code written from now on must hold every ADR they keep. Ask, for each one, whether they keep or abandon it, and why when they abandon it." "$BODY_FLAT"; then
    pass "command tells the human the code to come holds the ADRs they keep"
else
    fail "command tells the human the code to come holds the ADRs they keep"
fi

if has "Keep an ADR they want rewritten: this pull request rewrites none." "$BODY_FLAT"; then
    pass "command rewrites no ADR"
else
    fail "command rewrites no ADR"
fi

if has "Then delete the ADRs your human partner abandoned, in a commit of its own whose message says why each one is abandoned." "$BODY_FLAT"; then
    pass "command deletes the abandoned ADRs in a commit of its own that says why"
else
    fail "command deletes the abandoned ADRs in a commit of its own that says why"
fi

if has "which modules are adopted, and which ADRs your human partner kept." "$BODY_FLAT"; then
    pass "command reports the ADRs kept"
else
    fail "command reports the ADRs kept"
fi

exit $((FAILURES > 0))
