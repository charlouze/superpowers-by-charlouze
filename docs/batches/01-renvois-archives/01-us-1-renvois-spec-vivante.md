# 01-us-1 — Renvois vers la spec vivante

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Faire pointer les deux renvois des artefacts livrés vers une section
nommée de la spec vivante, au lieu d'un numéro de section du document de
conception archivé.

**Architecture:** Un lot correctif : aucun comportement nouveau, aucune écriture
dans la spec. Une assertion de garde est ajoutée à la suite structurelle
existante, elle échoue sur les deux renvois actuels, puis les deux renvois sont
réécrits pour nommer leur section. La garde reste ensuite en place et empêche la
réapparition du défaut.

**Tech Stack:** Bash, la suite de tests structurels du dépôt (`tests/run-all.sh`),
`grep -E`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/01-renvois-archives/README.md
**Sections:** Verification

## Global Constraints

Contraintes du lot, recopiées verbatim de la section `Constraints` de
`docs/batches/01-renvois-archives/README.md` :

- **Ne pas réintroduire de numérotation dans la spec vivante.** Ses sections sont
  titrées et non numérotées, délibérément : la section est l'unité de tout ce qui
  se compte dans ce système, et un numéro se périme au premier réagencement. Un
  renvoi nomme la section, il ne la compte pas.
- **`commands/init.md` est lu par un agent, pas par un humain.** Son texte est
  chargé tel quel à chaque invocation de la commande. La correction doit y rester
  une instruction exécutable, et non devenir une citation ou une note de bas de
  page.
- **Ne rien corriger d'autre.** Les douze entrées de la section *Gaps* du registre
  ne sont pas dans ce périmètre et ne sont pas réservées par ce lot. Une dérive
  constatée en chemin se consigne sous `Observed drift`, jamais dans le registre
  directement.
- **Ordre des stories :** aucun. Ce lot est attendu en une story.

**Gel du fichier de spec :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.

Ici le commit de transcription est le commit `0724006`, qui barre l'entrée du
registre : le delta étant vide, il ne touche pas la spec. `docs/specs/supercharlouze.md`
ne doit être modifié par aucune tâche.

**Autorité :** quand le lot et la spec se contredisent, **la spec gagne — sans
exception et sans délibération.** Implémenter ce que dit la spec, inscrire un
`Ruling:`, et poursuivre. **Corriger une spec en cours de lot est un acte humain,
jamais un acte d'agent.**

**Cinquième condition d'arrêt — lot correctif :**

> Si, en mettant du code en conformité avec la spec, tu découvres que c'est la
> **spec** qui a tort et le code qui a raison, arrête-toi. Le lot n'est plus
> correctif et doit être requalifié. Ne corrige pas la spec et ne la contourne
> pas.

---

### Task 1: La garde et les deux renvois

**Files:**
- Modify: `tests/test-cross-references.sh` — ajouter l'assertion 5, avant `exit`
- Modify: `README.md:53-54`
- Modify: `commands/init.md:9-10`

**Interfaces:**
- Consumes: les helpers déjà définis en tête de `tests/test-cross-references.sh` —
  `REPO_ROOT`, `pass "<label>"`, `fail "<label>"`, le compteur `FAILURES`.
- Produces: rien que d'autres tâches consomment. Cette story tient en une tâche.

**Pourquoi une seule tâche.** Les deux renvois sont le même défaut, couverts par
la même entrée de registre et la même assertion. Un reviewer ne peut pas
raisonnablement accepter l'un en refusant l'autre.

- [ ] **Step 1: Write the failing test**

Ajouter à la fin de `tests/test-cross-references.sh`, **avant** la ligne
`exit $((FAILURES > 0))` :

```bash
# 5. No shipped artifact cites a numbered section of the archived design
#    document. The living spec is the binding authority and its sections are
#    titled, not numbered: a numbered pointer names a document that adoption
#    stripped of authority, and it rots further at every reshuffle of the spec.
#    tests/ is deliberately out of range — it is not shipped to users, and the
#    gaps register entry this guard answers to names only the shipped artifacts.
BAD=0
while read -r hit; do
    [ -n "$hit" ] || continue
    echo "    numbered reference to the archived design document: $hit"
    BAD=$((BAD + 1))
done < <(grep -rnoEi 'spec section [0-9]+|section [0-9]+ of the design|\(spec [0-9]+(\.[0-9]+)?\)' \
             "$REPO_ROOT/README.md" "$REPO_ROOT/skills" "$REPO_ROOT/commands" "$REPO_ROOT/scripts" \
             2>/dev/null | sort -u || true)

if [ "$BAD" = "0" ]; then
    pass "no shipped artifact cites a numbered section of the archived design document"
else
    fail "no shipped artifact cites a numbered section of the archived design document ($BAD found)"
fi
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-cross-references.sh`

Expected: FAIL, avec exactement deux occurrences listées —

```
    numbered reference to the archived design document: <repo>/README.md:54:section 11 of the design
    numbered reference to the archived design document: <repo>/commands/init.md:10:spec section 9
  [FAIL] no shipped artifact cites a numbered section of the archived design document (2 found)
```

Si le compte n'est pas exactement 2, s'arrêter : soit le motif attrape autre chose
que le défaut, soit le périmètre a bougé depuis l'écriture du plan.

- [ ] **Step 3: Write minimal implementation**

Dans `README.md`, remplacer les lignes 53-54 :

```markdown
Structural checks only — see section 11 of the design document for what is
deliberately not tested.
```

par :

```markdown
Structural checks only — see the `Verification` section of
`docs/specs/supercharlouze.md` for what is deliberately not tested.
```

Dans `commands/init.md`, remplacer les lignes 9-10 :

```markdown
Everything in this system ships through a pull request, and this command is no
exception (spec section 9).
```

par :

```markdown
Everything in this system ships through a pull request, and this command is no
exception — see `The init command` in `docs/specs/supercharlouze.md`.
```

Les deux nomment leur section au lieu de la compter. `commands/init.md` reste une
instruction : le renvoi tient sur la même phrase, sans note ni parenthèse
explicative.

**Limite connue, à ne pas essayer de fermer ici.** L'assertion 2 de ce même
fichier vérifie que les chemins entre backticks existent, mais son motif ne couvre
que `skills|scripts|commands|tests|.claude-plugin`. L'étendre à `docs` ferait
échouer la suite, parce que les skills citent des **patrons** —
`docs/specs/<module>.md`, `docs/batches/NN-<slug>/README.md` — que ce contrôle ne
sait pas distinguer de vrais chemins. Les deux nouveaux renvois ne sont donc pas
vérifiés mécaniquement. C'est hors périmètre de ce lot.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-cross-references.sh`
Expected: PASS sur l'assertion 5, et les quatre assertions précédentes toujours
vertes.

Puis la suite complète : `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-cross-references.sh README.md commands/init.md
git commit -m "fix: name the spec section instead of counting it"
```

## Rulings log

## Observed drift
