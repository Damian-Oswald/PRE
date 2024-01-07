#' @title Run the Process Rate Estimator on all dates for one experimental unit
#' 
#' @description
#' This function runs the Process Rate Estimator (PRE) on a specific depth and column, but on all available dates.
#' 
#' @param data A data frame with all relevant variables to run the Process Rate Estimator.
#' @param column The column name for which we want to run the PRE.
#' @param depth The depth name for which we want to run the PRE.
#' @param date The date (`DD-MM-YYYY`) for which we want to run the PRE.
#' @param nonNegative Should negative solutions be removed before retrieving the quantiles?
#' @param n The number of samples solved with the [BB::multiStart] solver.
#' @param quantiles The probabilities of the quantiles to be returned from the sampled set.
#' @param verbose Should a success message be printed after a model run?
#' 
#' @export
longPRE <- function(data, column, depth, n = 100, nonNegative = FALSE, quantiles = c(0.025, 0.25, 0.5, 0.75, 0.975)) {
    
    # make sure 50% is in quantiles
    if(!0.5%in%quantiles) quantiles <- append(quantiles, 0.5, after=length(quantiles)%/%2)
    
    # read out all dates on which we have data available
    dates <- data[data$column==column & data$depth==depth, "date"]
    
    # run the PRE for every date, save the results as a list
    results <- lapply(dates, function(x) PRE::PRE(data = data, column = column, depth = depth, date = x, n = n, quantiles = quantiles, nonNegative = FALSE))
    
    # create the column names of the results based on variables and quantiles
    colnames <- apply(expand.grid(colnames(results[[1]]),rownames(results[[1]])), 1, paste, collapse = "_")
    
    # restructure the results array-like list to a data frame
    results <- t(sapply(results, function(x) as.numeric(t(x))))
    
    # assign the created column names
    colnames(results) <- colnames
    
    # combine the results with the relevant subset of the data and return it
    df <- cbind(data[data$column==column&data$depth==depth,], results)
    
    # combine all neccesary information to a list
    output <- list(
        data = df,
        column = column,
        depth = depth,
        n = n,
        quantiles = quantiles,
        nonNegative = nonNegative
    )
    
    # assign `longPRE` class to output
    class(output) <- "longPRE"
    
    # return output
    return(output)
}
