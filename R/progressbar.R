#' @title Show the progress in the console
#' 
#' @description
#' This function prints out a progress bar in the console.
#' 
#' @param i The current index.
#' @param n The maximum index.
#' 
progressbar <- function (i, n) {
   w <- (options("width")$width - 8)/n
   cat("\r[", strrep("|", ceiling(i * w)), ">", strrep("-", floor((n - i) * w)), "] ", paste0(format(round(i/n * 100, 1), nsmall = 1), "%"), sep = "")
   if(i==n) cat("\n")
}
