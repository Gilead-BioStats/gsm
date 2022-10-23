#' Funnel Plot Analysis with Normal Approximation for Rate Outcomes
#'
#' @details
#' Creates analysis results data for rate data using funnel plot method with normal approximation.
#'
#'
#' @section Statistical Methods:
#' This function applies funnel plots using asymptotic limits based on normal approximation of Poisson distribution
#' the rate outcome verses the total exposure of the sites under investigation to assess data quality and safety.
#'
#' @section Data Specification:
#' The input data (`dfTransformed`) for Analyze_Rate is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Total number of events of interest at site
#' - `Denominator` - Total number of days of exposure at site
#' - `Metric` - Rate of events at site (Numerator / Denominator)
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Numerator_Other, Denominator, Denominator_Other, Prop, Prop_Other, Metric, Estimate, Score.
#'
#' @examples
#' dfInput <- AE_Map_Raw() %>% na.omit()
#'
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' dfAnalyzed <- Analyze_Rate(dfTransformed)
#'
#' @import dplyr
#'
#' @export

Analyze_Rate <- function(
  dfTransformed,
  bQuiet = TRUE
) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns not found: GroupID, Denominator, Numerator, Metric" =
      all(c("GroupID", "Denominator", "Numerator", "Metric") %in% names(dfTransformed)),
    "NA value(s) found in GroupID" = all(!is.na(dfTransformed[["GroupID"]]))
  )

  dfAnalyzed <- dfTransformed %>%
    mutate(
      z_0 = (.data$Metric -  sum(.data$Numerator) / sum(.data$Denominator)) /
        sqrt( sum(.data$Numerator) / sum(.data$Denominator) / .data$Denominator),
      phi = mean(.data$z_0^2),
      z_i = (.data$Metric -  sum(.data$Numerator) / sum(.data$Denominator)) /
        sqrt(.data$phi *  sum(.data$Numerator) / sum(.data$Denominator) / .data$Denominator)
    ) %>%
    select(
      "GroupID",
      "Numerator",
      "Denominator",
      "Metric",
      Score = "z_i"
    ) %>%
    arrange(.data$Score)

  if (!bQuiet) {
    cli::cli_text("{.var Score} column created from normal approxiamtion of the Poisson distribution")
  }

  return(dfAnalyzed)
}
