# supercharlouze

## Boundary

Ce module couvre le plugin dans son ensemble : les cinq skills et leur routage, la
commande et le script d'init, le bloc `CLAUDE.md` canonique, les métadonnées de
plugin et de marketplace, et le format des documents que le plugin fait produire
(spec, gaps register, batch, user story).

Il ne couvre pas superpowers lui-même : ses skills sont réutilisées telles quelles,
et seules les quatre surcharges déclarées les modifient. Il ne couvre pas non plus
le harnais Claude Code — mécanique `/plugin`, chargement des skills, hooks du
harnais.

Le plugin entier constitue un seul module, conformément à la règle qui préfère peu
de gros modules à beaucoup de petits.

## Purpose

superpowers écrit un document de conception daté par fonctionnalité et un plan par
fonctionnalité. Les deux sont des instantanés d'une intention, et aucun n'est
jamais repris : au bout de dix fonctionnalités, le comportement d'un module est
éparpillé dans dix documents dont aucun ne décrit l'état courant, et aucun artefact
ne peut révéler que le code a dérivé de ce qui avait été validé.

Le plugin doit remplacer ces documents jetables par une spécification vivante par
module fonctionnel, et remplacer les plans isolés par des batches de user stories
qui font grandir ces specs.

## Plugin identity and distribution

- Le plugin se nomme `supercharlouze`, et ce nom est le namespace de tous ses
  skills et de toutes ses commandes.
- Il est distribué comme plugin Claude Code, par une marketplace déclarée dans le
  même dépôt (`.claude-plugin/marketplace.json`), et son manifeste
  `.claude-plugin/plugin.json` doit être valide.
- **Harnais cible : Claude Code uniquement.** Le support multi-harnais est hors
  périmètre : chaque harnais supplémentaire est du portage sans retour.
- Il exige superpowers installé. Il ne le forke pas et ne le modifie pas.
- Le README doit documenter l'installation, la table des skills, la commande de
  test et les prérequis.

## The model

**Module** — un domaine fonctionnel grossier, vu de l'extérieur. Les modules sont
délimités par l'humain, jamais déduits par un agent. Un projet à trois modules est
normal, un projet à quinze est une erreur de découpage.

**Spec** — un document vivant par module, dans `docs/specs/<module>.md`. Elle est
**normative** — ce que le code doit faire — et non descriptive. Elle ne porte pas
de date. Elle est l'autorité contraignante de toutes les revues.

**Section** — la plus petite unité titrée d'une spec, et l'unité de tout ce qui se
compte dans ce système : un conflit de concurrence se juge sur une section, une
entrée de gaps register désigne une section. Le mot « exigence » n'est pas employé
comme unité, faute de pouvoir en définir la granularité.

**Batch** — l'unité de livraison, dans `docs/batches/NN-<slug>/`. Il regroupe
plusieurs user stories et existe pour ajouter du comportement à une ou plusieurs
specs. Un batch peut être transverse à plusieurs modules.

**User story** — un plan d'implémentation, dans
`docs/batches/NN-<slug>/NN-us-N-<slug>.md`. Elle appartient à exactement un batch
et vise exactement **un** module, donc une seule spec. C'est aussi l'unité de
livraison technique : **une story, une branche, une pull request**, et cette pull
request porte à la fois la tranche de spec et le code qui la réalise.

**Corrective batch** — un batch dont le spec delta est vide. Il remet du code
existant en conformité avec une spec déjà vraie. Son périmètre est puisé dans le
gaps register d'un module.

## Feature flags

Un feature flag est ce qui rend une story livrable seule sans exposer un lot à
moitié fait. `main` étant déployée en continu, chaque story fusionnée part en
production ; un lot dont les stories exposeraient du comportement incomplet en
déclare un.

**Le flag est un objet spécifié, pas un détail d'implémentation.** La section de
spec concernée énonce son nom et son défaut. Sans cette déclaration, une story
fusionnée derrière un flag rendrait la spec fausse au sens des utilisateurs.

**Le flag est par couple (lot, module).** Pas par story — le lot est la frontière
au-delà de laquelle il n'y a plus rien d'incomplet. Pas par lot non plus : un lot
transverse qui garde du comportement dans deux modules déclare **deux** flags, un
par module. Sinon sa story de levée devrait retirer la phrase de gating dans deux
specs, alors qu'une story vise exactement un module — elle serait impossible à
écrire.

**Sa durée de vie est courte, et le lot la borne par défaut.** Un flag qui traîne
est du code mort que plus personne n'ose retirer, et ce mode de panne est
silencieux.

**Portée étendue, par exception.** Un flag peut survivre à son lot — un module
construit sur plusieurs lots et ouvert seulement une fois complet en est le cas
type. Il déclare alors sa **portée** et **la condition qui le lève**. Cette
déclaration est ce qui distingue un flag encore utile d'un flag oublié ; sans elle
les deux se ressemblent exactement.

**Le critère d'exemption tient en une question :** une story de ce lot, fusionnée
seule, laisserait-elle un utilisateur devant quelque chose d'incomplet ? Si non,
pas de flag. Trois familles répondent non par construction :

- **Refactor et infrastructure** — ils ne changent aucun comportement, donc chaque
  pull request est déployable telle quelle. C'est la définition d'un refactor, pas
  une tolérance qu'on lui accorde.
- **Lot correctif** — il rétablit un comportement déjà promis par la spec ; le
  garder derrière un flag retarderait une mise en conformité.
- **Lot à story unique** — rien n'est jamais à moitié livré.

## Document layout

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

Les patrons de chemins sont anglais et figés ; les slugs suivent la langue du
projet, puisqu'ils nomment des objets métier.

**Le préfixe `NN-` des fichiers de story** garantit l'unicité des basenames. Il est
confortable sur le chemin nominal, où chaque story a son propre worktree, et
nécessaire sur les chemins dégradés — worktree refusé, isolation indisponible — où
deux stories partageraient un checkout : `sdd-workspace` dérive alors le workspace
du basename du plan, et deux `us-1-setup.md` partageraient `progress.md`.

## Number allocation

`NN` (batch) et `us-N` (story) suivent la même règle : le plus petit entier

