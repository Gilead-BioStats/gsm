#' Check if workflow is valid/contains necessary metadata.
#'
#' @param lWorkflow `list` of workflows to be run in `Study_Assess()` or `Make_Snapshot()`.
#'
#'
#' @examples
#' workflow <- MakeWorkflowList()
#'
#' @return `list` with TRUE/FALSE status for each workflow.
#'
#' @importFrom purrr map list_flatten flatten_lgl
#'
#' @export
is_workflow_valid <- function(lWorkflow) {
  purrr::map(lWorkflow, function(workflow) {

    checks <- list(
      workflow_is_list = is.list(workflow),
      workflow_has_steps = "steps" %in% names(workflow)
    )

    if (checks$workflow_has_steps) {

      checks$steps_are_valid <- purrr::map(workflow$steps, function(step) {

        list(
          step$name %in% getNamespaceExports("gsm"),
          exists("inputs", where = step),
          exists("output", where = step)
        )
      })

    }


    if (exists("steps_are_valid", checks)) {
      checks$steps_are_valid <- checks$steps_are_valid %>%
        purrr::list_flatten() %>%
        purrr::flatten_lgl() %>%
        all()
    } else {
      checks$steps_are_valid <- FALSE
    }

    checks <- checks %>%
      purrr::flatten_lgl() %>%
      all()

    return(checks)

  })
}
