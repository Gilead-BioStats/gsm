#' Flowchart visualization of data pipeline steps from filtering to summary data for an assessment workflow.
#'
#' @param lAssessments `list` A list of assessment-specific metadata.
#'
#' @return A flowchart of type `grViz`/`htmlwidget`.
#'
#' @examples
#' lAssessments <- list(kri0001 = MakeAssessmentList()$kri0001)
#' lData <- list(
#'   dfSUBJ = clindata::rawplus_dm,
#'   dfAE = clindata::rawplus_ae,
#'   dfPD = clindata::rawplus_protdev,
#'   dfCONSENT = clindata::rawplus_consent,
#'   dfIE = clindata::rawplus_ie
#' )
#' lTags <- list(
#'   Study = "myStudy"
#' )
#' lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
#'
#' kri0001 <- RunAssessment(lAssessments$kri0001, lData = lData, lMapping = lMapping, lTags = lTags)
#'
#' Visualize_Workflow(list(kri0001 = kri0001))
#'
#' @importFrom DiagrammeR create_node_df create_graph render_graph
#' @importFrom utils head
#' @import purrr
#'
#' @export

Visualize_Workflow <- function(lAssessments) {


  if (!is.null(lAssessments[[1]][["workflow"]])) {
    dfFlowchart <- map(lAssessments, function(studyObject) {


      name <- studyObject[["name"]]
      checks <- studyObject[["lChecks"]]
      workflow <- studyObject[["workflow"]]

      # rename workflow when checks are missing
      diff <- length(workflow) - length(checks)
      vec <- c(names(checks), rep("", diff))

      workflow <- workflow %>%
        imap(~ append(., list(n_step = .y))) %>%
        set_names(nm = vec)

      # make checks and workflow the same length so map2_dfr below doesn't fail.
      # empty lists will result in NA and will be accounted for to show domains that were not checked.
      if (diff > 0) {
        checks <- append(checks, vector(mode = "list", length = diff))
      }

      preAssessment <- map2_dfr(checks, workflow, function(checks, workflow) {
        domains <- workflow$inputs
        map_df(domains, function(x) {
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
      })

      if (nrow(preAssessment) > 1) {
        preAssessment <- preAssessment %>%
          slice(1:(n() - 1))
      }

      preAssessment <- preAssessment %>%
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


      pipelineSubset <- studyObject$lResults[grep("df", names(studyObject$lResults))]
      pipelineSubset[["dfBounds"]] <- NULL

      pipeline <- pipelineSubset %>%
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
          from = ifelse(is.na(.data$from), row_number(), .data$from),
          to = ifelse(is.na(.data$to), row_number() + 1, .data$to)
        )
    })

    # create_node_df for flowchart
    # add custom labels/tooltips
    flowchart <- map(dfFlowchart, function(assessment) {

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
        mutate(
          label = ifelse(.data$n_row != "", paste0(.data$label, "\n", .data$n_col, " x ", .data$n_row), .data$label),
          tooltip = paste0("Data dimensions: \n", .data$label),
          label = ifelse(
            substr(.data$value, 1, 2) != "df",
            paste0("[", .data$value, "]\n\n", .data$label),
            .data$label
          ),
          fillcolor = case_when(
            .data$checks == FALSE ~ "Tomato",
            .data$checks == "" ~ "LightSlateGray",
            TRUE ~ fillcolor
          ),
          tooltip = ifelse(.data$checks == "", paste0(.data$tooltip, "\nCheck Not Run"), .data$tooltip)
        )

      if (FALSE %in% node_df$checks) {
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

      edge_df <- assessment %>%
        filter(.data$to <= nrow(node_df)) %>%
        select(.data$from, .data$to) %>%
        as.data.frame()

      DiagrammeR::create_graph(
        nodes_df = node_df,
        edges_df = edge_df,
        attr_theme = "lr"
      ) %>%
        DiagrammeR::render_graph()
    })


    return(flowchart)
  } else {
    return(list(lAssessments$name))
  }
}
