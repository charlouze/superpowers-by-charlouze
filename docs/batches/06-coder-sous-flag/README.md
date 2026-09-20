---
status: open
---

# 06 — Coder sous flag

## Scope

Ce lot dit **comment écrire le code gardé par un feature flag**, et fait voyager
ces règles jusqu'aux agents qui l'écrivent.

Le cycle de vie d'un flag est déjà spécifié de bout en bout : la décision au gate
d'ouverture avec le champ `Feature flag`, la mention `🔒` dans la section de spec
concernée, la story de levée ou de démontage, et le refus de clore un lot dont un
flag survit sans portée déclarée. Il manque la seule chose que tout cela suppose :
ce que le code sous flag doit tenir entre sa déclaration et sa levée.

Pendant cette période, un flag peut être activé pour une partie des utilisateurs
seulement, et désactivé de nouveau à tout moment. Les deux comportements tournent
donc **en même temps, sur les mêmes données**. Coder sous flag, c'est coder sans
rupture — et rien dans le plugin ne le dit aujourd'hui.

Le lot livre trois choses :

- **Une norme.** Une section de spec énonce ce que le code gardé tient : la
  cohabitation des deux états, la désactivation toujours possible, l'absence
  d'autre changement, la vérification de chaque état, et un code écrit pour que la
  levée ne soit qu'une suppression.
- **Sa transmission jusqu'au code.** La spec du plugin ne voyage pas dans les
  projets qui l'utilisent : seules les skills y voyagent. Une norme que personne ne
  lit au moment d'écrire le code ne mord sur rien. Les règles sont donc recopiées
  dans les `Global Constraints` du plan, comme l'est déjà le gel du fichier de
  spec — le seul canal que lisent les implémenteurs et les reviewers de l'exécution
  par sous-agents.
- **Les deux ajustements que la norme rend nécessaires.** La frontière du module
  n'annonce pas qu'un flux de développement contraigne le code applicatif du
  projet, et c'est la première fois qu'il le fait. Et « activer » désigne désormais
  deux actes : le levier du projet, partiel et réversible, et la story qui fait
  passer le défaut déclaré de `off` à `on`. Les deux sont réparés ici, faute de
  quoi la norme entre dans une spec qu'elle rend fausse.

**Pourquoi maintenant.** Par anticipation, et c'est assumé : aucun lot n'a encore
déclaré de flag. Le premier qui le fera improvisera, et les défauts du code sous
flag ne se voient pas à la revue — ils se voient en production, chez l'utilisateur
resté du mauvais côté du branchement. Le coût de la règle écrite d'avance est d'une
section de spec ; le coût de l'improvisation est une donnée qu'un utilisateur au
flag désactivé ne sait plus lire. Écrire la règle avant le premier flag est aussi
ce que ce plugin demande partout ailleurs : la norme est antérieure et opposable
au code.

## Spec delta

Module `supercharlouze`, une seule spec : `docs/specs/supercharlouze.md`.

### D1 — `Feature flags`

Insérer, après le paragraphe qui se termine par « **La spec est le seul registre
des flags** : un flag existe tant que sa mention y figure, dans la section qu'il
couvre. », et avant le titre `### Lifting a feature flag` :

```markdown
### Code under a feature flag

Le code gardé par un flag tient l'activation pour une partie des utilisateurs
seulement, l'activation pour tous et la désactivation, quelle que soit la manière
dont le projet active ses flags. Il tient quatre règles :

- **Les deux états cohabitent.** Un utilisateur au flag activé et un utilisateur
  au flag désactivé travaillent côte à côte sur les mêmes données. Ce que l'un
  produit, l'autre peut le lire et s'en servir.
- **La désactivation reste toujours possible.** Désactiver le flag, pour un
  utilisateur ou pour tous, laisse lisible et utilisable ce que l'état activé a
  produit, sans erreur ni perte de donnée.
- **Rien d'autre ne change.** Flag désactivé, l'utilisateur retrouve le
  comportement d'avant le lot, aux données produites sous flag activé près.
- **Chaque état est vérifié.** La pull request de la story porte des tests du
  comportement flag activé, du comportement flag désactivé et de leur
  cohabitation.

**La levée ne fera que retirer.** Le code gardé est écrit de sorte que lever le
flag se réduise à supprimer le branchement et le comportement d'avant le lot, sans
rien écrire de neuf.
```

### D2 — `Story > The user story document`

Remplacer :

```markdown
`Global Constraints` porte quatre choses :

1. les contraintes que le lot impose, sa section `Constraints` recopiée mot pour
   mot ;
2. le gel du fichier de spec ;
3. la règle d'autorité — la spec gagne sans délibération, et corriger une spec est
   un acte humain, jamais un acte d'agent ;
4. **dans un lot correctif seulement**, la condition d'arrêt propre au lot
   correctif (`Departures from superpowers`), recopiée intégralement.
```

par :

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

### D3 — `Boundary`

Remplacer :

```markdown
Ce module couvre une extension de superpowers qui définit un flux de
développement : une spec vivante par module, des lots de stories qui font grandir
ces specs, des revues humaines tenues en pull request, les documents que ce flux produit —
spec, gaps register, document de lot, document de story — les conventions qu'il
laisse dans le dépôt — arborescence, branches, numéros, langue — et son
installation sur un projet.
```

par :

```markdown
Ce module couvre une extension de superpowers qui définit un flux de
développement : une spec vivante par module, des lots de stories qui font grandir
ces specs, des revues humaines tenues en pull request, les documents que ce flux produit —
spec, gaps register, document de lot, document de story — les conventions qu'il
laisse dans le dépôt — arborescence, branches, numéros, langue —, ce qu'il exige du
code applicatif tant qu'un flag le garde, et son installation sur un projet.
```

### D4 — `Feature flags > Lifting a feature flag`

Remplacer :

```markdown
La levée est **une story, jamais une part de la clôture.** Une période d'observation
entre activation et nettoyage se fait en deux stories — activer, puis retirer.
```

par :

```markdown
La levée est **une story, jamais une part de la clôture.** Une période
d'observation se fait en deux stories : la première fait passer le défaut déclaré
par la mention de `off` à `on`, la seconde supprime le branchement et la mention.

**Le défaut déclaré et l'état effectif sont deux choses distinctes.** La spec
déclare un défaut ; activer le flag pour une partie des utilisateurs, ou le
désactiver, est un geste du projet, qui ne change rien à ce que la spec déclare.
Seule une story change le défaut déclaré.
```

## Constraints

`none`

## Feature flag

Feature flag: none — lot à story unique, rien n'est jamais à moitié livré
