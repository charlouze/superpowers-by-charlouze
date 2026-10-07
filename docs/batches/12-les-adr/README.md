---
status: closed
---

# 12 — Les ADR

## Scope

Ce lot donne au flux les ADR : une décision technique que le code à venir du projet
doit tenir est consignée, avec sa raison, dans `docs/adr/`.

Une décision technique n'est consignée en ADR que si elle réunit trois conditions,
et que l'humain le décide. Une story ou un changement borné lui soumet celle qu'il
prend et qui les réunit.

Un ADR est écrit, réécrit ou supprimé à l'ouverture d'un lot, par un amendement ou
dans un changement borné. La revue de livraison d'une story peut en faire écrire
un.

Le code d'une story ou d'un changement borné tient les ADR que `main` porte quand
sa branche en part. Aucun ADR ne s'impose au code déjà sur `main`.

Une story s'arrête devant un ADR qu'elle ne peut pas tenir.

Le plan d'une story suit un ADR là où il contredit la conception technique de son
lot.

La relecture technique relit contre les ADR les blocs, la conception technique et
les contraintes d'un lot, et relit les ADR écrits ou réécrits avec lui.

Les contraintes d'un lot ne lient que ses stories.

La clôture ne réécrit plus `Technical design`.

L'installation soumet à l'humain les ADR qu'un projet porte déjà.

Ce lot prend en charge cette entrée du gaps register de `supercharlouze` : sous
*Gaps*, `The spec document / The gaps register`, sur la décision d'ingénierie qui
vaut pour tout le projet et que le test de l'autre implémentation laisse sans
sortie.

## Spec delta

Tous les blocs visent `docs/specs/supercharlouze.md`.

### D1 — `The model`

```diff
 **Conception technique** (`technical design`) — le mécanisme prévu pour les
 stories d'un lot, dont chacune peut s'écarter.
+
+**ADR** (`adr`) — le document qui consigne une décision technique du projet.
 
 **Flag** (`feature flag`) — ce qui garde un comportement incomplet hors de portée
 des utilisateurs jusqu'à sa levée.
```

### D2 — `Architecture decision records`

Une section nouvelle, qui suit `Feature flags > Lifting a feature flag` et précède
`Bounded change` :

```markdown
## Architecture decision records

Un ADR vit dans `docs/adr/<slug>.md`.

Il énonce une décision et sa raison.

Un ADR que le flux écrit ou réécrit ne porte ni date ni statut.

Une décision technique n'est consignée en ADR que si elle réunit ces conditions :

- la défaire coûte cher ;
- elle surprend qui n'en connaît pas le contexte ;
- elle tranche entre de vraies alternatives.

Un agent n'écrit, ne réécrit ni ne supprime un ADR sans que l'humain l'ait décidé.

Ce qui s'observe à la frontière d'un module est une règle de sa spec, jamais un
ADR.

Un ADR ne contredit aucune spec ni aucun autre ADR.

Un ADR dont la décision est remplacée est réécrit sur place.

Un ADR dont la décision est abandonnée est supprimé.

Le commit qui réécrit ou supprime un ADR dit pourquoi.
```

### D3 — `Bounded change`

```diff
 Il peut ajouter et supprimer des entrées du gaps register.
+
+Il peut écrire, réécrire et supprimer des ADR.
+
+Il peut ne porter que des ADR.
```

### D4 — `Boundary`

```diff
 produit, les conventions qu'il laisse dans le dépôt, ce qu'il exige du code
-applicatif tant qu'un flag le garde, et son installation sur un projet.
+applicatif qu'un flag garde ou qui doit tenir un ADR, et son installation sur un
+projet.
```

### D5 — `Architecture decision records`

```diff
 Le commit qui réécrit ou supprime un ADR dit pourquoi.
+
+Le code d'une story ou d'un changement borné tient les ADR que `main` porte quand
+sa branche en part.
+
+Aucun ADR ne s'impose au code déjà sur `main`.
+
+Quand une story s'arrête sur un ADR qu'elle ne peut pas tenir, l'humain juge
+l'ADR. S'il le juge intenable, la story est abandonnée et un changement borné
+réécrit ou supprime l'ADR ; sinon, la story reprend en le tenant.
```

### D6 — `Departures from superpowers`

