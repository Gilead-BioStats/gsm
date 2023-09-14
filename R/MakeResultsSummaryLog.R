#' `r lifecycle::badge("stable")`
#'
#' Make `results_summary_log`
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#'
#' @return `data.frame` Stacked results (a la `dplyr::bind_rows()`) of the `dfSummary` data.frames, from the
#' output of [gsm::Study_Assess()]
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' results_summary <- MakeResultsSummaryLog(study, gsm::config_workflow)
#' }
#'
#' @importFrom purrr discard imap_dfr map
#'
#' @export
MakeResultsSummaryLog <- function(lResults) {
  results_summary <- purrr::map(lResults, ~ .x[["lResults"]]) %>%
    purrr::discard(~ is.null(.x)) %>%
    purrr::discard(~ .x$lChecks$status == FALSE) %>%
    purrr::imap_dfr(~ .x$lData$dfSummary %>%
      mutate(
        KRIID = .y
      )) %>%
    select(
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
