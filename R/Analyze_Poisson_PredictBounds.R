#' Safety Assessment - Calculate prediction bounds
#'
#' @param dfTransformed data frame in format produced by \code{\link{AE_Map_Adam}} or \code{\link{AE_Map_Raw}}.
#'
#' @return dataframe with prediction boundary curves
#'
#' @import lamW 
#'
#' @export

Analyze_Poisson_PredictBounds <- function( dfTransformed, vThreshold ){
  dfTransformed$LogExposure <- log(dfTransformed$TotalExposure)
  cModel <- glm(
    TotalCount ~ stats::offset(LogExposure),
    family=poisson(link="log"),
    data=dfTransformed
  )

  dfBounds <- data.frame(
    LogExposure = seq(
    min(dfFlagged$LogExposure)-0.05,
    max(dfFlagged$LogExposure)+0.05,
    by=0.05
  )) %>% 
  mutate( vMu = as.numeric( exp( LogExposure * cModel$coefficients[2] + cModel$coefficients[1] ))) %>%
  mutate( vWHi = (vThreshold[2]^2 - 2 * vMu)  / ( 2 * exp(1) * vMu )) %>%
  mutate( vWLo = (vThreshold[1]^2 - 2 * vMu)  / ( 2 * exp(1) * vMu )) %>%
  mutate( PredictYHigh = ( vThreshold[2]^2-2* vMu) / (2*lamW::lambertW0( vWHi ))) %>%
  mutate( PredictYLo = ( vThreshold[1]^2-2* vMu) / (2*lamW::lambertWm1( vWLo ))) %>%
  mutate( MeanCount = exp( LogExposure * cModel$coefficients[2] + cModel$coefficients[1])) %>%
  mutate( LowerCount = if_else(is.nan( PredictYLo ), 0, PredictYLo )) %>%
  mutate( UpperCount = if_else(is.nan( PredictYHigh ), 0, PredictYHigh )) %>%
  select( LogExposure, MeanCount, LowerCount, UpperCount )


  return( dfBounds )
}
