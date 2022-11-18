#' Title
#'
#' @param snapshot
#'
#' @return
#' @export
#'
#' @examples
CheckSnapshotInputs <- function(snapshot) {

  # snapshot <- Make_Snapshot()
  #
  # snapshot$results_summary <- NULL
  #
  # snapshot_kri <- Make_Snapshot(lAssessments = MakeWorkflowList(strNames = c("kri0001", "kri0002")))

  gismo_input <- gsm::rbm_data_spec %>%
    filter(System == "Gismo") %>%
    arrange(match(Table, names(snapshot))) %>%
    split(.$Table)

  browser()

# expected tables ---------------------------------------------------------

  # check to see if there are any QTL workflows
  # if yes - results_analysis should be included
  # if no - results_analysis should not be included
  if (exists("results_summary", where = snapshot)) {
    hasQTL <- length(grep("qtl", unique(snapshot$results_summary$workflowid))) > 0
  }

  if (!hasQTL) {
    gismo_input$results_analysis <- NULL
  }

  expected_tables <- tibble(
    in_snapshot = sort(names(snapshot)),
    expected_gismo = sort(names(gismo_input))
  ) %>%
    mutate(
      status = in_snapshot == expected_gismo
    )

  tables_status <- all(expected_tables$status)


# expected columns --------------------------------------------------------
  expected_columns_snapshot <- imap_dfr(snapshot, ~tibble(snapshot_table = .y, snapshot_column = names(.x))) %>%
    arrange(snapshot_table, snapshot_column)
  expected_columns_gismo <- imap_dfr(gismo_input, ~tibble(gismo_table = .y, gismo_column = .x$Column)) %>%
    arrange(gismo_table, gismo_column)

  expected_columns <- full_join(
    expected_columns_snapshot,
    expected_columns_gismo, by = c("snapshot_table" = "gismo_table",
                                   "snapshot_column" = "gismo_column"),
    keep = TRUE
  ) %>%
    mutate(
      status = ifelse(is.na(snapshot_table) || is.na(snapshot_column) || is.na(gismo_table) || is.na(gismo_column), FALSE, TRUE)
    )

  columns_status <- all(expected_columns$status)
# return ------------------------------------------------------------------

  all_checks <- list(
    expected_tables = expected_tables,
    expected_columns = expected_columns,
    tables_status = tables_status,
    columns_status = columns_status
  )

  return(all_checks)

}

CheckSnapshotInputs(snapshot)
