#' @title Run the Process Rate Estimator on all dates for one experimental unit
#' 
#' @description
#' This function runs the Process Rate Estimator (PRE) on a specific depth and column, but on all available dates of this specific depth-column-combination.
#' 
#' @param data A data frame with all relevant variables to run the Process Rate Estimator. Needs to be of the form as the output of [`calculateFluxes`].
#' @param column The column name for which we want to run the PRE.
#' @param depth The depth name for which we want to run the PRE.
#' @param n The number of samples solved with the [BB::multiStart] solver.
#' @param parameters A list of parameters to be used to calculate the [`stateEquations`].
#' @param tolerance The convergence tolerance for the [BB::multiStart] solver.
#' @param nonNegative Should negative solutions be removed before retrieving the quantiles?
#' @param quantiles The probabilities of the quantiles to be returned from the sampled set.
#' @param verbose Should a progress bar be printed?
#' 
#' @export
longPRE <- function(data = calculateFluxes(), column = NULL, depth = NULL, n = 100, parameters = getParameters(), tolerance = 1e3, nonNegative = FALSE, quantiles = c(0.025, 0.25, 0.5, 0.75, 0.975), verbose = TRUE) {
    
    # save names of the processes
    processes <- c("Nitrification", "Denitrification", "Reduction")
    
    # make sure that the "center" of the quantiles is equal to 0.5, and that the quantiles are symmetric
    l <- length(quantiles)
    centerIsZeroPointFive <- isTRUE(all.equal(quantiles[l%/%2+1],0.5))
    quantilesAreSymmetric <- isTRUE(all.equal(head(quantiles,l%/%2)+rev(tail(quantiles,l%/%2)),rep(1,l%/%2)))
    if(!centerIsZeroPointFive | !quantilesAreSymmetric) stop("The chosen quantiles violate the minimal condition. Make sure that the quantiles (1) contain 0.5 and (2) are symmetric.")
    
    # read out all dates on which we have data available
    dates <- data[data$column==column & data$depth==depth, "date"]
    
    # create an empty data frame with columns for all combinations of quantiles and processes
    results <- data.frame(matrix(NA, ncol = 3+3*l, nrow = length(dates)))
    rownames(results) <- dates
    colnames(results) <- c(processes, PRE:::getPercentNames(quantiles))
    
    # loop over every date, run PRE, save result in data frame
    for (t in 1:length(dates)) {
        x <- PRE::PRE(data = data, column = column, depth = depth, date = dates[t], n = n, parameters = parameters, tolerance = tolerance, nonNegative = nonNegative)
        results[t,] <- c(colMeans(x), as.numeric(t(apply(x, 2, quantile, probs = quantiles))))
        if(verbose) progressbar(t,length(dates))
    }
    
    # combine the results with the relevant subset of the data and return it
    df <- cbind(data[data$column==column&data$depth==depth,], results)
    
    # combine all neccesary information to a list
    output <- list(
        data = df,
        column = column,
        depth = depth,
        n = n,
        processes = colMeans(df[,processes]),
        quantiles = quantiles,
        nonNegative = nonNegative
    )
    
    # assign `longPRE` class to output
    class(output) <- "longPRE"
    
    # return output
    return(output)
}
