all: 01.html 02.html
%.md: %.Rmd
	Rscript -e 'library(knitr);knit("$<")'
%.html: %.md
	pandoc --css style.css $< > $@
clean:
	-rm -f *~
	-rm -f *.html
	-rm -f *.md # caution on this

