#' @title Get the PRE parameters.
#' 
#' @description This function returns the initial parameters necessary to run the Process Rate Estimator.
#' To run this function, no function arguments have to be provided, however, if any default values are changed, any dependencies are calculated accordingly.
#' 
#' @param BD Bulk density.
#' @param PD Particle density.
#' @param theta_t Total soil porosity.
#' @param temperature Soil temperature \[K\].
#' @param D_fw Diffusivity of N₂O in water.
#' @param D_fa Diffusivity of N₂O in air.
#' @param H Dimensionless Henry's constant \[-\].
#' @param rho Gas density of N₂O.
#' @param N2Oatm Atmospheric N₂O concentration \[ppmv\].
#' @param SPatm Atmospheric SP concentration.
#' @param d18Oatm Atmospheric d18O concentration.
#' @param R Gas constant \[L⋅atm⋅K⁻¹⋅mol⁻¹\].
#' @param depths A numeric vector containing the measurement depths \[cm\].
#' @param eta_SP_diffusion End member for diffusion of site-preference \insertCite{well2008isotope}{PRE}.
#' @param eta_18O_diffusion End member for diffusion of `d18O` \insertCite{well2008isotope}{PRE}.
#' @param SP_nitrification Site-preference for nitrification \insertCite{decock2013potential}{PRE}.
#' @param d18O_nitrification `d18O` for nitrification \insertCite{lewicka2017quantifying}{PRE}.
#' @param SP_denitrification Site-preference for denitrification \insertCite{decock2013potential}{PRE}.
#' @param d18O_denitrification `d18O` for denitrification \insertCite{lewicka2017quantifying}{PRE}.
#' @param eta_SP_reduction End member for SP reduction \insertCite{denk2017nitrogen}{PRE}.
#' @param eta_18O_reduction End member for `d18O` reduction \insertCite{lewicka2017quantifying}{PRE}.
#' 
#' @returns A list of the PRE data preparation parameters as well as the isotope end members analogous to the function arguments.
#' 
#' @importFrom Rdpack reprompt
#' 
#' @references
#' \insertAllCited{}
#' 
#' @export
getParameters <- function(BD = 1.686,
                          PD = 2.65,
                          theta_t = 1 - BD/PD,
                          temperature = 298,
                          rho = 1.26e6,
                          R = 0.082,
                          N2Oatm = 0.2496,
                          SPatm = 15.1,
                          d18Oatm = 49.6,
                          D_fw = 5.07e-6 * exp(-2371/temperature),
                          D_fa = 0.1436e-4 * (temperature/273.15)^1.81,
                          H = (8.5470e6 * exp(-2284/temperature)) / (8.3145*temperature),
                          depths = c(7.5, 30, 60, 90, 120),
                          SP_nitrification = 34.4,
                          SP_denitrification = -2.4,
                          eta_SP_diffusion = 1.55,
                          eta_SP_reduction = -5.3,
                          d18O_nitrification = 36.5,
                          d18O_denitrification = 11.1,
                          eta_18O_diffusion = -7.79,
                          eta_18O_reduction = -16.1) {
   list(BD = BD,
        theta_t = theta_t,
        temperature = temperature,
        D_fw = D_fw, 
        D_fa = D_fa,
        H = H,
        rho = rho,
        N2Oatm = N2Oatm,
        SPatm = SPatm,
        d18Oatm = d18Oatm,
        R = R,
        depths = depths,
        SP_nitrification = SP_nitrification,
        SP_denitrification = SP_denitrification,
        eta_SP_diffusion = eta_SP_diffusion,
        eta_SP_reduction = eta_SP_reduction,
        d18O_nitrification = d18O_nitrification,
        d18O_denitrification = d18O_denitrification,
        eta_18O_diffusion = eta_18O_diffusion,
        eta_18O_reduction = eta_18O_reduction)
}
