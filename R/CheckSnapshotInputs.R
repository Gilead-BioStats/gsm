function(snapshot) {
  gismo_input <- gsm::rbm_data_spec %>%
    filter(.data$System ==
      "Gismo") %>%
    arrange(match(.data$Table, names(snapshot)))
  gismo_input <- split(gismo_input, gismo_input$Table)
  if (exists("results_summary", where = snapshot)) {
    hasQTL <- length(grep("qtl", unique(snapshot$results_summary$workflowid))) >
      0
    qtlOnly <- sum(purrr::map_int(c("kri", "cou"), ~ length(grep(
      .x,
      unique(snapshot$results_summary$workflowid)
    ))))
    if (qtlOnly == 0) {
      gismo_input$results_bounds <- tibble(Column = "gsm_analysis_date")
    }
  } else {
    hasQTL <- FALSE
  }
  expected_gismo <- tibble(tables = sort(names(gismo_input)))
  in_snapshot <- tibble(tables = sort(names(snapshot)))
  expected_tables <- left_join(expected_gismo, in_snapshot,
    by = "tables", suffix = c("_gismo", "_snapshot"), keep = TRUE
  ) %>%
    mutate(
      status = .data$tables_gismo == .data$tables_snapshot,
      status = ifelse(is.na(.data$status), FALSE, .data$status)
    )
  tables_status <- all(expected_tables$status)
  expected_columns_snapshot <- purrr::imap_dfr(snapshot, ~ tibble(
    snapshot_table = .y,
    snapshot_column = names(.x)
  )) %>% arrange(
    .data$snapshot_table,
    .data$snapshot_column
  )
  expected_columns_gismo <- purrr::imap_dfr(gismo_input, ~ tibble(
    gismo_table = .y,
    gismo_column = .x$Column
  )) %>% arrange(
    .data$gismo_table,
    .data$gismo_column
  )
  expected_columns <- full_join(expected_columns_snapshot,
    expected_columns_gismo,
    by = c(
      snapshot_table = "gismo_table",
      snapshot_column = "gismo_column"
    ), keep = TRUE
  ) %>%
    rowwise() %>%
    mutate(
      status = sum(is.na(pick(everything()))),
      status = ifelse(.data$status == 0, TRUE, FALSE)
    ) %>%
    ungroup()
  columns_status <- all(expected_columns$status)
  all_checks <- list(
    expected_tables = expected_tables, expected_columns = expected_columns,
    status_tables = tables_status, status_columns = columns_status,
    bStatus = isTRUE(tables_status) & isTRUE(columns_status)
  )
  return(all_checks)
}
