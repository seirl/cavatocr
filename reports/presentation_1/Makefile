REPORT := report.tex
PLAN := plan
PARTS := $(basename $(wildcard parts/*))
MD := md
LATEX := latex

all: ${MD} ${LATEX}

${MD}: $(addsuffix .md,${PARTS})
	for m in ${PARTS}; do\
	    pandoc -o $$m.tex $$m.md; \
	done

${LATEX}: ${REPORT}
	pdflatex ${REPORT}

plan:
	pandoc -o ${PLAN}.pdf ${PLAN}.md

clean:
	rm -f *.aux
	rm -f *.toc
	rm -f *.pdf
	rm -f *.log
	rm -f $(addsuffix .tex,${PARTS})
