#' Parse meta data from workflows to a data frame
#'
#' Used to format metric metadata (dfMetrics) for use in charts and reports. This function takes a list of workflows and returns a data frame with one row per MetricID.
#'
#' @param lWorkflows A list of workflows, like the one returned by MakeWorkflowList().
#'
#' @return A data frame.
#'
#' @examples
#' lWorkflows <- MakeWorkflowList(strNames = "kri")
#' dfMetrics <- MakeMetricInfo(lWorkflows)
#'
#' @export

MakeMetric <- function(lWorkflows){
   dfMetrics <- lWorkflows %>% map_df(function(wf){
    return(wf$meta)
  })
  return(dfMetrics)
}