```diff
-  Dans une story dont le lot déclare des contraintes seulement :
+  Dans une story seulement si son lot déclare des contraintes ou si `main` porte
+  un ADR quand sa branche en part :
 
-  > Si, en conduisant une story, tu découvres qu'une contrainte de son lot ne peut
-  > pas être tenue, arrête-toi et soumets-la à l'humain.
+  > Si, en conduisant une story, tu découvres qu'une contrainte de son lot ou un
+  > ADR ne peut pas être tenu, arrête-toi et soumets-le à l'humain.
```

### D7 — `Authority and conflict rules`

```diff
-| Livraison | le code d'une story, et sa modification de spec s'il y en a une | la story est livrée |
+| Livraison | le code d'une story, sa modification de spec s'il y en a une, et les ADR que la revue fait écrire | la story est livrée |
```

### D8 — `Batch > Amending a batch`

```diff
-Quand la condition d'arrêt sur une contrainte qui ne peut pas être tenue se
-déclenche, l'humain juge la contrainte. S'il la juge intenable, la story est
-abandonnée et un amendement modifie ou retire la contrainte ; sinon, la story
-reprend en la tenant.
+Quand une story s'arrête sur une contrainte qu'elle ne peut pas tenir, l'humain
+juge la contrainte. S'il la juge intenable, la story est abandonnée et un
+amendement modifie ou retire la contrainte ; sinon, la story reprend en la tenant.
```

### D9 — `Story > The user story document`

```diff
 7. dans une story technique seulement, sa condition d'arrêt
    (`Departures from superpowers`) ;
-8. dans une story dont le lot déclare des contraintes seulement, la condition
-   d'arrêt sur une contrainte qui ne peut pas être tenue
-   (`Departures from superpowers`).
+8. seulement si le lot déclare des contraintes ou si `main` porte un ADR quand la
+   branche de la story en part, la condition d'arrêt sur une contrainte ou un ADR
+   qui ne peut pas être tenu (`Departures from superpowers`) ;
+9. seulement si `main` porte un ADR quand la branche de la story en part,
+   l'obligation de tenir ces ADR (`Architecture decision records`) ;
+10. les conditions auxquelles une décision technique est consignée en ADR
+    (`Architecture decision records`), et l'obligation de soumettre comme
+    arbitrage ouvert la décision qui les réunit (`Delivering a story`).
```

### D10 — `Story > Delivering a story`

```diff
-   Le plan part de la conception technique du lot. Exception : là où le code de
-   `main` s'en est écarté, il part du code.
+   Le plan part de la conception technique du lot. Exceptions : là où un ADR la
+   contredit, il suit l'ADR ; ailleurs, là où le code de `main` s'en est écarté,
+   il part du code.
```

### D11 — `Story > Delivering a story`

```diff
 Tout autre arbitrage ouvert est tranché à la revue de livraison, et le
 `Rulings log` porte ce qui a été tranché.
+
+Une story soumet comme arbitrage ouvert la décision technique qu'elle prend et qui
+réunit les conditions auxquelles elle serait consignée en ADR
+(`Architecture decision records`). Si l'humain la veut en ADR, la story l'écrit
+en réponse à la revue.
```

### D12 — `Bounded change`

```diff
 Il peut ne porter que des ADR.
+
+Quand un changement borné ne peut pas tenir un ADR, il le soumet à l'humain. Si
+l'humain juge l'ADR intenable, le changement borné le réécrit ou le supprime ;
+sinon, il le tient.
+
+Un changement borné soumet à l'humain la décision technique qu'il prend et qui
+réunit les conditions auxquelles elle serait consignée en ADR
+(`Architecture decision records`). Si l'humain la veut en ADR, il l'écrit.
```

### D13 — `Authority and conflict rules`

```diff
 | Adoption | la spec et le gaps register du module | le module est adopté |
-| Ouverture | le document de lot | le lot est ouvert |
+| Ouverture | le document de lot, et les ADR écrits, réécrits ou supprimés avec lui | le lot est ouvert |
```

### D14 — `Batch > The batch document`

```diff
 - **Feature flag** — les flags que ce lot déclare, chacun avec son nom, son défaut,
   sa portée et, si elle dépasse le lot, sa condition de levée ; ou `none` suivi de
   la raison de l'exemption.
+
+Les contraintes d'un lot ne lient que ses stories.
 
 Chaque bloc porte un identifiant unique dans le lot, et nomme la spec et la section
 qu'il vise.
```

### D15 — `Batch > The technical reread`

