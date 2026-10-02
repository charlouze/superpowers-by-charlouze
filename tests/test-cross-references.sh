#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-cross-references"

KNOWN_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch rereading-a-spec rereading-a-technical-design recording-a-decision"
# Commands share the plugin namespace with the skills: /supercharlouze:init is a
# command, not a skill, so it resolves against commands/<name>.md instead.
KNOWN_COMMANDS="init"

# 1. Every supercharlouze:<name> reference names a skill or a command that exists.
#    README.md and CONTRIBUTING.md are scanned too — they name the skills
#    and the init command.
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
             "$REPO_ROOT/skills" "$REPO_ROOT/commands" "$REPO_ROOT/README.md" \
             "$REPO_ROOT/CONTRIBUTING.md" 2>/dev/null \
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
for needle in "if and only if nothing observable" "bounded/" "no feature flag"; do
    if has "$needle" "$UB"; then
        pass "bounded path states: $needle"
    else
        fail "bounded path states: $needle"
    fi
done

# The README states the same rules for a human reader who has read nothing
# else. It is the one shipped artifact that paraphrases them, so it is also the
# one that can keep asserting the unconditional version after the skill stopped.
# The needle carries "no change" so it cannot match the true rule, which reads
# "leaves the spec silent if and only if" — the trap the `absent` helper in
# test-skill-contracts.sh documents avoiding.
if grep -q "no change leaves the spec silent" "$REPO_ROOT/README.md"; then
    fail "the README does not assert the unconditional spec update"
else
    pass "the README does not assert the unconditional spec update"
fi

# The README row of rereading-a-spec says it is not for direct use, and names
# none of the skills that invoke it.
RROW="$(grep -F '`supercharlouze:rereading-a-spec`' "$REPO_ROOT/README.md" || true)"
case "$RROW" in
    *"adopting-a-module"*|*"writing-a-batch"*|*"invoked by"*)
        fail "the README row of rereading-a-spec names no caller" ;;
    *)  pass "the README row of rereading-a-spec names no caller" ;;
esac
case "$RROW" in
    *"Never directly"*) pass "the README row of rereading-a-spec rules out direct use" ;;
    *)                  fail "the README row of rereading-a-spec rules out direct use" ;;
esac

# The README row of rereading-a-technical-design, like the spec reread's, says it
# is not for direct use and names none of the skills that invoke it.
TROW="$(grep -F '`supercharlouze:rereading-a-technical-design`' "$REPO_ROOT/README.md" || true)"
case "$TROW" in
    *"writing-a-batch"*|*"invoked by"*)
        fail "the README row of rereading-a-technical-design names no caller" ;;
    *)  pass "the README row of rereading-a-technical-design names no caller" ;;
esac
case "$TROW" in
    *"Never directly"*) pass "the README row of rereading-a-technical-design rules out direct use" ;;
    *)                  fail "the README row of rereading-a-technical-design rules out direct use" ;;
esac

# The README row of recording-a-decision, like the rereads', says it is not for
# direct use and names none of the skills that invoke it.
DROW="$(grep -F '`supercharlouze:recording-a-decision`' "$REPO_ROOT/README.md" || true)"
case "$DROW" in
    *"writing-a-batch"*|*"writing-a-user-story"*|*"adopting-a-module"*|*"invoked by"*)
        fail "the README row of recording-a-decision names no caller" ;;
    *)  pass "the README row of recording-a-decision names no caller" ;;
esac
case "$DROW" in
    *"Never directly"*) pass "the README row of recording-a-decision rules out direct use" ;;
    *)                  fail "the README row of recording-a-decision rules out direct use" ;;
esac

# The rereads use three skills when they are installed; the README recommends
# them all, since nothing else tells a user they exist. Anchored on the
# recommendation itself: a skill named anywhere else in the README proves nothing.
README_REC="$(tr '\n' ' ' < "$REPO_ROOT/README.md" | tr -s ' ')"
case "$README_REC" in
    *"**Recommended: the \`domain-driven-design\`, \`clean-architecture\` and \`software-design-philosophy\` skills.**"*)
        pass "the README recommends the skills the rereads use" ;;
    *)  fail "the README recommends the skills the rereads use" ;;
