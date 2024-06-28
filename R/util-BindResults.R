#' Helper function to bind results from multiple workflows
#' 
#' Used to stack results (e.g. dfSummary) from a list of analysis pipeline output formatted like the result of RunWorklows(). Also adds study level metadata when provided. 
#'
#' @param lResults List of results in the format returned by RunWorkflows()
#' @param strName Name of the object to stack. Pulled from lResults$lData.
#' @param lColValues List of column names/values to add to all rows in the final data frame. e.g. l(SnapshotDate = sys.date(), StudyID = "ABC-123"),  Default is NULL.
#' 
#' @return A data frame.
#'
#'
#' @export
#' 

BindResults <- function(lResults, strName, lColValues = NULL){
  dfResults <- lResults %>% imap_dfr(
    ~.x$lData[[strName]] %>% mutate(MetricID = .y)
  ) 

  for(i in 1:length(lColValues)){
    dfResults <- dfResults %>% mutate(!!names(lColValues)[i] := lColValues[[i]])
  }

  return(dfResults)
}