# Examples of the oce package

The `oce` package can be installed in R in the usual way:

```splus
install.packages('oce')
```

You will most likely also want to install the `ocedata` package, which contains a variety of oceanographic datasets.

Package development is done through [Github](github.com), with the respective package repositories being found at:

* [oce](https://github.com/dankelley/oce/)

* [ocedata](https://github.com/dankelley/ocedata/)

The development version of the package can be obtained in several ways, either by downloading the source code from the `develop` branch on Github and installing via `R CMD build ...` and `R CMD INSTALL ...` in a terminal, or more simply by using the `devtools` package:

```splus
library(devtools) # might have to do install.packages('devtools') first
install_github("oce", "dankelley", "develop")
install_github("ocedata", "dankelley", "master")
```

For further examples on building from source, see [http://dankelley.github.io/oce/](http://dankelley.github.io/oce/)

**Warning:** the `develop` branch of the `oce` repo may be unstable -- bug fixes and alpha trials of new functions that exist there may not behave as expected.

Also note that to build packages from source may require utilities that are not included with the standard R (such as C and Fortran compilers). On OSX the [XCode Developer tools](https://developer.apple.com/xcode/) are required, as well as a gfortran compiler (see [R for Mac OS X](http://cran.r-project.org/bin/macosx/tools/))


## Basic oce object format

`oce` uses S4 objects, with standard "slots" that separate:

* `data`: the data of the object (e.g. temperature, salinity, pressure, etc)

* `metadata`: relevant metadata created from the input file (e.g. instrument parameters, cruise name, lead PI, etc)

* `processingLog`: a log of processing steps, with times, applied to the object (e.g. creation, subsetting, etc)

## Examples:

* CTD data

	* reading `cnv`, `odf`, `itp`, `woce` files
	* processing raw data (trimming, depth binning, etc)
	* TS diagrams
	* Sections

* ADP data

    * coordinate transformations

* image plots (e.g. `imagep()`), colormaps, and palettes

