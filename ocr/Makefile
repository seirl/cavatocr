OCAML := ocamlbuild
libs := sdlloader
FLAGS := -use-ocamlfind -libs $(libs)
BUILD := native
SYNTAX := python3 syntax.py

DIRS := . processing image

comma := ,
space :=
space +=
DEPS := $(subst $(space),$(comma),$(DIRS))

ML := $(wildcard $(foreach dir,$(DIRS),$(addsuffix /*.ml,${dir})))
MLI := $(wildcard $(foreach dir,$(DIRS),$(addsuffix /*.mli,${dir})))

.PHONY: all test clean gui

all: main.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} main.$(BUILD)

test: test.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} test.$(BUILD)

gui: interface/gui.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} interface/gui.$(BUILD)

clean:
	$(OCAML) -Is ${DEPS} -clean

syntax:
	$(SYNTAX) $(ML)
	$(SYNTAX) $(MLI)
