#' @title Generic plot function for a `PRE` class object
#'
#' @description
#' This is the generic plotting function for a [`PRE`] class object which is returned by the [`PRE`] function.
#' The plot visualizes the distribution of the sampled process rate estimates. The estimates that are sampled together are connected via lines.
#' 
#' @param x The output of the process rate estimator function [`PRE`] --- i.e. all the sampled process rate estimates.
#' @param col Color of the points.
#' 
#' @examples
#' # prepare data
#' data <- calculateFluxes()
#' 
#' # run PRE
#' x <- PRE(data, column = 1, depth = 7.5, date = "2016-01-02")
#' 
#' # visualize the results
#' plot(x)
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
