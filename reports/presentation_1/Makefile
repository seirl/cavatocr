REPORT := report.tex
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

clean:
	rm *.aux
	rm *.toc
	rm *.pdf
	rm *.log
