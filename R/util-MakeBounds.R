#' Calculate Bounds for display in scatterplots
#'
#' Used to calculate bounds for across a set of metrics
#'
#' @param dfMetrics Metric metadata including thresholds and analysis type
#' @param dfResults Results data
#' @param strMetrics list of MetricIDs to include in dfBounds. All unique values from dfResults$MetricID used by default.
#'
#' @return A data frame.
#'
#' @examples
#' dfBounds <- MakeBounds(dfResults=gsm::reportingResults, dfMetrics=gsm::reportingMetrics)
#'
#' @export

MakeBounds <- function(dfResults, dfMetrics, strMetrics = NULL){
  
  if(is.null(strMetrics)){
    strMetrics <- unique(dfResults$MetricID)
  }  

  dfBounds <- strMetrics %>% map(function(MetricID){
    dfResult <- dfResults %>% filter(MetricID = MetricID)
    lMetric <- dfMetrics %>% filter(MetricID == MetricID) %>% as.list

    vThreshold <- ParseThreshold(strThreshold = lMetric$strThreshold)
    dfBounds <- Analyze_NormalApprox_PredictBounds(dfResults, strType = lMetric$Type, vThreshold = vThreshold )

    return(dfBounds)
  })%>%
  list_rbind

  return(dfBounds)
}
