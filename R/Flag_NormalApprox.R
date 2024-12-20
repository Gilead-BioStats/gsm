#' Flag_NormalApprox
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Add columns flagging sites that represent possible statistical outliers.
#'
#' @details
#' This function flags sites based on the funnel plot with normal approximation analysis result as part of
#' the GSM data model (see `vignette("DataModel")`).
#'
#' @section Data Specification:
#' \code{Flag_NormalApprox} is designed to support the input data (`dfAnalyzed`) from \code{Analyze_NormalApprox} function.
#' At a minimum, the input data must have a `GroupID` column and a column of numeric values (identified
#' by the `strColumn` parameter) that will be compared to the specified thresholds (`vThreshold`) to
#' calculate a new `Flag` column.
#' In short, the following columns are considered:
#' - `GroupID` - Group ID (required)
#' - `GroupLevel` - Group Type
#' - `strColumn` - A column to use for Thresholding (required)
#' - `strValueColumn` - A column to be used for the sign of the flag (optional)
#'
#' @param dfAnalyzed `data.frame` where flags should be added.
#' @param vThreshold `vector` of 4 numeric values representing lower and upper threshold values. All
#' values in `strColumn` are compared to `vThreshold` using strict comparisons. Values less than the lower threshold or greater than the upper threshold are flagged as -1 and 1 respectively. Values equal to the threshold values are set to 0 (i.e. not flagged). If NA is provided for either threshold value it is ignored, and no values are flagged based on the threshold. NA and NaN values in `strColumn` are given NA flag values.
#'
#' @return `data.frame` with "Flag" column added
#'
#' @examples
#' dfTransformed <- Transform_Rate(analyticsInput)
#'
#' # Binary
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "binary")
#' dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-3, -2, 2, 3))
#'
#' # Rate
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
#' dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-3, -2, 2, 3))
#'
#' @export

Flag_NormalApprox <- function(
  dfAnalyzed,
  vThreshold = NULL
) {
  stop_if(cnd = !is.data.frame(dfAnalyzed), message = "dfAnalyzed is not a data frame")
  stop_if(cnd = !is.numeric(vThreshold), message = "vThreshold is not numeric")
  stop_if(cnd = !(length(vThreshold) == 4), message = "vThreshold must be length of 4")
  stop_if(cnd = is.null(vThreshold), message = "vThreshold cannot be NULL")


  if (all(!is.na(vThreshold))) {
    stop_if(
      cnd = vThreshold[2] <= vThreshold[1],
      message = "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-3, -2, 2, 3))"
    )
    stop_if(
      cnd = vThreshold[3] <= vThreshold[2],
      message = "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-3, -2, 2, 3))"
    )
    stop_if(
      cnd = vThreshold[4] <= vThreshold[3],
      message = "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-3, -2, 2, 3))"
    )
  }


  # Flag values outside the specified threshold.
  dfFlagged <- dfAnalyzed %>%
    mutate(
      Flag = case_when(
        (.data$Score < vThreshold[1]) ~ -2,
        (.data$Score < vThreshold[2]) ~ -1,
        (.data$Score < vThreshold[3]) ~ 0,
        (.data$Score < vThreshold[4]) ~ 1,
        (.data$Score >= vThreshold[4]) ~ 2
      )
    )

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))


  return(dfFlagged)
}
