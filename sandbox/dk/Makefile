all: 01.html 02.html
%.md: %.Rmd
	Rscript -e 'library(knitr);knit("$<")'
%.html: %.md
	pandoc $< > $@

