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
#' The input data (` dfTransformed`) for the Analyze_Poisson is typically created using
#' \code{\link{Transform_EventCount}} and should be one record per site with columns for:
#' - `SubjectID` - Unique subject ID
#' - `SiteID` - Site ID
#' - `TotalCount` - Number of Events
#' - `TotalExposure` - Number of days of exposure
#'
#' @param dfTransformed `data.frame` data.frame in format produced by
#' \code{\link{Transform_EventCount}}. Must include SubjectID, SiteID, TotalCount and TotalExposure.
#' @param vThreshold `numeric` upper and lower boundaries in residual space. Should be identical to
#' the thresholds used AE_Assess().
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @importFrom stats glm offset poisson
#'
#' @return data frame containing predicted boundary values with upper and lower bounds across the
#' range of observed values
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure")
#' dfBounds <- Analyze_Poisson_PredictBounds(dfTransformed, c(-5, 5))
#'
#' @export

Analyze_Poisson_PredictBounds <- function(dfTransformed, vThreshold = c(-5, 5), bQuiet = TRUE) {
  # Calculate log of total exposure at each site.
  dfTransformed$LogExposure <- log(
    dfTransformed$TotalExposure
  )

  # Fit GLM of number of events at each site predicted by total exposure.
  cModel <- glm(
    TotalCount ~ stats::offset(LogExposure),
    family = poisson(link = "log"),
    data = dfTransformed
  )

  # Calculate expected event count and predicted bounds across range of total exposure.
  dfBounds <- data.frame(
    # Generate sequence along range of total exposure.
    LogExposure = seq(
      min(dfTransformed$LogExposure) - 0.05,
      max(dfTransformed$LogExposure) + 0.05,
      by = 0.05
    )
  ) %>%
    mutate(
      # Calculate expected event count at given exposure.
      vMu = as.numeric(exp(.data$LogExposure * cModel$coefficients[2] + cModel$coefficients[1])),
      a = qchisq(0.95, 1), # used in Pearson calculation

      # Calculate lower bound of expected event count given specified threshold.
      vLo = vThreshold[1]^2 - 2 * .data$vMu,
      vWLo = vLo / (2 * exp(1) * .data$vMu),

      # Calculate upper bound of expected event count given specified threshold.
      vHi = vThreshold[2]^2 - 2 * .data$vMu,
      vWHi = vHi / (2 * exp(1) * .data$vMu)
    )

  # {lamW} is required to run this code block.
  if (requireNamespace('lamW', quietly = TRUE)) {
    # Calculate boundaries around predicted event counts with Lambert-W function.
    dfBounds$PredictYLo <- dfBounds$vLo / (2 * lamW::lambertWm1(dfBounds$vWLo))
    dfBounds$PredictYHi <- dfBounds$vHi / (2 * lamW::lambertW0(dfBounds$vWHi))

    # Set lower limit of predicted bounds to 0.
    dfBounds$LowerCount <- if_else(is.nan(dfBounds$PredictYLo), 0, dfBounds$PredictYLo)
    dfBounds$UpperCount <- if_else(is.nan(dfBounds$PredictYHi), 0, dfBounds$PredictYHi)
  } else {
    dfBounds$LowerCount <- NA_real_
    dfBounds$UpperCount <- NA_real_
  }

  return(
    dfBounds %>%
      select(
        .data$LogExposure, MeanCount = .data$vMu, .data$LowerCount, .data$UpperCount
      )
  )
}
