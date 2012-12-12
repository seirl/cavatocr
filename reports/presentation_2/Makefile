REPORT := report.tex
PLAN := plan
PARTS := $(basename $(wildcard parts/*))
MD := md
LATEX := latex

UP := rsync -rsh='ssh' -vPtz
URL := root@serialk.fr:/srv/http/cavatocr/downloads/report2.pdf

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

upload: all
	${UP} report.pdf ${URL}

clean:
	rm -f *.aux
	rm -f *.toc
	rm -f *.pdf
	rm -f *.log
	rm -f $(addsuffix .tex,${PARTS})
