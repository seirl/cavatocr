OCAML = ocamlbuild
LIBS = sdlloader
FLAGS = -use-ocamlfind -libs $(LIBS)
DEPS = processing,image
BUILD = byte


all:
	$(OCAML) $(FLAGS) -Is ${DEPS} main.$(BUILD)

test:
	$(OCAML) $(FLAGS) -Is ${DEPS} test.$(BUILD)

clean:
	$(OCAML) -Is ${DEPS} -clean
