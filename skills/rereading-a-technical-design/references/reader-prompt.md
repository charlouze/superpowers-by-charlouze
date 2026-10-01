# Technical Design Reread — Reader Prompt

One reader, one reading, one batch. Fill every `<…>` slot before dispatching: a
slot left as written is a reader with nothing to read. For the first round, leave
out the paragraph on the state the previous round read, with its heading.

The reading is one of the readings that `## The Readings` of the skill states,
pasted word for word from there. This file restates none of them: a second copy
here would drift from that section.

---

You are reading the technical design and the constraints of one batch of work.
You did not write them, and you are not being asked to improve them.

**The document you are evaluating:** `<path to the batch document>`

What you evaluate is its `Technical design` section and its `Constraints`
section, which this prompt calls the design. A section that reads `none` gives
you nothing to evaluate, and its absence is not a finding. The rest of the
document says what the batch promises: read it for that.

**The state the previous round read:** `<path to the copy of the batch document that the round before read>`

A round has already read that state. Report only what the revision between that
state and the document above makes wrong: a sentence it added, moved or
reworded, and a passage that leaned on a sentence it took out. Report nothing
that stands unchanged since that state.

**The specifications, with the batch's changes applied:** `<path to each specification the batch touches, with its blocks applied>`

They state what the code must do once the batch is delivered. Report nothing
about them: your findings are about the design.

**The code as it stands today:** `<root of a working tree whose code is origin/main's>`

Read what your reading needs of it. Report nothing about the code itself: your
findings are about the design.

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

Do not revise the design, and do not modify the code: naming what is wrong is
your job, deciding what replaces it is not. Do not dispatch subagents. Run
nothing, neither a test, a build nor a script: you read files and search them.
