---
name: recording-a-decision
description: Use only when a skill tells you to invoke recording-a-decision, never on a request to document a decision - writes the ADR your human partner decided, or rewrites in place the one whose decision they replaced, after confronting it with the specs and the other ADRs
user-invocable: false
---

# Recording a Decision

## Overview

An ADR records a technical decision of the project and its reason. It is a `.md`
file placed directly in `docs/adr/`.

This skill writes an ADR, or rewrites in place the one whose decision was
replaced. Your human partner has decided it before this skill runs: without
their decision, write nothing.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the recording-a-decision skill to record this decision."

Deleting an ADR, and correcting its text without changing its decision, do not
come through this skill. A correction that changes the decision is a rewrite,
and does.

## Input and Output

The input is:

- the decision and its reason;
- the path of the ADR to rewrite, when there is one;
- copies of specs to read in place of the files under `docs/specs/`, when the
  skill that invokes this one hands some.

Return the path of the file written, or what your human partner ruled when
nothing is written.

## Procedure

Follow these steps on the branch you are working on.

1. Read every ADR in `docs/adr/` and every spec in `docs/specs/`. Where you were
   handed a copy of a spec, read the copy.
2. When the decision contradicts a spec or another ADR, or is observable at a
   module's boundary, say so to your human partner and write nothing until they
   have ruled. An ADR contradicts neither a spec nor another ADR, and what is
   observable at a module's boundary is a rule of that module's spec, which only
   your human partner changes.
3. Write the file from `skills/recording-a-decision/references/adr-template.md`,
   creating `docs/adr/` if it does not exist. A new ADR goes to
   `docs/adr/<slug>.md`. A rewrite replaces the text at the path you were given.

An ADR this flow writes or rewrites carries no date and no status. The file
states what holds now, and its git history keeps what held before.

Do not commit. The commit that rewrites an ADR says why, since the file keeps
nothing of the decision it replaced.

## Language

An ADR carries an English skeleton and prose in the project's language. The
section titles `Considered options` and `Consequences` are skeleton. The title,
the sentences and the file's slug are prose.

Every text this skill writes follows `Concision` in `supercharlouze:using-batches`.

## Red Flags

| Thought | Reality |
|---|---|
| "The decision contradicts a spec, I'll word the ADR so it fits" | A reworded contradiction is still one. Say so to your human partner, and write nothing until they have ruled. |
| "This decision shows at the module's boundary, but an ADR is quicker than a spec change" | What is observable at a module's boundary is a rule of its spec. Say so to your human partner. |
| "Every ADR has a date and a status, I'll add them" | An ADR of this flow carries neither. The file states what holds now. |
| "The old decision is worth keeping, I'll mark it superseded" | Rewrite in place. Git history keeps the old text, and the commit says why it changed. |
| "The file is written, I'll commit it" | Do not commit. |
