#' QTL Analysis for Binary and Rate Outcomes.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @details
#' Creates confidence intervals for the observed proportion of participants for the event of interest. Uses the exact binomial (`stats::binom.test`) or poisson test (`stats::poisson.test`).
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for `Analyze_QTL` is typically created using \code{\link{Transform_Rate}} and should be one record for the entire study with required columns for:
#' - `GroupID` - GroupID should be the StudyID
#' - `GroupLevel` - Group Type
#' - `N` - Total number of participants at site
#' - `Numerator` - Total number of participants at site with event of interest
#' - `Denominator` - Total number of participants at a site
#' - `Metric` - Proportion of participants at site with event of interest
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}
#' @param nConfLevel `numeric` specified confidence interval for QTL analysis.
#' @param strOutcome `character` indicates statistical test used for QTL analysis. One of `rate` or `binary`.
#'
#' @return `data.frame` with one row with columns: GroupID, Numerator, Denominator, Metric, Method, ConfLevel, Estimate, LowCI, UpCI and Score.
#'
#' @examples
#' # binary
#' dfTransformed <- tibble::tibble(
#'   GroupID      = c("AA-AA-000-0000"),
#'   Numerator    = c(122),
#'   Denominator  = c(1301),
#'   Metric       = c(0.0938)
#' )
#'
#' dfAnalyzed <- Analyze_QTL(dfTransformed, strOutcome = "binary")
#'
#' # rate
#' dfTransformedRate <- tibble::tibble(
#'   GroupID      = c("AA-AA-000-0000"),
#'   Numerator    = c(4473),
#'   Denominator  = c(6.19),
#'   Metric       = c(723)
#' )
#' dfAnalyzed <- Analyze_QTL(dfTransformedRate, strOutcome = "rate")
#'
#' @export

Analyze_QTL <- function(
  dfTransformed,
  nConfLevel = 0.95,
  strOutcome = "binary"
) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns: GroupID, Numerator, or Denominator not found in dfTransformed" = all(c("GroupID", "Numerator", "Denominator") %in% names(dfTransformed)),
    "NA value(s) found in GroupID" = all(!is.na(dfTransformed[["GroupID"]]))
  )

  if (strOutcome == "binary") {
    lModel <- stats::binom.test(dfTransformed$Numerator, dfTransformed$Denominator,
      alternative = "two.sided",
      conf.level = nConfLevel
    )
  }

  if (strOutcome == "rate") {
    lModel <- stats::poisson.test(dfTransformed$Numerator,
      T = dfTransformed$Denominator,
      alternative = "two.sided",
      conf.level = nConfLevel
    )
  }

  dfAnalyzed <- dfTransformed %>%
    bind_cols(
      Method = lModel$method,
      ConfLevel = nConfLevel,
      Estimate = lModel$estimate,
      LowCI = lModel$conf.int[1],
      UpCI = lModel$conf.int[2],
    ) %>%
    mutate(Score = .data$LowCI)

  return(dfAnalyzed)
}
