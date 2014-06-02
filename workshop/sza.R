x <- seq(0, 2*pi, 0.01)
sza <- 4*(-cos(x) + 1) + rnorm(x, 0.5)
II <- which(sza > 7)
sza[II] <- NA

plot(x, sza, ylim=c(0, 8))

fit <- lm(sza ~ cos(x) + sin(x))
y <- predict(fit, newdata=list(x=x))
lines(x, y, col='red', lwd=3)