```diff
-La relecture technique relit la conception technique et les contraintes d'un lot,
-contre les specs, blocs appliqués, et contre le code de `main`.
+La relecture technique relit :
+
+- la conception technique et les contraintes du lot, contre les specs, blocs
+  appliqués, et contre le code de `main` ;
+- les blocs, la conception technique et les contraintes du lot, contre les ADR
+  tels que la pull request d'ouverture ou d'amendement les laisse ;
+- chaque ADR que cette pull request écrit ou réécrit, contre les specs, blocs
+  appliqués, et contre les autres ADR.
 
-Un lot qui n'a ni conception technique ni contraintes s'en passe.
+Une ouverture s'en passe quand le lot n'a ni conception technique ni contraintes,
+et que sa pull request ne laisse aucun ADR dans `docs/adr/`.
 
 Elle n'est jamais conduite dans le contexte qui a écrit ce qu'elle relit.
```

### D16 — `Batch > Opening a batch`

```diff
 2. attribue `NN` ;
-3. rédige le document de lot ;
+3. rédige le document de lot, puis écrit, réécrit ou supprime des ADR s'il y a
+   lieu ;
 4. réserve les entrées du gaps register que le lot prend en charge ;
 5. fait passer le spec delta par la relecture de cohérence ;
-6. fait passer la conception technique et les contraintes du lot par la
-   relecture technique ;
+6. fait passer le lot par la relecture technique ;
 7. relit le document de lot en entier ;
```

### D17 — `Authority and conflict rules`

```diff
-| Amendement | la décision de changer le périmètre, le spec delta, la conception technique, les contraintes ou le flag d'un lot | le lot est amendé |
+| Amendement | la décision de changer le périmètre, le spec delta, la conception technique, les contraintes ou le flag d'un lot, et les ADR écrits, réécrits ou supprimés avec elle | le lot est amendé |
 | Clôture | la consolidation et `status: closed` | le lot est clos |
```

### D18 — `Batch > Amending a batch`

```diff
 Un amendement change le périmètre, le spec delta, la conception technique, les
 contraintes ou le flag d'un lot ouvert, par une pull request sur son document.
+
+La pull request d'un amendement peut aussi écrire, réécrire ou supprimer des ADR.
 
 Exception à la revue d'amendement : un amendement qui change le spec delta est revu
 comme une ouverture.
```

### D19 — `Batch > Amending a batch`

```diff
-Un amendement qui change le spec delta, la conception technique ou les contraintes
-d'un lot passe par la relecture technique.
+Un amendement qui change le spec delta, la conception technique ou les contraintes
+d'un lot, ou qui écrit ou réécrit un ADR, passe par la relecture technique.
```

### D20 — `Batch > Closing a batch`

```diff
 - le retrait du document de lot des blocs qu'aucune story fusionnée n'a livrés.
   L'humain décide si chacun rejoint le gaps register ;
-- la conception technique du document de lot, quand elle n'est pas `none`,
-  réécrite pour décrire le mécanisme que le lot a livré ;
 - le statut `closed` du document de lot.
```

### D21 — `Installing on a project`

```diff
 4. liste les modules déjà adoptés, c'est-à-dire ceux dont une spec existe dans
-   `docs/specs/`.
+   `docs/specs/` ;
+5. soumet à l'humain les ADR que `docs/adr/` porte déjà, et supprime ceux qu'il
+   abandonne.
```

## Technical design

Ce lot n'écrit aucun ADR.

### What an ADR is on disk

Un ADR est un fichier `.md` placé directement dans `docs/adr/`. Toutes les skills,
le script d'installation et les tests emploient cette définition, et aucune autre.

### Who decides, who writes

La décision de consigner un ADR se prend dans la conversation, sans fichier : à la
conception d'un lot ou d'un changement borné, à l'amendement d'un lot, à la revue
de livraison d'une story, ou quand un changement borné bute sur un ADR.

L'écriture vient ensuite, sur la branche du travail, par
`supercharlouze:recording-a-decision`, qui confronte la décision aux specs et aux
autres ADR.

La suppression d'un ADR, et la correction de son texte qui ne change pas sa
décision, ne repassent pas par cette skill. La skill qui conduit le travail les
fait, sur une décision de l'humain.

Une correction qui change la décision est une réécriture, et repasse par la skill.

### The conditions

Le texte anglais de référence des conditions d'un ADR vit dans `## The Model` de
`skills/using-batches/SKILL.md`.

Les `Global Constraints` de `writing-a-user-story` le recopient mot pour mot, sous
garde. Aucune autre skill ne le recopie.

### `skills/recording-a-decision/`

Une skill neuve, interne : `user-invocable: false`, et sa description s'ouvre par
`Use only when a skill tells you to invoke recording-a-decision`.

