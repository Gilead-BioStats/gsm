#' Make `results_summary`
#'
#' `r lifecycle::badge("stable")`
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#' @param dfConfigWorkflow `data.frame` Workflow configuration data.
#'
#' @return `data.frame` Stacked results (a la `dplyr::bind_rows()`) of the `dfSummary` data.frames, from the
#' output of [gsm::Study_Assess()]
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' results_summary <- MakeResultsSummary(study, gsm::config_workflow)
#' }
#'
#' @importFrom purrr discard imap_dfr map
#'
#' @export
MakeResultsSummary <- function(lResults, dfConfigWorkflow) {
  results_summary <- purrr::map(lResults, ~ .x[["lResults"]]) %>%
    purrr::discard(~ is.null(.x)) %>%
    purrr::discard(~ .x$lChecks$status == FALSE) %>%
    purrr::imap_dfr(~ .x$lData$dfSummary %>%
      mutate(
        KRIID = .y,
        StudyID = unique(dfConfigWorkflow$studyid)
      )) %>%
    select(
      studyid = "StudyID",
      workflowid = "KRIID",
      groupid = "GroupID",
      numerator = "Numerator",
      denominator = "Denominator",
      metric = "Metric",
      score = "Score",
      flag = "Flag"
    )

  return(results_summary)
}
