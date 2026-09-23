---
status: open
---

# 11 — La concision

## Scope

Ce lot rend précis et concis la spec du plugin et les documents qu'il produit :

- une section `Concision` fixe la règle pour tout document du flux, et la relecture
  de cohérence comme les `Global Constraints` d'une story la reprennent ;
- le document de lot ne dit plus pourquoi le lot a lieu maintenant, et un bloc
  montre ce qu'il change dans le paragraphe qui le contient ;
- les specs n'ont plus de table `Changelog` ;
- la spec du plugin est réécrite selon cette règle, et ses règles regroupées là où
  elles vivent. Aucun autre comportement ne change ;
- les skills reprennent ce que la spec perd : la méthode, les raisons qui aident à
  trancher, et des exemples ; le `CLAUDE.md` du dépôt porte la manière d'écrire une
  skill ;
- cinq entrées du gaps register, réservées ici, sont résolues par la réécriture :
  l'une des entrées `Installing on a project`, `Code under a feature flag`,
  `Language`, `The user story document` et `The model / The batch document`.

## Spec delta

Tous les blocs visent `docs/specs/supercharlouze.md`. Un bloc qui réécrit une
section remplace son texte propre, sans ses sous-sections.

### D1 — `Boundary`

Réécrit toute la section :

````markdown
## Boundary

Ce module couvre une extension de superpowers qui définit un flux de
développement : une spec vivante par module, des lots de stories qui font grandir
ces specs, des revues humaines tenues en pull request, les documents que ce flux
produit, les conventions qu'il laisse dans le dépôt, ce qu'il exige du code
applicatif tant qu'un flag le garde, et son installation sur un projet.

Il ne couvre ni superpowers lui-même, ni l'outil qui exécute les agents.

Le plugin entier constitue un seul module.
````

### D2 — `Purpose`

Retire la section entière.

### D3 — `The model`

Réécrit toute la section :

````markdown
## The model

Chaque concept porte un seul terme, lié ici au nom anglais qu'il porte dans les
chemins, les branches et l'ossature des documents. Aucun synonyme n'est employé.

**Module** (`module`) — un domaine fonctionnel grossier, vu de l'extérieur.

**Spec** (`spec`) — le document vivant d'un module, qui dit ce que son code doit
faire.

**Section** (`section`) — la plus petite unité titrée d'une spec, et l'unité sur
laquelle se jugent les conflits de concurrence et que désigne une entrée du gaps
register.

**Gaps register** (`gaps register`) — le document vivant qui consigne, pour un
module, ce que sa spec ne tient pas : les violations de son code et les gaps
qu'elle ne décrit pas.

**Dérive** (`drift`) — toute contradiction entre la spec de `main` et le code de
`main`.

**Lot** (`batch`) — l'unité de livraison : un ensemble de stories qui vise un ou
plusieurs modules.

**Lot correctif** (`corrective batch`) — un lot qui remet du code en conformité
avec une spec déjà vraie. Son spec delta ne porte aucun bloc.

**Bloc** (`delta block`) — l'unité du spec delta d'un lot : une section visée et
le texte exact qu'elle doit recevoir.

**Story** (`user story`) — le plan d'implémentation d'une part d'un lot, qui vise un
seul module et se livre en une pull request.

**Story technique** (`technical story`) — une story qui ne change rien d'observable
à la frontière de son module.

**Flag** (`feature flag`) — ce qui garde un comportement incomplet hors de portée
des utilisateurs jusqu'à sa levée.

**Mention de flag** (`gating sentence`) — la ligne par laquelle une spec déclare
qu'un comportement est gardé par un flag.

**Revue** (`gate`) — l'examen par l'humain d'une pull request, dont la fusion fait
avancer un module, un lot ou une story. La vérification d'un travail par un agent
est une relecture, pas une revue.

**Arbitrage** (`ruling`) — une décision prise par un agent sans l'humain, consignée
pour lui.

**Arbitrage ouvert** (`open ruling`) — un arbitrage dont la décision laisse quelque
chose à trancher.

**Pull request** (`pull request`) — un changement proposé pour `main`, que l'humain
revoit avant qu'il l'atteigne.

**Changement borné** (`bounded`) — un changement complet en une pull request, hors
de tout lot.

**Exploration** (`spike`) — un travail qui produit une réponse et aucun artefact.

**Conception architecturale** (`architectural`) — un travail qui demande une
conception avant d'être découpé en stories.
````

### D4 — `Built on superpowers`

