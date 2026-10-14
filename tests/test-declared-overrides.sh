#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-declared-overrides"

SKILL="$REPO_ROOT/skills/using-batches/SKILL.md"
BLOCK="$REPO_ROOT/skills/using-batches/references/claude-md-block.md"

if [ -f "$BLOCK" ] && [ -f "$SKILL" ]; then
    pass "skill and canonical block both exist"
else
    fail "skill and canonical block both exist"
    exit 1
fi

# Flatten both files: a phrase must match regardless of how the prose is wrapped.
SKILL_FLAT="$(tr '\n' ' ' < "$SKILL")"
BLOCK_FLAT="$(tr '\n' ' ' < "$BLOCK")"
FOUNDATION_FLAT="$(tr '\n' ' ' < "$REPO_ROOT/skills/following-the-rules/SKILL.md")"

has() { case "$2" in *"$1"*) return 0 ;; *) return 1 ;; esac }

check_both() {
    local label="$1" needle="$2"
    if has "$needle" "$SKILL_FLAT"; then
        pass "using-batches names override: $label"
    else
        fail "using-batches names override: $label"
    fi
    if has "$needle" "$BLOCK_FLAT"; then
        pass "CLAUDE.md block names override: $label"
    else
        fail "CLAUDE.md block names override: $label"
    fi
}

check_both "brainstorming steps 6 to 9"    "superpowers:brainstorming"
check_both "SDD stop conditions"           "superpowers:subagent-driven-development"
check_both "imposed execution mode"        "execution mode"
check_both "finishing-a-development-branch" "superpowers:finishing-a-development-branch"

# Naming the skill is not naming the override: "superpowers:brainstorming applies
# unchanged" would satisfy the four checks above. Each override is therefore also
# checked on what it does, in the wording each file actually uses.
check_verb() {
    local label="$1" skill_needle="$2" block_needle="$3"
    if has "$skill_needle" "$SKILL_FLAT"; then
        pass "using-batches states what the override does: $label"
    else
        fail "using-batches states what the override does: $label"
    fi
    if has "$block_needle" "$BLOCK_FLAT"; then
        pass "CLAUDE.md block states what the override does: $label"
    else
        fail "CLAUDE.md block states what the override does: $label"
    fi
}

check_verb "steps 6 to 9 are replaced by opening-a-batch" \
    "are replaced by \`supercharlouze:opening-a-batch\`" \
    "replaces steps 6 to 9 of the architectural checklist"
check_verb "the stop conditions are extended, not restated" \
    "This plugin adds the stop conditions \`supercharlouze:following-the-rules\` writes in full" \
    "extends the stop conditions of superpowers:subagent-driven-development"

# The condition on a constraint is introduced with both of its triggers: a batch
# that declares constraints, or an ADR on `main`.
if has "For a story only if its batch declares constraints or \`main\` carries an ADR when its branch starts:" "$FOUNDATION_FLAT"; then
    pass "following-the-rules introduces the stop condition on a constraint or an ADR"
else
    fail "following-the-rules introduces the stop condition on a constraint or an ADR"
fi
check_verb "SDD is imposed as the execution mode" \
    "This plugin imposes SDD as the execution mode" \
    "requires subagent-driven-development as the execution mode"
check_verb "finishing is constrained to the pull request option" \
    "this plugin constrains the choice to" \
    "constrains superpowers:finishing-a-development-branch to the pull request option"

# using-batches writes in full the override on steps 6 to 9 alone. For each of
# the others it declares the override and names the skill that writes it in
# full: delivering-a-story.
STORY_FLAT="$(tr '\n' ' ' < "$REPO_ROOT/skills/delivering-a-story/SKILL.md" | tr -s ' ')"
POINTERS="$(grep -o "\`supercharlouze:delivering-a-story\` writes this override in full\." "$SKILL" | wc -l | tr -d ' ' || true)"
if [ "$POINTERS" = "3" ]; then
    pass "using-batches says where each of the three other overrides is written in full"
else
    fail "using-batches says where each of the three other overrides is written in full ($POINTERS found)"
fi
for needle in \
    "this plugin requires \`superpowers:subagent-driven-development\`" \
    "repatriating the rulings depends on SDD's ledger" \
    "those arbitrations are the only record of where the spec was ambiguous" \
    "the choice is constrained to **\"Push and create a Pull Request\"**" \
    "**\"Merge back locally\" is actively destructive.**" \
    "**\"Keep the branch as-is\" is not destructive**" \
    "**Deliberately not an override:** SDD's terminal state." \
    "know nothing of the stories beside it"; do
    if has "$needle" "$STORY_FLAT"; then
        pass "delivering-a-story writes the override in full: $needle"
    else
        fail "delivering-a-story writes the override in full: $needle"
    fi
done
for needle in \
    "Justification, stated exactly" \
    "actively destructive" \
    "keeps none" \
    "know nothing of the stories beside it" \
    "SDD's terminal state"; do
    if has "$needle" "$SKILL_FLAT"; then
        fail "using-batches no longer writes in full: $needle"
    else
        pass "using-batches no longer writes in full: $needle"
    fi
done

if has "before any design work" "$BLOCK_FLAT" && has "before executing any plan" "$BLOCK_FLAT"; then
    pass "block requires invocation before design and before execution"
else
    fail "block requires invocation before design and before execution"
fi

if has "steps 6 to 9" "$BLOCK_FLAT"; then
    pass "block scopes the brainstorming override to steps 6 to 9"
else
    fail "block scopes the brainstorming override to steps 6 to 9"
fi

if has "subagent-driven-development applies unchanged" "$BLOCK_FLAT"; then
    fail "block must not claim subagent-driven-development applies unchanged"
else
    pass "block does not claim subagent-driven-development applies unchanged"
fi

# "fifth" alone is satisfied by the prose around the override count — "an
# undeclared fifth", "a fifth clause" — so the needle is a fragment of the
# prohibition itself.
if has "there must never be an undeclared" "$SKILL_FLAT"; then
    pass "using-batches forbids an undeclared fifth override"
else
    fail "using-batches forbids an undeclared fifth override"
fi

# The git model lives in following-the-rules and nowhere else (spec 5.1).
for needle in "may ship to production" "feature flag" "drift"; do
    if has "$needle" "$FOUNDATION_FLAT"; then
        pass "following-the-rules states: $needle"
    else
        fail "following-the-rules states: $needle"
    fi
done

# The bounded change's rule on updating the spec in the same pull request lives
# in making-a-bounded-change.
BOUNDED_FLAT="$(tr '\n' ' ' < "$REPO_ROOT/skills/making-a-bounded-change/SKILL.md")"
if has "same pull request" "$BOUNDED_FLAT"; then
    pass "making-a-bounded-change states: same pull request"
else
    fail "making-a-bounded-change states: same pull request"
fi

exit $((FAILURES > 0))
