#' Calculate Bounds for display in scatterplots
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Calculate bounds across a set of metrics.
#'
#' @inheritParams shared-params
#' @param strMetrics Character vector of `MetricID`s to include in `dfBounds`.
#'   All unique values from `dfResults$MetricID` used by default.
#' @param strStudyID Study ID. Uses `dfResults$StudyID` by default. If more than
#'   one snapshot date is found in `dfResults`, a warning is thrown and this
#'   function returns `NULL`.
#' @param dSnapshotDate Snapshot date. Uses `dfResults$SnapshotDate` by default.
#'   If more than one snapshot date is found in `dfResults`, a warning is thrown
#'   and this function returns `NULL`.
#'
#' @return A data frame.
#'
#' @examples
#' dfBounds <- MakeBounds(
#'   dfResults = reportingResults,
#'   dfMetrics = reportingMetrics
#' )
#'
#' @export
MakeBounds <- function(
  dfResults,
  dfMetrics,
  strMetrics = unique(dfResults$MetricID),
  dSnapshotDate = unique(dfResults$SnapshotDate),
  strStudyID = unique(dfResults$StudyID)
) {
  stop_if_empty(strMetrics)
  stop_if_empty(dSnapshotDate)
  stop_if_empty(strStudyID)
  cli::cli_inform("Creating stacked dfBounds data for {strMetrics}")

  if (length(dSnapshotDate) != 1) {
    cli::cli_warn(
      "More than one SnapshotDate found. Returning NULL",
      class = "gsm_warning-multiple_values"
    )
    return(NULL)
  }

  if (length(strStudyID) != 1) {
    cli::cli_warn(
      "More than one StudyID found. Return NULL",
      class = "gsm_warning-multiple_values"
    )
    return(NULL)
  }

  dfBounds <- strMetrics %>%
    purrr::map(function(strMetric) {
      dfResult <- dplyr::filter(dfResults, .data$MetricID == strMetric)
      lMetric <- dfMetrics %>%
        dplyr::filter(.data$MetricID == strMetric) %>%
        as.list()
      vThreshold <- ParseThreshold(strThreshold = lMetric$Threshold)
      if (!is.null(lMetric$AnalysisType) &&
        tolower(unique(lMetric$AnalysisType)) %in% c("identity")) {
        dfBounds <- NULL 
      } else if (!is.null(lMetric$AnalysisType) &&
        tolower(unique(lMetric$AnalysisType)) %in% c("poisson")) {
        dfBounds <- Analyze_Poisson_PredictBounds(
          dfResult,
          vThreshold = vThreshold
        ) %>%
          mutate(MetricID = strMetric) %>%
          mutate(StudyID = strStudyID) %>%
          mutate(SnapshotDate = dSnapshotDate)
      } else {
        dfBounds <- Analyze_NormalApprox_PredictBounds(
          dfResult,
          strType = lMetric$AnalysisType %||% "binary",
          vThreshold = vThreshold
        ) %>%
          mutate(MetricID = strMetric) %>%
          mutate(StudyID = strStudyID) %>%
          mutate(SnapshotDate = dSnapshotDate)
      }

      return(dfBounds)
    }) %>%
    purrr::list_rbind()

  return(dfBounds)
}