Réécrit toute la section :

````markdown
## Built on superpowers

Termes empruntés à superpowers, qui en est propriétaire, réduits à ce dont le flux
se sert :

- **Brainstorming** (`superpowers:brainstorming`) — le dialogue qui précède tout
  travail. Il classe ce travail en exploration, changement borné ou conception
  architecturale, et, pour une conception architecturale, conduit le contexte, les
  questions, les approches, une conception présentée par sections, puis son
  approbation.
- **Plan** (`superpowers:writing-plans`) — un plan d'implémentation : un en-tête,
  une section `Global Constraints` qui s'impose à chacune de ses tâches, puis des
  tâches.
- **Exécution par sous-agents** (`superpowers:subagent-driven-development`) —
  l'exécution d'un plan tâche par tâche, chaque tâche confiée à un agent neuf puis
  relue. Les arbitrages pris en cours de route, de la forme
  `Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>`, sont
  présentés à l'humain en fin d'exécution.
- **Conclusion d'une branche** (`superpowers:finishing-a-development-branch`) — le
  choix de ce que devient une branche terminée : fusion locale, pull request, ou
  branche gardée.
````

### D5 — `Departures from superpowers`

Réécrit toute la section :

````markdown
## Departures from superpowers

Le flux s'écarte de superpowers en quatre points, et en aucun autre. L'emplacement
des documents et ce que le flux ajoute à un plan ne sont pas des écarts.

- Aucun document de conception daté. Une conception architecturale se conclut
  par l'ouverture d'un lot : le document de lot remplace le document de conception,
  sa relecture avant ouverture en remplace l'auto-relecture, et la revue d'ouverture
  en remplace la revue humaine. Le plan n'est écrit qu'avec chaque story. Une
  conception qui touche un module non adopté s'arrête, et l'humain l'abandonne ou
  la met de côté. Le module est adopté hors du contexte de la conception ; celle-ci
  ne reprend qu'une fois l'adoption fusionnée, dans un nouveau contexte.
- Le flux ajoute des conditions d'arrêt, sur lesquelles l'exécution par
  sous-agents s'arrête aussi. Dans un lot correctif seulement :

  > Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
  > spec qui a tort et le code qui a raison, arrête-toi. Le lot n'est plus
  > correctif et doit être requalifié.

  Dans une story technique seulement :

  > Si, en conduisant une story technique, tu découvres qu'elle change quelque chose
  > d'observable à la frontière du module, arrête-toi. La story n'est plus
  > technique.

  Un arbitrage ne remplace ni l'une ni l'autre.
- Le mode d'exécution est imposé. Une story s'exécute par sous-agents, et le
  choix d'un autre mode n'est pas proposé.
- Une story se conclut par une pull request. La conclusion de sa branche n'offre
  ni la fusion locale, ni la branche gardée.
````

### D6 — `Authority and conflict rules`

Réécrit toute la section :

````markdown
## Authority and conflict rules

Tout ce qui atteint `main` peut partir en production, et rien ne l'atteint sans
pull request.

Toute branche du flux part de `main` tel que le remote le porte, et se fusionne dans
`main`. Sauf celle d'un amendement, elle porte le nom que son étape lui assigne
avant que le travail commence.

La spec est l'autorité contraignante de toute revue et de toute relecture. Hors son
spec delta, un lot ne porte que ce qu'une spec ne peut pas porter : son périmètre,
ses flags, l'ordre de ses stories et de ses blocs, et ses contraintes de migration
et de compatibilité.

La spec de `main` décrit toujours exactement ce que son code fait. Toute dérive est
du travail correctif.

Quand un lot et une spec se contredisent, la spec gagne : l'agent implémente ce
qu'elle dit, consigne un arbitrage, et poursuit. Seul un humain corrige une spec en
cours de lot.

Après le premier commit de sa branche et jusqu'à l'ouverture de sa pull request,
une story ne modifie plus le fichier de spec. Une story qui découvre que la spec
doit changer s'arrête.

À l'ouverture de la pull request, la revue peut faire modifier la spec.

| Revue | Pull request examinée | Sa fusion |
|---|---|---|
| Adoption | la spec et le gaps register du module | le module est adopté |
| Ouverture | le document de lot | le lot est ouvert |
| Livraison | le code d'une story, et sa modification de spec s'il y en a une | la story est livrée |
| Amendement | la décision de changer le périmètre ou le flag d'un lot | le lot est amendé |
| Clôture | la consolidation et `status: closed` | le lot est clos |

