# supercharlouze — Design

**Goal:** un plugin Claude Code qui surcharge l'organisation des specs et des
plans de superpowers. Il remplace les documents de conception datés et jetables
par une spécification vivante par module fonctionnel, et remplace les plans
isolés par des *batches* de user stories qui font grandir ces specs.

**Status:** conception validée le 2026-09-03. Rien n'est encore implémenté.

**Plugin name:** `supercharlouze` (namespace de tous les skills). Dépôt :
`superpowers-by-charlouze`.

**Target harness:** Claude Code uniquement.

---

## 1. Problem

superpowers écrit un document de conception daté par fonctionnalité
(`docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`) et un plan par
fonctionnalité (`docs/superpowers/plans/YYYY-MM-DD-<feature>.md`). Les deux
sont des instantanés d'une intention à un moment donné, et aucun n'est jamais
repris.

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

**Batch** (« lot ») — l'unité de livraison, dans `docs/batches/NN-<slug>/`. Un
batch regroupe plusieurs user stories. Sa raison d'être est d'ajouter des
fonctionnalités à une ou plusieurs specs. Un batch peut être transverse à
plusieurs modules.

**User story** — un plan d'implémentation, dans
`docs/batches/NN-<slug>/us-N-<slug>.md`. Une user story appartient à exactement
un batch et vise exactement **un** module, donc une seule spec.

**Corrective batch** — un batch dont le spec delta est vide. Son but est de
remettre le code existant en conformité avec une spec déjà vraie. Son périmètre
est puisé dans le gaps register d'un module.

## 3. Authority and conflict rules

La spec est l'autorité contraignante. Le batch ne porte que ce qu'une spec ne
peut pas porter : le périmètre de livraison, l'ordre des user stories, les
contraintes de migration et de compatibilité, et la raison pour laquelle ce
travail a lieu maintenant. Par construction, le batch ne peut pas contredire la
spec.

**Quand un batch et une spec se contredisent, la spec gagne.** Un conflit n'est
pas un arbitrage à rendre, c'est un symptôme : le spec delta a été mal écrit. On
corrige la spec, puis on continue.

**Tout conflit est consigné pour l'humain.** On réutilise le mécanisme existant
plutôt que d'en inventer un : `superpowers:subagent-driven-development` tient un
ledger dont les décisions prennent la forme
`Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>`, et collecte
toutes les lignes `Ruling:` pour les présenter à l'humain avant de supprimer son
workspace. Comme ce workspace est éphémère, ce plugin recopie ces lignes dans le
**Rulings log** du batch à la validation de chaque user story, pour que la trace
survive.

**Deux batches ouverts peuvent marquer la même spec** — les marqueurs nomment
leur batch, donc aucune confusion possible. Deux batches ouverts modifiant **la
même exigence** est une condition d'arrêt et d'escalade ; ça ne se résout pas
tout seul. La détection a lieu dans `writing-a-batch` : avant de poser un
marqueur sur une section, il vérifie qu'un marqueur nommant un autre batch n'y
est pas déjà.

## 4. Artifact layout

```
docs/
  specs/
    facturation.md                spec vivante, une par module, non datée
    facturation.gaps.md           gaps register du module
  batches/
    07-facturation-recurrente/
      README.md                   le batch
      us-1-abonnement.md          une user story = un plan superpowers
      us-2-relance.md
  archive/                        documents datés d'avant la migration
```

Les *patrons* de chemins sont anglais et figés ; les *slugs* suivent la langue
du projet, puisqu'ils nomment des objets métier (§10).

### 4.1 Spec document

Décrit le comportement. Ni date, ni statut par exigence au repos.

- Les sections en cours de livraison portent un marqueur temporaire
  `🚧 batch-07`, posé à l'ouverture du batch et retiré à sa clôture.
- Une table **Changelog** en pied de document porte l'historique :
  `batch | date | change`. Les modifications faites hors de tout batch (cf.
  §8.2) y sont enregistrées avec `out-of-batch` en guise de numéro.

La règle du marqueur est ce qui rend la détection de dérive mécanique : **tout
écart entre la spec et le code qui n'est pas couvert par un marqueur est une
dérive**, donc du travail correctif.

### 4.2 Gaps register

`docs/specs/<module>.gaps.md` est un document vivant, pas un rapport jetable.
Créé par l'adoption du module, il est vidé au fil des batches. Deux sections
distinctes, parce qu'elles ne se traitent pas pareil :

- **Violations** — le code contredit la spec. Alimente un *corrective batch*.
- **Gaps** — le code fait des choses qu'aucune spec ne décrit. Alimente un
  batch ordinaire qui les spécifie enfin.

Chaque entrée est barrée avec son numéro de batch quand elle est consommée.

