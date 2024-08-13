#' Flag_Poisson
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Add columns flagging sites that represent possible statistical outliers when the Poisson statistical method is used.
#'
#' @details
#' This function flags sites based on the Poisson analysis result as part of `vignette("DataModel")`.
#'
#' @section Data Specification:
#' \code{Flag_Poisson} is designed to support the input data (`dfAnalyzed`) generated from the \code{Analyze_Poisson} function. At a minimum, the input must define a `dfAnalyzed` data frame with a `Score` variable included and a `vThreshold`. These inputs will be used to identify possible statistical outliers in a new `Flag` column by comparing `Score` values to the specified thresholds.
#'
#' The following columns are considered required:
#' - `GroupID` - Group ID; default is `SiteID`
#' - `GroupLevel` - Group Type
#' - `Score` - Site residuals calculated from the rates of exposure provided to `Analyze_Poisson()`
#'
#' @param dfAnalyzed data.frame where flags should be added.
#' @param vThreshold Vector of 4 numeric values representing lower and upper threshold values. All values in the `Score` column are compared to `vThreshold` using strict comparisons. Values less than the lower thresholds or greater than the upper thresholds are flagged. Values equal to the threshold values are set to 0 (i.e., not flagged). If NA is provided for either threshold value, it is ignored and no values are flagged based on the thresholds. NA and NaN values in `Score` are given NA flag values.
#'
#' @return `data.frame` with one row per site with columns: `GroupID`, `Numerator`, `Denominator`, `Metric`, `Score`, `PredictedCount`, `Flag`
#'
#' @examples
#' dfTransformed <- Transform_Rate(analyticsInput)
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' dfFlagged <- Flag_Poisson(dfAnalyzed, vThreshold = c(-7, -5, 5, 7))
#'
#' @export

Flag_Poisson <- function(
  dfAnalyzed,
  vThreshold = NULL
) {
  stopifnot(
    "dfAnalyzed is not a data frame" = is.data.frame(dfAnalyzed),
    "vThreshold is not numeric" = is.numeric(vThreshold),
    "vThreshold must be length of 4" = length(vThreshold) == 4,
    "vThreshold cannot be NULL" = !is.null(vThreshold)
  )


  if (all(!is.na(vThreshold))) {
    stopifnot(
      "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-7, -5, 5, 7))" =
        vThreshold[1] < vThreshold[2],
      "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-7, -5, 5, 7))" =
        vThreshold[2] < vThreshold[3],
      "vThreshold must contain cutoff for moderate/high risks in two directions (i.e., vThreshold = c(-7, -5, 5, 7))" =
        vThreshold[3] < vThreshold[4]
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
