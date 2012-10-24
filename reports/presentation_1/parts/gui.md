Le membre en charge de cette partie était Stéphane Lefebvre.

> *I think the major good idea in Unix was its clean and simple interface: open,
> close, read, and write.*

> -- Ken Thompson

### Introduction
L'interface est le lien entre les fonctions de traitements et d'extraction et
l'utilisateur, elle se veut simple, facilement abordable et la plus complète
possible.

Dans cette interaction l'utilisateur définit l'image qu'il faut travailler en
la chargeant depuis ses documents personnels. Il peut également modifier des
paramètres, telles que les différents filtres à appliquer et l'emplacement où
le fichier doit être extrait.

Enfin il lance l'application tout en gardant un apercu visuel sur le
déroulement du programme afin de corriger les possibles erreurs d'extraction.

### Choix du support
Pour créer cette interface nous avons eu le choix entre la création *from
scratch* en utilisant SDL, l'utilisation la bibliothèque GTK ou QT,
bibliothèque spécialisée dans l'interface, et l'utilisation de programmes de
création de Windows Forms semblables a celui disponible sous Visual Studio.

Après une brève recherche sur le logiciel LibGlade, notre choix s'est porté sur
l'utilisation de GTK avec lablGTK, car les logiciels de création interactives
ne présentent pas de coté technique intéressant et la documentation sur GTK est
largement plus fournie que celle sur QT.

### Composition de l'interface
De même que le site internet, l'interface est en anglais et se compose d'une
fenêtre composé de trois parties :
La partie haute qui est une ligne de boutons de commandes.
La partie centrale qui est un espace d'affichage pour l'image,
La partie basse qui contient trois boutons : *pretreatment* et *extract* qui
sont actuellement des boutons vides, et *quit* qui ferme le programme. À la
différence de la croix, le boutton quit ne demande pas de confirmation avant de
fermer l'interface.

### Coté technique
L'utilisation de lablGTK est composé de deux grandes parties, le visuel et les
rouages internes.

Du coté du visuel, la création avec GTK consiste à créer une fenêtre principale
dans laquelle on insère des fenêtres que l'on peut diviser à la verticale ou à
l'horizontale, et l'on peut soit les partitionner de blocs préexistants, soit
en créer un et le coller. À l'interieur de ces blocs, on peut mettre des
boutons, boîtes à cocher, barres de pourcentages et autres objet interactifs
proposés par la bibliothèque.

Lors de l'appui sur ces boutons, des fonctions sont appelées, ces fonctions
existent en partie grâce à la bibliothèque lablgtk et il est très simple de les
compléter pour obtenir ce que l'on souhaite.

