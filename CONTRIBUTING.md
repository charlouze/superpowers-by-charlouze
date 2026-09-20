# Contributing

This plugin is developed with itself: its living spec is
`docs/specs/supercharlouze.md`, its batches are in `docs/batches/`, and a change
to its behaviour goes through a batch and a user story like any other. What
follows is the mechanism around that — the tests, the checks and the release.

## Tests

```bash
bash tests/run-all.sh
```

The suite is **structural**. It reads the shipped artifacts — skills, commands,
manifests, the `CLAUDE.md` block — and asserts properties a human would
otherwise have to re-check by eye at every edit: that the four overrides are
declared in both places that must name them, that every `supercharlouze:<name>`
reference resolves to a skill or a command that exists, that every repo-relative
path cited in backticks is real, that the canonical `CLAUDE.md` block lives in
exactly one file, that the versions in the three manifests agree, and that
`scripts/init.sh` behaves on a fresh project as on one already installed.
`tests/test-suite-integrity.sh` closes the loop: it checks that every check file
is named so the runner picks it up and that none of them silently asserts
nothing.

What the suite **deliberately does not test** — all three need a live agent
session, and asserting them from a shell would only assert a paraphrase of them:

- whether the `CLAUDE.md` block actually wins precedence over superpowers in a
  live session;
- whether subagent-driven implementers honour the freeze of the spec file;
- whether `finishing-a-development-branch` is really kept to the pull-request
  option on a story.

Read that list as the shape of the net, not as a to-do: these are the properties
the human gates exist for.

## What every pull request runs

`.github/workflows/ci.yml` runs two jobs.

**The test suite**, as above.

**`scripts/check-commits.sh`**, over the commits the pull request would bring to
`main`. Two rules, one per failure mode already seen on `main`:

- **no `fixup!`, `squash!` or `amend!` commit.** Review corrections are pushed as
  fixups, on purpose, so they can be read on GitHub against the commit they
  correct; they are folded by an autosquash rebase once the review is approved.
  One merged unfolded lands on `main` for good.
- **every subject follows [Conventional Commits](https://www.conventionalcommits.org).**
  The release is derived from them, so a subject that does not follow them is
  silently left out of it.

Merge commits are skipped — git writes them, not the author.

## Releasing

[release-please](https://github.com/googleapis/release-please) keeps a release
pull request open against `main` and updates it on every merge: it derives the
version from the commit subjects (`feat` a minor, `fix` a patch), bumps it in
both manifests, and writes `CHANGELOG.md`. Merging that pull request tags
`vX.Y.Z` and publishes the GitHub release.

Nothing is lost while it waits. It only delays what already-installed plugins
receive, so it can sit open across several batches without costing anything.

It runs as the `charlouze-dev-agent` GitHub App, read from the
`AGENT_APP_CLIENT_ID` variable and the `AGENT_APP_PRIVATE_KEY` secret.

## Layout

| Path | What lives there |
|---|---|
| `skills/` | the five skills, one directory each |
| `commands/` | `/supercharlouze:init` |
| `scripts/` | what the command and the CI run |
| `tests/` | the structural suite |
| `docs/specs/` | the living spec and its gaps register |
| `docs/batches/` | one directory per batch, with its stories |
| `docs/archive/` | the pre-adoption design document, kept for history and stripped of authority |
