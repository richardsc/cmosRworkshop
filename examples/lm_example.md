# Model fitting




## Linear Models

Create some data, according to the formula
$$
y(x) = x + \epsilon
$$
where $\epsilon$ is normally distributed noise, with a mean of zero and a standard deviation of 2. For the sake of the example, let's introduce a few outliers.


```r
set.seed(3)  # makes it reproducible
x <- seq(0, 10, 0.25)
ep <- rnorm(x, sd = 2)
II <- c(38:41)
ep[II] <- abs(rnorm(II, sd = 50))
y <- x + ep
plot(x, y, pch = 21, bg = "grey")
grid()
```

![plot of chunk unnamed-chunk-2](figure/lm-unnamed-chunk-2.png) 


We can fit a linear model to the data, using the `lm()` function, and add it to the plot:

```r
m1 <- lm(y ~ x)
plot(x, y, pch = 21, bg = "grey")
grid()
abline(m1)
```

![plot of chunk unnamed-chunk-3](figure/lm-unnamed-chunk-3.png) 

Note the effect that the outliers have on the inferred slope and intercept. We can get some stats about the fit examining the object returned by `lm()`, either by printing it to the screen, or by using the `summary()` function (remember, `summary()` is a generic function, and so it uses the `summary.lm()` version here):

```r
m1
```

```
## 
## Call:
## lm(formula = y ~ x)
## 
## Coefficients:
## (Intercept)            x  
##       -7.05         3.16
```

```r
summary(m1)
```

```
## 
## Call:
## lm(formula = y ~ x)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12.00  -7.34  -1.66   3.13  71.49 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   -7.053      4.166   -1.69    0.098 .  
## x              3.159      0.717    4.40    8e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 13.6 on 39 degrees of freedom
## Multiple R-squared:  0.332,	Adjusted R-squared:  0.315 
## F-statistic: 19.4 on 1 and 39 DF,  p-value: 8.02e-05
```


We can also plot the `lm` object, to get a summary of the fit using various statistical tests:

```r
par(mfrow = c(2, 2))
plot(m1)
```

![plot of chunk unnamed-chunk-5](figure/lm-unnamed-chunk-5.png) 

Clearly the outliers are strongly influencing the fit, and acting as leverage points.

One way of doing a regression in the presence of outliers and leverage points is to use a "robust linear model" with the `rlm()` function. See `?rlm` for more details, but let's see what effect it has on our synthetic data:

```r
library(MASS)
m2 <- rlm(y ~ x)
par(mfrow = c(1, 1))
plot(x, y, pch = 21, bg = "grey")
grid()
abline(m1)
abline(m2, lty = 2)
legend("topleft", c("lm", "rlm"), lty = 1:2)
```

![plot of chunk unnamed-chunk-6](figure/lm-unnamed-chunk-6.png) 


And we can similarly plot the results of the regression:

```r
par(mfrow = c(2, 2))
plot(m2)
```

![plot of chunk unnamed-chunk-7](figure/lm-unnamed-chunk-7.png) 

Notice that the residuals no longer have a significant trend (panel 1), and that the leverage of the outliers is significantly reduce (panel 4).


## Polynomial fits

What if we wanted to fit data that is not linear in x? Let's modify the original problem to be quadratic:
$$
y(x) = x^2 + \epsilon
$$
and we'll increase the standard deviation of $\epsilon$ to 10, just for the heck of it, and forget about the outliers for now:

```r
par(mfrow = c(1, 1))
x <- seq(0, 10, 0.25)
ep <- rnorm(x, sd = 5)
y <- x^2 + ep
plot(x, y, pch = 21, bg = "grey")
grid()
```

![plot of chunk unnamed-chunk-8](figure/lm-unnamed-chunk-8.png) 

Now we make another call to `lm()`:

```r
m3 <- lm(y ~ I(x^2))
summary(m3)
```

```
## 
## Call:
## lm(formula = y ~ I(x^2))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -10.096  -3.197   0.346   3.389   7.588 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  -1.2306     1.0217    -1.2     0.24    
## I(x^2)        1.0504     0.0224    46.8   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.39 on 39 degrees of freedom
## Multiple R-squared:  0.983,	Adjusted R-squared:  0.982 
## F-statistic: 2.19e+03 on 1 and 39 DF,  p-value: <2e-16
```

Note the use of the `I()` construct in the `formula` argument for `lm()`. See `?formula` for more details about the syntax of formulas, but basically it ensures that we do the fit against the *square* of x.

Another way to do this, that I just learned from [stack overflow](http://stackoverflow.com/questions/3822535/fitting-polynomial-model-to-data-in-r) is to use the `poly()` function:

```r
mpoly2 <- lm(y ~ poly(x, 2))
summary(mpoly2)
```

```
## 
## Call:
## lm(formula = y ~ poly(x, 2))
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -7.87  -3.08   0.32   3.27   8.54 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   34.221      0.679    50.4   <2e-16 ***
## poly(x, 2)1  200.461      4.348    46.1   <2e-16 ***
## poly(x, 2)2   46.905      4.348    10.8    4e-13 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.35 on 38 degrees of freedom
## Multiple R-squared:  0.983,	Adjusted R-squared:  0.982 
## F-statistic: 1.12e+03 on 2 and 38 DF,  p-value: <2e-16
```

Note that this doesn't give exactly the same answer, because it includes the order 0, 1, and 2 terms in the polynomial, which were not included in the `m3` linear model.

Since `abline()` won't work for this model, we now use `predict()` to plot the results:

```r
y.pred <- predict(m3)
plot(x, y, pch = 21, bg = "grey")
grid()
lines(x, y.pred, lwd = 2)
```

![plot of chunk unnamed-chunk-11](figure/lm-unnamed-chunk-11.png) 

Unless told otherwise, predict will return predicted values for `y` at the original `x` locations.

We can use the `confint()` function to get an idea of the 95% confidence limits for the fit:

```r
confint(m3)
```

```
##              2.5 % 97.5 %
## (Intercept) -3.297  0.836
## I(x^2)       1.005  1.096
```

and we can add them to the plot by specifying the `interval="confidence"` argument in `predict()`. Note that `predict()` now returns a 3-column matrix:

```r
y.pred <- predict(m3, interval = "confidence")
str(y.pred)
```

```
##  num [1:41, 1:3] -1.231 -1.165 -0.968 -0.64 -0.18 ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : chr [1:41] "1" "2" "3" "4" ...
##   ..$ : chr [1:3] "fit" "lwr" "upr"
```

```r
plot(x, y, pch = 21, bg = "grey")
grid()
lines(x, y.pred[, 1], lwd = 2)
lines(x, y.pred[, 2], lty = 2)
lines(x, y.pred[, 3], lty = 2)
```

![plot of chunk unnamed-chunk-13](figure/lm-unnamed-chunk-13.png) 











