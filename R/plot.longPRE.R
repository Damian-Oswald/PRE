#' @title Generic plot function for a `longPRE` class object
#' 
#' @description
#' This is the generic plotting function for a `longPRE` class object which is returned by the [`longPRE`] function.
#' 
#' @param x The output of the process rate estimator (over time) function [`longPRE`].
#' @param which Select which part of the plot ought to be plotted. Possible values are `"Interpolation"` for the three driving variable plots, `"Nitrification"`, `"Denitrification"`, and `"Reduction"`.
#' @param ylim.variable List of the y-axis limits for the driving variables. Must contain exactly three named numeric vectors of length 2. See default argument for reference.
#' @param ylim.processes List of the y-axis limits for the estimated process rates. Must contain exactly three named numeric vectors of length 2. See default argument for reference.
#' @param col Plotting color for the uncertainty ranges of the process rate estimates.
#' @param layout Logical. Should the layout be automatically determined? If `FALSE`, no graphical parameters are set, meaning they may be set externally.
#' 
#' @examples
#' # prepare data
#' data <- calculateFluxes()
#' 
#' # run process rate estimator
#' x <- longPRE(data, column = 1, depth = 7.5, n = 10)
#' 
#' # plot result of one variable
#' plot(x, which = "Nitrification")
#' 
#' # plot overview with all variables
#' plot(x)
#' 
#' # plot overview with fixed y-axis limits
#' plot(x, ylim.processes = list(Nitrification = c(-50,50),
#'                               Denitrification = NA,
#'                               Reduction = NA))
#' 
#' @export
plot.longPRE <- function (x, which = c("Interpolation", "Nitrification", "Denitrification","Reduction"), ylim.variable = list(N2ONarea = c(0,10), SP = c(-10,25), d18O = c(20,55)), ylim.processes = list(Nitrification = NA, Denitrification = NA, Reduction = NA), col = "cadetblue", layout = TRUE) {
    
    # save vector with possible processes names
    processes = c("Nitrification", "Denitrification","Reduction")
    
    # set graphical parameters
    if(layout) {
        
        # full component layout matrix
        if("Interpolation"%in%which) {
            L <- matrix(1:3, ncol = 3, byrow = TRUE)
            if(any(processes%in%which)) {
                L <- rbind(L, matrix((max(L)+rep(1:sum(processes%in%which),each=3)),ncol=3,byrow=T))
            }
        } else {
            L <- matrix(1:sum(processes%in%which),ncol=1)
        }
        
        # save graphical parameter settings
        par(oma = c(4,0,1,0)+0.1)
        layout(mat = L)
    }
    
    # save the quantile name extensions (except the middle one, 50%)
    q <- x[["quantiles"]]
    q <- q[q!=0.5]
    q <- paste0("_",q*100,"%")
    p <- length(q)
    
    # save data
    data <- x[["data"]]
    
    # visualize the interpolated measurements, if wished
    if("Interpolation"%in%which) {
        ylab_names <- list(
            N2ONarea = expression("N"[2]*"O - N"[area]),
            SP = "Site preference",
            d18O = expression("delta"^18*"O")
        )
        par(mar = c(3,4,0,2)+0.1)
        for (variable in c("N2ONarea","SP","d18O")) {
            plot(x = data[,"date"], y = data[,variable], ylab = "", ylim = ylim.variable[[variable]], xlab = "", las = 1, type = "l", lwd = 1.5)
            title(ylab = ylab_names[[variable]], line = 2.5)
            grid(col = par()$fg, lwd = 0.5)
            points(x = data[,"date"], y = data[,paste0(variable,"_measurement")], pch = 16, cex = 0.8)
            box()
        }
    }
    
    # visualize all processes in `which`
    par(mar = c(0.1,4,0.1,2)+0.1)
    for (variable in processes[processes%in%which]) {
        plot(x = data[,"date"],
             y = data[,paste0(variable,"_50%")],
             ylim = if(all(is.na(ylim.processes[[variable]]))) {
                 range(data[,grep(variable, colnames(data))])
             } else {
                 ylim.processes[[variable]]
             },
             type = "l",
             xlab = "",
             ylab = "",
             las = 1,
             xaxs = "i",
             axes = FALSE)
        title(ylab = variable, line = 2.5)
        axis(2, las = 1)
        for (i in 1:(p%/%2)) {
            polygon(x = c(data[,"date"], rev(data[,"date"])),
                    y = c(data[,paste0(variable,q[i])], rev(data[,paste0(variable,q[p-i+1])])),
                    col = adjustcolor(col, alpha.f = min(0.3*i,1)),
                    border = FALSE)
        }
        lines(x = data[,"date"], y = data[,paste0(variable,"_50%")], lwd = 1.5)
        grid(col = par()$fg, lwd = 0.5)
        abline(h = 0)
        box()
        legend("bottomright", bty = "n", legend = paste("Non-negative mean:",signif(nonNegative(x[["data"]][,paste0(variable,"_50%")]),4)))
    }
    if(any(processes%in%which)) {
        axis.Date(1, format = "%b %Y", xpd = NA)
        title(xlab = "Date", xpd = NA)
    }
    
    # change graphical parameters back to default values
    par(mfrow=c(1,1), mar = c(4,4,2,1)+.1)
}