Elle écrit un ADR que l'humain a décidé, ou réécrit sur place celui dont il a
remplacé la décision.

Son entrée : la décision et sa raison ; le chemin de l'ADR à réécrire, s'il y en a
un ; et, à l'ouverture ou à l'amendement d'un lot, les copies des specs avec les
blocs appliqués. Sa sortie : le chemin du fichier écrit, ou ce que l'humain a
tranché quand rien n'est écrit.

L'agent qui l'invoque suit sa procédure sur la branche où il travaille :

1. lire `docs/adr/` et toutes les specs de `docs/specs/`, dans les copies reçues
   quand il y en a ;
2. quand la décision contredit une spec ou un autre ADR, ou s'observe à la
   frontière d'un module, le dire à l'humain et ne rien écrire tant qu'il n'a pas
   tranché ;
3. écrire le fichier selon
   `skills/recording-a-decision/references/adr-template.md`, en créant `docs/adr/`
   au besoin.

Le gabarit : un titre, puis une à trois phrases qui disent la décision et sa
raison ; deux sections optionnelles, `Considered options` et `Consequences` ; ni
date ni statut.

Elle dit l'ossature anglaise de ses documents, et renvoie à `Concision` dans
`supercharlouze:using-batches`. Elle ne nomme ni `writing-a-batch` ni
`writing-a-user-story`.

Elle ne commite pas. Elle dit à l'agent que le commit d'une réécriture dit
pourquoi.

### `skills/using-batches/SKILL.md`

- `## The Model` définit l'ADR, porte ses conditions, et dit que le code d'une
  story ou d'un changement borné tient les ADR que `main` porte quand sa branche
  en part, et qu'aucun ADR ne s'impose au code déjà sur `main`.
- La table de routage gagne une ligne : l'humain veut écrire, réécrire ou
  supprimer un ADR hors de l'ouverture ou de l'amendement d'un lot, ce qui mène au
  changement borné.
- `## What a Spec Says` : la phrase qui envoie au gaps register ce dont rien
  d'observable ne dépend, le paragraphe sur la règle logée hors des specs, le
  paragraphe `Scope` qui envoie au gaps register tout ce que le test éjecte, et la
  ligne de `## Red Flags` sur la règle qui vaudrait pour tous les modules, disent
  qu'une décision technique sans règle observable à la frontière d'un module a
  l'ADR pour sortie.
- `## The Git Model` : la table des revues suit `D7`, `D13` et `D17`. Le commit
  qui réécrit ou supprime un ADR dit pourquoi.
- `## What Is Kept, What Is Rerouted` :
  - les phrases qui disent la cérémonie du changement borné inchangée et les
    étapes 1 à 5 de la conception architecturale intactes gagnent une exception :
    sur ces chemins, la conception lit `docs/adr/` avant de proposer une approche,
    et soumet à l'humain la décision qui réunit les conditions ;
  - les règles du changement borné cessent d'être comptées, et gagnent celles de
    `D3` et de `D12` ;
  - une fois sa branche créée, le changement borné relit `docs/adr/`, tient ce
    qu'il y trouve, et soumet à l'humain la décision qu'il prend en cours de route
    et qui réunit les conditions ;
  - il invoque `supercharlouze:recording-a-decision` pour écrire ou réécrire un
    ADR, et supprime lui-même celui que l'humain abandonne.
- L'override 2 étend aux ADR sa phrase d'introduction, le texte anglais de
  référence de la condition d'arrêt, le paragraphe sur l'arbitrage qui ne remplace
  aucune condition, sa justification et le paragraphe sur ce qui suit l'arrêt, qui
  porte l'issue de `D5`.

### `skills/writing-a-batch/SKILL.md`

- `## Opening, in Order` : après avoir rédigé le document de lot, l'ouverture
  construit les copies des specs avec les blocs appliqués, puis invoque
  `supercharlouze:recording-a-decision` pour chaque ADR que l'humain a décidé
  d'écrire ou de réécrire pendant le brainstorming, et supprime ceux qu'il a
  abandonnés.
- `## The Batch Document` dit que les contraintes d'un lot ne lient que ses
  stories.
- `## Opening, in Order`, le paragraphe qui distingue les relectures et
  `## The Technical Reread` : l'ouverture invoque toujours la relecture technique,
  qui dit elle-même quand elle n'a rien à relire. L'invocation passe aussi
  `docs/adr/`, `docs/specs/` et les chemins des ADR que la pull request écrit ou
  réécrit.
