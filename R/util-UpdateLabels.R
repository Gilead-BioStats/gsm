#' Update visualization labels based on metadata.
#'
#' @description
#' If visualizations are created outside of a standard snapshot (e.g., [gsm::Make_Snapshot()]), there is not enough descriptive metadata to assign
#' meaningful labels. `UpdateLabels` updates labels for JavaScript visualizations (from `rbm-viz`) using metadata provided by `dfMetaWorkflow.`
#'
#'
#' @param lStudyAssessResults `list` The output of [gsm::Study_Assess()].
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
#' @export
UpdateLabels <- function(lStudyAssessResults, dfMetaWorkflow) {
  study <- lStudyAssessResults %>%
    map(~ {
      workflowid <- .x$name
      js_charts <- .x$lResults$lCharts[grep("JS", names(.x$lResults$lCharts))]

      js_charts_updated <- imap(js_charts, ~ {
        .x$x$workflow <- AssignLabels(.x, workflowid, dfMetaWorkflow)
        return(.x)
      })

      .x$lResults$lCharts[grep("JS", names(.x$lResults$lCharts))] <- js_charts_updated
      return(.x)
    })
}

AssignLabels <- function(lPlot, cWorkflowID, dfWorkflow) {
  required_labels <- SubsetMetaWorkflow(dfWorkflow, cWorkflowID) %>%
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


SubsetMetaWorkflow <- function(dfWorkflow, cWorkflowID) {
  dfWorkflow %>%
    filter(workflowid == cWorkflowID)
}