L'agent n'approuve ni ne fusionne jamais une pull request de revue.

Pendant une revue, l'humain voit sur la pull request ce que chaque correction
demandée a changé depuis sa dernière lecture. L'humain donne son
accord dans la conversation ; l'agent annonce alors la pull request prête. Une
correction de revue n'atteint `main` comme commit à part que si elle porte une
décision nouvelle.

La fusion d'une revue est le moment de vider le contexte, et l'agent le dit en
annonçant la pull request prête. Quand une étape suivante existe, il la nomme et
donne le prompt qui la lance dans un contexte vide. Ce prompt nomme la skill à
invoquer et le document d'où repartir, et ne renvoie jamais à la conversation.
````

### D7 — `Module`

Réécrit toute la section :

````markdown
## Module

Un module a une spec et un gaps register, qui naissent ensemble à son adoption.
Aucun lot ne touche un module qui n'est pas adopté.

L'humain délimite les modules. Un agent n'en propose aucun découpage de lui-même.
````

### D8 — `Module > Module adoption`

Réécrit toute la section :

````markdown
### Module adoption

L'adoption produit une pull request portant deux documents et aucun code : la spec
et le gaps register du module.

Ordre d'autorité des sources :

1. Les documents validés sont normatifs sur les intentions qu'ils énoncent, jamais
   sur les mécanismes qu'ils décrivent. Un mécanisme lu dans un document validé
   n'entre pas dans la spec : il devient un gap nommant son document. Hors ce que
   l'humain promeut, eux seuls créent du texte normatif.
2. Le code ne corrige jamais un document. Ce qu'il révèle là où les documents se
   taisent est un gap.
3. L'humain tranche les contradictions.

Une intention ne se déduit pas d'un mécanisme, qu'il soit lu dans le code ou dans
un document validé : elle vient d'un document validé ou de l'humain.

Un chiffre que personne n'a décidé n'est pas une règle, même écrit comme une
garantie.

Étapes :

1. Délimiter le module. L'agent demande son découpage à l'humain, et n'écrit rien
   avant sa décision.
2. Inventorier les documents validés qui le couvrent, et soumettre la liste à
   l'humain avant d'écrire. Le corps de la pull request porte l'inventaire retenu.
3. Créer la branche `adopt/<module>`.
4. Écrire la spec depuis ces seuls documents. Ce qui n'y est pas une règle devient
   un gap nommant son document. Quand deux documents validés se contredisent, le
   plus récent l'emporte par défaut, et cet arbitrage figure dans le corps de la
   pull request.
5. Auditer le code contre la spec, et consigner au gaps register ce que l'audit
   révèle. Le code n'est pas corrigé : résorber une violation revient à un lot.
6. Soumettre à l'humain, un par un, les gaps qui décrivent un comportement
   observable à la frontière du module. Celui qu'il valide comme intention entre
   dans la spec et sort du gaps register. Un mécanisme ne lui est pas soumis.
7. Ouvrir la pull request d'adoption. Sa revue est la seule de l'adoption.

Conclue par la fusion de sa pull request : le module est adopté.

Sans aucun document validé, l'adoption énumère les comportements observables à la
frontière du module, groupés en sections candidates, et demande à l'humain, section
par section, s'ils sont voulus. Ce qu'il valide devient la spec ; le reste part en
gaps. Le corps de la pull request dit qu'aucun document validé n'existait. Un
inventaire partiel suit les étapes 2 à 6 pour sa partie couverte, et ce dialogue
pour le reste.
````

### D9 — `Module > The spec document`

Réécrit toute la section :

````markdown
### The spec document

La spec vit dans `docs/specs/<module>.md`. Elle dit ce que le code doit faire, et ne
porte ni date, ni statut, ni marqueur de travail en cours, hors la mention d'un
flag.

Une spec porte des règles métier, jamais le mécanisme qui les réalise. Une règle
énonce une intention que toute implémentation qui la réalise rend vraie : ce
qu'elle dit s'observe hors du module, que ses mots soient techniques ou métier.

Une décision métier chiffrée s'écrit avec sa valeur.

Une règle vit dans la section du comportement qu'elle contraint. Une règle qui en
contraint plusieurs vit dans une section qui nomme ce qu'elle règle.

Une règle appartient à une seule spec. Une règle qui contraindrait un comportement
observable à la frontière de plus d'un module signale un découpage à revoir :
l'agent s'arrête et soumet le cas à l'humain.

