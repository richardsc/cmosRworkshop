## Demo colormap for an image (salinity at drifter)

library(oce)
data(drifter)
cm <- colormap(zlim=c(33.5, 36), col=oceColorsJet)
p <- drifter[["pressure"]][,1] # note that p is a matrix
t <- drifter[["time"]]
S <- t(drifter[["salinity"]]) # note the transpose
hist(S, xlim=c(33.5, 36), breaks=200) # the xlim from playing around — good for workshop
imagep(t, p, S, colormap=cm, ylim=rev(range(p)))
contour(t, p, S, level=35, add=TRUE, drawlabels=FALSE) # check a colour
