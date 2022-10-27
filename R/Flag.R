#' Flag
#'
#' Add columns flagging sites that represent possible statistical outliers when Identity statistical method is used.
#'
#' @details
#' This function provides a generalized framework for flagging sites as part of the [GSM data pipeline](https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (`dfAnalyzed`) from the `Analyze_Identity()` function. At a minimum, the input data must have `GroupID` and a numeric `strColumn` parameter defined. `strColumn` will be compared to the specified thresholds in `vThreshold` to define a new `Flag` column, which identifies possible statistical outliers. If a user would like to see the directionality of those identified points, they can define the `strValueColumn` parameter, which will assign a positive or negative indication to already flagged points.
#'
#' The following columns are considered required:
#' - `GroupID` - Group ID; default is site ID
#' - `strColumn` - A column to use for thresholding
#'
#' The following column is considered optional:
#' - `strValueColumn` - A column to be used for the sign/directionality of the flagging
#'
#' @param dfAnalyzed A data.frame where flags should be added.
#' @param strColumn Name of the column to use for thresholding. Default: `"Score"`
#' @param vThreshold Vector of 2 numeric values representing lower and upper threshold values. All values in `strColumn` are compared to `vThreshold` using strict comparisons. Values less than the lower threshold or greater than the upper threshold are flagged. Values equal to the threshold values are set to 0 (i.e., not flagged). If NA is provided for either threshold value, it is ignored and no values are flagged based on the threshold. NA and NaN values in `strColumn` are given NA flag values.
#' @param strValueColumn Name of the column to use for sign of `Flag.` If the value for that row is higher than the median of `strValueColumn`, then `Flag` is set to 1. Similarly, if the value for that row is lower than the median of `strValueColumn`, then Flag is set to -1.
#'
#' @return `data.frame` with one row per site with columns: `GroupID`, `TotalCount`, `Metric`, `Score`, `Flag`
#'
#' @examples
#' dfInput <- Consent_Map_Raw()
#'
#' dfTransformed <- Transform_Count(dfInput,
#'   strGroupCol = "SiteID",
#'   strCountCol = "Count"
#' )
#'
#' dfAnalyzed <- Analyze_Identity(dfTransformed)
#'
#' dfFlagged <- Flag(dfAnalyzed, vThreshold = c(-5, 5))
#'
#' @import dplyr
#' @importFrom stats median
#'
#' @export

Flag <- function(
  dfAnalyzed,
  strColumn = "Score",
  vThreshold = NULL,
  strValueColumn = NULL
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "strColumn is not character" = is.character(strColumn),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 2" = length(vThreshold) == 2,
    "vThreshold cannot be NULL" = !is.null(vThreshold),
    "strColumn must be length of 1" = length(strColumn) == 1,
    "strColumn not found in dfAnalyzed" = strColumn %in% names(dfAnalyzed),
    "strValueColumn not found in dfAnalyzed" = strValueColumn %in% names(dfAnalyzed),
    "GroupID not found in dfAnalyzed" = "GroupID" %in% names(dfAnalyzed)
  )

  if (all(!is.na(vThreshold))) {
    stopifnot(
      "vThreshold must contain a minimum and maximum value (i.e., vThreshold = c(1, 2))" = vThreshold[2] > vThreshold[1]
    )
  }

  # Flag values outside the specified threshold.
  dfFlagged <- dfAnalyzed %>%
    mutate(
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

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(1, -1, 0)))

  return(dfFlagged)
}
