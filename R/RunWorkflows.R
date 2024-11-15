#' Convenience function to easily run multiple workflows
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function takes a list of workflows and a list of data as input.  It runs each workflow and returns the
#' results as a named list where the names of the list correspond to the workflow ID ($meta$ID).
#'
#' Workflows are run in the order they are provided in the lWorkflows. The results from each workflow are passed as inputs (along with lData) for later workflows.
#'
#' @param lWorkflows `list` A named list of metadata defining how the workflow should be run.
#' @param lData `list` A named list of domain-level data frames.
#' @param bReturnResult `boolean` should *only* the result from the last step (`lResults`) be returned? If false, the full workflow (including `lResults`) is returned. Default is `TRUE`.
#' @param bKeepInputData `boolean` should the input data be included in `lData` after the workflow is run? Only relevant when bReturnResult is FALSE. Default is `TRUE`.
#' @param strResultNames `string` vector of length two, which describes the meta fields used to name the output.
#'
#' @return A named list of results from `RunWorkflow()`, where the names correspond to the names of
#' the workflow ID

#'
#' @export

RunWorkflows <- function(
    lWorkflows,
    lData = NULL,
    bKeepInputData = FALSE,
    bReturnResult = TRUE,
    strResultNames = c("Type", "ID")
) {
  LogMessage("info", "h1", "Running {length(lWorkflows)} Workflows")

  lResults <- list()
  for (wf in lWorkflows) {
    lResult <- RunWorkflow(
      lWorkflow = wf,
      lData = c(lResults, lData),
      bReturnResult = bReturnResult,
      bKeepInputData = bKeepInputData
    )

    resultName <- strResultNames %>%
      map(function(name) {
        return(wf$meta[[name]])
      }) %>%
      paste0(collapse = "_")

    lResults[[resultName]] <- lResult
  }

  return(lResults)
}
