#' @title Generic print function for a `longPRE` class object
#' 
#' @param x The output of the process rate estimator function `longPRE`.
#' @param replaceNegative Logical (`TRUE`/`FALSE`). Should the negative values be replaced by zero in order to calculate the mean rates?
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
