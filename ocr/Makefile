
DEPS=processing,image

all:
	ocamlbuild -Is ${DEPS} main.native

test:
	ocamlbuild -Is ${DEPS} test.native

clean:
	ocamlbuild -Is ${DEPS} -clean 