esac

# The specs carry no changelog any more, and the README says nothing of one.
if grep -qi "changelog" "$REPO_ROOT/README.md"; then
    fail "the README names no changelog"
else
    pass "the README names no changelog"
fi

# A bounded change lives on `bounded/<slug>`; the former name survives nowhere.
if grep -q "fix/" "$REPO_ROOT/README.md"; then
    fail "the README names no fix/ branch"
else
    pass "the README names no fix/ branch"
fi

# The amendment gate covers the technical design and the constraints, in the
# README's gate table too.
if grep -q "a change of scope, of spec delta, of technical design, of constraints or of flag on an open batch" "$REPO_ROOT/README.md"; then
    pass "the README's amendment gate covers the design and the constraints"
else
    fail "the README's amendment gate covers the design and the constraints"
fi

# The README presumes no continuous deployment either.
if grep -qi "continuous" "$REPO_ROOT/README.md"; then
    fail "the README requires no continuous deployment"
else
    pass "the README requires no continuous deployment"
fi

# The README defines drift as the spec does: code that contradicts the spec, or
# behaviour no spec describes.
README_FLAT="$(tr '\n' ' ' < "$REPO_ROOT/README.md" | tr -s ' ')"
case "$README_FLAT" in
    *"any code on \`main\` that contradicts the spec on \`main\`, and any behaviour on \`main\` that no spec describes, is drift"*)
        pass "the README defines drift as the spec does" ;;
    *)
        fail "the README defines drift as the spec does" ;;
esac

# The README defines the ADR in its model, and states what a bounded change may
# do with one.
case "$README_FLAT" in
    *"- **ADR** — the document that records a technical decision of the project and its reason, at \`docs/adr/<slug>.md\`."*)
        pass "the README defines the ADR" ;;
    *)  fail "the README defines the ADR" ;;
esac
case "$README_FLAT" in
    *"A decision earns one only if undoing it is expensive, it surprises whoever does not know its context, and it settles between real alternatives."*)
        pass "the README states the conditions of an ADR" ;;
    *)  fail "the README states the conditions of an ADR" ;;
esac
case "$README_FLAT" in
    *"A human decides every one."*)
        pass "the README says a human decides every ADR" ;;
    *)  fail "the README says a human decides every ADR" ;;
esac
case "$README_FLAT" in
    *"it may write, rewrite and delete ADRs, or carry nothing but ADRs;"*)
        pass "the README lets a bounded change write ADRs" ;;
    *)  fail "the README lets a bounded change write ADRs" ;;
esac
# The adoption gate reviews the ADRs the adoption wrote, in the README's gate
# table too.
case "$README_FLAT" in
    *"| Module adoption | the spec and the gaps register, and the ADRs written with them, before any batch touches that module |"*)
        pass "the README's adoption gate covers the ADRs" ;;
    *)  fail "the README's adoption gate covers the ADRs" ;;
esac
case "$README_FLAT" in
    *"it holds the ADRs \`main\` carries when its branch starts, and puts to the human one it cannot hold;"*)
        pass "the README makes a bounded change hold the ADRs" ;;
    *)  fail "the README makes a bounded change hold the ADRs" ;;
esac
case "$README_FLAT" in
    *"and it puts to the human the technical decision it takes that would earn an ADR."*)
        pass "the README makes a bounded change put its decision to the human" ;;
    *)  fail "the README makes a bounded change put its decision to the human" ;;
esac
# The delivery gate carries the ADRs the review asks for, in the README's gate
# table too.
case "$README_FLAT" in
    *"| Story delivery | a story's code, its spec change if it has one, and the ADRs the review asks for, in one diff |"*)
        pass "the README's delivery gate carries the ADRs the review asks for" ;;
    *)  fail "the README's delivery gate carries the ADRs the review asks for" ;;
