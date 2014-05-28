# Base graphics example

When it comes to making plots in R, there are a wide variety of options. Popular packages that extend the base plotting capabilities of R include the [`ggplot2`](http://cran.r-project.org/web/packages/ggplot2/index.html) and [`lattice`](http://cran.r-project.org/web/packages/lattice/index.html) packages.

The `oce` package however, almost exclusively uses the base graphics plotting functions. Thus to understand how to tweak, manipulate, and add to plots create through `oce` functions it is a good idea to have an idea how to interact with R's basic graphing system.

## The Basics

Let's start with a basic plot, created from the `adp` dataset in `oce`. For simplicity, we'll extract some of the variables from the adp object, to make the plotting commands cleaner.


```r
library(oce)
```

```
## Loading required package: mapproj
## Loading required package: maps
```

```r
data(adp)
time <- adp[["time"]]
pressure <- adp[["pressure"]]
temperature <- adp[["temperature"]]
```


We can plot the variables using the `plot()` command. Remember that R and oce use objects and "generic" functions, so if we do something like `plot(adp)`, we are in fact calling the function `plot.adp()` which has different behavior from the default `plot.default()` function (see e.g. `?plot.adp`).


```r
plot(pressure)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

makes a plot of the pressure vector against the indices of the vector -- this is the default behavior when only the `x` argument is given. Note that the default plot type is to use points. This can be changed using the `type` argument (see `?plot.default` for details):

```r
par(mfrow = c(2, 2))  # 2 by 2 grid
plot(pressure, type = "p")  # default
plot(pressure, type = "l")  # lines
plot(pressure, type = "b")  # both
plot(pressure, type = "o")  # overplotted both
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 


We can plot temperature as a function of pressure:

```r
par(mfrow = c(1, 1))
plot(pressure, temperature)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

or we can use the `~` formula notation to plot as the form `plot(y ~ x)`

```r
plot(temperature ~ pressure)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 



Notice that every time you use the `plot()` command, it draws a new plot. This is what is known as a "high-level" plotting function. To add further things to the plot, such as more points, lines, text, legends, etc, requires the use of a series of so-called "low-level" plotting commands.

Let's add some points perturbed from the original by random noise, and use some different "plotting characters", as specified by the `pch` argument:

```r
plot(pressure, temperature, pch = 21, bg = "grey")
pnoise <- rnorm(pressure, sd = sd(pressure)/10)  # first argument specifies desired length
tnoise <- rnorm(length(temperature), sd = sd(temperature)/10)  # can be a vector or a single number
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 


How about we add a line, such as a least squares fit of T(p) (i.e. a "linear model"):

```r
plot(pressure, temperature, pch = 21, bg = "grey")
grid()  # add a grid
pnoise <- rnorm(pressure, sd = sd(pressure)/10)  # first argument specifies desired length
tnoise <- rnorm(length(temperature), sd = sd(temperature)/10)  # can be a vector or a single number
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
m <- lm(temperature ~ pressure)
press.pred <- seq(min(pressure), max(pressure), 0.01)
temp.pred <- predict(m, list(pressure = press.pred))
lines(press.pred, temp.pred, lwd = 10, col = "pink")
abline(m)  # can add a straight line directly using the lm object
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 



## Tweaking the aesthetics

Notice that the default margins leave lots of room for readability, but may be too large for most practical purposes. To adjust all the different aesthetic aspects of the plot, we make use of the myriad of different "parameters" -- to see all of them do `?par` or type `par()` at the command line. Note that we already used the `mfrow` parameter to set the layout of subplots.

As an example here, we will adjust both the "margins" (through the `mar` parameter) and the "margin positions" (through the `mgp` parameter). We need to call `par()` to set the various parameters *before* doing any plotting.

The current par values can be queried using the `par()` function -- e.g. if we want to know what the current settings are for `mar`, we do:

```r
par("mar")
```

```
## [1] 5.1 4.1 4.1 2.1
```

These numbers can be interpreted as the number of "lines" around the outside of the plot, starting with the bottom, then the left side, then the top, then the right side. Similarly we can query the `mgp`

```r
par("mgp")
```

```
## [1] 3 1 0
```

These 3 numbers represent the line that axis label is printed on, the line the tick labels are printed on, and the line that the axis itself is drawn on.

Let's try changing them to make a tighter plot, plotted next to the original for comparison:

```r
par(mfrow = c(1, 2))
plot(pressure, temperature, pch = 21, bg = "grey")
grid()
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
par(mar = c(3, 3, 1, 1), mgp = c(2, 0.75, 0))
plot(pressure, temperature, pch = 21, bg = "grey")
grid()
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

Notice that we've reduced the space around the plot box, and have tightened the labeling of the axes. Let's reproduce the four-panel plot from earlier, but now with the tighter axes:

```r
par(mfrow = c(2, 2), mar = c(3, 3, 1, 1), mgp = c(2, 0.75, 0))
plot(pressure, type = "p")
plot(pressure, type = "l")
plot(pressure, type = "b")
plot(pressure, type = "o")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 



If we wanted, using the `mgp` par, we could move the axis position *away* from the zero position:

```r
par(mfrow = c(1, 1), mar = c(3, 3, 1, 1), mgp = c(2, 0.75, 0.25))
plot(pressure, temperature, pch = 21, bg = "grey")
grid()
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 


### A note about axis limits, ranges, etc

There are a *lot* of different `par`'s, so it's not surprising that many new R users find it a bit overwhelming. The best resources for discovering and understanding what they do is the `?par` help page and Google. I'll point out a couple more relevant plotting parameters before moving on to legends.

First I'm going to use a call to `dev.off()` to close our open figure window, and thereby reset all the `par` tweaking we've been doing. This should only matter when running the code in an interactive session, but not for compiling the Rmarkdown document.

```r
dev.off()
```

```
## null device 
##           1
```


Now, we can set the x and y limits in our plot using the `xlim` and `ylim` arguments:

```r
plot(pressure, temperature, pch = 21, bg = "grey", xlim = c(37, 41), ylim = c(3, 
    5))
title("Set the axis limits")
grid()
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 

Note that by default R extends the range of the axes by a small amount. This is essentially an aesthetic choice, in the event that there is a point that lies right on one of the limits, e.g.

```r
plot(pressure, temperature, pch = 21, bg = "grey", xlim = range(pressure), ylim = range(temperature))
title("Default extension of axis limits")
grid()
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15.png) 

Note that we set the limits *exactly* to the range of the x and y variables, but the actual limits are extended slightly. This behavior is controlled by the `xaxs` and `yaxs` arguments, which from `?par` are:
```
     ‘xaxs’ The style of axis interval calculation to be used for the
          x-axis.  Possible values are ‘"r"’, ‘"i"’, ‘"e"’, ‘"s"’,
          ‘"d"’.  The styles are generally controlled by the range of
          data or ‘xlim’, if given.
          Style ‘"r"’ (regular) first extends the data range by 4
          percent at each end and then finds an axis with pretty labels
          that fits within the extended range.
          Style ‘"i"’ (internal) just finds an axis with pretty labels
          that fits within the original data range.
          Style ‘"s"’ (standard) finds an axis with pretty labels
          within which the original data range fits.
          Style ‘"e"’ (extended) is like style ‘"s"’, except that it is
          also ensures that there is room for plotting symbols within
          the bounding box.
          Style ‘"d"’ (direct) specifies that the current axis should
          be used on subsequent plots.
          (_Only ‘"r"’ and ‘"i"’ styles have been implemented in R._)
```
From the above it can be seen that the default value "r" (regular), extends the visible axis limits by 4%. If we want the limits to be *exactly* the values specified, we can change `xaxs` and/or `yaxs` to "i" (internal).

```r
plot(pressure, temperature, pch = 21, bg = "grey", xlim = range(pressure), ylim = range(temperature), 
    xaxs = "i", yaxs = "i")
title("Axis limits set to \"internal\"")
grid()
points(pressure + pnoise, temperature + tnoise, pch = 22, bg = "red", cex = 0.75)
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16.png) 

Note now that the points at the extreme ends get "cut off" by the axis. This is the same as the default behavior in Matlab.

## Legends

It is very common to add a legend to a plot to describe the different elements being plotted. This can be accomplished in R using the base graphics function `legend()`.



To include:

* high-level plotting commands (e.g. `plot()`)

* low-level plotting commands (e.g. `points()`, `lines()`, ... )

* multi-figure plots (e.g. `mfrow/mfcol` and `layout()`)

* graphing parameters, i.e. `par`

    * `mar`, `mgp`, ...

	* axes styles (e.g. `xaxs`)

* adding text (e.g. `text()`, and `mtext()`)

* legends

* point out commonly used missing (or inflexible) functions, such as image plots, filled contours, palettes and colormaps.
