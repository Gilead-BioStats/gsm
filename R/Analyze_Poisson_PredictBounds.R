#' Poisson Analysis - Predicted Boundaries.
#'
#' @description
#' `r lifecycle::badge("stable")`
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
#' @param dfTransformed `r gloss_param("dfTransformed")`
#'   `r gloss_extra("dfTransformed_Rate")`
#' @param vThreshold `numeric` upper and lower boundaries in residual space. Should be identical to
#' the thresholds used AE_Assess().
#' @param nStep `numeric` step size of imputed bounds.
#'
#' @return `data.frame` containing predicted boundary values with upper and lower bounds across the
#' range of observed values.
#'
#' @examples
#' dfTransformed <- Transform_Rate(analyticsInput)
#'
#' dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed, c(-5, 5))
#'
#' @export

Analyze_Poisson_PredictBounds <- function(
  dfTransformed,
  vThreshold = c(-5, 5),
  nStep = NULL
) {
  rlang::check_installed("lamW", reason = "to run `Analyze_Poisson_PredictBounds()`")

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

  # Set [ nStep ] to the range of the log denominator divided by 250.
  if (is.null(nStep)) {
    nMinLogDenominator <- min(dfTransformed$LogDenominator)
    nMaxLogDenominator <- max(dfTransformed$LogDenominator)
    nRange <- nMaxLogDenominator - nMinLogDenominator

    if (!is.null(nRange) && !is.na(nRange) && nRange != 0) {
      nStep <- nRange / 250
    } else {
      nStep <- .05
    }

    cli::cli_alert("nStep was not provided. Setting default step to {nStep}")
  }

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
