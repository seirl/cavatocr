OCAML := ocamlbuild
libs := sdlloader
FLAGS := -use-ocamlfind -libs $(libs)
DEPS := .,processing,image
BUILD := native

.PHONY: all test clean

all: main.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} main.$(BUILD)

test: test.ml
	$(OCAML) $(FLAGS) -Is ${DEPS} test.$(BUILD)

clean:
	$(OCAML) -Is ${DEPS} -clean
