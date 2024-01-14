#' @title Interpolate missing measurement data using kernel regression
#' 
#' @description
#' This function interpolates the missing values of all variable names in `hyperparameters`.
#' Also, it returns the derivatives of the smoothing functions used.
#' For both procedures, it calls the [getDerivative] function -- simply with `n = 0` and `n = 1`.
#' 
#' @param data The original data we wish to interpolate. Needs to have the same variables as [measurements].
#' @param hyperparameters An array of hyperparameters (bandwidths) used in the kernel regression process.
#' 
#' @export
getMissing <- function(data = getN2ON(), hyperparameters = PRE::hyperparameters) {
    
    for (variable in dimnames(hyperparameters)[[3]]) {
        
        # make a copy of the *measured* variable, as the original variable will be overwritten
        data[,paste0(variable,"_measurement")] <- data[,variable]
        
        # loop over every column for which we have a hyperparameter available
        for (column in dimnames(hyperparameters)[[2]]) {
            
            # loop over every depth for which we have a hyperparameter available
            for (depth in dimnames(hyperparameters)[[1]]) {
                
                # save the indices of matching column and depths (selects all the respective dates)
                indices <- which(data[,"column"]==column & data[,"depth"]==as.numeric(depth))
                
                # interpolate the variable (the `getDerivative` function is used to estimate the derivative, but with a zero order (n = 0) derivative, which is the function itself)
                data[indices, variable] <- PRE::getDerivative(x = as.numeric(data[indices,"date"]),
                                                             y = data[indices,variable],
                                                             bandwidth = hyperparameters[as.character(depth),as.character(column),variable],
                                                             n = 0)
                
                # estimate the derivative of the variable with respect to time
                data[indices, paste0(variable,"_derivative")] <- PRE::getDerivative(x = as.numeric(data[indices,"date"]),
                                                                                   y = data[indices,variable],
                                                                                   bandwidth = hyperparameters[as.character(depth),as.character(column),variable],
                                                                                   n = 1)
            }
        }
    }
    
    # return the modified data frame
    return(data)
}
