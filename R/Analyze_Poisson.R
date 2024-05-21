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
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for `Analyze_Poisson` is typically created using \code{\link{Transform_Rate}} and should be one record per site with required columns for:
#' - `GroupID` - Site ID
#' - `Numerator` - Number of Adverse Events
#' - `Denominator` - Number of days of exposure
#' - `Metric` - Rate of exposure (Numerator / Denominator)
#'
#' @param dfTransformed data.frame in format produced by \code{\link{Transform_Rate}}. Must include GroupID, Numerator, Denominator and Metric.
#'
#' @return `data.frame` with one row per site with columns: GroupID, Numerator, Denominator, Metric, Score, and PredictedCount.
#'
#' @examples
#' dfInput <- tibble::tribble(
#'   ~SubjectID, ~SiteID, ~StudyID, ~CountryID, ~CustomGroupID, ~Exposure, ~Count, ~Rate,
#'   "0496", "5", "AA-AA-000-0000", "US", "0X167", 730, 5, 5/720,
#'   "1350", "78", "AA-AA-000-0000", "US", "0X002", 50, 2, 2/50,
#'   "0539", "139", "AA-AA-000-0000", "US", "0X052", 901, 5, 5/901,
#'   "0329", "162", "AA-AA-000-0000", "US", "0X049", 370, 3, 3/370,
#'   "0429", "29", "AA-AA-000-0000", "Japan", "0X116", 450, 2, 2/450,
#'   "1218", "143", "AA-AA-000-0000", "US", "0X153", 170, 3, 3/170,
#'   "0808", "173", "AA-AA-000-0000", "US", "0X124", 680, 6, 6/680,
#'   "1314", "189", "AA-AA-000-0000", "US", "0X093", 815, 4, 4/815,
#'   "1236", "58", "AA-AA-000-0000", "China", "0X091", 225, 1, 1/225,
#'   "0163", "167", "AA-AA-000-0000", "US", "0X059", 360, 3, 3/360
#' )
#'
#' dfTransformed <- Transform_Rate(dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' @export

Analyze_Poisson <- function(dfTransformed) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns not found: GroupID, GroupType, Denominator, Numerator, Metric" =
      all(c("GroupID", "GroupType", "Denominator", "Numerator", "Metric") %in% names(dfTransformed)),
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
      "Numerator",
      "Denominator",
      "Metric",
      Score = ".resid",
      PredictedCount = ".fitted"
    ) %>%
    arrange(.data$Score)

  return(dfAnalyzed)
}
