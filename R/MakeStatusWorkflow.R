function(lResults, dfConfigWorkflow) {
  workflow_parse_status <- purrr::imap(lResults, function(status,
                                                          workflowid) {
    tibble(status = status$bStatus, workflowid = workflowid)
  }) %>% bind_rows()
  workflow_parse_warnings <- ParseWarnings(lResults)
  status_workflow <- dfConfigWorkflow %>%
    full_join(workflow_parse_status,
      by = "workflowid"
    ) %>%
    mutate(status = ifelse(is.na(.data$status),
      FALSE, .data$status
    )) %>%
    left_join(workflow_parse_warnings,
      by = c("workflowid", "status")
    )
  return(status_workflow)
}
