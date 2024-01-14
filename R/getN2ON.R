#' @title Calculate the volumetric and area N₂O-N
#' 
#' @description This function calculates the volumetric and the area N₂O-N from the soil N₂O concentration (as stored in the variable `N2O` of [`PRE::measurements`]).
#' 
#' @param data A data set of original measurements in the form of [measurements].
#' @param parameters A list of parameters to be used for the calculation of `N2ONvolume` and `N2ONarea`. To see how to use alternative parameters, visit [PRE::getParameters].
#' 
#' @details In order to calculate the volume N₂O-N, the following equation is used:
#' \deqn{\text N_2 \text {O-N}_\text{volume} =  \frac{28[\text{N}_2\text O]}{\text {R} \cdot \text {T}}}
#' Where \eqn{\text R} is the gas constant and \eqn{\text T} is the temperature.
#' In a second step, the per-area N₂O-N is calculated from the volumetric N₂O-N.
#' \deqn{\text N_2 \text {O-N}_\text{area} = \text N_2 \text {O-N}_\text{volume} \times \frac{1}{100} \texttt{increment} \times \frac{10^4}{10^3} \left(\theta_t - \texttt{moisture} \right)}
#' Note that the scalar values handle the unit conversions.
#' 
#' @usage
#' data <- getN2ON(data = PRE::measurements,
#'                 parameters = getParameters())
#' 
#' @export
getN2ON <- function(data = PRE::measurements, parameters = getParameters()) {
    
    # attach the parameters to function environment
    list2env(parameters, environment())
    
    # calculate the volumetric and area N2O-N
    data[,"N2ONvolume"] <- with(data, N2O * 1/(R*temperature)*28)
    data[,"N2ONarea"] <- with(data, N2ONvolume * increment/100 * (theta_t - moisture) * 10000/1000)
    
    return(data)
}
