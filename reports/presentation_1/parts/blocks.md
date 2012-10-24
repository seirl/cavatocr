*Le membre en charge de cette partie du projet était Antoine Pietri*

La dernière étape avant de vraiment reconnaitre les caractères est de les
trouver. C'est la troisième sorte de detection utilisée jusqu'à présent dans le
processus (la première étant la détection de l'angle et la deuxième
l'élimination du bruit).

Sur quoi travaillons-nous dans cette partie ? La photo a été chargée, tournée de
sorte à ce que le texte soit droit, et elle est ensuite passée au travers de
divers filtres n'en faisant maintenant qu'un tableau de pixels blanc ou noir
(pur).

## Lignes

Tout d'abord, trouvons les lignes de texte. Pour cela, nous avont besoin d'un
histogramme vertical de l'image, ici une simple liste représentant le nombre de
pixel noir de chaque rangée.

Avec cet histogramme, nous créons des blocs de lignes continues et non-vides.
Comme chaque ligne est séparée d'au moins une rangée de pixel blancs, la
différentiation se passe générallement très bien.

Par exemple, dans l'image suivante :

\begin{figure}[htbp]
\centering
\includegraphics[scale=1.5]{images/lorem.png}
\caption{Detection exemple -- original}
\end{figure}

Notre programme detecte toutes les lignes comme ceci :

\begin{figure}[htbp]
\centering
\includegraphics[scale=0.3]{images/lorem_line1.png}

\includegraphics[scale=0.3]{images/lorem_line2.png}

\includegraphics[scale=0.3]{images/lorem_line3.png}
\caption{Line detection exemple}
\end{figure}

## Caractères

Détecter les caractères repose essentiellement sur le même principe. Nous
calculons cette fois l'histogramme horizontal de chaque ligne pour ensuite
recréer des bloques de colonnes adjacentes et non vides.

La ligne suivante par exemple :

\begin{figure}[htbp]
\centering
\includegraphics[scale=0.4]{images/lorem_line1.png}
\caption{Characters detection exemple -- line 1}
\end{figure}

est séparée en caractères comme ceci :

\begin{figure}[htbp]
\centering
\includegraphics[scale=0.5]{images/lorem_char0.png}
\includegraphics[scale=0.5]{images/lorem_char1.png}
\includegraphics[scale=0.5]{images/lorem_char2.png}
\includegraphics[scale=0.5]{images/lorem_char3.png}
\includegraphics[scale=0.5]{images/lorem_char4.png}
\includegraphics[scale=0.5]{images/lorem_char5.png}
\includegraphics[scale=0.5]{images/lorem_char6.png}
\includegraphics[scale=0.5]{images/lorem_char7.png}
\includegraphics[scale=0.5]{images/lorem_char8.png}
\includegraphics[scale=0.5]{images/lorem_char9.png}
\includegraphics[scale=0.5]{images/lorem_char10.png}
\includegraphics[scale=0.5]{images/lorem_char11.png}
\includegraphics[scale=0.5]{images/lorem_char12.png}
\includegraphics[scale=0.5]{images/lorem_char13.png}
\includegraphics[scale=0.5]{images/lorem_char14.png}\\
et ainsi de suite\ldots{}
\caption{Characters detection exemple}
\end{figure}

## Définition du seuil

Parfois, les caractères sont tellement proches qu'il n'y a aucune colonne vide
entre eux

Une solution naïve à ce problème est de définir nous-même ce qu'est une "colonne
vide", notre premier choix a été de considérer les colonnes de moins d'un
certains nombre de pixels comme étant vide, ce nombre étant relatif à la taille
de l'image et du text.

Dans l'exemple précédent, ce seuil était de trois pixels noirs, observont ce
qu'il arrive en variant légèrement cette valeur.

Avec un seuil de quatre pixels, nous nous retrouvons parfois avec des caractères
"deux en un" :

\begin{figure}[htbp]
\centering
\includegraphics[scale=0.8]{images/lorem_char_merge.png}
\caption{Characters detection exemple -- char merge}
\end{figure}

Et avec un seuil de deux pixels, certains caractères sont interprêtés comme deux
différents, comme ce 'n' par exemple:

\begin{figure}[htbp]
\centering
\includegraphics{images/lorem_char_strip1.png}
\includegraphics{images/lorem_char_strip2.png}
\caption{Characters detection exemple -- char merge}
\end{figure}

## Améliorations futures

Aujourd'hui, nous pensons à deux axes d'optimisation de ce module :

### Améliorer la définition du seuil

Bien que fonctionnant d'une façon très correct, l'actuel seuil est très naif. Un
idée serait de prendre en compte la distance entre les pixels noirs d'une même
colonne. De cette façon, nous pourrions augmenter le nombre de pixel noirs
autorisé par colonne vide, tout en détectant correctement ce genre de groupe de
caractère comme étant deux lettres différentes :\newpage{}

![Characters detection exemple -- char merge 2](images/lorem_char_merge.png)

mais en voyant toujours celui-ci comme un caractère seul :

![Characters detection exemple -- line 14](images/lorem_char24.png)

L'amélioration suivante (et plus compliquée) sera de détecter les lignes
continues d'une façon plus intelligente, de comparer la largeur des caractères
avec une moyenne, ou même utiliser le réseau de neurone pour régler les cas
particuliers.

### Détecter les zones de texte

Le seul défaut de notre module de détection des blocs est qu'il se trompe
facilement dans ce genre de cas :\newpage{}

![Text zone improvement -- typical exemple](images/text.jpg)

Notre algorithme ne peut correctement reconnaitre les lignes à côté du 'H'
décoré car celui-ci rend toutes les rangées de pixels non vides.

La solution évidente est de détecter _où_ se trouve les grandes zones de texte,
les isoler dans des surfaces et n'appliquer les autres algorithmes que sur ces
surfaces.
