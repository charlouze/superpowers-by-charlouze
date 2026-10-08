#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib.sh"

echo "test-skill-frontmatter"

# The declaration every check file reads is itself well formed: a line a helper
# skips declares a skill no guard walks.
INVALID="$(invalid_declarations | tr '\n' '|')"
if [ -z "$INVALID" ]; then
    pass "every declaration names a skill and one of the three types"
else
    fail "every declaration names a skill and one of the three types (invalid: $INVALID)"
fi

for skill in $(declared_skills); do
    f="$SKILLS_DIR/$skill/SKILL.md"
    if [ ! -f "$f" ]; then
        fail "$skill/SKILL.md exists"
        continue
    fi
    pass "$skill/SKILL.md exists"

    if [ "$(head -1 "$f")" = "---" ]; then
        pass "$skill frontmatter opens on line 1"
    else
        fail "$skill frontmatter opens on line 1"
    fi

    front="$(skill_front "$skill")"

    name="$(printf '%s\n' "$front" | sed -n 's/^name:[[:space:]]*//p' | head -1)"
    if [ "$name" = "$skill" ]; then
        pass "$skill name matches directory"
    else
        fail "$skill name matches directory (got '$name')"
    fi

    desc="$(printf '%s\n' "$front" | sed -n 's/^description:[[:space:]]*//p' | head -1)"
    if [ -n "$desc" ]; then
        pass "$skill has a description"
    else
        fail "$skill has a description"
    fi
done

# An internal skill is a building block: only a skill invokes it. It keeps its
# frontmatter, since a skill without one still loads and takes its first line as
# its description.
OFFENDERS="$(internal_form_offenders | tr '\n' '|')"
if [ -z "$OFFENDERS" ]; then
    pass "every skill declared internal has the form of one, and no other skill has"
else
    fail "every skill declared internal has the form of one, and no other skill has ($OFFENDERS)"
fi

# The foundation is invoked by a skill or by a plan, never from the slash menu.
# Its description asks for that call, and it stays invocable by the model:
# whoever executes a task of a plan invokes it without a skill telling it to.
FOUNDATIONS="$(declared_skills foundation | tr '\n' ' ')"
if [ "$FOUNDATIONS" = "following-the-rules " ]; then
    pass "following-the-rules is the one declared foundation"
else
    fail "following-the-rules is the one declared foundation (got: $FOUNDATIONS)"
fi

front="$(skill_front following-the-rules)"
if printf '%s\n' "$front" | grep -qx 'user-invocable: false'; then
    pass "following-the-rules is hidden from the slash menu"
else
    fail "following-the-rules is hidden from the slash menu"
fi

desc="$(printf '%s\n' "$front" | sed -n 's/^description:[[:space:]]*//p' | head -1)"
case "$desc" in
    "Use when a skill or a plan tells you to invoke following-the-rules"*)
        pass "following-the-rules asks to be invoked when a skill or a plan says so" ;;
    *)  fail "following-the-rules asks to be invoked when a skill or a plan says so" ;;
esac

case "$front" in
    *"disable-model-invocation"*) fail "following-the-rules stays invocable by the model" ;;
    *)                            pass "following-the-rules stays invocable by the model" ;;
esac

actual="$(ls "$SKILLS_DIR" | sort | tr '\n' ' ')"
expected="$(declared_skills | sort | tr '\n' ' ')"
if [ "$actual" = "$expected" ]; then
    pass "skills directory holds exactly the declared skills"
else
    fail "skills directory holds exactly the declared skills (got: $actual)"
fi

exit $((FAILURES > 0))
