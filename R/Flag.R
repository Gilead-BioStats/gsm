#' Make data frame with flagged values
#' 
#' Adds columns flagging sites that represent possible statistical outliers. Rows with PValue less than 0.05 are flagged by default.  
#'
#' @param dfAnalyzed data frame in format produced by \code{\link{AE_Poisson_Analyze}}
#' @param strColumn Name of the Column to use for thresholding
#' @param vThreshold vector of 2 numeric values representing lower and upper threshold values. If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. 
#' @param strValueColumn Optional, Name of the Column to use for sign of Flag. If value for that row is higher than median of strValueColumn then Flag = 1, if lower then Flag = -1.
#'
#' @return input data frame with the columns added for "ThresholdLow","ThresholdHigh","ThresholdCol" and "Flag" 
#' 
#' @export

Flag <- function( dfAnalyzed , strColumn="PValue", vThreshold=c(0.05,NA),strFlagValueColumn = NULL){
  stopifnot(
      is.data.frame(dfAnalyzed), 
      is.character(strColumn),
      is.numeric(vThreshold),
      .data$strColumn %in% names(dfAnalyzed)
  )

  if(all(!is.na(vThreshold))){
    stopifnot(vThreshold[2]>vThreshold[1])
  }

  dfFlagged<-dfAnalyzed %>%
    mutate(ThresholdLow = vThreshold[1]) %>%
    mutate(ThresholdHigh= vThreshold[2]) %>%
    mutate(ThresholdCol = strColumn) %>% 
    mutate(Flag = case_when(
      !is.na(vThreshold[1]) & (.data[[strColumn]] < vThreshold[1]) ~ -1,
      !is.na(vThreshold[2]) & (.data[[strColumn]] > vThreshold[2]) ~ 1,
      TRUE ~ 0
    )) 

  # if strFlagValueColumn is supplied, it can only affect sign of Flag (1 or -1)
  if(!is.null(strFlagValueColumn)){
    nMedian <-  dfFlagged %>% pull(strFlagValueColumn) %>% median(na.rm=TRUE)
    dfFlagged <- dfFlagged  %>%  
      mutate(Flag = case_when(
        Flag != 0 & .data[[strFlagValueColumn]] >= nMedian ~ 1,
        Flag != 0 & .data[[strFlagValueColumn]] < nMedian ~ -1,
        TRUE ~ Flag
      ))
  }
  return( dfFlagged )
}