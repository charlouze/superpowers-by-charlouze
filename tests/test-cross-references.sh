#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-cross-references"

KNOWN_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch"
# Commands share the plugin namespace with the skills: /supercharlouze:init is a
# command, not a skill, so it resolves against commands/<name>.md instead.
KNOWN_COMMANDS="init"

# 1. Every supercharlouze:<name> reference names a skill or a command that exists.
#    README.md is scanned too — it names all five skills and the init command.
#    begin/end are the CLAUDE.md block markers, not references.
BAD=0
while read -r ref; do
    [ -n "$ref" ] || continue
    found=0
    for s in $KNOWN_SKILLS; do
        if [ "$ref" = "$s" ] && [ -f "$REPO_ROOT/skills/$s/SKILL.md" ]; then
            found=1
        fi
    done
    for c in $KNOWN_COMMANDS; do
        if [ "$ref" = "$c" ] && [ -f "$REPO_ROOT/commands/$c.md" ]; then
            found=1
        fi
    done
    if [ "$found" = "0" ]; then
        echo "    unknown reference: supercharlouze:$ref"
        BAD=$((BAD + 1))
    fi
done < <(grep -rhoE 'supercharlouze:[a-z-]+' \
             "$REPO_ROOT/skills" "$REPO_ROOT/commands" "$REPO_ROOT/README.md" 2>/dev/null \
         | sed 's/^supercharlouze://' | grep -vxE 'begin|end' | sort -u || true)

if [ "$BAD" = "0" ]; then
    pass "every supercharlouze: skill or command reference resolves"
else
    fail "every supercharlouze: skill or command reference resolves ($BAD unknown)"
fi

# 2. Every repo-relative path in backticks exists.
BAD=0
while read -r p; do
    [ -n "$p" ] || continue
    if [ ! -e "$REPO_ROOT/$p" ]; then
        echo "    missing path: $p"
        BAD=$((BAD + 1))
    fi
done < <(grep -rhoE '`(skills|scripts|commands|tests|\.claude-plugin)/[A-Za-z0-9._/-]+`' \
         "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null | tr -d '`' | sort -u || true)

if [ "$BAD" = "0" ]; then
    pass "every repo-relative path referenced in skills exists"
else
    fail "every repo-relative path referenced in skills exists ($BAD missing)"
fi

# 3. The canonical block lives in exactly one file (spec 8.1).
COPIES="$(grep -rl "supercharlouze:begin" "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null | wc -l | tr -d ' ' || true)"
if [ "$COPIES" = "1" ]; then
    pass "the CLAUDE.md block exists in exactly one file"
else
    fail "the CLAUDE.md block exists in exactly one file (found $COPIES)"
fi

# 4. The bounded path is spelled out (spec 8.2) — it has no skill of its own.
UB="$(awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$REPO_ROOT/skills/using-batches/SKILL.md" | tr '\n' ' ')"
has() { case "$2" in *"$1"*) return 0 ;; *) return 1 ;; esac }
for needle in "out-of-batch" "never leaves the spec silent" "fix/" "no feature flag"; do
    if has "$needle" "$UB"; then
        pass "bounded path states: $needle"
    else
        fail "bounded path states: $needle"
    fi
done

# 5. No shipped artifact cites a numbered section of the archived design
#    document. The living spec is the binding authority and its sections are
#    titled, not numbered: a numbered pointer names a document that adoption
#    stripped of authority, and it rots further at every reshuffle of the spec.
#    tests/ is deliberately out of range — it is not shipped to users, and the
#    gaps register entry this guard answers to names only the shipped artifacts.
BAD=0
while read -r hit; do
    [ -n "$hit" ] || continue
    echo "    numbered reference to the archived design document: $hit"
    BAD=$((BAD + 1))
done < <(grep -rnoEi 'spec section [0-9]+|section [0-9]+ of the design|\(spec [0-9]+(\.[0-9]+)?\)' \
             "$REPO_ROOT/README.md" "$REPO_ROOT/skills" "$REPO_ROOT/commands" "$REPO_ROOT/scripts" \
             2>/dev/null | sort -u || true)

if [ "$BAD" = "0" ]; then
    pass "no shipped artifact cites a numbered section of the archived design document"
else
    fail "no shipped artifact cites a numbered section of the archived design document ($BAD found)"
fi

exit $((FAILURES > 0))