- `## The Technical Reread` : un constat sur un bloc que l'humain fait corriger
  renvoie l'ouverture à l'étape 5, comme un comportement repris au spec delta. Un
  constat sur un ADR que l'humain fait corriger repasse
  par `supercharlouze:recording-a-decision` quand il change sa décision, puis par
  la relecture technique.
- Le corps de la pull request d'ouverture et celui d'un amendement énoncent, parmi
  ce que l'humain tranche, chaque ADR écrit, réécrit ou supprimé.
- `## Amending a Batch` : un amendement écrit, réécrit ou supprime des ADR comme
  l'ouverture, et passe par la relecture technique quand il en écrit ou en réécrit
  un. Un changement qui ne touche que des ADR passe par un changement borné.

### `skills/writing-a-user-story/SKILL.md`

- `## Step 4 — Write the Plan` : le plan lit `docs/adr/` dans le worktree de la
  story, et suit un ADR là où il contredit `Technical design`. Le déclencheur de
  la condition d'arrêt devient un lot qui déclare des contraintes ou un
  `docs/adr/` qui porte un ADR.
- `Global Constraints` gagne, sans numéroter ses éléments : la condition d'arrêt
  étendue, recopiée mot pour mot ; les chemins
  des ADR que le code de la story tient ; les conditions d'un ADR, avec
  l'obligation de consigner comme `Open ruling:` la décision qui les réunit.
- `## Step 5 — Execute` : le paragraphe sur la condition d'arrêt couvre l'issue de
  `D5`. Aucune tâche n'écrit dans `docs/adr/`.
- `## Step 6 — Record Before the Merge` : un plan qui suit un ADR contre
  `Technical design` ne consigne pas de `Technical design ruling:`.
- `## Step 7 — Answer the Review` : quand l'humain veut l'ADR, la story invoque
  `supercharlouze:recording-a-decision`, et le commite à part. Quand rien n'est
  écrit, le `Rulings log` porte ce que l'humain a tranché. Une correction du
  texte demandée ensuite, qui ne change pas la décision, est un `fixup!` de ce
  commit.
- `## Red Flags` : la ligne sur la contrainte dont dépend une autre story couvre
  l'ADR, et la ligne sur l'écart non consigné ne dit plus que la conception du lot
  décrirait un mécanisme que personne n'a construit.

### `skills/rereading-a-technical-design/`

- La description, `## Overview` et `## Input and Output` : la relecture porte aussi
  sur les blocs du lot et sur les ADR que la pull request écrit ou réécrit.
  L'entrée gagne `docs/adr/`, `docs/specs/` pour les specs que le lot ne touche
  pas, et les chemins de ces ADR. La sortie gagne les constats sur un ADR, et les
  blocs que l'humain a repris au spec delta.
- `## The Readings` gagne deux lectures, chacune avec son lecteur et son objet
  nommé :
  - les blocs, la conception technique et les contraintes tiennent-ils les ADR ?
  - chaque ADR que la pull request écrit ou réécrit contredit-il une spec, blocs
    appliqués, ou un autre ADR, et porte-t-il une règle observable à la frontière
    d'un module ?
- La phrase qui donne toutes les lectures à tout lot est remplacée par une règle :
  une lecture est lancée quand son objet existe. La phrase qui la suit, sur le
  premier tour, reste. Les lectures existantes gardent
  pour objet la conception, que le cadre du prompt définit. La skill rend « rien à
  relire » quand aucune lecture n'est lancée.
- `## Findings and Rounds` : un constat sur un bloc est soumis à l'humain, qui le
  laisse ou reprend le lot à son spec delta, ce qui arrête la relecture. Un
  constat sur un ADR lui est soumis et rendu tel quel. La skill ne révise ni bloc
  ni ADR. La copie de l'état qu'un tour a lu porte aussi les ADR relus.
- `references/reader-prompt.md` : le cadre est réécrit autour de ce que la lecture
  nomme, à la place de la conception seule : ses phrases sur ce que le lecteur
  évalue, sur ce dont il ne rapporte rien et sur ce qu'il ne révise pas. Il gagne
  l'emplacement de `docs/adr/`, celui de `docs/specs/` et les chemins des ADR à
  relire, et dit quoi écrire dans un emplacement que la lecture n'emploie pas. Le
  paragraphe sur l'état que le tour précédent a lu nomme aussi ces ADR.
- La skill ne nomme toujours aucune skill du plugin.

### `skills/closing-a-batch/SKILL.md`

