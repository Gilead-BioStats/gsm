#' Poisson Analysis - Predicted Boundaries
#'
#' @details
#'
#' Fits a Poisson model to site level data and then calculates predicted count values and upper- and lower- bounds for across the full range of exposure values.
#'
#' @section Statistical Methods:
#'
#' This function fits a poisson model to site-level data and then calculates residuals for each site. The poisson model is run using standard methods in the `stats` package by fitting a `glm` model with family set to `poisson` using a "log" link. Upper and lower boundary values are then calculated using the method described here TODO: Add link. In short,
#'
#' @section Data Specification:
#'
#' The input data (` dfTransformed`) for the Analyze_Poisson is typically created using \code{\link{Transform_EventCount}} and should be one record per Site with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `TotalCount` - Number of Events
#' - `TotalExposure` - Number of days of exposure
#'
#' @param dfTransformed data.frame in format produced by \code{\link{Transform_EventCount}}. Must include SubjectID, SiteID, TotalCount and TotalExposure.
#' @param vThreshold upper and lower boundaries in residual space. Should be identical to the thresholds used AE_Assess().
#'
#' @return data frame containing predicted boundary values with upper and lower bounds across the range of observed values
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' dfTransformed <- Transform_EventCount( dfInput, strCountCol = 'Count', strExposureCol = "Exposure" )
#' dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed, c(-5,5))
#'
#' @export
Analyze_Poisson_PredictBounds <- function( dfTransformed, vThreshold=c(-5,5)){
  dfTransformed$LogExposure <- log(dfTransformed$TotalExposure)
  cModel <- stats::glm(
    TotalCount ~ stats::offset(LogExposure),
    family = stats::poisson(link="log"),
    data = dfTransformed
  )

  dfBounds <- data.frame(
    LogExposure = seq(
    min(dfTransformed$LogExposure)-0.05,
    max(dfTransformed$LogExposure)+0.05,
    by=0.05
  )) %>%
  dplyr::mutate( vMu = as.numeric( exp( .data$LogExposure * cModel$coefficients[2] + cModel$coefficients[1] ))) %>%
  dplyr::mutate( vWHi = (vThreshold[2]^2 - 2 * .data$vMu)  / ( 2 * exp(1) * .data$vMu )) %>%
  dplyr::mutate( vWLo = (vThreshold[1]^2 - 2 * .data$vMu)  / ( 2 * exp(1) * .data$vMu )) %>%
  dplyr::mutate( PredictYHigh = ( vThreshold[2]^2-2* .data$vMu) / (2*lamW::lambertW0( .data$vWHi ))) %>%
  dplyr::mutate( PredictYLo = ( vThreshold[1]^2-2* .data$vMu) / (2*lamW::lambertWm1( .data$vWLo ))) %>%
  dplyr::mutate( MeanCount = exp( .data$LogExposure * cModel$coefficients[2] + cModel$coefficients[1])) %>%
  dplyr::mutate( LowerCount = dplyr::if_else(is.nan( .data$PredictYLo ), 0, .data$PredictYLo )) %>%
  dplyr::mutate( UpperCount = dplyr::if_else(is.nan( .data$PredictYHigh ), 0, .data$PredictYHigh )) %>%
  select( .data$LogExposure, .data$MeanCount, .data$LowerCount, .data$UpperCount )


  return( dfBounds )
}
