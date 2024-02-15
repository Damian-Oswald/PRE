#' @title Get the indices related to an index
#' 
#' @description
#' In the various computations implemented in the process rate estimator, the task of finding the indices related to the measurements above and below a certain measurement comes up repeatedly. This task is automated with this function. It returns the indices of the top `i_top` and bottom `i_bottom` measurements.
#' 
#' @param data A data frame such as [`measurements`] with at least the following variables: `date`, `column`, and `depth`.
#' @param i The index of the row of interest (in the data frame `data`).
#' @param parameters A list of parameters as it's returned by the [`getParameters`] function.
#' 
#' @export
getIndices <- function(data, i, parameters) {
        with(parameters, {
                
                # get the index of the current depth
                j <- which(depths==data[i,"depth"])
                
                # create a mask of the current column
                c <- data[,"column"] == data[i,"column"]
                
                # create a mask of the current data
                d <- data[,"date"] == data[i,"date"]
                
                # save indices of the top and bottom measurements
                i_top <- which(c & d & data[,"depth"] == depths[j-1])
                i_bottom <- which(c & d & data[,"depth"] == depths[j+1])
                
                # return a list with the relevant indices
                return(list(j = j, i_top = i_top, i_bottom = i_bottom))  
        })
}
