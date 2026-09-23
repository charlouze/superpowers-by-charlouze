# La branche d'amendement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `writing-a-batch` dit que la branche d'un amendement ne suit aucun des patrons de branche du plugin, et non plus seulement qu'elle est distincte de `batch/NN-<slug>`.

**Architecture:** Une seule section de skill porte la règle — `## Amending a Batch` de `skills/writing-a-batch/SKILL.md`. Son paragraphe sur la branche est réécrit pour nommer tous les patrons que le plugin définit et dire pourquoi aucun ne convient : ce qu'un patron revendique, un amendement ne le tient pas. Une ligne de `## Red Flags` rattrape la tentation de nommer la branche d'après un patron, et trois gardes de `tests/test-skill-content.sh` tiennent le tout.

**Tech Stack:** Markdown (skills), bash (suite de gardes `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/09-quand-aucune-regle-ne-bouge/README.md
**Sections:** Batch > Amending a batch
**Blocks:** D11

## Global Constraints

Les contraintes du lot, recopiées mot pour mot depuis sa section `Constraints` :

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

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

La règle d'autorité : quand le lot et la spec se contredisent, **la spec gagne, sans
exception et sans délibération** — implémenter ce que dit la spec, consigner un
`Ruling:`, continuer. **Corriger une spec en cours de lot est un acte humain, jamais
un acte d'agent.**

Règles propres à ce dépôt, qui valent pour chaque tâche :

- **Une skill livrée ne cite jamais une section de la spec** : la spec est française
  et propre à ce dépôt, elle ne voyage pas avec le plugin. La norme s'énonce en
  anglais dans la skill. Contrôle : `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md`
  ne renvoie rien.
- **Ossature anglaise, prose de la langue du projet** : les skills sont entièrement
  en anglais.
- **Commits** : sous l'identité de l'agent, via
  `bash ~/.config/github-app/as-agent.sh git commit ...`, et terminés par la seule
  ligne `Co-Authored-By: Charlouze <me@charlouze.com>` — ni ligne `Co-Authored-By:
  Claude`, ni `Claude-Session:`.

## Review Focus

- **Un patron oublié dans l'énumération.** Le plugin définit six patrons de branche :
  `adopt/<module>`, `batch/NN-<slug>`, `batch/NN-<slug>-close`,
  `story/NN-us-N-<slug>`, `fix/<slug>`, `chore/supercharlouze-init`. Un lecteur qui
  n'en voit que quatre peut nommer sa branche d'après les deux autres ; la garde de la
  tâche 1 exige l'énumération entière.
- **La raison ancienne qui survit à côté de la nouvelle.** « do not reuse
  `batch/NN-<slug>`, which the opening pull request may still hold » est un cas
  particulier de la règle générale ; le garder ferait lire la règle comme une liste
  d'interdits ponctuels. La tâche 1 le retire.
- **Une revendication attribuée à tort.** `adopt/*` et `chore/supercharlouze-init` ne
  revendiquent ni numéro ni section ; le paragraphe ne doit pas prétendre que tout
  patron revendique quelque chose, seulement nommer ce que revendiquent ceux qui le
  font.
- **L'exception de nommage.** Le paragraphe garde ce qui fait de l'amendement la seule
  exception à la restauration d'un nom conventionnel, et pour cette seule raison.
- **Un renvoi à la spec.** Aucune phrase ajoutée ne cite une section de
  `docs/specs/supercharlouze.md`.

---

### Task 1: la branche d'un amendement ne suit aucun patron

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` — paragraphe « Do it on a **distinct branch whose name carries no meaning** … » de `## Amending a Batch` (vers la ligne 507), et une ligne ajoutée au tableau de `## Red Flags`
- Test: `tests/test-skill-content.sh` — bloc `# --- writing-a-batch (spec 4, 4.3, 5.2, 8.3) ---`, juste après la ligne `require writing-a-batch "amendment pull request exists" ...`

**Interfaces:**
- Consumes: la fonction `require <skill> <label> <needle>` de `tests/test-skill-content.sh`, qui cherche `<needle>` dans le corps aplati de la skill (retours à la ligne remplacés par des espaces, espaces multiples réduits à un).
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, après la ligne
`require writing-a-batch "amendment pull request exists"           "amendment pull request"`,
ajouter :

```bash
require writing-a-batch "an amendment branch follows no pattern"  "follows none of this plugin's branch patterns"
require writing-a-batch "the patterns are all named"              "\`adopt/<module>\`, \`batch/NN-<slug>\`, \`batch/NN-<slug>-close\`, \`story/NN-us-N-<slug>\`, \`fix/<slug>\`, \`chore/supercharlouze-init\`"
require writing-a-batch "a pattern name claims what it does not hold" "would claim what it does not hold"
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh | grep -E "FAIL|follows no pattern|patterns are all named|does not hold"`
Expected: les trois nouvelles lignes en `[FAIL]`, aucune autre ligne `[FAIL]`.

- [ ] **Step 3: Rewrite the amendment branch paragraph**

Dans `skills/writing-a-batch/SKILL.md`, remplacer :

```markdown
Do it on a **distinct branch whose name carries no meaning** — do not reuse
`batch/NN-<slug>`, which the opening pull request may still hold on the remote.
An amendment claims neither a fresh number nor any sections, so no scan looks for
its branch and its name has nothing to carry: that is what makes it the one
exception to restoring a conventional name, and the exception holds for that
reason alone. Edit the batch document **in place** — no
```

par :

```markdown
Do it on a branch whose name **follows none of this plugin's branch patterns** —
`adopt/<module>`, `batch/NN-<slug>`, `batch/NN-<slug>-close`,
`story/NN-us-N-<slug>`, `fix/<slug>`, `chore/supercharlouze-init`. Some of those
names are read as claims: `batch/*` and `story/*` claim a number, `story/*` and
`fix/*` claim sections. An amendment claims neither a number nor any section, so a
branch named after one of them would claim what it does not hold, and a name that
follows none has nothing to carry: that is what makes it the one exception to
restoring a conventional name, and the exception holds for that reason alone.
Edit the batch document **in place** — no
```

La suite du paragraphe (« changelog inside it, no history of its own scope — … »)
reste telle quelle.

- [ ] **Step 4: Add the Red Flags row**

Dans le tableau de `## Red Flags` du même fichier, ajouter après la ligne qui commence
par `| "The scope changed, I'll slip the edit into the next story's pull request" |` :

```markdown
| "I'll call the amendment branch `batch/NN-<slug>-amend`, it says what it is" | A name under one of this plugin's branch patterns claims what that pattern claims — a number, sections — and an amendment holds neither. Its branch follows none of them. |
```

- [ ] **Step 5: Run the guards and the whole suite**

Run: `bash tests/test-skill-content.sh | grep -E "FAIL|follows no pattern|patterns are all named|does not hold"`
Expected: les trois nouvelles lignes en `[PASS]`, aucune ligne `[FAIL]`.

Run: `bash tests/run-all.sh 2>&1 | tail -3`
Expected: `all tests passed`.

Run: `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md`
Expected: aucune citation d'une section de la spec — les renvois de `writing-a-batch` à ses propres sections `##` (`Preconditions`, `Allocating NN`, …) ne comptent pas.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: la branche d'un amendement ne suit aucun patron du plugin

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

## Rulings log

## Observed drift
