#' lifecycle::badge("stable")
#'
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
#' @importFrom purrr map
#'
#' @export
UpdateLabels <- function(lStudyAssessResults, dfMetaWorkflow) {
  stopifnot(
    "[ lStudyAssessResults ] must be a list." = is.list(lStudyAssessResults),
    "[ dfMetaWorkflow ] must be a data.frame" = is.data.frame(dfMetaWorkflow)
  )

  study <- lStudyAssessResults %>%
    purrr::map(~ {
      # get the name of the workflow -- this should match dfMetaWorkflow$workflowid to allow for subsetting
      workflowid <- .x$name


      # modify {rbm-viz} charts -------------------------------------------------

      # extract JavaScript charts created with {rbm-viz}, since they need to be modified
      # in a different way than {ggplot2} charts
      js_charts <- .x$lResults$lCharts[grep("JS", names(.x$lResults$lCharts))]

      # loop over JavaScript charts and update the `workflow` arg
      # -- `workflow` creates the labels for each widget
      js_charts_updated <- purrr::map(js_charts, ~ {
        .x$x$workflow <- AssignLabelsJS(.x, workflowid, dfMetaWorkflow)
        return(.x)
      })

      # overwrite the JS charts with updated charts
      .x$lResults$lCharts[grep("JS", names(.x$lResults$lCharts))] <- js_charts_updated


      # modify {ggplot2} charts -------------------------------------------------

      # use the inverse `grep()` as above to select all plots that do not have "JS" in them
      ggplot2_charts <- .x$lResults$lCharts[!names(.x$lResults$lCharts) %in% names(js_charts)]

      # loop over ggplot2 charts and update the labels directly
      # TODO: confirm these are the intended labels and modify accordingly
      ggplot2_charts_updated <- purrr::map(ggplot2_charts, ~ {
        required_labels <- SubsetMetaWorkflow(dfMetaWorkflow, workflowid)

        .x$labels$y <- glue::glue("{required_labels$numerator} ({required_labels$outcome})")
        .x$labels$x <- glue::glue("{required_labels$group}: {required_labels$denominator}")
        .x$labels$title <- glue::glue("{required_labels$metric} by {required_labels$group}")
        .x$labels$subtitle <- glue::glue("Workflow: {required_labels$workflowid}")
        return(.x)
      })

      # overwrite the ggplot2 charts with updated charts
      .x$lResults$lCharts[!names(.x$lResults$lCharts) %in% names(js_charts)] <- ggplot2_charts_updated


      return(.x)
    })
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
