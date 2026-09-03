# supercharlouze — Design

**Goal:** un plugin Claude Code qui surcharge l'organisation des specs et des
plans de superpowers. Il remplace les documents de conception datés et jetables
par une spécification vivante par module fonctionnel, et remplace les plans
isolés par des *batches* de user stories qui font grandir ces specs.

**Status:** conception validée le 2026-09-03, révisée après deux relectures
adversariales. Rien n'est encore implémenté.

**Plugin name:** `supercharlouze` (namespace de tous les skills). Dépôt :
`superpowers-by-charlouze`.

**Target harness:** Claude Code uniquement.

---

## 1. Problem

superpowers écrit un document de conception daté par fonctionnalité
(`docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`) et un plan par
fonctionnalité (`docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`). Les
deux sont des instantanés d'une intention à un moment donné, et aucun n'est
jamais repris.

Rien ne capitalise. Au bout de dix fonctionnalités, le comportement d'un module
est éparpillé dans dix documents qui décrivent chacun un delta et dont aucun ne
décrit l'état courant. Aucun artefact ne répond à la question « que fait le
module facturation aujourd'hui ? » — et par conséquent aucun artefact ne peut
révéler que le code a dérivé de ce qui avait été validé.

## 2. Model

**Module** — un domaine fonctionnel grossier, vu de l'extérieur. Les modules
sont délimités par l'humain, jamais déduits par un agent. Préférer peu de gros
modules à beaucoup de petits : un projet à trois modules est normal, un projet
à quinze est une erreur de découpage. Ce plugin entier constitue un seul
module.

**Spec** — un document vivant par module, dans `docs/specs/<module>.md`. Elle
est **normative** (ce que le code doit faire), pas descriptive (ce que le code
fait par accident). Elle ne porte pas de date. Elle est l'autorité contraignante
de toutes les revues.

**Section** — la plus petite unité titrée d'une spec. C'est l'unité de tout ce
qui se compte dans ce système : un marqueur porte sur une section, un conflit de
concurrence se juge sur une section, une entrée de gaps register désigne une
section. Le mot « exigence » n'est pas employé comme unité, faute de pouvoir en
définir la granularité.

**Batch** (« lot ») — l'unité de livraison, dans `docs/batches/NN-<slug>/`. Un
batch regroupe plusieurs user stories. Sa raison d'être est d'ajouter des
fonctionnalités à une ou plusieurs specs. Un batch peut être transverse à
plusieurs modules.

**User story** — un plan d'implémentation, dans
`docs/batches/NN-<slug>/NN-us-N-<slug>.md`. Une user story appartient à
exactement un batch et vise exactement **un** module, donc une seule spec. C'est
aussi l'unité d'intégration : une branche, une story (§5.1).

**Corrective batch** — un batch dont le spec delta est vide. Son but est de
remettre le code existant en conformité avec une spec déjà vraie. Son périmètre
est puisé dans le gaps register d'un module.

## 3. Authority and conflict rules

La spec est l'autorité contraignante. Le batch ne porte que ce qu'une spec ne
peut pas porter : le périmètre de livraison, l'ordre des user stories, les
contraintes de migration et de compatibilité, et la raison pour laquelle ce
travail a lieu maintenant.

**Quand un batch et une spec se contredisent, la spec gagne — sans exception et
sans délibération.** L'agent implémente ce que dit la spec, inscrit un
`Ruling:`, et poursuit. **Corriger une spec en cours de batch est un acte
humain, jamais un acte d'agent.** Un agent qui « corrige » la spec pour la
faire coïncider avec le batch inverse silencieusement l'autorité : c'est alors
l'intention du batch qui gagne, et la seule règle qui rende ce système
vérifiable disparaît.

**Tout conflit est consigné pour l'humain.** On réutilise le mécanisme existant
plutôt que d'en inventer un : `superpowers:subagent-driven-development` tient un
ledger dont les décisions prennent la forme
`Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>`, et les
présente à l'humain sous le titre « Rulings I made » avant de supprimer son
workspace. **La source à rapatrier est ce message final, pas le fichier
ledger** : à l'instant où `closing-a-user-story` s'exécute, le workspace et son
`progress.md` n'existent plus. Un implémenteur qui irait lire le ledger lirait
un fichier supprimé.