Le devoir `Rewrite the technical design` est retiré, avec ce qui le reflète : la
description de la skill, `## Overview`, `## Preconditions` et les lignes de
`## Red Flags`.

### `scripts/init.sh` and `commands/init.md`

Le script liste les ADR de `docs/adr/` sous un titre, et écrit `(none)` sous ce
titre quand le répertoire n'en porte aucun. Il teste l'existence du répertoire
avant de le lister : l'installation ne le crée pas.

Avant de commiter, la commande soumet à l'humain chaque ADR listé, en lui disant
que le code à venir devra tenir ceux qu'il garde. Elle supprime ceux qu'il
abandonne, dans un commit à part qui dit pourquoi.

### `README.md`

- `### The model` définit l'ADR et nomme `docs/adr/`.
- La table des revues suit `D7`, `D13` et `D17`.
- `### What stays outside a batch` porte les règles du changement borné sur les
  ADR.
- `### The four departures` étend la condition d'arrêt à l'ADR.
- La table des skills gagne `recording-a-decision`, sur le modèle des lignes des
  deux relectures.

### `docs/specs/supercharlouze.gaps.md`

La story qui transcrit `D2` supprime l'entrée que ce lot prend en charge.

### Tests

Chaque norme d'une skill a sa garde dans `tests/`, écrite avant le texte.

La story qui change un texte gardé change sa garde, dont :

- la condition d'arrêt, son déclencheur, ce qui suit l'arrêt et le paragraphe sur
  l'arbitrage, dans `tests/test-skill-contracts.sh` et
  `tests/test-skill-content.sh` ;
- la phrase d'introduction de l'override 2, dans
  `tests/test-declared-overrides.sh` ;
- les deux phrases de `writing-a-user-story` sur le plan qui part du code et sur
  les écarts consignés ;
- le saut, l'invocation et les révisions de la relecture technique dans
  `writing-a-batch`, et la relecture technique d'un amendement ;
- l'entrée, la sortie, le traitement des constats et « Every batch gets every
  reading » dans `rereading-a-technical-design`, et la liste des lectures que
  `writing-a-batch` ne porte pas ;
- le cadre du prompt dans `tests/test-technical-reader-prompt.sh` ;
- le devoir de réécriture et l'ordre des devoirs de `closing-a-batch`, et le
  contrat qui exige `Technical design ruling:` dans cette skill ;
- la ligne d'amendement de la table des revues du `README`.

`recording-a-decision` entre dans :

- `EXPECTED_SKILLS` de `tests/test-skill-frontmatter.sh` et sa boucle des skills
  internes ;
- `KNOWN_SKILLS` de `tests/test-cross-references.sh`, avec un bloc de gardes pour
  sa ligne du `README` sur le modèle de ceux des deux relectures ;
- les deux boucles de `tests/test-skill-content.sh` sur les skills qui écrivent
  un document ;
- chaque liste `absent` de `tests/test-skill-contracts.sh` qui tient
  `writing-a-batch` et `writing-a-user-story`.

Elle n'entre pas dans les listes qui gardent le dispatch des lecteurs et les tours
d'une relecture.

Gardes neuves :

- les conditions d'un ADR mot pour mot dans `using-batches` et dans les
  `Global Constraints` ;
- le gabarit sans date ni statut ;
- `recording-a-decision` ne nomme ni `writing-a-batch` ni `writing-a-user-story` ;
- `closing-a-batch` ne réécrit plus la conception technique ;
- les deux lectures neuves absentes du prompt du lecteur ;
- dans `tests/test-init.sh`, l'installation liste les fichiers `.md` de
  `docs/adr/`, ignore les autres, et écrit `(none)` quand le répertoire est absent
  comme quand il est vide ;
- les lignes d'ouverture et de livraison de la table des revues du `README`, et
  son passage sur la condition d'arrêt ;
- dans `tests/test-command.sh`, la commande soumet à l'humain les ADR listés et
  supprime ceux qu'il abandonne.

## Constraints

`D1`, `D2` et `D3` sont transcrits par la même story, avant tout autre bloc sauf
`D14` et `D20`.

`D4` à `D12` sont transcrits par la même story.

`D13`, `D15` et `D16` sont transcrits par la même story.

`D17`, `D18` et `D19` sont transcrits par la même story, après `D15`.

La story qui transcrit `D2` livre la skill `recording-a-decision`.

Toutes les stories emploient tels quels le répertoire `docs/adr/` et la skill
`recording-a-decision`.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request, et
l'ordre des blocs interdit qu'une règle livrée renvoie à une règle non livrée.
