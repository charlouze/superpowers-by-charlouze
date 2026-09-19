#!/usr/bin/env bash
# Check the commits a pull request would bring to main.
#
#   bash scripts/check-commits.sh <base> <head>
#
# Two rules, one per failure mode seen on main:
# - no fixup!, squash! or amend! commit: they are folded by an autosquash rebase
#   once the review is approved, and one merged unfolded lands on main for good;
# - every subject follows Conventional Commits: the release is derived from them,
#   and a commit that does not follow them is silently left out of it.
# Merge commits are skipped — they are written by git, not by the author.
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: check-commits.sh <base> <head>" >&2
    exit 2
fi

TYPES="feat|fix|docs|chore|refactor|test|ci|build|perf|style|revert"
CONVENTIONAL="^($TYPES)(\([^()]+\))?!?: [^ ]"
FAILURES=0

while IFS= read -r subject; do
    if [[ "$subject" =~ ^(fixup|squash|amend)!\  ]]; then
        echo "not folded: $subject"
        FAILURES=$((FAILURES + 1))
    elif ! [[ "$subject" =~ $CONVENTIONAL ]]; then
        echo "not conventional: $subject"
        FAILURES=$((FAILURES + 1))
    fi
done < <(git log --no-merges --format=%s "$1..$2")

if [ "$FAILURES" -gt 0 ]; then
    echo "$FAILURES commit(s) to fix — fixups are folded with 'git rebase -i --autosquash', other subjects follow https://www.conventionalcommits.org"
    exit 1
fi

echo "all commits are conventional"
