Le membre en charge de cette partie du projet était Paul Hervot

> *Le BAC, c'est comme la lessive, on mouille, on sèche et on repasse.*
>
> -- Monfieur fat

La dernière étape avant de vraiment reconnaitre les caractères est de les
trouver. C'est la troisième sorte de detection utilisée jusqu'à présent dans le
processus (la première étant la détection de l'angle et la deuxième
l'élimination du bruit).

Sur quoi travaillons-nous dans cette partie ? La photo a été chargée, tournée de
sorte à ce que le texte soit droit, et elle est ensuite passée au travers de
divers filtres n'en faisant maintenant qu'un tableau de pixels blanc ou noir
(pur).

### Lignes
> *non*
>
> -- Thiel

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

### Caractères
> *JE SUIS KABYLE CONNARD*
>
> -- Bruce

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

### Définition du seuil
> *Le train de tes injures roule sur le rail de mon indifférence.*
>
> -- George Abitbol

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

C'est maintenant un problème résolu grâce un réglage plus intelligent et
auto-adaptatif du seuil.

### Détection des mots

> *Il existe un art, ou plutôt un truc, pour voler. Le truc est d'apprendre à se
> flanquer par terre en ratant le sol.*
>
> -- Le Guide Du Voyageur Galactique

Le minimum de détection de mise en page est bien évidemment de reconnaitre le
début et la fin de chaque mots.

Nous utilisons pour ça une fois de plus la bonne vielle technique de
l'histogramme. Cette fois, c'est le nombre d'espace entre chaque caractères que
nous étudions. Un algorithme digne d'un exercice de prologin détecte les deux
espacements les plus répétés dans l'histograme, nous en déduisont que le plus
grand est l'espacement général des caractère. Il suffit donc de placer une fin
et un début de mot à chaque espace proche de celui-ci.

#### Détecter les zones de texte

> Tu n’es vraiment pas très sympa.
>
> -- George Abitbol

La puissance d'ocaml se révèle dans cette partie: la sélection des zones de
l'image contenant du texte se fait via un principe récursif. Prenons l'exemple
de cette image :

![text avec image](images/text_img.jpg)

Avce notre algorithme de détection des caractères, l'image entière sera reconnue
comme un gros caractère. Plus intéressant encore, si une grande ligne verticale
parcour l'image, elle sera reconnue comme un caractère mais toutes les lignes
qu'elle occupe n'en feront qu'une, notre algorithme ne trouvera pas de caractère
dans ce méli-mélo de ligne et tout le block (sans la ligne parasite) sera
interprêté comme un caractère. Nous faisons alors la moyenne de la taille de
tous les caractères de l'image, un caractère plus grand que cette moyenne sera
sans aucun doute un faux, nous relançons alors la détection dedans, ainsi le
block parasité sera de nouveau analysé, correctement cette fois.
