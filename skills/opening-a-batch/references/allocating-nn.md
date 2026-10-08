# Allocating NN

`NN` is the **smallest integer not used in `docs/batches/` on `main`, not
claimed by an open pull request, and not claimed by a pushed `batch/*` or
`story/*` branch that carries no pull request yet**. Fetch, then read all three,
always:

```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/
gh pr list --state open --json number,headRefName
git ls-remote --heads origin 'batch/*' 'story/*'
```

An artifact only reaches `main` when its pull request merges, so
that listing knows nothing about work in flight. Trusting that listing
alone hands the same number to two batches opened in parallel — and the second
one discovers it at merge time, after review.

**The third source closes the same window, by the same argument, as the
scan of `supercharlouze:detecting-concurrency`** — read it as one idea applied
twice, not as two coincidences. A branch is on the remote as soon as it has a
commit, while its pull request may not open for a long while, so for that whole
stretch it claims its number and `gh pr list` shows nothing at all.
The branch name already carries the number — `batch/NN-<slug>` and
`story/NN-us-N-<slug>` — so the remote listing answers on its own, with nothing
to fetch and no file to read. That is also why the pull request query asks for
`headRefName`: the number is in the head branch name, and nothing else in a
pull request states it.

Both patterns are scanned because both spell `NN`, but they do not carry the
same weight. On the nominal path the `story/*` half finds nothing new:
`supercharlouze:writing-a-user-story` requires the batch's opening pull request
to be **merged** before any story is written, so wherever a `story/NN-us-N-`
branch exists, `docs/batches/NN-<slug>/` is already on `main` and that
listing above sees it. Scan it anyway — it is one line and it is the only thing
that answers in the degraded case where that precondition was skipped and a
story branch is the sole trace of its batch.
