#' Poisson Analysis - Predicted Boundaries
#'
#' @details
#' Apply funnel plot analysis to site level data and then calculates predicted count values and upper- and
#' lower- bounds (funnels) for across the full range of exposure values.
#'
#' @section Statistical Methods:
#' This function applies funnel plots analysis to site-level data and then calculates predicted count values
#' and upper- and lower- bounds (funnels) for across the full range of exposure values.
#'
#' @section Data Specification:
#' The input data (`dfTransformed`) for Analyze_Poisson is typically created using
#' \code{\link{Transform_Rate}} and should be one record per site with columns for:
#' - `GroupID` - Unique subject ID
#' - `Numerator` - Number of Events
#' - `Denominator` - Number of days of exposure
#'
#' @param dfTransformed `data.frame` data.frame in format produced by
#' \code{\link{Transform_Rate}}. Must include GroupID, N, Numerator and Denominator
#' @param vThreshold `numeric` upper and lower boundaries in residual space. Should be identical to
#' the thresholds used AE_Assess().
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` containing predicted boundary values with upper and lower bounds across the
#' range of observed values.
#'
#' @examples
#' dfInput <- AE_Map_Raw()
#'
#' dfTransformed <- Transform_Rate(dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' dfBounds <- Analyze_Rate_PredictBounds(dfTransformed, c(-5, 5))
#'
#' @import dplyr
#' @importFrom tidyr expand_grid
#'
#' @export

Analyze_Rate_PredictBounds <- function(dfTransformed, vThreshold = c(-3, -2, 2, 3), bQuiet = TRUE) {
  if (is.null(vThreshold)) {
    vThreshold <- c(-3, -2, 2, 3)
    cli::cli_alert("vThreshold was not provided. Setting default threshold to c(-3, -2, 2, 3)")
  }

  # add a 0 threhsold to calcultate estimate without an offset
  vThreshold <- unique(c(vThreshold, 0))

  # Calculate log of total exposure at each site.
  dfTransformed$LogDenominator <- log(
    dfTransformed$Denominator
  )

  # Calculate expected event count and predicted bounds across range of total exposure.
  vRange <- seq(
    min(dfTransformed$LogDenominator) - 0.05,
    max(dfTransformed$LogDenominator) + 0.05,
    by = 0.05
  )

  dfBounds <- tidyr::expand_grid(Threshold = vThreshold, LogDenominator = vRange) %>%
    mutate(
      Denominator = exp(.data$LogDenominator),
      # Calculate expected rate at given exposure.
      vMu = sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator),
      phi = mean(((dfTransformed$Metric - sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator)) /
        sqrt(sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator) / dfTransformed$Denominator))^2),
      # Calculate lower and upper bounds of expected event count given specified threshold.
      Numerator = (.data$vMu + .data$Threshold * sqrt(.data$phi * .data$vMu / .data$Denominator)) * .data$Denominator
    ) %>%
    # Only positive counts are meaningful bounds
    filter(.data$Numerator >= 0) %>%
    select(
      "Threshold",
      "LogDenominator",
      "Denominator",
      "Numerator"
    )

  return(dfBounds)
}
