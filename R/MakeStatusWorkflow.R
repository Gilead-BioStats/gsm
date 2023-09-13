#' `r lifecycle::badge("stable")`
#'
#' Make `status_workflow`
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#' @param dfConfigWorkflow `data.frame` Workflow configuration data.
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' status_workflow <- MakeStatusWorkflow(
#'   lResults = study,
#'   dfConfigWorkflow = gsm::config_workflow
#' )
#' }
#'
#' @return `data.frame` with columns `studyid`, `workflowid`, `gsm_version`, `active`, `status`, and `notes`.
#'
#' @importFrom purrr imap
#'
#' @export
MakeStatusWorkflow <- function(lResults, dfConfigWorkflow) {
  # extract bStatus and create data.frame -----------------------------------
  workflow_parse_status <- purrr::imap(lResults, function(status, workflowid) {
    tibble(
      status = status$bStatus,
      workflowid = workflowid
    )
  }) %>%
    bind_rows()


  # extract warnings from results -------------------------------------------
  workflow_parse_warnings <- ParseWarnings(lResults)


  # combine extracted status and warnings -----------------------------------
  status_workflow <- dfConfigWorkflow %>%
    full_join(
      workflow_parse_status,
      by = "workflowid"
    ) %>%
    mutate(
      status = ifelse(
        is.na(.data$status),
        FALSE,
        .data$status
      )
    ) %>%
    left_join(
      workflow_parse_warnings,
      by = c("workflowid", "status")
    )


  return(status_workflow)
}
