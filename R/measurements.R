#' @title Soil N₂O flux measurements
#' 
#' @description This data was measured in Zürich for the Process Rate Estimator.
#' 
#' @usage 
#' data(measurements, package = "PRE")
#' 
#' @format ## `measurements`
#' A data frame with 9640 rows and  9 columns:
#' \describe{
#'   \item{`date`}{Date of the measurement \[`YYYY-MM-DD`\].}
#'   \item{`column`}{Experimental unit. There are twelve columns in total each with one distinct wheat variety.}
#'   \item{`depth`}{Measurement depth \[cm\]. Either 7.5, 30, 60, 90, or 120 cm.}
#'   \item{`increment`}{Height of one conceptual soil layer (borders between the different depth layers).}
#'   \item{`variety`}{The wheat variety as a factor. Either `"CH Claro"`, `"Monte Calme 268"`, `"Probus"`, or `"Zinal"`.}
#'   \item{`moisture`}{The average moisture over a day.}
#'   \item{`N2O`}{The corrected N₂O concentration.}
#'   \item{`SP`}{Site preference (SP), defined as the difference in isotope value between the central and terminal N atom in the N₂O molecule.}
#'   \item{`d18O`}{\eqn{\delta^{18}\text O}, a measure of the deviation in ratio of stable isotopes oxygen-18 (\eqn{^{18}\text O}) and oxygen-16 (\eqn{^{16}\text O}). It is commonly used as an indicator of processes that show isotopic fractionation.}
#'   ...
#' }
"measurements"