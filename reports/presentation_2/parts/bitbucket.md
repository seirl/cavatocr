Nous avons décidé d'utiliser Mercurial comme gestionnaire de version, pour
gérer nos versions de code.

Nous avons choisi Bitbucket comme hébergeur, car l'interface, les possibilités
et les fonctionnalités étaient très intéressantes.
Notre code est ouvert au public, et vous pouvez les retrouver sur notre site
web.

Voici la liste des commits que nous avons envoyé sur bitbucket :

* blog: added two new articles
* report: preprocessing last images
* report: preprocessing finished
* added old images
* report: preprocessing images
* report: preprocessing almost finished
* report: touch empty parts
* report: blockst: add some bullshit
* added Mareo, Kido_Soraki, nurelin, underflow and Zeletochoy.
* added irc, environnement, network
* report: blocks part almost fished
* report: fix again
* added irc bot to structure
* added base structure + some md
* pres_2: fixed report.tex
* failed merge
* rapport bien avance\', il manque les images et les accents.
* : Enter commit message.  Lines beginning with 'HG:' are removed.
* added rapport 2
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* lol
* main: fixed
* main: correction
* almost working neural network
* separated doc rules
* blocks: documentation
* cavatobot: try/except on shortenurl
* rotate: rlsa clean after rotating
* added nn.bin to hgignore
* added README
* final commit ?
* added training and rotation to the main, deleted warnings
* gui: extract works
* work on the mlp
* filters: delete useless functions
* coding without testing is _bad_
* Tired
* filter: filter function
* blocks: remove vim-specific line
* main: use the interface
* makefile: adding the interface to the sources
* gui: avoid remaining warnings and delete _ function
* gui: reindenting and creating main function
* main: arg parsing
* Better.
* Without fail
* gui, miss the function inside
* blocks: avoid a warning
* filters: clean
* filters: forgot to return filtered image
* blocks: clean and debug
* added ttf-training result display
* GUI almost finished
* added some functions for ttf training
* "j ai fix la matrice est full initialiser a false"
* "binarisation ajoute mais pb elle prend en parametre un matrice de triplet
grey scale , je ne sais pas trp comment la modifier cependant je l ai moidifier
pour au elle renvoi une matrice de bool ... dernier pb la matrice creer devrait
avoir tout initialiser a false avant de faire l algo dessus , je cherche cmt
faire"
* "test"
* xHG: --
* blocks: words detection
* filter fixes
* filters: some fixes
* added some filters, rlsa
* added a generic neuron
* resize.ml: trailing whitespaces
* blocks: new method: character detection
* blog: added documentation page
* wrong minus position
* optimized rotation diff
* blocks: new method, detect lines
* beginning rotation fix
* added local_moy to resize properly a character
* added 'doc' rule to .PHONY
* rsync for doc deploying, sed -i
* cavatobot: auto reconnect
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* blocks: now detect words
* better documentation, integrated in the website
* some fixes
* added int_of_bool
* added soutenance 2
* oops
* proper layer 1
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* removed useless things in the neuron definition
* blocks: format comments for ocamldoc
* added documentation generator
* wget options
* added test images getter to the Makefile
* added neural network
* syntax fixes
* added syntax.py, and make syntax rule
* float/truncate shortcuts
* cavatobot pep8 compliant
* added kick message
* added resize function
* bug for repositories containing less than one commit
* cavatobot: autorejoin on quit
* cavatobot: auto reconnect
* cavatobot: two calls to the same function
* site: added gui image
* report: dettorer's presentation
* s/jours/journées/
* fix rotation part
* merge
* report: blocks
* delete images
* added plan.md and conclusion
* added thoma's article
* report: added stephane's part
* added images + avancement
* added download page
* report1: preprocessing
* blog: block detection article
* report: added quotes, site: added bitbucket link
* added introduction and group presentation
* completed rotation.md
* blocks: lists in right order
* blog: team: Thomas
* completed skeleton
* site: added project.markdown
* report: added skeleton
* site: added the Project page
* blog: deleted cavatorta
* blog: team: Dettorer correction
* blog: team: Dettorer presentation
* blog: added team avatars
* blog: better formula in skew detection article
* site: added team page
* blog: added skew detection part
* working mathjax formulas in rotation/skew detection article
* added rotation-and-first-draft-of-skew-detection
* added mathjax to blog
* added developing-an-ocr-an-ambitious-project post
* gui: capitales in comments
* gui: better comments
* gui: indentation and norm proofreading
* gui: no warnings
* interface: compile
* La meme chose, j'avais omis le hg add
* Il manque : l'edit (choix des filtres) les actions(quand on touche aux
boutons) l'actualisation de l'image (la elles s'empilent)
* fix warning
* READY
* blocks: handy functions
* makefile: much simplier: just use .PHONY
* blocks: use a specific rotation function
* all: proofreading (norm)
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* delete test_filters.ml
* makefile: define sources
* tries on optimization
* message in english
* message in english
* blocks: character detection
* image: now wait_key terminate the program on a ^C
* blocks: indentation
* filters: Use Array.fast_sort
* oops
* functionnal skew angle detection
* merge
* fixing rotate.ml
* 1st try of skew detecting
* matrix: nvm, juste forgot to save (fixed Image.load too)
* matrix: move back some functions (strange circular dependency)
* matrix: move matrix-related functions to logical places
* filters: now uses matrixes instead of SDL surfaces
* Image: accomodation for working with matrixes
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* filter: black magic on median filter
* Debut de l'interface avec un deuxieme fichier qui coresponds a ce que je
compte faire en resultat final
* filters: debuged cleaning function
* filtre median faire sort...pas tester...
* filters: add laplacian edge detection
* filters: simple binarization
* filter: binarize almost works
* filter: binarisation V2
* new main.ml
* moved preprocessing.ml to filters.ml
* added main.ml with a basic binarization and rotation
* various fixes
* multiple fixes in preprocessing.ml
* beginning histogram
* Clean and reorganisation
* .hgignore: ignore test.ml and images
* debug preprocessing
* image.ml: delet uncomplet function
* Makefile improvement
* preprocessing.ml : cosmetic fixes
* added makefile
* tris vecteur pour median OK (a tester)
* niveux de gris OK binarisation(fixage seuil par fction OK) reste a faire
median(le parcour)
* Added makefile and ocamldoc-compatible comments
* added some comments
* merge
* added missing begin-end
* fixed cavatobot
* added get_skew_angle (histogram has not been written yet, don't try to
compile.)
* merge
* block detection: line detection, hey, I didn't tested it but I think it works
!
* added octopress blog
* merging
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* Automated merge with ssh://bitbucket.org/serialk/cavatocr
* matrix.ml: trailing semicolon
* fixed shortenurl()
* fix cavatobot
* merge
* added conf.yml in .hgignore
* added url in cavatobot
* solved problem in cavatobot
* removed useless buggy statement
* cavatobot is now compatible with multiple repositories
* cavatobot.py: wrong number of args in message()
* cavatobot.py: **params
* cavatobot.py: deleting debugging logs
* i'm stupid
* i'm stupid
* fixed cavatobot ('i'm stupid' commit)
* added python caches in hgignore
* cavatobot.py: saving last commit correctly
* cavatobot.py: using limit instead of count for bitbucket API
* cavatobot.py: correct commit index
* fixed cavatobot.py
* conf.yml added, cavatobot.py fixed
* work on cavatobot
* added cavatobot
* rotate.ml: rotation now operates on matrix
* added int_of_bool.
* moved src root in /ocr
* rotate.ml: working rotate function
* matrix.ml,image.ml : added some usual functions
* Attempt to fix rotate
* Removed useless open
* Moved matrix.ml, added hgignore, added matrix_to_surface
* Added matrix.ml and rotation algorithm, reorganized project
* Added new dimensions calculation
* Added rotate.ml
