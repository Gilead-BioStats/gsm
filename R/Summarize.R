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
#' @param strScoreCol column from analysis results to be copied to `dfSummary$Score`
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

Summarize <- function(dfFlagged, strScoreCol = "Score") {
  stopifnot(
    "dfFlagged is not a data frame" = is.data.frame(dfFlagged),
    "One or more of these columns: GroupID, Flag , strScoreCol, not found in dfFlagged" = all(c("GroupID", "Flag", strScoreCol) %in% names(dfFlagged))
  )

  dfSummary <- dfFlagged %>%
    select(
      "GroupID",
      "Metric",
      "Score",
      "Flag"
    ) %>%
    arrange(desc(abs(.data$Metric))) %>%
    arrange(match(.data$Flag, c(1, -1, 0)))

  return(dfSummary)
}
