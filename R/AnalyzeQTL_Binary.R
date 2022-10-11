#' Binomial QTL Analysis
#'
#' @details
#' Creates QTL Analysis results data for binary event of interest (e.g. Yes/No)
#'
#' @details
#'
#' Creates confidence intervals for the observed proportion of participants with event of interest using the exact binomial test
#'
#' @section Statistical Methods:
#'
#' TODO Coming soon ...
#'
#' @section Data Specification:
#'
#' The input data (`dfTransformed`) for AnalyzeQTL_Binary is typically created using \code{\link{Transform_Rate}} and should be one record for the entire study with required columns for:
#' - `GroupID` - GroupID should be the StudyID
#' - `N` - Total number of participants at site
#' - `Numerator` - Total number of participants at site with event of interest
#' - `Denominator` - Total number of participants at a site
#' - `Metric` - Proportion of participants at site with event of interest
#'
#' @param dfTransformed `data.frame` in format produced by \code{\link{Transform_Rate}}
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return `data.frame` with one row with columns: GroupID, N, Numerator, Denominator, Metric, Method, ConfLevel, Estimate, LowCI, UpCI.
#'
#' @examples
#' dfInput <- Disp_Map_Raw()
#' dfTransformed <- Transform_Rate(dfInput, strNumeratorCol = "Count",
#'                                          strDenominatorCol = "Total",
#'                                          strGroupCol = "StudyID")
#'
#' dfAnalyzed <- AnalyzeQTL_Binary(dfTransformed)
#' dfFlagged <- Flag( dfAnalyzed, strColumn = "LowCI", vThreshold = c(NA, 0.2) )
#'
#' @import dplyr
#'
#' @export

AnalyzeQTL_Binary <- function(
    dfTransformed,
    conf.level = 0.95,
    bQuiet = TRUE,
) {
  stopifnot(
    "dfTransformed is not a data.frame" = is.data.frame(dfTransformed),
    "One or more of these columns: GroupID, N, or the value in strOutcome not found in dfTransformed" = all(c("GroupID", "N") %in% names(dfTransformed)),
    "NA value(s) found in GroupID" = all(!is.na(dfTransformed[["GroupID"]])),
  )

  lModel <- binom.test( dfTransformed$Numerator, dfTransformed$Denominator,
                        alternative = "two-sided",
                        conf.level = conf.level)

  dfAnalyzed <- bind_cols( dfTransformed,
                           Method = lModel$method,
                           ConfLevel = conf.level,
                           Estimate = lModel$estimate,
                           LowCI = lModel$conf.int[1],
                           UpCI = lModel$conf.int[2] )

  return(dfAnalyzed)
}
