#' Helper function to create charts for multiple metrics
#'
#' `r lifecycle::badge("stable")`
#'
#' @inheritParams shared-params
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
