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

actual="$(ls "$SKILLS_DIR" | sort | tr '\n' ' ')"
expected="$(declared_skills | sort | tr '\n' ' ')"
if [ "$actual" = "$expected" ]; then
    pass "skills directory holds exactly the declared skills"
else
    fail "skills directory holds exactly the declared skills (got: $actual)"
fi

exit $((FAILURES > 0))
