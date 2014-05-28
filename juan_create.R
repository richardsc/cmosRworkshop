## Extract and plot Halifax sea level (plus tidal model) along
## with wind, during Hurricane Juan.  Also, output a data file
## named juan.csv if it's not already present.  That file contains:
##  time = time in UTC
##  eta = sea level [m]
##  etap = predicted sea level [m], based on tidal model
##  wind = wind speed in m/s

library(oce)
if (length(list.files(pattern='^juan.csv$'))) {
    d <- read.csv('juan.csv')
    time <- as.POSIXct(d$time, tz="UTC")
    eta <- d$eta
    etap <- d$etap
    wind <- d$wind
} else {
    data(sealevel)
    eta <- sealevel[['elevation']]
    etap <- predict(tidem(sealevel))
    start <- as.POSIXct("2003-09-20 00:00:00", tz="UTC")
    end <- as.POSIXct("2003-10-01 00:00:00", tz="UTC")
    met <- read.met('http://climate.weather.gc.ca/climateData/bulkdata_e.html?format=csv&stationID=6358&Year=2003&Month=9&Day=17&timeframe=1&submit=Download+Data')
    met[['time']] <- met[['time']] + 4 * 3600 # convert from Halifax LST to UTC
    time <- sealevel[['time']]
    look <- start <= time & time < end
    time <- time[look]
    eta <- eta[look]
    etap <- etap[look]

    time2 <- met[['time']]
    look2 <- start <= time2 & time2 < end
    time2 <- time2[look2]
    wind <- met[['wind']][look2] * 1000 / 3600 # m/s
    direction <- 10 * met[['direction']][look2]
    u <- met[['u']][look2]
    v <- met[['v']][look2]
    stopifnot(all(time==time2))
    write.csv(data.frame(time, eta, etap=round(etap,2), wind=round(wind, 1)), row.names=FALSE, file="juan.csv")
} 

## http://www.ec.gc.ca/ouragans-hurricanes/default.asp?lang=En&n=258CBC16-1
## above says wind dir changed from 90 (from the N) to 180 (from the S)
## during the peak.

juan <- as.POSIXct("2003-09-29 04:00:00", tz="UTC")
par(mfrow=c(3, 1))
oce.plot.ts(time, eta)
lines(time, etap, lty='dotted', col='blue')
abline(v=juan, lty='dotted', col='red')
oce.plot.ts(time, eta - etap)
abline(v=juan, lty='dotted', col='red')
oce.plot.ts(time, wind)
abline(v=juan, lty='dotted', col='red')

