#' Calculate needed values for report
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' @inheritParams shared-params
#'
#' @export
#' @keywords internal
#'
#' @return `list` with the following elements:
#' - `GroupLevel` (character): The group level of the report.
#' - `SnapshotDate` (Date): The date of the snapshot.
#' - `lStudy` (list): Study-level metadata.
#' - `StudyID` (character): The study ID.
#' - `red_kris` (numeric): The number of red flags.
#' - `amber_kris` (numeric): The number of amber flags.

Report_Setup <- function(dfGroups = NULL, dfMetrics = NULL, dfResults = NULL) {
  output <- list()

  # Get type of report
  group <- unique(dfMetrics$GroupLevel)
  if (length(group) == 1) {
    output$GroupLevel <- group
  } else {
    cli::cli_alert("Multiple `GroupLevel`s detected in dfMetrics, so GroupLevel not specifed for KRI Report. ")
    output$GroupLevel <- ""
  }

  # Get the snapshot date
  if ("SnapshotDate" %in% names(dfResults)) {
    output$SnapshotDate <- max(dfResults$SnapshotDate)
  } else {
    cli::cli_alert("No `SnapshotDate` detected in dfResults, setting to today: {Sys.Date()}")
    output$SnapshotDate <- Sys.Date()
    dfResults$SnapshotDate <- Sys.Date()
  }

  # Get the study-level metadata
  output$lStudy <- dfGroups %>%
    dplyr::filter(.data$GroupLevel == "Study") %>%
    select("Param", "Value") %>%
    pivot_wider(names_from = "Param", values_from = "Value") %>%
    as.list()

  if( output$GroupLevel == "Country") {
    output$lStudy$CountryCount <- length(unique(dfResults$GroupID)) %>% as.character()
  }

  output$StudyID <- dfGroups %>%
    filter(.data$GroupLevel == 'Study') %>%
    pull('GroupID') %>%
    unique()

  # Count Red and Amber Flags for most recent snapshot
  output$red_kris <- dfResults %>%
    filter(.data$SnapshotDate == output$SnapshotDate) %>%
    mutate(red_flag = ifelse(.data[["Flag"]] %in% c(-2, 2), 1, 0)) %>%
    pull(.data[["red_flag"]]) %>%
    sum()

  output$amber_kris <- dfResults %>%
    filter(.data$SnapshotDate == output$SnapshotDate) %>%
    mutate(amber_flag = ifelse(.data[["Flag"]] %in% c(-1, 1), 1, 0)) %>%
    pull(.data[["amber_flag"]]) %>%
    sum()

  return(output)
}
