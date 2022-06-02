#' Make data frame with flagged values
#'
#' Adds columns flagging sites that represent possible statistical outliers. Rows with PValue less
#' than 0.05 are flagged by default.
#'
#' @details
#' This function provides a generalized framework for flagging sites as part of the GSM data
#' pipeline (TODO add link to data vignette).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (` dfAnalyzed`) input data from many different
#' \code{Analyze} functions. At a minimum, the input data must have a `SiteID` column and a column
#' of numeric values (identified by the `strColumn` parameter) that will be compared to the
#' specified thresholds (`vThreshold`) to calculate a new `Flag` column. Optionally, a second column
#' of numeric values (identified by `strValueColumn`) can be specified to set the directionality of
#' the `Flag`.
#'
#' In short, the following columns are considered:
#' - `SiteID` - Site ID (required)
#' - `strColumn` - A column to use for Thresholding (required)
#' - 'strValueColumn' - A column to be used for the sign of the flag (optional)
#'
#' @param dfAnalyzed data.frame where flags should be added.
#' @param strColumn Name of the column to use for thresholding.
#' @param vThreshold Vector of 2 numeric values representing lower and upper threshold values. All
#' values in strColumn are compared to vThreshold using strict comparisons. Values less than the lower threshold or greater than the upper threshold are flagged as -1 and 1 respectively. Values equal to the threshold values are set to 0 (i.e. not flagged). If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. NA and NaN values in strColumn are given NA flag values.
#' @param strValueColumn Optional, Name of the Column to use for sign of Flag. If value for that row
#' is higher than median of strValueColumn then Flag = 1, if lower then Flag = -1.
#'
#' @return input data frame with the columns added for "ThresholdLow","ThresholdHigh","ThresholdCol"
#' and "Flag"
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure")
#' dfAnalyzed <- Analyze_Wilcoxon(dfTransformed, "Rate")
#' dfFlagged <- Flag(dfAnalyzed) # PValue < 0.05 flagged
#' dfFlagged10 <- Flag(dfAnalyzed, vThreshold = c(0.10, NA)) # PValue <0.10 flagged
#' # Flag direction set based on 'Statistic' column
#' dfFlagged <- Flag(dfAnalyzed, strColumn = "PValue", strValueColumn = "Estimate")
#'
#' @import dplyr
#' @importFrom stats median
#'
#' @export

Flag <- function(
  dfAnalyzed,
  strColumn = "PValue",
  vThreshold = c(0.05, NA),
  strValueColumn = NULL
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "strColumn is not character" = is.character(strColumn),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 2" = length(vThreshold) == 2,
    "strColumn must be length of 1" = length(strColumn) == 1,
    "strColumn not found in dfAnalyzed" = strColumn %in% names(dfAnalyzed),
    "strValueColumn not found in dfAnalyzed" = strValueColumn %in% names(dfAnalyzed),
    "SiteID not found in dfAnalyzed" = "SiteID" %in% names(dfAnalyzed)
  )

  if (all(!is.na(vThreshold))) {
    stopifnot(
      "vThreshold must contain a minimum and maximum value (i.e., vThreshold = c(1, 2))" = vThreshold[2] > vThreshold[1]
    )
  }

  # Flag values outside the specified threshold.
  dfFlagged <- dfAnalyzed %>%
    mutate(
      ThresholdLow = vThreshold[1],
      ThresholdHigh = vThreshold[2],
      ThresholdCol = strColumn,
      Flag = case_when(
        !is.na(vThreshold[1]) & (.data[[strColumn]] < vThreshold[1]) ~ -1,
        !is.na(vThreshold[2]) & (.data[[strColumn]] > vThreshold[2]) ~ 1,
        is.na(.data[[strColumn]]) ~ NA_real_,
        is.nan(.data[[strColumn]]) ~ NA_real_,
        TRUE ~ 0 # All other values set to 0 (not flagged)
      )
    )

  # If strValueColumn is supplied, it can only affect sign of Flag (1 or -1).
  if (!is.null(strValueColumn)) {
    nMedian <- dfFlagged %>%
      pull(strValueColumn) %>%
      stats::median(na.rm = TRUE)

    dfFlagged <- dfFlagged %>%
      mutate(
        Flag = case_when(
          Flag != 0 & .data[[strValueColumn]] >= nMedian ~ 1,
          Flag != 0 & .data[[strValueColumn]] < nMedian ~ -1,
          TRUE ~ Flag
        )
      )
  }

  dfFlagged <- dfFlagged %>% arrange(match(.data$Flag, c(1, -1, 0)))

  return(dfFlagged)
}
