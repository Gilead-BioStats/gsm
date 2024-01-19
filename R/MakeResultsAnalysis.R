#' Make `results_analysis`
#'
#' `r lifecycle::badge("stable")`
#'
#' @param lResults `list` List returned from [gsm::Study_Assess()].
#'
#' @return `data.frame` QTL results stacked data from [gsm::Study_Assess()]
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' results_analysis <- MakeResultsAnalysis(study)
#' }
#'
#' @export
MakeResultsAnalysis <- function(lResults) {
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

  return(results_analysis)
}
