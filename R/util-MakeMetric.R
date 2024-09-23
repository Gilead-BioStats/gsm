#' Parse metadata from workflows to a data frame
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Used to format metric metadata (`dfMetrics`) for use in charts and reports.
#' This function takes a list of workflows and returns a data frame with one row
#' per `MetricID`.
#'
#' @param lWorkflows A list of workflows, like the one returned by
#'   [MakeWorkflowList()].
#'
#' @return A data frame.
#'
#' @examples
#' lWorkflows <- MakeWorkflowList(strPath = "workflow/2_metrics", strNames = "kri")
#' dfMetrics <- MakeMetric(lWorkflows)
#'
#' @export
MakeMetric <- function(lWorkflows) {
  #check to make sure Type and ID exist for naming
    missing_types <- which(sapply(lWorkflows, function(x) is.null(x$meta$Type))) %>% names()
    missing_ids <- which(sapply(lWorkflows, function(x) is.null(x$meta$ID))) %>% names()
    if (length(missing_types > 0)) {
      stop(glue::glue("The following workflows are missing the 'Type' field in `meta`: {missing_types}"))
    }
    if (length(missing_ids > 0)) {
      stop(glue::glue("The following workflows are missing the 'ID' field in `meta`: {missing_ids}"))
    }
  dfMetrics <- lWorkflows %>%
    purrr::map(function(wf) {
      return(tibble::as_tibble(wf$meta))
    }) %>%
    purrr::list_rbind() %>%
    mutate(MetricID = paste0(Type,"_",ID))
  return(dfMetrics)
}
