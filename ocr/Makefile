OCAML := ocamlbuild
libs := sdlloader
FLAGS := -use-ocamlfind -libs $(libs)
BUILD := native
SYNTAX := python3 syntax.py

DIRS := . processing image nn training interface

comma := ,
space :=
space +=
DEPS := $(subst $(space),$(comma),$(DIRS))

ML := $(wildcard $(foreach dir,$(DIRS),$(addsuffix /*.ml,${dir})))
MLI := $(wildcard $(foreach dir,$(DIRS),$(addsuffix /*.mli,${dir})))

URL_IMAGES := http://infoprepa.epita.fr/ImagesOCR/
URL_FONTS := http://cavatocr.serialk.fr/downloads/fonts
RSYNC := rsync --rsh='ssh' -vPtz

.PHONY: all test clean gui syntax get_images get_fonts doc training

all: main.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} main.$(BUILD)

training: training.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} training.$(BUILD)

test: test.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} test.$(BUILD)

gui: interface/gui.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} interface/gui.$(BUILD)

clean:
	$(OCAML) -Is ${DEPS} -clean

syntax:
	$(SYNTAX) $(ML) $(MLI)

get_fonts:
	mkdir -p fonts
	wget -r -c -A.ttf -nH -np -nd -nv -P fonts $(URL_FONTS)

get_images:
	mkdir -p test_images
	wget -r -c -A.jpg -nH -np -nd -nv -P test_images $(URL_IMAGES)

doc:
	$(OCAML) $(FLAGS) -Is ${DEPS} ocr.docdir/index.html
	sed -i 's/White/transparent/' ocr.docdir/style.css
	$(RSYNC) -r ocr.docdir/* root@serialk.fr\:/srv/http/cavatocr/doc/
	$(MAKE) clean
	
