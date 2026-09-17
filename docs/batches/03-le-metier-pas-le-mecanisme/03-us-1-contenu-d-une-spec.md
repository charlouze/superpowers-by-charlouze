# 03 — us-1 — Ce dont une spec parle — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Porter dans les skills la seconde propriété de contenu d'une spec — le métier entre, le mécanisme reste dans le code — que la tranche de spec de cette story vient d'écrire.

**Architecture:** La règle vit à **un seul endroit** : `skills/using-batches/SKILL.md`, dans une section `What a Spec Says` qui suit `The Model`. C'est la skill de routage, chargée avant tout travail de conception comme avant toute exécution, donc la seule que tout écrivain de spec a déjà lue. Les deux skills qui écrivent dans le fichier de spec hors adoption — `writing-a-user-story` pour la tranche, `closing-a-batch` pour la cellule `change` — n'en portent pas une seconde formulation : elles nomment la règle et reprennent **mot pour mot** la question du test, ce qu'une assertion unique de `tests/test-skill-contracts.sh` verrouille sur les trois fichiers à la fois. L'adoption est hors périmètre : elle est la tranche suivante du lot, et elle citera cette même section.

**Tech Stack:** Markdown (skills, README, spec), bash (`tests/*.sh`, exécutées par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/03-le-metier-pas-le-mecanisme/README.md
**Sections:** The spec document

## Global Constraints

Le gel du fichier de spec, la règle d'autorité, puis la section `Constraints` du lot copiée verbatim. Tout cela fait implicitement partie des exigences de chaque tâche.

**Gel du fichier de spec.** Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête. `docs/specs/supercharlouze.md` a reçu sa tranche dans le commit `3a93fe5`, premier commit de cette branche : il n'y a plus rien à y écrire dans cette story.

**Autorité.** Quand le lot et la spec se contredisent, **la spec gagne — sans exception et sans délibération.** Implémente ce que dit la spec, inscris un `Ruling:`, et continue. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

Constraints du lot, copiées verbatim :

- **Ordre requis, et il est total.** La tranche `The spec document` est transcrite
  **en premier** et fusionnée avant que la suivante commence : la tranche
  `Module adoption` cite la règle que la première pose, et l'écrire contre un texte
  non fusionné produirait deux formulations concurrentes de la même règle. La **mise
  en conformité de `docs/specs/supercharlouze.md`** vient **en dernier**, après que
  les deux tranches normatives sont sur `main` : elle applique la règle, elle ne
  peut donc pas précéder son énoncé, et elle toucherait sinon des sections que les
  deux autres sont en train d'écrire.
- **La spec de ce plugin doit survivre à la règle qu'elle énonce.**
  `docs/specs/supercharlouze.md` est pleine de noms de branches, d'appels `gh` et de
  mécanique git — légitimement, parce qu'ils sont observables à la frontière de ce
  module et qu'un autre implémenteur les lirait comme vrais du sien. Toute
  formulation qui rendrait cette spec illégale est une mauvaise formulation, et il
  faut la reprendre plutôt que l'excepter. C'est le meilleur test disponible de la
  règle, et il est gratuit.
- **La mise en conformité est à sens constant.** Elle réexprime, elle ne décide
  jamais. Une phrase qui sort de la spec parce qu'elle décrit un mécanisme ne
  change pas ce que le plugin doit faire ; si la reprise d'une section changeait la
  norme, c'est que ce n'est plus une mise en conformité mais une décision, et une
  décision sur une spec est **un acte humain**. La tranche s'arrête et la pose.
- **Elle n'invente aucune intention.** Là où la spec porte un mécanisme dont aucun
  document validé ni aucune section voisine ne donne la règle qu'il servait, la
  tranche **ne la déduit pas** : ce serait le blanchiment que ce lot interdit,
  commis par le lot lui-même. Elle laisse la phrase en place et **consigne le
  constat sous `Observed drift`** dans son document de story, d'où
  `supercharlouze:closing-a-batch` le consolidera. Aucune écriture directe dans le
  gaps register : ce lot n'y touche pas.
- **Cette tranche est commanditée par l'humain au gate d'ouverture**, et c'est ce
  qui la distingue d'un agent qui corrigerait une spec de sa propre initiative. La
  commande porte sur la **forme** du document, jamais sur ce qu'il exige ; la revue
  de sa pull request est le gate qui le vérifie.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans la
  même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la compte
  pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit la
  spec, la constatation part sous `Observed drift` dans le document de story.
- **Sept décisions sont tranchées au gate d'ouverture** et ne se rediscutent pas en
  cours d'implémentation : le critère est le **test de l'autre implémentation** et
  non une liste de mots interdits ; un mécanisme lu dans un document validé **part
  au registre** plutôt que d'être lu à travers pour en déduire une intention ; **un
  choix métier porte son chiffre**, la règle n'autorisant jamais le flou ; **nommer
  n'est pas mécaniser**, donc un glossaire métier reste ; **tout ce qu'une spec
  contient est normatif au même niveau**, le plugin ne prescrivant aucun balisage
  d'aparté ; **un module redéfinit ce qu'il emprunte** plutôt que de renvoyer à la
  spec voisine ; et le gaps register est **hors du périmètre** de la règle.
- **La place d'une règle transverse est hors périmètre.** Une règle qui vaut pour
  tous les modules ne vit dans aucun, et ce plugin ne dit nulle part où elle vit —
  un module, une spec, et rien d'autre. Trancher demande de décider si le système
  gagne une spec transverse ou s'il reconnaît `CLAUDE.md` comme son domicile, ce qui
  touche `Document layout` et l'adoption. C'est un lot à part entière, pas une
  clause à glisser ici.
- **La contestation de la section `Sources` est hors périmètre.** Elle est réelle,
  elle vise ce plugin, et elle demande de décider si une spec vivante a encore
  besoin de déclarer ce qui l'a nourrie — avec l'état des lieux de `init` qui en
  dépend. Aucune story de ce lot n'y touche, ni pour la défendre ni pour la retirer.
- **Aucune dépendance à `domain-driven-design`.** La règle s'énonce de façon
  autonome, et elle doit tenir pour un agent qui n'a jamais chargé cette skill.
  Faire de `domain-driven-design` un prérequis du plugin, au même rang que
  superpowers, est une question ouverte et délibérément hors de ce lot — mais
  l'exemple ci-dessus l'a rendue plus sérieuse, puisque c'est son invocation qui a
  produit la seule version acceptable des trois. Trancher cette question demande de
  peser une dépendance externe que le plugin ne contrôle pas ; c'est une décision
  humaine, elle ne se prend pas au détour d'une story.
- **Ne toucher à aucune entrée du gaps register.** Ce lot n'en réserve aucune ;
  toutes appartiennent à d'autres lots.

**Langue.** Squelette anglais, prose dans la langue du projet — et **le plugin lui-même est intégralement en anglais** : skills, README, messages. Tout texte ajouté sous `skills/`, `README.md` et `tests/` est donc en anglais. Le fichier de spec et ce document de story sont en français.

**Hors périmètre de cette story**, et à ne toucher sous aucun prétexte : `skills/adopting-a-module/SKILL.md` (tranche suivante du lot), `skills/writing-a-batch/SKILL.md` (le delta d'un lot n'est pas le fichier de spec, et le périmètre de la règle s'arrête à ce fichier), `docs/specs/supercharlouze.gaps.md`, et la table `Changelog` de la spec (elle est écrite par `closing-a-batch`, une ligne par lot).

---

## File Structure

| Fichier | Responsabilité dans cette story |
|---|---|
| `skills/using-batches/SKILL.md` | **Modifier.** Porte la règle en entier, dans une section `What a Spec Says` nouvelle, placée entre `## The Model` et `## The Git Model`. Le paragraphe `**Spec**` du glossaire y renvoie d'une phrase. |
| `README.md` | **Modifier.** Une ligne de vitrine : la spec vivante dit le métier, pas le mécanisme. |
| `skills/writing-a-user-story/SKILL.md` | **Modifier.** Step 3 : la transcription applique le test, et ce qu'il éjecte part sous `Observed drift`. |
| `skills/closing-a-batch/SKILL.md` | **Modifier.** Duty 1 : la cellule `change` est dans le périmètre de la règle. |
| `tests/test-skill-content.sh` | **Modifier.** Les assertions par clause sur `using-batches`. |
| `tests/test-skill-contracts.sh` | **Modifier.** L'assertion unique qui verrouille la question du test, mot pour mot, sur les trois skills à la fois. |

---

### Task 1: La règle, à un seul endroit

**Files:**
- Modify: `skills/using-batches/SKILL.md` (paragraphe `**Spec**` de `## The Model` ; nouvelle section avant `## The Git Model`)
- Modify: `README.md` (la puce `**One living spec per functional module**`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la section `## What a Spec Says` de `skills/using-batches/SKILL.md`, que la Task 2 nomme sans la reformuler ; et la phrase exacte `read this sentence as true of their code`, que la Task 2 reprend mot pour mot.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, juste avant la ligne finale `exit $((FAILURES > 0))`, ajouter :

```bash
# --- using-batches: what a spec says (spec section "The spec document") ---
require using-batches "the test bears on the module boundary"   "bears on the module's boundary"
require using-batches "no rewording a mechanism into a rule"    "You do not reword a mechanism into a rule"
require using-batches "lists the laundering signs"              "Four signs recognise it"
require using-batches "a business choice carries its number"    "A business choice carries its number"
require using-batches "vagueness is not prudence"               "Vagueness is not prudence"
require using-batches "a number says where it comes from"       "a decision, or a reading of the code"
require using-batches "structure follows the business"          "structure follows the business"
require using-batches "a glossary is a rule, not a leak"        "Naming is not mechanising"
require using-batches "one normative level, no ranking"         "normative, at the same level"
require using-batches "a module redefines what it borrows"      "redefines what it borrows"
require using-batches "the rule covers the changelog cell"      "including the changelog's \`change\` cell"
require using-batches "the gaps register is out of scope"       "which is not a spec"
```

Ces `require` lisent le corps du `SKILL.md` aplati par `body_flat` (`tr '\n' ' '`) : un needle ne doit donc jamais contenir deux espaces consécutifs, et se compare en sous-chaîne littérale via `case`.

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — douze lignes `[FAIL] using-batches: …`, et un code de sortie non nul.

- [ ] **Step 3: Point the glossary at the new section**

Dans `skills/using-batches/SKILL.md`, section `## The Model`, remplacer le paragraphe `**Spec**` par :

```markdown
**Spec** — one living document per module, at `docs/specs/<module>.md`. It is **normative** (what the code must do), not descriptive (what the code happens to do), and it carries **business rules and intentions; the mechanism stays in the code** — see `What a Spec Says` below. It carries no date, no status, no work-in-progress marker. It is the binding authority of every review.
```

- [ ] **Step 4: Write the rule, once**

Dans le même fichier, insérer la section suivante **entre la fin de `## The Model` et le titre `## The Git Model`**. Ce fichier écrit un paragraphe sur une seule ligne, sans repli à 80 colonnes : respecter cette forme.

```markdown
## What a Spec Says

A spec carries **business rules and intentions; the mechanism stays in the code**. This is a second content property, orthogonal to normative-not-descriptive: a perfectly normative spec can still impose a data store, a trigger or an adapter layer. The clauses below are inseparable — the first says what does not get in, the second says what you may not write in its place, the third is what keeps the first two from manufacturing vagueness.

**The other-implementation test.** The criterion is not a forbidden vocabulary but a question, asked of every sentence you are about to write:

> Would another developer, having implemented the same intention differently, read this sentence as true of their code?

Yes: it is a rule, it goes in. No: it is this implementation of it, and it stays in the code. The test restates equivalently as replaceability — *could this mechanism be replaced without making the spec false for anyone outside the module?* — and the first form is the one you apply: imagining a colleague is within anyone's reach, imagining an external observer is not.

The test bears on the module's boundary, never on words, and that is what makes it applicable everywhere. A module whose domain *is* infrastructure — a deployment pipeline, or this plugin — states branch names and `gh` calls as rules, because at its boundary they are observable and another implementer would read them as true of theirs. A forbidden vocabulary would make this plugin's own spec illegal; the test lets it be written.

Two corollaries. **A rule does not move when a mechanism moves:** if a purely technical change of mind forced you to rewrite the sentence, the sentence was describing the technique. **And a spec does not legislate on code quality:** a clumsy implementation that produces the promised behaviour is conformant. The spec says what must be true, never by which road nor with what elegance.

**You do not reword a mechanism into a rule.** The test says what goes out, not what replaces it, and that is where an agent invents. The intention behind a mechanism is not **deduced**: it comes from a validated document or from your human partner. An intention paraphrased from the code is reconstruction from the code by another road, and the rule that comes out has three defects no review catches easily — it is unverifiable from outside, it has the shape of the code rather than of the business, and it **canonises the drift**, since what it describes is the observed behaviour.

Four signs recognise it without knowing anything about the domain:

- the section has **the shape of the code** — one sentence per branch, one paragraph per technical module;
- it is **vague where the code is precise** — "a few minutes" is an erased number, not a prudent promise;
- it **names an internal actor** — what watches, what computes, what this module does not count;
- **nobody outside the module could tell whether it is held.**

The question that settles all four: *what does a user or a neighbouring module lose if this sentence is false?* If the answer is "nothing observable", it is not a rule — it is a gap, and it goes to the register.

**A business choice carries its number.** A duration, a step, a window, a ceiling, a guarantee delay are business decisions, and a business decision is written with its value: "a session lasts four hours", "extending pushes the closing back by one hour and is offered only in the last thirty minutes". If the value changes one day, the spec changes, and that is exactly what a living spec is for. **Vagueness is not prudence** — it is a rule no code can contradict, therefore a rule that serves nothing.

The other-implementation test is enough for the plain case: another implementer reads "a session lasts four hours" as true of their code, and does not recognise "the sweep runs every five minutes". It is not enough for the case that matters — a number inherited from a mechanism and then written as a guarantee has the shape of a promise and passes the test, since any implementation can hold it. It is false as a rule nonetheless, because nobody ever decided it. Hence the question that accompanies every number written into a spec:

> That one — where does it come from: a decision, or a reading of the code?

A number you cannot answer for is a gap, not a guarantee. Written as a guarantee, it turns a legitimate engineering decision into conformance debt, and the corrective batch that follows is regular — which is what makes it undetectable.

**The spec's structure follows the business.** A rule lives where the behaviour it constrains lives, not gathered into a section that groups rules by nature. A section called "the invariants", "the ports" or "what writes where" has the shape of the code's layers, and that shape alone betrays the origin of the text even when every sentence, taken on its own, would pass the test. It is the shape-of-the-code sign, stated constructively.

**Naming is not mechanising.** A glossary binding a business term to the name the code and the interface carry is a rule, not a leak: it states that this concept is called the same everywhere, which is exactly what lets a domain expert read the code and recognise their intentions in it. It passes the test — renaming the identifier without touching the glossary makes the spec false, since the spec promised the opposite. What a glossary need not carry are the names that are nobody's: a persistence type, an adapter class, a store document.

**Everything a spec contains is normative, at the same level.** A spec does not rank its rules: marking some as important implies the others bind less, and a rule that binds less does not bind. There are therefore no main rules, no recommendations and no best practices in a spec — what is not opposable does not go in. A project that wants a **non-normative aside** — an example, a precision tempering a neighbouring rule — declares the convention that makes it recognisable and holds to it; no markup is imposed, it is only required that an aside be distinguishable from a rule and that it never carry one.

**A module redefines what it borrows.** A spec reads on its own. A term a neighbouring module owns is redefined here, **reduced to what this module uses**, naming the spec that owns it. Referring to the definition next door looks cleaner and is not: the term's meaning then changes without this module knowing, and it finds out through a breakage. The reduced borrowing is not duplication but a **contract** — and the day it diverges from the original definition is exactly what you wanted to see.

**Scope.** These clauses bear on the spec file, **all of its lines**, including the changelog's `change` cell: this is a property of the document, so it holds for whoever writes in it. They do not bear on `docs/specs/<module>.gaps.md`, which is not a spec — a register entry names a mechanism, that is its job, and that is where everything the test ejects goes. Saying both is necessary: a rule with no declared outlet leaves an agent who has understood it with nowhere to write down what they found.
```

- [ ] **Step 5: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh`
Expected: PASS — les douze assertions `using-batches` vertes, code de sortie 0.

- [ ] **Step 6: Say it on the shop front**

Dans `README.md`, remplacer la puce :

```markdown
- **One living spec per functional module** — undated, normative, and the
  binding authority for every review.
```

par :

```markdown
- **One living spec per functional module** — undated, normative, and the
  binding authority for every review. It carries business rules and
  intentions; the mechanism stays in the code.
```

- [ ] **Step 7: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 8: Commit**

```bash
git add skills/using-batches/SKILL.md README.md tests/test-skill-content.sh
git commit -m "feat: dit dans using-batches ce dont une spec parle"
```

---

### Task 2: Le test, mot pour mot, chez ceux qui écrivent dans une spec

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 3, avant le paragraphe `**Corrective story.**`)
- Modify: `skills/closing-a-batch/SKILL.md` (duty `### 1. Write the changelog line`)
- Test: `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la section `## What a Spec Says` de `skills/using-batches/SKILL.md`, et sa question `Would another developer, having implemented the same intention differently, read this sentence as true of their code?` (Task 1).
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Write the failing guard**

Dans `tests/test-skill-contracts.sh`, ajouter — juste avant le commentaire `# \`Branch naming\` used to deny…` qui précède l'assertion `absent` finale :

```bash
# The content rule lives in one place, `using-batches`. A skill that writes into a
# spec file names it and reuses its question verbatim rather than restating it —
# a second formulation of the same rule is exactly what drifts. One assertion over
# the three files: two separate ones would both stay green while one end reworded.
shared "whoever writes into a spec spells the other-implementation test identically" \
    "read this sentence as true of their code" \
    using-batches writing-a-user-story closing-a-batch
```

- [ ] **Step 2: Run the guard to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL — `[FAIL] whoever writes into a spec spells the other-implementation test identically (missing in: writing-a-user-story closing-a-batch)`.

- [ ] **Step 3: Make the transcription apply the test**

Dans `skills/writing-a-user-story/SKILL.md`, section `## Step 3 — Commit the Spec Slice First`, insérer juste avant le paragraphe `**Corrective story.**` :

```markdown
**What the slice may contain.** The transcription applies the content rule of
`supercharlouze:using-batches` — a spec carries business rules and intentions,
the mechanism stays in the code — to every sentence it writes. Ask it of each:
*would another developer, having implemented the same intention differently,
read this sentence as true of their code?* The delta was written by a human at
the opening gate, but transcribing it is still writing, and a delta that names a
mechanism is transcribed as the rule that mechanism served **only if a validated
document or your human partner states that rule**. You do not deduce it: an
intention paraphrased from the code is reconstruction from the code, and it
canonises the very drift it describes. What the test ejects is not lost — it
goes under **Observed drift** (Step 6), from where
`supercharlouze:closing-a-batch` files it into the gaps register.
```

Ce fichier replie sa prose autour de 78 colonnes : respecter cette forme.

- [ ] **Step 4: Bring the changelog cell under the rule**

Dans `skills/closing-a-batch/SKILL.md`, duty `### 1. Write the changelog line`, insérer juste après le paragraphe qui commence par `The changelog is a reading convenience, not a mechanism:` :

```markdown
The `change` cell is part of the spec file, so the content rule of `supercharlouze:using-batches` holds there too: it says what this batch changed for the business, never by what mechanism. The test is the same one — *would another developer, having implemented the same intention differently, read this sentence as true of their code?* A changelog line that names a branch, a hook or a file the business never asked for is the one place where a whole batch's worth of mechanism gets back into a spec, one line at a time.
```

Ce fichier écrit un paragraphe sur une seule ligne, sans repli : respecter cette forme.

- [ ] **Step 5: Run the guard to verify it passes**

Run: `bash tests/test-skill-contracts.sh`
Expected: PASS — `[PASS] whoever writes into a spec spells the other-implementation test identically`.

- [ ] **Step 6: Drop the duplicate coverage**

La question du test est désormais gardée par l'assertion `shared` ci-dessus, qui couvre `using-batches` parmi les trois. Vérifier que `tests/test-skill-content.sh` ne porte pas, pour `using-batches`, une seconde assertion sur cette même phrase : si `grep -n "read this sentence as true of their code" tests/test-skill-content.sh` renvoie une ligne, la supprimer. Une garde par bout, sur un couplage, est ce que le commentaire en tête de `shared` interdit.

- [ ] **Step 7: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 8: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/closing-a-batch/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh
git commit -m "feat: applique le test de l'autre implémentation à qui écrit dans une spec"
```

---

## Rulings log

**Ruling: la tranche route vers `Observed drift` une clause qui est dans le périmètre de la story — corrigé ici.** Le paragraphe ajouté au Step 3 de `writing-a-user-story` envoyait sous `Observed drift` toute clause du delta que le test éjecte. Or le Step 6 du même fichier définit cette section comme les divergences constatées **hors** du périmètre de la story, et une clause que la story avait mandat de transcrire est dedans. Décidé : une clause intranscriptible est un conflit entre le lot et la spec, donc la règle d'autorité s'applique — la spec gagne, un `Ruling:` la nomme, et seule une clause qui décrit un comportement que le code a déjà part aussi sous `Observed drift`. Un mécanisme prescrit mais pas encore construit n'est ni une violation ni un gap, et le registre n'a nulle part où le mettre — ce trou-là est comblé par la tranche `The gaps register` du lot, qui n'est pas dans cette story. — Coût si c'est faux : de la prose dans une skill, qu'un commentaire de revue corrige.

**Ruling: la clause « la structure de la spec suit le métier » est plus large que sa propre justification — porté à la revue, pas corrigé.** Lue au pied de la lettre, elle condamne `Branch naming` (qui rassemble la règle de nommage de sept workflows), `Authority and conflict rules`, `Language` et `Verification` — des sections de cette spec-ci qui regroupent par nature. La justification qui suit la clause ne parle que des couches du code et ne les rattrape pas. Le constat est réel et les Constraints du lot interdisent d'excepter plutôt que de reprendre la formulation. Mais la reprise touche `docs/specs/supercharlouze.md`, gelée jusqu'à l'ouverture de la pull request, et **corriger une spec est un acte humain, jamais un acte d'agent**. Décidé : ne rien toucher, et porter le constat au gate de livraison, où le gel est levé et où l'humain tranche la rédaction de sa propre tranche. — Coût si c'est faux : la tranche 3 hérite d'une clause qui l'obligerait soit à dissoudre `Branch naming` en cinq sections, soit à inventer l'exception que le lot interdit.

**Ruling: l'exemple `🔒 billing.recurring` de la spec tombe sous la clause de l'aparté non normatif — transmis à la tranche 3.** La clause exige qu'un projet voulant un aparté déclare la convention qui le rend reconnaissable ; la spec n'en déclare aucune et porte un exemple illustratif dans `The spec document`, la section même que cette story a écrite. Non corrigé pour la même raison que ci-dessus : c'est la spec, elle est gelée, et c'est précisément le travail de la mise en conformité. — Coût si c'est faux : la tranche 3 y passe un tour de plus.

## Observed drift

Aucune divergence entre la spec et le code constatée hors du périmètre de cette story. Les deux constats que la revue finale a remontés portent sur la spec elle-même et non sur le code : ils sont dans le `Rulings log` ci-dessus et dans le corps de la pull request.
