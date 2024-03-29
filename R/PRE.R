#' @title Run the Process Rate Estimator on one Date
#' 
#' @description
#' This function runs the Process Rate Estimator (PRE) on a specific depth, column and date.
#' It returns an object of class `PRE`, which allows the use of generic plot and print functions.
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
#' @examples
#' # prepare data
#' data <- calculateFluxes()
#' 
#' # run PRE
#' x <- PRE(data, column = 1, depth = 7.5, date = "2016-01-02")
#' 
#' # print some basic information
#' print(x)
#' 
#' # visualize the results
#' plot(x)
#' 
#' # show the correlations
#' pairs(x)
#' 
#' @export
PRE <- function(data, column, depth, date, nonNegative = FALSE, n = 100, parameters = getParameters(), tolerance = 1e3, verbose = TRUE) {
    
    # run repeatedly with varying starting values using the multistart package
    solution <- BB::multiStart(par = matrix(runif(n*3, 0, 40), ncol = 3),
                               fn = PRE::stateEquations,
                               action = "solve",
                               control = list(tol = tolerance),
                               details = FALSE,
                               quiet = TRUE,
                               parameters = parameters,
                               fluxes = as.list(data[data$column==column & data$depth==depth & data$date==date,]))
    
    # select all the converged solutions
    solution <- with(solution, par[converged,])
    colnames(solution) = c("Nitrification", "Denitrification", "Reduction")
    
    # select only solutions for which all (estimated) processes are is non-negative
    if(nonNegative) solution <- solution[apply(solution, 1, function(x) all(x>0)),]
    
    # assign class to solution
    solution <- as.data.frame(solution)
    class(solution) <- c("PRE","data.frame")
    
    # return solutions
    return(solution)

}
