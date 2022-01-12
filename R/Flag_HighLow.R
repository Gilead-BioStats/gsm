#' Safety Assessment - Make data frame with flagged values
#' 
#' Adds columns flagging sites that represent possible statistical outliers
#'
#' @param dfFlagged data frame in format produced by \code{\link{AE_Poisson_Analyze}}
#' @param dThresholdHi Higher threshold to be compared 
#' @param dThresholdLo Lower threshold to be compared 
#'
#' @return input data frame with the following columns added for "Threshold", "FlagOver" and "FlagUnder" 
#' 
#' @export

Flag_HighLow <- function( dfAnalyzed , dThresholdHi, dThresholdLo ){
    stopifnot(
        is.data.frame(dfAnalyzed), 
        is.numeric(dThresholdHi),
        is.numeric(dThresholdLo),
        all( c("SiteID", "N", "TotalCount", "TotalExposure", "Rate", "Unit","LogExposure","Residuals","PredictedCount","PValue") %in% names(dfAnalyzed))    
    )
    dfFlagged<-dfAnalyzed
    dfFlagged$ThresholdHi <- dThresholdHi
    dfFlagged$ThresholdLo <- dThresholdLo

    dfFlagged$Flag <- rep(0, nrow(dfFlagged))
    dfFlagged$Flag[ dfFlagged$Residuals > dThresholdHi ] <- 1 
    dfFlagged$Flag[ dfFlagged$Residuals < dThresholdLo ] <- -1 

    return( dfFlagged )
}