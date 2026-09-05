---
status: closed
---

# 01 — Renvois au document de conception archivé

## Scope

Ce lot ramène `README.md` et `commands/init.md` en conformité avec la spec
vivante du module `supercharlouze`. Les deux fichiers renvoient le lecteur à des
sections numérotées du document de conception — « section 11 of the design
document » et « spec section 9 » — alors que ce document a été archivé sous
`docs/archive/specs/` et privé d'autorité par l'adoption du module.

**Pourquoi maintenant.** Ces deux renvois n'étaient pas faux avant l'adoption :
ils désignaient le seul document qui faisait autorité. Ils le sont devenus à
l'instant précis où la pull request d'adoption a fusionné, et ce sont les deux
pointeurs qu'un nouveau lecteur suit en premier — le README pour comprendre ce
que le plugin garantit, le fichier de commande parce qu'un agent le lit à chaque
`/supercharlouze:init`. Laisser courir, c'est laisser la première lecture du
module renvoyer à un document que la spec a explicitement dépassé, et l'écart
grandira à chaque amendement de la spec.

## Spec delta

**Vide — lot correctif.** Ce lot n'ajoute aucun comportement : il rétablit ce que
la spec promet déjà. Son périmètre est l'entrée suivante de
`docs/specs/supercharlouze.gaps.md`, réservée par cette pull request :

- Section **Verification** — `README.md` renvoie à « section 11 of the design
  document » pour la liste des paris non testés, et `commands/init.md` renvoie à
  « spec section 9 » pour la règle de la pull request ; ces deux renvois désignent
  des sections numérotées d'un document archivé et sans autorité.

C'est la seule entrée de la section *Violations* du registre, et ce lot la prend
intégralement.

## Constraints

- **Ne pas réintroduire de numérotation dans la spec vivante.** Ses sections sont
  titrées et non numérotées, délibérément : la section est l'unité de tout ce qui
  se compte dans ce système, et un numéro se périme au premier réagencement. Un
  renvoi nomme la section, il ne la compte pas.
- **`commands/init.md` est lu par un agent, pas par un humain.** Son texte est
  chargé tel quel à chaque invocation de la commande. La correction doit y rester
  une instruction exécutable, et non devenir une citation ou une note de bas de
  page.
- **Ne rien corriger d'autre.** Les douze entrées de la section *Gaps* du registre
  ne sont pas dans ce périmètre et ne sont pas réservées par ce lot. Une dérive
  constatée en chemin se consigne sous `Observed drift`, jamais dans le registre
  directement.
- **Ordre des stories :** aucun. Ce lot est attendu en une story.

## Feature flag

Feature flag: none — corrective batch, restores behaviour the spec already promises

## Live flags

none

Vérifié section par section sur `docs/specs/supercharlouze.md` : le module ne
porte aucune phrase de gating. Le seul `🔒` du fichier est l'**exemple illustratif**
de la section *The spec document*, à l'intérieur d'un bloc de code — il montre la
forme qu'une phrase de gating doit prendre, il n'en déclare pas une. Aucun flag
n'est donc vivant sur ce module, et ce lot n'en hérite aucun.
