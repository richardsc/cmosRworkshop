## DISCUSSION. goal: illustrate CTD work by finding outliers in TS diagram

library(oce)
data(ctd)

## Get an idea on the data
plotTS(ctd)

## DISCUSSION. the [[]] method
S <- ctd[["salinity"]]
## DISCUSSION. *never* use the TRUE=T notation!
T <- ctd[["temperature"]]
## DISCUSSION. audience opinion on df?
df <- 3
m <- smooth.spline(S, T, df=df)
lines(predict(m)) # DISCUSS: it looks for "x" and "y" in the data

## DISCUSSION. S is not monotonic so this idea is nuts...go to density-spice space
sigthe <- ctd[["sigmaTheta"]]
spice <- ctd[["spice"]]
plot(sigthe, spice)
## DISCUSS. new name for this spline -- not a good name but one easy to type (practical)
mm <- smooth.spline(sigthe, spice, df=df)
lines(predict(mm))

## DISCUSSION. probably want larger df ... can play a bit
df <- 10
mm <- smooth.spline(sigthe, spice, df=df)
lines(predict(mm), col='red')

## DISCUSSION. the predictions are at *data locations*; optionally show them
## how to get a smooth curve but for the present purpose we actually *want*
## the predictions at the data locations.

## Deviation histogram
dev <- spice - predict(mm)$y
hist(dev)
## DISCUSSION: play with breaks; can show result of too many; maybe also show boxplot
# hist(dev, breaks=300)

## DISCUSSION. a boxplot reveals some outliers (based on its definition) ...
boxplot(dev)
## DISCUSSION. ... but we will make our own definition.

## DISCUSSION. anyone recognize this number?
qnorm(0.975)

## DISCUSSION. we can do the "t" distribution as well!
qt(0.975, df=9999)
qt(0.975, df=length(spice)) # our data

## DISCUSSION. construct "z" values and identify those that seem unusual at 95% level
z <- (dev - mean(dev)) / sd(dev)
bad <- abs(z) > qt(0.975, df=length(spice))
table(bad) 

plot(sigthe, spice, col=ifelse(bad, "red", "black"), pch=20)
lines(predict(mm), col='blue')

## DISCUSSION. put two plots together for those who like TS
par(mfrow=c(1,2))
plotTS(ctd, col=ifelse(bad, "red", "black"), pch=20)
plot(sigthe, spice, col=ifelse(bad, "red", "black"), pch=20)
grid()
