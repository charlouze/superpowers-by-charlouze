#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$REPO_ROOT/scripts/check-commits.sh"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-check-commits"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Build a throwaway repository: one base commit, then one commit per subject
# given. Prints nothing; the base is tagged `base` so the range reads base..HEAD.
make_repo() {
    rm -rf "$WORK/repo"
    git init -q "$WORK/repo"
    git -C "$WORK/repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m "chore: base"
    git -C "$WORK/repo" tag base
    for subject in "$@"; do
        git -C "$WORK/repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m "$subject"
    done
}

# Run the check over base..HEAD of the throwaway repository.
run_check() {
    (cd "$WORK/repo" && bash "$CHECK" base HEAD) >"$WORK/out" 2>&1
}

make_repo "feat: ajoute un check" "fix(ci): corrige le check" "docs!: casse le format" "chore(main): release 0.4.0"
if run_check; then
    pass "conventional subjects pass"
else
    fail "conventional subjects pass ($(cat "$WORK/out"))"
fi

make_repo "feat: ajoute un check" "fixup! feat: ajoute un check"
if ! run_check && grep -q "fixup! feat: ajoute un check" "$WORK/out"; then
    pass "a fixup! commit fails and is named"
else
    fail "a fixup! commit fails and is named ($(cat "$WORK/out"))"
fi

for prefix in "squash!" "amend!"; do
    make_repo "feat: ajoute un check" "$prefix feat: ajoute un check"
    if ! run_check && grep -qF "$prefix feat: ajoute un check" "$WORK/out"; then
        pass "a $prefix commit fails and is named"
    else
        fail "a $prefix commit fails and is named ($(cat "$WORK/out"))"
    fi
done

for subject in "ajoute un check" "Feat: ajoute un check" "feat:ajoute un check" "wip: ajoute un check" "feat(): ajoute un check"; do
    make_repo "$subject"
    if ! run_check && grep -qF "$subject" "$WORK/out"; then
        pass "non-conventional subject fails and is named: '$subject'"
    else
        fail "non-conventional subject fails and is named: '$subject' ($(cat "$WORK/out"))"
    fi
done

# A merge of main into the branch is not the author's commit to name.
make_repo "feat: ajoute un check"
git -C "$WORK/repo" switch -q -c side base
git -C "$WORK/repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m "docs: ailleurs"
git -C "$WORK/repo" switch -q -
git -C "$WORK/repo" -c user.name=t -c user.email=t@t merge -q --no-ff -m "Merge branch 'side'" side
if run_check; then
    pass "merge commits are ignored"
else
    fail "merge commits are ignored ($(cat "$WORK/out"))"
fi

exit $((FAILURES > 0))
