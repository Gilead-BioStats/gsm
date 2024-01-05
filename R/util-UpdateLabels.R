#' Update visualization labels based on metadata.
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' If visualizations are created outside of a standard snapshot (e.g., [gsm::Make_Snapshot()]), there is not enough descriptive metadata to assign
#' meaningful labels. `UpdateLabels` updates labels for JavaScript visualizations (from `rbm-viz`) using metadata provided by `dfMetaWorkflow.`
#'
#' @param strWorkflowId `character` Name of Workflow ID, e.g., 'kri0001'.
#' @param lCharts `list` The output of [gsm::MakeKRICharts()].
#' @param dfMetaWorkflow `data.frame` The metadata for a workflow or set of workflows.
#'
#' @return `list` `lStudyAssessResults` with updated JavaScript visualizations, annotated with the values provided by `dfMetaWorkflow`.
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' updated_study <- UpdateLabels(study, gsm::meta_workflow)
#' }
#'
#' @importFrom purrr map
#'
#' @export
UpdateLabels <- function(strWorkflowId, lCharts, dfMetaWorkflow) {
  stopifnot(
    "[ lStudyAssessResults ] must be a list." = is.list(lCharts),
    "[ dfMetaWorkflow ] must be a data.frame" = is.data.frame(dfMetaWorkflow)
  )


  # split out JS charts and ggplot2 charts ----------------------------------
  js_charts <- lCharts[grep("JS", names(lCharts))]
  gg_charts <- lCharts[!names(lCharts) %in% names(js_charts)]


  js_charts_updated <- purrr::map(js_charts, ~ {
    .x$x$workflow <- AssignLabelsJS(.x, strWorkflowId, dfMetaWorkflow)
    return(.x)
  })


  gg_charts_updated <- purrr::map(gg_charts, ~ {
    required_labels <- SubsetMetaWorkflow(dfMetaWorkflow, strWorkflowId)

    .x$labels$y <- glue::glue("{required_labels$numerator} ({required_labels$outcome})")
    .x$labels$x <- glue::glue("{required_labels$group}: {required_labels$denominator}")
    .x$labels$title <- glue::glue("{required_labels$metric} by {required_labels$group}")
    .x$labels$subtitle <- glue::glue("Workflow: {required_labels$workflowid}")
    return(.x)
  })

  lCharts <- purrr::flatten(
    dplyr::lst(
      js_charts_updated,
      gg_charts_updated
    )
  )

  return(lCharts)
}

AssignLabelsJS <- function(lPlot, strWorkflowID, dfWorkflow) {
  required_labels <- SubsetMetaWorkflow(dfWorkflow, strWorkflowID) %>%
    select(
      "workflowid",
      "metric",
      "numerator",
      "denominator",
      "model",
      "score",
      "group"
    )

  lPlot$x$workflow %>%
    mutate(
      workflowid = required_labels$workflowid,
      metric = required_labels$metric,
      numerator = required_labels$numerator,
      denominator = required_labels$denominator,
      model = required_labels$model,
      score = required_labels$score,
      group = required_labels$group
    )
}


SubsetMetaWorkflow <- function(dfWorkflow, strWorkflowID) {
  dfWorkflow %>%
    filter(.data$workflowid == strWorkflowID)
}
