#' Parse warnings from the result of [gsm::Study_Assess()].
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' `ParseWarnings` is used inside of [gsm::Make_Snapshot()] to summarize any issues with data needed to run a KRI or QTL. If there are any warnings for any
#' workflow run via `Make_Snapshot()`, they are appended to the `notes` column in the  `status_workflow` data.frame, which is included in the output
#' of `Make_Snapshot()`. If there are no warnings, the `notes` column contains `NA` for all KRIs/QTLs.
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#'
#' @examples
#' # Set all subjid to NA to create warnings
#'
#' \dontrun{
#' lData <- list(
#'   dfAE = clindata::rawplus_ae %>%
#'     dplyr::mutate(subjid = NA),
#'   dfSUBJ = clindata::rawplus_dm
#' )
#'
#' study <- Study_Assess(lData = lData)
#'
#' warnings <- ParseWarnings(study)
#' }
#'
#' @return `data.frame` With columns `workflowid`, `status`, and `notes`.
#'
#' @export
ParseWarnings <- function(lResults) {
  # lChecks
  overall_standard <- lResults %>%
    purrr::imap(function(x, y) {
      tibble(overall_status = x$bStatus, workflowid = y)
    }) %>%
    purrr::list_rbind()

  standard <- lResults %>%
    purrr::map(function(kri) {
      kri$lChecks %>%
        purrr::imap(function(workflow, workflow_name) {
          data_checks <- names(workflow)[grep("df", names(workflow))]
          purrr::map(data_checks, function(this_data) {
            purrr::map_df(workflow[[this_data]]$tests_if, function(x) {
              dplyr::tibble(status = x$status, warning = x$warning)
            })
          })
        })
    }) %>%
    purrr::imap(function(data, index) {
      if (length(data) > 0) {
        dplyr::bind_rows(unname(data), .id = index) %>%
          dplyr::pull(warning) %>%
          purrr::discard(is.na) %>%
          paste(collapse = "\n")
      }
    }) %>%
    purrr::imap_dfr(function(x, y) {
      dplyr::tibble(notes = x, workflowid = y)
    }) %>%
    mutate(
      notes = ifelse(is.na(.data$notes), "", .data$notes)
    ) %>%
    left_join(overall_standard, by = "workflowid")


  # get overall workflow status ---------------------------------------------
  workflow <- lResults %>%
    purrr::map(function(checks) {
      checks$lWorkflowChecks
    })

  workflow_overall <-
    workflow %>%
    purrr::imap(function(x, y) {
      tibble(
        workflowid = y,
        workflow_overall_status = x$bStatus
      )
    }) %>%
    purrr::list_rbind()


  # get workflow dimensions check -------------------------------------------
  workflow_dimensions <- workflow %>%
    purrr::map(function(x) {
      list(
        workflow_is_list = x$workflow_is_list,
        workflow_has_steps = x$workflow_has_steps
      )
    }) %>%
    purrr::imap(function(x, y) {
      x %>%
        purrr::imap(function(data, nm) {
          tibble(
            workflowid = y,
            check = nm,
            status = data$status,
            notes = data$message
          )
        })
    }) %>%
    purrr::map(function(x) {
      x %>% purrr::list_rbind()
    }) %>%
    purrr::list_rbind()

  # get each step of workflow check -----------------------------------------
  workflow_steps_overall <- workflow %>%
    purrr::imap(function(x, y) {
      overall <- x$steps_are_valid

      tibble(
        workflowid = y,
        status = overall$status,
        notes = overall$message
      )
    }) %>%
    purrr::list_rbind() %>%
    mutate(
      check_name = "overall",
      step = 0
    )

  workflow_steps <- workflow %>%
    purrr::imap(function(x, y) {
      x$steps_are_valid %>%
        purrr::map(function(step) {
          if (is.list(step)) {
            step %>%
              purrr::imap(function(check, check_name) {
                tibble(workflowid = y, check_name, status = check$status, notes = check$message)
              })
          }
        })
    }) %>%
    purrr::map(function(x) {
      x %>% purrr::discard(is.null)
    }) %>%
    purrr::compact() %>%
    purrr::map(function(x) {
      x %>%
        purrr::imap(function(x, y) {
          bind_rows(x)
        })
    }) %>%
    purrr::imap(function(x, y) {
      bind_rows(stats::setNames(x, seq_along(x)), .id = "step") %>%
        mutate(
          step = as.numeric(.data$step)
        )
    }) %>%
    purrr::list_rbind() %>%
    bind_rows(
      workflow_steps_overall
    )

  # consolidate notes to single row -----------------------------------------
  steps <- workflow_steps %>%
    group_split(.data$workflowid) %>%
    purrr::map(function(x) {
      overall <- x %>%
        filter(.data$check_name == "overall") %>%
        pull(.data$status)

      if (overall) {
        tibble(workflowid = unique(x$workflowid), workflow_steps_status = TRUE, workflow_steps_notes = "")
      } else {
        notes <- x %>%
          filter(.data$status == FALSE) %>%
          pull(.data$notes)
        notes <- paste(notes, collapse = ", ")
        tibble(workflowid = unique(x$workflowid), workflow_steps_status = FALSE, workflow_steps_notes = notes)
      }
    }) %>%
    purrr::list_rbind()


  # consolidate dimensions to single row ------------------------------------
  dimensions <- workflow_dimensions %>%
    group_split(.data$workflowid) %>%
    purrr::map(function(x) {
      if (all(x$status)) {
        tibble(workflowid = unique(x$workflowid), workflow_dimensions_status = TRUE, workflow_dimensions_notes = "")
      } else {
        notes <- x %>%
          filter(.data$status == FALSE) %>%
          pull(notes)
        notes <- paste(notes, collapse = ", ")
        tibble(workflowid = unique(x$workflowid), workflow_dimensions_status = FALSE, workflow_dimensions_notes = notes)
      }
    }) %>%
    purrr::list_rbind()


  all_workflow <- purrr::reduce(list(workflow_overall, steps, dimensions), left_join, by = "workflowid")

  warnings <- left_join(standard, all_workflow, by = "workflowid") %>%
    select("workflowid", ends_with("status"), ends_with("notes"))

  warnings <- warnings %>%
    rowwise() %>%
    mutate(
      status = all(c(.data$overall_status, .data$workflow_overall_status, .data$workflow_steps_status, .data$workflow_dimensions_status))
    ) %>%
    ungroup() %>%
    mutate(across(c("notes", "workflow_steps_notes", "workflow_dimensions_notes"), function(x) ifelse(x == "", NA, x))) %>%
    tidyr::unite("notes", c("notes", "workflow_steps_notes", "workflow_dimensions_notes"), na.rm = TRUE, sep = ", ") %>%
    select(
      "workflowid",
      "status",
      "notes"
    )

  return(warnings)
}
