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

v0.1.0 — the five skills, the `/supercharlouze:init` command and the structural
test suite are in place.

## Install

```bash
/plugin marketplace add charlouze/superpowers-by-charlouze
/plugin install supercharlouze@supercharlouze
```

Then, in each project you want to move over, run `/supercharlouze:init`. It opens
a pull request; nothing is adopted until you decide, module by module.

## Skills

| Skill | Use it when |
|---|---|
| `supercharlouze:using-batches` | Entry point — routing, authority rules, declared overrides |
| `supercharlouze:adopting-a-module` | A module has no living spec yet |
| `supercharlouze:writing-a-batch` | Opening, amending or requalifying a batch |
| `supercharlouze:writing-a-user-story` | Writing the next story of an open batch |
| `supercharlouze:closing-a-batch` | Every story is merged or abandoned |

## Tests

```bash
bash tests/run-all.sh
```

Structural checks only — see the `Verification` section of
`docs/specs/supercharlouze.md` for what is deliberately not tested.

## Requirements

- Claude Code
- superpowers installed

## License

MIT
