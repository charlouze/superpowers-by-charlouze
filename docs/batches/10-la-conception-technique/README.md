---
status: open
---

# 10 — La conception technique

## Scope

Ce lot donne au document de lot un champ `Technical design`, qui porte la
conception technique de ses stories. Le plan d'une story en part, et une story
peut s'en écarter en le consignant comme arbitrage de conception technique.

`Constraints` porte aussi les décisions techniques dont une story ne peut pas
s'écarter sans casser une autre story. Une story qui découvre qu'une contrainte ne
peut pas être tenue s'arrête, et l'humain juge la contrainte : intenable, elle est
corrigée par un amendement ; sinon, la story reprend.

Une relecture technique relit la conception technique et les contraintes à
l'ouverture et à tout amendement qui les touche, hors du contexte qui les a
écrites.

La clôture réécrit `Technical design` pour qu'il décrive le mécanisme livré.

## Spec delta

Tous les blocs visent `docs/specs/supercharlouze.md`.

### D1 — `The model`

```diff
 **Story technique** (`technical story`) — une story qui ne change rien
 d'observable à la frontière de son module.
+
+**Conception technique** (`technical design`) — le mécanisme prévu pour les
+stories d'un lot, dont chacune peut s'écarter.
 
 **Flag** (`feature flag`) — ce qui garde un comportement incomplet hors de portée
 des utilisateurs jusqu'à sa levée.
```

### D2 — `The model`

```diff
 **Arbitrage ouvert** (`open ruling`) — un arbitrage dont la décision laisse
 quelque chose à trancher.
+
+**Arbitrage de conception technique** (`technical design ruling`) — un arbitrage
+par lequel une story s'écarte de la conception technique de son lot.
 
 **Changement borné** (`bounded`) — un changement complet en une pull request, hors
 de tout lot.
```

### D3 — `Departures from superpowers`

```diff
   Dans une story technique seulement :
 
   > Si, en conduisant une story technique, tu découvres qu'elle change quelque
   > chose d'observable à la frontière du module, arrête-toi. La story n'est plus
   > technique.
 
-  Un arbitrage ne remplace ni l'une ni l'autre.
+  Dans une story dont le lot déclare des contraintes seulement :
+
+  > Si, en conduisant une story, tu découvres qu'une contrainte de son lot ne peut
+  > pas être tenue, arrête-toi et soumets-la à l'humain.
+
+  Une contrainte que la spec contredit ne relève pas de cette condition, mais de
+  `Authority and conflict rules`.
+
+  Un arbitrage ne remplace aucune de ces conditions.
```

### D4 — `Authority and conflict rules`

```diff
 La spec est l'autorité contraignante de toute revue et de toute relecture.
 
 Hors son spec delta, un lot ne porte que ce qu'une spec ne peut pas porter : son
-périmètre, ses flags, l'ordre de ses stories et de ses blocs, et ses contraintes de
-migration et de compatibilité.
+périmètre, ses flags, ses contraintes et sa conception technique.
 
 La spec de `main` décrit toujours exactement ce que son code fait.
```

### D5 — `Authority and conflict rules`

```diff
 | Revue | Pull request examinée | Sa fusion |
 |---|---|---|
 | Adoption | la spec et le gaps register du module | le module est adopté |
 | Ouverture | le document de lot | le lot est ouvert |
 | Livraison | le code d'une story, et sa modification de spec s'il y en a une | la story est livrée |
-| Amendement | la décision de changer le périmètre, le spec delta ou le flag d'un lot | le lot est amendé |
+| Amendement | la décision de changer le périmètre, le spec delta, la conception technique, les contraintes ou le flag d'un lot | le lot est amendé |
 | Clôture | la consolidation et `status: closed` | le lot est clos |
```

### D6 — `Batch > The batch document`

```diff
 - **Scope** — ce que ce lot livre, dont les entrées du gaps register qu'il prend en
   charge ;
 - **Spec delta** — le texte exact que ce lot écrit dans les specs, en blocs ; ou
   `none` suivi de sa raison ;
-- **Constraints** — seulement les contraintes de migration et de compatibilité, et
-  l'ordre requis des stories et des blocs ; ou `none` ;
+- **Technical design** — la conception technique du lot ; ou `none` suivi de sa
+  raison ;
+- **Constraints** — seulement les contraintes de migration et de compatibilité,
+  les décisions techniques dont une story ne peut pas s'écarter sans casser une
+  autre story, et l'ordre requis des stories et des blocs ; ou `none` ;
 - **Feature flag** — les flags que ce lot déclare, chacun avec son nom, son défaut,
   sa portée et, si elle dépasse le lot, sa condition de levée ; ou `none` suivi de
   la raison de l'exemption.
```

