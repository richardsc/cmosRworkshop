all: tidal_analysis.html TS_outlier.html SST.html gridding.html index.html
%.md: %.Rmd
	Rscript -e 'library(knitr);knit("$<")'
%.html: %.md
	pandoc --css style.css $< > $@
index.html: index.md
	pandoc --css style.css $< > $@
clean:
	-rm -f *~
	-rm -f *.html

