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
#'       dplyr::filter(.data$MetricID == 'kri0001') %>%
#'       FilterByLatestSnapshotDate(),
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
  if(!is.null(dfGroups)) {
    dfResults <- dfResults %>%
      add_Groups_metadata(
        dfGroups,
        strGroupLevel,
        strGroupDetailsParams
      )
  }
  dfResults <- dfResults %>%
    dplyr::filter(
      .data$Flag %in% vFlags
    )

  if (!nrow(dfResults)) {
    return("Nothing flagged for this KRI.")
  }

  if (length(unique(dfResults$MetricID)) > 1) {
    stop("Expecting `dfResults` to be filtered to one unique MetricID, but many detected.")
  }

  if (rlang::arg_match(strGroupLevel) == "Site" && !is.null(dfGroups) && !is.null(dfGroups$InvestigatorLastName)) {
    dfResults$Group <- glue::glue("{dfResults$GroupID} ({dfResults$InvestigatorLastName})")
  } else {
    dfResults$Group <- dfResults$GroupID
  }

  SummaryTable <- dfResults %>%
    dplyr::arrange(
      desc(abs(.data$Flag)),
      desc(abs(.data$Score))
    ) %>%
    dplyr::mutate(
      Flag = Report_FormatFlag(.data$Flag),
      dplyr::across(
        dplyr::where(is.numeric),
        ~ round(.x, 2)
      )
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "Group",
        "Enrolled" = "ParticipantCount",
        "Numerator",
        "Denominator",
        "Metric",
        "Score",
        "Flag"
      ))
    ) %>%
    kableExtra::kbl(format = "html", escape = FALSE) %>%
    kableExtra::kable_styling("striped", full_width = FALSE)

  return(SummaryTable)
}
