#' Poisson Analysis - Predicted Boundaries
#'
#' @details
#'
#' Fits a Poisson model to site-level data and then calculates predicted count values and upper- and
#' lower- bounds for across the full range of exposure values.
#'
#' @section Statistical Methods:
#' This function fits a Poisson model to site-level data and then calculates residuals for each
#' site. The Poisson model is run using standard methods in the `stats` package by fitting a `glm`
#' model with family set to `poisson` using a "log" link. Upper and lower boundary values are then
#' calculated using the method described here TODO: Add link.
#'
#' @section Data Specification:
#' The input data (`dfTransformed`) for Analyze_Poisson is typically created using
#' \code{\link{Transform_Rate}} and should be one record per site with columns for:
#' - `GroupID` - Unique subject ID
#' - `Numerator` - Number of Events
#' - `Denominator` - Number of days of exposure
#'
#' @param dfTransformed `data.frame` data.frame in format produced by
#' \code{\link{Transform_Rate}}. Must include GroupID, N, Numerator and Denominator.
#' @param vThreshold `numeric` upper and lower boundaries in residual space. Should be identical to
#' the thresholds used AE_Assess().
#' @param nStep `numeric` step size of imputed bounds.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`.
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
#' dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed, c(-5, 5))
#'
#' @importFrom lamW lambertWm1 lambertW0
#' @importFrom stats glm offset poisson qchisq
#' @importFrom tibble tibble
#' @importFrom tidyr expand_grid
#'
#' @export

Analyze_Poisson_PredictBounds <- function(
  dfTransformed,
  vThreshold = c(-5, 5),
  nStep = .05,
  bQuiet = TRUE
) {
  if (is.null(vThreshold)) {
    vThreshold <- c(-5, 5)
    cli::cli_alert("vThreshold was not provided. Setting default threshold to c(-5, 5)")
  }

  # add a 0 threhsold to calcultate estimate without an offset
  vThreshold <- unique(c(vThreshold, 0))

  # Calculate log of total exposure at each site.
  dfTransformed$LogDenominator <- log(
    dfTransformed$Denominator
  )

  # Fit GLM of number of events at each site predicted by total exposure.
  cModel <- glm(
    Numerator ~ stats::offset(LogDenominator),
    family = poisson(link = "log"),
    data = dfTransformed
  )

  # Calculate expected event count and predicted bounds across range of total exposure.
  vRange <- seq(
    min(dfTransformed$LogDenominator) - nStep,
    max(dfTransformed$LogDenominator) + nStep,
    by = nStep
  )

  dfBounds <- tidyr::expand_grid(Threshold = vThreshold, LogDenominator = vRange) %>%
    mutate(
      # Calculate expected event count at given exposure.
      vMu = as.numeric(exp(.data$LogDenominator * cModel$coefficients[2] + cModel$coefficients[1])),
      # Calculate lower bound of expected event count given specified threshold.
      vEst = .data$Threshold^2 - 2 * .data$vMu,
      vWEst = .data$vEst / (2 * exp(1) * .data$vMu),
      PredictYPositive = .data$vEst / (2 * lamW::lambertW0(.data$vWEst)),
      PredictYNegative = .data$vEst / (2 * lamW::lambertWm1(.data$vWEst)),
      Numerator = case_when(
        .data$Threshold < 0 ~ PredictYNegative,
        .data$Threshold > 0 ~ PredictYPositive,
        .data$Threshold == 0 ~ vMu
      ),
      Denominator = exp(.data$LogDenominator)
    ) %>%
    # NaN is meaningful result indicating not bounded
    filter(!is.nan(.data$Numerator)) %>%
    select(
      "Threshold",
      "LogDenominator",
      "Denominator",
      "Numerator"
    )

  return(dfBounds)
}
