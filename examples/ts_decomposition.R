# Let us consider the data found at
# http://www.esrl.noaa.gov/psd/data/correlation/soi.data
# (monthly timeseries of the Southern Oscillation Index)

# Read the data
X <- scan(url("http://www.esrl.noaa.gov/psd/data/correlation/soi.data"),
          skip=1, nmax=20)

# What is the format of this data?
# It is not just a list of values; year info is in the way; this is a table.
nyears <- 2014 - 1948 + 1
X <- read.table(url("http://www.esrl.noaa.gov/psd/data/correlation/soi.data"),
                skip=1, nrows=nyears)

# Take a look
head(X)

# There was no header; let us give the column names.
colnames(X) <- c("year", month.name)
head(X)

# How do you handle bad/missing values?
# Typically, you use a sentinel value, such as -99.99 here.
# Let us specify all this when reading the data
rm(X)  # Clear name X
X <- read.table(url("http://www.esrl.noaa.gov/psd/data/correlation/soi.data"),
                skip=1,
                nrows=nyears,
                col.names=c("year", month.name),
                na.strings=-99.99)
head(X)
class(X)

# Access a column/dimension
X$December
mean(X$January)
# We have to discard missing (NA) values
mean(X$January, na.rm=TRUE)

# We want to convert this dataframe into a timeseries object
# Keep values only
soi_values <- subset(X, select=-year)
class(soi_values)
nrow(soi_values) * ncol(soi_values)
soi_matrix <- as.matrix(soi_values)
class(soi_matrix)
# Transpose
soi_matrix <- t(soi_matrix)
soi_vector <- as.vector(soi_matrix)
class(soi_vector)
length(soi_vector)
# Where are the missing values?
is.na(soi_vector)

# Create timeseries object
soi_timeseries <- ts(soi_vector, frequency=12, start=c(1948, 1))
class(soi_timeseries)

# Plot timeseries
plot.ts(soi_timeseries)

# Interpolate for missing values?
library(zoo)
# Remove leading and trailing NAs
soi_timeseries <- na.trim(soi_timeseries)
length(soi_timeseries)
which(is.na(soi_timeseries))
# NAs were either leading or trailing, so we have no need for interpolation.

# Our data is seasonal. Let us decompose it.
soi_components <- decompose(soi_timeseries)
soi_components
# Visualize the decomposition
plot(soi_components)

# Estimated seasonal figure
soi_components$figure
# The estimated seasonal factors are given for the months January--December,
# and are the same for each year.
soi_components$seasonal[1:12]
soi_components$seasonal[13:24]
plot.ts(soi_components$seasonal)
plot.ts(soi_components$seasonal[1:12])
plot(soi_components$seasonal[1:12], col="red", pch="*")
# Seasonal adjusting
plot(soi_timeseries - soi_components$seasonal, col="blue",
     ylab="Seasonally adjusted SOI")

# The remainder/residual/random part represents a stochastic process, which is
# typically fitted by an ARIMA model.
plot.ts(soi_components$random, ylab="SOI fluctuations")

# The trend shows the actual Southern Oscillation
plot.ts(soi_components$trend, ylab="SOI trend")
par(new=TRUE)
abline(0, 0)
