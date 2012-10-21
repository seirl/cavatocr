OCAML := ocamlbuild
libs := sdlloader
FLAGS := -use-ocamlfind -libs $(libs)
DEPS := .,processing,image
BUILD := native

find_files := $(wildcard $(folder)/*)
SOURCES := $(foreach folder,$(DEPS),$(find_files))


all: $(SOURCES)
	$(OCAML) $(FLAGS) -Is ${DEPS} main.$(BUILD)

test: $(SOURCES)
	$(OCAML) $(FLAGS) -Is ${DEPS} test.$(BUILD)

clean:
	$(OCAML) -Is ${DEPS} -clean
