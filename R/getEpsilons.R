#' @title Get the isotope end members
#' 
#' @param eta_SP_diffusion End member for diffusion of site-preference \insertCite{well2008isotope}{PRE}.
#' @param eta_18O_diffusion End member for diffusion of `d18O` \insertCite{well2008isotope}{PRE}.
#' @param SP_nitrification Site-preference for nitrification \insertCite{decock2013potential}{PRE}.
#' @param d18O_nitrification `d18O` for nitrification \insertCite{lewicka2017quantifying}{PRE}.
#' @param SP_denitrification Site-preference for denitrification \insertCite{decock2013potential}{PRE}.
#' @param d18O_denitrification `d18O` for denitrification \insertCite{lewicka2017quantifying}{PRE}.
#' @param eta_SP_reduction End member for SP reduction \insertCite{denk2017nitrogen}{PRE}.
#' @param eta_18O_reduction End member for `d18O` reduction \insertCite{lewicka2017quantifying}{PRE}.
#' 
#' @returns A list of the eight isotope end members analogous to the function arguments.
#' 
#' @importFrom Rdpack reprompt
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export
getEpsilons <- function(SP_nitrification = 34.4,
                        SP_denitrification = -2.4,
                        eta_SP_diffusion = 1.55,
                        eta_SP_reduction = -5.3,
                        d18O_nitrification = 36.5,
                        d18O_denitrification = 11.1,
                        eta_18O_diffusion = -7.79,
                        eta_18O_reduction = 3*eta_SP_reduction) {
        list(SP_nitrification = SP_nitrification,
             SP_denitrification = SP_denitrification,
             eta_SP_diffusion = eta_SP_diffusion,
             eta_SP_reduction = eta_SP_reduction,
             d18O_nitrification = d18O_nitrification,
             d18O_denitrification = d18O_denitrification,
             eta_18O_diffusion = eta_18O_diffusion,
             eta_18O_reduction = eta_18O_reduction)
}