**Concurrence.** Deux batches ouverts peuvent toucher la même spec ; les
marqueurs nomment leur user story, donc aucune confusion possible. Deux user
stories marquant **la même section** est une condition d'arrêt et d'escalade ;
ça ne se résout pas tout seul. La détection a lieu dans `writing-a-user-story`,
et dans le chemin bounded (§8.2), avant toute écriture dans la spec — et elle
n'est fiable que parce que tous les marqueurs vivent sur la branche
d'intégration (§5.1).

## 4. Artifact layout

```
docs/
  specs/
    facturation.md                spec vivante, une par module, non datée
    facturation.gaps.md           gaps register du module
  batches/
    07-facturation-recurrente/
      README.md                   le batch
      07-us-1-abonnement.md       une user story = un plan superpowers
      07-us-2-relance.md
  archive/
    specs/                        anciens docs/superpowers/specs/
    plans/                        anciens docs/superpowers/plans/
```

Les *patrons* de chemins sont anglais et figés ; les *slugs* suivent la langue
du projet, puisqu'ils nomment des objets métier (§10).

**Le préfixe `NN-` des fichiers de user story n'est pas cosmétique.**
`superpowers`, dans `skills/subagent-driven-development/scripts/sdd-workspace`,
dérive le répertoire de travail d'un plan de son **basename seul**. Les plans
superpowers étant datés, leurs basenames sont quasi uniques. Sans ce préfixe,
deux `us-1-setup.md` dans deux batches différents partageraient workspace et
`progress.md` : SDD détecterait un ledger étranger, mais sa consigne — le
laisser en place et en démarrer un autre — est inapplicable au même chemin.
Comportement indéfini, et perte du mécanisme de reprise.

**`NN` est attribué par `writing-a-batch`** comme le plus petit entier non
utilisé dans `docs/batches/` **sur la branche d'intégration**, et le document de
batch y est commité dès la validation du gate humain (§5.2). C'est ce commit qui
réserve le numéro. Sans cette règle, deux batches ouverts en parallèle
prendraient le même `NN` et la collision de basenames que le préfixe existe pour
empêcher reviendrait par la porte que la concurrence ouvre.

### 4.1 Spec document

Décrit le comportement. Ni date, ni statut par section au repos.

- Une section en cours de traitement porte un marqueur temporaire, posé par
  `writing-a-user-story` et retiré par `closing-a-user-story`. **Sa durée de vie
  va de l'écriture de la story à son intégration effective** (§5.1, §5.3).
- **Le marqueur porte sa propre glose**, parce qu'il est lu par des agents qui
  ignorent tout de ce plugin — au premier rang desquels les reviewers de SDD,
  qui contrôlent la conformité sur la section même qui le porte :

  ```
  🚧 batch-07/us-2 — binding requirement, delivery in progress
  ```

  Sans cette glose, un reviewer peut traiter la section marquée comme du
  brouillon non contraignant, ou la signaler comme corps étranger. Le marqueur
  doit se lire sans contexte.
- Une table **Changelog** en pied de document porte l'historique :
  `batch | date | change`. Les modifications faites hors de tout batch (§8.2) y
  sont enregistrées avec `out-of-batch` en guise de numéro.
- Une section **Sources** liste les documents validés consommés lors de
  l'adoption (§6), par leur chemin **après archivage** (`docs/archive/...`).
  Elle est ce qui rend calculable l'état des lieux de `init` (§9) ; sans elle,
  aucun lien n'existe entre une spec et ce qui l'a nourrie.

La règle du marqueur est ce qui rend la détection de dérive mécanique : **tout
écart entre la spec et le code qui n'est pas couvert par un marqueur est une
dérive**, donc du travail correctif. Parce que le marqueur vit à l'échelle d'une
user story et non d'un batch, cette règle est vraie en continu — et pas
seulement entre deux batches.

### 4.2 Gaps register

`docs/specs/<module>.gaps.md` est un document vivant, pas un rapport jetable.
Deux sections distinctes, parce qu'elles ne se traitent pas pareil :

- **Violations** — le code contredit la spec. Alimente un *corrective batch*.
- **Gaps** — le code fait des choses qu'aucune spec ne décrit. Alimente un
  batch ordinaire qui les spécifie enfin.

**Qui écrit dedans.** `adopting-a-module` le crée (§6.4). Ensuite,
`closing-a-user-story` et `closing-a-batch` y **ajoutent** toute dérive
constatée en chemin et hors périmètre — typiquement une divergence spec/code sur
une section non marquée, relevée par un reviewer SDD ou consignée dans un
`Ruling:`. Sans ces écrivains, le registre ne serait alimenté qu'une fois, à
l'adoption, et la règle du §4.1 s'appuierait sur un audit qui n'a plus jamais
lieu.

