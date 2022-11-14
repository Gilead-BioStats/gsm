#' Funnel Plot Analysis with Normal Approximation - Predicted Boundaries
#'
#' @details
#' Applies a funnel plot analysis with normal approximation to site-level data and then calculates predicted
#' percentages/rates and upper- and lower-bounds across the full range of sample sizes/total exposure values.
#'
#' @section Statistical Methods:
#' This function applies a funnel plot analysis with normal approximation to site-level data and then calculates
#' predicted percentages/rates and upper- and lower- bounds (funnels) based on the standard deviation from the mean
#' across the full range of sample sizes/total exposure values.
#'
#' @section Data Specification:
#' The input data (`dfTransformed`) for Analyze_NormalApprox is typically created using
#' \code{\link{Transform_Rate}} and should be one record per site with columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Total number of participants at site with event of interest/Total number of events of interest at site
#' - `Denominator` - Total number of participants at site/Total number of days of exposure at site
#' - `Metric` - Proportion of participants at site with event of interest/Rate of events at site (Numerator / Denominator)
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}.
#' @param vThreshold `numeric` upper and lower boundaries based on standard deviation. Should be identical to
#' the thresholds used in `*_Assess()` functions.
#' @param nStep `numeric` step size of imputed bounds.
#' @param strType `character` Statistical method. Valid values:
#'   - `"binary"` (default)
#'   - `"rate"`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` containing predicted boundary values with upper and lower bounds across the
#' range of observed values.
#'
#' @examples
#' #' # Binary
#' dfInput <- Disp_Map_Raw()
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Total"
#' )
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "binary")
#' dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed, c(-3, -2, 2, 3), strType = "binary")
#'
#' # Rate
#' dfInput <- AE_Map_Raw() %>% na.omit()
#' dfTransformed <- Transform_Rate(
#'   dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
#' dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed, c(-3, -2, 2, 3), strType = "rate")
#'
#' @import dplyr
#' @importFrom tidyr expand_grid
#'
#' @export

Analyze_NormalApprox_PredictBounds <- function(
  dfTransformed,
  vThreshold = c(-3, -2, 2, 3),
  nStep = 1,
  strType = "binary",
  bQuiet = TRUE
) {
  if (is.null(vThreshold)) {
    vThreshold <- c(-3, -2, 2, 3)
    cli::cli_alert("vThreshold was not provided. Setting default threshold to c(-3, -2, 2, 3)")
  }

  # add a 0 threhsold to calcultate estimate without an offset
  vThreshold <- unique(c(vThreshold, 0))

  # Calculate expected event count and predicted bounds across range of total exposure.
  vRange <- seq(
    min(dfTransformed$Denominator) - nStep,
    max(dfTransformed$Denominator) + nStep,
    by = nStep
  )

  if (strType == "binary") {
    dfBounds <- tidyr::expand_grid(Threshold = vThreshold, Denominator = vRange) %>%
      mutate(
        LogDenominator = log(.data$Denominator),
        # Calculate expected event percentage at sample size.
        vMu = sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator),
        phi = mean(((dfTransformed$Metric - sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator)) /
          sqrt(sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator) * (1 - sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator)) / dfTransformed$Denominator))^2),
        # Calculate lower and upper bounds of expected event percentage given specified threshold.
        Metric = .data$vMu + .data$Threshold * sqrt(.data$phi * .data$vMu * (1 - .data$vMu) / .data$Denominator),
        Numerator = .data$Metric * .data$Denominator
      ) %>%
      # Only positive percentages are meaningful bounds
      filter(.data$Numerator >= 0) %>%
      select(
        "Threshold",
        "Denominator",
        "LogDenominator",
        "Numerator",
        "Metric"
      )
  } else if (strType == "rate") {
    dfBounds <- tidyr::expand_grid(Threshold = vThreshold, Denominator = vRange) %>%
      mutate(
        LogDenominator = log(.data$Denominator),
        # Calculate expected rate at given exposure.
        vMu = sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator),
        phi = mean(((dfTransformed$Metric - sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator)) /
          sqrt(sum(dfTransformed$Numerator) / sum(dfTransformed$Denominator) / dfTransformed$Denominator))^2),
        # Calculate lower and upper bounds of expected event count given specified threshold.
        Metric = .data$vMu + .data$Threshold * sqrt(.data$phi * .data$vMu / .data$Denominator),
        Numerator = .data$Metric * .data$Denominator
      ) %>%
      # Only positive counts are meaningful bounds
      filter(.data$Numerator >= 0) %>%
      select(
        "Threshold",
        "Denominator",
        "LogDenominator",
        "Numerator",
        "Metric"
      )
  }

  return(dfBounds)
}