- non utilisé dans `docs/batches/` **sur `main`**,
- non revendiqué par une **pull request ouverte**,
- non revendiqué par une **branche poussée qui ne porte pas encore de pull
  request**.

Les trois conditions sont nécessaires : un artefact n'atteint `main` qu'à la fusion
de sa pull request, donc le contenu du répertoire ignore tout ce qui est en vol.

Le patron de branche à balayer diffère selon le numéro, parce que le nom d'une
branche dit ce qu'elle revendique : `NN` se cherche contre `batch/*` **et**
`story/*`, puisque `story/NN-us-N-<slug>` porte le numéro de son lot autant que
celui de sa story ; `us-N` se cherche contre `story/*` seul, une branche `batch/*`
ne pouvant revendiquer aucun numéro de story.

## Branch naming

| Type de pull request | Branche |
|---|---|
| Story | `story/NN-us-N-<slug>` |
| Ouverture de batch | `batch/NN-<slug>` |
| Clôture de batch | `batch/NN-<slug>-close` |
| Adoption d'un module | `adopt/<module>` |
| `init` | `chore/supercharlouze-init` |
| Bounded | `fix/<slug>` |

Ce nommage est une convention que le plugin fait respecter lui-même, et non une
propriété de `superpowers:using-git-worktrees` : ce skill préfère les outils natifs
du harnais, qui choisissent le nom de branche, et peut aboutir à un HEAD détaché.
**Aucun mécanisme de ce système ne dépend du nom de branche** — l'identification
passe par la pull request et par le document de story — mais une branche nommée
doit exister pour qu'une pull request puisse être ouverte.

## The spec document

La spec décrit le comportement. **Ni date, ni statut, ni marqueur de travail en
cours.** C'est une propriété du modèle git et non une préférence de style : sur
`main`, la spec et le code avancent dans la même pull request, donc il n'existe
jamais d'état où la spec décrirait quelque chose que le code ne fait pas encore.

- Une table **Changelog** en pied de document porte l'historique
  `batch | date | change`. **Une ligne par batch, écrite par `closing-a-batch`** —
  pas une ligne par story : le changelog est de granularité batch par nature, et le
  faire écrire par chaque story ferait conflicter au même point toutes les stories
  d'un même module en vol simultanément, ce qui est le régime nominal. Les
  modifications faites hors de tout batch portent `out-of-batch` et sont écrites
  par leur propre pull request.
- Une section **Sources** liste les documents validés consommés lors de l'adoption,
  par leur chemin après archivage. Elle est le seul lien persistant entre une spec
  et ce qui l'a nourrie, et l'état des lieux de `init` en dépend.

Le changelog est un confort de lecture, pas un mécanisme : aucune règle ne repose
dessus. L'historique faisant autorité est celui du fichier lui-même
(`git log docs/specs/<module>.md`), exact par construction puisque chaque
changement de spec voyage avec son code.

**Comportement sous flag.** Une section décrivant un comportement encore gardé
énonce son flag, son défaut, et — si la portée dépasse le lot — sa condition de
levée :

```markdown
🔒 `billing.recurring`, off by default — lifted when the `facturation` module is fully delivered
```

La spec reste ainsi exactement vraie : elle décrit non seulement ce que le code
fait, mais ce qu'il expose et sous quelle condition. Cette phrase disparaît quand
le flag est retiré, et c'est un changement de spec comme un autre. La condition de
levée est écrite ici et pas seulement dans le document de lot, parce que c'est ici
qu'on la lit : le document de lot finit par se clore, la spec est relue à chaque
adoption, chaque audit et chaque ouverture de lot.

**La règle de dérive s'énonce alors sans exception :** toute divergence entre la
spec de `main` et le code de `main` est une dérive, donc du travail correctif. Il
n'y a pas de cas « pas encore livré » à excepter, parce que ce cas n'existe pas.

## The gaps register

`docs/specs/<module>.gaps.md` est un document vivant, pas un rapport jetable. Deux
sections distinctes, parce qu'elles ne se traitent pas pareil :

- **Violations** — le code contredit la spec. Alimente un lot correctif.
- **Gaps** — le code fait des choses qu'aucune spec ne décrit. Alimente un lot
  ordinaire qui les spécifie enfin.

Chaque entrée désigne une section de la spec et doit être **un item adressable —
un élément de liste, jamais un paragraphe de prose courante** : trois gestes en
place s'y appliquent, et un registre écrit en paragraphes n'offre rien à annoter,
rien à barrer, et aucun périmètre qu'un lot correctif puisse en tirer.

**Ajouter une entrée** — `adopting-a-module` à la création, puis `closing-a-batch`
seul, qui consolide en une pull request les dérives constatées hors périmètre par
les stories du batch. Les stories **n'ajoutent pas** : elles consignent leurs
constats dans leur propre document, sous **Observed drift**. Un ajout se fait en
fin de section et concurrence tous les autres ajouts du même module — la même
contention que le changelog évite, réglée de la même façon : un seul écrivain par
batch.

**Barrer une entrée existante** — la pull request de la story qui la résorbe, ou
celle d'un bounded. Le geste est local à une ligne déjà écrite, donc deux stories
qui barrent des entrées différentes ne se marchent pas dessus.

Un bounded n'appartient à aucun batch : il ajoute comme il barre, directement, et
ne concurrence qu'un autre bounded.

**Réservation, consommation, libération :**

- **Réservée** par la pull request d'ouverture du batch qui la prend en charge
  (annotation `reserved by batch-NN`).
- **Barrée** par la pull request de la story qui la résorbe, atomiquement avec le
  code qui la résorbe.
- **Libérée** par `closing-a-batch` si elle n'a pas été consommée. Sans cette
  étape, une story abandonnée laisserait sur `main` une réservation perpétuelle
  empêchant tout autre batch de reprendre l'écart : la réservation vit sur `main`,
  et fermer la pull request de la story ne l'emporte pas.

Le registre déclare aussi **sa propre couverture** : quelles parties du module ont
été auditées, lesquelles ne l'ont pas été, et pourquoi. Un registre vide qui
signifie « rien n'a été examiné » ne doit pas ressembler à un registre vide qui
signifie « tout est conforme ».

