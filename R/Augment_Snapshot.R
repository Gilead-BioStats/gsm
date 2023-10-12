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

  single_snap <- c("lSnapshotDate",
                   "lSnapshot",
                   "lStudyAssessResults",
                   "lInputs")

  long_snap <- c("meta_param",
                 "meta_workflow",
                 "results_analysis",
                 "results_summary",
                 "status_param",
                 "status_site",
                 "status_study",
                 "status_workflow",
                 "parameters")

  if(all(names(stackedSnapshots) %in% long_snap)){
    if (bAppendTimeSeriesCharts) {
      lSnapshot$lStudyAssessResults <- lSnapshot$lStudyAssessResults %>%
        purrr::imap(function(result, workflowid) {
          this_workflow_id <- result$name

          siteSelectLabelValue <- lSnapshot$lSnapshot$meta_workflow %>%
            filter(.data$workflowid == this_workflow_id) %>%
            pull(.data$group)

          result$lResults$lData$dfSummaryLongitudinal <- stackedSnapshots$results_summary %>%
            dplyr::filter(
              .data$workflowid == this_workflow_id
            )

          workflow <- stackedSnapshots$meta_workflow %>%
            dplyr::filter(
              .data$workflowid == this_workflow_id
            )

          parameters <- stackedSnapshots$parameters %>%
            dplyr::filter(
              .data$workflowid == this_workflow_id
            )

          if(!grepl("qtl", result$name)){
            result$lResults$lCharts[["timeSeriesContinuousJS"]] <- Widget_TimeSeries(
              results = result$lResults$lData$dfSummaryLongitudinal,
              workflow = workflow,
              parameters = parameters,
              siteSelectLabelValue = siteSelectLabelValue
            )
          }

          if(grepl("qtl", result$name)){
            result$lResults$lCharts[["timeSeriesContinuousJS"]] <- Widget_TimeSeriesQTL(
              qtl = this_workflow_id,
              raw_results = stackedSnapshots$results_summary,
              raw_workflow = stackedSnapshots$meta_workflow,
              raw_param = stackedSnapshots$meta_param,
              raw_analysis = stackedSnapshots$results_analysis
            )
          }

          return(result)
        })
    }

    if (bAppendLongitudinalResults) {
      snapshots <- ExtractDirectoryPaths(cPath, file = "snapshot.rds", include.partial.match = FALSE, verbose = FALSE)
      snapshot_dates <- ExtractSnapshotDate(snapshots)

      ## get current status
      status <- stackedSnapshots$results_summary %>%
        select(.data$snapshot_date, .data$workflowid) %>%
        filter(.data$snapshot_date %in% snapshot_dates$snapshot_date) %>%
        distinct() %>%
        group_by(workflowid) %>%
        summarise(
          latest = max(as.Date(snapshot_date), na.rm = TRUE),
          .groups = "drop"
        ) %>%
        mutate(is_current = latest == max(latest)) %>%
        left_join(snapshot_dates, by = c("latest" = "snapshot_date"))

      ## get old workflowids
      old_workflows <- status %>%
        filter(!is_current) %>%
        split(.$latest) %>%
        map(., . %>% pull(.data$workflowid))

      ## Set active status
      for (kri in names(lSnapshot$lStudyAssessResults)) {
        lSnapshot$lStudyAssessResults[[kri]][["bActive"]] <- TRUE
      }

      ## pull object into snapshot
      if(length(old_workflows) != 0){
        old_snapshots <- list()
        for (i in 1:(status %>% filter(!.data$is_current) %>% nrow())) {
          old_date <- status[i,"latest"] %>% pull() %>% as.character()
          old_file_path <- paste0(snapshots[grepl(status[i,"foldername"], snapshots)], "/snapshot.rds")
          old_snapshots[[old_date]] <- readRDS(file = old_file_path)
        }

        for (dates in names(old_snapshots)) {
          for (kri in names(old_snapshots[[dates]]$lStudyAssessResults)) {
            old_snapshots[[dates]]$lStudyAssessResults[[kri]][["bActive"]] <- FALSE
          }
        }

        ## Transfer old snaps to current snap
        for (old_date in names(old_workflows)) {
          for (kri in old_workflows[[old_date]]) {
            lSnapshot$lStudyAssessResults[[kri]] <- old_snapshots[[old_date]]$lStudyAssessResults[[kri]]
          }
        }
      }

      lSnapshot[["lStatus"]] <- status %>%
        rename("Workflow ID" = "workflowid",
               "Latest Snapshot" = "latest",
               "Currently Active" = "is_current",
               "Folder Name" = "foldername")
    }

    lSnapshot[["lStackedSnapshots"]] <- stackedSnapshots
  } else if(all(names(snapshot) %in% single_snap)){
    return(lSnapshot)
  } else {
    stop("Unexpected error occurred in the names of StackedSnapshot output")
  }
}
