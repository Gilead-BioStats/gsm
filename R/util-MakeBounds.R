#' Calculate Bounds for display in scatterplots
#'
#' Used to calculate bounds across a set of metrics/
#'
#' @param dfMetrics Metric metadata including thresholds and analysis type.
#' @param dfResults Results data.
#' @param strMetrics Character vector of `MetricID`s to include in `dfBounds`.
#'   All unique values from `dfResults$MetricID` used by default.
#' @param dSnapshotDate Snapshot date. Uses dfResults$SnapshotDate by default. If more than one snapshot date is found in dfResults, an error is thrown. 
#' @param dStudyID Study ID. Uses dfResults$StudyID by default. If more than one snapshot date is found in dfResults, an error is thrown. 
#' @return A data frame.
#'
#' @examples
#' dfBounds <- MakeBounds(
#'   dfResults = reportingResults, dfMetrics = reportingMetrics
#' )
#'
#' @export

MakeBounds <- function(
  dfResults,
  dfMetrics,
  strMetrics = unique(dfResults$MetricID),
  dSnapshotDate = unique(dfResults$SnapshotDate),
  strStudyID = unique(dfResults$StudyID) 
) {
  cli_alert_info("Creating stacked dfBounds data for {strMetrics}")

  if(length(dSnapshotDate) != 1){
    cli_error("More than one Snapshot Date found. Returning NULL")
    return(NULL)
  }

  if(length(strStudyID) != 1){
    cli_error("More than one StudyID found. Return NULL")
    return(NULL)
  }

  dfBounds <- strMetrics %>%
    purrr::map(function(strMetric) {
      dfResult <- dplyr::filter(dfResults, .data$MetricID == strMetric)
      lMetric <- dfMetrics %>%
        dplyr::filter(.data$MetricID == strMetric) %>%
        as.list()

      vThreshold <- ParseThreshold(strThreshold = lMetric$strThreshold)
      dfBounds <- Analyze_NormalApprox_PredictBounds(
        dfResult,
        strType = lMetric$Type %||% "binary",
        vThreshold = vThreshold
      ) %>% 
      mutate(MetricID = strMetric) %>%
      mutate(StudyID = strStudyID) %>%
      mutate(SnapshotDate = dSnapshotDate)
      
      return(dfBounds)
    }) %>%
    purrr::list_rbind()

  return(dfBounds)
}
