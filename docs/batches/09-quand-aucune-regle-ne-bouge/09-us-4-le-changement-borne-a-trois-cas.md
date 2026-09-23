# 09-us-4 — Le changement borné à trois cas

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/09-quand-aucune-regle-ne-bouge/README.md
**Sections:** Bounded change
**Blocks:** D15, D16

**Goal:** Mettre les skills, le README et la suite de tests en conformité avec la
spec que le premier commit de cette branche a livrée : un changement borné est
une pull request unique, qui laisse la spec muette si et seulement si rien
d'observable à la frontière du module ne change, et dont la déclaration nomme la
spec visée autant que les sections.

**Architecture:** Le code de ce dépôt, ce sont les cinq skills de `skills/`, le
`README.md` qui les présente, et les assertions de `tests/` qui les tiennent.
La modification de spec est déjà commitée. Trois tâches, trois sujets : les trois
cas de la mise à jour de spec, la déclaration du changement borné, puis la
présentation que le README en donne au lecteur humain.

**Tech Stack:** Markdown ; suite de tests en bash pur (`tests/run-all.sh`), dont
les assertions lisent le corps des documents aplati en une ligne.

## Global Constraints

Les contraintes que le lot impose, sa section `Constraints` recopiée mot pour
mot :

> **Ordre des blocs.** `D1` pose le seul terme neuf et précède donc `D4`, `D5`, `D7`,
> `D12` et `D13`. `D12` précède `D7` et `D13`, qui renvoient tous deux à la condition
> d'arrêt qu'il écrit. Tous les autres sont indépendants.
>
> **Six sections portent plusieurs blocs, dont l'ordre entre eux est libre** : leurs
> ancres sont disjointes. `The model` (`D1`, `D2`), `Authority and conflict rules`
> (`D9`, `D17`, `D18`), `Batch > Amending a batch` (`D11`, `D13`), `Story > The user
> story document` (`D5`, `D6`, `D7`), `Bounded change` (`D15`, `D16`), `Batch >
> Opening a batch` (`D21`, `D22`).
>
> **Une seule pull request est en vol** : la clôture du lot 08. Elle écrit une ligne
> de changelog au pied de la spec et consolide dans le gaps register — aucun passage
> que ce lot cite, mais l'annotation `reserved by batch-09` vit dans ce même fichier
> de registre, où un conflit de fusion git est possible. Il se résout sur la branche
> de la story.

Le gel du fichier de spec :

> Entre le premier commit de la branche et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.

La règle d'autorité : **quand le lot et la spec se contredisent, la spec gagne —
sans exception et sans délibération.** Implémente ce que dit la spec, consigne un
`Ruling:`, et continue. **Corriger une spec en cours de lot est un acte humain,
jamais un acte d'agent.**

**Frontière avec les stories sœurs de ce lot.** Deux autres stories du lot 09
vivent en parallèle et leurs sections sont disjointes de celle-ci. En
particulier, **ce plan ne touche pas `skills/writing-a-user-story/SKILL.md`** :
le côté *lecteur* de la déclaration — comment l'étape 1 filtre les pull requests
et où elle lit la déclaration d'un changement borné — relève du bloc `D10`,
`Story > Concurrency detection`, qu'une autre story livre. Ce plan ne change que
le côté *écrivain* : ce qu'un changement borné doit déclarer, et quand il doit
refaire la détection. Une tâche qui se croit obligée d'aller corriger le lecteur
s'arrête et le dit.

**Langue.** Ossature anglaise, prose française — y compris dans les libellés
d'assertions, qui sont de l'ossature et restent en anglais comme leurs voisines.

---

### Task 1: Les trois cas de la mise à jour de spec

Le changement borné cesse d'être défini comme « une pull request qui porte sa
mise à jour de spec » : c'est une pull request unique, et sa règle (a) décide s'il
y a une mise à jour de spec. Cette règle passe à trois cas.

**Files:**
- Modify: `skills/using-batches/SKILL.md` — la ligne de définition du bloc
  `Bounded` (« **Bounded** — ceremony unchanged, with four rules: » et sa
  règle (a)), la phrase de clôture du bloc (« No batch, no user story: … »), et
  la ligne de la table `Red Flags` qui commence par « "This is a small fix, the
  spec can stay silent about it" »