Le registre déclare aussi **sa propre couverture** : quelles parties du module
ont été auditées, lesquelles ne l'ont pas été, et pourquoi. Un registre vide qui
signifie « rien n'a été examiné » ne doit pas ressembler à un registre vide qui
signifie « tout est conforme ».

### 4.3 Batch document

Un `README.md` avec un front matter `status: open | closed`, et :

- **Scope** — ce que ce batch livre, et pourquoi maintenant.
- **Spec delta** — le comportement ajouté à chaque spec ; ou, pour un
  corrective batch, les entrées du gaps register qu'il consomme. Delta vide +
  entrées non vides, c'est exactement ce qui rend un batch correctif.
- **User stories** — une liste à cocher. Les cases sont cochées à mesure que
  les stories sont validées.
- **Rulings log** — les rulings rapatriés du ledger de SDD.

### 4.4 User story document

Un plan superpowers standard, produit par `superpowers:writing-plans`,
enregistré dans le répertoire du batch, avec un header étendu :

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
```

`Spec:` est le champ que `subagent-driven-development` lit déjà comme autorité
contraignante — le faire pointer vers la spec vivante du module est ce qui fait
fonctionner toute l'intégration sans modifier superpowers.

`Batch:` est un pointeur de lecture, pour l'humain et pour l'orchestrateur. Ce
n'est **pas** le véhicule des contraintes. Ce que le batch impose à l'exécution
est recopié mot pour mot dans la section `Global Constraints` du plan, que
`superpowers:writing-plans` définit déjà comme faisant implicitement partie des
exigences de chaque tâche.

## 5. Batch lifecycle

**Opening.** Vérifier que chaque module touché possède une spec adoptée ; sinon
l'adoption est un préalable bloquant (§6). Écrire le spec delta dans chaque spec
et poser les marqueurs `🚧 batch-NN` sur les sections concernées. Rédiger le
document de batch avec son scope et la liste initiale des user stories.

**Running.** Les user stories sont écrites **une par une**, pas toutes à
l'avance : la story N+1 est écrite en connaissant ce qu'a produit la story N.
Chaque story passe par `superpowers:writing-plans` pour la mécanique des tâches,
puis par `superpowers:subagent-driven-development` pour l'exécution. À sa
validation, on coche sa case dans le batch et on recopie ses rulings dans le
Rulings log.

**Closing.** Retirer tous les marqueurs `🚧 batch-NN` des specs. Ajouter une
ligne de changelog à chaque spec touchée. Barrer les entrées consommées dans les
gaps registers avec le numéro de batch. Passer `status: closed`.

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
   par cet inventaire.
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
| `using-batches` | point d'entrée, cité par le bloc `CLAUDE.md` | le routage, le vocabulaire, les règles d'autorité et d'arbitrage |
| `adopting-a-module` | premier batch touchant un module sans spec | la spec + le gaps register |
| `writing-a-batch` | ouverture d'un batch | le document de batch, le spec delta, les marqueurs |
| `writing-a-user-story` | une story à écrire | un plan superpowers au bon endroit et au bon format |
| `closing-a-batch` | dernière story validée | marqueurs retirés, changelog, registre consommé, rulings journalisés |

`writing-a-user-story` est séparé de `writing-a-batch` parce que les stories
sont écrites au fil de l'eau (§5).

## 8. Routing and precedence

### 8.1 The lever

La préséance sur superpowers s'obtient par le `CLAUDE.md` du projet, parce que
c'est le seul levier que superpowers concède explicitement :
`superpowers:using-superpowers` se termine par *« User instructions (CLAUDE.md,
AGENTS.md, direct requests) take precedence over skills »*.

Un hook `SessionStart` a été écarté : l'ordre entre les hooks de deux plugins
n'est pas spécifié, ce qui laisserait deux blocs `EXTREMELY_IMPORTANT`
concurrents et produirait des échecs intermittents et indiagnosticables.

Le bloc inséré par `/supercharlouze:init` est délibérément minuscule et stable,
pour n'avoir jamais à être resynchronisé quand le plugin évolue. Toute la
substance vit dans les skills versionnés :

```markdown
## Specs and plans

