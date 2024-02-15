#' @title Hypertuning parameters for the Process Rate Estimator
#' 
#' @description This is a three-dimensional array, where the first dimension are the depths, the second are the columns, and the third are the specific variables such as `N2O`, `SP`, or `d18O`. These hypertuning parameters (specifically, they are bandwidths for the [np::npreg] function) were optimized on the [PRE::measurements] data.
#' 
#' @usage 
#' data(hyperparameters, package = "PRE")
#' 
#' @source <https://writethesourceurlorthepaper.com>
"hyperparameters"