- Test: `tests/test-cross-references.sh`, `tests/test-skill-content.sh`,
  `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la formulation « if and only if nothing observable at the module's
  boundary changes », que les assertions de cette tâche et la tâche 3 citent.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, juste avant la ligne finale
`exit $((FAILURES > 0))`, ouvrir un bloc et y ajouter :

```bash
# --- using-batches: the bounded change (spec `Bounded change`) ---
```

puis, dans ce bloc :

```bash
require using-batches "a bounded change may leave the spec silent" \
        "if and only if nothing observable at the module's boundary changes"
require using-batches "a silent bounded change writes no changelog line" \
        "the spec stays silent and no changelog line is written"
```

Dans `tests/test-skill-contracts.sh`, juste avant la ligne finale
`exit $((FAILURES > 0))`, ajouter le garde qui interdit la survivance de la claim
inconditionnelle. Faire précéder l'appel du commentaire qui dit pourquoi il
existe, comme le font ses voisins :

```bash
# The unconditional claim the spec change removed: a bounded change used to be
# said never to leave the spec silent. The positive assertion above would stay
# green on a file carrying both phrasings, and the two contradict each other —
# one says the spec is always updated, the other says it depends.
absent "no skill says a bounded change never leaves the spec silent" \
       "never leaves the spec silent" \
       using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

Dans `tests/test-cross-references.sh`, au point 4 (« The bounded path is spelled
out »), remplacer le needle `"never leaves the spec silent"` par
`"if and only if nothing observable"`. La liste devient :

```bash
for needle in "out-of-batch" "if and only if nothing observable" "fix/" "no feature flag"; do
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh; bash tests/test-cross-references.sh`

Expected: FAIL sur `using-batches: a bounded change may leave the spec silent`,
FAIL sur `using-batches: a silent bounded change writes no changelog line`,
FAIL sur `no skill says a bounded change never leaves the spec silent (present in: using-batches)`,
FAIL sur `bounded path states: if and only if nothing observable`.

- [ ] **Step 3: Write the rule**

Dans `skills/using-batches/SKILL.md`, remplacer la règle (a) :

```markdown
- **(a) Its pull request never leaves the spec silent.** Whether it *alters* a behaviour some spec already describes or *adds* one no spec describes, it updates the spec in the same pull request as the code, with an `out-of-batch` changelog line. Handling only the "alters" case would reopen the same hole one notch over.
```

par :

```markdown
- **(a) Its pull request leaves the spec silent if and only if nothing observable at the module's boundary changes.** Whether it *alters* a behaviour some spec already describes or *adds* one no spec describes, it updates the spec in the same pull request as the code, with an `out-of-batch` changelog line — handling only the "alters" case would reopen the same hole one notch over. Where nothing observable at that boundary changes — a dependency bump, an internal rename, a preparatory refactor — the spec stays silent and no changelog line is written. That third case is not a tolerance: a rule does not move when a mechanism moves, so there is nothing to write, and writing something anyway means inventing a sentence from the code, which canonises the drift it describes.
```

Puis remplacer la phrase de clôture du bloc :

```markdown
No batch, no user story: a bounded change is already a pull request, it simply carries its spec update. Its branch is `fix/<slug>`.
```

par :

```markdown
No batch, no user story: a bounded change is already a single pull request, and whether it carries a spec update is what rule (a) decides. Its branch is `fix/<slug>`.
```

Puis, dans la table `Red Flags`, remplacer la ligne :

```markdown
| "This is a small fix, the spec can stay silent about it" | A bounded change updates the spec in the same pull request, with an `out-of-batch` changelog line, and declares its sections. |
```

par :

```markdown
| "This is a small fix, the spec can stay silent about it" | Only if nothing observable at the module's boundary changes. The moment behaviour moves, the spec is updated in the same pull request, with an `out-of-batch` changelog line — and either way the change declares its sections. |
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh tests/test-cross-references.sh
git commit -m "feat: un changement borné ne met la spec à jour que si un comportement bouge"
```

---

### Task 2: Ce que déclare un changement borné

Un changement borné peut désormais ne toucher aucune section. Sa déclaration doit
donc dire quelle spec il vise, et valoir `none` plutôt que rester blanche ; et une
déclaration qui change avant l'ouverture refait la détection.

**Files:**
- Modify: `skills/using-batches/SKILL.md` — la règle (b) du bloc `Bounded` et le
  paragraphe d'angle mort qui la suit
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la règle (a) réécrite par la tâche 1, à laquelle la règle (b) ne
  touche pas.
