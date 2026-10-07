---
status: open
---

# 13 — Le redécoupage des skills

## Scope

Ce lot redécoupe les skills du plugin : une skill par moment où on l'invoque, un
socle que toute skill d'entrée charge, et une skill interne pour chaque texte de
plus d'une ou deux phrases que plusieurs skills partagent.

Il livre les skills que `Technical design` énumère, par extraction des skills
existantes, et renomme `writing-a-batch` en `opening-a-batch` et
`writing-a-user-story` en `delivering-a-story`.

Il change la spec en ces points :

- l'abandon d'une story technique attend la décision de l'humain ;
- l'étape que demande la décision prise sur une story abandonnée après un arrêt
  se lance dans un contexte vide ;
- un changement borné porte la correction d'une spec que l'humain juge fausse ;
- un travail qui va toucher une section de plus refait la détection de
  concurrence ;
- le plan d'une story nomme les règles d'exécution qui valent pour elle, et ne les
  recopie plus.

Il prend en charge ces entrées de `docs/specs/supercharlouze.gaps.md` :

- la violation sur `The gaps register` : un amendement qui ajoute une entrée à
  `Scope` ne la réserve pas ;
- le gap sur `Amending a batch` : la spec fait abandonner une story technique dès
  l'arrêt ;
- le gap sur `Code under a feature flag` et `The user story document` : des
  reformulations partielles des règles du code gardé circulent sans rien qui les
  rattache à leur texte.

Il ne réécrit pas les autres entrées du gaps register, qui citent les skills par
leur ancien nom.

## Spec delta

### D1 — `docs/specs/supercharlouze.md`, `Batch > Amending a batch`

```diff
-Quand la condition d'arrêt d'une story technique se déclenche, la story est
-abandonnée.
+Quand la condition d'arrêt d'une story technique se déclenche, la story est
+abandonnée une fois que l'humain a tranché si le changement observable qu'elle a
+révélé est voulu.
 
 Si l'humain veut le changement observable qu'elle a révélé, un amendement ajoute
 son bloc, et le flag qu'il exige s'il en exige un (`Feature flags`).
```

### D2 — `docs/specs/supercharlouze.md`, `Batch > Amending a batch`

```diff
 Quand la condition d'arrêt d'un lot correctif se déclenche, l'humain tranche :
 
-- soit il corrige la spec, et le lot reste correctif sur un périmètre réduit ;
+- soit il décide de corriger la spec : un changement borné porte cette
+  correction (`Bounded change`), et un amendement réduit le périmètre du lot,
+  qui reste correctif ;
 - soit un amendement réécrit le lot comme lot ordinaire, en gardant `NN` et son
   répertoire ;
```

### D3 — `docs/specs/supercharlouze.md`, `Bounded change`

```diff
 Quand il change quelque chose d'observable à la frontière du module, sa pull
 request met la spec à jour avec le code. Sinon, la spec reste muette.
+
+Exception : quand l'humain juge qu'une spec a tort et que le code a raison, un
+changement borné porte la correction de spec que l'humain décide, sans toucher
+au code.
```

### D4 — `docs/specs/supercharlouze.md`, `Authority and conflict rules`

```diff
 Quand l'humain annonce une fusion et qu'une étape suivante existe, l'agent la nomme
 et donne le prompt qui la lance dans un contexte vide.
 
-Ce prompt nomme la skill à invoquer et le document d'où repartir, et ne renvoie
-jamais à la conversation.
+Quand une story arrêtée par une condition d'arrêt (`Departures from superpowers`)
+est abandonnée et que la décision de l'humain demande une étape suivante, l'agent
+la nomme et donne le prompt qui la lance dans un contexte vide, et ce prompt
+énonce cette décision.
+
+Chacun de ces prompts nomme la skill à invoquer et le document d'où repartir, et
+ne renvoie jamais à la conversation.
```

### D5 — `docs/specs/supercharlouze.md`, `Story > Concurrency detection`

