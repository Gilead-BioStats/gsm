#' Check Snapshot Inputs
#'
#' @description
#' Check that the output created from [gsm::Make_Snapshot()] returns all expected tables and columns within tables as defined by the
#' data model ([gsm::rbm_data_spec]).
#'
#' @param snapshot `list` List returned from running [gsm::Make_Snapshot()].
#'
#' @return `list` Named list including:
#' - `expected_tables` `data.frame` with columns `in_snapshot`, `expected_gismo`, and `status`.
#' - `expected_columns` `data.frame` with columns `snapshot_table`, `snapshot_column`, `gismo_table`, `gismo_column`, and `status`.
#' - `status_tables` `logical` TRUE if all checks pass. FALSE if not.
#' - `status_columns` `logical` TRUE if all checks pass. FALSE if not.
#'
#' @examples
#' \dontrun{
#' snapshot <- Make_Snapshot()
#' check_snapshot <- CheckSnapshotInputs(snapshot)
#' }
#'
#' @importFrom purrr map_int imap_dfr
#'
#' @export
CheckSnapshotInputs <- function(snapshot) {
  # get rbm_data_spec/data model
  gismo_input <- gsm::rbm_data_spec %>%
    filter(.data$System == "Gismo") %>%
    arrange(match(.data$Table, names(snapshot)))

  gismo_input <- split(gismo_input, gismo_input$Table)

  # expected tables ---------------------------------------------------------

  # check to see if there are any QTL workflows
  # if yes - results_analysis should be included
  # if no - results_analysis should not be included
  if (exists("results_summary", where = snapshot)) {
    hasQTL <- length(grep("qtl", unique(snapshot$results_summary$workflowid))) > 0

    # check to see if there are *only* QTLs being run
    # if yes - results_bounds should not be included
    # if no - results_bounds should be included
    qtlOnly <- sum(purrr::map_int(c("kri", "cou"), ~ length(grep(.x, unique(snapshot$results_summary$workflowid)))))

    if (qtlOnly == 0) {
      # QTLs don't produce a meaningful results_bounds data.frame
      # Only have gsm_analysis_date appended at the end of Make_Snapshot()
      # Duplicate expected result here
      gismo_input$results_bounds <- tibble(Column = "gsm_analysis_date")
    }
  } else {
    hasQTL <- FALSE
  }

  if (!hasQTL) {
    gismo_input$results_analysis <- NULL
  }

  # expected tables for gismo input
  expected_gismo <- tibble(tables = sort(names(gismo_input)))

  # tables in snapshot
  in_snapshot <- tibble(tables = sort(names(snapshot)))

  expected_tables <- left_join(
    expected_gismo,
    in_snapshot,
    by = "tables",
    suffix = c("_gismo", "_snapshot"),
    keep = TRUE
  ) %>%
    mutate(
      status = .data$tables_gismo == .data$tables_snapshot,
      status = ifelse(is.na(.data$status), FALSE, .data$status)
    )

  tables_status <- all(expected_tables$status)


  # expected columns --------------------------------------------------------
  expected_columns_snapshot <- purrr::imap_dfr(snapshot, ~ tibble(snapshot_table = .y, snapshot_column = names(.x))) %>%
    arrange(.data$snapshot_table, .data$snapshot_column)
  expected_columns_gismo <- purrr::imap_dfr(gismo_input, ~ tibble(gismo_table = .y, gismo_column = .x$Column)) %>%
    arrange(.data$gismo_table, .data$gismo_column)

  expected_columns <- full_join(
    expected_columns_snapshot,
    expected_columns_gismo,
    by = c(
      "snapshot_table" = "gismo_table",
      "snapshot_column" = "gismo_column"
    ),
    keep = TRUE
  ) %>%
    rowwise() %>%
    mutate(
      status = sum(is.na(pick(everything()))),
      status = ifelse(.data$status == 0, TRUE, FALSE)
    ) %>%
    ungroup()

  columns_status <- all(expected_columns$status)
  # return ------------------------------------------------------------------


  all_checks <- list(
    expected_tables = expected_tables,
    expected_columns = expected_columns,
    status_tables = tables_status,
    status_columns = columns_status,
    bStatus = isTRUE(tables_status) & isTRUE(columns_status)
  )

  return(all_checks)
}
