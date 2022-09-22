#' Poisson Analysis - Predicted Boundaries
#'
#' @details
#'
#' Fits a Poisson model to site level data and then calculates predicted count values and upper- and
#' lower- bounds for across the full range of exposure values.
#'
#' @section Statistical Methods:
#' This function fits a poisson model to site-level data and then calculates residuals for each
#' site. The poisson model is run using standard methods in the `stats` package by fitting a `glm`
#' model with family set to `poisson` using a "log" link. Upper and lower boundary values are then
#' calculated using the method described here TODO: Add link. In short,
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
#' dfInput <- AE_Map_Raw() %>% na.omit()  #na.omit is placeholder for now
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
#'
#' @export

Analyze_Poisson_PredictBounds <- function(dfTransformed, vThreshold = c(-5, 5), bQuiet = TRUE) {

  if (is.null(vThreshold)) {
    vThreshold <- c(-5, 5)
    cli::cli_alert("vThreshold was not provided. Setting default threshold to c(-5, 5)")
  }

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
  dfBounds <- tibble::tibble(
    # Generate sequence along range of total exposure.
    LogDenominator = seq(
      min(dfTransformed$LogDenominator) - 0.05,
      max(dfTransformed$LogDenominator) + 0.05,
      by = 0.05
    )
  ) %>%
    mutate(
      # Calculate expected event count at given exposure.
      vMu = as.numeric(exp(.data$LogDenominator * cModel$coefficients[2] + cModel$coefficients[1])),
      a = qchisq(0.95, 1), # used in Pearson calculation

      # Calculate lower bound of expected event count given specified threshold.
      vLo = vThreshold[1]^2 - 2 * .data$vMu,
      vWLo = .data$vLo / (2 * exp(1) * .data$vMu),

      # Calculate upper bound of expected event count given specified threshold.
      vHi = vThreshold[2]^2 - 2 * .data$vMu,
      vWHi = .data$vHi / (2 * exp(1) * .data$vMu),
      PredictYLo = .data$vLo / (2 * lamW::lambertWm1(.data$vWLo)),
      PredictYHi = .data$vHi / (2 * lamW::lambertW0(.data$vWHi)),
      LowerCount = if_else(is.nan(.data$PredictYLo), 0, .data$PredictYLo),
      UpperCount = if_else(is.nan(.data$PredictYHi), 0, .data$PredictYHi)
    ) %>%
    select(
      .data$LogDenominator,
      MeanCount = .data$vMu, .data$LowerCount, .data$UpperCount
    )

  return(dfBounds)
}
