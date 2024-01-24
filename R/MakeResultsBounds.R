function(lResults, dfConfigWorkflow) {
  results_bounds <- lResults %>%
    purrr::map(~ .x$lResults$lData$dfBounds) %>%
    purrr::discard(is.null)
  if (length(results_bounds) > 0) {
    results_bounds <- results_bounds %>%
      purrr::imap_dfr(~ .x %>%
        mutate(workflowid = .y)) %>%
      mutate(studyid = unique(dfConfigWorkflow$studyid)) %>%
      select("studyid", "workflowid",
        threshold = "Threshold",
        numerator = "Numerator", denominator = "Denominator",
        log_denominator = "LogDenominator"
      )
  } else {
    results_bounds <- results_bounds %>% as_tibble()
  }
  return(results_bounds)
}
