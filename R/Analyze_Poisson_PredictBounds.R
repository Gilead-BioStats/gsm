#' Safety Assessment - Calculate prediction bounds
#'
#' @param dfTransformed  data.frame in format produced by \code{\link{Transform_EventCount}}.
#' @param vThreshold Residual thresholds used to calculating upper and lower bounds.

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
    min(dfTransformed$LogExposure)-0.05,
    max(dfTransformed$LogExposure)+0.05,
    by=0.05
  )) %>% 
  mutate( vMu = as.numeric( exp( .data$LogExposure * cModel$coefficients[2] + cModel$coefficients[1] ))) %>%
  mutate( vWHi = (vThreshold[2]^2 - 2 * .data$vMu)  / ( 2 * exp(1) * .data$vMu )) %>%
  mutate( vWLo = (vThreshold[1]^2 - 2 * .data$vMu)  / ( 2 * exp(1) * .data$vMu )) %>%
  mutate( PredictYHigh = ( vThreshold[2]^2-2* .data$vMu) / (2*lamW::lambertW0( .data$vWHi ))) %>%
  mutate( PredictYLo = ( vThreshold[1]^2-2* .data$vMu) / (2*lamW::lambertWm1( .data$vWLo ))) %>%
  mutate( MeanCount = exp( .data$LogExposure * cModel$coefficients[2] + cModel$coefficients[1])) %>%
  mutate( LowerCount = if_else(is.nan( .data$PredictYLo ), 0, .data$PredictYLo )) %>%
  mutate( UpperCount = if_else(is.nan( .data$PredictYHigh ), 0, .data$PredictYHigh )) %>%
  select( .data$LogExposure, .data$MeanCount, .data$LowerCount, .data$UpperCount )


  return( dfBounds )
}