**Réservation et consommation.** Chaque entrée désigne une section de la spec.
Elle est **réservée** à l'ouverture du batch qui la prend en charge (annotation
`reserved by batch-08`) et **barrée** à la clôture de ce batch (§5.4), pas à son
ouverture : tant que le batch n'est pas clos, l'écart n'est pas résorbé. La
réservation est au registre ce que le marqueur est à la spec — sans elle, deux
corrective batches concurrents piochent dans le même stock.

Le registre déclare aussi **sa propre couverture** : quelles parties du module
ont été auditées, lesquelles ne l'ont pas été, et pourquoi. Un registre vide qui
signifie « rien n'a été examiné » ne doit pas ressembler à un registre vide qui
signifie « tout est conforme ».

### 4.3 Batch document

Un `README.md` avec un front matter `status: open | closed`, et :

- **Scope** — ce que ce batch livre, et pourquoi maintenant.
- **Spec delta** — le comportement ajouté à chaque spec, énoncé comme
  intention. Ce delta n'est **pas** transcrit dans la spec à l'ouverture : il
  l'est tranche par tranche, par chaque user story (§5.3). Pour un corrective
  batch, ce champ est vide et remplacé par les entrées du gaps register que le
  batch réserve. Delta vide + entrées réservées, c'est exactement ce qui rend un
  batch correctif.
- **User stories** — une liste à cocher. Une case n'est cochée qu'après
  intégration effective de la story (§5.3).
- **Rulings log** — les rulings rapatriés du message final de SDD (§3).

### 4.4 User story document

