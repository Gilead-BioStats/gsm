#' Safety Assessment - Calculate prediction bounds
#'
#' @param dfOutput data frame in format produced by \code{\link{AE_Map_Adam}} or \code{\link{AE_Map_Raw}}.
#'
#' @return dataframe with prediction boundary curves
#'
#' @import lamW
#'
#' @export
AE_Poisson_PredictBounds <- function( dfOutput ){

  cModel <- glm(
    TotalCount ~ stats::offset(LogExposure),
    family=poisson(link="log"),
    data=dfOutput
  )

  vNewX <- seq(
    min(dfOutput$LogExposure)-0.05,
    max(dfOutput$LogExposure)+0.05,
    by=0.05
  )

  vMu <- as.numeric( exp( vNewX * cModel$coefficients[2] + cModel$coefficients[1] ) )
  vWHi <- ( dfOutput$ThresholdHigh[1] ^2 - 2 * vMu ) / ( 2 * exp(1) * vMu )
  vWLo <- ( dfOutput$ThresholdLow[1] ^2 - 2 * vMu ) / ( 2 * exp(1) * vMu )

  vPredictYHi <- ( dfOutput$ThresholdHigh[1]^2-2* vMu) / (2*lambertW0( vWHi ))
  vPredictYLo <- ( dfOutput$ThresholdLow[1]^2-2* vMu) / (2*lambertWm1( vWLo ))
  vPredictY <- exp( vNewX * cModel$coefficients[2] + cModel$coefficients[1])
  vPredictYLo[ is.nan( vPredictYLo ) ] <- 0
  vPredictYHi[ is.nan( vPredictYHi ) ] <- 0

  dfBounds <- data.frame(
    LogExposure = vNewX,
    MeanCount = vPredictY,
    LowerCount = vPredictYLo,
    UpperCount = vPredictYHi)

  return( dfBounds )
}
