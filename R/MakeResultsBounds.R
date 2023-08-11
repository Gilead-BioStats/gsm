#' Make `results_bounds`
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#' @param dfConfigWorkflow `data.frame` Workflow configuration data.
#'
#' @return `data.frame` Containing stacked results from `dfBounds`.
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' results_bounds <- MakeResultsBounds(lResults = study, dfConfigWorkflow = gsm::config_workflow)
#' }
#'
#' @importFrom purrr discard imap_dfr map
#'
#' @export
MakeResultsBounds <- function(lResults, dfConfigWorkflow) {
  # extract dfBounds data.frame ---------------------------------------------
  # -- discard `dfBounds` if it is NULL
  results_bounds <- lResults %>%
    purrr::map(~ .x$lResults$lData$dfBounds) %>%
    purrr::discard(is.null)


  if (length(results_bounds) > 0) {
    results_bounds <- results_bounds %>%
      purrr::imap_dfr(~ .x %>% mutate(workflowid = .y)) %>%
      mutate(studyid = unique(dfConfigWorkflow$studyid)) %>%
      select(
        "studyid",
        "workflowid",
        "threshold" = "Threshold",
        "numerator" = "Numerator",
        "denominator" = "Denominator",
        "log_denominator" = "LogDenominator"
      )
  } else {
    results_bounds <- results_bounds %>%
      as_tibble()
  }

  return(results_bounds)
}
