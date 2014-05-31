all: base_graphics.html lm_example.html
%.md: %.Rmd
	Rscript -e 'library(knitr);knit("$<")'
%.html: %.Rmd
	#pandoc --css style.css $< > $@
	Rscript -e 'library(knitr);knit2html("$<")'
index.html: index.md
	pandoc --css style.css $< > $@
clean:
	-rm -f *~
	-rm -f *.html

