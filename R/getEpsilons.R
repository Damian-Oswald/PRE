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
getEpsilons <- function(SPnit = 34.4,
                        SPden = -2.4,
                        eSPdiffusion = 1.55,
                        eSPred = -5.3,
                        d18Onit = 36.5,
                        d18Oden = 11.1,
                        e18Odiffusion = -7.79,
                        e18Ored = 3*eSPred) {
        list(SPnit = SPnit,
             SPden = SPden,
             eSPdiffusion = eSPdiffusion,
             eSPred = eSPred,
             d18Onit = d18Onit,
             d18Oden = d18Oden,
             e18Odiffusion = e18Odiffusion,
             e18Ored = e18Ored)
}