#' Make Time Series Trend Data
#'
#' @param lSnapshot `list` The output of [gsm::Make_Snapshot()] where `bReturnStudyObject = TRUE`.
#' @param cDirectory `character` Path to longitudinal snapshots, returned by [gsm::Make_Snapshot()].
#' @param bAppendTimeSeriesCharts `logical` Append time series charts to KRIs? Default: `TRUE`.
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' directory_location <- here::here("snapshots")
#'
#' trend_data <- MakeTrendData(lStudyAssess = study, cDirectory = directory_location)
#'
#' }
#'
#' @return `list` The output of [gsm::Study_Assess()] with longitudinal data appended.
#'
#' @export
MakeTrendData <- function(
    lSnapshot,
    cDirectory,
    bAppendTimeSeriesCharts = TRUE
) {
  # TODO: alternatively accept the output of StackSnapshots?
  snapshots <- StackSnapshots(cDirectory, lSnapshot)

  if (bAppendTimeSeriesCharts) {
    lSnapshot$lStudyAssessResults <- lSnapshot$lStudyAssessResults %>%
      purrr::imap(function(result, workflowid) {
        result$lResults$lData$dfSummaryLongitudinal <- snapshots$results_summary %>%
          dplyr::filter(
              .data$workflowid == !!workflowid
          )

        workflow <- snapshots$meta_workflow %>%
          dplyr::filter(
              .data$workflowid == !!workflowid
          )

        parameters <- snapshots$parameters %>%
          dplyr::filter(
              .data$workflowid == !!workflowid
          )

        result$lResults$lCharts[['timeSeriesContinuousJS']] <- Widget_TimeSeries(
          results = result$lResults$lData$dfSummaryLongitudinal,
          workflow = workflow,
          parameters = parameters
        )

        return(result)
      })
  }

  lSnapshot[["lSnapshots"]] <- snapshots

  return(lSnapshot)
}