Le glossaire d'une spec définit les concepts du domaine, et eux seuls, avec le nom
que chacun porte dans le code et dans l'interface, quand il en a un. Le code et
l'interface emploient ce nom.

Une spec redéfinit chaque terme qu'elle emprunte à la spec d'un autre module,
réduit à ce qu'elle en utilise, et nomme cette spec. Un terme emprunté n'est pas
une règle partagée.

Tout ce qu'une spec contient est normatif et au même niveau. Seule exception :
l'aparté, qu'un projet admet en déclarant la convention qui le distingue d'une
règle. Un aparté ne porte aucune règle.
````

### D10 — `Module > The gaps register`

Réécrit toute la section :

````markdown
### The gaps register

`docs/specs/<module>.gaps.md` range ses entrées en deux catégories, chacune sous son
propre titre :

- **Violations** — le code contredit la spec. Alimente un lot correctif.
- **Gaps** — ce qu'aucune spec ne décrit. Alimente un lot ordinaire qui le
  spécifie.

Chaque entrée est un élément de liste qui désigne une section de la spec. Une
entrée qui vient d'un document nomme ce document.

Hors sa couverture, le gaps register ne porte que des entrées : ce qui qualifie une
entrée vit dans l'entrée, et aucune prose ne qualifie un groupe d'entrées. Une
entrée ne renvoie à aucune autre entrée.

Une entrée s'ajoute à la fin de sa catégorie. Dans un lot, une seule pull request
ajoute des entrées au gaps register.

Le gaps register ne porte que ce qui reste à régler. Une entrée réglée se supprime
du fichier, et le commit qui la supprime dit pourquoi. Un constat déjà supprimé ne
se réinscrit que si l'entrée dit ce qui a changé depuis.

Une entrée peut être :

- **réservée** — elle porte l'annotation `reserved by batch-NN` du lot qui la prend
  en charge ;
- **supprimée** — sa réservation part avec elle ;
- **libérée** — son annotation de réservation est retirée, et l'entrée reste.

Le gaps register déclare sa couverture : les parties du module auditées, celles qui ne
l'ont pas été, et pourquoi.
````

### D11 — `Batch`

Réécrit toute la section :

````markdown
## Batch

Un lot vit dans `docs/batches/NN-<slug>/`.

Un lot est identifié par `NN`, le plus petit entier

- non utilisé dans `docs/batches/` sur `main`,
- non revendiqué par une pull request ouverte,
- non revendiqué par une branche poussée qui ne porte pas encore de pull request.

Seules les branches `batch/*` et `story/*` revendiquent un numéro :
`batch/NN-<slug>` revendique `NN`, et `story/NN-us-N-<slug>` revendique `NN` et
`us-N`.

Le document de lot ne change que par un amendement (`Amending a batch`) ou à sa
clôture, qui l'amende et le déclare clos. Il ne porte ni la liste de ses stories,
ni leur état : ses stories sont les documents de son répertoire, et les pull
requests ouvertes et branches poussées `story/NN-*` qui n'ont pas encore atteint
`main`.
````

### D12 — `Batch > The batch document`

Réécrit toute la section :

````markdown
### The batch document

Un `README.md` avec un front matter `status: open | closed`, et :

- **Scope** — ce que ce lot livre.
- **Spec delta** — le texte exact que ce lot écrit dans les specs, en blocs. Chaque
  bloc porte un identifiant `D<n>`, unique dans le lot, et nomme la spec et la
  section qu'il vise. Un bloc qui modifie un passage donne le paragraphe qui le
  contient, avec ce qu'il en retire et ce qu'il y ajoute ; un bloc qui ajoute du
  texte le donne avec l'endroit
  où il s'insère ; un bloc qui retire un passage le cite ; un bloc qui réécrit une
  section entière donne son nouveau texte. Aucun bloc n'est
  rattaché à une story. Une section qui change deux fois porte deux blocs, et
  `Constraints` donne leur ordre. Un lot qui lève un flag déclaré par un autre lot
  le fait par un bloc qui retire sa mention. Ce champ n'est jamais vide : il porte
  des blocs ; ou, quand le lot n'en a aucun, les entrées du gaps register qu'il
  réserve, ou `none` suivi de la raison.
- **Constraints** — seulement les contraintes de migration et de compatibilité, et
  l'ordre requis des stories et des blocs ; `none` s'il n'y en a pas.