Un plan superpowers standard, produit par `superpowers:writing-plans`,
enregistré dans le répertoire du batch, avec un header étendu :

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
```

`Spec:` est le champ que `subagent-driven-development` lit déjà comme autorité
contraignante — le faire pointer vers la spec vivante du module est ce qui fait
fonctionner l'intégration sans modifier superpowers.

**Ce montage n'est correct qu'à deux conditions**, toutes deux load-bearing :

1. **La transcription est incrémentale.** Si le delta complet d'un batch était
   écrit dans la spec à son ouverture, la spec décrirait, pendant l'exécution de
   l'US 1, le comportement des US 2 à N — et les reviewers de SDD signaleraient
   comme manquant ce qui n'est pas encore livré.
2. **La transcription est commitée sur la branche d'intégration avant que SDD
   démarre** (§5.1). Le worktree de SDD est un checkout du HEAD commité : une
   transcription non commitée n'y figure pas, et les reviewers jugeraient la
   conformité contre une spec dépourvue du delta — précisément l'inverse de ce
   que ce montage cherche.

`Batch:` est un pointeur de lecture, pour l'humain et pour l'orchestrateur. Ce
n'est **pas** le véhicule des contraintes. Ce que le batch impose à l'exécution
est recopié mot pour mot dans la section `Global Constraints` du plan, que
`superpowers:writing-plans` définit déjà comme faisant implicitement partie des
exigences de chaque tâche.

## 5. Batch lifecycle

### 5.1 Git model

Une seule règle, dont tout le reste découle : **les documents vivent sur la
branche d'intégration, le code vit sur des branches de user story.**

- Specs, gaps registers et documents de batch sont écrits par des **commits
  documentaires sur la branche d'intégration** (`main` ou son équivalent), en
  dehors de tout worktree, immédiatement. Ils ne transitent jamais par une
  branche de story.
- Le code d'une story vit sur sa propre branche, créée par
  `superpowers:using-git-worktrees` au démarrage de SDD. Le worktree dérive de
  la branche d'intégration, donc il contient déjà le delta transcrit et le
  marqueur.
- **Une branche par user story, une intégration par user story.**

C'est ce qui rend simultanément vraies les deux propriétés dont dépend le
design : les reviewers de SDD voient le delta (§4.4, condition 2), et les
marqueurs de tous les batches sont visibles au même endroit, donc la détection
de concurrence du §3 fonctionne. Une transcription qui vivrait sur la branche de
la story satisferait la première et casserait la seconde.

### 5.2 Opening — `writing-a-batch`

Vérifier que chaque module touché possède une spec adoptée ; sinon l'adoption
est un préalable bloquant (§6). Rédiger le document de batch : scope, spec delta
comme intention, liste initiale des user stories. Pour un corrective batch,
réserver dans le gaps register les entrées prises en charge (§4.2). **Aucune
écriture dans les specs à ce stade.**

Puis **gate humain obligatoire** : l'humain valide le batch avant qu'une seule
user story soit écrite. Ce gate est la transposition de celui de superpowers,
qui fait relire la spec écrite avant de passer à la planification ; le supprimer
laisserait entrer du normatif dans l'autorité contraignante sans validation.

À la validation, le document de batch est commité sur la branche d'intégration —
c'est ce commit qui réserve `NN` (§4).

### 5.3 Running

Les user stories sont écrites **une par une**, pas toutes à l'avance : la story
N+1 est écrite en connaissant ce qu'a produit la story N. Pour chacune :

1. **`writing-a-user-story`** — vérifier qu'aucun marqueur d'une autre story
   n'est posé sur les sections visées (§3) ; transcrire dans la spec **la
   tranche du delta propre à cette story** ; poser le marqueur ; commiter le
   tout sur la branche d'intégration ; puis appeler
   `superpowers:writing-plans`.

   **Cas correctif :** le delta étant vide, il n'y a rien à transcrire, mais
   **le marqueur est posé quand même**, sur les sections que la story remet en
   conformité. Il y signifie « écart connu, en cours de traitement ». Sans lui,
   la détection de concurrence du §3 et la vérification bounded du §8.2 seraient
   aveugles aux stories correctives en vol.

2. **`superpowers:subagent-driven-development`** exécute le plan, puis conclut
   comme il le fait toujours, sur `superpowers:finishing-a-development-branch`.
   Rien n'est intercepté : ce plugin ne touche pas à l'état terminal de SDD.

3. **`closing-a-user-story`** — **après intégration effective** de la branche.
   Retirer le marqueur, cocher la case dans le batch, recopier les lignes
   `Ruling:` du message final de SDD dans le Rulings log, verser au gaps
   register les dérives constatées hors périmètre (§4.2), le tout en un commit
   documentaire sur la branche d'intégration. Puis enchaîner sur la story
   suivante ou, s'il n'en reste aucune, sur `closing-a-batch`.

**Si l'humain n'intègre pas** — `finishing-a-development-branch` propose aussi
de garder la branche en l'état — alors `closing-a-user-story` ne s'exécute pas :
la story n'est pas validée, sa case reste vide et son marqueur reste posé. C'est
l'état correct : la spec annonce un comportement en cours de livraison, et il
l'est effectivement. Cocher la case au retour de SDD, avant la décision
d'intégration, ferait dire au système qu'une story est livrée alors qu'aucun
code intégré ne la porte — une dérive fabriquée par le processus.

### 5.4 Closing — `closing-a-batch`

Ajouter une ligne de changelog à chaque spec touchée. Barrer les entrées
réservées dans les gaps registers avec le numéro de batch. Verser au registre
les dérives constatées pendant le batch et non traitées. Passer
`status: closed`. Vérifier qu'aucun marqueur de ce batch ne subsiste : il n'en
reste normalement aucun, chacun ayant été retiré à l'intégration de sa story ;
s'il en reste un, une story n'a pas été intégrée et c'est une anomalie à
signaler, pas à nettoyer en silence.

## 6. Module adoption

`supercharlouze:adopting-a-module` établit la vérité dont tout le reste dépend.
C'est l'opération la plus délicate du système.

**Ordre d'autorité des sources :**

1. **Les documents validés** sont normatifs. Ils font la vérité.
2. **Le code** ne corrige jamais un document. Il comble les *silences* des
   documents — les comportements qu'aucun document n'a jamais décrits.
3. **L'humain** tranche les contradictions.

Reconstruire une spec depuis le code est explicitement écarté : cela
canoniserait la dérive et détruirait la propriété même qui rend les corrective
batches possibles.

**Steps:**

1. **Delimit the module** — l'humain le nomme et en trace les contours. Le skill
   ne les déduit jamais. Préférer un gros module à plusieurs petits.
2. **Inventory the validated documents** qui le couvrent — anciens design docs
   superpowers, README, docs métier, ADR. Présenter la liste à l'humain *avant*
   d'écrire quoi que ce soit, pour qu'il puisse ajouter une source manquante ou
   en écarter une qui n'a jamais été validée. La qualité de la spec est plafonnée
   par cet inventaire. **L'inventaire retenu est enregistré dans la section
   `Sources` de la spec** (§4.1) : c'est le seul lien persistant entre une spec
   et ce qui l'a nourrie, et `init` en dépend (§9).
3. **Write the spec from those documents only.** Fusion, déduplication, mise en
   cohérence. Quand deux documents validés se contredisent, le plus récent
   l'emporte par défaut — consigné comme ruling, jamais résolu en silence.
4. **Audit the code against the spec** et produire le gaps register, avec ses
   deux sections et sa couverture déclarée (§4.2).
5. **Mandatory human review.** Tant que l'humain n'a pas validé la spec et le
   registre, le module n'est pas adopté et aucun batch ne peut démarrer dessus.

**Cas dégradé — un module sans aucun document validé.** L'adoption depuis les
documents est impossible et la reconstruction depuis le code est écartée. Le
skill bascule alors en dialogue : il énumère les comportements trouvés dans le
code et demande à l'humain, section par section, « est-ce voulu ? ». Ce que
l'humain valide devient la spec ; le reste part en gaps. C'est lent, et lancer
cette adoption maintenant ou la différer reste la décision de l'humain.

## 7. Skills

| Skill | Trigger | Produces |
|---|---|---|
| `using-batches` | point d'entrée, cité par le bloc `CLAUDE.md` | le routage, le vocabulaire, les règles d'autorité, les overrides déclarés (§8.3) |
| `adopting-a-module` | premier batch touchant un module sans spec | la spec (avec ses `Sources`) + le gaps register |
| `writing-a-batch` | ouverture d'un batch, ou requalification d'un batch correctif (§8.3) | le document de batch, les réservations au registre, le gate humain |
| `writing-a-user-story` | une story à écrire | la tranche de delta transcrite et commitée, le marqueur, le plan superpowers |
| `closing-a-user-story` | intégration effective de la branche de story | marqueur retiré, case cochée, rulings rapatriés, dérives versées au registre |
| `closing-a-batch` | dernière story intégrée | changelog, registre drainé, `status: closed` |

`writing-a-user-story` est séparé de `writing-a-batch` parce que les stories
sont écrites au fil de l'eau (§5.3). `closing-a-user-story` est séparé de
`closing-a-batch` parce qu'il s'exécute N fois par batch, à un moment que seule
l'intégration déclenche.

## 8. Routing and precedence

### 8.1 The lever

La préséance sur superpowers s'obtient par le `CLAUDE.md` du projet, parce que
c'est le levier que superpowers concède explicitement.
`superpowers:using-superpowers` se termine par *« User instructions (CLAUDE.md,
AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills »*. Ce
pari est plus solide qu'il n'y paraît : le hook `SessionStart` de superpowers
injecte l'**intégralité** de `using-superpowers` au démarrage de chaque session,
cette phrase comprise. La concession n'attend donc pas qu'un skill soit chargé —
superpowers la remet lui-même en contexte à chaque fois.

Deux concessions plus étroites, mais plus directes encore, existent pour la
seule relocalisation des artefacts : `brainstorming` porte *« (User preferences
for spec location override this default) »* et `writing-plans` *« (User
preferences for plan location override this default) »*. Sur ce point précis, la
préséance n'est pas un pari — c'est une porte prévue par superpowers. Le bloc
`CLAUDE.md` doit s'appuyer sur ces formulations quand il déplace les chemins, et
ne recourir à la clause générale que pour ce qu'elles ne couvrent pas : le
reroutage et les overrides.

Un hook `SessionStart` propre au plugin a été écarté : l'ordre entre les hooks
de deux plugins n'est pas spécifié, ce qui laisserait deux blocs
`EXTREMELY_IMPORTANT` concurrents et produirait des échecs intermittents et
indiagnosticables.

Le bloc inséré par `/supercharlouze:init` est délibérément minuscule et stable,
pour n'avoir jamais à être resynchronisé quand le plugin évolue. Toute la
substance vit dans les skills versionnés :

```markdown
## Specs and plans