esac

# The opening gate carries the ADRs written, rewritten or deleted with the batch
# document, in the README's gate table too.
case "$README_FLAT" in
    *"| Batch opening | the exact text each spec will receive, before a line of code is written against it, and the ADRs written, rewritten or deleted with it |"*)
        pass "the README's opening gate carries the ADRs changed with the batch document" ;;
    *)  fail "the README's opening gate carries the ADRs changed with the batch document" ;;
esac

# The amendment gate carries the ADRs written, rewritten or deleted with the
# amendment, in the README's gate table too.
case "$README_FLAT" in
    *"| Batch amendment | a change of scope, of spec delta, of technical design, of constraints or of flag on an open batch, and the ADRs written, rewritten or deleted with it |"*)
        pass "the README's amendment gate carries the ADRs changed with the amendment" ;;
    *)  fail "the README's amendment gate carries the ADRs changed with the amendment" ;;
esac

# The README extends the stop condition on a constraint to an ADR.
case "$README_FLAT" in
    *"If a story finds that a constraint of its batch or an ADR cannot be held, it stops and puts it to the human. An agent may neither correct a spec, nor keep a qualification it has lost, nor bend a constraint or an ADR."*)
        pass "the README's stop condition covers the ADR" ;;
    *)  fail "the README's stop condition covers the ADR" ;;
esac

# 5. No shipped artifact cites a numbered section of the archived design
#    document. The living spec is the binding authority and its sections are
#    titled, not numbered: a numbered pointer names a document that adoption
#    stripped of authority, and it rots further at every reshuffle of the spec.
#    tests/ is out of range.
BAD=0
while read -r hit; do
    [ -n "$hit" ] || continue
    echo "    numbered reference to the archived design document: $hit"
    BAD=$((BAD + 1))
done < <(grep -rnoEi 'section [0-9]+|§ ?[0-9]+|\(spec [0-9]+(\.[0-9]+)?\)' \
             "$REPO_ROOT/README.md" "$REPO_ROOT/CONTRIBUTING.md" "$REPO_ROOT/skills" \
             "$REPO_ROOT/commands" "$REPO_ROOT/scripts" \
             2>/dev/null | sort -u || true)

if [ "$BAD" = "0" ]; then
    pass "the shipped documents cite no numbered section of the archived design document"
else
    fail "the shipped documents cite no numbered section of the archived design document ($BAD found)"
fi

# 6. Every section a shipped cross-reference names exists in the living spec.
#    Assertion 5 proves the old numbered phrasing is gone; without this one,
#    nothing proves the replacement points anywhere. A renamed section would
#    break the reference silently — the same defect, one indirection later.
#    The spec nests steps under the object they advance, so a cited section may
#    sit at `##` or `###`; both count.
for h in "Installing on a project" "The spec document" "Authority and conflict rules"; do
    if grep -qxE "#{2,3} $h" "$REPO_ROOT/docs/specs/supercharlouze.md"; then
        pass "the living spec has a section named: $h"
    else
        fail "the living spec has a section named: $h"
    fi
done

# 7. A section a skill names in parentheses is a heading of that skill, never a
#    section of the living spec: the spec is French, and it is not among what
#    the plugin ships.
BAD=0
for f in "$REPO_ROOT"/skills/*/SKILL.md; do
    while IFS= read -r title; do
        [ -n "$title" ] || continue
        if ! grep -qxE "#{1,4} $title" "$f"; then
            echo "    $(basename "$(dirname "$f")"): ($title) is no section of this skill"
            BAD=$((BAD + 1))
        fi
    done < <(grep -oE '\(`[A-Z][A-Za-z ]+`\)' "$f" | sed 's/^(`//; s/`)$//' | sort -u || true)
done
if [ "$BAD" = "0" ]; then
    pass "a section a skill names in parentheses is one of its own"
else
    fail "a section a skill names in parentheses is one of its own ($BAD found)"
fi

exit $((FAILURES > 0))
