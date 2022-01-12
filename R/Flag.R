#' Make data frame with flagged values
#' 
#' Adds columns flagging sites that represent possible statistical outliers. Rows with PValue less than 0.05 are flagged by default.  
#'
#' @param dfAnalyzed data frame in format produced by \code{\link{AE_Poisson_Analyze}}
#' @param strColumn Name of the Column to use for thresholding
#' @param vThreshold vector of 2 numeric values representing lower and upper threshold values. If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. 
#'
#' @return input data frame with the columns added for "ThresholdLow","ThresholdHigh","ThresholdCol" and "Flag" 
#' 
#' @export

Flag <- function( dfAnalyzed , strColumn="PValue", vThreshold=c(0.05,NA)){
    stopifnot(
        is.data.frame(dfAnalyzed), 
        is.character(strColumn),
        is.numeric(dThreshold),
        strColumn %in% names(dfAnalyzed)
    )

    if(!all(is.na(vThreshold))){
        stopifnot(vThreshold[2]>vThreshold[1])
    }

    dfFlagged<-dfAnalyzed %>%
        mutate(ThresholdLow = vThreshold[1]) %>%
        mutate(ThresholdHigh= vThreshold[2]) %>%
        mutate(ThresholdCol = strColumn) %>%

    dfFlagged$Flag <- rep(0, nrow(dfFlagged))
    if(!is.na(vThreshold[1])) dfFlagged$Flag[dfFlagged[strColumn] < vThreshold[1]] <- -1 
    if(!is.na(vThreshold[2])) dfFlagged$Flag[dfFlagged[strColumn] > vThreshold[2]] <- 1 

    return( dfFlagged )
}