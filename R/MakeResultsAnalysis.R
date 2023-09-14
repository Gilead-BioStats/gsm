#' `r lifecycle::badge("stable")`
#'
#' Make `results_analysis_log`
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#'
#' @return `data.frame` QTL results stacked data from [gsm::Study_Assess()]
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' results_analysis <- MakeResultsAnalysisLog(study)
#' }
#'
#' @importFrom purrr imap_dfr
#' @importFrom tidyr pivot_longer
#'
#' @export
MakeResultsAnalysisLog <- function(lResults) {
  results_analysis <- purrr::imap_dfr(lResults[grep("qtl", names(lResults))], function(qtl, qtl_name) {
    if (qtl$bStatus) {
      qtl$lResults$lData$dfAnalyzed %>%
        select(
          "GroupID",
          "LowCI",
          "Estimate",
          "UpCI",
          "Score"
        ) %>%
        mutate(workflowid = qtl_name) %>%
        tidyr::pivot_longer(-c("GroupID", "workflowid")) %>%
        rename(
          param = "name",
          studyid = "GroupID"
        )
    }
  })

  if (nrow(results_analysis) > 0) {
    return(results_analysis)
  } else {
    return(
      dplyr::tibble(
        studyid = character(),
        workflowid = character(),
        param = character(),
        value = double()
      )
    )
  }
}
