#' @title State equation set
#' 
#' @description The state equation set are the core of the process rate estimator (PRE). This set of three functions is evaluated repeatedly by the solver in order to find well suiting process rates.
#' 
#' @param x A vector with the named values of N₂O `Nitification`, `Denitrification`, and `Reduction`.
#' @param parameters A list of parameters containing the isotope end members. By default, the [`getParameters`] function is used to return these values.
#' @param fluxes A list of `N2ONarea`, `SP` and `d18O` as well as their fluxes from other increments and derivative. Essentially, this is one row of the data as it's returned by the [`calculateFluxes`] function as a list.
#' 
#' @details
#' 
#' The process rate estimator includes three-state functions, describing the change in N₂O concentrations over time.
#' The change in N₂O concentrations in each depth increment over time \eqn{\frac{\Delta}{\Delta t}[{\text N_2 \text O}]} depends on the flux of N₂O entering the depth increment from the top or the bottom through diffusion (\eqn{\text F_\text{t,i}} and \eqn{\text F_\text {b,i}}, respectively), the flux of N₂O leaving the depth increment through diffusion (\eqn{\text F_\text {out}}), the rate of N₂O produced through nitrification (`N2Onit`), the rate of N₂O produced through denitrification (`N2Oden`), and the rate of N₂O reduced to N₂ (`N2Ored`).
#' \deqn{\frac{\Delta[{\text N_2 \text O}]}{\Delta t} = \text F_{\text{t,i}} + \text F_{\text{b,i}}  + {\text N_2 \text O}_{\text{nit.}} + {\text N_2 \text O}_{\text{den.}} + {\text N_2 \text O}_{\text{red.}}}
#' For the equation of the change of site preference over time, we'll use the substitutions \eqn{A_1}, \eqn{A_2} and \eqn{A_3}, as the expression is rather long.
#' \deqn{\frac{\Delta \text{SP}}{\Delta t} = \frac{A_1 + A_2 + A_3}{[{\text N_2 \text O}]}}
#' \deqn{A_1 = \text F_{\text{t,i}}(\text{SP}_{\text{t,i}} - \eta \text{SP}_\text{diff.} - \text{SP}) + \text F_{\text{b,i}}(\text{SP}_{\text{b,i}} - \eta \text{SP}_\text{diff.} - \text{SP})}
#' \deqn{A_2 = {\text N_2 \text O}_{\text{nit.}}(\text{SP}_\text{nit.} - \text{SP}) + {\text N_2 \text O}_{\text{den.}}(\text{SP}_\text{den.} - \text{SP})}
#' \deqn{A_3 = - \eta \text{SP}_\text{diff.} \text F_{\text{out}} - \eta\text{SP}_\text{red.} {\text N_2 \text O}_{\text{red.}}}
#' Similar to \eqn{\text{SP}}, the change in \eqn{\delta^{18}\text O} over time in each time point and depth increment can be described as:
#' \deqn{\frac{\Delta\delta^{18}\text{O}}{\Delta t} = \frac{B_1 + B_2 + B_3}{[{\text N_2 \text O}]}}
#' \deqn{B_1 = \text F_{\text{t,i}}(\delta^{18}\text{O}_{\text{t,i}} - \eta^{18}\text{O}_\text{diff.} - \delta^{18}\text{O}) + \text F_{\text{b,i}}(\delta^{18}\text{O}_{\text{b,i}} - \eta^{18}\text{O}_\text{diff.} - \delta^{18}\text{O})}
#' \deqn{B_2 = {\text N_2 \text O}_{\text{nit.}}(\delta^{18}\text{O}_\text{nit.} - \delta^{18}\text{O}) + {\text N_2 \text O}_{\text{den.}}(\delta^{18}\text{O}_\text{den.} - \delta^{18}\text{O})}
#' \deqn{B_3 = - \eta^{18}\text{O}_\text{diff.} \text F_{\text{out}} - \eta^{18}\text{O}_\text{red.} \text{N}_2 \text{O}_{\text{red.}}}
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