- **Feature flag** — les flags que ce lot déclare, chacun avec son nom, son défaut
  et sa portée ; ou `none` avec la raison de l'exemption. Ce champ n'est jamais
  vide. Il prend, pour chaque flag, l'une de ces formes :

  ```markdown
  Feature flag: `<flag>`, <on|off> by default — scope: this batch
  Feature flag: `<flag>`, <on|off> by default — scope: beyond this batch, lifted when <condition de levée>
  Feature flag: none — <raison de l'exemption>
  ```
````

### D13 — `Batch > The coherence reread`

Réécrit toute la section :

````markdown
### The coherence reread

La relecture de cohérence lit chaque spec que touchent les blocs d'un spec delta,
en entier, sur l'état que ces blocs produiront. Quand le champ `Spec delta` ne
porte aucun bloc, l'ouverture passe cette étape.

Elle pose quatre questions à chaque spec touchée :

- Qu'est-ce que les blocs rendent faux ailleurs ? Un passage qu'aucun d'eux ne vise
  et qu'ils contredisent.
- Qu'est-ce qu'ils omettent ? Un cas devant lequel ils passent, une conséquence
  qu'ils ne tirent pas.
- Tiennent-ils ce qu'une spec doit tenir (`The spec document`) ?
- Sont-ils précis et concis (`Concision`) ?

Elle n'est jamais conduite dans le contexte qui a écrit les blocs. Le corps de la
pull request d'ouverture le déclare, avec ce qu'elle a trouvé, ou qu'elle n'a rien
trouvé.
````

### D14 — `Batch > Opening a batch`

Réécrit toute la section :

````markdown
### Opening a batch

L'ouverture :

1. vérifie que chaque module touché est adopté, et s'arrête sinon ;
2. attribue `NN` ;
3. rédige le document de lot ;
4. réserve dans le gaps register toute entrée que ce lot prend en charge. Deux lots
   ne réservent jamais la même entrée. Rien n'est écrit dans les specs à
   l'ouverture ;
5. fait passer le spec delta par la relecture de cohérence ;
6. ouvre la pull request du lot, sur la branche `batch/NN-<slug>`.

La revue d'ouverture porte sur le texte exact de chaque bloc. Quand le champ
`Spec delta` ne porte aucun bloc, elle porte sur ce qui en tient lieu : les entrées
réservées, ou la raison du `none`.

Conclue par la fusion de sa pull request : le lot est ouvert.
````

### D15 — `Batch > Amending a batch`

Réécrit toute la section :

````markdown
### Amending a batch

Un amendement change le périmètre ou le flag d'un lot ouvert, par une pull request
sur son document existant.

Sa branche ne suit aucun des patrons de ce flux, et ne revendique ni numéro ni
section.

Requalification d'un lot correctif : quand sa condition d'arrêt se déclenche
(`Departures from superpowers`), la story en cours est abandonnée
(`Abandoning a story`) une fois la requalification tranchée. L'humain tranche :

- soit il corrige la spec, et le lot reste correctif sur un périmètre réduit ;
- soit un amendement réécrit le lot comme lot ordinaire, avec un spec delta, en
  gardant `NN` et son répertoire.

Un `NN` neuf n'est attribué que si l'humain juge le travail restant être un autre
lot ; le lot requalifié est alors clos. Dans tous les cas, les entrées du gaps
register que le lot ne prend plus en charge sont libérées.

Requalification d'une story technique : quand sa condition d'arrêt se déclenche
(`Departures from superpowers`), la story est abandonnée (`Abandoning a story`). Si
l'humain veut le changement observable, un amendement ajoute son bloc. Si ce
changement exige un flag (`Feature flags`), le même amendement le déclare.

Exception à la revue d'amendement : un amendement qui ajoute ou réécrit un spec
delta est revu comme une ouverture.

Conclu par la fusion de sa pull request : le lot est amendé.
````

### D16 — `Batch > Closing a batch`

Réécrit toute la section :

````markdown
### Closing a batch

Quand toutes les stories du lot sont fusionnées ou abandonnées et que l'humain
considère le lot terminé, sa clôture passe par une pull request, sur la branche
`batch/NN-<slug>-close`.

Un lot ne se clôt pas tant qu'un flag de son champ `Feature flag` subsiste, dans le
code ou par sa mention dans une spec, sans que sa portée étendue et sa condition
de levée soient déclarées. Un flag déclaré par un autre lot n'entre pas dans ce
contrôle.

