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
  bAppendHistoricalKris = TRUE
) {
  # TODO: alternatively accept the output of StackSnapshots?
  stackedSnapshots <- StackSnapshots(cPath, lSnapshot, vFolderNames)

  if (bAppendHistoricalKris) {

    # list full directory names so snapshots can be read
    snapshot_directories <- list.files(cPath, full.names = TRUE)

    # loop through directories to read in the .rds file
    kris_to_update <- purrr::map(snapshot_directories, ~ {
      all_files <- list.files(., full.names = TRUE)

      # identify the .rds file and read it in
      if ("snapshot.rds" %in% basename(all_files)) {
        this_snapshot <- readRDS(all_files[basename(all_files) == "snapshot.rds"])

        # extract the date and `Study_Assess()` results ony
        snapshot <- list(
          lSnapshotDate = this_snapshot$lSnapshotDate,
          lStudyAssessResults = this_snapshot$lStudyAssessResults
        )

        return(snapshot)
      }

    }) %>%
      setNames(basename(snapshot_directories))

    lSnapshot$lStudyAssessResults <- update_kris_in_list(kris_to_update)

  }

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

  lSnapshot[["lStackedSnapshots"]] <- stackedSnapshots

  return(lSnapshot)
}



update_kris_in_list <- function(kri_list) {

  # determine most recent snapshot ------------------------------------------
  newest_snapshot_date <- purrr::map(kri_list, ~ .x$lSnapshotDate) %>%
    purrr::reduce(max) %>%
    as.character()

  newest_snapshot <- kri_list[[newest_snapshot_date]]

  # remove most recent to consolidate historical snapshots ------------------
  historical_snapshots <- kri_list[names(kri_list) != newest_snapshot_date]

  # unique list of historical KRIs to check against most recent KRIs
  all_unique_historical_kris <- purrr::map(historical_snapshots, ~names(.x$lStudyAssessResults)) %>%
    unlist() %>%
    unique()

  if (!all(all_unique_historical_kris %in% names(newest_snapshot$lStudyAssessResults))) {
    all_missing_kris_from_newest <- setdiff(all_unique_historical_kris, names(newest_snapshot$lStudyAssessResults))

    for (kri in all_missing_kris_from_newest) {

      most_recent_missing_kri <- purrr::imap_dfr(historical_snapshots, function(snapshot_value, snapshot_date) {

        if (kri %in% names(snapshot_value$lStudyAssessResults)) {
          tibble(
            date = as.Date(snapshot_date),
            kri_name = kri
          )
        }
      }) %>%
        filter(
          date == max(date)
        )

      # append KRI to snapshot
      newest_snapshot$lStudyAssessResults[[kri]] <- historical_snapshots[[as.character(most_recent_missing_kri$date)]]$lStudyAssessResults[[most_recent_missing_kri$kri_name]]

      # append historical to snapshot to create "historical" section in report
      newest_snapshot$lStudyAssessResults[[kri]]$historical <- TRUE
    }

  }

  return(newest_snapshot)
}
