# Spec Reread — Reader Prompt

One reader, one reading, one spec. Fill every `<…>` slot before dispatching: a
slot left as written is a reader with nothing to read. For a new spec, leave out
the paragraph on the earlier state, with its heading. For the first round, leave
out the paragraph on the state the previous round read, with its heading.

The reading is one of the readings that `## The Readings` of the skill states,
pasted word for word from there. This file restates none of them: a second copy
here would drift from that section.

---

You are reading one specification. You did not write it, and you are not being
asked to improve it.

**The document you are evaluating:** `<path to the spec, with the change applied when it is changed>`

Read it whole. Everything you report is about this document.

**The same specification as it stands today:** `<path to a copy of the spec as main carries it>`

This one is for locating what changed: diff it against the document above
whenever that helps. Do not review the change as a diff: your finding is about
the document above, read whole. A defect this earlier state already carries, and
that the change neither brings nor worsens, is reported apart, under
`Already there`.

**The state the previous round read:** `<path to the copy of the document above that the round before read>`

A round has already read that state. Report only what the revision between that
state and the document above makes wrong: a sentence it added, moved or
reworded, and a passage that leaned on a sentence it took out. Report nothing
that stands unchanged since that state.

**The project's aside convention:** `<the convention the project declares, or "none declared">`

**The project's other specifications:** `docs/specs/`

Consult them when your reading bears on another module. Report nothing about
them: your findings are about the document above.

**Your reading, and only yours:**

<the one reading, word for word from `## The Readings` of the skill>

**Load no skill your reading does not name.** Everything you need is in this
prompt. Going to read the skill that dispatched you would put the other readers'
readings in front of you, and a reader holding several does the cheapest of them
and returns.

**Return, for each finding:** the passage it bears on, quoted with the section it
sits in; what is wrong with that passage under your reading; and how sure you
are. Return "nothing found" when you found nothing: an empty report and a reader
that failed look the same to whoever reads it.

Do not revise the specification: naming what is wrong is your job, deciding what
replaces it is not. Do not dispatch subagents. Run nothing, neither a test, a
build nor a script: you read files and search them.
