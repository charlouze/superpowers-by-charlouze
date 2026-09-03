# supercharlouze

A Claude Code plugin that overrides how [superpowers](https://github.com/obra/superpowers)
organizes specs and plans.

superpowers writes one dated design document per feature and one plan per
feature. Nothing accumulates: after ten features, a module's behavior is
scattered across ten snapshots, none of which describes the current state.

This plugin replaces that with:

- **One living spec per functional module** — undated, normative, and the
  binding authority for every review.
- **Batches** — units of delivery that group user stories and whose purpose is
  to make those specs grow.
- **User stories** — one implementation plan each, targeting exactly one spec.
- **Corrective batches** — empty spec delta; they bring existing code back into
  conformance with a spec that is already true.

Everything else in superpowers — TDD, subagent-driven development, systematic
debugging, code review — is reused unchanged.

## Status

Design stage. Nothing is implemented yet.

The design lives on the `design/supercharlouze` branch, at
`docs/superpowers/specs/2026-09-03-supercharlouze-design.md`.

## Requirements

- Claude Code
- superpowers installed

## License

MIT
