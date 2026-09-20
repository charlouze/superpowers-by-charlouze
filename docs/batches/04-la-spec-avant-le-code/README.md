---
status: closed
---

# 04 — La spec avant le code

## Scope

Ce lot fait **revoir le texte exact de la spec avant que le code se construise
dessus**, et donne un rythme explicite à la fin de chaque revue.

Aujourd'hui, l'humain revoit deux fois ce que dira une spec. À l'ouverture du lot,
il revoit le spec delta, mais seulement comme **intention**. À la livraison d'une
story, il revoit le texte exact, mais **à la toute fin**, avec le code déjà écrit.
Entre les deux, la story transcrit sa part de spec, écrit son plan, exécute et
ouvre sa pull request d'un seul trait. Le texte exact que les sous-agents vont
implémenter n'a donc jamais été lu par l'humain au moment où il compte. Ses
retours arrivent à contretemps : il commente la formulation alors que l'agent est
déjà passé au plan, puis au code.

Le lot livre trois choses :

- **Le spec delta devient du texte exact.** Le document de lot porte, en blocs, le
  texte que les specs recevront, et la revue d'ouverture est celle où l'humain le
  lit. Chaque story choisit, en s'écrivant, les blocs qu'elle transcrit, et les
  transcrit mot pour mot. Le découpage en stories reste décidé story par story :
  aucun bloc n'est rattaché d'avance à une story, et le document de lot ne gagne
  aucune liste de stories.
- **La fin d'une revue a une forme.** Les corrections demandées en revue sont
  poussées en `fixup!`, lisibles sur GitHub. L'accord de l'humain se donne dans la
  conversation ; l'agent fond alors les fixups et annonce la pull request prête.
  L'approbation et la fusion restent des gestes humains : l'agent ne les fait
  jamais.
- **Chaque fusion qui fait d'un document la référence est un moment de vider le
  contexte.** L'agent ne peut pas le faire lui-même : il le dit, et donne le prompt
  à coller après le clear.
- **Une adoption ne partage jamais le contexte de la conception d'un lot.**
  Aujourd'hui, une conception qui découvre un module non adopté enchaîne sur son
  adoption, puis revient au lot : deux travaux dans une même conversation, qui se
  polluent l'un l'autre. La conception s'arrête désormais, et reprend dans un
  nouveau contexte une fois l'adoption fusionnée.

Le lot résorbe aussi l'entrée *Batch / Closing a batch* du gaps register, parce
qu'elle vise la phrase même que ce lot doit relire : « le document de lot ne porte
aucun état mutable, et rien dans le déroulement normal ne le modifie », que la
clôture contredit.

**Pourquoi maintenant.** Parce que le décalage a coûté sur chaque story du lot 03.
La PR #17 a demandé six allers-retours sur des constats que l'humain aurait
tranchés avant l'implémentation s'il les avait vus à temps. La PR #18 a été
fusionnée avec cinq `fixup!` non fondus : l'approbation et la fusion sont arrivées
avant le rebase, faute d'une règle disant quand il a lieu et qui le déclenche. La
CI refuse désormais un `fixup!` non fondu ; il manque la règle qui dit quand le
fondre. Et le travail de ce lot est la condition du suivant : préparer plusieurs
stories puis les exécuter sans intervention suppose que le texte de spec qu'elles
transcrivent ait été revu d'avance.

## Spec delta

Module `supercharlouze`, une seule spec : `docs/specs/supercharlouze.md`. Ce lot
applique déjà la forme qu'il introduit : chaque bloc donne la section visée, puis
le passage actuel et le texte qui le remplace, ou le texte à insérer et l'endroit
où il s'insère. Une story transcrit ses blocs mot pour mot.

### D1 — `The model`

Insérer, juste après la définition de **Lot correctif** :

```markdown
**Bloc** (`delta block`) — l'unité du spec delta d'un lot : une section visée et
le texte exact qu'elle doit recevoir, transcrit mot pour mot par une story.
```