```diff
 Il s'arrête aussi si une déclaration n'a pas pu être lue.
+
+Un travail qui, avant l'ouverture de sa pull request, va toucher une section pour
+laquelle il n'a pas fait la détection la fait, et s'arrête si cette section est
+revendiquée ou si une déclaration n'a pas pu être lue.
```

### D6 — `docs/specs/supercharlouze.md`, `Story > The user story document`

```diff
 `Global Constraints` porte :
 
 1. la section `Constraints` du lot, recopiée mot pour mot ;
-2. le gel du fichier de spec ;
-3. la primauté de la spec sur le lot, et la correction d'une spec réservée à
-   l'humain ;
-4. les règles de `Concision` ;
-5. dans un lot correctif seulement, sa condition d'arrêt
-   (`Departures from superpowers`) ;
-6. dans une story qui écrit du code gardé par un flag seulement, les règles de
-   `Code under a feature flag`, quel que soit le lot qui déclare le flag ;
-7. dans une story technique seulement, sa condition d'arrêt
-   (`Departures from superpowers`) ;
-8. seulement si le lot déclare des contraintes ou si `main` porte un ADR quand la
-   branche de la story en part, la condition d'arrêt sur une contrainte ou un ADR
-   qui ne peut pas être tenu (`Departures from superpowers`) ;
-9. seulement si `main` porte un ADR quand la branche de la story en part,
-   l'obligation de tenir ces ADR (`Architecture decision records`) ;
-10. les conditions auxquelles une décision technique est consignée en ADR
-    (`Architecture decision records`), et l'obligation de soumettre comme
-    arbitrage ouvert la décision qui les réunit (`Delivering a story`).
+2. le nom des règles d'exécution qui valent pour la story (`Execution rules`),
+   sans les recopier ;
+3. le chemin de chaque ADR que `main` porte à la création de la branche de la
+   story, ou `none`.
```

### D7 — `docs/specs/supercharlouze.md`, `Story > Execution rules`

Section neuve, après `The user story document`.

```diff
+### Execution rules
+
+Celui qui exécute ou relit une tâche du plan d'une story suit les règles
+d'exécution :
+
+- le gel du fichier de spec ;
+- la primauté de la spec sur le lot, et la correction d'une spec réservée à
+  l'humain ;
+- les règles de `Concision` ;
+- dans un lot correctif, sa condition d'arrêt (`Departures from superpowers`) ;
+- dans une story qui écrit du code gardé par un flag, les règles de
+  `Code under a feature flag` ;
+- dans une story technique, sa condition d'arrêt
+  (`Departures from superpowers`) ;
+- si le lot déclare des contraintes ou si `main` porte un ADR, la condition
+  d'arrêt sur une contrainte ou un ADR qui ne peut pas être tenu
+  (`Departures from superpowers`) ;
+- si `main` porte un ADR, l'obligation de tenir ces ADR
+  (`Architecture decision records`) ;
+- les conditions auxquelles une décision technique est consignée en ADR
+  (`Architecture decision records`), et l'obligation de soumettre comme
+  arbitrage ouvert la décision qui les réunit (`Delivering a story`).
+
 ### Concurrency detection
```

### D8 — `docs/specs/supercharlouze.md`, `The model`

```diff
 **Story technique** (`technical story`) — une story qui ne change rien
 d'observable à la frontière de son module.
+
+**Règles d'exécution** (`execution rules`) — les règles à suivre par celui qui
+exécute ou relit une tâche d'un plan.
```

## Technical design

Il existe trois types de skill :

- une skill d'entrée, déclenchée par une situation ;
- une skill interne, invoquée seulement par une autre skill ;
- le socle, invoqué par une skill ou par un plan.

Une ref appartient à une seule skill.

Une skill qui en invoque une autre lui passe ce qui varie d'un appelant à
l'autre.

Les stories d'extraction et de renommage sont techniques.

