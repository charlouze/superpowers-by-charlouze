---
status: closed
---

# 09 — Quand aucune règle ne bouge

## Scope

**Un travail purement technique n'a pas de forme dans ce flux.** Un bump de
dépendance, un renommage interne, un refactor préparatoire ne déplacent aucune
règle — la spec le dit déjà, « une règle ne bouge pas quand un mécanisme bouge » —
et pourtant rien ne dit où ce travail vit. Trois constats, tous lisibles sur
`main` :

- Le changement borné **ne laisse jamais la spec muette**, et les deux cas qu'il
  énumère supposent l'un et l'autre un comportement changé. Un agent qui bute sur
  le troisième n'a que deux sorties, toutes deux mauvaises : inventer une phrase de
  spec, ce qui canonise la dérive, ou écarter la règle en silence, et alors plus
  rien ne s'applique — ni ligne de changelog, ni déclaration de sections.
- Le critère d'exemption de flag nomme une famille **« Refactor et
  infrastructure »**, alors que le champ `Spec delta` n'a que deux formes : des
  blocs, ou les entrées du gaps register qu'un lot correctif réserve. Cette famille
  est donc nommée sans être documentable.
- Une story dont le premier commit ne touche pas le fichier de spec **est invisible
  de la détection de concurrence**, dont le filtre ne retient que les branches dont
  le diff touche ce fichier. Le gaps register porte déjà ce constat pour la story
  d'un lot correctif ; une story technique héritait du même silence.

Ce lot donne sa forme à ce travail. **Un seul terme neuf** — la **story technique**,
légale dans n'importe quel lot, déclarée dans son en-tête et rattrapée par une
**condition d'arrêt** qui empêche « purement technique » de devenir la porte par
laquelle un comportement entre sans gate. Un filtre de détection **par nom de
branche**, qui rend visibles les stories dont la pull request ne touche aucune spec
et résorbe l'entrée du registre que ce lot réserve. Et la règle du changement borné
portée à **trois cas**, pour que le travail technique d'une seule pull request reste
où il est.

**Il ferme aussi une supposition que le document porte partout sans la dire :** que
toute story livre une modification de spec. L'appariement spec + code est affirmé
sans condition à trois endroits, le gel du fichier de spec est ancré sur un commit
de transcription, et l'un et l'autre sont **déjà faux aujourd'hui** d'une story de
lot correctif, dont la pull request ne touche aucune spec. Le lot les corrige par la
négation — « ne porte jamais l'un sans l'autre » — plutôt qu'en énumérant les cas,
parce qu'une négation ne vieillit pas au cas suivant.

**Pourquoi maintenant.** Le refactor préparatoire est le cas fréquent, pas le cas
rare : il se présente dans tout lot dont le code n'est pas prêt à recevoir le
comportement, et il n'a aujourd'hui que deux sorties, se cacher dans une story de
comportement ou partir en changement borné hors de tout lot. La PR #34 a déjà livré
le README hors lot faute de spec touchée : le précédent est pris en fait, il vaut
mieux qu'il soit spécifié.

## Spec delta

Tous les blocs visent `docs/specs/supercharlouze.md`.

### D1 — `The model`

Remplacer :

```markdown
**Story** (`user story`) — le plan d'implémentation d'une part d'un lot, qui vise un
seul module et se livre en une pull request.
```

par :

```markdown
**Story** (`user story`) — le plan d'implémentation d'une part d'un lot, qui vise un
seul module et se livre en une pull request.

**Story technique** (`technical story`) — une story qui ne change rien d'observable
à la frontière de son module. C'est une qualification déclarée, que sa condition
d'arrêt rattrape si elle se révèle fausse.
```

### D2 — `The model`

Remplacer :

```markdown
**Lot** (`batch`) — l'unité de livraison : un ensemble de stories qui ajoute du
comportement à une ou plusieurs specs.
```

par :

```markdown
**Lot** (`batch`) — l'unité de livraison : un ensemble de stories qui vise une ou
plusieurs specs.
```

