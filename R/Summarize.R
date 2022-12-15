#' Make Summary Data Frame
#'
#' Create a concise summary of assessment results that is easy to aggregate across assessments
#'
#' @details
#'
#' \code{Summarize} supports the input data (`dfFlagged`) from the \code{Flag} function.
#'
#' @section Data Specification:
#'
#' (`dfFlagged`) has the following required columns:
#' - `GroupID` - Group ID
#' - `Flag` - Flagging value of -1, 0, or 1
#' - `strScoreCol` - Column from analysis results.
#'
#' @param dfFlagged data.frame in format produced by \code{\link{Flag}}
#' @param nMinDenominator `numeric` Specifies the minimum denominator required to return a `score` and calculate a `flag`. Default: NULL
#' @param strScoreCol column from analysis results to be copied to `dfSummary$Score`
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @return Simplified finding data.frame with columns for GroupID, Metric, Score, Flag
#' when associated with a workflow.
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#'
#' dfTransformed <- Transform_Rate(dfInput,
#'   strGroupCol = "SiteID",
#'   strNumeratorCol = "Count",
#'   strDenominatorCol = "Exposure"
#' )
#'
#' dfAnalyzed <- Analyze_Poisson(dfTransformed)
#'
#' dfFlagged <- Flag(dfAnalyzed, vThreshold = c(-5, 5))
#'
#' dfSummary <- Summarize(dfFlagged)
#'
#' @import dplyr
#'
#' @export

Summarize <- function(
    dfFlagged,
    nMinDenominator= NULL,
    strScoreCol = "Score",
    bQuiet = TRUE) {

  stopifnot(
    "dfFlagged is not a data frame" = is.data.frame(dfFlagged),
    "One or more of these columns: GroupID, Flag , strScoreCol, not found in dfFlagged" = all(c("GroupID", "Flag", strScoreCol) %in% names(dfFlagged))
  )

  dfSummary <- dfFlagged %>%
    select(
      "GroupID",
      "Metric",
      "Numerator",
      "Denominator",
      "Score",
      "Flag"
    ) %>%
    arrange(desc(abs(.data$Metric))) %>%
    arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))

  if(!is.null(nMinDenominator)){
    dfSummary$Score[dfSummary$Denominator < nMinDenominator] <- NA
    dfSummary$Flag[dfSummary$Denominator < nMinDenominator] <- NA

    if (!bQuiet) {
      cli::cli_alert_info(
        paste0(
          sum(dfSummary$Denominator < nMinDenominator),
          " Site(s) have insufficient sample size due to KRI denominator less than {nMinDenominator}. \nThese site(s) will not have KRI score and flag summarized."
        )
      )
    }
  }

  return(dfSummary)
}
