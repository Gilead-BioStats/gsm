#' Generate a summary table for a report
#'
#' @description `r lifecycle::badge("stable")`
#'
#'   This function generates a summary table for a report by joining the
#'   provided results data frame with the site-level metadata from dfGroups. It
#'   then filters and arranges the data based on certain conditions and displays
#'   the result in a datatable.
#'
#' @inheritParams shared-params
#' @param dfResults `data.frame` A stacked summary of analysis pipeline output.
#'   Created by passing a list of results returned by [Summarize()] to
#'   [gsm.mapping::BindResults()]. Expected columns: `GroupID`, `GroupLevel`, `Numerator`,
#'   `Denominator`, `Metric`, `Score`, `Flag`, `MetricID`, `StudyID`,
#'   `SnapshotDate`. For this function, `dfResults` must be filtered to a single
#'   KRI (`MetricID`).
#' @param strGroupLevel  group level for the table
#' @param strGroupDetailsParams one or more parameters from dfGroups to be added
#'   as columns in the table
#' @param vFlags `integer` List of flag values to include in output table.
#'   Default: `c(-2, -1, 1, 2)`.
#'
#' @return A [gt::gt()] containing the summary table.
#'
#' @examples
#' # site-level report
#' Report_MetricTable(
#'   dfResults = reportingResults %>%
#'     dplyr::filter(.data$MetricID == "Analysis_kri0001") %>%
#'     FilterByLatestSnapshotDate(),
#'   dfGroups = reportingGroups
#' )
#'
#' @export
Report_MetricTable <- function(
  dfResults,
  dfGroups = NULL,
  strGroupLevel = c("Site", "Country", "Study"),
  strGroupDetailsParams = NULL,
  vFlags = c(-2, -1, 1, 2)
) {
  MetricTable <- MakeMetricTable(
    dfResults, dfGroups, strGroupLevel, strGroupDetailsParams, vFlags
  )

  if (!nrow(MetricTable)) {
    return(htmltools::tags$p("Nothing flagged for this KRI."))
  }

  # Check these columns against columns in the output of [ MakeMetricTable ].
  cols_to_hide <- intersect(
    c("StudyID", "GroupID", "MetricID"),
    names(MetricTable)
  )

  if (length(unique(MetricTable$SnapshotDate == 1))) {
    cols_to_hide <- c(cols_to_hide, "SnapshotDate")
  }

  MetricTable %>%
    gsm_gt() %>%
    gt::cols_hide(cols_to_hide) %>%
    fmt_sign(columns = "Flag")
}
