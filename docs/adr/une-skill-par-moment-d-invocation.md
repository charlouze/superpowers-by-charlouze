# Une skill par moment d'invocation

Le plugin livre une skill par moment où un agent l'invoque, parce qu'un agent ne
lit que la skill qu'il a invoquée.

Ce qui vaut en permanence vit dans un socle : une skill que toute skill d'entrée
invoque en commençant, et qu'invoque aussi celui qui exécute ou relit une tâche
d'un plan.

Un texte que plusieurs skills partagent et qui dépasse une ou deux phrases vit
dans une skill interne, que ces skills invoquent.

Une définition ou une règle d'une ou deux phrases ne devient pas une skill : elle
vit dans le socle, et les autres skills y renvoient.

Exception : le texte collé dans le prompt d'un sous-agent qui ne doit charger
aucune skill est recopié, et un test le tient identique à son original.

## Considered options

- Peu de skills, chacune couvrant plusieurs moments. Écartée : un agent charge
  alors le texte de moments qui ne le concernent pas, et la skill grossit jusqu'à
  ne plus être relue.
- Une ref que plusieurs skills citent. Écartée : elle vit dans le répertoire d'une
  seule skill, et les autres dépendent d'un fichier qu'aucune d'elles ne possède.
- Le texte recopié dans chaque skill. Écartée : les copies dérivent.
- Une skill interne par texte partagé, quelle que soit sa taille. Écartée : une
  règle d'une phrase ne vaut pas une invocation.

## Consequences

Une ref appartient à une seule skill.

Une skill interne n'est invoquée que par une autre skill.

Le socle ne nomme aucune autre skill.
