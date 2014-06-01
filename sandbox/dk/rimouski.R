rebuild <- TRUE
library(oce)
if (rebuild) {
    image <- read.landsat("~/Google Drive/LC80120262013282LGN00", band="panchromatic")
    left <- -68.61465 - 0.03
    right <- -68.42006 + 0.08
    bottom <- 48.38358 + 0.03
    top <- 48.64969 - 0.02
    rimouski <- landsatTrim(image, list(latitude=bottom, longitude=left),
                            list(latitude=top, longitude=right))
    save(rimouski, file="rimouski.rda")
} else {
    load("rimouski.rda")
}
if (!interactive()) png("rimouski_2013-10-09.png", width=7, height=7, unit="in", res=100, pointsize=12)
plot(rimouski, col=oceColorsJet, zlim=c(0.125, 0.14))
points(-68.517016, 48.444152, pch=20, col='pink')
if (!interactive()) dev.off()
