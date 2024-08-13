#' Helper function to create charts for multiple metrics
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' @inheritParams shared-params
#'
#' @return A list of charts for each metric.
#'
#' @export

MakeCharts <- function(dfResults, dfBounds, dfGroups, dfMetrics, bDebug = FALSE) {
  metrics <- unique(dfMetrics$MetricID)
  charts <- metrics %>%
    purrr::map(~ Visualize_Metric(
      dfResults = dfResults,
      dfBounds = dfBounds,
      dfGroups = dfGroups,
      dfMetrics = dfMetrics,
      strMetricID = .x,
      bDebug = bDebug
    )) %>%
    stats::setNames(metrics)
  return(charts)
}
