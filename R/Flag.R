#' Flag
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Add columns flagging sites that represent possible statistical outliers when the Identity statistical
#' method is used.
#'
#' @details
#' This function provides a generalized framework for flagging sites as part of the
#' GSM data model (see `vignette("DataModel")`).
#'
#' @section Data Specification:
#' \code{Flag} is designed to support the input data (`dfAnalyzed`) from the `Analyze_Identity()`
#' function. At a minimum, the input data must have a `strGroupCol` parameter and a numeric
#' `strColumn` parameter defined. `strColumn` will be compared to the specified thresholds in
#' `vThreshold` to define a new `Flag` column, which identifies possible statistical outliers. If a
#' user would like to see the directionality of those identified points, they can define the
#' `strValueColumn` parameter, which will assign a positive or negative indication to already
#' flagged points.
#'
#' The following columns are considered required:
#' - `GroupID` - Group ID; default is `SiteID`
#' - `GroupLevel` - Group Type
#' - `strColumn` - A column to use for thresholding
#'
#' The following column is considered optional:
#' - `strValueColumn` - A column to be used for the sign/directionality of the flagging
#'
#' @param dfAnalyzed `data.frame` where flags should be added.
#' @param strColumn `character` Name of the column to use for thresholding. Default: `"Score"`
#' @param vThreshold `numeric` Vector of 2 numeric values representing lower and upper threshold values. All
#' values in `strColumn` are compared to `vThreshold` using strict comparisons. Values less than
#' the lower threshold or greater than the upper threshold are flagged. Values equal to the
#' threshold values are set to 0 (i.e., not flagged). If NA is provided for either threshold value,
#' it is ignored and no values are flagged based on the threshold. NA and NaN values in `strColumn`
#' are given NA flag values.
#' @param strValueColumn `character` Name of the column to use for sign of `Flag.` If the value for
#' that row is higher than the median of `strValueColumn`, then `Flag` is set to 1. Similarly, if
#' the value for that row is lower than the median of `strValueColumn`, then Flag is set to -1.
#'
#' @return `data.frame` with one row per site with columns: `GroupID`, `TotalCount`, `Metric`, `Score`, `Flag`
#'
#' @examples
#' dfTransformed <- Transform_Count(analyticsInput, strCountCol = "Numerator")
#'
#' dfAnalyzed <- Analyze_Identity(dfTransformed)
#'
#' dfFlagged <- Flag(dfAnalyzed, vThreshold = c(0.001, 0.01))
#'
#' @export

Flag <- function(
  dfAnalyzed,
  strColumn = "Score",
  vThreshold = NULL,
  strValueColumn = NULL
) {
  stop_if(cnd = !is.data.frame(dfAnalyzed), message = "dfAnalyzed is not a data frame")
  stop_if(cnd = !is.character(strColumn), message = "strColumn is not character")
  stop_if(cnd = !is.numeric(vThreshold), message = "vThreshold is not numeric")
  stop_if(cnd = length(vThreshold) != 2, message = "vThreshold must be length of 2")
  stop_if(cnd = is.null(vThreshold), message = "vThreshold cannot be NULL")
  stop_if(cnd = length(strColumn) != 1, message = "strColumn must be length of 1")
  stop_if(cnd = !(strColumn %in% names(dfAnalyzed)), message = "strColumn not found in dfAnalyzed")
  stop_if(cnd = !("GroupID" %in% names(dfAnalyzed)), message = "GroupID not found in dfAnalyzed")

  if (all(!is.na(vThreshold))) {
    stop_if(cnd = vThreshold[2] <= vThreshold[1], "vThreshold must contain a minimum and maximum value (i.e., vThreshold = c(1, 2))")
  }

  # Flag values outside the specified threshold.
  dfFlagged <- dfAnalyzed %>%
    mutate(
      Flag = case_when(
        !is.na(vThreshold[1]) & (.data[[strColumn]] < vThreshold[1]) ~ -1,
        !is.na(vThreshold[2]) & (.data[[strColumn]] > vThreshold[2]) ~ 1,
        !is.na(.data[[strColumn]]) & !is.nan(.data[[strColumn]]) ~ 0
      )
    )

  # If strValueColumn is supplied, it can only affect sign of Flag (1 or -1).
  if (!is.null(strValueColumn)) {
    stop_if(cnd = !(strValueColumn %in% names(dfAnalyzed)), message = "strValueColumn not found in dfAnalyzed")

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