This project overrides the documentary organization of superpowers.
Before any design work, invoke `supercharlouze:using-batches`. It replaces the
"Write design doc" step of superpowers:brainstorming and the plan location of
superpowers:writing-plans. Every other superpowers skill (TDD,
subagent-driven-development, debugging, reviews) applies unchanged.
```

### 8.2 What is kept, what is rerouted

La classification spike / bounded / architectural de superpowers est
**conservée telle quelle** — elle est orthogonale à ce modèle, et elle est
bonne.

- **Spike** — inchangé. Aucun artefact.
- **Bounded** — cérémonie inchangée, avec un ajout. superpowers autorise une
  modification bounded à être livrée sans aucun document, ce qui dans ce modèle
  signifie du comportement qui change pendant que la spec reste immobile : une
  dérive fabriquée par le processus lui-même. Donc : une modification bounded
  qui altère un comportement décrit dans une spec **doit mettre cette spec à
  jour au titre de sa définition de terminé**, avec une ligne de changelog
  `out-of-batch`. Pas de batch, pas de user story, pas de cérémonie ajoutée.
- **Architectural** — l'état terminal est rerouté. Au lieu d'écrire un design
  doc daté et d'appeler `writing-plans`, il appelle
  `supercharlouze:writing-a-batch`.

### 8.3 Declared override of a closed rule

`superpowers:subagent-driven-development` énonce *« Four things stop you, and
only these »*. Ce plugin en ajoute une cinquième, pour les corrective batches
seulement :

> Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
> **spec** qui a tort et le code qui a raison, arrête-toi. Le batch n'est plus
> correctif et doit être requalifié.

Parce que SDD présente sa liste comme fermée, cet override doit être **nommé
comme un override** dans `using-batches`, avec sa justification. Une exception
implicite à une règle marquée « et seulement celles-ci » ne survivra pas à une
session sous pression.

## 9. The `init` command

`/supercharlouze:init` est idempotente et n'adopte jamais rien.

1. Créer `docs/specs/`, `docs/batches/`, `docs/archive/`.
2. Déplacer les `docs/superpowers/specs/` et `docs/superpowers/plans/`
   existants dans `docs/archive/`.
3. Insérer le bloc `CLAUDE.md`, ou le mettre à jour sur place s'il est déjà
   présent. Ne jamais le dupliquer. Fonctionne aussi bien sur un projet qui a
   déjà un `CLAUDE.md` que sur un projet qui n'en a pas.
4. Rendre l'état des lieux : quels modules sont adoptés (une spec existe dans
   `docs/specs/`), et quels documents ont été archivés sans qu'aucune spec ne
   les couvre. La commande ne **propose pas** de découpage en modules — §6 le
   réserve à l'humain, et une suggestion serait lue comme une décision.

L'adoption reste une décision délibérée, module par module (§6). Un projet peut
rester à moitié adopté indéfiniment sans que rien ne casse.

## 10. Language

La frontière ne passe pas entre les documents, elle passe **à l'intérieur** de
chaque document : ossature en anglais, prose dans la langue du projet.

- **L'ossature est anglaise, partout.** Titres de sections, noms de champs,
  libellés de templates, valeurs de front matter (`status: open | closed`),
  en-têtes de tableaux, patrons de chemins, marqueurs (`🚧 batch-07`), noms de
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
`Files`, `Interfaces`, `Steps`) n'est alors plus une exception subie — c'est la
règle générale, déjà appliquée par superpowers.

Le présent document suit cette règle.

## 11. Verification

**Contrôles structurels uniquement**, automatisés et bon marché :

- `plugin.json` est valide.
- Chaque `SKILL.md` a un front matter avec `name` et `description`.
- Les chemins cités d'un skill à l'autre existent.
- Le bloc `CLAUDE.md` s'insère proprement dans un fichier existant, dans un
  projet sans `CLAUDE.md`, et ne se duplique pas à la deuxième exécution.

L'évaluation comportementale du routage est **explicitement hors périmètre**. La
conséquence acceptée : la solidité du levier `CLAUDE.md` — le point de rupture
le plus probable de toute la conception — n'est pas prouvée par la suite de
tests. La phase 2 du plan d'amorçage ci-dessous est ce qui l'éprouve en
pratique.

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
| Spec mise à jour à la clôture du batch | Même motif : SDD contrôle la conformité après *chaque* tâche, contre une spec qui ne décrirait pas encore le travail en cours. |
| Statut permanent par exigence dans la spec | Traçabilité totale au prix d'un document qui se lit comme un registre et non comme une spécification. Le changelog en récupère l'essentiel. |
| Spec reconstruite depuis le code à l'adoption | Canonise la dérive ; détruit la prémisse des corrective batches. |
| Comportement non documenté absorbé dans la spec à l'adoption | La spec ne doit contenir que du validé ; le comportement non validé appartient au gaps register. |
| Support multi-harness | Seul Claude Code est utilisé ; chaque harness supplémentaire est du portage sans retour. |
| Documents intégralement anglais | La spec est lue et amendée par l'humain ; l'anglais n'y sert que la machine. |
| Documents intégralement français, ossature comprise | Perd le « feeling superpowers », et casse les champs que `subagent-driven-development` lit (§4.4). |
