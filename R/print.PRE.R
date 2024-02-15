#' @title Generic print function for a `PRE` class object
#' 
#' @description
#' This is the generic printing function for a [`PRE`] class object which is returned by the [`PRE`] function.
#' The function prints out a summary of the distribution of the sampled process estimates.
#' Additionally, it shows how many solutions converged, and how many have resulted in negative process rates.
#' 
#' @param x The output of the process rate estimator function `PRE`.
#' 
#' @examples
#' # prepare data
#' data <- calculateFluxes()
#' 
#' # run PRE
#' x <- PRE(data, column = 1, depth = 7.5, date = "2016-01-02")
#' 
#' # print some basic information
#' print(x)
#' 
#' @export
print.PRE <- function (x) {
    f <- function(char) cat(strrep(char, getOption("width")-5), "\n")
    f("=")
    cat(sprintf("Results of the PRE (with %s converged solutions):\n",nrow(x)))
    f("-")
    print(signif(apply(x, 2, quantile, probs = c(0.025, 0.75, 0.5, 0.25, 0.975)), 3))
    f("-")
    r <- sum(apply(x, 1, function(z) any(z<0)))
    cat(sprintf("%s solutions have estimated negative rates (%s%%).\n",r,signif(100*(r/nrow(x)),3)))
    f("=")
}
