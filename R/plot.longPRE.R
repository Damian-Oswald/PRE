#' @title Generic plot function for a `longPRE` class object
#' 
#' @param x The output of the process rate estimator (over time) function `longPRE`.
#' 
#' @export
plot.longPRE <- function (x, which = c("Nitrification", "Denitrification","Reduction")) {
    
    # save the quantile name extensions (except the middle one, 50%)
    q <- x[["quantiles"]]
    q <- q[q!=0.5]
    q <- paste0("_",q*100,"%")
    p <- length(q)
    
    # save data
    data <- x[["data"]]
    
    # nitrification
    for (variable in which) {
        plot(x = data[,"date"],
             y = data[,paste0(variable,"_50%")],
             ylim = range(data[,grep(variable, colnames(data))]),
             type = "l",
             xlab = "Time",
             ylab = paste(variable,"process rate"),
             las = 1,
             xaxs = "i")
        for (i in 1:(p%/%2)) {
            polygon(x = c(data[,"date"], rev(data[,"date"])),
                    y = c(data[,paste0(variable,q[i])], rev(data[,paste0(variable,q[p-i+1])])),
                    col = adjustcolor("cadetblue", alpha.f = min(0.3*i,1)),
                    border = FALSE)
        }
        lines(x = data[,"date"], y = data[,paste0(variable,"_50%")], lwd = 1.5)
        grid(col = 1, lwd = 0.5)
        abline(h = 0)
        box()
    }
}
