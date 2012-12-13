REPORT := report.tex
PLAN := plan
PARTS := $(basename $(wildcard parts/*))
MD := md
LATEX := latex

UP := rsync -rsh='ssh' -vPtz
URL := root@serialk.fr:/srv/http/cavatocr/downloads/report2.pdf
exploit_URL := root@serialk.fr:/srv/http/cavatocr/downloads/manuel_exploitation.pdf

all: ${MD} ${LATEX}

${MD}: $(addsuffix .md,${PARTS})
	for m in ${PARTS}; do\
	    pandoc -o $$m.tex $$m.md; \
	done

${LATEX}: ${REPORT}
	pdflatex ${REPORT}
	pdflatex ${REPORT}

plan:
	pandoc -o ${PLAN}.pdf ${PLAN}.md

exploitation:
	pandoc -o exploitation.pdf exploitation.md

upload: all
	${UP} report.pdf ${URL}
	${UP} exploitation.pdf ${exploit_URL}

clean:
	rm -f *.aux
	rm -f *.toc
	rm -f *.pdf
	rm -f *.log
	rm -f $(addsuffix .tex,${PARTS})
