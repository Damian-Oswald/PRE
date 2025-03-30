The R package PRE
=================

A repository for the R package containing the code for the process rate estimator (PRE). Note that this README file contains only a very brief documentation. For a more comprehensive overview, please visit the [documentation site](https://damian-oswald.github.io/process-rate-estimator/).

# Installation

You can install this R package directly from GitHub using the following R command.

```r
install.packages("remotes")
remotes::install_github("https://github.com/Damian-Oswald/PRE")
```

Next, attach the library to your search path and you're good to go!

```r
library(PRE)
```

# Loading the data

First, load the prepared hyperparameters.

```r
hyperparameters <- PRE::hyperparameters
```

Next, load the measurements used for the modelling.

```r
measurements <- PRE::measurements
```

Finally, load the parameters for this session.

```r
parameters <- getParameters()
```

You may also load the parameters with some (or any number of) alternative parameter value.

```r
parameters <- getParameters(BD = 1.7)
```

# Impute the missing dependent data

Calculate N2O-N:

```r
data <- getN2ON(data = measurements, parameters = parameters)
```

Interpolate the missing values based on the bandwidths in `hyperparameters` (This function interpolates all values over time; and it also computes and adds the derivatives):

```r
data <- getMissing(data = data, hyperparameters = hyperparameters)
```

Calculate fluxes from measurement data (This function calculates all necessary parameters from the data)

```r
data <- calculateFluxes(data = data, parameters = parameters)
```

Read some details on a function.

```r
help(calculateFluxes)
```

# Run the solver once

Run the solver for some column, depth and date combination.

```r
x <- PRE(data = data, column = 1, depth = 7.5, date = "2016-01-01", n = 200, parameters = parameters)
```

Print out information.

```r
print(x)
```

Generate a plot.

```r
plot(x)
```

Produce a pairwise panel plot.

```r
pairs(x)
```

# Run the solver over time

Run the solver for all the dates.

```r
x <- longPRE(data, column = 6, depth = 90, n = 10)
```

Print information about the PRE results.

```
print(x)
```

Plot the results to get an overview.

```r
plot(x)
```

Plot the results for a specific process.

```r
plot(x, which = "Nitrification")
```

Plot the overview with fixed y-axis limits.

```r
plot(x, ylim.processes = list(Nitrification = c(-50,50), Denitrification = NA, Reduction = NA))
```
