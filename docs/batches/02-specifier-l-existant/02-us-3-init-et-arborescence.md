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

Neuf décisions, recopiées du ledger SDD avant sa suppression. La liste est exhaustive, **y compris la première, que la quatrième renverse** : une décision retirée du dossier ne se distingue plus d'une décision jamais prise.

- **Ruling:** la garde du mode est structurelle et non comportementale — **pourquoi :** j'avais mesuré que ce système de fichiers ne sait pas exprimer les modes, donc qu'une assertion comportementale y passerait vacuement — **coût si c'est faux :** la garde atteste l'appel, jamais qu'il fonctionne. **Renversée ci-dessous : la mesure était fausse.**

- **Ruling:** `scripts/init.sh` n'est pas modifié par cette story, et découvrir qu'un des comportements gardés est absent est un **arrêt**, pas une correction — **pourquoi :** les deux comportements ont été vérifiés présents avant le dispatch ; leur absence signifierait que le code contredit une spec qui les décrit désormais, donc une *Violation*, et cette story n'a réservé que des entrées de *Gaps*. Une violation résorbée dedans serait une correction que personne n'a revue comme telle — **coût si c'est faux :** une story s'arrête sur ce qu'un implémenteur aurait corrigé en une ligne, et il faut un lot correctif pour ça.

- **Ruling:** modèle de milieu de gamme pour les implémenteurs et les revues de tâche, le plus capable pour la revue finale — **pourquoi :** même raisonnement que les deux stories précédentes — **coût si c'est faux :** quelques centimes.

- **Ruling:** la garde du mode devient **comportementale**, et son commentaire est réécrit, parce que **ma prémisse était fausse** — **pourquoi :** j'avais mesuré `chmod` avec 600, 644 et 755, toutes inscriptibles et donc toutes ramenées à 644, et j'en ai conclu que le système de fichiers ne sait pas exprimer les modes. Il suit le **bit d'écriture** : 400, 444 et 555 donnent tous 444. J'ai généralisé depuis un échantillon incapable de discriminer, puis inscrit la conclusion fausse dans le fichier de test comme documentation permanente, dans le plan, au ledger et dans un message à l'humain. La revue finale l'a falsifiée en construisant l'assertion que je déclarais impossible — **coût si c'est faux :** aucun que je voie ; l'assertion comportementale est strictement plus forte.

- **Ruling:** le minor différé sur l'ancrage du `grep` est résolu **par le passage au comportemental**, pas en resserrant le motif — **pourquoi :** ancrer l'ordre des arguments fermerait un trou et en laisserait deux, un `chmod` sans `--reference` et toute casse de l'échange autour de l'appel. L'assertion comportementale ferme les trois et cesse de lire le source — **coût si c'est faux :** elle dépend de `stat`, d'où le repli BSD.

- **Ruling:** l'*Important 2* est une **sous-livraison de mon plan** et se corrige ici — **pourquoi :** mon plan affirmait que les quatre formes de marqueurs cassés étaient déjà gardées tout en n'en nommant que trois ; la quatrième, une fermeture sans ouverture, n'avait aucune fixture. La revue l'a prouvé par mutation : le refus remplacé par un no-op laisse la suite à 33 PASS / 0 FAIL. La contrainte du lot exige une garde dans la même pull request que la norme, et cette story a recopié cette contrainte dans ses propres `Global Constraints` — **coût si c'est faux :** une fixture de plus que nécessaire.

- **Ruling:** l'*Important 3* part au gate humain et n'est **pas** corrigé ici — **pourquoi :** il est faux dans le fichier de spec, gelé depuis la transcription, et corriger une spec est un acte humain. Ta décision du gate — l'arborescence ne survit pas à un clone — n'est pas en cause ; seule ma formulation l'est — **coût si c'est faux :** la phrase part en production telle quelle pour une story de plus.