### D2 — `Batch`

Remplacer :

```markdown
**Le document de lot ne porte aucun état mutable**, et rien dans le déroulement
normal ne le modifie. En conséquence :
```

par :

```markdown
**Le document de lot ne porte aucun état mutable**, et rien dans le déroulement
normal ne le modifie avant sa clôture, qui l'amende et le déclare clos. En
conséquence :
```

### D3 — `Batch > The batch document`

Remplacer :

```markdown
- **Spec delta** — le comportement ajouté à chaque spec, énoncé comme intention.
  Ce delta n'est transcrit dans aucune spec à l'ouverture : il l'est story par
  story, chacune dans sa propre pull request. Un lot qui lève un flag déclaré par
  un autre lot le dit ici : la levée retire une mention de flag, c'est une
  modification de spec comme une autre. Pour un lot correctif, ce champ est vide et remplacé par
  les entrées du gaps register que le lot réserve.
```

par :

```markdown
- **Spec delta** — le texte exact que ce lot écrit dans les specs, en **blocs**.
  Chaque bloc porte un identifiant `D<n>`, unique dans le lot, et nomme la spec et
  la section qu'il vise. Pour modifier un passage, il cite le passage actuel puis
  le texte qui le remplace ; pour en retirer un, il le cite ; pour ajouter du
  texte, il donne ce texte et l'endroit où il s'insère. **Aucun bloc n'est rattaché à une story** : c'est la story qui
  choisit, en s'écrivant, les blocs qu'elle transcrit. Une section qui change deux
  fois au cours du lot porte deux blocs, et `Constraints` donne leur ordre. Aucun
  bloc n'est transcrit dans une spec à l'ouverture : chacun l'est par une story,
  dans sa propre pull request. Un lot qui lève un flag déclaré par un autre lot le
  fait par un bloc qui retire sa mention : c'est une modification de spec comme une
  autre. Pour un lot correctif, ce champ est vide et remplacé par les entrées du
  gaps register que le lot réserve.
```

### D4 — `Batch > Opening a batch`

Remplacer :

```markdown
3. Rédige le document de lot : scope, spec delta comme intention, champ
   `Feature flag`.
```

par :

```markdown
3. Rédige le document de lot : scope, spec delta en blocs de texte exact, champ
   `Feature flag`.
```

Puis remplacer :

```markdown
**Conclue par** la fusion de sa pull request : le lot est ouvert. Tant qu'elle n'est
pas fusionnée, aucune story ne s'écrit.
```

par :

```markdown
**La revue d'ouverture porte sur le texte exact de chaque bloc** : c'est là que
l'humain lit ce que diront les specs, avant qu'aucun code ne s'écrive dessus.

**Conclue par** la fusion de sa pull request : le lot est ouvert. Tant qu'elle n'est
pas fusionnée, aucune story ne s'écrit.
```

### D5 — `Batch > Closing a batch`

Remplacer :

```markdown
- **le constat des intentions non livrées** : si le spec delta annoncé à
  l'ouverture n'a pas été entièrement transcrit, l'écart est inscrit au gaps
  register comme *gap*, et le texte du lot est amendé pour ne plus promettre ce
  qu'il n'a pas livré ;
```

par :

```markdown
- **le constat des blocs non livrés** : un bloc du spec delta qu'aucune story
  fusionnée ne déclare dans son champ `Blocks:` est inscrit au gaps register comme
  *gap*, et le texte du lot est amendé pour ne plus promettre ce qu'il n'a pas
  livré ;
```

Puis remplacer :

```markdown
**Un lot correctif n'a pas d'intention non livrée à constater** : son spec delta
est vide.
```

par :

```markdown
**Un lot correctif n'a pas de bloc non livré à constater** : son spec delta est
vide.
```

### D6 — `Story`

Remplacer :

```markdown
Les stories d'un lot sont écrites **une par une** — la story N+1 en connaissant ce
qu'a produit la story N — et plusieurs peuvent être en vol simultanément.
```

