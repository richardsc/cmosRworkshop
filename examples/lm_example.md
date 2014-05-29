# Linear models

Create some data, according to the formula
$$
y(x) = x + \epsilon
$$
where $\epsilon$ is normally distributed noise, with a mean of zero and a standard deviation of 2. For the sake of the example, let's introduce a few outliers.


```r
set.seed(3)  # makes it reproducible
x <- seq(0, 10, 0.25)
ep <- rnorm(x, sd = 2)
II <- c(35, 40)
ep[II] <- abs(rnorm(II, sd = 50))
y <- x + ep
plot(x, y, pch = 21, bg = "grey")
grid()
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 



```r
m <- lm(y ~ x)
```