Une extraction reprend le comportement que `main` porte. Ce qu'un bloc change, ou
ce que résorbe l'entrée du gaps register prise en charge, n'entre dans une skill
qu'avec la story qui transcrit ce bloc ou résorbe cette entrée.

Un renommage est un commit à lui.

### Le socle

`following-the-rules` porte ce qui vaut en permanence : le modèle, le modèle git,
l'autorité, la langue, la concision, la conversation et les règles d'exécution.

Elle n'est pas `user-invocable`, et sa description demande de l'invoquer quand une
skill ou un plan le demande.

Elle donne un nom à chaque règle d'exécution, que `Global Constraints` cite pour
dire lesquelles valent pour la story.

Elle ne nomme aucune skill, ni du plugin ni de superpowers. Sa story reformule
les passages qui en nomment une aujourd'hui : « l'exécution par sous-agents » et
« un plan » y remplacent les noms des skills de superpowers.

Elle porte la forme de la mention de flag, et la forme d'un prompt qui lance une
étape dans un contexte vide.

Toute skill d'entrée commence par l'invoquer si la session ne l'a pas fait.

Celui qui exécute ou relit une tâche d'un plan l'invoque avant de commencer : la
ligne de `Global Constraints` qui nomme les règles d'exécution le lui demande.

Elle porte en entier les règles du code gardé par un flag, que
`writing-a-user-story` porte aujourd'hui : ce sont des règles d'exécution, et
celui qui exécute une tâche charge le socle, pas la skill de story.

Une définition ou une règle d'une ou deux phrases qu'une skill recopie aujourd'hui
du socle devient un renvoi au socle, dans la story qui extrait ou réécrit cette
skill.

### Skills d'entrée

- `using-batches` route le travail. Elle porte la table de routage, ce qui est
  gardé ou dérouté de `superpowers:brainstorming`, la lecture de `docs/adr/` par
  la conception, et une ligne par override, qui le déclare et dit où il est écrit
  en entier. Elle porte en entier celui qui remplace les étapes 6 à 9 de
  `superpowers:brainstorming`.
- `adopting-a-module` et `closing-a-batch` gardent leur rôle, et invoquent les
  skills internes à la place de leurs copies.
- `opening-a-batch` conduit l'ouverture : préconditions, attribution de `NN`,
  ordre des étapes, écriture des ADR, corps de la pull request.
- `amending-a-batch` conduit l'amendement : ce qu'il change, sa branche, l'écriture
  des ADR, les relectures qu'il doit selon ce qu'il change, la réservation et la
  libération des entrées du gaps register.
- `opening-a-batch` et `amending-a-batch` invoquent `applying-a-spec-delta` avant
  d'écrire ou de réécrire un ADR, et passent les copies qu'elle rend à
  `recording-a-decision`.
- `handling-a-stopped-story` conduit ce qui suit le déclenchement d'une condition
  d'arrêt : la story reste en l'état, l'humain tranche entre les options de cette
  condition, puis la story est abandonnée ou reprend. Quand elle est abandonnée et
  que la décision demande une suite, elle demande de vider le contexte et donne le
  prompt qui énonce cette décision et les étapes qu'elle demande, dans leur ordre,
  chacune avec la skill à invoquer et le document d'où elle repart.
- `delivering-a-story` conduit le cycle d'une story. Elle porte en entier les
  overrides du mode d'exécution imposé et de la sortie par pull request. Elle invoque
  `detecting-concurrency` avant d'attribuer `us-N`, et de nouveau quand la story va
  toucher une section de plus. Avec la story qui transcrit D6, D7 et D8, elle
  porte en ref le gabarit de `Global Constraints`, dont le chemin des ADR vaut
  `none` quand `main` n'en porte aucun.
- `making-a-bounded-change` porte les règles du changement borné. Elle invoque
  `detecting-concurrency` avant de créer sa branche, et de nouveau quand le
  changement va toucher une section de plus.

### Skills internes

