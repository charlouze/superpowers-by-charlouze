---
status: open
---

# 05 — Une règle, une spec ; un register propre

## Scope

Ce lot répond à deux questions que le flux laisse sans réponse, et qui se
rejoignent sur un point : **où une chose vit, et ce qui reste écrit quand elle
n'a plus lieu d'être.**

**Le domicile d'une règle qui semble valoir pour tous les modules.** Une spec par
module, et rien ne dit où vit une règle qui n'est celle d'aucun. Le dépôt
`charlouze/beacon-hosting`, qui consomme ce plugin, a dû trancher tout seul : son
`CLAUDE.md` énonce qu'« une règle qui vaut pour tous les modules ne vit dans
aucun », et la range dans ses décisions d'architecture. Une règle y échappe alors
à tout ce qui fait l'autorité d'une spec — la revue contre elle, la règle de
dérive, le gaps register, le changelog. Ce lot tranche : **une règle appartient à
une seule spec**, et une règle qui semblerait en concerner plusieurs signale un
découpage de modules à revoir, donc une décision humaine.

Le lot **ne tranche pas** le cas voisin : une décision d'ingénierie qui vaut pour
tout le projet, qu'aucune frontière de module ne rend observable. La spec l'envoie
aujourd'hui au gaps register, comme tout ce que le test de l'autre implémentation
éjecte, et la catégorie *Gaps* promet qu'un lot « les spécifie enfin » — lot qui
réappliquerait le test et la réejecterait. Cette boucle est antérieure à ce lot :
elle part en `Observed drift`, et un lot futur la tranchera.

**Ce que le gaps register garde d'une entrée qui n'est plus.** Le register barre
ses entrées, et une entrée barrée ne porte plus rien : ce que la spec et le code
disent désormais est dans la spec et dans le code. Pire, le barré sert
aujourd'hui de domicile à des décisions qu'il tient mal — celui du plugin compte
une douzaine d'entrées barrées, dont plusieurs portent en commentaire la raison de
leur sortie, et l'une d'elles a été barrée parce qu'elle était **fausse**, geste
que la spec ne décrit pas. Ce lot remplace le barré par la **suppression** : la
pull request qui règle une entrée la retire du fichier et dit dans son corps
pourquoi. Le register ne porte que ce qui est ouvert, et l'histoire d'une entrée
se lit dans celle du fichier. C'est le même esprit que la suppression de la
section `Sources` au lot 03 : ne pas garder dans un document ce qui ne fait plus
référence.

**Pourquoi maintenant.** Les deux sujets sont des silences constatés, pas des
envies. Le premier a déjà coûté : un dépôt consommateur a inventé la règle
manquante, et son gaps register désigne une règle de `CLAUDE.md` là où une entrée
doit désigner une section de spec. Le second a déjà produit une entrée que la
spec ne sait pas relire, et le register du plugin grossit d'un barré à chaque
story.

Le lot résorbe l'entrée *The gaps register* du gaps register — « le registre n'a
pas de vocabulaire pour retirée parce que fausse » —, qu'il rend sans objet : il
n'y a plus de barré à qualifier, seulement des entrées présentes et une pull
request qui dit pourquoi elle en retire une.

## Spec delta

Module `supercharlouze`, une seule spec : `docs/specs/supercharlouze.md`.

### D1 — `Module`

Insérer, juste après :

```markdown
Un module a une spec et un gaps register, qui naissent ensemble à son adoption.
Aucun lot ne touche un module qui n'est pas adopté.
```

le texte :

```markdown
**Une règle appartient à une seule spec.** Une règle qui contraindrait un
comportement observable à la frontière de plus d'un module signale un découpage
de modules à revoir, et le découpage est une décision humaine : l'agent s'arrête
et soumet le cas à l'humain, plutôt que de recopier la règle d'une spec à l'autre
ou de lui chercher un domicile commun. L'emprunt réduit d'un terme
(`The spec document`) n'est pas concerné : il redéfinit un terme, il ne partage
pas une règle.
```

### D3 — `Module > The gaps register`

Remplacer :

```markdown
**Barrer une entrée existante** — la pull request de la story qui la résorbe, ou
celle d'un changement borné.

Un changement borné n'appartient à aucun lot : il ajoute comme il barre,
directement.
```

par :

```markdown
**Supprimer une entrée** — la pull request de la story qui la résorbe, celle d'un
changement borné, ou celle d'une adoption qui promeut un gap en spécification, la
**supprime du fichier**, et **le commit qui la supprime dit pourquoi** : l'entrée
est résorbée, promue, sans objet, fausse, ou écartée par l'humain. Le register ne
porte que ce qui reste à régler ; ce qu'une entrée a été, et pourquoi elle est
partie, se lisent dans l'histoire du fichier
(`git log -p docs/specs/<module>.gaps.md`).

Un changement borné n'appartient à aucun lot : il ajoute une entrée comme il en
supprime une, directement.
```

### D4 — `Module > The gaps register`

Remplacer :

```markdown
- **Réservée** par la pull request d'ouverture du lot qui la prend en charge
  (annotation `reserved by batch-NN`).
- **Barrée** par la pull request de la story qui la résorbe, atomiquement avec le
  code qui la résorbe.
- **Libérée** par la pull request de clôture si elle n'a pas été consommée.
```

par :

```markdown
- **Réservée** par la pull request d'ouverture du lot qui la prend en charge
  (annotation `reserved by batch-NN`).
- **Supprimée** par la pull request de la story qui la résorbe, atomiquement avec
  le code qui la résorbe ; le commit qui la supprime dit pourquoi.
- **Libérée** — son annotation de réservation retirée, l'entrée restant — par la
  pull request de clôture si elle n'a pas été consommée.
```