- Produces: la formulation « the spec it targets and the sections it touches »,
  que la tâche 3 cite dans le README.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, à la suite des assertions ajoutées par la
tâche 1, dans le même bloc `# --- using-batches: the bounded change … ---`,
ajouter :

```bash
require using-batches "a bounded change names the spec it targets" \
        "the spec it targets and the sections it touches"
require using-batches "a bounded change touching no section declares none" \
        "when it touches none"
require using-batches "a changed declaration redoes the detection" \
        "redoes the detection"
```

Dans `tests/test-skill-contracts.sh`, juste après le garde ajouté par la tâche 1
et avant la ligne finale `exit $((FAILURES > 0))`, ajouter :

```bash
# The old declaration named only the sections. Left standing beside the new one,
# it would tell a bounded change that naming its sections is enough — and a
# reader comparing sections against the wrong spec finds conflicts that are not
# there, or misses the one that is.
#
# The needle carries "therefore" on purpose. Step 1 of writing-a-user-story
# tells a *reader* where a bounded change keeps its declaration, in words that
# overlap this one; that sentence belongs to the concurrency detection rule and
# is not what this guard hunts. "therefore declares its sections" appears only
# where the duty is laid on the bounded change itself.
absent "no skill says a bounded change declares only its sections" \
       "therefore declares its sections" \
       using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`

Expected: FAIL sur `using-batches: a bounded change names the spec it targets`,
FAIL sur `using-batches: a bounded change touching no section declares none`,
FAIL sur `using-batches: a changed declaration redoes the detection`,
FAIL sur `no skill says a bounded change declares only its sections (present in: using-batches)`.

Si ce dernier passe au vert avant toute modification, la règle (b) a déjà été
réécrite ailleurs : arrête-toi et dis-le, plutôt que de relâcher le garde.

- [ ] **Step 3: Write the rule**

Dans `skills/using-batches/SKILL.md`, remplacer la règle (b) :

