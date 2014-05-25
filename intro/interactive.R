# This is a comment.
# In the command-line interpreter, use R like a calculator:
1 + 2
3 / 5
# List objects in your current environment:
ls()
# We can *assign* a value to an object, if we give it a name:
a <- 3 / 5
ls()

# Types
typeof(a)
typeof("word")
typeof(as.integer(a))
# Notice that we have nested one function inside of another.
typeof(is.integer(a))
is.integer(a)
# Show help using F1 (https://www.rstudio.com/ide/docs/using/keyboard_shortcuts)

# Data structures
## Atomic Vectors
x <- c(1, 2, 3, 4)
x
length(x)
instructors <- c("Clark", "Dan", "Marianne")
typeof(instructors)
# Access element
instructors[1]
# Append element
c(x, 6)
# Sequence of numbers
1:5
seq(5)
x <- seq(from=0, to=10, by=0.1)
x
## Lists (generic vectors)
l <- list(1, "hello", TRUE)
l
# Access element: Elements are indexed by double brackets.
l[[3]]
# Single brackets will return a(nother) list.
l[3]
length(l)
# Append element
l[[length(l) + 1]] <- FALSE
l
# Give sublist a name
xlist <- list(dim1="Name", dim2=1:5, data=head(iris))
xlist
xlist$data
xlist[[3]]

# Plotting
plot(x, sin(x))

# Stats Functions
mean(sin(x))
sd(sin(x))

# Model Fitting
x
y <- 2 * x + 4.5 + runif(x)
plot(x, y)
y0 <- y
y[40:45] <- NaN
plot(x, y)
original_set <- list(x=x, y=y0)
original_set$y
trivial_fit <- smooth.spline(original_set)
refill <- predict(trivial_fit, x[40:45])
refill
y0[40:45]

plot(x, y, xlim=c(0, 10), ylim=c(5, 25))
par(new=TRUE)
plot(refill, col='red', xlim=c(0, 10), ylim=c(5, 25))
