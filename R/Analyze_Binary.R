#' Funnel Plot Analysis with Normal Approximation for Binary Outcomes
#'
#' @details
#' Creates analysis results data for percentage data using funnel plot method with normal approximation.
#'
#'
#' @section Statistical Methods:
#' This function applies funnel plots using asymptotic limits based on normal approximation of binomial distribution for
#' the binary outcome with the sample sizes of the sites to assess data quality and safety.
#'
#' @section Data Specification:
#' The input data (`dfTransformed`) for Analyze_Binary is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Total number of participants at site with event of interest
#' - `Denominator` - Total number of participants at site
#' - `Metric` - Proportion of participants at site with event of interest
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Numerator_Other, Denominator, Denominator_Other, Prop, Prop_Other, Metric, Estimate, Score.
#'
#' @examples
#' dfInput <- Disp_Map_Raw()
#'
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Total"
#' )
#'
#' dfAnalyzed <- Analyze_Binary(dfTransformed)
#'
#' @import dplyr
#'
#' @export

Analyze_Binary <- function(
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
        sqrt((sum(.data$Numerator) / sum(.data$Denominator)) * (1 - sum(.data$Numerator) / sum(.data$Denominator)) / .data$Denominator),
      phi = mean(.data$z_0^2),
      z_i = (.data$Metric -  sum(.data$Numerator) / sum(.data$Denominator)) /
        sqrt(.data$phi *  sum(.data$Numerator) / sum(.data$Denominator) * (1 -  sum(.data$Numerator) / sum(.data$Denominator)) / .data$Denominator)
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
    cli::cli_text("{.var Score} column created from normal approxiamtion of the binomial distribution")
  }

  return(dfAnalyzed)
}