- `rereading-a-spec`, `rereading-a-technical-design` et `recording-a-decision`
  existent et gardent leur rôle. Les deux relectures invoquent
  `running-reread-rounds` à la place de leur copie du déroulé des tours.
- `running-reread-rounds` porte le déroulé des tours d'une relecture : attendre
  tous les lecteurs, instruire les constats, retoucher, ce qu'un tour suivant
  relit, le registre des problèmes, la limite des tours. Elle porte ce que fait
  qui conduit la relecture ; les `reader-prompt.md` gardent ce qu'un lecteur
  reçoit et la façon de composer son envoi.
- `starting-a-branch` reçoit le nom de la branche. Elle fetch, crée l'espace de
  travail, et restaure le nom et le point de départ `origin/main`.
- `detecting-concurrency` reçoit la spec, les sections et, quand elle existe, la
  branche du travail, qu'elle écarte de sa lecture. Elle fetch, et rend les
  conflits ou les déclarations illisibles.
- `writing-in-a-gaps-register` porte la forme du gaps register, les règles d'une
  entrée et les gestes : ajouter, supprimer, réserver, libérer.
- `writing-in-a-spec` porte ce qu'une spec contient.
- `abandoning-a-story` ferme la pull request, supprime la branche et retire
  l'espace de travail.
- `finishing-a-pr` reçoit les conditions que l'appelant pose à l'annonce et, quand
  il y en a une, l'étape suivante avec son document. Elle conduit la fin d'une
  revue : une correction en `fixup!` ou en commit à elle quand elle porte une
  décision nouvelle, l'accord dans la conversation, la vérification de ces
  conditions, qui renvoie à la revue quand l'une ne tient pas, le squash,
  l'annonce, puis, à l'annonce de la fusion, la demande de vider le contexte et le
  prompt de l'étape suivante quand il y en a une.
- `writing-a-batch-document` porte la forme du document de lot et de ses champs.
- `applying-a-spec-delta` reçoit le document de lot et les blocs à appliquer. Elle
  construit hors du dépôt la copie de chaque spec, blocs appliqués, ce qui vérifie
  chaque bloc, et rend le chemin de ces copies.
- `rereading-a-batch` reçoit le document de lot, les blocs à appliquer, les
  relectures dues et les ADR que la pull request écrit ou réécrit. Elle conduit
  les relectures dues, dans l'ordre cohérence, technique, document, avec leurs
  retours de l'une à l'autre. Elle invoque `applying-a-spec-delta` avant la
  première relecture, et de nouveau quand une relecture a retouché un bloc.

### Refs

- L'attribution de `NN` devient une ref de `opening-a-batch`, celle de `us-N` une
  ref de `delivering-a-story`. Chacune fetch avant de lire le remote.
- Les `reader-prompt.md` des deux relectures restent où ils sont, et chaque
  lecture reste écrite en entier dans sa skill : un lecteur ne charge aucune skill
  du plugin.
- La consigne du sous-agent qui relit le document de lot devient une ref de
  `rereading-a-batch`.

### Tests

- Un fichier de données de `tests/`, qui n'est pas un script, déclare chaque skill
  et son type : entrée, interne ou socle. Tous les tests le lisent, à la place de
  `EXPECTED_SKILLS` et de `KNOWN_SKILLS`.
- Le répertoire `skills/` porte exactement les skills déclarées.
- Une skill déclarée interne porte `user-invocable: false` et la description
  d'une skill interne, et aucune autre skill ne porte cette description.
- Une garde négative qui vaut pour toutes les skills parcourt la liste déclarée.
- Les gardes de contenu lisent aussi les `references/` d'une skill.
- L'outil de lecture lit en entier un fichier de `references/`, qui n'a pas de
  front matter.
- Une ref n'est citée que par la skill qui la porte.
- `following-the-rules` ne cite aucune skill, ni `supercharlouze:` ni
  `superpowers:`.
- `following-the-rules` porte `user-invocable: false`, une description qui
  demande de l'invoquer quand une skill ou un plan le demande, et pas
  `disable-model-invocation`.
