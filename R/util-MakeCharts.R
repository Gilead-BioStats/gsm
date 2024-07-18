#' Helper function create charts for multiple metrics
#'
#' @inheritParams shared-params
#' @param dfBounds A data frame with the bounds of the simulation.
#' @param dfGroups A data frame with the groups of the simulation.
#'
#' @return A list of charts for each metric.
#
#'
#' @export

MakeCharts <- function(dfResults, dfBounds, dfGroups, dfMetrics){
    metrics<- unique(dfMetrics$MetricID)
    charts <- metrics %>% map(~Visualize_Metric(
        dfResults = dfResults,
        dfBounds = dfBounds,
        dfGroups = dfGroups,
        dfMetrics = dfMetrics,
        strMetricID = .x
    )) %>% setNames(metrics)

    return(charts)
}
