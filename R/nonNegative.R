#' @title Apply a function on a vector with removed negative values
#' 
#' @description
#' This function applies a function `f` to a vector `x`, but first sets all negative values in `x` to zero.
#' 
#' @param x A vector.
#' @param n A function to be applied to the vector `x`. By default, this is [base::mean].
#' 
#' @export
nonNegative <- function(x, f = mean){
    x[x<0] <- 0
    return(f(x))
}