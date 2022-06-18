#' Flowchart visualization of data pipeline steps from filtering to summary data for an assessment workflow.
#'
#' @param lAssessment `list` A list of assessment-specific metadata.
#' @param lResult `list` A list of data and metadata from running any `*_Assess()` function.
#' @param dfNode `data.frame` A data frame containing metadata from an assessment workflow.
#'
#' @return A flowchart of type `grViz`/`htmlwidget`.
#'
#' @importFrom DiagrammeR create_node_df create_graph render_graph
#' @importFrom purrr imap_dfr
#' @importFrom utils head
#'
#' @export

Visualize_Workflow <- function(lAssessment, lResult, dfNode) {

  # data pipeline up to "mapping"
  subject_level <- dfNode %>%
    mutate(from = row_number())

  # data pipeline from dfInput to dfSummary
  domain_check <- lResult[grep('df', names(lResult))]

  # combine subject and domain - add "from" and "to" for the edge_df
  dfFlowchart <- bind_rows(
    subject_level,

    domain_check %>%
      purrr::imap_dfr(
        ~ tibble(
          assessment = lAssessment$name,
          n_step = max(dfNode$n_step),
          name = .y,
          inputs = .y,
          n_row = nrow(.x),
          n_col = ncol(.x),
          checks = TRUE
        )
      ) %>%
      mutate(
        n_step = .data$n_step + row_number(),
        from = .data$n_step,
        to = .data$n_step + 1
      )
  ) %>%
    filter(!is.na(.data$n_row)) %>%
    mutate(n_row = ifelse(!is.na(lag(.data$n_row_end)), lag(.data$n_row_end), .data$n_row))

  # create_node_df for flowchart
  # add custom labels/tooltips
  node_df <- DiagrammeR::create_node_df(
    n = nrow(dfFlowchart),
    type = "a",
    label = dfFlowchart$inputs,
    value = dfFlowchart$name,
    style = "filled",
    color = "Black",
    fillcolor = "Honeydew",
    shape = "rectangle",
    n_row = dfFlowchart$n_row,
    n_col = dfFlowchart$n_col,
    checks = dfFlowchart$checks,
    fixedsize = "false"
  )

  node_df <- replace(node_df, is.na(node_df), "")

  node_df <- node_df %>%
    mutate(
      label = paste0(.data$label, "\n", .data$n_col, " x ", .data$n_row),
      tooltip = paste0("Data dimensions: \n", .data$label),
      label = ifelse(
        substr(.data$value, 1, 2) != "df",
        paste0("[", .data$value, "]\n\n", .data$label),
        .data$label
      )
    )

  # edge_df
  edge_df <- data.frame(
    from = utils::head(dfFlowchart$from, n = nrow(dfFlowchart) - 1),
    to = utils::head(dfFlowchart$to, n = nrow(dfFlowchart) - 1)
  )

  # render graph
  DiagrammeR::create_graph(
    nodes_df = node_df,
    edges_df = edge_df,
    attr_theme = "lr") %>%
    DiagrammeR::render_graph()
}
