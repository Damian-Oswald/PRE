#' @title Calculate fluxes from measurement data
#' 
#' @description
#' This function calculates nitrous oxide fluxes and other parameters from pre-processed measurement data (see [PRE::getMissing] for more information on the pre-processing).
#' 
#' @param data Measurement data from which one wants to calculate fluxes. This needs to be a `data.frame` which includes variables `date`, `column`, `depth`, `increment`, `moisture`, `N2O`, `SP`, and `d18O`. For further details and a reference data frame, read the description of the [`measurements`] data.
#' @param parameters A set of parameters as returned by the function [`getParameters`]. These will be used in calculating the returned flux data.
#' @param verbose Logical. Should a progress bar be printed?
#' 
#' @examples
#' # load the parameters with an alternative parameter value
#' parameters <- getParameters(BD = 1.7)
#' 
#' # calculate N2O-N
#' data <- getN2ON(data = PRE::measurements, parameters = parameters)
#' 
#' # interpolate the missing values based on the bandwidths in `hyperparameters` (This function interpolates all values over time; and it also computes and adds the derivatives)
#' data <- getMissing(data = data, hyperparameters = PRE::hyperparameters)
#' 
#' # calculate fluxes from measurement data (This function calculates all necessary parameters from the data)
#' data <- calculateFluxes(data = data, parameters = parameters)
#' 
#' # look at the resulting data frame
#' View(data)
#' 
#' @details
#' This function calculates a range of parameters and variables according to the equations listed below.
#' First, the mean moisture between two depth increments \eqn{\theta_w} is calculated.
#' \deqn{\theta_{w} = \frac{1}{2}(m_d + m_{d+1})}
#' From this, the air-filled pore space is computed.
#' \deqn{\theta_{a} = 1-\frac{\theta_{w}}{\theta_{t}}}
#' In a next step, the Gas diffusion coefficient is calculated \insertCite{millington1961permeability}{PRE}.
#' \deqn{D_{\text s} = \left( \frac{\theta_w^{10/3} + D_{\text fw}}{H} + \theta_a^{10/3} \times D_{\text fa} \right) \times \theta_T^{-2}}
#' Note that the diffusivity of N₂O in air \eqn{D_{\text fa}} is a fixed value that is computed by the [getParameters] function.
#' With all of these values prepared, the N₂O gradient (\eqn{\frac{dC}{dZ}}) is computed.
#' \eqn{dC} is the change of N₂O concentration from one layer to the next, while \eqn{dZ} is the vertical distance from one measurement depth to the next.
#' The atmospheric nitrous oxide concentration is once again passed by the [getParameters] function.
#' Finally, the N₂O flux is calculated.
#' \deqn{F_{\text{calc}} = \frac{dC}{dZ} D_{\text s} \rho}
#' Here, \eqn{\rho} is the gas density of N₂O. This variable is split into "in" and "out" fluxes from the top and bottom layer. For the top layer, a fixed \eqn{F_{\text{top,in}}} is assumed which is passed by [getParameters]. In the lowest layer, \eqn{F_{\text{bottom,in}}} is assumed to be zero.
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export
calculateFluxes <- function(data = getMissing(), parameters = PRE::getParameters(), verbose = TRUE) {
    
    # attach the parameters to function environment
    list2env(parameters, environment())
    
    # loop through every complete observation in the data frame
    for (i in 1:nrow(data)) {
        
        # attach the related indices and masks of the current index i to the search path
        list2env(PRE::getIndices(data, i, parameters), environment())
        
        # calculate the mean of the current depth moisture and the one above (if it is the top layer, that's the mean of one observation)
        data[i,"theta_w"] <- mean(c(data[i, "moisture"], data[i_top, "moisture"]), na.rm = TRUE)
        
        # calculate air-filled pore space
        data[i,"theta_a"] <- with(data[i,], 1 - theta_w/theta_t)
        
        # calculate Ds
        data[i,"Ds"] <- with(data[i,], ((theta_w^(10/3)*D_fw)/H+theta_a^(10/3)*D_fa)*theta_t^-2)
        
        # calculate the N2O concentration gradient dC/cZ
        dC <- (data[i,"N2O"] - ifelse(j==1, N2Oatm, data[i_top,"N2O"]))/1000000
        if(length(dC)==0) dC <- NA
        dZ <- (diff(c(0,depths))/100)[j] # dZ is the distance from one measurement depth to the next in meters
        data[i,"dCdZ"] <- dC/dZ
        
        # calculate F_calc, considering flux is upward (originally in mg N2O-N/m2/s, converted to g N/ha/day)
        data[i,"F"] <- with(data[i,], dCdZ * Ds * rho * 10000 * 3600 * 24/1000)
        
        # print out a progress bar
        if(verbose) PRE:::progressbar(i, nrow(data)*2)
    }
    
    # start a new loop, to make sure all `F` have been calculated already
    for (i in 1:nrow(data)) {
        
        # attach the related indices and masks of the current index i to the search path
        list2env(PRE::getIndices(data, i, parameters), environment())
        
        # save F_calc for top and bottom
        F_top <- data[i,"F"]
        if(j==5) F_bottom <- 0 else F_bottom <- data[i_bottom,"F"]
        
        # avoid empty F_top or F_bottom
        if(length(F_top)==0) F_top <- NA
        if(length(F_bottom)==0) F_bottom <- NA
        
        # calculate inputs and outputs
        data[i,"F_top_in"] <- ifelse(F_top > 0, 0, abs(F_top))
        data[i,"F_top_out"] <- ifelse(F_top < 0, 0, abs(F_top))
        data[i,"F_bottom_in"] <- ifelse(F_bottom < 0, 0, abs(F_bottom))
        data[i,"F_bottom_out"] <- ifelse(F_bottom > 0, 0, abs(F_bottom))
        
        # calculate F_out
        data[i,"F_out"] <- with(data[i,], F_bottom_out + F_top_out)
        
        # save SP and d18O inputs from the bottom layer (if we're in the deepest increment, the inputs are all zero)
        if(j==5) {
            data[i, "SP_bottom"] <- 0
            data[i,"d18O_bottom"] <- 0
        } else {
            data[i, "SP_bottom"] <- ifelse(length(data[i_bottom, "SP"])==1, data[i_bottom, "SP"], NA)
            data[i,"d18O_bottom"] <- ifelse(length(data[i_bottom, "d18O"])==1, data[i_bottom, "d18O"], NA)
        }
        
        # save SP and d18O inputs from the top layer (if we're in the surface increment, the inputs are from the atmosphere)
        if(j==1) {
            data[i, "SP_top"] <- SPatm
            data[i, "d18O_top"] <- d18Oatm
        } else {
            data[i, "SP_top"] <- ifelse(length(data[i_top, "SP"])==1, data[i_top, "SP"], NA)
            data[i, "d18O_top"] <- ifelse(length(data[i_top, "d18O"])==1, data[i_top, "d18O"], NA)
        }
        
        # print out a progress bar
        if(verbose) PRE:::progressbar(nrow(data)+i, nrow(data)*2)
    }
    
    return(data)
}