### D7 — `Batch > The technical reread`

Une section nouvelle, qui suit `Batch > The coherence reread` :

```markdown
### The technical reread

La relecture technique relit la conception technique et les contraintes d'un lot,
contre les specs, blocs appliqués, et contre le code de `main`.

Un lot qui n'a ni conception technique ni contraintes s'en passe.

Elle n'est jamais conduite dans le contexte qui a écrit ce qu'elle relit.

Le corps de la pull request d'ouverture ou d'amendement dit ce qu'elle a trouvé,
ou qu'elle n'a rien trouvé.
```

### D8 — `Batch > Opening a batch`

```diff
 1. vérifie que chaque module touché est adopté, et s'arrête sinon ;
 2. attribue `NN` ;
 3. rédige le document de lot ;
 4. réserve les entrées du gaps register que le lot prend en charge ;
 5. fait passer le spec delta par la relecture de cohérence ;
-6. relit le document de lot en entier ;
-7. ouvre la pull request du lot, sur la branche `batch/NN-<slug>`.
+6. fait passer la conception technique et les contraintes du lot par la
+   relecture technique ;
+7. relit le document de lot en entier ;
+8. ouvre la pull request du lot, sur la branche `batch/NN-<slug>`.
```

### D9 — `Batch > Amending a batch`

```diff
-Un amendement change le périmètre, le spec delta ou le flag d'un lot ouvert, par
-une pull request sur son document.
+Un amendement change le périmètre, le spec delta, la conception technique, les
+contraintes ou le flag d'un lot ouvert, par une pull request sur son document.
```

### D10 — `Batch > Amending a batch`

```diff
 Si l'humain veut le changement observable qu'elle a révélé, un amendement ajoute
 son bloc, et le flag qu'il exige s'il en exige un (`Feature flags`).
+
+Quand la condition d'arrêt sur une contrainte qui ne peut pas être tenue se
+déclenche, l'humain juge la contrainte. S'il la juge intenable, la story est
+abandonnée et un amendement modifie ou retire la contrainte ; sinon, la story
+reprend en la tenant.
+
+Un amendement qui change le spec delta, la conception technique ou les contraintes
+d'un lot passe par la relecture technique.
```

### D11 — `Batch > Closing a batch`

```diff
 - la libération des réservations non consommées ;
 - le retrait du document de lot des blocs qu'aucune story fusionnée n'a livrés.
   L'humain décide si chacun rejoint le gaps register ;
+- la conception technique du document de lot, quand elle n'est pas `none`,
+  réécrite pour décrire le mécanisme que le lot a livré ;
 - le statut `closed` du document de lot.
```

### D12 — `Story > The user story document`

```diff
 5. dans un lot correctif seulement, sa condition d'arrêt
    (`Departures from superpowers`) ;
 6. dans une story qui écrit du code gardé par un flag seulement, les règles de
    `Code under a feature flag`, quel que soit le lot qui déclare le flag ;
 7. dans une story technique seulement, sa condition d'arrêt
-   (`Departures from superpowers`).
+   (`Departures from superpowers`) ;
+8. dans une story dont le lot déclare des contraintes seulement, la condition
+   d'arrêt sur une contrainte qui ne peut pas être tenue
+   (`Departures from superpowers`).
```

### D13 — `Story > Delivering a story`

```diff
 4. Écrire le plan dans le document de story, le commiter et le pousser avant
    l'exécution.
+
+   Le plan part de la conception technique du lot. Exception : là où le code de
+   `main` s'en est écarté, il part du code.
+
+   Tout autre écart du plan à la conception technique est un arbitrage de
+   conception technique, consigné dans le `Rulings log`.
 5. Exécuter le plan par l'exécution par sous-agents de superpowers
    (`Built on superpowers`), puis conclure la branche par une pull request.
```

## Technical design

Ce lot remplit le champ qu'il crée, sans la relecture technique, qu'il crée aussi.

### `skills/writing-a-batch/SKILL.md`

- Le gabarit de `## The Batch Document` place `## Technical design` entre
  `## Spec delta` et `## Constraints` : la conception technique approuvée à
  l'étape de conception du brainstorming, ou `none` et sa raison.
- Le paragraphe sur `Constraints` ajoute les décisions techniques dont une story ne
  peut pas s'écarter sans casser une autre story.
