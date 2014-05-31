library(oce)
## band <- "pan"
## image <- read.landsat("LC80120262013282LGN00", band=band, debug=0)
## left <- -68.61465 - 0.03
## right <- -68.42006 + 0.08
## bottom <- 48.38358 + 0.03
## top <- 48.64969 - 0.02
## rimouski <- landsatTrim(image, list(latitude=bottom, longitude=left),
##                         list(latitude=top, longitude=right))
if (!interactive()) png("rimouski_2013-10-09.png", width=7, height=7, unit="in", res=100, pointsize=12)
load("rimouski.rda")
plot(rimouski, col=oceColorsJet, zlim=c(0.125, 0.14))
if (!interactive()) dev.off()
