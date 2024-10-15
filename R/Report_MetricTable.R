#' Generate a summary table for a report
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function generates a summary table for a report by joining the provided
#' results data frame with the site-level metadata from dfGroups. It then filters and arranges the
#' data based on certain conditions and displays the result in a datatable.
#'
#' @inheritParams shared-params
#' @param dfResults `r gloss_param("dfResults")`
#'   `r gloss_extra("dfResults_filtered")`
#' @param strGroupLevel  group level for the table
#' @param strGroupDetailsParams one or more parameters from dfGroups to be added as columns in the table
#' @param vFlags `integer` List of flag values to include in output table. Default: `c(-2, -1, 1, 2)`.
#'
#' @return A datatable containing the summary table
#'
#' @examples
#' # site-level report
#' Report_MetricTable(
#'   dfResults = reportingResults %>%
#'     dplyr::filter(.data$MetricID == "kri0001") %>%
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
    return("Nothing flagged for this KRI.")
  }

  MetricTable %>%
    gsm_gt() %>%
    fmt_sign_rag(columns = "Flag")

}
