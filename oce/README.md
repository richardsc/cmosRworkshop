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

Within an `oce` object, a particular item can be retrieved using the `[[` method, e.g. to get the temperature from a ctd object:
```splus
library(oce)
data(ctd)
T <- ctd[['temperature']]
```

The data can also be accessed directly, by following the path through the slots, e.g.

```splus
T <- ctd@data$temperature
```

To get a look at the structure of the object, use the `str()` function:
```splus
str(ctd)
```
produces:
```
> str(ctd)
Formal class 'ctd' [package "oce"] with 3 slots
  ..@ metadata     :List of 21
  .. ..$ header          : chr [1:42] "* Sea-Bird SBE 25 Data File:" "* FileName = C:\\SEASOFT3\\BASIN\\BED0302.HEX" "* Software Version 4.230a" "* Temperature SN = 1140" ...
  .. ..$ type            : chr "SBE"
  .. ..$ hexfilename     : chr "c:\\seasoft3\\basin\\bed0302.hex"
  .. ..$ serialNumber    : chr ""
  .. ..$ systemUploadTime: POSIXct[1:1], format: "2003-10-15 11:38:00"
  .. ..$ ship            : chr "Divcom3"
  .. ..$ scientist       : chr ""
  .. ..$ institute       : chr ""
  .. ..$ address         : chr ""
  .. ..$ cruise          : chr "Halifax Harbour"
  .. ..$ station         : chr "Stn 2"
  .. ..$ date            : logi NA
  .. ..$ startTime       : POSIXct[1:1], format: "2003-10-15 11:38:00"
  .. ..$ latitude        : num 44.7
  .. ..$ longitude       : num -63.6
  .. ..$ recovery        : logi NA
  .. ..$ waterDepth      : num 44.1
  .. ..$ sampleInterval  : logi NA
  .. ..$ names           : chr [1:8] "scan" "time" "pressure" "depth" ...
  .. ..$ labels          : chr [1:8] "scan" "time" "pressure" "depth" ...
  .. ..$ filename        : chr "/Users/kelley/Dropbox/oce-data/ctd/ctd.cnv"
  ..@ data         :List of 8
  .. ..$ scan       : num [1:181] 130 131 132 133 134 135 136 137 138 139 ...
  .. ..$ time       : num [1:181] 129 130 131 132 133 134 135 136 137 138 ...
  .. ..$ pressure   : num [1:181] 1.48 1.67 2.05 2.24 2.62 ...
  .. ..$ depth      : num [1:181] 1.47 1.66 2.04 2.23 2.6 ...
  .. ..$ temperature: num [1:181] 14.2 14.2 14.2 14.2 14.2 ...
  .. ..$ salinity   : num [1:181] 29.9 29.9 29.9 29.9 29.9 ...
  .. ..$ flag       : num [1:181] 0 0 0 0 0 0 0 0 0 0 ...
  .. ..$ sigmaTheta : num [1:181] 22.2 22.2 22.2 22.2 22.2 ...
  ..@ processingLog:List of 2
  .. ..$ time : POSIXct[1:3], format: "2013-07-28 09:13:37" "2013-07-28 09:13:37" ...
  .. ..$ value: chr [1:3] "create 'ctd' object" "ctdAddColumn(x = res, column = swSigmaTheta(res@data$salinity,     res@data$temperature, res@data$pressure), name = \"sigmaThet"| __truncated__ "read.ctd.sbe(file = file, processingLog = processingLog)"
```

## Examples:

* CTD data

	* reading `cnv`, `odf`, `itp`, `woce` files
	* processing raw data (trimming, depth binning, etc)
	* TS diagrams
	* Sections

* ADP data

    * coordinate transformations

* image plots (e.g. `imagep()`), colormaps, and palettes