par :

```markdown
Les stories d'un lot sont écrites **une par une** — la story N+1 en connaissant ce
qu'a produit la story N — et plusieurs peuvent être en vol simultanément. **Chaque
story choisit, en s'écrivant, les blocs du spec delta qu'elle transcrit**, et les
transcrit en entier : un bloc n'est jamais partagé entre deux stories.
```

### D7 — `Story > The user story document`

Remplacer :

```markdown
**Spec:** docs/specs/<module>.md
**Batch:** docs/batches/NN-<slug>/README.md
**Sections:** <section> > <sous-section>, <section>
```

par :

```markdown
**Spec:** docs/specs/<module>.md
**Batch:** docs/batches/NN-<slug>/README.md
**Sections:** <section> > <sous-section>, <section>
**Blocks:** D<n>, D<n>
```

Puis insérer, juste après le paragraphe qui commence par « `Sections:` déclare les
sections que la story touche » :

```markdown
`Blocks:` déclare les blocs du spec delta que la story transcrit, et c'est ce que
lit la clôture pour constater les blocs non livrés. Il vaut `none` pour une story
qui n'en transcrit aucun — une story de lot correctif, une story de démontage.
```

### D8 — `Story > Delivering a story`

Remplacer :

```markdown
3. **Commiter la modification de spec propre à cette story, puis pousser la branche
   immédiatement.** La transcription obéit à deux conditions :
   - **elle est incrémentale** — la part du spec delta que livre cette story,
     jamais le delta complet du lot ;
   - **elle est le premier commit de la branche**, avant que le plan soit écrit et
     que la moindre tâche s'exécute : la norme précède le code dans l'histoire de
     la branche.
```

par :

```markdown
3. **Commiter la transcription des blocs de cette story, puis pousser la branche
   immédiatement.** La transcription obéit à trois conditions :
   - **elle est mot pour mot** — le texte des blocs que déclare `Blocks:`, tel que
     la revue d'ouverture l'a lu, et jamais le delta complet du lot ;
   - **elle est le premier commit de la branche**, avant que le plan soit écrit et
     que la moindre tâche s'exécute : la norme précède le code dans l'histoire de
     la branche ;
   - **tout écart avec un bloc est nommé dans la pull request**, et tranché à la
     revue de livraison. Un écart n'a que deux causes légitimes. Soit `main` a
     changé depuis l'ouverture et le passage que le bloc cite n'y figure plus tel
     quel : la story ajuste le bloc à ce que porte `main`, sans en changer le sens.
     Soit le texte du bloc pose problème : l'agent s'arrête et le soumet à l'humain
     avant de le transcrire. Dans les deux cas, le document de lot n'est pas
     amendé.
```

### D9 — `Authority and conflict rules`

Insérer, juste après le tableau des revues :

```markdown
**L'agent n'approuve ni ne fusionne jamais une pull request de revue.**
L'approbation et la fusion sont des gestes humains.

**Pendant une revue, la branche n'est pas réécrite.** Chaque correction demandée
est poussée en commit `fixup!` du commit qu'elle corrige, ou en commit à part
quand elle porte une décision nouvelle, pour que l'humain voie sur la pull request
ce qui a changé depuis sa dernière lecture. **L'humain donne son accord dans la
conversation avec l'agent.** L'agent fond alors les `fixup!` dans les commits
qu'ils corrigent, pousse la branche réécrite, et annonce que la pull request est
prête à être approuvée et fusionnée.

**La fusion d'une revue d'adoption, d'ouverture, de livraison ou d'amendement est
un moment de vider le contexte** : le document fusionné porte alors tout ce dont
l'étape suivante a besoin, et la conversation n'est plus qu'un brouillon qui peut
le contredire. Celle d'une clôture n'en est pas un, rien ne la suivant. L'agent ne peut pas vider son propre contexte : en
annonçant la pull request prête, il dit que sa fusion sera ce moment, nomme
l'étape suivante, et donne dans un bloc à copier-coller le prompt qui la lance
après le clear. **Ce prompt se suffit à lui-même** : il nomme la skill à invoquer
et le document d'où repartir, et ne renvoie jamais à la conversation.
```