- **Ruling:** les minors 1, 2 et 4 vont sous `Observed drift` plutôt que dans la vague de correction — **pourquoi :** les deux premiers sont des divergences entre la spec et le code sur un fichier gelé, le troisième est du bruit — **coût si c'est faux :** deux divergences réelles attendent un lot ultérieur.

- **Ruling:** la réserve de la revue sur mon usage de `Verification` est **acceptée et consignée pour la story suivante** — **pourquoi :** j'ai invoqué « contrôles structurels uniquement » pour légitimer un `grep` sur du texte source, alors que les cinq contrôles que cette section énumère incluent un contrôle comportemental. « Structurel » y oppose *automatisé et bon marché* à *jugement sur la prose*, pas *assertion sur le source* à *assertion sur le comportement*. La dernière story du lot transcrit précisément cette section — **coût si c'est faux :** elle écrit une section `Verification` plus étroite que la spec ne l'entend.

## Observed drift

Cinq constats **hors du périmètre de cette story**. Les quatre premiers sont des divergences entre la spec et le code ou entre la spec et le dépôt ; le cinquième vise la story suivante.

- **`Document layout` — la clause que cette tranche a écrite est fausse dans ce dépôt même.** Elle affirme que `docs/specs/` et `docs/batches/` « ne sont donc pas sur `main` ». `git ls-tree -r main` les y trouve tous les deux, et le fichier qui porte la phrase est l'un d'eux. La prémisse est vraie — ils restent vides jusqu'à leur premier usage — mais la conclusion est énoncée au présent absolu. Reformulation tenable : « **tant qu'ils sont vides**, ils ne sont pas sur `main` ».

  **Second membre de la même phrase, également falsifiable :** « rien dans ce système ne lit ces répertoires avant qu'un document y soit écrit ». `writing-a-batch` prescrit `ls docs/batches/` pour attribuer `NN`, exécuté exactement quand le répertoire peut être absent — premier lot après un clone frais — et `writing-a-user-story` fait de même sur le répertoire du lot. L'impact pratique est faible, un `ls` qui échoue laissant déduire `NN=1`, mais la phrase est présentée comme une garantie. Formulation tenable : « aucune **décision** de ce système ne dépend de leur existence ».

- **`The init command` — « le mode du fichier est préservé » promet plus que le code n'offre.** `chmod --reference` est une extension GNU ; le `chmod` BSD ne la connaît pas. L'erreur est avalée par `2>/dev/null || true`, et `CLAUDE.md` repart alors en `0600` sans un mot. La spec promet une préservation, le code offre un best-effort silencieux. Soit la spec dit « best-effort », soit le script gagne un repli.

- **`The init command` — « ni déplacé, ni supprimé » n'est vrai qu'en dehors de `specs/` et `plans/`.** Le balayage `find "$from" -depth -type d -exec rmdir {} +` supprime un répertoire étranger **vide** placé sous `docs/superpowers/specs/`, et un fichier étranger déposé là est déplacé vers `docs/archive/specs/`. La clause ne tient qu'au-dessus de ces deux sous-répertoires — ce que la fixture ajoutée respecte, puisqu'elle place son document sous `notes/`. La garde ne mord donc jamais dans la zone ambiguë. Borner la phrase suffirait.

- **`The init command` — « fichier laissé intact » est vrai au sens qui compte, faux au sens strict.** `touch "$CLAUDE_MD"` s'exécute avant les comptages de marqueurs, donc sur un chemin de refus le contenu est bien intact mais la `mtime` a changé. Signalé pour mémoire.

- **`Verification` — la section est en train d'être mélue, et la story suivante en hérite.** J'ai invoqué « contrôles structurels uniquement » pour justifier une assertion portant sur du texte source plutôt que sur un comportement. Les cinq contrôles que la section énumère incluent « le bloc `CLAUDE.md` s'insère proprement », qui est comportemental : « structurel » y oppose *automatisé et bon marché* à *jugement humain sur la prose*. La tranche `Verification` est la dernière de ce lot ; si elle transcrit ma lecture, elle rétrécit la section sans que personne ne l'ait décidé.