## The batch document

Un `README.md` avec un front matter `status: open | closed`, et :

- **Scope** — ce que ce batch livre, et pourquoi maintenant.
- **Spec delta** — le comportement ajouté à chaque spec, énoncé comme intention.
  Ce delta n'est transcrit dans aucune spec à l'ouverture : il l'est tranche par
  tranche, par la pull request de chaque story. Pour un lot correctif, ce champ est
  vide et remplacé par les entrées du gaps register que le batch réserve.
- **Feature flag** — le nom du flag, son défaut et sa portée ; ou `none` avec la
  raison de l'exemption. Ce champ est **obligatoire et jamais vide** : « aucun
  flag » doit être une décision énoncée et revue, pas un oubli. Une portée qui
  dépasse le lot **doit nommer sa condition de levée**.

  ```markdown
  Feature flag: `billing.recurring`, off by default — scope: this batch
  Feature flag: `billing.recurring`, off by default — scope: beyond this batch,
                lifted when the `facturation` module is fully delivered
  Feature flag: none — corrective batch, restores behaviour the spec already promises
  ```

**Le document de batch ne porte aucun état mutable**, et rien dans le déroulement
normal ne le modifie. Deux conséquences :

- **La liste des stories n'y figure pas** : elle est le contenu du répertoire du
  batch, complété par les pull requests ouvertes. Une liste maintenue à la main
  produirait un conflit de fusion à chaque story, pour une information que le
  système possède déjà.
- **L'état d'une story n'y figure pas non plus** : l'état d'une story *est* l'état
  de sa pull request. Une case à cocher recopierait une vérité que `gh pr list`
  donne mieux, et se désynchroniserait dès la première pull request fusionnée hors
  session.

Il reste **amendable par une pull request d'amendement**, revue comme les autres.
C'est le chemin de sortie de deux impasses réelles : un lot exempté de flag qui
découvre en chemin qu'il en fallait un, et un lot dont on décide de réduire ou
d'abandonner le périmètre.

## The user story document

