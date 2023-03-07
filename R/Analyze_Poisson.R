#' `r lifecycle::badge("stable")`
#'
#' Poisson Analysis - Site Residuals
#'
#' @details
#' Fits a Poisson model to site-level data and adds columns capturing Residual and Predicted Count for each site.
#'
#' @section Statistical Methods:
#'
#' This function fits a Poisson model to site-level data and then calculates residuals for each site.
#' The Poisson model is run using standard methods in the `stats` package by fitting a `glm` model with family
#' set to `poisson` using a "log" link. Site-level residuals are calculated  `stats::predict.glm` via `broom::augment`.
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for Analyze_Poisson is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Number of Adverse Events
#' - `Denominator` - Number of days of exposure
#' - `Metric` - Rate of exposure (Numerator / Denominator)
#'
#' @param dfTransformed data.frame in format produced by \code{\link{Transform_Rate}}. Must include GroupID, Numerator, Denominator and Metric.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with columns added for "Score" and "PredictedCount".
#'
#' @examples
#' dfInput <- AE_Map_Raw() %>% na.omit() # na.omit is placeholder for now
#' dfTransformed <- Transform_Rate(dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' @import dplyr
#' @importFrom broom augment
#' @importFrom cli cli_alert_info
#' @importFrom glue glue
#' @importFrom stats glm offset poisson pnorm
#'
#' @export

Analyze_Poisson <- function(dfTransformed, bQuiet = TRUE) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns not found: GroupID, Denominator, Numerator, Metric" =
      all(c("GroupID", "Denominator", "Numerator", "Metric") %in% names(dfTransformed)),
    "NA value(s) found in GroupID" = all(!is.na(dfTransformed[["GroupID"]]))
  )

  dfModel <- dfTransformed %>%
    mutate(LogDenominator = log(.data$Denominator))

  if (!bQuiet) {
    cli::cli_alert_info(
      glue::glue(
        "Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ]."
      )
    )
  }

  cModel <- stats::glm(
    Numerator ~ stats::offset(LogDenominator),
    family = stats::poisson(link = "log"),
    data = dfModel
  )

  dfAnalyzed <- broom::augment(cModel, dfModel, type.predict = "response") %>%
    select(
      "GroupID",
      "Numerator",
      "Denominator",
      "Metric",
      Score = ".resid",
      PredictedCount = ".fitted"
    ) %>%
    arrange(.data$Score)

  return(dfAnalyzed)
}
