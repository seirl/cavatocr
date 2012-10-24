# Chargement de l'image

Nous avons fait le choix d‘utiliser la librairie SDL pour le traitement de notre
image et toute les opération qui suive celui - ci, ce choix s est fait tout
d’abord par l existence de documentation concernant Ocaml Sdl puis dans un
second temps grâce à la familiarisation avec cette bibliothèque en séance de
travaux pratiques.

# Passage en niveau de gris

L'image que l’on doit traiter est tout d'abord charger sous forme d'une SDL
surface ,cette SDL surface est accessible a la manière d'une matrice.  Une des
fonctionnalité de SDL nous permet d’accéder a la valeur RGB (red,green,blue) de
chaque pixel.

Pour opérer le passage en niveau de gris nous multiplions chaque composante de
cd triplé par des valeurs spécifique

- le rouge est multiplier par 0.3
- le vert est multiplie par 0.59
- le bleu est multiplie par 0.11

Une fois ces multiplications effectues nous additionnons le résultat puis nous
le divisons par 255.Cette opération nous donne le niveau de gris du pixel
etudie.

Nous appliquons cette opération a chaque pixel de l image en entrée et nous
plaçons le résultat dans une matrice de même taille que l image.  Nous avons
fait le choix de placer ces valeurs dans une matrice pour un accès plus rapide
par la suite et cela nous évite aussi la création de multiple sdl surface.

A la suite de cette etape nous avons en mémoire une matrice contenant le niveau
de gris de chaque pixel ,si l’on créait un SDL surface contenant en chaque pixel
(en rgb) les valeurs de la matrice obtenu nous obtiendrons une image en noir et
b.

# Filtrage de l’image

Pour la réalisation de cette partie la majorité du travail à été axé sur la
recherche. En effet il nous fallait un algorithme permettant efficacement de
supprimer les bruits d’une image sans en altérer le contenu. L’algorithme qui
nous à paru le plus efficace parmi ceux dont la difficulté de compréhension
n‘était pas trop grande est le filtre médian.

Le filtre médian que nous avons implémenté s’applique sur une fenêtre de 9
pixel. En effet la fonction de passage en niveaux de gris nous permet d obtenir
un tableau contenant la valeur en niveau de gris de chaque pixel, sur cette
matrice, pixel par pixel nous analysons les valeurs des pixel entourant le
courant (celui que nous désirons filtrer) toute les valeurs sont récupérées puis
trié dans un vecteurs. L‘élément médian de ce vecteur sera la nouvelle valeur du
pixel filtré.

Voici les étapes de l’algorithme :

- soit la matrice de l'image donc chaque case est symbolisé ainsi (colonne,
ligne)
- soit le pixel analysé en (x,y) dans la matrice de l’image les valeur de
niveaux de gris des pixels en position :

- (x,y)
- (x-1,y-1)
- (x,y-1)
- (x+1,y-1)
- (x-1,y)
- (x+1,y)
- (x-1,y+1)
- (x,y+1)
- (x+1,  y+1)

Ces valeurs de niveaux de gris sont enregistré dans un tableau, ce tableau est
trié et l'élément médian de cette énumération se trouvera en cinquième position
du tableau, la valeur du pixel en position (x,y) sera alors fixé a cette valeur
médiane.

Ce filtrage est satisfaisant pour la première présentation du projet mais la
personne qui y a travailler a le désirs de proposer une meilleur solution de
filtrage pour la prochaine soutenance, ses recherche sont en ce moment même
principalement axé sur l’implémentation du filtre médian relaché.

Exemple de résultat issus du filtre médian : image avant après filtre médian.

# Binarisation de l’image

La qualité de cette étape est essentiel pour la suite des operations que va
subir l’image car tout les algorithme appliqué par suite sur celle ci seront
fait sur sa représention binaire.

La grande difficulté de cette réalisation est le choix du seuil de binarisation
c ‘est a dire , si un pixel est au dessus d ‘une valeur alors il est fixé à
blanc dans le cas contraire le pixel est considéré comme noir. Nous avons essayé
plusieurs méthodes de calcul du seuil de binarisation mais aucune n'a été
concluante et la plupart du temps etait moins efficaces qu un seuil fixé.  Nous
avons donc choisi de fixer le seuil de binarisation.

Lla fonction nous permettant de binariser l'image n'utilise pas de SDL surface
mais rend plutôt une matrice de booléens avec vrai quand le pixel est blanc et
faux quand il est noir.

# Filtre supplémentaire

Lors de nos travaux de traitement d’image nous avons eu l'idée de créer un
filtre. Ce filtre ne porte pas de nom car il est de notre propre création cet
algorithme permet de faire ressortir le contour des caractères en noir cela
donne de très bon résultat.

Pour cette soutenance nous n’avons pas trouvé de vocation à ce dernier mais nous
pensons qu’il nous sera d’un grand secours par la suite.
