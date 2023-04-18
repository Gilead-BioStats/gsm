#' Attach longitudinal content to snapshot
#'
#' Attach stacked, longitudinal snapshot data and time series widgets to output of
#' [gsm::Make_Snapshot()].
#'
#' @param lSnapshot `list` The output of [gsm::Make_Snapshot()] where `bReturnStudyObject = TRUE`.
#' @param cPath `character` Path to longitudinal snapshots, returned by [gsm::Make_Snapshot()].
#' @param bAppendTimeSeriesCharts `logical` Append time series charts to KRIs? Default: `TRUE`.
#'
#' @examples
#' \dontrun{
#' # Path to study
#' study_path <- here::here("data-raw/AA-AA-000-0000")
#' 
#' # Output current snapshot to dated folder within study folder.
#' #snapshot_path <- paste(study_path, Sys.Date(), sep = '/'); dir.create(snapshot_path)
#' snapshot <- Make_Snapshot(
#'   #cPath = snapshot_path
#' )
#' 
#' augmented_snapshot <- Augment_Snapshot(
#'   lSnapshot = snapshot,
#'   cPath = study_path
#' )
#' }
#'
#' @return `list` The output of [gsm::Make_Snapshot()] with longitudinal data and widgets appended.
#'
#' @export
Augment_Snapshot <- function(
    lSnapshot,
    cPath,
    bAppendTimeSeriesCharts = TRUE
) {
  # TODO: alternatively accept the output of StackSnapshots?
  stackedSnapshots <- StackSnapshots(cPath, lSnapshot)

  if (bAppendTimeSeriesCharts) {
    lSnapshot$lStudyAssessResults <- lSnapshot$lStudyAssessResults %>%
      purrr::imap(function(result, workflowid) {
        result$lResults$lData$dfSummaryLongitudinal <- stackedSnapshots$results_summary %>%
          dplyr::filter(
              .data$workflowid == !!workflowid
          )

        workflow <- stackedSnapshots$meta_workflow %>%
          dplyr::filter(
              .data$workflowid == !!workflowid
          )

        parameters <- stackedSnapshots$parameters %>%
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

  lSnapshot[["lStackedSnapshots"]] <- stackedSnapshots

  return(lSnapshot)
}
