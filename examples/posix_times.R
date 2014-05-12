### There are various different ways of storing dates and times in R,
### including: Date class, POSIX class, time series class, or any
### other ad-hoc way that is preferred by the user. The advantage to
### using the built-in date/time classes is that there are many
### functions built to use and manipulate such objects, and it can
### eliminate ambiguities (e.g. daylight savings time?) in the type of
### representation.

### Here I'll go through the basics of the POSIXt class, which
### includes both POSIXct and POSIXlt objects, as well as some added
### functionality to base R through the `lubridate` package.

### In data files, dates and times are frequently stored as character
### strings, often in a form something like: `YYYY-mm-dd HH:MM:SS`, or
### `mm/dd/YY`, or `Jun 1 2014`, etc. The definition of a POSIX time
### is the number of seconds since a particular date (usually
### 1970-01-01 00:00:00 UTC), and the `POSIXct` and `POSIXlt` classes
### and their associated functions simply convert between character
### representations of the date and time to the numeric value, which
### is what is actually stored internally. This system allows for the
### specification, and conversion of, time zones, though as with all
### temporal data care must be taken to avoid errors when loading data
### from different sources. The best practice is to always convert
### objects to the UTC time zone if the are not already, which is
### standard when collecting data at sea.

### On the difference between `POSIXct` and `POSIXlt`:
###
###  * POSIXct objects are stored internally as the number of seconds
###  since 1970-01-01 as described above
###
###  * POSIXlt objects consist of a named list of vectors which is
###  closer to human readable form (see the help by doing `?POSIXt`)

## The `Sys.time()` functions returns the current system time as a POSIX object
Sys.time()
class(Sys.time())

## Note that the time zone depends on the machine, e.g. EDT
## You can learn more about your system time zone settings by doing
Sys.timezone()

## which for me gives "America/New_York"

## To convert the current system time to UTC, use `with_tz` from the lubridate package
library(lubridate)
tt <- Sys.time()
tt_utc <- with_tz(tt, 'UTC')
print(tt)
print(tt_utc)

## What does the numeric representation look like? use `as.numeric()`
as.numeric(tt)
as.numeric(tt_utc)

## Notice that they are the same, despite the different time zone specification. The time zone is stored as an "attribute", which is taken into account when the POSIX-to-numeric conversion takes place:
attributes(tt)
## See how tt_utc has a `tzone` attribute that says that it is UTC?
attributes(tt_utc)


## What do these look like as POSIXlt objects?
## Let's convert it
ttl <- as.POSIXlt(tt)
ttl_utc <- as.POSIXlt(tt_utc)
## and print it:
print(tt)
print(ttl)

## They look the same when printed. What about the numeric version?
as.numeric(tt)
as.numeric(ttl)
## again, the same

## So what's the difference with POSIXlt? It's a list!
attributes(ttl)

## Which means we can get different fields by simply naming them
ttl$year                                #years since 1900
ttl$mon                                 #numbered 0 to 11
ttl$wday                                #numbered 0 to 6
ttl$yday                                #0 to 365

## There are many functions for reading in characters of dates and times and converting them to POSIX objects. The most common are:

## as.POSIXct and as.POSIXlt
newtime1 <- as.POSIXct('2014-06-01 13:30:00', tz='UTC')  # assumes a
                                                         # default
                                                         # format, but
                                                         # can be
                                                         # changed

## strptime, creates POSIXlt
newtime2 <- strptime('06/01/2014', format='%m/%d/%Y', tz='UTC') # requires format

## The lubridate package contains a variety of conversion functions that can greatly simpify date/time conversion when reading data. Note that it defaults to UTC
ymd('2014-06-01')
ymd('20140601')
ymd('14 jun 1')
ymd('14jun1')

mdy('6/1/14')
mdy('060114')
mdy('06012014')
mdy('June 1 2014')

## etc ... can also add times
ymd_hm('201406011330')
ymd_hms('20140601133000')
ymd_hms('2014-06-01 13:30:00')
ymd_hms('2014-06-01T13:30:00')

## lubridate can also be used to extract specific fields, similar to the POSIXlt class
day(tt)                                 #day of month
yday(tt)                                #yearday -- note this is different from ttl$yday!!!
wday(tt)                                #day of week -- also different from ttl$wday
month(tt)                               #again, different from ttl$mon
hour(tt)
leap_year(tt)                           #is it a leap year?

### ========================================================
### Plotting

## using POSIX objects for time makes plotting with nice axes super easy.
## let's load an example data set from oce
library(oce)
data(sealevelTuktoyaktuk)
tuk <- sealevelTuktoyaktuk               # I'm lazy 

## extract the time vector
tuk_time <- tuk[['time']]
head(tuk_time)
class(tuk_time)

## extract the sealevel vector
tuk_sl <- tuk[['elevation']]

## plot the elevation time series -- note the automatic formatting of the x-axis. When the `x` argument to plot is a POSIX object, the labels are formatted appropriately.
plot(tuk_time, tuk_sl, type='l')

## if we are using the oce package, we can also use the `oce.plot.ts()` function, which behaves similarly but offers default plotting options that are more suited to plotting a time series
oce.plot.ts(tuk_time, tuk_sl)

## The time axis formatting can be controlled using the `format=` argument. To see the format options do `?strptime`
oce.plot.ts(tuk_time, tuk_sl, tformat='%b%Y')

## Notice the number of time axis ticks has increased to be more useful, and a date/time range has been added to the upper left of the plot. The range can be suppressed with
oce.plot.ts(tuk_time, tuk_sl, drawTimeRange = FALSE)
grid()


### ==========================================================
### Some final tips:
###
### Be careful when concatenating POSIX objects using `c()` -- the
### resultant vector will not have any attributes, meaning that the
### time zone information will be lost. A work around is save the
### timezone first, and then re-assign it as an attribute after the
### concatenation
tzUTC <- tz(tt_utc)
cat_time <- c(tt_utc, tt_utc + 86400, tt_utc + 2*86400) #lost the timezone
tz(cat_time) <- tzUTC
cat_time                                #back to UTC

## Another way to avoid this is to create an empty vector of the correct class and with the correct attributes first
cat_time2 <- rep(NA, length(tuk_time))
attributes(cat_time2) <- attributes(tuk_time) #make it POSIXct and tzone=UTC
## now fill it up
for (i in seq_along(tuk_time)) {
    cat_time2[i] <- tuk_time[i]
}
head(cat_time2)
