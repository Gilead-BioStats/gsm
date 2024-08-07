#' Poisson Analysis - Site Residuals.
#'
#' `r lifecycle::badge("stable")`
#'
#' @details
#' Fits a Poisson model to site-level data and adds columns capturing Residual and Predicted Count for each site.
#'
#' More information can be found in [The Poisson Regression Method](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-poisson-regression-method)
#' of the KRI Method vignette.
#'
#' @section Statistical Methods:
#'
#' This function fits a Poisson model to site-level data and then calculates residuals for each site.
#' The Poisson model is run using standard methods in the `stats` package by fitting a `glm` model with family
#' set to `poisson` using a "log" link. Site-level residuals are calculated using `stats::predict.glm` via `broom::augment`.
#'
#' @param dfTransformed `r gloss_param("dfTransformed")`
#'   `r gloss_extra("dfTransformed_Rate")`
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Denominator, Metric, Score, and PredictedCount.
#'
#' @examples
#' dfTransformed <- Transform_Rate(analyticsInput)
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' @export

Analyze_Poisson <- function(dfTransformed) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns not found: GroupID, GroupLevel, Denominator, Numerator, Metric" =
      all(c("GroupID", "GroupLevel", "Denominator", "Numerator", "Metric") %in% names(dfTransformed)),
    "NA value(s) found in GroupID" = all(!is.na(dfTransformed[["GroupID"]]))
  )

  dfModel <- dfTransformed %>%
    mutate(LogDenominator = log(.data$Denominator))

  cli::cli_alert_info(
    glue::glue(
      "Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ]."
    )
  )


  cModel <- stats::glm(
    Numerator ~ stats::offset(LogDenominator),
    family = stats::poisson(link = "log"),
    data = dfModel
  )

  dfAnalyzed <- broom::augment(cModel, dfModel, type.predict = "response") %>%
    select(
      "GroupID",
      "GroupLevel",
      "Numerator",
      "Denominator",
      "Metric",
      Score = ".resid",
      PredictedCount = ".fitted"
    ) %>%
    arrange(.data$Score)

  return(dfAnalyzed)
}
