#' Make data frame with flagged values
#' 
#' Adds columns flagging sites that represent possible statistical outliers. Rows with PValue less than 0.05 are flagged by default.  
#'
#' @param dfAnalyzed data frame where flags should be added
#' @param strColumn Name of the Column to use for thresholding
#' @param vThreshold vector of 2 numeric values representing lower and upper threshold values. All values in strColumn are compared to vThreshold using strict comparisons. Values less than the lower threshold or greater than the upper threshold are flagged as -1 and 1 respectively. Values equal to the threshold values are set to 0 (i.e. not flagged). If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. NA and NaN values in strColumn are given NA flag values. 
#' @param strValueColumn Optional, Name of the Column to use for sign of Flag. If value for that row is higher than median of strValueColumn then Flag = 1, if lower then Flag = -1.
#'
#' @return input data frame with the columns added for "ThresholdLow","ThresholdHigh","ThresholdCol" and "Flag" 
#' 
#' @examples 
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
#' dfAnalyzed <- Analyze_Wilcoxon( dfTransformed ) 
#' dfFlagged <- Flag( dfAnalyzed ,  strColumn = 'PValue', strValueColumn = 'Statistic')
#' 
#' @export

Flag <- function( dfAnalyzed , strColumn="PValue", vThreshold=c(0.05,NA),strValueColumn = NULL){
  stopifnot(
      is.data.frame(dfAnalyzed), 
      is.character(strColumn),
      is.numeric(vThreshold),
      length(vThreshold) == 2,
      strColumn %in% names(dfAnalyzed),
      strValueColumn %in% names(dfAnalyzed)
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
      is.na(.data[[strColumn]]) ~ NA_real_,
      is.nan(.data[[strColumn]]) ~ NA_real_,
      TRUE~0 # All other values set to 0 (not flagged)
    )) 

  # if strValueColumn is supplied, it can only affect sign of Flag (1 or -1)
  if(!is.null(strValueColumn)){
    nMedian <-  dfFlagged %>% pull(strValueColumn) %>% median(na.rm=TRUE)
    dfFlagged <- dfFlagged  %>%  
      mutate(Flag = case_when(
        Flag != 0 & .data[[strValueColumn]] >= nMedian ~ 1,
        Flag != 0 & .data[[strValueColumn]] < nMedian ~ -1,
        TRUE ~ Flag
      ))
  }
  return( dfFlagged )
}