Quand l'humain renonce au périmètre d'un lot dont des stories gardées sont sur
`main`, il choisit : écrire la story de levée et livrer ce qui existe ; déclarer au
flag une portée étendue par un amendement ; ou écrire une story de démontage, qui
retire le code gardé et ce qu'il avait ajouté à la spec.

La pull request de clôture porte :

- la consolidation dans le gaps register de ce que les documents des stories ont
  laissé : leurs sections `Observed drift`, et les arbitrages ouverts que leur
  `Rulings log` classe en violation ou en gap ;
- la libération des réservations non consommées ;
- le constat des blocs non livrés : un bloc qu'aucune story fusionnée ne déclare
  dans son champ `Blocks:` est inscrit au gaps register comme gap, et le document
  de lot est corrigé pour ne plus le promettre ;
- `status: closed` dans le document de lot.

Une entrée réservée et jamais résorbée n'est pas reclassée en gap neuf.

Conclue par la fusion de sa pull request : le lot est clos.
````

### D17 — `Story`

Réécrit toute la section :

````markdown
## Story

Une story appartient à exactement un lot et vise exactement un module, donc une
seule spec. Une story se livre sur une branche, par une pull request. Cette pull
request ne porte jamais sa modification de spec sans le code
qui la réalise.

Une story est identifiée par `us-N` dans son lot, attribué selon la règle qui
identifie un lot (`Batch`).

Les stories d'un lot s'écrivent une par une, et plusieurs peuvent être en vol à la
fois. Chaque story choisit, en s'écrivant, les blocs qu'elle transcrit, et les
transcrit en entier : un bloc n'est jamais partagé entre deux stories.

L'état d'une story est celui de sa pull request.
````

### D18 — `Story > The user story document`

Réécrit toute la section :

````markdown
### The user story document

Un plan, enregistré dans `docs/batches/NN-<slug>/NN-us-N-<slug>.md`, dont le basename
est unique parmi les documents de story du dépôt. Il porte un en-tête étendu :

```markdown
**Spec:** docs/specs/<module>.md
**Batch:** docs/batches/NN-<slug>/README.md
**Sections:** <section> > <sous-section>, <section>
**Blocks:** D<n>, D<n>
**Technical:** yes
```

- `Spec:` désigne la spec du module visé.
- `Sections:` déclare les sections que la story touche, choisies par son auteur et
  jamais déduites d'un diff.
- `Blocks:` déclare les blocs que la story transcrit, ou `none`.
- `Technical: yes` déclare une story technique, dont `Sections:` vaut `none`. Aucune
  autre story ne porte ce champ.

Le document porte aussi un `Rulings log` et une section `Observed drift`, créés
vides avec l'en-tête et complétés s'il y a lieu avant la fusion. Une section restée
vide signifie « examiné, rien trouvé ».

Un arbitrage ouvert s'écrit `Open ruling:`, et sa ligne se termine par ce qui reste
à trancher, puis par la catégorie du gaps register qui l'accueille quand il en
rejoint une.

`Global Constraints` porte :

1. la section `Constraints` du lot, recopiée mot pour mot ;
2. la règle de `Authority and conflict rules` qui gèle le fichier de spec, recopiée
   mot pour mot ;
3. les deux règles de `Authority and conflict rules` qui font gagner la spec sur le
   lot et réservent à l'humain la correction d'une spec, recopiées mot pour mot ;
4. les règles de `Concision`, recopiées mot pour mot ;
5. dans un lot correctif seulement, sa condition d'arrêt
   (`Departures from superpowers`), recopiée mot pour mot ;
6. dans une story qui écrit du code gardé par un flag seulement, les règles de
   `Code under a feature flag`, recopiées mot pour mot, quel que soit le lot qui
   déclare le flag ;
7. dans une story technique seulement, sa condition d'arrêt
   (`Departures from superpowers`), recopiée mot pour mot.
````

### D19 — `Story > Concurrency detection`

Réécrit toute la section :

````markdown
### Concurrency detection

Deux stories, ou une story et un changement borné, qui touchent la même section
d'une même spec sont un conflit. Seules les branches `story/*` et `fix/*`
revendiquent des sections. La détection lit les déclarations de deux sources
distantes :

- les pull requests ouvertes dont la branche est `story/*` ou `fix/*` ;
- les branches `story/*` poussées qui ne portent pas encore de pull request.

Une story déclare dans son document de story ; un changement borné, dans le corps
de sa pull request. Les deux nomment la spec et les sections.

Le travail qui démarre s'arrête si une déclaration porte l'une de ses sections, ou
si une déclaration n'a pas pu être lue. Une branche poussée qui ne porte pas encore
de déclaration l'arrête si elle a déjà modifié la spec qu'il vise.
````

