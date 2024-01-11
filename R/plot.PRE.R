#' @title Generic plot function for a `PRE` class object
#' 
#' @param x The output of the process rate estimator function `PRE`.
#' 
#' @export
plot.PRE <- function (x, col = "grey") {
    plot(NA, ylim = range(x), xlim = c(0.5,3.5), axes = FALSE, ylab = "Rate", xlab = "")
    for (i in 1:nrow(x)) {
        lines(x = 1:3, y = x[i,], col = col, pch = 16, cex = 0.8, type = "o", lwd = 0.3)
    }
    boxplot(x, add = TRUE, lty = 1, axes = FALSE, col = "transparent", boxwex = 0.2, outline = FALSE)
    axis(1, 1:3, colnames(x), col = NA)
    axis(2, las = 1)
}
