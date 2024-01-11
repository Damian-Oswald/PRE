#' @title Get Process Names with Quantile Percentages
#' 
getPercentNames <- function(quantiles, process = c("Nitrification","Denitrification","Reduction")) apply(expand.grid(process,paste0(quantiles*100,"%",sep="")), 1, paste, collapse = "_")
