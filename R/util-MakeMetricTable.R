#' Generate a Summary data.frame for use in reports
#'
#' @description
#' `r lifecycle::badge("stable")`
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
#'     dplyr::filter(.data$MetricID == "Analysis_kri0001") %>%
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
        StudyID = character(), GroupID = character(), MetricID = character(),
        Group = character(), SnapshoteDate = as.Date(integer()),
        Enrolled = integer(), Numerator = integer(),
        Denominator = integer(), Metric = double(), Score = double(),
        Flag = character()
      )
    )
  }

  metric_ids <- sort(unique(dfResults$MetricID))
  if (length(metric_ids) > 1) {
    LogMessage(
      level = "fatal",
      message =
        paste0(
          "{dfResults} must only contain one unique `MetricID`.",
          "{dfResults} contains these `MetricID` values: {metric_ids}."
        )
    )
  }

  if (rlang::arg_match(strGroupLevel) == "Site" & !is.null(dfGroups)) {
    dfResults$Group <- glue::glue(
      "{dfResults$GroupID} ({dfResults$InvestigatorLastName})"
    )
  } else {
    dfResults$Group <- dfResults$GroupID
  }

  MetricTable <- dfResults %>%
    dplyr::arrange(
      desc(abs(.data$Flag)),
      desc(abs(.data$Score))
    ) %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::where(is.double),
        ~ round(.x, 2)
      )
    ) %>%
    dplyr::select(
      dplyr::any_of(c(
        "StudyID",
        "GroupID",
        "MetricID",
        "Group",
        "SnapshotDate",
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