Un plan superpowers standard, produit par `superpowers:writing-plans`, enregistré
dans le répertoire du batch, avec un header étendu :

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
**Sections:** Abonnement > Renouvellement, Abonnement > Proration
```

`Spec:` est le champ que `superpowers:subagent-driven-development` lit déjà comme
autorité contraignante ; le faire pointer vers la spec vivante du module est ce qui
fait fonctionner l'intégration sans modifier superpowers.

`Sections:` **est le mécanisme de détection de concurrence**. Il est déclaré et non
déduit : lire un diff pour deviner quelles sections une story touche est fragile,
alors que l'auteur de la story le sait.

Le document porte en outre un **Rulings log** et une section **Observed drift**,
remplis avant la fusion. Les deux sont **créées vides au moment du plan**, en même
temps que le header, et laissées vides si rien n'est venu : une section vide dit
« examiné, rien trouvé », une section absente dit « jamais examiné », et un
reviewer ne la distingue pas d'un oubli.

`Global Constraints` porte deux choses : les contraintes que le batch impose,
recopiées mot pour mot, et le gel du fichier de spec.

**Ce montage n'est correct qu'à trois conditions, toutes load-bearing :**

1. **La transcription est incrémentale** — une tranche par story, jamais le delta
   complet du batch. Sinon la spec décrirait, pendant l'exécution de la story 1, le
   comportement des stories suivantes, et les reviewers de SDD le signaleraient
   comme manquant.
2. **La transcription est le premier commit de la branche**, avant que le plan soit
   écrit et que la moindre tâche s'exécute — non pour une raison de visibilité,
   mais parce que c'est ce qui rend la norme antérieure et opposable au code.
3. **La branche part d'un `main` à jour, depuis le checkout principal.**

## Git model

Deux contraintes du projet, pas des choix de ce plugin, dont tout le modèle
découle :

- **`main` est protégée** : tout passe par une pull request.
- **`main` est déployée en continu** : chaque fusion part en production.

La seconde est la raison d'être des feature flags, et elle écarte les deux
alternatives naturelles. Une branche de lot, ou une branche `develop` façon
gitflow, protégeraient la production en retenant le travail, au prix d'un angle
mort : une story fusionnée dans une branche de lot disparaît des **deux** sources
de la détection de concurrence — sa pull request n'est plus ouverte, et sa branche
`story/*` n'est plus une revendication vivante dès lors que la fusion la supprime —
alors que ce qu'elle a écrit n'a pas atteint `main`. Une branche `develop` fait
pire : elle crée **deux baselines** pour la règle de dérive, et un lot correctif ne
sait plus contre quoi il corrige.

**Une pull request de story porte la tranche de spec et le code qui la réalise**,
livrés ensemble ou pas du tout. C'est ce qui donne à `main` sa propriété centrale :
**sa spec décrit toujours exactement ce que son code fait.** Aucun état
intermédiaire à signaler, donc aucun marqueur, aucune sémantique à faire comprendre
à des agents qui ignorent ce plugin, et aucune exception à la règle de dérive.

**Les gates humains sont des revues de pull request.** Le plugin n'ajoute aucune
cérémonie : il place ses points de validation là où le flux en a déjà.

| Gate | Artefact revu |
|---|---|
| Adoption d'un module | la PR portant la spec et le gaps register |
| Ouverture d'un batch | la PR portant le document de batch |
| Livraison d'une story | la PR portant la tranche de spec et le code |
| Clôture d'un batch | la PR portant changelog, consolidation et `status: closed` |
| Amendement d'un batch | la PR portant la décision de changer son périmètre ou son flag |

**L'abandon d'une story.** Sa pull request est fermée sans fusion s'il y en a une —
le plus souvent il n'y en a pas encore — et **dans tous les cas** sa branche est
supprimée localement **et sur le remote**, worktree compris. La suppression
distante n'est ni un ménage optionnel ni une alternative à la fermeture : le
balayage de concurrence n'écarte que les branches couvertes par une pull request
**ouverte**, donc une branche dont la pull request a été fermée est relue comme une
revendication vivante. Laissée en place, elle réserve ses sections contre toutes
les stories qui suivent, et plus rien ne les libère. Deux résidus subsistent sur
`main`, que la clôture doit constater : la réservation au gaps register posée par
la PR d'ouverture, et l'intention annoncée dans le spec delta et jamais livrée.

**Création de la branche.** Le plugin crée lui-même la branche au nom conventionnel
et son espace de travail, en invoquant `superpowers:using-git-worktrees`. Si ce
skill aboutit à une branche autrement nommée, à un HEAD détaché, ou si l'isolation
est refusée, le plugin s'assure qu'une branche nommée existe avant de continuer.

Un projet organisé en sous-modules git sort du chemin décrit ici et n'est pas
couvert : le Step 0 de `superpowers:using-git-worktrees` y voit
`GIT_DIR != GIT_COMMON` sans qu'il s'agisse d'un worktree.

**Préconditions de toute pull request de ce système, vérifiées avant de créer une
branche :**

- **Être dans le checkout principal.** `superpowers:finishing-a-development-branch`
  préserve le worktree sur le chemin « pull request » ; une session qui enchaîne
  deux stories sans en sortir poserait le code de la seconde sur la branche de la
  première.
- **Être sur `main`, rafraîchie.** Les fusions arrivent depuis le remote : sans
  `fetch`/`pull`, l'attribution des numéros et la détection de concurrence
  raisonnent sur un état périmé.
- **Pour une story : le batch existe et est ouvert** — sa pull request d'ouverture
  est fusionnée et son document porte `status: open`.

**Hypothèse assumée :** `gh` est disponible et authentifié. L'attribution des
numéros et la détection de concurrence l'interrogent ; sans lui, les deux dégradent
vers un filet partiel et ne préviennent plus rien.

## Authority and conflict rules

La spec est l'autorité contraignante. Le batch ne porte que ce qu'une spec ne peut
pas porter : le périmètre de livraison, l'ordre des stories, les contraintes de
migration et de compatibilité, et la raison pour laquelle ce travail a lieu
maintenant.

**Quand un batch et une spec se contredisent, la spec gagne — sans exception et
sans délibération.** L'agent implémente ce que dit la spec, inscrit un `Ruling:`,
et poursuit. **Corriger une spec en cours de batch est un acte humain, jamais un
acte d'agent** : un agent qui « corrige » la spec inverse silencieusement
l'autorité.

**Le gel du fichier de spec, avec un début et une fin :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.

Après l'ouverture de la pull request le gel est levé : les demandes de la revue
sont des décisions humaines, y compris sur la formulation de la tranche de spec. Un
gel sans borne rendrait littéralement impossible de répondre à une revue, ou de
résoudre un conflit de fusion sur ce fichier. La règle est recopiée dans les
`Global Constraints` de chaque plan, donc sous les yeux de chaque implémenteur et
de chaque reviewer.

**Tout conflit est consigné pour l'humain.** On réutilise le mécanisme existant
plutôt que d'en inventer un : `superpowers:subagent-driven-development` tient un
ledger dont les décisions prennent la forme
`Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>`. Ces lignes
sont recopiées dans le document de story, sur la branche de la story, avant la
fusion — elles sont périssables, et le workspace de SDD est déjà supprimé.

## Concurrency detection

Deux stories qui touchent la même section d'une même spec sont un conflit. La
détection est **par déclaration**, et lit **deux sources distantes** :

- les **pull requests ouvertes** touchant le même fichier de spec, dont on lit le
  champ `Sections:` ;
- les **branches `story/*` poussées qui ne portent pas encore de pull request et
  dont le diff contre `main` touche le même fichier de spec**, dont on lit le même
  champ sur leur head ref.

Le second terme n'est pas un raffinement, c'est ce qui rend le mécanisme vrai : la
pull request d'une story n'ouvre qu'à la toute fin de son implémentation, donc s'en
tenir aux pull requests ouvertes rendrait chaque story invisible de ses sœurs
pendant toute cette durée — exactement l'angle mort reproché à la branche de lot,
réintroduit sur le chemin nominal.

Le **filtre par fichier de spec** est le même sur les deux sources, et il fait
partie de la règle : sans lui, l'étape ordonnerait de lire toutes les branches de
story du dépôt et de s'arrêter à la première illisible, y compris sur des modules
que cette story ne touche pas.

**La déclaration `Sections:` se lit là où la pull request la tient** : dans le
document de story pour une story, dans le corps de la pull request pour un bounded,
qui n'a pas de document de story. Chercher le champ au seul endroit prévu pour les
stories ferait de chaque bounded ouvert une déclaration illisible, et arrêterait
toutes les stories tant qu'un bounded reste ouvert.

**Il faut s'arrêter** si l'intersection avec les sections visées n'est pas vide, et
**s'arrêter aussi si un champ `Sections:` n'a pas pu être lu** — fetch en échec,
document absent, champ manquant. Un champ non lu est un inconnu, pas un feu vert.
Le cas d'une branche poussée dont le document de story n'existe pas encore est un
inconnu au même titre, et arrête pareillement ; cette fenêtre dure le temps
d'écrire un plan.

**L'angle mort est nommé, pas nié :** ce filet voit ce qui est sur le remote, ni
plus ni moins, et une branche créée mais non poussée reste invisible. Le dire est
la moitié du mécanisme.

**Le conflit de fusion git n'est qu'un filet partiel** — git conflicte sur des
lignes, pas sur des sections, donc deux stories modifiant la même section à des
endroits éloignés fusionnent proprement.

## Opening a batch

`supercharlouze:writing-a-batch` doit :

1. Vérifier que chaque module touché possède une spec adoptée ; sinon l'adoption
   est un **préalable bloquant**.
2. Attribuer `NN`.
3. Rédiger le document de batch : scope, spec delta comme intention, champ
   `Feature flag`.
4. **Réserver dans le gaps register toute entrée que ce lot prend en charge** —
   lot correctif puisant dans *Violations* comme lot ordinaire puisant dans
   *Gaps*. La réservation est une propriété de la pull request d'ouverture de
   quelque lot que ce soit, et elle existe pour que deux lots ne puissent pas
   tirer la même entrée. **Aucune écriture dans les specs à ce stade.**
5. **Faire remonter les flags vivants — au niveau du module, pas de la section.**
   Lister toute phrase de gating présente dans les specs des modules que ce lot
   touche, quelles que soient les sections visées, et la reporter dans le document
   de batch avec sa condition de levée. L'humain tranche au gate : ce lot
   satisfait-il la condition, et porte-t-il donc la story de levée ?
6. Ouvrir la pull request du batch.

La granularité de la remontée est ce qui rend le contrôle utile : limitée aux
sections que le lot modifie, elle laisserait un flag à portée étendue survivre
indéfiniment, puisque le dernier lot d'un module ajoute typiquement des sections
neuves sans toucher les anciennes.

**La revue de cette pull request est le gate humain** : tant qu'elle n'est pas
fusionnée, aucune story ne s'écrit.

## Running a batch

Les user stories sont écrites **une par une** — la story N+1 en connaissant ce
qu'a produit la story N — mais plusieurs peuvent être en vol simultanément, ce qui
est le régime normal d'un flux par pull request.

`supercharlouze:writing-a-user-story` doit, pour chacune :

1. **Vérifier les préconditions** — checkout principal, `main` rafraîchie, batch
   ouvert.
2. **Détecter la concurrence** sur les deux sources.
3. **Attribuer `us-N`** et **créer la branche**.
4. **Commiter la tranche du delta propre à cette story** — premier commit de la
   branche — **puis pousser la branche immédiatement**. Le push la rend visible de
   ses sœurs et réduit l'angle mort de la durée d'une implémentation à celle d'un
   seul commit. Si le lot déclare un feature flag, la tranche transcrite énonce le
   flag et son défaut.

   **Cas correctif :** le delta étant vide, ce premier commit ne touche pas la
   spec ; il barre l'entrée du gaps register que la story résorbe, ce qui joue le
   même rôle — fixer le périmètre dans l'histoire de la branche avant que le code
   commence.
5. **Appeler `superpowers:writing-plans`**, en portant dans `Global Constraints`
   les contraintes du batch et le gel du fichier de spec. Puis **commiter le
   document de story — header, les deux sections vides et `Global Constraints` —
   et le pousser immédiatement**, avant que l'exécution démarre. Jusqu'à ce push,
   la branche est sur le remote sans déclarer aucune section, et une sœur qui la
   trouve doit s'arrêter sur un inconnu.
6. **Exécuter par `superpowers:subagent-driven-development`**, qui conclut sur
   `superpowers:finishing-a-development-branch`, dont le choix est contraint à la
   pull request.
7. **Avant fusion**, recopier les lignes `Ruling:` du message final de SDD dans le
   Rulings log, et consigner sous **Observed drift** les dérives constatées hors
   périmètre. Ces informations sont périssables et sont poussées sur la branche.
8. **Répondre à la revue** — le gel est levé, et le worktree est préservé sur ce
   chemin, donc l'itération s'y fait.

La story est livrée quand sa pull request est fusionnée. Il n'y a rien à cocher ni
à réconcilier : son état *est* l'état de sa pull request.

## Lifting a feature flag

La story de levée supprime le branchement dans le code et la phrase de gating dans
la spec — donc du code et une tranche de spec, dans une pull request : exactement
la forme d'une story, sans mécanisme nouveau. C'est elle qui met la fonctionnalité
en production.

**Une story de levée par flag, donc par module.** Un lot transverse gardant deux
modules en écrit deux, et chacune respecte l'invariant « une story, un module ».

Elle est la dernière story du lot quand le flag est à portée de lot. Quand la
portée est étendue, elle appartient au lot qui satisfait la condition de levée
déclarée — ce n'est pas au lot courant de le deviner, c'est la remontée des flags
vivants au gate d'ouverture qui le fait trancher par l'humain.

Elle est **une story et non un devoir de clôture** parce qu'elle porte du code, et
que du code mérite une revue et un cycle de tests. Une période d'observation entre
activation et nettoyage se modélise en deux stories — activer, puis retirer — sans
rien changer au modèle.

## Closing a batch

Quand toutes les stories du batch sont fusionnées ou abandonnées et que l'humain
considère le batch terminé, `supercharlouze:closing-a-batch` produit une pull
request de clôture qui :

1. **Écrit la ligne de changelog** de chaque spec touchée — un batch, une ligne.
2. **Consolide dans le gaps register** les sections `Observed drift` des stories du
   batch.
3. **Libère les réservations non consommées.**
4. **Constate les intentions non livrées** : si le spec delta annoncé à l'ouverture
   n'a pas été entièrement transcrit, l'écart est inscrit au gaps register comme
   *gap*, et le texte du batch est amendé pour ne plus promettre ce qu'il n'a pas
   livré. Sans cette étape, l'abandon d'une story serait invisible : ni dérive, ni
   gap, juste une promesse oubliée dans un document clos.
5. **Vérifie qu'aucun flag du lot ne subsiste par accident.** Un flag encore
   présent — dans le code ou comme phrase de gating dans une spec — n'est
   acceptable que si sa portée étendue et sa condition de levée sont déclarées.
   Sinon la story de levée n'a pas été écrite et le lot **ne peut pas être clos**.
6. **Passe `status: closed`.**

**Trois sorties, pas une impasse.** Un lot dont on renonce au périmètre alors que
des stories gardées sont déjà sur `main` ne doit pas rester ouvert à jamais.
L'humain choisit : écrire la story de levée et livrer ce qui existe ; déclarer au
flag une portée étendue par une pull request d'amendement, ce qui reporte la
décision à un lot ultérieur ; ou écrire une **story de démontage** qui retire le
code gardé et la tranche de spec correspondante. Sans ces trois sorties, le refus
de clore fabriquerait précisément le code mort sous flag qu'il existe pour
empêcher.

Cette pull request est revue comme les autres : la clôture acte une décision
humaine.

## Module adoption

`supercharlouze:adopting-a-module` établit la vérité dont tout le reste dépend, et
c'est l'opération la plus délicate du système. Elle produit une pull request
portant deux documents et aucun code : la spec et le gaps register.

**Ordre d'autorité des sources :**

1. **Les documents validés** sont normatifs. Ils font la vérité.
2. **Le code** ne corrige jamais un document. Il comble les *silences* des
   documents — les comportements qu'aucun document n'a jamais décrits — et ce qu'il
   y révèle n'entre pas dans la spec de sa propre autorité : c'est un gap, que seul
   l'humain peut promouvoir en spécification.
3. **L'humain** tranche les contradictions.

**Reconstruire une spec depuis le code est explicitement écarté** : une spec écrite
depuis le code est une spec qu'aucun code ne peut contredire. La dérive devient
canon à l'instant où on l'écrit, les violations deviennent indétectables par
construction, et les lots correctifs perdent la baseline qui les rend possibles.

**Étapes :**

1. **Délimiter le module** — l'humain le nomme et en trace les contours, jamais le
   skill. On peut lui montrer ce qui existe comme matière, mais pas proposer de
   découpage : une suggestion se lit comme une décision.
2. **Inventorier les documents validés** qui le couvrent — anciens design docs
   superpowers, README, docs métier, ADR. Présenter la liste à l'humain **avant**
   d'écrire quoi que ce soit, pour qu'il puisse ajouter une source manquante ou en
   écarter une qui n'a jamais été validée. La qualité de la spec est plafonnée par
   cet inventaire. L'inventaire retenu est enregistré dans la section `Sources`.
3. **Créer la branche `adopt/<module>`** et son espace de travail, comme toute
   pull request de ce système.
4. **Écrire la spec depuis ces documents seuls.** Fusion, déduplication, mise en
   cohérence. Quand deux documents validés se contredisent, le plus récent l'emporte
   par défaut, et l'arbitrage est consigné comme ruling — jamais résolu en silence.
   L'adoption n'ayant pas de document de story, ces rulings vivent dans **le corps
   de la pull request d'adoption**.
5. **Auditer le code contre la spec** et produire le gaps register, avec ses deux
   sections et sa couverture déclarée. Ne rien corriger au passage : résorber une
   entrée est un lot à part entière, avec sa propre revue.
6. **Ouvrir la pull request d'adoption.** Sa revue est le gate humain, et il n'y en
   a pas d'autre. **Tant qu'elle n'est pas fusionnée, le module n'est pas adopté et
   aucun batch ne peut démarrer dessus.**

**Cas dégradé — un module sans aucun document validé.** L'adoption depuis les
documents est impossible et la reconstruction depuis le code reste écartée. Le
skill bascule en dialogue : il énumère les comportements trouvés dans le code,
groupés en sections candidates, et demande à l'humain **section par section**,
« est-ce voulu ? ». Ce que l'humain valide devient la spec ; le reste part en gaps.
La question se pose section par section parce qu'un mur de questions reçoit un
« oui » global en retour, et un oui global est de la reconstruction depuis le code
avec des étapes en plus. La section `Sources` enregistre alors qu'aucun document
validé n'existait, plutôt que de rester muette. Le même traitement s'applique à un
inventaire partiel : la partie couverte suit les étapes 2 à 5, la partie non
couverte suit ce dialogue.

## Skills

| Skill | Trigger | Produit |
|---|---|---|
| `using-batches` | point d'entrée, cité par le bloc `CLAUDE.md` | le routage, le vocabulaire, les règles d'autorité, les overrides déclarés |
| `adopting-a-module` | premier batch touchant un module sans spec | la PR d'adoption : spec (avec ses `Sources`) + gaps register |
| `writing-a-batch` | ouverture d'un batch, amendement, ou requalification | la PR de batch : `NN`, scope, spec delta, `Feature flag`, réservations, flags vivants remontés |
| `writing-a-user-story` | une story à écrire, y compris levée ou démontage | la PR de story : tranche de spec, plan, code, rulings, observed drift |
| `closing-a-batch` | toutes les stories fusionnées ou abandonnées | la PR de clôture : changelog, consolidation, libérations, constats, contrôle des flags, `status: closed` |

Quatre skills productifs, un de routage. Le cycle d'une story tient dans un seul
skill parce que la pull request porte son état : il n'y a ni enregistrement à
rapatrier après coup, ni réconciliation à faire tourner.

## Routing and precedence

La préséance sur superpowers s'obtient par le `CLAUDE.md` du projet, parce que
c'est le levier que superpowers concède explicitement :
`superpowers:using-superpowers` se termine par « User instructions (CLAUDE.md,
AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills ». Ce pari
est solide parce que le hook `SessionStart` de superpowers injecte l'intégralité de
`using-superpowers` au démarrage de chaque session, cette phrase comprise — la
concession n'attend donc pas qu'un skill soit chargé.

`superpowers:writing-plans` porte en outre une concession directe sur
l'emplacement des plans, sur laquelle le bloc s'appuie pour les déplacer vers
`docs/batches/`. `superpowers:brainstorming` porte la même concession pour
l'emplacement des specs, mais elle est **sans objet ici** : l'Override 1 remplace
l'étape qui écrirait ce document, donc il n'y a aucun emplacement à relocaliser.

**Un hook `SessionStart` propre au plugin est écarté** : l'ordre entre les hooks de
deux plugins n'est pas spécifié, ce qui laisserait deux blocs `EXTREMELY_IMPORTANT`
concurrents et produirait des échecs intermittents.

**Le bloc `CLAUDE.md`** inséré par `/supercharlouze:init` est délibérément minuscule
et stable. Il doit :

- demander l'invocation de `supercharlouze:using-batches` **avant toute conception
  et avant l'exécution de tout plan** — sans quoi `using-batches` n'est pas en
  contexte quand ses règles d'exécution doivent s'appliquer ;
- **énumérer les quatre overrides, sans en omettre un.** Le bloc est le seul
  artefact garanti en contexte, et ce qu'il affirme l'emporte sur un skill chargé à
  la demande : un override absent du bloc serait exactement aussi fragile qu'un
  override non déclaré ;
- affirmer que là où aucun override n'est déclaré, superpowers s'applique inchangé.

Le bloc vit dans **un seul fichier**, `skills/using-batches/references/claude-md-block.md`,
et c'est de là que le script d'init le lit. Aucune autre copie n'existe dans le
plugin — une seconde dériverait de la première.

## What is kept, what is rerouted

La classification spike / bounded / architectural de `superpowers:brainstorming`
est **conservée telle quelle** : elle est orthogonale à ce modèle, et elle est
bonne. Seule la queue du chemin architectural est déviée.

**Spike** — inchangé. Une réponse, aucun artefact.

**Bounded** — cérémonie inchangée, avec quatre règles :

- **(a) Il ne laisse jamais la spec muette.** Qu'il *altère* un comportement déjà
  décrit ou qu'il en *ajoute* un que nulle spec ne décrit, sa pull request met la
  spec à jour en même temps que le code, avec une ligne de changelog
  `out-of-batch`. Traiter seulement le cas « altère » rouvrirait le même trou un
  cran à côté.
- **(b) Il subit la même détection de concurrence qu'une story**, et déclare donc
  ses sections **dans le corps de sa pull request**, faute de document de story.
  Son propre angle mort est nommé et accepté : entre son premier commit et
  l'ouverture de sa pull request, rien ne porte sa déclaration. On le tolère parce
  qu'un bounded *est* une pull request, sans longue phase d'implémentation
  derrière elle — là où la fenêtre d'une story durait une implémentation entière.
- **(c) Il ne porte aucun feature flag** : il est complet dans sa propre pull
  request, donc il satisfait le critère d'exemption par construction.
- **(d) Il écrit directement dans un gaps register** : n'appartenant à aucun batch,
  il peut y ajouter comme y barrer une entrée depuis sa propre pull request, et ne
  concurrence qu'un autre bounded.

Pas de batch, pas de user story : un bounded est déjà une pull request, il porte
simplement sa mise à jour de spec. Sa branche est `fix/<slug>`.

**Architectural** — les **étapes 6 à 9** de la checklist architecturale sont
remplacées par `supercharlouze:writing-a-batch`, qui peut d'abord exiger
`supercharlouze:adopting-a-module` comme préalable bloquant. Les étapes 1 à 5 —
contexte, questions, approches, design présenté par sections, approbation — sont
**conservées intactes** : c'est le travail de conception lui-même, et il n'a aucune
raison de changer.

## Declared overrides

superpowers énonce plusieurs de ses règles comme fermées. Une exception implicite à
une règle marquée « et seulement celles-ci » ne survivra pas à une session sous
pression : chacune doit donc être **nommée comme un override**, dans
`using-batches` et dans le bloc `CLAUDE.md`, avec sa justification. **Il y en a
quatre, et il ne doit jamais y en avoir une cinquième non déclarée.**

La clause d'ouverture du bloc — « it relocates specs and plans » — n'est pas un
override, ce qui laisse le compte à quatre : `superpowers:writing-plans` concède
explicitement l'emplacement des plans, et l'emplacement des specs n'a besoin
d'aucune concession puisque l'Override 1 supprime l'étape qui écrirait le document
à relocaliser.

### Override 1 — steps 6 to 9 of the architectural checklist

La checklist architecturale de `superpowers:brainstorming` se termine par quatre
étapes : **6.** écrire le design doc daté, **7.** self-review, **8.** revue humaine
de la spec écrite, **9.** transition vers `writing-plans`. Le skill verrouille la
neuvième — « Architectural: the ONLY skill you invoke after brainstorming is
writing-plans », redoublé par « Do NOT invoke any other skill ».

**Cet override remplace les quatre, pas seulement la dernière.** Ne rerouter que
l'étape 9 laisserait les étapes 6 à 8 s'exécuter, et un design doc daté continuerait
d'être écrit — exactement ce que ce plugin existe pour supprimer. C'est un seul
override, correctement délimité : la substitution porte sur un bloc terminal
cohérent.

**Le substitut peut lui-même être bloqué.** Quand un module touché n'a pas de spec,
`supercharlouze:writing-a-batch` traite `supercharlouze:adopting-a-module` comme un
préalable bloquant. Cela n'élargit rien : l'override porte toujours sur les étapes
6 à 9 et rien d'autre.

*Justification :* `writing-a-batch` n'est pas un skill d'implémentation — la
catégorie que la règle de l'étape 9 protège — mais un substitut à l'étape
documentaire qui précède `writing-plans`, lequel reste appelé depuis
`writing-a-user-story`. Et la substitution préserve chacune des étapes remplacées :
l'étape 6 devient le document de batch, la 7 sa relecture avant ouverture, et la 8
devient la revue de la pull request de batch. La revue humaine n'est pas supprimée,
elle change d'outil.

### Override 2 — fifth stop condition (corrective batches)

`superpowers:subagent-driven-development` énonce « Four things stop you, and only
these ». Ce plugin en ajoute une, pour les lots correctifs seulement :

> Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
> **spec** qui a tort et le code qui a raison, arrête-toi. Le batch n'est plus
> correctif et doit être requalifié.

*Justification :* les quatre conditions supposent qu'une autorité valide existe.
Ici c'est l'autorité elle-même qui est en cause, et un agent ne peut pas corriger
une spec.

**Procédure de requalification**, portée par `supercharlouze:writing-a-batch`.

**Elle ne commence pas par fermer une pull request**, parce qu'il n'y en a
normalement pas encore : cette condition se déclenche *à l'intérieur* de SDD, en
pleine implémentation, alors que la pull request de la story n'ouvre qu'à la toute
fin. Ce qui existe est une branche poussée et un worktree. La story est donc
abandonnée : sa pull request est fermée sans fusion s'il y en a déjà une, et dans
tous les cas la branche est supprimée localement **et sur le remote**, worktree
compris, une fois la requalification tranchée. Rien n'a atteint `main` — la tranche
de spec, ou l'entrée barrée du gaps register, meurt avec la branche ; la
réservation, elle, vit sur `main` et n'est pas concernée.

Puis l'humain tranche : soit il corrige la spec — lui seul le peut — et le lot
reste correctif sur un périmètre réduit ; soit le lot est réécrit comme lot
ordinaire, avec un spec delta, par une **pull request d'amendement** sur le document
existant. **Cette réécriture garde `NN` et son répertoire** : le numéro identifie
une unité de livraison, et les stories déjà fusionnées vivent dessous — un numéro
neuf les laisserait orphelines. Elle repasse par la revue d'ouverture. Un `NN` neuf
n'est attribué que si l'humain juge le travail restant être un *autre* lot, et
celui-ci est alors clos plutôt que laissé ouvert. Dans les deux cas les
réservations au gaps register sont révisées.

### Override 3 — imposed execution mode

`superpowers:writing-plans` se termine en proposant à l'humain un choix entre
`subagent-driven-development` et `executing-plans`. Ce plugin impose SDD et ne
présente pas le choix.

*Justification :* le rapatriement des rulings dépend du ledger de SDD ;
`executing-plans` n'en tient pas, et la trace des arbitrages — seul témoignage des
endroits où la spec était ambiguë — serait perdue.

### Override 4 — finishing-a-development-branch constrained to the pull request

`superpowers:finishing-a-development-branch` présente trois options — merge local,
pull request, garder la branche — et attend un choix humain. Sur le chemin story,
ce plugin contraint le choix à **« Push and create a Pull Request »**.

**« Merge back locally » est activement destructrice.** Elle fusionne sur la `main`
**locale**, lance les tests, puis **supprime le worktree et la branche**. Elle ne
pousse jamais, donc rien n'échoue sur le moment : le travail se retrouve dans un
commit local qui ne pourra jamais atteindre le remote, et la branche qui aurait
porté une pull request n'existe plus. Le rapatriement des rulings n'a jamais lieu
non plus, puisqu'il se fait sur la branche avant fusion.

**« Keep the branch as-is » n'est pas destructrice** et reste compatible avec une
`main` protégée — elle est simplement hors flux : sans pull request, la story n'a
pas d'état observable et ne sera jamais livrée.

Cet override retire donc un choix qui ne peut pas aboutir, et un choix qui n'aboutit
nulle part.

**Ce qui n'est délibérément pas un override :** l'état terminal de SDD. Rien n'est
intercalé entre SDD et `finishing-a-development-branch` — ce qui est contraint,
c'est ce que ce dernier propose. La réutilisation du worktree existant par le Step 0
de `superpowers:using-git-worktrees` n'en est pas un non plus : c'est son
comportement documenté.

## The init command

`/supercharlouze:init` est **idempotente** et **n'adopte jamais rien**. Comme tout
le reste, elle produit une pull request, sur la branche
`chore/supercharlouze-init`. Elle doit :

1. Créer `docs/specs/`, `docs/batches/`, `docs/archive/`.
2. Déplacer `docs/superpowers/specs/` vers `docs/archive/specs/` et
   `docs/superpowers/plans/` vers `docs/archive/plans/`, en conservant les noms de
   fichiers. La structure est fixée ici parce que le point 4 en dépend : `Sources`
   enregistre les chemins d'archive, et la correspondance doit être exacte.
3. Insérer le bloc `CLAUDE.md`, ou le mettre à jour sur place s'il est déjà
   présent, **sans jamais le dupliquer**. Fonctionne aussi bien sur un projet qui a
   déjà un `CLAUDE.md` que sur un projet qui n'en a pas.
4. Rendre l'état des lieux : quels modules sont adoptés — une spec existe dans
   `docs/specs/` — et quels documents archivés ne figurent dans la section
   `Sources` d'aucune spec. C'est ce qui rend ce calcul décidable plutôt qu'affaire
   d'heuristique.

**Elle ne propose aucun découpage en modules** : c'est réservé à l'humain, et une
suggestion serait lue comme une décision.

## Language

La frontière ne passe pas entre les documents, elle passe **à l'intérieur** de
chaque document : ossature en anglais, prose dans la langue du projet.

- **L'ossature est anglaise, partout** — titres de sections, noms de champs,
  libellés de templates, valeurs de front matter (`status: open | closed`), en-têtes
  de tableaux, patrons de chemins et de branches, noms de skills et de commandes.
  Cela vaut pour le plugin comme pour les documents qu'il produit.
- **La prose est dans la langue du projet** — corps des exigences, descriptions,
  justifications, et les slugs de fichiers et de répertoires, qui nomment des objets
  métier.
- **Le plugin lui-même est intégralement anglais** — skills, commandes, README,
  bloc `CLAUDE.md`, messages. Il n'a pas de prose métier ; il n'a que de l'ossature.

C'est le « feeling superpowers » conservé : un document de ce système se lit comme
un document superpowers, avec du contenu dans la langue du projet. L'ossature
anglaise que `superpowers:writing-plans` impose aux stories n'est alors plus une
exception subie — c'est la règle générale, déjà appliquée.

## Verification

**Contrôles structurels uniquement**, automatisés et bon marché :

- `plugin.json` est valide.
- Chaque `SKILL.md` a un front matter avec `name` et `description`.
- Les chemins cités d'un skill à l'autre existent.
- Le bloc `CLAUDE.md` s'insère proprement dans un fichier existant, dans un projet
  sans `CLAUDE.md`, et ne se duplique pas à la deuxième exécution.
- Chacun des quatre overrides est présent et nommé **à la fois** dans
  `using-batches` et dans le bloc `CLAUDE.md`.

**Ce qui n'est pas testé, et qui est donc un pari assumé :**

- La solidité du levier `CLAUDE.md` pour le routage — le point de rupture le plus
  probable de la conception.
- Le respect du gel du fichier de spec par les implémenteurs de SDD. La règle
  voyage dans `Global Constraints`, donc sous leurs yeux, mais rien ne garantit
  qu'elle soit suivie.
- Le respect de l'Override 4 au moment où `finishing-a-development-branch` présente
  son menu.

## Sources

- `docs/archive/specs/2026-09-03-supercharlouze-design.md` — document de conception
  du plugin, validé le 2026-09-03 et amendé le 2026-09-04 après livraison de la
  v1 ; il couvre l'intégralité du module.
- `README.md` — description publique du plugin : installation, table des skills,
  commande de test, prérequis. Document validé, jamais archivé, donc listé à son
  chemin vivant.

## Changelog

| batch | date | change |
|---|---|---|
