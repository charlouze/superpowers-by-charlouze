#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-skill-frontmatter"

EXPECTED_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch rereading-a-spec rereading-a-technical-design"

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

# The rereads are building blocks: only a skill invokes them. Each keeps its
# frontmatter, since a skill without one still loads and takes its first line as
# its description. It is hidden from the slash menu, and its description asks
# for an explicit call. `disable-model-invocation` would stop the calling skills
# from invoking it too.
for r in rereading-a-spec rereading-a-technical-design; do
    RFRONT="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$REPO_ROOT/skills/$r/SKILL.md" 2>/dev/null || true)"
    case "$RFRONT" in
        *"user-invocable: false"*) pass "$r is hidden from the slash menu" ;;
        *)                          fail "$r is hidden from the slash menu" ;;
    esac
    case "$RFRONT" in
        *"description: Use only when a skill tells you to invoke $r"*)
            pass "$r asks for an explicit call" ;;
        *)  fail "$r asks for an explicit call" ;;
    esac
    case "$RFRONT" in
        *"disable-model-invocation"*) fail "$r stays invocable by the skills" ;;
        *)                            pass "$r stays invocable by the skills" ;;
    esac
done

if [ -d "$REPO_ROOT/skills" ]; then
    actual="$(ls "$REPO_ROOT/skills" | sort | tr '\n' ' ')"
    expected="$(printf '%s\n' $EXPECTED_SKILLS | sort | tr '\n' ' ')"
    if [ "$actual" = "$expected" ]; then
        pass "skills directory holds exactly the declared skills"
    else
        fail "skills directory holds exactly the declared skills (got: $actual)"
    fi
fi

exit $((FAILURES > 0))
