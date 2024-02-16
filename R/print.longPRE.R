#' @title Generic print function for a `longPRE` class object
#' 
#' @description
#' This is the generic printing function for a `longPRE` class object which is returned by the [`longPRE`] function.
#' The function prints out a summary of the distribution of the sampled process estimates over all dates.
#' Additionally, it shows the percentage of dates on which the median process rate was estimated to be negative.
#' 
#' @param x The output of the process rate estimator function `longPRE`.
#' @param replaceNegative Logical (`TRUE`/`FALSE`). Should the negative values be replaced by zero in order to calculate the mean rates?
#' 
#' @examples
#' # prepare data
#' data <- calculateFluxes()
#' 
#' # run process rate estimator
#' x <- longPRE(data, column = 1, depth = 7.5, n = 10)
#' 
#' # print out basic information
#' print(x)
#' 
#' # plot result of one variable
#' plot(x, which = "Nitrification")
#' 
#' @export
print.longPRE <- function (x, replaceNegative = TRUE) {
    f <- function(char) cat(strrep(char, getOption("width")-5), "\n")
    f("=")
    cat(sprintf("Results of the PRE over time%s:\n",ifelse(replaceNegative, " (Negative values are treated as zeros)", "")))
    f("-")
    if(replaceNegative) {
        Q <- sapply(c("Nitrification","Denitrification","Reduction"), function(variable) sapply(x$quantiles, function(q) PRE::nonNegative(x$data[,paste0(variable,"_",q*100,"%")])))
    } else {
        Q <- sapply(c("Nitrification","Denitrification","Reduction"), function(variable) sapply(x$quantiles, function(q) mean(x$data[,paste0(variable,"_",q*100,"%")])))
    }
    rn <- paste0(x$quantiles*100,"%")
    rownames(Q) <- paste0(strrep(" ", 13 - nchar(rn)), rn)
    print(signif(Q, 3))
    N <- 100*sapply(c("Nitrification_50%","Denitrification_50%","Reduction_50%"), function(variable) mean(x$data[,variable] < 0))
    N <- t(N)
    colnames(N) <- strrep(" ", nchar(colnames(Q)))
    rownames(N) <- "Negative [%]:"
    print(signif(N,3))
    f("=")
}
