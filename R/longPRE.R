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
longPRE <- function(data, column, depth, n = 100, nonNegative = FALSE) {
    
    # read out all dates on which we have data available
    dates <- data[data$column==column & data$depth==depth, "date"]
    
    # run the PRE for every date, save the results as a list
    results <- lapply(dates, function(x) PRE::PRE(data = data, column = column, depth = depth, date = x, n = n, nonNegative = FALSE))
    
    # create the column names of the results based on variables and quantiles
    colnames <- apply(expand.grid(colnames(results[[1]]),rownames(results[[1]])), 1, paste, collapse = "_")
    
    # restructure the results array-like list to a data frame
    results <- t(sapply(results, function(x) as.numeric(t(x))))
    
    # assign the created column names
    colnames(results) <- colnames
    
    # combine the results with the relevant subset of the data and return it
    cbind(data[data$column==column&data$depth==depth,], results)
}