### D3 — `Batch > The batch document`

Remplacer :

```markdown
  fait par un bloc qui retire sa mention : c'est une modification de spec comme une
  autre. Pour un lot correctif, ce champ est vide et remplacé par les entrées du
  gaps register que le lot réserve.
```

par :

```markdown
  fait par un bloc qui retire sa mention : c'est une modification de spec comme une
  autre. **Ce champ n'est jamais laissé blanc** : il porte les blocs du spec delta ;
  ou, quand le lot n'en a aucun, les entrées du gaps register qu'il réserve, ou
  `none` suivi de la raison.
```

### D4 — `Feature flags`

Remplacer :

```markdown
- **Refactor et infrastructure** — ils ne changent aucun comportement.
```

par :

```markdown
- **Un lot dont toutes les stories sont techniques** — aucune ne change ce qui est
  observable à la frontière de son module.
```

### D5 — `Story > The user story document`

Remplacer :

```markdown
`Sections:` déclare les sections que la story touche, et c'est ce que lit la
détection de concurrence. Il est déclaré par l'auteur de la story, jamais déduit
d'un diff.

`Blocks:` déclare les blocs du spec delta que la story transcrit, et c'est ce que
lit la clôture pour constater les blocs non livrés. Il vaut `none` pour une story
qui n'en transcrit aucun — une story de lot correctif, une story de démontage.
```

par :

```markdown
`Sections:` déclare les sections que la story touche, et c'est ce que lit la
détection de concurrence. Il est déclaré par l'auteur de la story, jamais déduit
d'un diff.

`Blocks:` déclare les blocs du spec delta que la story transcrit, et c'est ce que
lit la clôture pour constater les blocs non livrés. Il vaut `none` pour une story
qui n'en transcrit aucun — une story de lot correctif, une story technique, une
story de démontage.

**Une story technique porte `Technical: yes` dans son en-tête**, et ne touche aucune
section : son `Sections:` vaut `none`. Aucune autre story ne porte ce champ.
```

### D6 — `Story > The user story document`

Remplacer :

```markdown
Le document porte en outre un **Rulings log** et une section **Observed drift**,
remplis avant la fusion. Les deux sont **créées vides au moment du plan**, en même
temps que l'en-tête, et laissées vides si rien n'est venu : une section vide
signifie « examiné, rien trouvé ».
```

par :

```markdown
Le document porte en outre un **Rulings log** et une section **Observed drift**,
remplis avant la fusion. Les deux sont **créées vides en même temps que l'en-tête**,
et laissées vides si rien n'est venu : une section vide signifie « examiné, rien
trouvé ».
```

### D7 — `Story > The user story document`

Remplacer :

```markdown
`Global Constraints` porte cinq choses :

1. les contraintes que le lot impose, sa section `Constraints` recopiée mot pour
   mot ;
2. le gel du fichier de spec ;
3. la règle d'autorité — la spec gagne sans délibération, et corriger une spec est
   un acte humain, jamais un acte d'agent ;
4. **dans un lot correctif seulement**, la condition d'arrêt propre au lot
   correctif (`Departures from superpowers`), recopiée intégralement ;
5. **dans une story qui écrit du code gardé par un flag seulement**, les règles du
   code gardé (`Code under a feature flag`), recopiées intégralement — que le flag
   soit déclaré par le lot de la story ou par un autre.
```

par :

```markdown
`Global Constraints` porte :

1. les contraintes que le lot impose, sa section `Constraints` recopiée mot pour
   mot ;
2. le gel du fichier de spec ;
3. la règle d'autorité — la spec gagne sans délibération, et corriger une spec est
   un acte humain, jamais un acte d'agent ;
4. **dans un lot correctif seulement**, la condition d'arrêt propre au lot
   correctif (`Departures from superpowers`), recopiée intégralement ;
5. **dans une story qui écrit du code gardé par un flag seulement**, les règles du
   code gardé (`Code under a feature flag`), recopiées intégralement — que le flag
   soit déclaré par le lot de la story ou par un autre ;
6. **dans une story technique seulement**, la condition d'arrêt propre à la story
   technique (`Departures from superpowers`), recopiée intégralement.
```

