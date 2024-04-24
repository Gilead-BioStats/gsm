#' QTL Analysis for Binary and Rate Outcomes.
#'
#' `r lifecycle::badge("stable")`
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
#' dfInput <- Disp_Map_Raw()
#' dfTransformed <- Transform_Rate(dfInput,
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Total",
#'   strGroupCol = "StudyID"
#' )
#'
#' dfAnalyzed <- Analyze_QTL(dfTransformed, strOutcome = "binary")
#' dfFlagged <- Flag_QTL(dfAnalyzed, vThreshold = 0.2)
#'
#' dfInput <- PD_Map_Raw_Binary()
#' dfTransformed <- Transform_Rate(dfInput,
#'   strGroupCol = "StudyID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Total"
#' )
#'
#' dfAnalyzed <- Analyze_QTL(dfTransformed, strOutcome = "rate")
#' dfFlagged <- Flag_QTL(dfAnalyzed, vThreshold = 0.01)
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
