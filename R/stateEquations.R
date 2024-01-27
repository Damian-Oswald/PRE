#' @title State equation set
#' 
#' @description The state equation set are the core of the process rate estimator (PRE).
#' 
#' @param x A vector with the named values of N₂O `Nitification`, `Denitrification`, and `Reduction`.
#' @param parameters A list of parameters containing the isotope end members. By default, the [`getParameters`] function is used to return these values.
#' @param fluxes A list of `N2ONarea`, `SP` and `d18O` as well as their fluxes from other increments and derivative. Essentially, this is one row of the data as it's returned by the [`calculateFluxes`] function as a list.
#' 
#' @details The state equation set incorporates three distinct equations.
#' \deqn{\frac{\Delta[N_2O]}{\Delta t}}
#' 
#' @export
stateEquations <- function(x = c(Nitrification = NA, Denitrification = NA, Reduction = NA),
                           parameters = getEpsilons(),
                           fluxes = list(F_top_in = NA, F_bottom_in = NA, F_out = NA, SP_top = NA, SP = NA, SP_bottom = NA, N2ONarea = NA, d18O_top = NA, d18O_bottom = NA, d18O = NA, N2ONarea_derivative = NA, SP_derivative = NA, d18O_derivative = NA)) {
   
   # name the elements of `x`
   names(x) <- c("Nitrification", "Denitrification", "Reduction")
   
   # make sure all function arguments are list
   if(!is.atomic(x) | !is.list(parameters) | !is.list(fluxes)) stop("Please make sure that `x` is an atomic vector and `parameters` and `fluxes` are lists!\n")
   
   # compute difference between expected and calculated derivatives using the state equations
   with(c(as.list(x),parameters,fluxes), {
      f <- numeric(3)
      f[1] <- F_top_in + F_bottom_in - F_out + Nitrification + Denitrification - Reduction - N2ONarea_derivative
      f[2] <- (F_top_in*(SP_top - eta_SP_diffusion - SP) + F_bottom_in*(SP_bottom - eta_SP_diffusion - SP) + Nitrification*(SP_nitrification-SP) + 
                  Denitrification*(SP_denitrification-SP)-(eta_SP_diffusion*F_out + eta_SP_reduction*Reduction))/N2ONarea - SP_derivative
      f[3] <- (F_top_in*(d18O_top - eta_18O_diffusion - d18O) + F_bottom_in*(d18O_bottom - eta_18O_diffusion - d18O) + 
                  Nitrification*(d18O_nitrification-d18O) + Denitrification*(d18O_denitrification-d18O)-(eta_18O_diffusion*F_out + eta_18O_reduction*Reduction))/N2ONarea - d18O_derivative
      return(f)
   })
}
