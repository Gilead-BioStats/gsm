#' Calculate Bounds for display in scatterplots
#'
#' Used to calculate bounds across a set of metrics/
#'
#' @param dfMetrics Metric metadata including thresholds and analysis type.
#' @param dfResults Results data.
#' @param strMetrics Character vector of `MetricID`s to include in `dfBounds`.
#'   All unique values from `dfResults$MetricID` used by default.
#'
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
  strMetrics = unique(dfResults$MetricID)
) {
  if (is.null(strMetrics)) {
    strMetrics <- unique(dfResults$MetricID)
  }

  dfBounds <- strMetrics %>%
    purrr::map(function(strMetric) {
      dfResult <- dplyr::filter(dfResults, .data$MetricID == strMetric)
      lMetric <- dfMetrics %>%
        dplyr::filter(.data$MetricID == strMetric) %>%
        as.list()

      vThreshold <- ParseThreshold(strThreshold = lMetric$strThreshold)
      dfBounds <- Analyze_NormalApprox_PredictBounds(
        dfResults,
        strType = lMetric$Type %||% "binary",
        vThreshold = vThreshold
      )

      return(dfBounds)
    }) %>%
    purrr::list_rbind()

  return(dfBounds)
}
