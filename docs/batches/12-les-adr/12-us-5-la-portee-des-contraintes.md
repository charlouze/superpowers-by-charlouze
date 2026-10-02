# La portée des contraintes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les contraintes d'un lot ne lient que ses stories.

**Architecture:** `## The Batch Document` de `skills/writing-a-batch/SKILL.md` gagne une phrase qui dit que les contraintes d'un lot ne lient que ses stories, à la suite du paragraphe qui dit quelle décision technique va dans `Constraints`. Sa garde vit dans `tests/test-skill-content.sh`, écrite avant le texte.

**Tech Stack:** Markdown pour la skill, Bash pour la garde de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/12-les-adr/README.md
**Sections:** Batch > The batch document
**Blocks:** D14

## Global Constraints

Contraintes du lot, recopiées mot pour mot :

> `D1`, `D2` et `D3` sont transcrits par la même story, avant tout autre bloc sauf
> `D14` et `D20`.
>
> `D4` à `D12` sont transcrits par la même story.
>
> `D13`, `D15` et `D16` sont transcrits par la même story.
>
> `D17`, `D18` et `D19` sont transcrits par la même story, après `D15`.
>
> La story qui transcrit `D2` livre la skill `recording-a-decision`.
>
> Toutes les stories emploient tels quels le répertoire `docs/adr/` et la skill
> `recording-a-decision`.

Gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

Règle d'autorité :

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

Règles de concision :

> These rules hold for every document, pull request body and commit message
> this story writes.
>
> Every sentence says one exact thing, once, and stands on its own.
>
> Every paragraph carries one rule.
>
> A rule says how far it holds, and an exception presents itself as one.
>
> A text says what it delivers or decides, without telling how it got there or
> why. Exception: a reason that is explicitly asked for, such as the why of a
> ruling.
>
> No sentence is set in relief: no bold that ranks one sentence above its
> neighbours.

Condition d'arrêt sur une contrainte ou un ADR qui ne peut pas être tenu :

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

Conditions d'un ADR :

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

Règles du dépôt, qui valent pour chaque tâche :

- Une skill et un test sont entièrement en anglais.
- Une skill ne cite jamais une section de `docs/specs/supercharlouze.md`. Une section qu'une skill nomme entre parenthèses est l'un de ses propres titres.
- Chaque norme qu'une skill énonce a sa garde dans `tests/`, écrite avant le texte et vue rouge.
- Chaque phrase d'une skill change ce qu'un agent fait. Pas de réfutation d'une version disparue, pas de cas particulier que la règle générale couvre déjà, pas de gras qui hiérarchise, pas de tiret à la place d'une virgule, pas de liste qui annonce combien d'éléments elle tient.
- Une règle est écrite en entier à un seul endroit et pointée ailleurs.
- Cette story ne livre que ce qui réalise `D14`. `## The ADRs`, `## The Technical Reread` et `## Amending a Batch` de `skills/writing-a-batch/SKILL.md`, et la table de routage de `skills/using-batches/SKILL.md`, ne sont pas touchés.
- Le texte d'une skill donné dans une tâche est écrit tel quel. Un implémenteur qui le juge faux le dit dans son rapport, et ne le réécrit pas.
- Tout commit passe par `bash ~/.config/github-app/as-agent.sh git -C <worktree> commit …` et se termine par la seule ligne d'attribution `Co-Authored-By: Charlouze <me@charlouze.com>`. Jamais de `Co-Authored-By: Claude …`, de `Claude-Session:` ni de « Generated with Claude Code ».
- Pendant une tâche, seuls les fichiers de test qu'elle touche sont lancés (`bash tests/<fichier>.sh`). La suite complète tourne à la fin de la story. Aucun lancement n'est laissé en arrière-plan.

## Review Focus

- Un agent qui écrit un lot suivant et tient pour siennes les contraintes d'un lot précédent : la phrase les borne aux stories de leur lot. Gardé en tâche 1.
- Un agent qui écrit dans `Constraints` une décision que le code à venir hors du lot devrait tenir : la phrase lui dit qu'elle ne liera que les stories du lot. Gardé en tâche 1.
- Une phrase qui enverrait vers un ADR toute décision appelée à durer : le seuil d'un ADR n'a pas de critère de portée, et la phrase n'en ajoute pas. Tenu par le texte donné en tâche 1.
- Une phrase qui redirait ce que `## The ADRs`, `## The Technical Reread` ou `## Amending a Batch` disent déjà : aucune de ces sections ne dit la portée des contraintes. Tenu par le texte donné en tâche 1.

---

### Task 1: Les contraintes d'un lot ne lient que ses stories

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## The Batch Document`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Écrire la garde**

Dans `tests/test-skill-content.sh`, après la garde dont le libellé est `a decision is a constraint only if the design relies on it` (les deux lignes `require writing-a-batch "a decision is a constraint only if the design relies on it" \` et sa suite), ajouter :

```bash
# A batch's constraints bind only its stories (spec section "The batch document"):
# neither another batch nor the code that comes after the batch has to hold them.
require writing-a-batch "a batch's constraints bind only its stories" \
    "A batch's constraints bind only its stories."
```

- [ ] **Step 2: Lancer la garde et la voir rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: une seule ligne, `[FAIL] writing-a-batch: a batch's constraints bind only its stories`.

- [ ] **Step 3: Écrire la phrase**

Dans `skills/writing-a-batch/SKILL.md`, dans `## The Batch Document`, après le paragraphe :

```markdown
A technical decision goes in `Constraints` only if the rest of the technical
design relies on it, such as a name or a format several parts of the design use.
Every other technical decision goes in `Technical design`, where a story may
depart from it.
```

insérer, précédé et suivi d'une ligne vide :

```markdown
A batch's constraints bind only its stories.
```

- [ ] **Step 4: Lancer les gardes et les voir vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: `0` trois fois.

- [ ] **Step 5: Commit**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: les contraintes d'un lot ne s'imposent qu'à ses stories

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
