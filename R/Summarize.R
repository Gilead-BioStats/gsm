#' Make Summary Data Frame
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
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
#'
#' @return Simplified finding data.frame with columns for GroupID, Metric, Score, Flag
#' when associated with a workflow.
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
#' dfFlagged <- Flag(dfAnalyzed, vThreshold = c(-5, 5))
#'
#' dfSummary <- Summarize(dfFlagged)
#'
#' @export

Summarize <- function(
  dfFlagged,
  nMinDenominator = NULL,
  strScoreCol = "Score"
  ) {
  stopifnot(
    "dfFlagged is not a data frame" = is.data.frame(dfFlagged),
    "One or more of these columns: GroupID, GroupLevel, Flag , strScoreCol, not found in dfFlagged" = all(c("GroupID", "GroupLevel", "Flag", strScoreCol) %in% names(dfFlagged))
  )

  if (!("Numerator" %in% colnames(dfFlagged))) {
    dfFlagged$Numerator <- NA
  }

  if (!("Denominator" %in% colnames(dfFlagged))) {
    dfFlagged$Denominator <- NA
  }

  dfSummary <- dfFlagged %>%
    select(
      "GroupID",
      "GroupLevel",
      "Numerator",
      "Denominator",
      "Metric",
      "Score",
      "Flag"
    ) %>%
    arrange(desc(abs(.data$Metric))) %>%
    arrange(match(.data$Flag, c(2, -2, 1, -1, 0)))

  if (!is.null(nMinDenominator)) {
    dfSummary$Score[dfSummary$Denominator < nMinDenominator] <- NA
    dfSummary$Flag[dfSummary$Denominator < nMinDenominator] <- NA

    cli::cli_alert_info(
      paste0(
        sum(dfSummary$Denominator < nMinDenominator),
        " Site(s) have insufficient sample size due to KRI denominator less than {nMinDenominator}. \nThese site(s) will not have KRI score and flag summarized."
      )
    )
  }

  return(dfSummary)
}
