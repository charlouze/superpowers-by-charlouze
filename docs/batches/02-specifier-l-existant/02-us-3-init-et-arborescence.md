# 02-us-3 — L'init et l'arborescence : Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Poser une garde derrière les deux sûretés de `scripts/init.sh` que la tranche de spec vient de rendre normatives et que rien ne vérifiait.

**Architecture:** La tranche de spec est **déjà livrée** — premier commit de cette branche, `b8a8bb7`. Elle a rendu normatifs cinq refus et préservations du script d'init, plus le fait que `docs/specs/` et `docs/batches/` ne survivent pas à un clone.

**Trois de ces cinq comportements sont déjà gardés**, et il n'y a rien à y ajouter : `tests/test-init.sh` couvre la collision d'archivage (trois assertions : sortie non nulle, fichier archivé non écrasé, fichier entrant laissé en place), les quatre formes de marqueurs cassés (déséquilibrés, inversés, dupliqués — chacune avec « exits non-zero » **et** « CLAUDE.md left untouched »), et l'appariement sur la ligne entière (le cas « prose markers »). Vingt-neuf assertions au total. Cette tâche ne les touche pas.

**Deux ne le sont pas, et ce sont deux natures différentes :**

- **« supprimée une fois vidée, et seulement une fois vidée »** — la clause *seulement* n'a aucune assertion. Le cas `nested` vérifie que `docs/superpowers` disparaît quand elle est vide ; rien ne vérifie qu'elle **survit** quand elle ne l'est pas, ni qu'un document étranger au plugin y est laissé intact. C'est testable, directement et sans détour.
- **« le mode du fichier est préservé »** — non testable **ici**, et la raison doit être écrite dans le test plutôt que tue. Ce système de fichiers rapporte `644` pour tout fichier quel que soit le `chmod` demandé : `chmod 600` comme `chmod 755` laissent `644`. Une assertion comportementale y comparerait `644` à `644` et passerait que l'appel soit présent ou non — c'est-à-dire précisément le « test qui passerait sans rien vérifier » que la section `Coverage` du registre déclare indétectable. La garde est donc **structurelle** : elle atteste l'appel. C'est aussi ce que la section `Verification` de la spec demande — « contrôles structurels uniquement ».

**Tech Stack:** Bash, `set -euo pipefail`. `tests/test-init.sh` monte chaque cas dans un projet jetable sous `$TEST_ROOT` et appelle `bash "$INIT" "$P"`. Helpers `pass` / `fail` déjà définis en tête.

**Spec:** docs/specs/supercharlouze.md

**Batch:** docs/batches/02-specifier-l-existant/README.md

**Sections:** The init command, Document layout

## Global Constraints

Contraintes du lot, recopiées mot pour mot depuis `docs/batches/02-specifier-l-existant/README.md` :

- **Ordre requis.** La tranche `Verification` est transcrite **en dernier**,
  après que toutes les autres tranches de ce lot ont été fusionnées sur `main`.
  Chacune des autres livre des gardes structurelles, donc chacune creuse l'écart
  entre la liste normative et ce que `tests/` vérifie réellement — l'écart même
  que cette tranche résorbe. Écrite plus tôt, sa liste serait périmée avant
  d'être fusionnée. Les autres tranches n'ont aucun ordre entre elles.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`,
  dans la même pull request qu'elle. Un contrat que rien ne vérifie redérivera
  comme il a dérivé.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la
  compte pas. Les sections de la spec vivante sont titrées et non numérotées,
  délibérément, et la garde livrée par le lot 01 le vérifie.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit
  la spec, la constatation part sous `Observed drift` dans le document de story ;
  elle ne se règle pas par une correction discrète du code ni de la spec.
- **Deux décisions sont déjà tranchées par l'humain au gate d'ouverture** et ne
  se rediscutent pas en cours d'implémentation : la **lecture stricte** du nom
  de branche, et la **non-survie** de `docs/specs/` et `docs/batches/` à un
  clone. Les appliquer, ne pas les rouvrir.
- **Ne toucher à aucune entrée non réservée** du gaps register. Les trois
  entrées laissées disponibles ci-dessus appartiennent à d'autres lots.

**Gel du fichier de spec :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête.

Le commit de transcription est `b8a8bb7` : il est déjà passé. `docs/specs/supercharlouze.md` est **gelé** pour toute la durée de ce plan.

**Règle d'autorité :**

> Quand le batch et la spec se contredisent, **la spec gagne — sans exception et sans délibération**. Implémente ce que dit la spec, inscris un `Ruling:`, et poursuis. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

**Ne modifie pas `scripts/init.sh`.** Les deux comportements gardés ici existent déjà et sont corrects. Si tu découvres qu'un des deux est en réalité absent du script, **arrête-toi et signale-le** : ce serait une violation, pas un gap, et elle ne se corrige pas dans une story qui n'a réservé aucune entrée de *Violations*.

---

### Task 1: Garder les deux sûretés non gardées de l'init

**Files:**
- Modify: `tests/test-init.sh` — deux blocs ajoutés avant la dernière ligne, `exit $((FAILURES > 0))`

**Interfaces:**
- Consumes: `$INIT`, `$TEST_ROOT`, `pass`, `fail` — tous définis en tête de `tests/test-init.sh`. Chaque cas monte son propre projet jetable sous `$TEST_ROOT` ; suis le style des cas existants.
- Produces: rien qu'une autre tâche consomme. Cette story n'a qu'une tâche.

- [ ] **Step 1: Ajouter les deux blocs**

Insérer immédiatement avant la dernière ligne du fichier (`exit $((FAILURES > 0))`) :

```bash
# --- Case 15: what the plugin does not own is neither moved nor removed ---
# The spec says docs/superpowers is dropped once emptied, and *only* once
# emptied. Case 11 covers the first half; nothing covered the second.
P14="$TEST_ROOT/foreign"
mkdir -p "$P14/docs/superpowers/specs" "$P14/docs/superpowers/notes"
touch "$P14/docs/superpowers/specs/moved.md"
printf 'KEEP\n' > "$P14/docs/superpowers/notes/keep.md"
bash "$INIT" "$P14" >/dev/null
if [ -f "$P14/docs/archive/specs/moved.md" ]; then
    pass "foreign: the plugin's own documents still migrate"
