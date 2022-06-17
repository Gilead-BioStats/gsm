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

Visualize_Workflow <- function(lAssessment, dfResult, dfNode) {

  # data pipeline up to "mapping"
  subject_level <- dfNode %>%
    mutate(from = row_number())

  # data pipeline from dfInput to dfSummary
  domain_check <- dfResult[grep('df', names(dfResult))]

  if(is.null(unlist(domain_check))){
    dfFlowchart <- bind_rows(
      subject_level,
      tibble::tribble(
      ~assessment, ~n_step,           ~name,         ~inputs, ~n_row, ~n_col, ~checks, ~from, ~to, ~n_row_end,
      NA,       4,       "dfInput",       "dfInput",     NA,     NA,   FALSE,     4,   5,         NA,
      NA,       5, "dfTransformed", "dfTransformed",     NA,     NA,   FALSE,     5,   6,         NA,
      NA,       6,    "dfAnalyzed",    "dfAnalyzed",     NA,     NA,   FALSE,     6,   7,         NA,
      NA,       7,     "dfFlagged",     "dfFlagged",     NA,     NA,   FALSE,     7,   8,         NA,
      NA,       8,     "dfSummary",     "dfSummary",     NA,     NA,   FALSE,     8,   9,         NA
    ) %>%
      mutate(assessment = lAssessment$name)
    )

  }


  # combine all steps in pipeline to create node_df
  if(!is.null(unlist(domain_check))) {

  dfFlowchart <- bind_rows(
    subject_level,

    domain_check %>%
      imap_dfr(
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
        n_step = n_step + row_number(),
        from = n_step,
        to = n_step + 1
      )
  ) %>%
    filter(!is.na(n_row)) %>%
    mutate(n_row = ifelse(!is.na(lag(n_row_end)), lag(n_row_end), n_row))
  }

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
    mutate(
      label = paste0(label, "\n", n_col, " x ", n_row),
      tooltip = paste0("Data dimensions: \n", label),
      label = ifelse(
        substr(value, 1, 2) != "df",
        paste0("[", value, "]\n\n", label),
        label
      ),
      color = ifelse(checks == TRUE, "aqua", "red")
    )

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
