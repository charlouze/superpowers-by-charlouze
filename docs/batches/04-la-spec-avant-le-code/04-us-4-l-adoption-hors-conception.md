# Une adoption se conduit hors de la conception — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Faire qu'une conception de lot qui découvre un module non adopté
s'arrête au lieu d'enchaîner sur l'adoption, et ne reprenne qu'une fois
l'adoption fusionnée, dans un nouveau contexte.

**Architecture:** Les blocs D10 et D11 sont déjà transcrits dans la spec : c'est
le premier commit de cette branche. Le travail restant les fait voyager jusqu'aux
trois skills qui portent encore l'ancienne norme du « préalable bloquant »
enchaîné — `writing-a-batch`, qui la vérifie, `using-batches`, qui la route et la
justifie dans son Override 1, et `adopting-a-module`, qui dit comment on y
arrive. Le texte intégral de la règle est écrit dans `writing-a-batch`, la skill
qui fait la vérification ; les deux autres y renvoient en disant ce que leur
propre position exige, sans recopier l'argument — une seconde formulation de la
même règle est exactement ce qui dérive. Chaque tâche emporte sa garde
structurelle dans `tests/`.

**Tech Stack:** Markdown (skills, spec, document de lot), bash (`tests/*.sh`,
exécutés par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/04-la-spec-avant-le-code/README.md
**Sections:** Departures from superpowers, Batch > Opening a batch
**Blocks:** D10, D11

## Global Constraints

Contraintes du lot 04, recopiées telles quelles :

- **Ordre requis.** D1 et D3, qui définissent le bloc et sa forme, sont transcrits
  **au plus tard dans la même story** que D7 et D8, qui font transcrire des blocs
  par une story : le champ `Blocks:` désigne des identifiants que seul le document
  de lot définit. Les autres blocs n'imposent aucun ordre.
- **Ce lot applique déjà ce qu'il introduit.** Ses stories déclarent `Blocks:`,
  transcrivent leurs blocs mot pour mot et nomment tout écart dans leur pull
  request, même là où les skills publiées ne le demandent pas encore. Leurs revues
  suivent D9 dès la première.
- **Chaque story met à jour les skills qui appliquent ses blocs**, dans la même
  pull request que sa transcription : `writing-a-batch`, `writing-a-user-story`,
  `closing-a-batch`, `using-batches` et `adopting-a-module` selon les blocs qu'elle
  prend. Une skill qui continuerait de parler de « spec delta comme intention »
  après la fusion de D3 est une dérive.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans la
  même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la compte
  pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit la
  spec, la constatation part sous `Observed drift` dans le document de story.
- **Cinq décisions sont tranchées au gate d'ouverture** et ne se rediscutent pas
  en cours d'implémentation : **une adoption ne partage jamais le contexte de la
  conception d'un lot**, et une conception qui découvre un module non adopté
  s'arrête plutôt que d'enchaîner ; le spec delta est découpé **par section, jamais par
  story**, et le document de lot ne porte aucune liste de stories ; le texte est lu
  **dans le document de lot**, bloc par bloc, et non comme un diff de la spec ;
  l'accord de fin de revue se donne **dans la conversation**, l'approbation et la
  fusion restant des gestes humains sur GitHub ; il n'y a **pas de pause après le
  plan** — c'est le texte de la spec que l'humain revoit en amont, pas le
  découpage du travail.
- **Hors périmètre** : l'exécution de stories en parallèle, les pull requests
  empilées et le lancement de plusieurs stories sans intervention, l'endroit où
  noter une idée qui émerge hors du lot en cours, et l'identité GitHub propre à
  l'agent — qui relève de la configuration de chaque dépôt, pas du plugin.
- **Une seule entrée du gaps register est touchée** : *Batch / Closing a batch*,
  réservée par ce lot et résorbée par D2. Aucune autre.

Contraintes propres à toute story :

- **Gel du fichier de spec.** Entre le commit de transcription et l'ouverture de
  la pull request, aucune tâche ne modifie le fichier de spec. Une story qui
  découvre que la spec doit changer s'arrête.
- **Autorité.** Quand le lot et la spec se contredisent, c'est la spec qui gagne,
  sans exception et sans délibération. Implémente ce que dit la spec, consigne un
  `Ruling:`, et continue. Corriger une spec en cours de lot est un geste humain,
  jamais celui d'un agent.

---

### Task 1: `writing-a-batch` — la vérification s'arrête au lieu d'enchaîner

C'est la skill qui fait la vérification décrite par D11, donc c'est elle qui
porte le texte intégral de la règle. Les deux autres tâches y renverront.

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md:32-39` (précondition 1)
- Modify: `skills/writing-a-batch/SKILL.md:433` (ligne de Red Flags)
- Test: `tests/test-skill-content.sh:77`

**Interfaces:**
- Consumes: rien (première tâche).
- Produces: les chaînes littérales sur lesquelles les gardes de cette tâche et
  des suivantes s'appuient — `"l'ouverture s'arrête"` n'est pas utilisée telle
  quelle, les gardes de la suite portent sur le texte anglais des skills :
  `never in the same context`, `resumes in a fresh context`,
  `abandon the design or set it aside`.

- [ ] **Step 1: Écrire la garde qui échoue**

Dans `tests/test-skill-content.sh`, remplacer la ligne 77 :

```bash
require writing-a-batch "adopted spec is a blocking precondition" "blocking precondition"
```

par :

```bash
require writing-a-batch "an unadopted module stops the design"   "the design stops"
require writing-a-batch "adoption never shares the design's context" "never conducted in the same context"
require writing-a-batch "the human abandons or sets the design aside" "abandon the design or set it aside"
require writing-a-batch "the design resumes in a fresh context"   "resumes in a fresh context"
```

La ligne retirée assertait `blocking precondition`, la formule que D11 supprime :
la laisser en place ferait passer au vert exactement le texte que ce lot
remplace.

- [ ] **Step 2: Lancer la garde pour vérifier qu'elle échoue**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les quatre nouvelles lignes `writing-a-batch`, le texte de la
skill ne portant encore aucune de ces formules.

- [ ] **Step 3: Réécrire la précondition 1**

Dans `skills/writing-a-batch/SKILL.md`, remplacer la précondition 1 :

```markdown
1. **Every module this batch touches has an adopted spec** in
   `docs/specs/<module>.md`. If one does not, then adoption is a
   **blocking precondition**: stop, run `supercharlouze:adopting-a-module`,
   and get its pull request merged before coming back. Do not write the batch
   "in the meantime". A batch argues from a spec — without one, the delta has
   nothing to attach to, and you would end up inventing the module's norm from
   its code, which is exactly what adoption exists to prevent.
```

par :

```markdown
1. **Every module this batch touches has an adopted spec** in
   `docs/specs/<module>.md`. If one does not, **the design stops here** — and
   **adoption is never conducted in the same context**. Say what is missing, and
   let your human partner abandon the design or set it aside. Adoption then runs
   on its own, through `supercharlouze:adopting-a-module`, and the design
   **resumes in a fresh context** once that pull request is merged, starting from
   the adopted spec.

   Two reasons, and the second is the one that is easy to miss. A batch argues
   from a spec — without one, the delta has nothing to attach to, and you would
   end up inventing the module's norm from its code, which is exactly what
   adoption exists to prevent. And an adoption run in this conversation would
   carry into the batch every mechanism it read while auditing the code: the
   design that follows would then argue from what the code does, having been told
   in the same breath that it must not. Chaining the two is what makes that leak
   invisible, so the stop is the rule and not a preference.
```

Le renvoi à `adopting-a-module` nomme la skill, jamais un numéro d'étape.

- [ ] **Step 4: Réécrire la ligne de Red Flags**

Dans la table `Red Flags` de la même skill, remplacer :

```markdown
| "The module has no spec yet, I'll write the batch and adopt later" | Adoption is blocking. Otherwise the batch invents the norm it is supposed to obey. |
```

par :

```markdown
| "The module has no spec yet, I'll write the batch and adopt later" | The design stops. Otherwise the batch invents the norm it is supposed to obey. |
| "The module has no spec, I'll adopt it right now and come back" | Adoption is never conducted in the same context. It would carry the mechanisms it read in the code into the design that follows. Stop, and resume in a fresh context after the merge. |
```

- [ ] **Step 5: Lancer la garde pour vérifier qu'elle passe**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les quatre lignes `writing-a-batch` ajoutées à l'étape 1.

- [ ] **Step 6: Lancer la suite entière**

Run: `bash tests/run-all.sh`
Expected: PASS partout.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: une conception qui découvre un module non adopté s'arrête"
```

---

### Task 2: `using-batches` — le routage et l'Override 1 disent l'arrêt

`using-batches` route le travail et justifie l'écart à superpowers. Ses deux
endroits qui parlent d'adoption décrivent encore un enchaînement : la ligne de
sa table de routage, et le paragraphe *The substitute may itself be blocked* de
l'Override 1. Elle renvoie à `writing-a-batch` pour l'argument, qu'elle ne
recopie pas.

**Files:**
- Modify: `skills/using-batches/SKILL.md:16` (ligne de la table de routage)
- Modify: `skills/using-batches/SKILL.md:186` (paragraphe `Architectural`)
- Modify: `skills/using-batches/SKILL.md:202` (Override 1, *The substitute may itself be blocked*)
- Modify: `skills/using-batches/SKILL.md:259` (ligne de Red Flags)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le texte intégral de la règle vit dans `skills/writing-a-batch/SKILL.md`,
  précondition 1 (Task 1). Cette tâche y renvoie et ne le recopie pas.
- Produces: rien pour la suite.

- [ ] **Step 1: Écrire la garde qui échoue**

Dans `tests/test-skill-content.sh`, à la suite des lignes `using-batches`
existantes, ajouter :

```bash
require using-batches "an unadopted module stops the design"     "the design stops"
require using-batches "adoption never shares the design's context" "never conducted in the same context"
require using-batches "Override 1 stays bounded to steps 6 to 9" "still covers steps 6 to 9 and nothing else"
```

La troisième garde tient la propriété qui faisait tout le prix du paragraphe
réécrit : l'arrêt ne fabrique pas un cinquième override.

- [ ] **Step 2: Lancer la garde pour vérifier qu'elle échoue**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les deux premières lignes `using-batches` ajoutées ; la
troisième passe déjà, le paragraphe actuel portant la phrase.

- [ ] **Step 3: Réécrire la ligne de la table de routage**

Dans `skills/using-batches/SKILL.md`, remplacer :

```markdown
| A module this work touches has no spec in `docs/specs/` | `supercharlouze:adopting-a-module` — blocking; nothing starts until its pull request merges |
```

par :

```markdown
| A module this work touches has no spec in `docs/specs/` | `supercharlouze:adopting-a-module`, in a context of its own — the design stops, and resumes in a fresh context once that pull request merges |
```

- [ ] **Step 4: Réécrire le paragraphe `Architectural`**

Remplacer :

```markdown
**Architectural** — **steps 6 to 9** of the architectural checklist (dated design doc, self-review, human review, transition to writing-plans) are replaced by `supercharlouze:writing-a-batch`, which may first require `supercharlouze:adopting-a-module` as a blocking precondition. That is Override 1 below. Steps 1 to 5 — context, questions, approaches, design presented section by section, approval — are **kept intact**: that is the design work itself, and it has no reason to change.
```

par :

```markdown
**Architectural** — **steps 6 to 9** of the architectural checklist (dated design doc, self-review, human review, transition to writing-plans) are replaced by `supercharlouze:writing-a-batch`, which stops the design outright when a module it touches has no spec. That is Override 1 below. Steps 1 to 5 — context, questions, approaches, design presented section by section, approval — are **kept intact**: that is the design work itself, and it has no reason to change.
```

- [ ] **Step 5: Réécrire *The substitute may itself be blocked***

Remplacer le paragraphe :

```markdown
**The substitute may itself be blocked.** When a module the work touches has no spec, `supercharlouze:writing-a-batch` treats `supercharlouze:adopting-a-module` as a blocking precondition, so that skill runs first — named here rather than left implicit, because a second post-brainstorming skill under a rule stated as closed is exactly what an unnamed exception looks like. It widens nothing: the override still covers steps 6 to 9 and nothing else.
```

par :

```markdown
**The substitute stops rather than chaining.** When a module the work touches has no spec, `supercharlouze:writing-a-batch` does not run `supercharlouze:adopting-a-module` and come back: **the design stops**, your human partner abandons it or sets it aside, and it resumes in a fresh context once the adoption pull request is merged. That skill's `Preconditions` carry the full rule and the reason — **adoption is never conducted in the same context as a design**, because it would carry the mechanisms it read in the code into the batch that follows. Said here because a post-brainstorming path that ends anywhere other than `supercharlouze:writing-a-batch` is exactly what an unnamed exception looks like, and this one ends nowhere at all — it stops. It widens nothing: the override still covers steps 6 to 9 and nothing else, and the resumed design re-enters at the same place.
```

- [ ] **Step 6: Réécrire la ligne de Red Flags**

Remplacer :

```markdown
| "The module has no spec but the change is small, I'll just code it" | Adoption is a blocking precondition: without an adopted spec there is no authority to review against, and the change becomes drift the moment it merges. |
```

par :

```markdown
| "The module has no spec but the change is small, I'll just code it" | Without an adopted spec there is no authority to review against, and the change becomes drift the moment it merges. The design stops until the module is adopted. |
| "The module has no spec, I'll adopt it now and carry on designing" | Adoption is never conducted in the same context as a design. Stop, and resume in a fresh context once the adoption merges. |
```

- [ ] **Step 7: Lancer la garde pour vérifier qu'elle passe**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les trois lignes `using-batches` ajoutées à l'étape 1.

- [ ] **Step 8: Lancer la suite entière**

Run: `bash tests/run-all.sh`
Expected: PASS partout. `tests/test-declared-overrides.sh` en particulier, qui
lit les quatre overrides déclarés : la réécriture ne doit ni en ajouter un ni en
retirer un.

- [ ] **Step 9: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
git commit -m "feat: le routage et l'Override 1 disent l'arrêt, pas l'enchaînement"
```

---

### Task 3: `adopting-a-module` — on y arrive dans un contexte neuf

La skill dit encore « you arrive here from there », qui décrit l'enchaînement que
D10 supprime. Sa clôture, elle, nomme déjà `supercharlouze:writing-a-batch`
comme étape suivante après le clear : c'est exactement la reprise que D10 exige,
et il suffit de dire que cette reprise est un **départ**, pas un retour.

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md:19-23` (comment on arrive ici)
- Modify: `skills/adopting-a-module/SKILL.md:327-332` (la fin de revue nomme l'étape suivante)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le texte intégral de la règle vit dans `skills/writing-a-batch/SKILL.md`,
  précondition 1 (Task 1). Cette tâche y renvoie et ne le recopie pas.
- Produces: rien pour la suite.

- [ ] **Step 1: Écrire la garde qui échoue**

Dans `tests/test-skill-content.sh`, à la suite des lignes `adopting-a-module`
existantes, ajouter :

```bash
require adopting-a-module "arrives in a context of its own"      "in a context of its own"
require adopting-a-module "the design that follows starts fresh" "from the adopted spec, not from a conversation"
```

- [ ] **Step 2: Lancer la garde pour vérifier qu'elle échoue**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les deux lignes `adopting-a-module` ajoutées.

- [ ] **Step 3: Réécrire comment on arrive ici**

Dans `skills/adopting-a-module/SKILL.md`, remplacer :

```markdown
Run this when a batch is about to touch a module that has no spec yet.
`supercharlouze:writing-a-batch` treats adoption as a blocking precondition, so
you arrive here from there, or directly when your human partner asks for a module
to be adopted.
```

par :

```markdown
Run this when a batch is about to touch a module that has no spec yet — always
**in a context of its own**. A design that discovers an unadopted module stops
instead of chaining here; you arrive from a conversation that begins with this
adoption, or directly when your human partner asks for a module to be adopted.
`supercharlouze:writing-a-batch` carries the rule and the reason in its
`Preconditions`.
```

- [ ] **Step 4: Dire que l'étape suivante est un départ**

Remplacer :

```markdown
So the announcement names `supercharlouze:writing-a-batch` as the next step, and
gives the prompt for it in a block to copy and paste after the clear. **That
prompt stands on its own:** it names the skill to invoke, and the prompt names
the adopted spec by path, and the gaps register beside it, and never refers
back to this conversation.
```

par :

```markdown
So the announcement names `supercharlouze:writing-a-batch` as the next step, and
gives the prompt for it in a block to copy and paste after the clear. **That
prompt stands on its own:** it names the skill to invoke, and the prompt names
the adopted spec by path, and the gaps register beside it, and never refers
back to this conversation.

That next step is a **start, not a return**. A design that stopped on this
module does not carry over: it begins again from the adopted spec, not from a
conversation, and whatever it had established before the stop is restated there
or lost. Saying so is what keeps the clear honest — a design resumed from memory
would bring back the very mechanisms the clear was meant to drop.
```

- [ ] **Step 5: Lancer la garde pour vérifier qu'elle passe**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les deux lignes `adopting-a-module` ajoutées à l'étape 1.

- [ ] **Step 6: Lancer la suite entière**

Run: `bash tests/run-all.sh`
Expected: PASS partout.

- [ ] **Step 7: Commit**

```bash
git add skills/adopting-a-module/SKILL.md tests/test-skill-content.sh
git commit -m "feat: on arrive à l'adoption dans un contexte neuf, et on en repart de même"
```

---

## Rulings log

## Observed drift