### D8 — `Story > Delivering a story`

Remplacer :

```markdown
   **Cas correctif :** le delta étant vide, ce premier commit ne touche pas la
   spec ; il supprime l'entrée du gaps register que la story résorbe.
```

par :

```markdown
   **Cas d'une story qui ne transcrit aucun bloc :** ce premier commit porte
   l'en-tête du document de story et ses sections `Rulings log` et `Observed drift`
   vides. Il y joint ce que cette story-là retire : l'entrée du gaps register
   qu'elle résorbe, ou la modification de spec qu'aucun bloc n'annonce. Le plan est
   écrit ensuite dans ce document.
```

### D9 — `Authority and conflict rules`

Remplacer :

```markdown
> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.
```

par :

```markdown
> Entre le premier commit de la branche et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.
```

### D10 — `Story > Concurrency detection`

Remplacer :

```markdown
Deux stories qui touchent la même section d'une même spec sont un conflit. La
détection est **par déclaration**, et lit **deux sources distantes** :

- les **pull requests ouvertes** touchant le même fichier de spec, dont on lit le
  champ `Sections:` ;
- les **branches `story/*` poussées qui ne portent pas encore de pull request et
  dont le diff contre `main` touche le même fichier de spec**, dont on lit le même
  champ sur leur tête.

Le même filtre par fichier de spec s'applique aux deux sources.

**La déclaration `Sections:` se lit là où la pull request la tient** : dans le
document de story pour une story, dans le corps de la pull request pour un
changement borné, qui n'a pas de document de story.
```

par :

```markdown
Deux stories qui touchent la même section d'une même spec sont un conflit. La
détection est **par déclaration**, et lit **deux sources distantes** :

- les **pull requests ouvertes dont la branche est `story/*` ou `fix/*`**, dont on
  lit le champ `Sections:` ;
- les **branches `story/*` poussées qui ne portent pas encore de pull request**,
  dont on lit le même champ sur leur tête.

**Le filtre est le nom de la branche** : seules `story/*` et `fix/*` revendiquent
des sections.

**La déclaration se lit là où la pull request la tient** : dans le document de story
pour une story, où `Spec:` nomme la spec et `Sections:` les sections ; dans le corps
de la pull request pour un changement borné, qui n'a pas de document de story et y
nomme les deux. Une branche poussée qui ne porte pas encore de déclaration concerne
la spec qu'elle a déjà modifiée.
```

### D11 — `Batch > Amending a batch`

Remplacer :

```markdown
Sa branche est distincte de `batch/NN-<slug>`, et son nom est sans signification :
elle ne revendique ni numéro ni section.
```

par :

```markdown
Sa branche ne suit aucun des patrons que ce document définit : elle ne revendique
ni numéro ni section.
```

### D12 — `Departures from superpowers`

Remplacer :

```markdown
- **Un lot correctif a une condition d'arrêt de plus.** L'exécution par
  sous-agents s'arrête aussi sur celle-ci, dans un lot correctif seulement :

  > Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
  > **spec** qui a tort et le code qui a raison, arrête-toi. Le lot n'est plus
  > correctif et doit être requalifié.
```

par :

```markdown
- **Le flux ajoute des conditions d'arrêt.** L'exécution par sous-agents s'arrête
  aussi sur celles-ci. Dans un lot correctif seulement :

  > Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
  > **spec** qui a tort et le code qui a raison, arrête-toi. Le lot n'est plus
  > correctif et doit être requalifié.

  Dans une story technique seulement :

  > Si, en conduisant une story technique, tu découvres qu'elle change quelque chose
  > d'observable à la frontière du module, arrête-toi. La story n'est plus
  > technique.

  Un arbitrage ne remplace ni l'une ni l'autre.
```

### D13 — `Batch > Amending a batch`

Texte inséré après le paragraphe « Un `NN` neuf n'est attribué que si l'humain juge
le travail restant être un *autre* lot… », donc avant « **Conclu par** la fusion de
sa pull request : le lot est amendé. » :

```markdown
**Requalification d'une story technique.** Quand sa condition d'arrêt se déclenche
(`Departures from superpowers`), la story est abandonnée (`Abandoning a story`). Si
l'humain juge le changement observable voulu, il lui faut un bloc, acquis par un
amendement qui repasse la revue d'ouverture ; et un lot exempté de flag parce que
toutes ses stories étaient techniques en déclare un par le même amendement.
```

### D14 — `Batch > The coherence reread`

Remplacer :

```markdown
La relecture de cohérence lit les blocs d'un spec delta contre la totalité de
chaque spec qu'ils touchent, sur l'état qu'ils produiront et sans qu'aucun soit
écrit dans une spec.
```

par :

```markdown
La relecture de cohérence lit les blocs d'un spec delta contre la totalité de
chaque spec qu'ils touchent, sur l'état qu'ils produiront et sans qu'aucun soit
écrit dans une spec. Quand le champ `Spec delta` ne porte aucun bloc, l'ouverture
passe cette étape.
```

### D15 — `Bounded change`

Remplacer :

```markdown
Un changement borné n'a ni lot ni story : c'est une pull request qui porte sa mise
à jour de spec, sur une branche `fix/<slug>`. Quatre règles :
```

par :

```markdown
Un changement borné n'a ni lot ni story : c'est une pull request unique, sur une
branche `fix/<slug>`. Quatre règles :
```

### D16 — `Bounded change`

Remplacer :

```markdown
- **(a) Il ne laisse jamais la spec muette.** Qu'il *altère* un comportement déjà
  décrit ou qu'il en *ajoute* un que nulle spec ne décrit, sa pull request met la
  spec à jour en même temps que le code, avec une ligne de changelog
  `out-of-batch`.
- **(b) Il subit la même détection de concurrence qu'une story**, et déclare donc
  ses sections **dans le corps de sa pull request**. Son angle mort est accepté :
  entre son premier commit et l'ouverture de sa pull request, rien ne porte sa
  déclaration.
```

par :

```markdown
- **(a) Il laisse la spec muette si et seulement si rien d'observable à la frontière
  du module ne change.** Qu'il *altère* un comportement déjà décrit ou qu'il en
  *ajoute* un que nulle spec ne décrit, sa pull request met la spec à jour en même
  temps que le code, avec une ligne de changelog `out-of-batch` ; s'il ne change
  rien d'observable, la spec reste muette et aucune ligne n'est écrite.
- **(b) Il subit la même détection de concurrence qu'une story**, et déclare donc
  **dans le corps de sa pull request** la spec qu'il vise et les sections qu'il
  touche, `none` s'il n'en touche aucune ; une déclaration qui change avant
  l'ouverture refait la détection. Son angle mort est accepté : entre son premier
  commit et l'ouverture de sa pull request, rien ne porte sa déclaration.
```

### D17 — `Authority and conflict rules`

Remplacer :

```markdown
**La pull request d'une story porte sa modification de spec et le code qui la
réalise**, livrés ensemble ou pas du tout. **La spec de `main` décrit toujours
exactement ce que son code fait.** Toute dérive est du travail correctif, sans exception.
```

par :

```markdown
**La pull request d'une story ne porte jamais sa modification de spec sans le code
qui la réalise.** **La spec de `main` décrit toujours exactement ce que son code
fait.** Toute dérive est du travail correctif, sans exception.
```

### D18 — `Authority and conflict rules`

Remplacer :

```markdown
| Livraison | la modification de spec et le code d'une story | la story est livrée |
```

par :

```markdown
| Livraison | le code d'une story, et sa modification de spec s'il y en a une | la story est livrée |
```

### D19 — `Story`

Remplacer :

```markdown
Une story appartient à exactement un lot et vise exactement **un** module, donc une
seule spec. C'est l'unité de livraison technique : **une story, une branche, une
pull request**, et cette pull request porte à la fois sa modification de spec et le
code qui la réalise.
```

par :

```markdown
Une story appartient à exactement un lot et vise exactement **un** module, donc une
seule spec. C'est l'unité de livraison technique : **une story, une branche, une
pull request**, et cette pull request ne porte jamais sa modification de spec sans
le code qui la réalise.
```

### D20 — `Story > Abandoning a story`

Remplacer :

```markdown
branche est supprimée localement **et sur le remote**. Deux résidus subsistent sur
`main`, que la clôture constate : la réservation au gaps register posée par la
pull request d'ouverture, et l'intention annoncée dans le spec delta et jamais
livrée.
```

par :

```markdown
branche est supprimée localement **et sur le remote**. Ce qui subsiste sur `main`,
la clôture le constate : la réservation au gaps register posée par la pull request
d'ouverture, et l'intention annoncée dans le spec delta et jamais livrée.
```

### D21 — `Batch > Opening a batch`

Remplacer :

```markdown
3. Rédige le document de lot : scope, spec delta en blocs de texte exact, champ
   `Feature flag`.
```

par :

```markdown
3. Rédige le document de lot : `Scope`, `Spec delta`, `Constraints`,
   `Feature flag`.
```

### D22 — `Batch > Opening a batch`

Remplacer :

```markdown
**La revue d'ouverture porte sur le texte exact de chaque bloc** : c'est là que
l'humain lit ce que diront les specs, avant qu'aucun code ne s'écrive dessus.
```

par :

```markdown
**La revue d'ouverture porte sur le texte exact de chaque bloc** : c'est là que
l'humain lit ce que diront les specs, avant qu'aucun code ne s'écrive dessus. Quand
le champ `Spec delta` ne porte aucun bloc, elle porte sur ce qui en tient lieu : les
entrées réservées, ou la raison du `none`.
```

### D23 — `Story > The user story document`

Le gabarit de l'en-tête gagne un champ.

Remplacer :

```markdown
**Spec:** docs/specs/<module>.md
**Batch:** docs/batches/NN-<slug>/README.md
**Sections:** <section> > <sous-section>, <section>
**Blocks:** D<n>, D<n>
```

par :

```markdown
**Spec:** docs/specs/<module>.md
**Batch:** docs/batches/NN-<slug>/README.md
**Sections:** <section> > <sous-section>, <section>
**Blocks:** D<n>, D<n>
**Technical:** yes
```

## Constraints

**Ordre des blocs.** `D1` pose le seul terme neuf et précède donc `D4`, `D5`, `D7`,
`D12` et `D13`. `D12` précède `D7` et `D13`, qui renvoient tous deux à la condition
d'arrêt qu'il écrit. Tous les autres sont indépendants.

**Six sections portent plusieurs blocs, dont l'ordre entre eux est libre** : leurs
ancres sont disjointes. `The model` (`D1`, `D2`), `Authority and conflict rules`
(`D9`, `D17`, `D18`), `Batch > Amending a batch` (`D11`, `D13`), `Story > The user
story document` (`D5`, `D6`, `D7`), `Bounded change` (`D15`, `D16`), `Batch >
Opening a batch` (`D21`, `D22`).

**Une seule pull request est en vol** : la clôture du lot 08. Elle écrit une ligne
de changelog au pied de la spec et consolide dans le gaps register — aucun passage
que ce lot cite, mais l'annotation `reserved by batch-09` vit dans ce même fichier
de registre, où un conflit de fusion git est possible. Il se résout sur la branche
de la story.

## Feature flag

Feature flag: none — chaque story livre une norme complète et opposable, et l'ordre
des blocs ci-dessus interdit qu'une règle livrée renvoie à une règle non livrée :
aucune story, fusionnée seule, ne laisse un lecteur de la spec devant une règle
incomplète.
