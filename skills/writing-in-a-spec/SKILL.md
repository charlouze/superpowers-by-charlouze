---
name: writing-in-a-spec
description: Use only when a skill tells you to invoke writing-in-a-spec, never on a request to write or correct a spec - carries what a spec contains, which every sentence passes before it goes into a spec file
user-invocable: false
---

# Writing in a Spec

## Overview

This skill carries what a spec contains. Apply it to every sentence you are
about to write into a spec file.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the writing-in-a-spec skill to check what goes into this spec."

Once the text is written, go on with the step that invoked this skill.

## What a Spec Says

A spec carries **business rules and intentions; the mechanism stays in the code**. This is a second content property, orthogonal to normative-not-descriptive: a perfectly normative spec can still impose a data store, a trigger or an adapter layer. The clauses below are inseparable — the first says what does not get in, the second says what you may not write in its place, the third is what keeps the first two from manufacturing vagueness.

**The other-implementation test.** The criterion is not a forbidden vocabulary but a question, asked of every sentence you are about to write:

> Would another developer, having implemented the same intention differently, read this sentence as true of their code?

Yes: it is a rule, it goes in. No: it is this implementation of it, and it stays in the code. The test restates equivalently as replaceability — *could this mechanism be replaced without making the spec false for anyone outside the module?* — and the first form is the one you apply: imagining a colleague is within anyone's reach, imagining an external observer is not.

The test bears on the module's boundary, never on words, and that is what makes it applicable everywhere. A module whose domain *is* infrastructure — a deployment pipeline, or this plugin — states branch names and pull requests as rules, because at its boundary they are observable and another implementer would read them as true of theirs. A forbidden vocabulary would make this plugin's own spec illegal; the test lets it be written.

Two corollaries. **A rule does not move when a mechanism moves:** if a purely technical change of mind forced you to rewrite the sentence, the sentence was describing the technique. **And a spec does not legislate on code quality:** a clumsy implementation that produces the promised behaviour is conformant. The spec says what must be true, never by which road nor with what elegance.

**You do not reword a mechanism into a rule.** The test says what goes out, not what replaces it, and that is where an agent invents. The intention behind a mechanism is not **deduced**: it comes from a validated document or from your human partner. An intention paraphrased from the code is reconstruction from the code by another road, and the rule that comes out has three defects no review catches easily — it is unverifiable from outside, it has the shape of the code rather than of the business, and it **canonises the drift**, since what it describes is the observed behaviour.

Four signs recognise it without knowing anything about the domain:

- the section has **the shape of the code** — one sentence per branch, one paragraph per technical module;
- it is **vague where the code is precise** — "a few minutes" is an erased number, not a prudent promise;
- it **names an internal actor** — what watches, what computes, what this module does not count;
- **nobody outside the module could tell whether it is held.**

The question that settles all four: *what does a user or a neighbouring module lose if this sentence is false?* If the answer is "nothing observable", it is not a rule — it is a gap, and it goes to the register. Exception: a sentence that states a technical decision has an ADR for outlet, under the conditions `supercharlouze:following-the-rules` states.

**A business choice carries its number.** A duration, a step, a window, a ceiling, a guarantee delay are business decisions, and a business decision is written with its value: "a session lasts four hours", "extending pushes the closing back by one hour and is offered only in the last thirty minutes". If the value changes one day, the spec changes, and that is exactly what a living spec is for. **Vagueness is not prudence** — it is a rule no code can contradict, therefore a rule that serves nothing.

The other-implementation test is enough for the plain case: another implementer reads "a session lasts four hours" as true of their code, and does not recognise "the sweep runs every five minutes". It is not enough for the case that matters — a number inherited from a mechanism and then written as a guarantee has the shape of a promise and passes the test, since any implementation can hold it. It is false as a rule nonetheless, because nobody ever decided it. Hence the question that accompanies every number written into a spec:

> That one — where does it come from: a decision, or a reading of the code?

