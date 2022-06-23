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

Visualize_Workflow <- function(lAssessments) {

  lAssessments <- discard(lAssessments, ~ .x$bStatus == FALSE)

  dfFlowchart <- map(lAssessments, function(studyObject) {
    name <- studyObject[["name"]]
    checks <- studyObject[["checks"]]
    workflow <- studyObject[["workflow"]] %>% set_names(nm = names(checks))

    preAssessment <- map2_dfr(checks, workflow, function(checks, workflow){
      domains <- workflow$inputs
      map_df(domains, function(x){
        tibble(
          assessment = name,
          name = workflow[["name"]],
          inputs = x,
          n_row = checks[[x]][["dim"]][1],
          n_col = checks[[x]][["dim"]][2],
          checks = checks[[x]][["status"]]
        )
      })
    }) %>%
      slice(1:(n()-1)) %>%
      mutate(
        from = row_number(),
        n_step = with(rle(name), rep(seq_along(lengths), lengths))
      ) %>%
      group_by(name) %>%
      mutate(
        step = n(),
        to = n_step + step
      ) %>%
      select(-step) %>%
      ungroup()

    pipeline <- studyObject$lResults[grep("df", names(studyObject$lResults))] %>%
      purrr::imap_dfr(
        ~ tibble(
          assessment = name,
          name = .y,
          inputs = .y,
          n_row = nrow(.x),
          n_col = ncol(.x),
          checks = TRUE
        )
      ) %>%
      mutate(n_step = max(preAssessment$n_step) + row_number())

    bind_rows(preAssessment, pipeline) %>%
      mutate(
        from = ifelse(is.na(from), row_number(), from),
        to = ifelse(is.na(to), row_number() + 1, to)
      )

  })

  # create_node_df for flowchart
  # add custom labels/tooltips
  flowcharts <- map(dfFlowchart, function(assessment){
    df <- DiagrammeR::create_node_df(
      n = nrow(assessment),
      type = "a",
      label = assessment$inputs,
      value = assessment$name,
      style = "filled",
      color = "Black",
      fillcolor = "Honeydew",
      shape = "rectangle",
      n_row = assessment$n_row,
      n_col = assessment$n_col,
      checks = assessment$checks,
      fixedsize = "false"
    )

    df <- replace(df, is.na(df), "")

    node_df <- df %>%
      mutate(
        label = paste0(.data$label, "\n", .data$n_col, " x ", .data$n_row),
        tooltip = paste0("Data dimensions: \n", .data$label),
        label = ifelse(
          substr(.data$value, 1, 2) != "df",
          paste0("[", .data$value, "]\n\n", .data$label),
          .data$label
        )
      )

    edge_df <- data.frame(
      from = utils::head(assessment$from, n = nrow(assessment) - 1),
      to = utils::head(assessment$to, n = nrow(assessment) - 1)
    )

    DiagrammeR::create_graph(
      nodes_df = node_df,
      edges_df = edge_df,
      attr_theme = "lr") %>%
      DiagrammeR::render_graph()

  })

  return(flowcharts)
}
