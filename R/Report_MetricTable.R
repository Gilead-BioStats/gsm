#' Generate a summary table for a report
#'
#' This function generates a summary table for a report by joining the provided
#' results data frame with the site-level metadata from dfGroups. It then filters and arranges the
#' data based on certain conditions and displays the result in a datatable.
#'
#' @inheritParams shared-params
#' @param dfGroups A data frame containing the group-level metadata.
#' @param strSnapshotDate user specified snapshot date as string
#' @param strGroupLevel  group level for the table
#' @param strGroupDetailsParams one or more parameters from dfGroups to be added as columns in the table
#'
#' @return A datatable containing the summary table
#'
#' @export
Report_MetricTable <- function(dfResults,
                               dfGroups,
                               strSnapshotDate = NULL,
                               strGroupLevel = c("Site", "Study", "Country"),
                               strGroupDetailsParams = NULL) {
  dfResults <- dfResults %>%
    filter_by_latest_SnapshotDate(strSnapshotDate) %>%
    add_Groups_metadata(dfGroups, strGroupLevel, strGroupDetailsParams) %>%
    dplyr::filter(.data$Flag != 0)

  if (!nrow(dfResults)) {
    return("Nothing flagged for this KRI.")
  }

  SummaryTable <- dfResults %>%
    dplyr::arrange(desc(abs(.data$Score))) %>%
    dplyr::mutate(
      Flag = Report_FormatFlag(.data$Flag),
      dplyr::across(
        dplyr::where(is.numeric),
        ~ round(.x, 3)
      )
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "Site" = "GroupID",
        "Country",
        "Status",
        "PI" = "InvestigatorLastName",
        "Subjects" = "ParticipantCount"
      )),
      dplyr::everything()
    ) %>%
    dplyr::select(-'MetricID') %>%
    kableExtra::kbl(format = "html", escape = FALSE) %>%
    kableExtra::kable_styling("striped", full_width = FALSE)

  return(SummaryTable)
}