### D20 — `Story > Delivering a story`

Réécrit toute la section :

````markdown
### Delivering a story

Précondition, vérifiée avant de créer la branche : le lot est ouvert — sa pull
request d'ouverture est fusionnée et son document porte `status: open`.

1. Détecter la concurrence.
2. Attribuer `us-N` et créer la branche `story/NN-us-N-<slug>`.
3. Commiter en premier la transcription des blocs de la story, mot pour mot, puis
   pousser la branche. Si le lot déclare un flag pour ce module, la modification de
   spec porte sa mention.

   Tout écart avec un bloc est nommé dans la pull request et tranché à la revue de
   livraison. Un écart n'a que deux causes légitimes : `main` a changé et le
   passage que le bloc vise n'y est plus tel quel, et la story ajuste le bloc sans
   en changer le sens ; ou le texte du bloc pose problème, et l'agent le soumet à l'humain avant
   de le transcrire. Le document de lot n'est pas amendé.

   Une story qui ne transcrit aucun bloc commite en premier l'en-tête de son
   document de story, avec ses sections `Rulings log` et `Observed drift` vides, et
   ce qu'elle retire s'il y a lieu : l'entrée du gaps register qu'elle résorbe, ou
   la modification de spec qu'aucun bloc n'annonce.
4. Écrire le plan dans le document de story, le commiter et le pousser avant
   l'exécution.
5. Exécuter par sous-agents, puis conclure la branche par une pull request.
6. Avant la fusion, recopier les arbitrages de l'exécution dans le `Rulings log`, et
   consigner sous `Observed drift` les dérives constatées hors du périmètre de la
   story.
7. Répondre à la revue sur la branche de la story.

Une story ne fusionne pas avec un arbitrage ouvert sans destination. Celui qui est
une violation ou un gap rejoint le gaps register à la clôture. Tout autre est
tranché à la revue de livraison, et le `Rulings log` porte ce qui a été tranché.

Conclue par la fusion de sa pull request : la story est livrée.
````

### D21 — `Story > Abandoning a story`

Réécrit toute la section :

````markdown
### Abandoning a story

La pull request d'une story abandonnée, s'il y en a une, est fermée sans fusion, et
sa branche est supprimée, sur le remote compris. La clôture constate ce qui en
subsiste sur `main` : la réservation au gaps register, et les blocs jamais livrés.
````

### D22 — `Feature flags`

Réécrit toute la section :

````markdown
## Feature flags

Un lot dont une story, fusionnée seule, laisserait un utilisateur devant quelque
chose d'incomplet déclare un flag, un par module qu'il garde.

Par défaut, un flag ne survit pas à son lot. Un flag qui lui survit déclare sa
portée et la condition qui le lève.

La section de spec qui décrit un comportement gardé porte la mention de son flag :
son nom, son défaut et, si sa portée dépasse le lot, sa condition de levée, sous
l'une de ces formes :

```markdown
🔒 `<flag>`, <on|off> by default
🔒 `<flag>`, <on|off> by default — lifted when <condition de levée>
```

La spec est le seul registre des flags : un flag existe tant que sa mention y
figure.
````

### D23 — `Feature flags > Code under a feature flag`

Réécrit toute la section :

````markdown
### Code under a feature flag

Le code gardé par un flag supporte l'activation pour une partie des utilisateurs,
l'activation pour tous et la désactivation :

- Les deux états cohabitent sur les mêmes données : ce que l'un produit, l'autre le
  lit et s'en sert.
- La désactivation, pour un utilisateur ou pour tous, laisse lisible et utilisable
  ce que l'état activé a produit, sans erreur ni perte de donnée.
- Flag désactivé, l'utilisateur retrouve le comportement d'avant le lot, aux données
  produites sous flag activé près.
- La pull request de la story teste le comportement flag activé, flag désactivé, et
  leur cohabitation.
- Lever le flag se réduit à supprimer le branchement et le comportement d'avant le
  lot, sans rien écrire de neuf.
````

### D24 — `Feature flags > Lifting a feature flag`

Réécrit toute la section :

````markdown
### Lifting a feature flag

La story de levée supprime le branchement dans le code et la mention du flag dans
la spec. Chaque flag a la sienne.

Elle est la dernière story du lot quand le flag est à portée de lot. Quand la portée
est étendue, elle appartient au lot dont le spec delta annonce la levée.

