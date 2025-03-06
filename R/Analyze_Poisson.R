#' Poisson Analysis - Site Residuals.
#'
#' `r lifecycle::badge("stable")`
#'
#' @details Fits a Poisson model to site-level data and adds columns capturing
#' Residual and Predicted Count for each site.
#'
#' More information can be found in [The Poisson Regression
#' Method](https://gilead-biostats.github.io/gsm/articles/KRI%20Method.html#the-poisson-regression-method)
#' of the KRI Method vignette.
#'
#' @section Statistical Methods:
#'
#'   This function fits a Poisson model to site-level data and then calculates
#'   residuals for each site. The Poisson model is run using standard methods in
#'   the `stats` package by fitting a `glm` model with family set to `poisson`
#'   using a "log" link. Site-level residuals are calculated using
#'   `stats::predict.glm` via `broom::augment`.
#'
#' @param dfTransformed `data.frame` Transformed data for analysis. Data should
#'   have one record per site with expected columns: `GroupID`, `GroupLevel`,
#'   `Numerator`, `Denominator`, and `Metric`. For more details see the Data
#'   Model vignette: `vignette("DataModel", package = "gsm")`. For this
#'   function, `dfTransformed` should typically be created using
#'   [Transform_Rate()].
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator,
#'   Denominator, Metric, Score, and PredictedCount.
#'
#' @examples
#' dfTransformed <- Transform_Rate(analyticsInput)
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' @export

Analyze_Poisson <- function(dfTransformed) {
  stop_if(cnd = !is.data.frame(dfTransformed), message = "dfTransformed is not a data.frame")
  stop_if(
    cnd = !all(c("GroupID", "GroupLevel", "Denominator", "Numerator", "Metric") %in% names(dfTransformed)),
    message = "One or more of these columns not found: GroupID, GroupLevel, Denominator, Numerator, Metric"
  )
  stop_if(cnd = !all(!is.na(dfTransformed[["GroupID"]])), message = "NA value(s) found in GroupID")

  dfModel <- dfTransformed %>%
    mutate(LogDenominator = log(.data$Denominator))

  LogMessage(
    level = "info",
    message = "Fitting log-linked Poisson generalized linear model of [ Numerator ] ~ [ log( Denominator ) ].",
    cli_detail = "alert_info"
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