This project overrides how superpowers organizes specs and plans. Invoke
`supercharlouze:using-batches` before any design work, and again before
executing any plan. It relocates specs and plans, reroutes the architectural
terminal state of superpowers:brainstorming, extends the stop conditions of
superpowers:subagent-driven-development, and requires subagent-driven-development
as the execution mode. It declares each of these overrides explicitly; where it
declares none, superpowers applies unchanged.
```

Le bloc **énumère les trois overrides du §8.3, sans en omettre un**. Par
l'argument même de cette section — le bloc est le seul artefact garanti en
contexte, et ce qu'il affirme l'emporte sur un skill chargé à la demande — un
override absent du bloc serait exactement aussi fragile que celui qu'une
formulation trop large aurait tué. Le bloc ne dit donc pas que les autres skills
« s'appliquent inchangés » sans réserve, et il demande l'invocation **avant
exécution d'un plan** autant qu'avant la conception : sans cela,
`using-batches` n'est pas en contexte au moment où sa cinquième condition
d'arrêt doit s'appliquer.

### 8.2 What is kept, what is rerouted

La classification spike / bounded / architectural de superpowers est
**conservée telle quelle** — elle est orthogonale à ce modèle, et elle est
bonne.

- **Spike** — inchangé. Aucun artefact.
- **Bounded** — cérémonie inchangée, avec deux ajouts. superpowers autorise une
  modification bounded à être livrée sans aucun document, ce qui dans ce modèle
  signifie du comportement qui change pendant que la spec reste immobile : une
  dérive fabriquée par le processus lui-même. Donc :
  - **(a) une modification bounded ne laisse jamais la spec muette.** Qu'elle
    *altère* un comportement déjà décrit ou qu'elle en *ajoute* un que nulle
    spec ne décrit, elle met la spec à jour au titre de sa définition de
    terminé, avec une ligne de changelog `out-of-batch`. Traiter seulement le
    cas « altère » rouvrirait le même trou un cran à côté.
  - **(b) elle vérifie d'abord qu'aucun marqueur ne couvre la section visée** —
    sinon elle percute une user story en vol, ce qui est la condition d'arrêt du
    §3 atteinte par une porte dérobée.

  Pas de batch, pas de user story, pas de cérémonie ajoutée au-delà de ces deux
  règles.
- **Architectural** — l'état terminal est rerouté vers
  `supercharlouze:writing-a-batch` au lieu du design doc daté suivi de
  `writing-plans`. C'est un override déclaré (§8.3).

### 8.3 Declared overrides of closed rules

superpowers énonce plusieurs de ses règles comme fermées. Une exception
implicite à une règle marquée « et seulement celles-ci » ne survivra pas à une
session sous pression : chacune doit donc être **nommée comme un override** dans
`using-batches` et dans le bloc `CLAUDE.md` (§8.1), avec sa justification. Il y
en a trois, et il ne doit jamais y en avoir une quatrième non déclarée.

**Override 1 — l'état terminal du chemin architectural.** `brainstorming`
écrit *« Architectural: the ONLY skill you invoke after brainstorming is
writing-plans »*, et redouble en fin de skill : *« Do NOT invoke any other
skill. writing-plans is the next step »*. Le reroutage du §8.2 contredit
frontalement cette règle. Justification : `writing-a-batch` n'est pas un skill
d'implémentation — la catégorie que cette règle protège — mais un substitut à
l'étape documentaire qui précède `writing-plans`, lequel reste appelé, depuis
`writing-a-user-story`.

**Override 2 — la cinquième condition d'arrêt de SDD.**
`subagent-driven-development` énonce *« Four things stop you, and only these »*.
Ce plugin en ajoute une, pour les corrective batches seulement :

> Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
> **spec** qui a tort et le code qui a raison, arrête-toi. Le batch n'est plus
> correctif et doit être requalifié.

Justification : les quatre conditions de SDD supposent qu'une autorité valide
existe. Ici c'est l'autorité elle-même qui est en cause, et le §3 interdit à un
agent de corriger une spec.

**Procédure de requalification**, portée par `writing-a-batch` : la story en
cours est abandonnée, l'humain tranche. Soit il corrige la spec — lui seul le
peut (§3) — et le batch reste correctif sur un périmètre réduit ; soit le batch
est réécrit comme batch ordinaire, avec un spec delta, et repasse par le gate
humain du §5.2. Dans les deux cas la réservation au gaps register est révisée.
Sans cette procédure, l'arrêt serait défini et la suite ne le serait pas.

**Override 3 — le mode d'exécution imposé.** `writing-plans` se termine en
proposant à l'humain un choix entre `subagent-driven-development` et
`executing-plans`. Ce plugin impose SDD. Justification : le rapatriement des
rulings (§3, §5.3) dépend du ledger de SDD ; `executing-plans` n'en tient pas,
et la trace des arbitrages serait perdue.

**Ce qui n'est délibérément pas un override :** l'état terminal de SDD. Il
serait tentant d'intercaler `closing-a-user-story` entre SDD et
`finishing-a-development-branch`, mais ce serait un quatrième override — et il
ferait cocher la case avant la décision d'intégration de l'humain (§5.3).
`closing-a-user-story` s'exécute donc **après** la chaîne superpowers, pas
dedans.

## 9. The `init` command

`/supercharlouze:init` est idempotente et n'adopte jamais rien.

1. Créer `docs/specs/`, `docs/batches/`, `docs/archive/`.
2. Déplacer `docs/superpowers/specs/` vers `docs/archive/specs/` et
   `docs/superpowers/plans/` vers `docs/archive/plans/`, en conservant les noms
   de fichiers. La structure est fixée ici parce que le point 4 en dépend :
   `Sources` enregistre les chemins d'archive, et la correspondance doit être
   exacte.
3. Insérer le bloc `CLAUDE.md`, ou le mettre à jour sur place s'il est déjà
   présent. Ne jamais le dupliquer. Fonctionne aussi bien sur un projet qui a
   déjà un `CLAUDE.md` que sur un projet qui n'en a pas.
4. Rendre l'état des lieux : quels modules sont adoptés (une spec existe dans
   `docs/specs/`), et quels documents archivés ne figurent dans la section
   `Sources` d'aucune spec (§4.1, §6.2) — c'est ce qui rend ce calcul décidable
   plutôt qu'affaire d'heuristique. La commande ne **propose pas** de découpage
   en modules — §6 le réserve à l'humain, et une suggestion serait lue comme une
   décision.

L'adoption reste une décision délibérée, module par module (§6). Un projet peut
rester à moitié adopté indéfiniment sans que rien ne casse.

## 10. Language

La frontière ne passe pas entre les documents, elle passe **à l'intérieur** de
chaque document : ossature en anglais, prose dans la langue du projet.

- **L'ossature est anglaise, partout.** Titres de sections, noms de champs,
  libellés de templates, valeurs de front matter (`status: open | closed`),
  en-têtes de tableaux, patrons de chemins, marqueurs et leur glose, noms de
  skills et de commandes. Cela vaut pour le plugin comme pour les documents
  qu'il produit dans un projet : specs de module, gaps registers, batches.
- **La prose est dans la langue du projet** — français par défaut ici. Le corps
  des exigences, les descriptions, les justifications, les slugs de fichiers et
  de répertoires, qui nomment des objets métier.
- **Le plugin lui-même est intégralement anglais** — skills, commandes, README,
  bloc `CLAUDE.md`, messages. Il n'a pas de prose métier ; il n'a que de
  l'ossature.

C'est le « feeling superpowers » conservé : un document de ce système se lit
comme un document superpowers, avec du contenu français. Et l'ossature anglaise
imposée par `superpowers:writing-plans` aux user stories (`Global Constraints`,
`Files`, `Interfaces`) n'est alors plus une exception subie — c'est la règle
générale, déjà appliquée par superpowers.

Le présent document suit cette règle.

## 11. Verification

**Contrôles structurels uniquement**, automatisés et bon marché :

- `plugin.json` est valide.
- Chaque `SKILL.md` a un front matter avec `name` et `description`.
- Les chemins cités d'un skill à l'autre existent.
- Le bloc `CLAUDE.md` s'insère proprement dans un fichier existant, dans un
  projet sans `CLAUDE.md`, et ne se duplique pas à la deuxième exécution.
- Chacun des trois overrides du §8.3 est présent et nommé **à la fois** dans
  `using-batches` et dans le bloc `CLAUDE.md` — le seul contrôle structurel qui
  protège une propriété comportementale, et il est bon marché.

**Ce qui n'est pas testé, et qui est donc un pari assumé :**

- La solidité du levier `CLAUDE.md` pour le routage — le point de rupture le
  plus probable de la conception.
- L'interprétation du marqueur par les reviewers de SDD (§4.1). La glose le rend
  lisible sans contexte, mais rien ne garantit qu'un reviewer la respecte.

La phase 2 du plan d'amorçage est ce qui éprouve ces deux paris en pratique.

## 12. Bootstrap plan

**Phase 1 — construire la v1 avec superpowers nu.** Le plugin ne peut pas se
construire lui-même : `writing-a-batch` n'existe pas encore. La v1 suit donc le
chemin superpowers standard — ce document de conception, puis
`superpowers:writing-plans`, puis `subagent-driven-development`. Les artefacts
atterrissent dans `docs/superpowers/specs/` et `docs/superpowers/plans/`, selon
les conventions de superpowers.

**Phase 2 — dogfooding sur ce dépôt.** Une fois la v1 livrée, lancer
`/supercharlouze:init` sur `superpowers-by-charlouze` lui-même. Il sera alors un
vrai projet superpowers, avec des documents de conception datés à migrer, et
dont on connaît chaque ligne — le bon premier sujet pour l'init, la migration et
l'adoption, avant de les lâcher sur des projets réels. superpowers se construit
lui-même de cette façon, et un plugin de skills s'y prête bien : son « code » est
de la prose, donc l'écart entre spec et implémentation y est réel et vaut la
peine d'être traqué.

**Nombre de modules pour ce dépôt : un — `superpowers-override`.** Pas quatre.
C'est l'heuristique de granularité du §2 appliquée à son propre auteur.

## 13. Rejected alternatives

| Alternative | Motif du rejet |
|---|---|
| Forker superpowers | Le projet refuse explicitement les PR spécifiques à un fork ; la divergence serait maintenue seul, sans gain par rapport à un plugin compagnon. |
| `CLAUDE.md` par projet, sans plugin | Suffisant pour les chemins et le vocabulaire, insuffisant face à la checklist en dur de `brainstorming` et à ses tables de red flags tunées. |
| Hook `SessionStart` pour la préséance | Ordre non spécifié entre hooks de plugins ; échecs intermittents. |
| Le batch l'emporte sur la spec pendant le batch | La spec est ce que lisent les reviewers ; la laisser fausse pendant tout un batch ruine sa raison d'être. |
| Un agent corrige la spec pour résoudre un conflit | Inverse silencieusement l'autorité : c'est alors l'intention du batch qui gagne (§3). |
| Spec mise à jour à la clôture du batch | SDD contrôle la conformité après *chaque* tâche, contre une spec qui ne décrirait pas encore le travail en cours. |
| Delta complet transcrit à l'ouverture du batch | Les reviewers de SDD signaleraient comme manquant le comportement des stories suivantes (§4.4). |
| Transcription non commitée, ou commitée sur la branche de story | Non commitée : absente du worktree de SDD, les reviewers jugent contre une spec sans le delta. Sur la branche de story : invisible des autres batches, la détection de concurrence devient aveugle (§5.1). |
| Une branche par batch, intégration unique à la clôture | Ramènerait la durée de vie du marqueur à celle du batch et annulerait la propriété de continuité du §4.1. |
| Marqueur sans glose | Il est lu par des agents qui ignorent ce plugin, sur la section même dont ils contrôlent la conformité (§4.1). |
| `closing-a-user-story` intercalé entre SDD et `finishing-a-development-branch` | Quatrième override non déclaré, et validation de la story avant la décision d'intégration de l'humain (§8.3). |
| Fichiers de story nommés `us-N-<slug>.md` | Collision de workspace SDD par basename identique entre batches (§4). |
| `NN` attribué sans réservation par commit | Deux batches parallèles prendraient le même numéro et rouvriraient la collision (§4). |
| Entrées du gaps register sans réservation à l'ouverture | Deux corrective batches concurrents piocheraient dans le même stock (§4.2). |
| Gaps register alimenté seulement à l'adoption | La règle de dérive du §4.1 s'appuierait sur un audit qui n'a plus jamais lieu (§4.2). |
| Pas de gate humain à l'ouverture d'un batch | Laisserait entrer du normatif dans l'autorité contraignante sans validation, là où superpowers en exige une pour un document jetable (§5.2). |
| Statut permanent par section dans la spec | Traçabilité totale au prix d'un document qui se lit comme un registre et non comme une spécification. Le changelog en récupère l'essentiel. |
| Spec reconstruite depuis le code à l'adoption | Canonise la dérive ; détruit la prémisse des corrective batches. |
| Comportement non documenté absorbé dans la spec à l'adoption | La spec ne doit contenir que du validé ; le comportement non validé appartient au gaps register. |
| « Exigence » comme unité de concurrence | Granularité indéfinissable ; la section, unité titrée, est vérifiable (§2). |
| Support multi-harness | Seul Claude Code est utilisé ; chaque harness supplémentaire est du portage sans retour. |
| Documents intégralement anglais | La spec est lue et amendée par l'humain ; l'anglais n'y sert que la machine. |
| Documents intégralement français, ossature comprise | Perd le « feeling superpowers », et casse les champs que `subagent-driven-development` lit (§4.4). |