- Toute skill d'entrée invoque `following-the-rules`.
- Le gabarit de `Global Constraints` permet de citer chaque nom de règle
  d'exécution que `following-the-rules` donne, et aucun autre.
- Le gabarit de `Global Constraints` demande d'invoquer `following-the-rules`.
- Une extraction emporte toutes les gardes qui tenaient le texte extrait, dans
  quelque fichier de `tests/` qu'elles vivent. Elle remplace les contrats `shared`
  qui exigeaient des copies par une garde sur la skill qui porte le texte et une
  garde sur chaque skill qui l'invoque.
- Un renommage ajoute une garde qui interdit l'ancien nom dans les skills, les
  commandes et le `README`.

Chaque story met à jour ce qui cite un nom de skill qu'elle change : le tableau
des skills du `README`, les tests et les autres skills.

Une extraction réécrit toutes les skills qui portaient une copie du texte
extrait.

La suite ne teste ni qu'un agent, en session, invoque une skill interne puis
revient à l'étape suivante de celle qui l'a invoquée, ni qu'un sous-agent qui
exécute ou relit une tâche charge le socle. `CONTRIBUTING.md` ajoute les deux à ce
que la suite ne teste pas.

## Constraints

Les skills portent les noms que `Technical design` leur donne.

`using-batches` garde son nom, que le bloc d'instructions des projets installés
cite.

La story qui renomme une skill redonne, avec le nouveau nom, le prompt en attente
qui nomme l'ancien.

Une skill interne porte `user-invocable: false` et une description de la forme
« Use only when a skill tells you to invoke <nom>, never on … ».

Une skill interne nomme les skills qu'elle invoque, jamais celles qui
l'invoquent.

Un texte de plus d'une ou deux phrases que plusieurs skills partagent vit dans une
skill interne, jamais dans une ref.

Une story fusionnée laisse chaque référence `supercharlouze:<nom>` résolue et la
suite de tests verte.

Jusqu'à la story qui transcrit D6, D7 et D8, `Global Constraints` recopie ses
textes, et les contrats `shared` qui les tiennent identiques suivent ces textes
dans les skills qui les portent.

Chaque skill extraite l'est par une story à elle.

Les stories se livrent une à la fois, dans cet ordre, libre entre les skills d'un
même rang que « puis » ne sépare pas :

1. l'outillage des tests ;
2. `following-the-rules` ;
3. `writing-in-a-spec`, `writing-in-a-gaps-register`, `detecting-concurrency`,
   `abandoning-a-story`, `applying-a-spec-delta` et `running-reread-rounds` ;
4. `starting-a-branch`, puis `finishing-a-pr` ;
5. `writing-a-batch-document`, puis `rereading-a-batch` ;
6. `amending-a-batch`, dont la story renomme `writing-a-batch` en
   `opening-a-batch` ;
7. `handling-a-stopped-story`, `making-a-bounded-change`, puis le renommage de
   `writing-a-user-story` en `delivering-a-story`.

La story qui résorbe la violation sur `The gaps register` suit l'extraction de
`amending-a-batch`.

La story qui extrait `following-the-rules` résorbe le gap sur `Code under a
feature flag` et `The user story document`.

D1 et D4 sont transcrits par une même story, qui suit l'extraction de
`handling-a-stopped-story`.

D2 et D3 sont transcrits par une même story, qui suit l'extraction de
`making-a-bounded-change`.

D6, D7 et D8 sont transcrits par une même story, qui suit le renommage en
`delivering-a-story`.

La story qui transcrit D5 suit ce renommage.

## Feature flag

Feature flag: none — aucune story fusionnée seule ne laisse un utilisateur devant quelque chose d'incomplet : une extraction ou un renommage ne change rien que la spec décrive, la story qui résorbe la violation rétablit ce que la spec promet déjà, et chaque story qui transcrit un bloc livre sa règle en entier