### D5 — `Story > Delivering a story`

Remplacer :

```markdown
   **Cas correctif :** le delta étant vide, ce premier commit ne touche pas la
   spec ; il barre l'entrée du gaps register que la story résorbe.
```

par :

```markdown
   **Cas correctif :** le delta étant vide, ce premier commit ne touche pas la
   spec ; il supprime l'entrée du gaps register que la story résorbe.
```

### D6 — `Bounded change`

Remplacer :

```markdown
- **(d) Il écrit directement dans un gaps register** : n'appartenant à aucun lot,
  il peut y ajouter comme y barrer une entrée depuis sa propre pull request.
```

par :

```markdown
- **(d) Il écrit directement dans un gaps register** : n'appartenant à aucun lot,
  il peut y ajouter une entrée comme en supprimer une, depuis sa propre pull
  request.
```

### D7 — `Module > The gaps register`

Remplacer :

```markdown
**Ajouter une entrée** — la pull request d'adoption à la création, puis la pull
request de clôture d'un lot seule, qui consolide les dérives constatées hors
périmètre par les stories du lot. Les stories **n'ajoutent pas** : elles consignent
leurs constats dans leur propre document, sous **Observed drift**. Une entrée
s'ajoute à la fin de sa catégorie. Un seul écrivain
par lot.
```

par :

```markdown
**Ajouter une entrée** — la pull request d'adoption à la création, puis la pull
request de clôture d'un lot seule, qui consolide les dérives constatées hors
périmètre par les stories du lot. Les stories **n'ajoutent pas** : elles consignent
leurs constats dans leur propre document, sous **Observed drift**. Une entrée
s'ajoute à la fin de sa catégorie. Un seul écrivain
par lot.

**On lit l'histoire du fichier avant d'ajouter une entrée**
(`git log -p docs/specs/<module>.gaps.md`) : ce qui a déjà été écarté l'a été
pour une raison, écrite dans le commit qui l'a supprimé. Réinscrire un constat
déjà écarté sans dire ce qui a changé depuis, c'est rouvrir une décision que
personne n'a revue.
```

## Constraints

- **Ordre requis.** D3, D4 et D7 visent la même section, `The gaps register` :
  ils sont transcrits dans cet ordre, ou dans la même story. Les autres blocs
  n'imposent aucun ordre.
- **Le gaps register du plugin est nettoyé de ses entrées barrées**, dans la même
  pull request que D3 et D4. Ce que le barré portait en commentaire — résorbée,
  sans objet, fausse — disparaît avec lui ; la pull request dit en une phrase ce
  qu'elle retire et pourquoi. Les réservations `reserved by batch-NN` d'entrées
  non barrées restent telles quelles.
- **L'entrée vivante *Concurrency detection* est reformulée** par cette même pull
  request, et seulement sur ce point : son texte cite « il barre une entrée du
  gaps register », geste que le lot supprime. Son fond ne change pas.
- **Les deux formulations jumelles restent identiques.** La phrase sur l'entrée
  qui « voyage avec le code et meurt avec la branche » vit en double, dans
  `writing-a-batch` et dans `writing-a-user-story`, et rien ne les verrouille
  ensemble : la story qui corrige l'une corrige l'autre.
- **Chaque story met à jour les skills qui appliquent ses blocs**, dans la même
  pull request que sa transcription : `using-batches`, `adopting-a-module`,
  `writing-a-batch`, `writing-a-user-story` et `closing-a-batch` selon les blocs
  qu'elle prend. Une skill qui continuerait de faire barrer une entrée après la
  fusion de D3 est une dérive.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans
  la même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la
  compte pas.
- **La boucle du `Scope` est consignée.** La story qui transcrit D1 l'écrit sous
  `Observed drift` : ce que le test éjecte et qui n'est le gap d'aucun module
  n'a pas de sortie. La clôture l'inscrira au gaps register.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit
  la spec, la constatation part sous `Observed drift` dans le document de story.
- **Le lot 04 est ouvert en parallèle**, et ses blocs restants visent d'autres
  sections que celles de ce lot. Une story de ce lot qui trouverait un passage
  cité déplacé par une story de 04 applique la règle ordinaire : elle ajuste le
  bloc à ce que porte `main`, sans en changer le sens, et le nomme dans sa pull
  request.
- **Hors périmètre** : où vit une idée qui émerge hors du lot en cours,
  l'historique d'une story et le moment du rebase, les stories en parallèle, les
  stories préparées puis lancées en bloc, la conduite à tenir en écrivant du code
  sous flag, Conventional Commits, l'identité GitHub de l'agent, et la refonte du
  `README.md`.
- **Une seule entrée du gaps register est résorbée** : *The gaps register* — « le
  registre n'a pas de vocabulaire pour retirée parce que fausse » —, réservée par
  ce lot et résorbée par D3. Le reste de ce que le lot fait au fichier est du
  ménage, énoncé plus haut : la suppression des entrées barrées et la
  reformulation de l'entrée *Concurrency detection*. Aucune autre entrée n'est
  résorbée, ni ajoutée.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Une story de ce lot, fusionnée seule, ne laisse personne devant quelque chose
d'incomplet. Livrée seule, la règle du domicile (D1) vaut dès qu'elle est lue. Livrée seule, la suppression d'une entrée (D3 à D7) remplace un geste par un
autre, sans état intermédiaire.
