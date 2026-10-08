---
name: writing-in-a-gaps-register
description: Use only when a skill tells you to invoke writing-in-a-gaps-register, never on a request to record a gap or a violation - carries the shape of a gaps register, the rules of an entry, and the gestures that add, remove, reserve and release one
user-invocable: false
---

# Writing in a Gaps Register

## Overview

This skill carries the shape of a gaps register, `docs/specs/<module>.gaps.md`,
the rules of an entry, and the gestures that write in it.

The skill that invokes it says which gesture to make, on which entry of which
register, and gives the batch number when the gesture reserves or releases.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the writing-in-a-gaps-register skill to write in this gaps register."

Once the register is written, go on with the step that invoked this skill.

## The Shape of the Register

```markdown
# <module> — Gaps register

## Coverage

<Which parts of the module were audited, which were not, and why. Written even
— especially — when nothing was found.>

## Violations

- **<spec section>** — <how the code contradicts it.>
- **<spec section>** — <another one.> `reserved by batch-08`

## Gaps

- **<spec section, or the section that should exist>** — <behaviour no spec
  describes.>
- **<spec section, or the section that should exist>** — <a mechanism
  `<the validated document, by its archive path>`
  prescribes and no spec carries.>
```

Two categories, each under its own heading, kept apart because they are not
treated the same way:

- **Violations** — the code contradicts the spec. Feeds a *corrective batch*.
- **Gaps** — a real behaviour or requirement no spec describes. Feeds an ordinary
  batch that finally specifies them.

**The register also declares its own coverage:** which parts of the module were
audited, which were not, and why. An empty register that means "nothing was
examined" must never look like an empty register that means "everything conforms" —
they are opposite facts and they look identical unless you write the difference
down. Declare the coverage especially when you found nothing.

**Nothing stays behind in this file once an entry is settled.** The register
carries what is still open, and what an entry was — and why it left — is read in
the history of the file (`git log -p docs/specs/<module>.gaps.md`).

## An Entry

Each entry designates a section of the spec. **An entry that came from a document
names that document**, so your human partner can promote it knowing what they are
promoting instead of re-reading the whole thing.

**Each entry is one list item, never a paragraph of running prose.** Every
gesture below needs a thing it can point at, whether to annotate it in place or
to take it out whole.

A register written as flowing paragraphs breaks every one of them: there is no
item to annotate, none to remove cleanly, no list to append one to — what gets
added is more prose, which the next writer cannot point at either — and nothing a
corrective batch can draw a scope from. Write entries so the gestures are
mechanical.

**What qualifies an entry lives in the entry.** Besides its coverage, the register
carries nothing but entries: no prose qualifies a *group* of them — where they came
from, how they were classified, how many there are. Entries are added and removed
one at a time, and nothing keeps such a paragraph honest: it goes false without
anyone touching it. What it would say of several entries is repeated in each, and
where an entry came from is read in the history of the file. Writing several
entries at once is exactly when a group paragraph feels natural.

**An entry designates no other entry.** A settled entry leaves the file whole, and
it takes with it anything that pointed at it — by name or by position. What an
entry needs from its neighbour it states itself.

## The Gestures

### Add

An entry is one list item, added at the end of its category.

Within a batch, only the closing pull request adds entries to the gaps register.
Every addition contends with every other on the same module, which is why a batch
adds through one pull request.

A finding already deleted from the register is re-entered only if the entry says
what has changed since.

Read the file's history before adding an entry
(`git log -p docs/specs/<module>.gaps.md`). An entry that left this file left for
a reason, written in the commit that removed it: resolved, promoted, moot, false,
or set aside by your human partner.

### Remove

Delete the entry from the file, whole, in the same pull request as what settles
it, and the commit that removes it says why.

### Reserve

Append `reserved by batch-NN` to the entry, `NN` being the number of the batch
that takes it on.

The annotation is what stops another batch from taking the same entry: two
batches never reserve the same entry.

### Release

Releasing removes the reservation annotation and leaves the entry: what it
describes is still open, it is simply no longer claimed.

## Red Flags

| Thought | Reality |
|---------|---------|
| "Prose reads better than a list in the gaps register" | Then nothing can reserve, remove or release an entry, and the gestures break. |
| "The audit found nothing, so the register is empty" | An empty register must say whether nothing was found or nothing was examined. |