```markdown
- **(b) It undergoes the same concurrency detection as a story**, and therefore declares its sections in the body of its pull request — otherwise it would hit a story in flight through a back door. Run **Step 1 of `supercharlouze:writing-a-user-story`** before creating `fix/<slug>` — the same open pull requests and the same pushed `story/*` branches to scan, the same `gh` calls, the same `Sections:` declaration read wherever each pull request keeps it — and stop on the same conditions, including the one where a declaration cannot be read. Symmetrically, a bounded change's declaration is read in its pull request body, because that is where a bounded keeps it: it has no story document, and a reader that looked only for one would stop on every open bounded change and jam the nominal path for as long as one stays open.
```

par :

```markdown
- **(b) It undergoes the same concurrency detection as a story**, and therefore declares in the body of its pull request **the spec it targets and the sections it touches**, `none` when it touches none — otherwise it would hit a story in flight through a back door. The spec is named because nothing else in the declaration says which document those section titles belong to, and a bounded change that updates no spec file leaves a reader nothing to infer it from; two identically titled sections in two different specs are not a conflict. And `none` is a declaration, not a blank: it is what a bounded change that changes nothing observable has to say, where a blank body is indistinguishable from one nobody filled in — which is an unknown, and an unknown stops the reader. Run **Step 1 of `supercharlouze:writing-a-user-story`** before creating `fix/<slug>` — the same open pull requests and the same pushed `story/*` branches to scan, the same `gh` calls, the same declaration read wherever each pull request keeps it — and stop on the same conditions, including the one where a declaration cannot be read. Symmetrically, a bounded change's declaration is read in its pull request body, because that is where a bounded keeps it: it has no story document, and a reader that looked only for one would stop on every open bounded change and jam the nominal path for as long as one stays open.
```

Puis, dans le paragraphe d'angle mort qui suit immédiatement, remplacer :

```markdown
  **A bounded change is in turn invisible until its own pull request opens, and that is accepted.** Its `fix/<slug>` branch declares nothing, since the sections live in the pull request body — so between its first commit and its pull request, nothing shows what it holds.
```

par :

```markdown
  **A declaration that changes before the pull request opens redoes the detection.** Step 1 answered about the sections declared when it ran, so a section added afterwards was never intersected against anything — not found free, simply never looked at. Redoing it costs one scan, and the opening is the last point where the widening is still cheap to undo.

  **A bounded change is in turn invisible until its own pull request opens, and that is accepted.** Its `fix/<slug>` branch declares nothing, since the declaration lives in the pull request body — so between its first commit and its pull request, nothing shows what it holds.
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
git commit -m "feat: la déclaration d'un changement borné nomme la spec qu'il vise"
```

---

### Task 3: Ce que le README en dit

Le README présente les quatre règles du changement borné à un lecteur humain qui
n'a encore rien lu du flux. Sa phrase porte aujourd'hui la version
inconditionnelle des deux règles réécrites.

**Files:**
- Modify: `README.md` — le paragraphe de la section `### What stays outside a batch`
- Test: `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: les formulations produites par les tâches 1 et 2.
- Produces: rien.

- [ ] **Step 1: Write the failing assertion**

Dans `tests/test-cross-references.sh`, à la fin du point 4 (juste après la boucle
`for needle in …; do … done`), ajouter le garde qui tient le README sur la même
règle que la skill. Le faire précéder du commentaire qui dit pourquoi :

```bash
# The README states the same four rules for a human reader who has read nothing
# else. It is the one shipped artifact that paraphrases them, so it is also the
# one that can keep asserting the unconditional version after the skill stopped.
# The needle carries "no change" so it cannot match the true rule, which reads
# "leaves the spec silent if and only if" — the trap the `absent` helper in
# test-skill-contracts.sh documents avoiding.
if grep -q "no change leaves the spec silent" "$REPO_ROOT/README.md"; then
    fail "the README does not assert the unconditional spec update"
else
    pass "the README does not assert the unconditional spec update"
fi
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-cross-references.sh`

Expected: FAIL sur `the README does not assert the unconditional spec update`.

- [ ] **Step 3: Rewrite the paragraph**

Dans `README.md`, remplacer :

```markdown
A **bounded change** — a
well-scoped change to code that already exists — keeps its own ceremony and its
`fix/<slug>` branch, under four rules: it updates the spec in the same pull
request, so no change leaves the spec silent; it declares its sections like a
story; it carries no flag, being complete on its own; and it may write to a gaps
register directly. Only architectural work opens a batch.
```

par :

```markdown
A **bounded change** — a
well-scoped change to code that already exists — keeps its own ceremony and its
`fix/<slug>` branch, under four rules: it updates the spec in the same pull
request whenever something observable at the module's boundary changes, and says
nothing there only when nothing does; it declares the spec it targets and the
sections it touches, like a story; it carries no flag, being complete on its own;
and it may write to a gaps register directly. Only architectural work opens a
batch.
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add README.md tests/test-cross-references.sh
git commit -m "docs: le README présente les trois cas du changement borné"
```

## Rulings log

L'exécution par sous-agents n'a produit aucun arbitrage : la relecture
préalable du plan était propre, aucune tâche n'a buté sur une contradiction
entre le lot et la spec, et aucun constat de revue n'a été parqué. Un seul
arbitrage a été pris, au moment d'écrire le plan.

Ruling: la story ne livre que le côté *écrivain* de la déclaration d'un
changement borné — ce qu'il doit déclarer et quand il refait la détection — et
laisse intact le côté *lecteur*, l'étape 1 de `writing-a-user-story` —
parce que le bloc `D10` réécrit `Story > Concurrency detection`, qui est la
section où le lecteur est normé, et qu'une story sœur de ce lot le tient ;
transcrire le lecteur ici aurait livré deux fois la même règle, sur deux
branches, dans deux sections — ce qu'il en coûte si c'est faux : si `D10` est
abandonné, `main` porte un écrivain qui nomme la spec visée et un lecteur qui
ne la lit pas, et c'est alors la clôture du lot qui doit constater l'écart.

## Observed drift

Aucune divergence entre la spec et le code sur `main` en dehors du périmètre de
cette story.

Une **asymétrie interne au lot** mérite d'être signalée, qui n'est pas une
dérive aujourd'hui : après cette story, `Bounded change` (b) veut qu'un
changement borné nomme la spec qu'il vise, et rien ne lit encore ce nom, parce
que `Story > Concurrency detection` — que le bloc `D10` réécrit — ne le demande
pas encore. Les deux moitiés se rejoignent quand `D10` est livré. Si `D10` ne
l'est pas, l'écart devient réel et relève de la clôture du lot.
