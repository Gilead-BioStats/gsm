#' `r lifecycle::badge("stable")`
#'
#' Check if workflow is valid/contains necessary metadata.
#'
#' @param lWorkflow `list` A named list of metadata defining how the workflow should be run.
#'
#'
#' @examples
#' workflow <- MakeWorkflowList()
#'
#' # check a single workflow
#' valid_workflow <- is_workflow_valid(workflow[[2]])
#'
#' # check all workflows
#' library(dplyr)
#' library(purrr)
#' valid_workflow_all <- workflow %>%
#'   purrr::map(~is_workflow_valid(.) %>% purrr::pluck('bStatus'))
#'
#' @return `list` with `TRUE`/`FALSE` status for each workflow.
#'
#' @import purrr
#'
#' @export
is_workflow_valid <- function(lWorkflow) {
  checks <- list(
    workflow_is_list = workflow_is_list(lWorkflow),
    workflow_has_steps = workflow_has_steps(lWorkflow)
  )


  if (checks$workflow_has_steps$status) {
    checks$steps_are_valid <- steps_are_valid(lWorkflow)
  }

  if (exists("steps_are_valid", checks)) {
    check_all_steps <- purrr::imap_dfr(checks$steps_are_valid, function(step, index) {
      step_status <- tibble(
        n_step = index,
        status = all(purrr::map_lgl(step, function(x) x$status)),
        message = purrr::map_chr(step, function(x) x$message)
      )

      return(step_status)
    })

    if (all(check_all_steps$status)) {
      checks$steps_are_valid$status <- TRUE
    } else {
      checks$steps_are_valid$status <- FALSE
      msg <- check_all_steps %>%
        filter(.data$status == F & .data$message != "") %>%
        mutate(x = paste0("Issue at step ", .data$n_step, ": ", .data$message)) %>%
        pull(.data$x)
      checks$steps_are_valid$message <- paste(msg, collapse = ", ") # make message indicate step/index that error occurred at.
    }
  } else {
    checks$steps_are_valid$status <- FALSE
    checks$steps_are_valid$message <- "Steps not found in workflow."
  }

  checks$bStatus <- all(purrr::map_lgl(checks, function(x) x$status))

  return(checks)
}


workflow_is_list <- function(lWorkflow) {
  status <- is.list(lWorkflow)
  message <- ifelse(status, "", paste0("lWorkflow is of type ", class(lWorkflow), " and not a list."))

  return(
    list(status = status, message = message)
  )
}

workflow_has_steps <- function(lWorkflow) {
  status <- "steps" %in% names(lWorkflow) && length(lWorkflow$steps) > 0
  message <- ifelse(status, "", "'steps' object not found in lWorkflow")

  return(
    list(status = status, message = message)
  )
}


steps_are_valid <- function(lWorkflow) {
  check <- purrr::map(lWorkflow$steps, function(step) {
    status_function_is_valid <- exists("name", step) && step$name %in% getNamespaceExports("gsm")
    status_input_is_valid <- exists("inputs", where = step)
    status_output_is_valid <- exists("output", where = step)

    message_function_is_valid <- ifelse(status_function_is_valid, "", "Function not found in list of {gsm} functions")
    message_input_is_valid <- ifelse(status_input_is_valid, "", "Input(s) not found.")
    message_output_is_valid <- ifelse(status_output_is_valid, "", "Output(s) not found")

    return(
      list(
        function_is_valid = list(status = status_function_is_valid, message = message_function_is_valid),
        input_is_valid = list(status = status_input_is_valid, message = message_input_is_valid),
        output_is_valid = list(status = status_output_is_valid, message = message_output_is_valid)
      )
    )
  })

  return(check)
}
