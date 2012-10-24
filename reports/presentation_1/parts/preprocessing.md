*Le membre en charge de cette partie était Thomas Kostas*

### Chargement de l'image

Nous avons fait le choix d'utiliser la librairie SDL pour le traitement de
notre image et toute les opération qui suive celui-ci. Nous avons choisi cette
bibliothèque car elle était bien documentée et car nous avions appris à la
manipuler en TP.

### Passage en niveau de gris

L'image que l'on doit traiter est tout d'abord chargée sous forme d'une SDL
surface. Cette SDL surface est accessible à la manière d'une matrice. Une des
fonctionnalités de SDL nous permet d'accéder à la valeur RGB (red, green, blue)
de chaque pixel.

Pour opérer le passage en niveau de gris nous multiplions chaque composante de
ce triplet par des valeurs spécifiques :

- le rouge est multiplié par $0.3$
- le vert est multiplié par $0.59$
- le bleu est multiplié par $0.11$

\vspace{0.5cm}

Une fois ces multiplications effectuées nous additionnons le résultat puis nous
le divisons par 255. Cette opération nous donne le niveau de gris du pixel
étudié.

Nous appliquons cette opération à chaque pixel de l'image en entrée et nous
plaçons le résultat dans une matrice de même taille que l'image. Nous avons
fait le choix de placer ces valeurs dans une matrice pour un accès plus rapide
par la suite et cela nous évite aussi la création de multiple SDL Surfaces.

À la suite de cette étape, nous avons en mémoire une matrice contenant le
niveau de gris de chaque pixel. Si l'on créait un SDL surface contenant en
chaque pixel (en rgb) les valeurs de la matrice obtenue, nous obtiendrons une
image en noir et blanc.

### Filtrage de l'image

Pour la réalisation de cette partie la majorité du travail à été axé sur la
recherche. En effet il nous fallait un algorithme permettant efficacement de
supprimer les bruits d'une image sans en altérer le contenu. L'algorithme qui
nous à paru le plus efficace parmi ceux dont la difficulté de compréhension
n'était pas trop grande est le filtre médian.

Le filtre médian que nous avons implémenté s'applique sur une fenêtre de 9
pixels. En effet la fonction de passage en niveaux de gris nous permet
d'obtenir un tableau contenant la valeur en niveau de gris de chaque pixel. Sur
cette matrice, pixel par pixel, nous analysons les valeurs des pixels entourant
le courant (celui que nous désirons filtrer) Toutes les valeurs sont récupérées
puis triées dans un vecteur. L'élément médian de ce vecteur sera la nouvelle
valeur du pixel filtré.

\vspace{0.5cm}

Voici le fonctionnement de l'algorithme :

On a la matrice de l'image donc chaque case est symbolisée ainsi : (colonne,
ligne), et le pixel analysé en $(x, y)$ dans la matrice de l'image.

On s'intéresse au niveau de gris des pixels en ces positions :

- $(x, y)$
- $(x-1, y-1)$
- $(x, y-1)$
- $(x+1, y-1)$
- $(x-1, y)$
- $(x+1, y)$
- $(x-1, y+1)$
- $(x, y+1)$
- $(x+1, y+1)$

Ces valeurs de niveaux de gris sont enregistrés dans un tableau. Ce tableau est
trié et l'élément médian de cette énumération se trouvera en cinquième position
du tableau. La valeur du pixel en position (x, y) sera alors fixé à cette valeur
médiane.

Ce filtrage est satisfaisant pour la première présentation du projet mais la
personne qui y a travaillé à le désir de proposer une meilleure solution de
filtrage pour la prochaine soutenance, ses recherches sont en ce moment même
principalement axés sur l'implémentation du filtre gaussien.

### Binarisation de l'image

La qualité de cette étape est essentielle pour la suite des opérations que va
subir l'image car tout les algorithmes appliqués par la suite sur celle-ci
seront faits sur sa représentation binaire.

La grande difficulté de cette réalisation est le choix du seuil de
binarisation, c'est à dire que si un pixel est au dessus d'une valeur alors il
est fixé à blanc. Dans le cas contraire le pixel est considéré comme noir. Nous
avons essayé plusieurs méthodes de calcul du seuil de binarisation mais aucune
n'a été concluante et la plupart du temps étaient moins efficaces qu'un seuil
fixé. Nous avons donc choisi de fixer le seuil de binarisation.

La fonction nous permettant de binariser l'image n'utilise pas de SDL Surface
mais rend plutôt une matrice de booléens ("vrai" quand le pixel est blanc et
"faux" quand il est noir).

### Filtre supplémentaire

Lors de nos travaux de traitement d'image nous avons eu l'idée de créer un
filtre. Ce filtre ne porte pas de nom car il est de notre propre création. Cet
algorithme permet de faire ressortir le contour des caractères en noir. Cela
donne de très bons résultats.

Pour cette soutenance, nous n'avons pas trouvé de but à ce filtre mais nous
pensons qu'il nous sera d'une grande aide par la suite.
