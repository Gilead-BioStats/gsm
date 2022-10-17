#' Funnel Plot Analysis for Binary Outcomes - Predicted Boundaries
#'
#' @details
#' Apply funnel plot analysis to site level data and then calculates predicted percentages and upper- and
#' lower- bounds for across the full range of sample sizes.
#'
#' @section Statistical Methods:
#' This function applies funnel plots analysis to site-level data and then calculates predicted percentages
#' and upper- and lower- bounds (funnels) for across the full range of sample sizes.
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
#' dfBounds <- Analyze_Binary_PredictBounds(dfTransformed, c(-3, -2, 2, 3))
#'
#' @import dplyr
#' @importFrom tidyr expand_grid
#'
#' @export

Analyze_Binary_PredictBounds <- function(dfTransformed, vThreshold = c(-3, -2, 2, 3), bQuiet = TRUE) {
  if (is.null(vThreshold)) {
    vThreshold <- c(-3, -2, 2, 3)
    cli::cli_alert("vThreshold was not provided. Setting default threshold to c(-3, -2, 2, 3)")
  }

  # add a 0 threhsold to calcultate estimate without an offset
  vThreshold <- unique(c(vThreshold, 0))

  # Calculate expected event count and predicted bounds across range of total exposure.
  vRange <- seq(
    min(dfTransformed$Denominator) - 0.05,
    max(dfTransformed$Denominator) + 0.05,
    by = 0.05
  )

  dfBounds <- tidyr::expand_grid(Threshold = vThreshold, Denominator = vRange) %>%
    mutate(
      # Calculate expected event percentage at sample size.
      vMu = mean(dfTransformed$Metric),
      # Calculate lower and upper bounds of expected event percentage given specified threshold.
      Numerator = .data$vMu + .data$Threshold*sqrt(.data$vMu*(1-.data$vMu)/.data$Denominator)
    ) %>%
    # Only positive percentages are meaningful bounds
    filter(.data$Numerator>=0) %>%
    select(
      "Threshold",
      "Denominator",
      "Numerator"
    )

  return(dfBounds)
}