### D10 — `Departures from superpowers`

Remplacer :

```markdown
  en remplace la revue humaine. Le plan n'est écrit qu'avec chaque story. Quand un
  module touché n'a pas de spec, son adoption précède l'ouverture du lot.
```

par :

```markdown
  en remplace la revue humaine. Le plan n'est écrit qu'avec chaque story. Quand un
  module touché n'a pas de spec, son adoption précède la conception du lot, **et ne
  se conduit jamais dans le même contexte qu'elle** : une conception qui découvre un
  module non adopté s'arrête, l'humain choisit de l'abandonner ou de la mettre de
  côté, et elle ne reprend qu'une fois l'adoption fusionnée, dans un nouveau
  contexte.
```

### D11 — `Batch > Opening a batch`

Remplacer :

```markdown
1. Vérifie que chaque module touché est adopté ; sinon l'adoption est un
   **préalable bloquant**.
```

par :

```markdown
1. Vérifie que chaque module touché est adopté ; sinon l'ouverture s'arrête, et
   l'adoption se conduit à part (`Departures from superpowers`).
```

## Constraints

- **Ordre requis.** D1 et D3, qui définissent le bloc et sa forme, sont transcrits
  **au plus tard dans la même story** que D7 et D8, qui font transcrire des blocs
  par une story : le champ `Blocks:` désigne des identifiants que seul le document
  de lot définit. Les autres blocs n'imposent aucun ordre.
- **Ce lot applique déjà ce qu'il introduit.** Ses stories déclarent `Blocks:`,
  transcrivent leurs blocs mot pour mot et nomment tout écart dans leur pull
  request, même là où les skills publiées ne le demandent pas encore. Leurs revues
  suivent D9 dès la première.
- **Chaque story met à jour les skills qui appliquent ses blocs**, dans la même
  pull request que sa transcription : `writing-a-batch`, `writing-a-user-story`,
  `closing-a-batch`, `using-batches` et `adopting-a-module` selon les blocs qu'elle
  prend. Une skill qui continuerait de parler de « spec delta comme intention »
  après la fusion de D3 est une dérive.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans la
  même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la compte
  pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit la
  spec, la constatation part sous `Observed drift` dans le document de story.
- **Cinq décisions sont tranchées au gate d'ouverture** et ne se rediscutent pas
  en cours d'implémentation : **une adoption ne partage jamais le contexte de la
  conception d'un lot**, et une conception qui découvre un module non adopté
  s'arrête plutôt que d'enchaîner ; le spec delta est découpé **par section, jamais par
  story**, et le document de lot ne porte aucune liste de stories ; le texte est lu
  **dans le document de lot**, bloc par bloc, et non comme un diff de la spec ;
  l'accord de fin de revue se donne **dans la conversation**, l'approbation et la
  fusion restant des gestes humains sur GitHub ; il n'y a **pas de pause après le
  plan** — c'est le texte de la spec que l'humain revoit en amont, pas le
  découpage du travail.
- **Hors périmètre** : l'exécution de stories en parallèle, les pull requests
  empilées et le lancement de plusieurs stories sans intervention, l'endroit où
  noter une idée qui émerge hors du lot en cours, et l'identité GitHub propre à
  l'agent — qui relève de la configuration de chaque dépôt, pas du plugin.
- **Une seule entrée du gaps register est touchée** : *Batch / Closing a batch*,
  réservée par ce lot et résorbée par D2. Aucune autre.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Une story de ce lot, fusionnée seule, ne laisse personne devant quelque chose
d'incomplet. Livrée seule, la forme en blocs (D1, D3) donne des lots dont le delta
est plus précis qu'une intention, que les stories transcrivent sous la règle
actuelle. Livrée seule, la fin de revue (D9) vaut dès qu'elle est lue.
