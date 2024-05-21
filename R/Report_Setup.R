#' Calculate needed values for report
#'
#' Calculates the following:
#' - Snapshot date: dfStudy$SnapshotDate (if available) or Sys.Date()
#' - Study ID: dfStudy$StudyID (if available)  or "Unknown"
#' @param dfStudy `data.frame` Site-level metadata.
#' @export
#' @keywords internal
#'
#'
Report_Setup <- function(dfStudy = NULL, dfMetrics = NULL, dfSummary = NULL) {

  output <- list()
  # Get type of report

  group <- unique(dfMetrics$group)

  if(length( group )==1) {
    output$group <- group %>% stringr::str_to_title()
  } else {
    output$group <- ""
  }

  output$SnapshotDate <- if("SnapshotDate" %in% names(dfStudy)) {
    dfStudy$SnapshotDate[[1]]
  } else {
    Sys.Date()
  }

  output$StudyID <- if("StudyID" %in% names(dfStudy)) {
    dfStudy$StudyID[[1]]
  } else {
    "Unknown"
  }

  output$red_kris <- dfSummary %>%
    mutate(red_flag = ifelse(.data[["Flag"]] %in% c(-2, 2), 1, 0)) %>%
    pull(.data[["red_flag"]]) %>%
    sum()

  output$amber_kris <- dfSummary %>%
    mutate(amber_flag = ifelse(.data[["Flag"]] %in% c(-1, 1), 1, 0)) %>%
    pull(.data[["amber_flag"]]) %>%
    sum()

  return(output)
}
