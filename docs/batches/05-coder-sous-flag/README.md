---
status: open
---

# 05 — Coder sous flag

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

Le lot livre deux choses :

- **Une norme.** Une section de spec énonce ce que le code sous flag tient : la
  cohabitation des deux états, la désactivation toujours possible, l'absence de
  changement hors de la garde, la vérification de chaque état, et une levée qui ne
  fait que retirer du code.
- **Sa transmission jusqu'au code.** La spec du plugin ne voyage pas dans les
  projets qui l'utilisent : seules les skills y voyagent. Une norme que personne ne
  lit au moment d'écrire le code ne mord sur rien. Les règles sont donc recopiées
  dans les `Global Constraints` du plan, comme l'est déjà le gel du fichier de
  spec — le seul canal que lisent les implémenteurs et les reviewers de l'exécution
  par sous-agents.

**Pourquoi maintenant.** Par anticipation, et c'est assumé : aucun lot n'a encore
déclaré de flag. Le premier qui le fera improvisera, et les défauts du code sous
flag ne se voient pas à la revue — ils se voient en production, chez l'utilisateur
resté du mauvais côté de la garde. Le coût de la règle écrite d'avance est d'une
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

Tant qu'il vit, un flag peut être activé pour une partie des utilisateurs
seulement, puis désactivé. Le code écrit sous flag tient ce cas, quelle que soit
la manière dont le projet active ses flags. Coder sous flag, c'est coder sans
rupture :

- **Les deux états cohabitent.** Un utilisateur au flag activé et un utilisateur
  au flag désactivé travaillent côte à côte sur les mêmes données. Ce que l'un
  produit, l'autre peut le lire et s'en servir.
- **La désactivation reste toujours possible.** Ce que l'état activé a produit
  reste acceptable pour l'état désactivé : désactiver le flag, pour un utilisateur
  ou pour tous, ne casse rien.
- **Rien ne change hors de la garde.** Flag désactivé, l'utilisateur retrouve
  exactement le comportement d'avant le lot.
- **Chaque état est vérifié.** Une story sous flag prouve son comportement flag
  activé, flag désactivé, et la cohabitation des deux.
- **La levée ne fait que retirer.** Lever le flag supprime la garde et le chemin
  désactivé, sans rien écrire de neuf.
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
5. **dans un lot qui déclare un flag seulement**, les règles du code sous flag
   (`Feature flags > Code under a feature flag`), recopiées intégralement.
```

## Constraints

`none`

## Feature flag

Feature flag: none — lot à story unique, rien n'est jamais à moitié livré
