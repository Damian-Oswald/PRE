#' @title Get Process Names with quantile percentages
#' 
#' @description
#' This is an internal function which takes the quantiles as an argument and creates variable names of the quantiles and processes combinations.
#' 
getPercentNames <- function(quantiles, process = c("Nitrification","Denitrification","Reduction")) apply(expand.grid(process,paste0(quantiles*100,"%",sep="")), 1, paste, collapse = "_")
