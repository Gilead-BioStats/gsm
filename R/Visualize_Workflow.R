#' Visualize Workflow
#'
#' Show the data structure of subject and site-level data in an assessment.
#'
#' @param lAssessment
#'
#' @return A flowchart.
#'
#' @importFrom DiagrammeR create_node_df create_graph render_graph
#'
#' @export

Visualize_Workflow <- function(dfFlowchart, lAssessment, dfResult, dfNode) {

  dfFlowchart <-
    bind_rows(
      dfNode %>%
        mutate(from = row_number()),

      dfResult[grep('df', names(dfResult))] %>%
        imap_dfr(~tibble(assessment = lAssessment$name,
                         n_step = max(dfNode$n_step),
                         name = .y,
                         inputs = .y,
                         n_row = nrow(.x),
                         n_col = ncol(.x),
                         checks = TRUE)) %>%
        mutate(n_step = n_step + row_number(),
               from = n_step,
               to = n_step + 1)
    ) %>%
    filter(!is.na(n_row)) %>%
    mutate(n_row = ifelse(!is.na(lag(n_row_end)), lag(n_row_end), n_row))

  node_df <- create_node_df(
    n = nrow(dfFlowchart),
    type = "a",
    label = dfFlowchart$inputs,
    value = dfFlowchart$name,
    style = "filled",
    color = "aqua",
    shape = "rectangle",
    n_row = dfFlowchart$n_row,
    n_col = dfFlowchart$n_col,
    checks = dfFlowchart$checks,
    fixedsize = "false"
  ) %>%
    replace(is.na(.), "") %>%
    mutate(label = paste0(label, "\n", n_col, " x ", n_row),
           tooltip = paste0("Data dimensions: \n", label),
           label = ifelse(substr(value, 1, 2) != "df", paste0("[", value, "]\n\n", label), label))

  edge_df <- data.frame(
    from = head(dfFlowchart$from, n = nrow(dfFlowchart) - 1),
    to = head(dfFlowchart$to, n = nrow(dfFlowchart) - 1),
    rel = "next"
  )

  create_graph(
    nodes_df = node_df,
    edges_df = edge_df,
    attr_theme = "lr") %>%
    render_graph()
}
