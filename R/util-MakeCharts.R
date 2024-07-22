#' Helper function to create charts for multiple metrics
#'
#' @inheritParams shared-params
#' @param dfBounds A data frame with the bounds of the simulation.
#' @param dfGroups A data frame with the groups of the simulation.
#'
#' @return A list of charts for each metric.
#'
#' @export

MakeCharts <- function(dfResults, dfBounds, dfGroups, dfMetrics) {
  metrics <- unique(dfMetrics$MetricID)
  charts <- metrics %>%
    purrr::map(~ Visualize_Metric(
      dfResults = dfResults,
      dfBounds = dfBounds,
      dfGroups = dfGroups,
      dfMetrics = dfMetrics,
      strMetricID = .x
    )) %>%
    stats::setNames(metrics)
  return(charts)
}
