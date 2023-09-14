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
    nPath <- ifelse(grepl("$\\/", cPath), cPath, paste0(cPath, "/"))
    snapshot_date <- list.files(nPath)
    snapshot_directory_names <- paste0(nPath, snapshot_date)

    ## get current status
    is_current <- snapshot_directory_names %>%
      purrr::set_names(snapshot_date) %>%
      purrr::map_df(., function(snap) {
        snapshot <- read.csv(paste0(snap, "/results_summary.csv")) %>%
          distinct(workflowid) %>%
          mutate()
      }, .id = "snapshot_date") %>%
      group_by(workflowid) %>%
      summarise(
        latest = max(as.Date(snapshot_date), na.rm = TRUE),
        .groups = "drop"
      ) %>%
      mutate(is_current = latest == max(latest))

    old_workflows <- is_current %>%
      filter(!is_current) %>%
      split(.$latest) %>%
      map(., . %>% pull(.data$workflowid))

    ## pull object into snapshot
    old_snapshots <- list()
    for (latest in is_current %>%
      filter(!.data$is_current) %>%
      pull(.data$latest) %>%
      as.character()) {
      old_snapshots[[latest]] <- readRDS(paste0(nPath, latest, "/snapshot.rds"))
    }

    ## Set active status
    for (kri in names(lSnapshot$lStudyAssessResults)) {
      lSnapshot$lStudyAssessResults[[kri]][["bActive"]] <- TRUE
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
    lSnapshot[["lStatus"]] <- is_current %>%
      `colnames<-`(c("Workflow ID", "Latest Snapshot", "Currently Active"))
  }

  lSnapshot[["lStackedSnapshots"]] <- stackedSnapshots

  return(lSnapshot)
}
