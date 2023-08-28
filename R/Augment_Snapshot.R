#' `r lifecycle::badge("experimental")`
#'
#' Attach longitudinal content to snapshot
#'
#' Attach stacked, longitudinal snapshot data and time series widgets to output of
#' [gsm::Make_Snapshot()].
#'
#' @param lSnapshot `list` The output of [gsm::Make_Snapshot()] where `bReturnStudyObject = TRUE`.
#' @param cPath `character` Path to longitudinal snapshots, returned by [gsm::Make_Snapshot()].
#' @param vFolderNames `vector` Name(s) of folder(s) found within `cPath` to use. Any folders not specified will not be used in the augment.
#' @param bAppendTimeSeriesCharts `logical` Append time series charts to KRIs? Default: `TRUE`.
#' @param bAppendLongitudinalResults `logical` Append time series/longitudinal data from `results_summary`? Default: `TRUE`.
#'
#' @examples
#' \dontrun{
#' # Path to study
#' study_path <- system.file("snapshots", "AA-AA-000-0000", package = "gsm")
#'
#' # Output current snapshot to dated folder within study folder.
#' # snapshot_path <- paste(study_path, Sys.Date(), sep = '/'); dir.create(snapshot_path)
#' snapshot <- Make_Snapshot()
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
  vFolderNames = NULL,
  bAppendTimeSeriesCharts = TRUE,
  bAppendLongitudinalResults = TRUE
) {
  # TODO: alternatively accept the output of StackSnapshots?
  stackedSnapshots <- StackSnapshots(cPath, lSnapshot, vFolderNames)

  if (bAppendTimeSeriesCharts) {
    lSnapshot$lStudyAssessResults <- lSnapshot$lStudyAssessResults %>%
      purrr::imap(function(result, workflowid) {
        this_workflow_id <- workflowid

        siteSelectLabelValue <- lSnapshot$lSnapshot$meta_workflow %>%
          filter(.data$workflowid == this_workflow_id) %>%
          pull(.data$group)

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

        result$lResults$lCharts[["timeSeriesContinuousJS"]] <- Widget_TimeSeries(
          results = result$lResults$lData$dfSummaryLongitudinal,
          workflow = workflow,
          parameters = parameters,
          siteSelectLabelValue = siteSelectLabelValue
        )

        return(result)
      })
  }

  if (bAppendLongitudinalResults) {
    tests <- stackedSnapshots$results_summary %>%
      mutate(current = case_when(snapshot_date == lSnapshot$lSnapshotDate ~ TRUE,
                                 TRUE ~ FALSE))

    max_dates <- stackedSnapshots$results_summary %>%
      group_by(.data$studyid, .data$workflowid) %>%
      summarise(snapshot_date = max(.data$snapshot_date)) %>%
      mutate(current = case_when(.data$snapshot_date == lSnapshot$lSnapshotDate ~ TRUE,
                                 TRUE ~ FALSE))

    if(any(!max_dates$current)){
      dropped <- max_dates %>%
        filter(!.data$current)
      for(i in 1:length(dropped$workflowid)){
        browser()
        lSnapshot$lStudyAssessResults[[dropped$workflowid[i]]] <- stackedSnapshots$results_summary %>%
                                                                  filter(.data$workflowid == dropped$workflowid[i],
                                                                         .data$snapshot_date == dropped$snapshot_date[i],
                                                                         .data$studyid == dropped$studyid[i])
      }
    }
  }

  lSnapshot[["lStackedSnapshots"]] <- stackedSnapshots

  return(lSnapshot)
}