La levée est une story, jamais une part de la clôture. Pour observer le flag activé
avant de le lever, une story antérieure fait passer son défaut déclaré de `off` à
`on`.

Activer ou désactiver un flag est un geste du projet, qui ne change pas le défaut
que la spec déclare. Seule une story change ce défaut.

Conclue par la fusion de sa pull request : le flag est levé.
````

### D25 — `Bounded change`

Réécrit toute la section :

````markdown
## Bounded change

Un changement borné n'a ni lot ni story : c'est une pull request unique, sur une
branche `fix/<slug>`.

- Quand il change quelque chose d'observable à la frontière du module, sa pull
  request met la spec à jour avec le code. Sinon, la spec reste muette.
- Il déclare dans le corps de sa pull request la spec qu'il vise et les sections
  qu'il touche, ou `none`. Il subit la même détection de concurrence qu'une story,
  et la refait si les sections qu'il touche changent avant l'ouverture de sa pull
  request. Entre son premier commit et cette ouverture, rien ne porte sa
  déclaration.
- Il ne porte aucun flag.
- Il ajoute et supprime directement des entrées du gaps register.
````

### D26 — `Installing on a project`

Réécrit toute la section :

````markdown
## Installing on a project

L'installation est idempotente et n'adopte jamais rien. Elle produit une pull
request, sur la branche `chore/supercharlouze-init`, qui :

1. crée `docs/specs/`, `docs/batches/`, `docs/archive/` ;
2. déplace `docs/superpowers/specs/` vers `docs/archive/specs/` et
   `docs/superpowers/plans/` vers `docs/archive/plans/`, en conservant les noms de
   fichiers ;
3. insère dans le fichier d'instructions que l'agent lit au démarrage, en le créant
   s'il n'existe pas, un bloc qui fait entrer toute conception et toute exécution
   de plan dans ce flux ; si le bloc est déjà présent, elle le met à jour sur place,
   sans jamais le dupliquer ;
4. rend l'état des lieux : les modules adoptés, c'est-à-dire ceux dont une spec
   existe dans `docs/specs/`.

Et :

- Si des documents occupent déjà des chemins de destination, l'installation énumère
  tous ces chemins et s'arrête avant tout déplacement.
- Si les marqueurs du bloc sont cassés — une ouverture sans fermeture, une
  fermeture sans ouverture, un marqueur en double, une fermeture avant son
  ouverture —, elle nomme le défaut et s'arrête sans réécrire le fichier.
- Un marqueur est une ligne entière, jamais une sous-chaîne.
- Le mode du fichier d'instructions est préservé.
- L'arborescence `docs/superpowers` est supprimée une fois vidée, et seulement
  alors. Ce qui y subsiste n'est ni déplacé, ni supprimé.
- Un répertoire qu'elle crée n'est sur `main` qu'avec son premier document, et
  aucune décision du flux ne dépend de son existence.
````

### D27 — `Language`

Réécrit toute la section :

````markdown
## Language

L'ossature d'un document est anglaise : titres de sections, noms de champs,
libellés de gabarits, valeurs de front matter (`status: open | closed`), en-têtes
de tableaux, patrons de chemins et de branches, noms de skills et de commandes.

Sa prose est dans la langue du projet, comme les slugs de fichiers et de
répertoires.

Exception : ce que le plugin livre — skills, commandes, scripts, tests, README, bloc
d'instructions, messages — est intégralement anglais.
````

### D28 — `Concision`

Insère cette section après `Language` :

````markdown
## Concision

Ces règles valent pour tout texte que le flux écrit : ses documents, les corps de
ses pull requests et ses messages de commit.

Chaque phrase dit une chose exacte, une seule fois, et se comprend seule.

Une règle dit jusqu'où elle vaut, et une exception se présente comme telle.

Un texte dit ce qu'il livre ou décide, sans raconter comment on y est arrivé. Il ne
donne la raison d'un choix que là où ce flux la demande.

Aucune phrase n'est mise en relief.
````

### D29 — `Changelog`

Retire la section entière.

## Constraints

- `D28` est transcrit au plus tard avec `D13` et avec `D18`.
- `D16` et `D25` sont transcrits au plus tard avec `D29`, et `D29` au plus tard avec
  `D9`.
- `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
  `D26`.
- `D17` est transcrit au plus tard avec `D6`.
- `D6` et `D12` sont transcrits ensemble.

## Feature flag

Feature flag: none — aucune story ne laisse un comportement du flux incomplet.
