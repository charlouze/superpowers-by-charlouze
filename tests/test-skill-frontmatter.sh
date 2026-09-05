#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-skill-frontmatter"

EXPECTED_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch"

for skill in $EXPECTED_SKILLS; do
    f="$REPO_ROOT/skills/$skill/SKILL.md"
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

    front="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$f")"

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

if [ -d "$REPO_ROOT/skills" ]; then
    actual="$(ls "$REPO_ROOT/skills" | sort | tr '\n' ' ')"
    expected="$(printf '%s\n' $EXPECTED_SKILLS | sort | tr '\n' ' ')"
    if [ "$actual" = "$expected" ]; then
        pass "skills directory holds exactly the five declared skills"
    else
        fail "skills directory holds exactly the five declared skills (got: $actual)"
    fi
fi

exit $((FAILURES > 0))
