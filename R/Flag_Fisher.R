#' Flag_Fisher
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Add columns flagging sites that represent possible statistical outliers when the Fisher's Exact Test is used.
#'
#' @details
#' This function flags sites based on the Fisher's Exact Test result as part of the GSM data model (see `vignette("DataModel")`).
#'
#' @section Data Specification:
#' \code{Flag_Fisher} is designed to support the input data (`dfAnalyzed`) generated from the \code{Analyze_Fisher} function. At a minimum, the input must define a `dfAnalyzed` data frame with `Score`, `Prop`, and `Prop_Other` variables included and a `vThreshold`. These inputs will be used to identify possible statistical outliers in a new `Flag` column by comparing `Score`, `Prop`, and `Prop_Other` values to the specified thresholds.
#'
#' The following columns are considered required:
#' - `GroupID` - Group ID; default is `SiteID`
#' - `GroupLevel` - Group Type
#' - `Score` - P-value calculated from the rates of exposure provided to `Analyze_Fisher()`
#' - `Prop` - Proportion of events of interest over days of exposure
#' - `Prop_Other` - Cumulative proportion of events of interest over days of exposure
#'
#' @param dfAnalyzed data.frame where flags should be added.
#' @param vThreshold Vector of 2 numeric values representing lower and upper p-value thresholds.
#'
#' @return `data.frame` with one row per site with columns: `GroupID`, `Numerator`, `Denominator`, `Metric`, `Score`, `PredictedCount`, and `Flag`.
#'
#' @examples
#' dfTransformed <- Transform_Rate(analyticsInput)
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' dfFlagged <- Flag(dfAnalyzed, vThreshold = c(-5, 5))
#'
#' @export

Flag_Fisher <- function(
  dfAnalyzed,
  vThreshold = NULL
) {
  stop_if(cnd = !is.data.frame(dfAnalyzed), message = "dfAnalyzed is not a data frame")
  stop_if(cnd = !is.numeric(vThreshold), message = "vThreshold is not numeric")
  stop_if(cnd = length(vThreshold) != 2, message = "vThreshold must be length of 2")
  stop_if(cnd = is.null(vThreshold), message = "vThreshold cannot be NULL")
  stop_if(cnd = !("GroupID" %in% names(dfAnalyzed)), message = "GroupID not found in dfAnalyzed")

  if (all(!is.na(vThreshold))) {
    stop_if(cnd = vThreshold[2] <= vThreshold[1], "vThreshold must contain a minimum and maximum value (i.e., vThreshold = c(1, 2))")
  }

  dfFlagged <- dfAnalyzed %>%
    mutate(
      Flag = case_when(
        # score < lower threshold and metric < overall metric sans current group
        (.data$Score < vThreshold[1]) & (.data$Prop < .data$Prop_Other) ~ -2,
        # score < lower threshold and metric >= overall metric sans current group
        (.data$Score < vThreshold[1]) & (.data$Prop >= .data$Prop_Other) ~ 2,
        # score < upper threshold and metric < overall metric sans current group
        (.data$Score < vThreshold[2]) & (.data$Prop < .data$Prop_Other) ~ -1,
        # score < upper threshold and metric >= overall metric sans current group
        (.data$Score < vThreshold[2]) & (.data$Prop >= .data$Prop_Other) ~ 1,
        !is.na(.data$Score) & !is.nan(.data$Score) ~ 0
      )
    )

  dfFlagged <- dfFlagged %>%
    arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))

  return(dfFlagged)
}