else
    fail "foreign: the plugin's own documents still migrate"
fi
if [ -f "$P14/docs/superpowers/notes/keep.md" ] \
   && grep -q "KEEP" "$P14/docs/superpowers/notes/keep.md"; then
    pass "foreign: a document the plugin does not own is left untouched"
else
    fail "foreign: a document the plugin does not own is left untouched"
fi
if [ -d "$P14/docs/superpowers" ]; then
    pass "foreign: docs/superpowers survives while it still holds something"
else
    fail "foreign: docs/superpowers survives while it still holds something"
fi

# --- Case 16: the CLAUDE.md file mode survives the rewrite ---
# Structural, not behavioural, and the reason belongs here rather than in a
# commit message: the rewrite goes through a temp file, which is born 0600, so
# the target's mode has to be restored explicitly. A filesystem that reports
# 644 for every file whatever chmod is asked of it cannot tell a restored mode
# from a lost one — a behavioural assertion would compare 644 to 644 and pass
# whether or not the call is there, which is the test that verifies nothing.
# Asserting the call is what such a filesystem can still check.
if grep -q 'chmod --reference' "$INIT"; then
    pass "init restores the CLAUDE.md mode after the temp-file swap"
else
    fail "init restores the CLAUDE.md mode after the temp-file swap"
fi
```

- [ ] **Step 2: Lancer le test — les quatre assertions doivent PASSER**

Run: `bash tests/test-init.sh`
Expected: les quatre nouvelles lignes en `[PASS]`, aucune `[FAIL]`.

Ce sont des tests de caractérisation : `scripts/init.sh` fait déjà ces deux choses, le défaut était que la spec ne les décrivait pas et que rien ne les tenait. Il n'y a donc pas de phase rouge par absence, et la preuve se fait par mutation aux étapes suivantes.

**Si l'une des trois premières échoue**, ne la « répare » pas : cela voudrait dire que le script ne préserve pas ce qui ne lui appartient pas, ce qui est une **violation** de la spec et non un gap. Arrête-toi et signale BLOCKED.

- [ ] **Step 3: Prouver que la première garde mord**

```bash
sed -i 's|rmdir "$PROJECT/docs/superpowers" 2>/dev/null \|\| true|rm -rf "$PROJECT/docs/superpowers"|' scripts/init.sh
grep -n 'rm -rf "$PROJECT/docs/superpowers"' scripts/init.sh
bash tests/test-init.sh
```

Expected: la substitution est confirmée par le `grep`, puis **deux** `[FAIL]` —
`foreign: a document the plugin does not own is left untouched` et
`foreign: docs/superpowers survives while it still holds something`.

C'est la mutation qui compte : elle simule exactement la simplification qu'un lecteur pressé ferait, `rmdir` qui échoue silencieusement remplacé par un `rm -rf` qui « marche toujours ».

- [ ] **Step 4: Revenir et re-vérifier**

```bash
git checkout -- scripts/init.sh
bash tests/test-init.sh
```

Expected: tout en `[PASS]`.

- [ ] **Step 5: Prouver que la seconde garde mord**

```bash
sed -i '/chmod --reference/d' scripts/init.sh
bash tests/test-init.sh
```

Expected: `[FAIL] init restores the CLAUDE.md mode after the temp-file swap`.

- [ ] **Step 6: Revenir et vérifier la suite complète**

```bash
git checkout -- scripts/init.sh
bash tests/run-all.sh
```

Expected: `all tests passed`. Vérifie aussi que `git status --short` ne montre que `tests/test-init.sh` — les deux mutations doivent être annulées.

- [ ] **Step 7: Commit**

```bash
git add tests/test-init.sh
git commit -m "test: garder les deux sûretés non gardées de l'init"
```

---

## Rulings log

## Observed drift
