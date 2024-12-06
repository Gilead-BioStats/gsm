#' Make Summary Data Frame
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Create a concise summary of assessment results that is easy to aggregate across assessments
#'
#' @details
#'
#' `Summarize` supports the input data (`dfFlagged`) from the `Flag` function.
#'
#' @section Data Specification:
#'
#' (`dfFlagged`) has the following required columns:
#' - `GroupID` - Group ID
#' - `GroupLevel` - Group Type
#' - `Flag` - Flagging value of -1, 0, or 1
#' - `Score` - Column from analysis results.
#'
#' @param dfFlagged data.frame in format produced by [Flag()].
#' @param nMinDenominator `numeric` Specifies the minimum denominator required to return a `score` and calculate a `flag`. Default: NULL
#'
#' @return Simplified finding data.frame with columns for GroupID, GroupType, Metric, Score, Flag
#' when associated with a workflow.
#'
#' @examples
#' 
#' dfTransformed <- Transform_Rate(analyticsInput)
#' dfAnalyzed <- Analyze_NormalApprox(dfTransformed)
#' dfFlagged <- Flag(dfAnalyzed)
#' dfSummary <- Summarize(dfFlagged)
#'
#' @export

Summarize <- function(
  dfFlagged,
  nMinDenominator = NULL
) {
  stopifnot(
    "dfFlagged is not a data frame" = is.data.frame(dfFlagged),
    "One or more of these columns: GroupID, GroupLevel, Flag, Score, not found in dfFlagged" = all(c("GroupID", "GroupLevel", "Flag", "Score") %in% names(dfFlagged))
  )

  if (!("Numerator" %in% colnames(dfFlagged))) {
    dfFlagged$Numerator <- NA
  }

  if (!("Denominator" %in% colnames(dfFlagged))) {
    dfFlagged$Denominator <- NA
  }

  dfSummary <- dfFlagged %>%
    select(
      any_of(
        c(
          "GroupID",
          "GroupLevel",
          "Numerator",
          "Denominator",
          "Metric",
          "Score",
          "Flag"
        )
      )
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
