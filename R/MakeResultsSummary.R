function(lResults, dfConfigWorkflow) {
  results_summary <- purrr::map(lResults, ~ .x[["lResults"]]) %>%
    purrr::discard(~ is.null(.x)) %>%
    purrr::discard(~ .x$lChecks$status ==
      FALSE) %>%
    purrr::imap_dfr(~ .x$lData$dfSummary %>% mutate(
      KRIID = .y,
      StudyID = unique(dfConfigWorkflow$studyid)
    )) %>%
    select(
      studyid = "StudyID",
      workflowid = "KRIID", groupid = "GroupID", numerator = "Numerator",
      denominator = "Denominator", metric = "Metric", score = "Score",
      flag = "Flag"
    )
  return(results_summary)
}