A number you cannot answer for is a gap, not a guarantee. Written as a guarantee, it turns a legitimate engineering decision into conformance debt, and the corrective batch that follows is regular — which is what makes it undetectable.

**The spec's structure follows the business.** A rule lives where the behaviour it constrains lives. What is banned is a section that reproduces the code's internal decomposition — "the ports", "the adapters", "what writes where" — or that files rules by their nature rather than by what they constrain — "the invariants", "the constraints". That shape alone betrays the origin of the text even when every sentence, taken on its own, would pass the test; it is the shape-of-the-code sign, stated constructively. A section carrying a concept observable at the module's boundary — a naming convention, an authority rule — follows the business, even when that concept holds for several behaviours. Without that last sentence the clause would outlaw this plugin's own spec, whose `Authority and conflict rules` and `Language` gather rules several workflows share.

**Naming is not mechanising.** A glossary binding a business term to the name the code and the interface carry is a rule, not a leak: it states that this concept is called the same everywhere, which is exactly what lets a domain expert read the code and recognise their intentions in it. It passes the test — renaming the identifier without touching the glossary makes the spec false, since the spec promised the opposite. What a glossary need not carry are the names that are nobody's: a persistence type, an adapter class, a store document.

**Everything a spec contains is normative, at the same level.** A spec does not rank its rules: marking some as important implies the others bind less, and a rule that binds less does not bind. There are therefore no main rules, no recommendations and no best practices in a spec — what is not opposable does not go in. A project that wants a **non-normative aside** — an example, a precision tempering a neighbouring rule — declares the convention that makes it recognisable and holds to it; no markup is imposed, it is only required that an aside be distinguishable from a rule and that it never carry one.

**A module redefines what it borrows.** A spec reads on its own. A term a neighbouring module owns is redefined here, **reduced to what this module uses**, naming the spec that owns it. Referring to the definition next door looks cleaner and is not: the term's meaning then changes without this module knowing, and it finds out through a breakage. The reduced borrowing is not duplication but a **contract** — and the day it diverges from the original definition is exactly what you wanted to see.

**A rule belongs to exactly one spec.** A rule that would constrain behaviour
observable at the boundary of more than one module is not a rule looking for a
home — it is a module breakdown asking to be revisited, and a breakdown is a
human decision. Stop and put the case to your human partner, rather than copying
the rule from one spec into another or giving it a home above them both. The
reduced borrowing of a term — a term a neighbouring module owns, redefined here
and reduced to what this module uses — is not concerned: it redefines a term, it
does not share a rule.

There is no spec above the specs, and that is the point. A rule housed outside
the module specs — in a CLAUDE.md, in an architecture note — sits beyond
everything that makes a spec binding: the review held against it, the drift rule,
the gaps register. It would read as a norm and be none. A technical decision
that no module boundary makes observable is not a rule: its outlet is an ADR.

**Scope.** These clauses bear on the spec file, **all of its lines**: this is a property of the document, so it holds for whoever writes in it. They do not bear on `docs/specs/<module>.gaps.md`, which is not a spec — a register entry names a mechanism, that is its job, and that is where what the test ejects goes, except a technical decision, which has an ADR for outlet. Saying both is necessary: a rule with no declared outlet leaves an agent who has understood it with nowhere to write down what they found.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The delta names a mechanism — I'll reword it into a business rule" | That is the laundering this rule exists to stop: what you would write describes the observed behaviour, so it canonises the drift. The spec wins, record a `Ruling:` for the clause you left out, and carry on. |
| "I can't say where this number came from, I'll write 'a few minutes'" | Vagueness is not prudence — it is a rule no code can contradict. A number you cannot answer for is a gap, not a guarantee. |
| "This rule holds for every module, so it lives above them all" | There is no spec above the specs. A rule belongs to exactly one spec; a rule that seems to belong to several signals a module breakdown to revisit, and that is your human partner's decision. A technical decision with nothing observable at a module's boundary is no rule at all: its outlet is an ADR. |
