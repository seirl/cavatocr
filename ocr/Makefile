OCAML := ocamlbuild
libs := sdlloader
FLAGS := -use-ocamlfind -libs $(libs)
DEPS := .,processing,image
BUILD := native

.PHONY: all test clean gui

all: main.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} main.$(BUILD)

test: test.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} test.$(BUILD)

gui: interface/gui.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} interface/gui.$(BUILD)

clean:
	$(OCAML) -Is ${DEPS} -clean
