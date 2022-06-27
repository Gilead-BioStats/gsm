#' Flowchart visualization of data pipeline steps from filtering to summary data for an assessment workflow.
#'
#' @param lAssessments `list` A list of assessment-specific metadata.
#'
#' @return A flowchart of type `grViz`/`htmlwidget`.
#'
#' @examples
#' lAssessments <- MakeAssessmentList()
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_subj,
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::rawplus_pd,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfIE = clindata::rawplus_ie
#' )
#' lTags <- list(
#'   Study = "myStudy"
#' )
#' lMapping <- clindata::mapping_rawplus
#'
#' ae_assessment <- RunAssessment(lAssessments$ae, lData = lData, lMapping = lMapping, lTags = lTags)
#'
#' Visualize_Workflow(list(ae = ae_assessment))
#'
#' @importFrom DiagrammeR create_node_df create_graph render_graph
#' @importFrom utils head
#' @import purrr
#'
#' @export

Visualize_Workflow <- function(lAssessments) {

  #lAssessments <- discard(lAssessments, ~ .x$bStatus == FALSE)

  dfFlowchart <- map(lAssessments, function(studyObject) {
    name <- studyObject[["name"]]
    checks <- studyObject[["checks"]]
    workflow <- studyObject[["workflow"]] %>%
      imap(~append(., list(n_step = .y))) %>%
      set_names(nm = names(checks))

    preAssessment <- map2_dfr(checks, workflow, function(checks, workflow){

      domains <- workflow$inputs
      map_df(domains, function(x){
        tibble(
          assessment = name,
          name = workflow[["name"]],
          inputs = x,
          n_row = checks[[x]][["dim"]][1],
          n_col = checks[[x]][["dim"]][2],
          checks = checks[[x]][["status"]],
          n_step = workflow[["n_step"]]
        )
      })
    }) %>%
      slice(1:(n()-1)) %>%
      mutate(
        from = row_number()
      ) %>%
      group_by(.data$n_step) %>%
      mutate(
        step = n(),
        to = .data$n_step + .data$step
      ) %>%
      select(-.data$step) %>%
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
        from = ifelse(is.na(.data$from), row_number(), from),
        to = ifelse(is.na(.data$to), row_number() + 1, to)
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
      fontcolor = "Black",
      fillcolor = "Honeydew",
      shape = "rectangle",
      n_row = assessment$n_row,
      n_col = assessment$n_col,
      checks = assessment$checks,
      fixedsize = "false"
    )

    df <- replace(df, is.na(df), "")

    node_df <- df %>%
      mutate(label = ifelse(.data$n_row != "", paste0(.data$label, "\n", .data$n_col, " x ", .data$n_row), .data$label),
             tooltip = paste0("Data dimensions: \n", .data$label),
             label = ifelse(
               substr(.data$value, 1, 2) != "df",
               paste0("[", .data$value, "]\n\n", .data$label),
               .data$label
             ),
             fillcolor = ifelse((.data$checks == FALSE | .data$checks == ""), "Tomato", .data$fillcolor))

    if(FALSE %in% node_df$checks){
      node_df <- node_df %>%
        add_row(
          id = max(node_df$id) + 1,
          type = "a",
          label = "Error!",
          value = "Error!",
          style = "filled",
          color = "Black",
          fontcolor = "Black",
          fillcolor = "Tomato",
          shape = "rectangle",
          fixedsize = "false",
          tooltip = "Error in preceeding step(s). Check all workflow steps highlighted in red."
        )
    }

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
