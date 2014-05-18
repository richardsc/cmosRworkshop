all: 01.html 02.html 03.html 04.html 05.html index.html 
%.md: %.Rmd
	Rscript -e 'library(knitr);knit("$<")'
%.html: %.md
	pandoc --css style.css $< > $@
index.html: README.md
	pandoc --css style.css $< > $@
clean:
	-rm -f *~
	-rm -f *.html

