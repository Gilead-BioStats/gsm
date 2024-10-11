#' Generate a Summary data.frame for use in reports
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Generate a summary table for a report by joining the provided results data
#' frame with the site-level metadata from dfGroups, and filter and arrange the
#' data based on provided conditions.
#'
#' @inheritParams Report_MetricTable
#'
#' @return A data.frame containing the summary table
#'
#' @examples
#' # site-level report
#' MakeMetricTable(
#'   dfResults = reportingResults %>%
#'     dplyr::filter(.data$MetricID == "kri0001") %>%
#'     FilterByLatestSnapshotDate(),
#'   dfGroups = reportingGroups
#' )
#'
#' @export
MakeMetricTable <- function(
  dfResults,
  dfGroups = NULL,
  strGroupLevel = c("Site", "Country", "Study"),
  strGroupDetailsParams = NULL,
  vFlags = c(-2, -1, 1, 2)
) {
  # Check for if dfGroups was provided and process group metadata if available
  if (!is.null(dfGroups)) {
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
    return(
      data.frame(
        Group = character(), Enrolled = character(), Numerator = double(),
        Denominator = double(), Metric = double(), Score = double(),
        Flag = character()
      )
    )
  }

  metric_ids <- sort(unique(dfResults$MetricID))
  if (length(metric_ids) > 1) {
    cli::cli_abort(
      c(
        "{.arg dfResults} must only contain one unique {.field MetricID}.",
        x = "{.arg dfResults} contains these {.field MetricID} values: {metric_ids}."
      ),
      class = "gsm_error-multiple_values"
    )

    stop("Expecting `dfResults` to be filtered to one unique MetricID, but many detected.")
  }

  if (rlang::arg_match(strGroupLevel) == "Site" & !is.null(dfGroups)) {
    dfResults$Group <- glue::glue("{dfResults$GroupID} ({dfResults$InvestigatorLastName})")
  } else {
    dfResults$Group <- dfResults$GroupID
  }

  MetricTable <- dfResults %>%
    dplyr::arrange(
      desc(abs(.data$Flag)),
      desc(abs(.data$Score))
    ) %>%
    dplyr::mutate(
      # Flag = Report_FormatFlag(.data$Flag),
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
    )
  return(MetricTable)
}
