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
#' - `SiteID` - Site ID
#' - `N` - Total number of participants at site
#' - `Flag` - Flagging value of -1, 0, or 1
#' - `strScoreCol` - Column from analysis results. Default is "PValue".
#'
#' @param dfFlagged data frame in format produced by \code{\link{Flag}}
#' @param strScoreCol column from analysis results to be copied to `dfSummary$Score`
#' @param lTags List of tags containing metadata to add to the data frame.
#'
#' @return Simplified finding data frame with columns for SiteID, N, Pvalue, Flag and any metadata specified in lTags.
#'
#' @examples
#' dfInput <- AE_Map_Adam()
#' dfTransformed <- Transform_EventCount(dfInput, strCountCol = "Count", strExposureCol = "Exposure", strKRILabel = "AEs/Week")
#' dfAnalyzed <- Analyze_Wilcoxon(dfTransformed)
#' dfFlagged <- Flag(dfAnalyzed, strColumn = "Score", strValueColumn = "Estimate")
#' dfSummary <- Summarize(dfFlagged)
#'
#' @import dplyr
#'
#' @export

Summarize <- function(dfFlagged, strScoreCol = "Score", lTags = NULL) {
  stopifnot(
    "dfFlagged is not a data frame" = is.data.frame(dfFlagged),
    "One or more of these columns: SiteID, N, Flag , strScoreCol, not found in dfFlagged" = all(c("SiteID", "N", "Flag", strScoreCol) %in% names(dfFlagged))
  )

  if (!is.null(lTags)) {
    stopifnot(
      "lTags is not named" = (!is.null(names(lTags))),
      "lTags has unnamed elements" = all(names(lTags) != "")
    )
  }

  dfSummary <- dfFlagged %>%
    select(
      .data$SiteID,
      .data$N,
      .data$KRI,
      .data$KRILabel,
      .data$Score,
      .data$ScoreLabel,
      .data$Flag
    ) %>%
    arrange(desc(abs(.data$KRI))) %>%
    arrange(match(.data$Flag, c(1, -1, 0))) %>%
    bind_cols(lTags[!names(lTags) %in% names(.data)])

  return(dfSummary)
}
