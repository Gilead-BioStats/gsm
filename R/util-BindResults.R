#' Helper function to bind results from multiple workflows
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Used to stack results (e.g. `dfSummary`) from a list of analysis pipeline
#' output formatted like the result of `RunWorkflows()`. Also adds study level
#' metadata when provided.
#'
#' @param lResults Named List of analysis results in the format returned by
#'   [RunWorkflows()].
#' @param strName Name of the object to stack. Pulled from `lResults` (or from
#'   `lResults$lData` when `bUselData` is `TRUE`).
#' @param dSnapshotDate Date of the snapshot. Default is [Sys.Date()].
#' @param strStudyID Study ID.
#' @param bUselData Should the function bind results from an `lData` object (or
#'   look directly in the root elements of `lResults`)? Default is `FALSE.`
#'
#' @return A data frame.
#'
#' @export

BindResults <- function(
  lResults,
  strName,
  dSnapshotDate = Sys.Date(),
  strStudyID,
  bUselData = FALSE
) {
  dfResults <- lResults %>%
    purrr::imap(
      function(result, metric) {
        if (bUselData) {
          subResult <- result$lData[[strName]]
        } else {
          subResult <- result[[strName]]
        }
        return(subResult %>% dplyr::mutate(MetricID = metric))
      }
    ) %>%
    purrr::list_rbind() %>%
    dplyr::mutate(
      SnapshotDate = dSnapshotDate,
      StudyID = strStudyID
    )
  return(dfResults)
}
