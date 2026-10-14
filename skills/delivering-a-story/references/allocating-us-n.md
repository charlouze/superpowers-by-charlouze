# Allocating us-N

`us-N` is the smallest integer **not used in the batch directory on `main`**,
**not claimed by an open pull request**, *and* **not claimed by a pushed
`story/*` branch that carries no pull request yet**:

```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/NN-<slug>/
gh pr list --state open --limit 100 --json number,headRefName
git ls-remote --heads origin 'story/*'
```

Each is necessary. The remote ones are the sources the concurrency scan reads,
one idea applied twice and not a coincidence. The listing of `main` is the one
that scan never reads, because concurrency is a question about work
in flight and allocation is also a question about work already landed. An
artifact only reaches `main` when its pull request merges, so that listing
knows nothing about what is in flight; and a story's pull request opens only
at the very end of Step 5, so from its first commit until then a branch holds
its number without ever appearing in
`gh pr list`. The branch name carries the number — `story/NN-us-N-<slug>` — so
the remote listing answers on its own, with nothing to fetch and no file to
read. Going by that listing alone gives the same number to two stories written
while a third is in review; adding only the pull requests still gives it to two
stories written while a third is being implemented, and that window is the
longer of the two.