- `## Opening, in Order` ajoute l'étape de la relecture technique après celle de la
  relecture de cohérence, sautée quand le lot n'a ni conception technique ni
  contraintes.
- La relecture du document de lot vérifie `Technical design` rempli et le critère
  d'entrée de `Constraints`.
- Le corps de la pull request énonce `Technical design` et `Constraints` parmi ce
  que l'humain tranche, et dit ce que la relecture technique a trouvé, ou qu'elle
  n'a rien trouvé.
- `## Amending a Batch` couvre la conception technique, les contraintes, la
  contrainte qui ne peut pas être tenue, et la relecture technique d'un amendement
  qui change le spec delta, la conception technique ou les contraintes, déclarée
  dans le corps de sa pull request.

### `skills/rereading-a-technical-design/`

Une skill neuve, sur le modèle de `supercharlouze:rereading-a-spec` :
`user-invocable: false`, invoquée par writing-a-batch, un lecteur par lecture,
tous rendus avant que rien ne remonte, constats instruits puis soumis à
l'humain, mêmes conditions d'arrêt des tours.

Son prompt de lecteur est dans `references/reader-prompt.md`. Le lecteur reçoit
la conception technique, les contraintes, les specs, blocs appliqués, et le code
tel que `origin/main` le porte.

Ses cinq lectures :

1. Couverture : la conception réalise-t-elle ce que les blocs promettent ?
2. Ancrage dans le code : ce qu'elle suppose exister existe-t-il, suit-elle la
   structure en place, touche-t-elle ce qu'elle croit toucher ?
3. Architecture : découpage en unités, frontières, sens des dépendances, avec
   `clean-architecture` si elle est disponible.
4. Conception des modules : profondeur, masquage d'information, fuites,
   complexité, avec `software-design-philosophy` si elle est disponible.
5. Robustesse : gestion d'erreurs, stratégie de test, risques non nommés.

### `skills/writing-a-user-story/SKILL.md`

- `## Step 4 — Write the Plan` : le plan part de `Technical design`, sauf là où
  le code de `main` s'en est écarté, et sa ligne `Architecture:` en dérive.
- Un écart pris en écrivant le plan s'inscrit aussitôt dans le `Rulings log` sous
  la forme `Technical design ruling:`, définie à côté de `Open ruling:`.
- `Global Constraints` gagne un huitième élément, dans une story dont le lot
  déclare des contraintes seulement : la condition d'arrêt sur une contrainte qui
  ne peut pas être tenue, recopiée mot pour mot.
- `## Step 6` recopie sous la forme `Technical design ruling:` les arbitrages de
  l'exécution qui s'écartent de la conception technique.

### `skills/using-batches/SKILL.md`

L'override 2 porte la nouvelle condition d'arrêt dans son texte anglais de
référence. `## The Model` définit les deux termes.

### `skills/closing-a-batch/SKILL.md`

Un devoir après le retrait des blocs non livrés : réécrire `Technical design` pour
décrire le mécanisme livré, à partir des `Technical design ruling:` des stories
fusionnées et de leur code, sans ce qui servait les blocs retirés. Rien à faire
quand le champ vaut `none`. Le devoir dit que le texte réécrit est vrai à la
clôture, et que le code fait foi ensuite.

### `README.md`

Il recommande `clean-architecture` et `software-design-philosophy` à côté de
`domain-driven-design`.

### Tests

Chaque norme d'une skill a sa garde dans `tests/`, écrite avant le texte : la
condition d'arrêt mot pour mot dans using-batches et writing-a-user-story, et le
prompt du lecteur technique sur le modèle de `tests/test-reader-prompt.sh`.

### Names

Toutes les stories emploient tels quels le champ `Technical design`, la forme
`Technical design ruling:`, la section `The technical reread` et la skill
`rereading-a-technical-design`.

## Constraints

`D1` précède `D2`, `D4`, `D5`, `D6`, `D7`, `D8`, `D9`, `D10`, `D11` et `D13`, qui
nomment la conception technique.

`D2` précède `D13`, qui nomme l'arbitrage de conception technique.

`D3` précède `D10` et `D12`, qui renvoient à la condition d'arrêt qu'il écrit.

`D7` précède `D8` et `D10`, qui nomment la relecture technique.

Un lot ouvert avant la transcription de `D6` n'a pas de champ `Technical design` :
sa clôture n'a rien à réécrire, et ses stories n'ont pas de conception dont partir.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request, et
l'ordre des blocs interdit qu'une règle livrée renvoie à une règle non livrée.
