#' Helper function create charts for multiple metrics
#'
#' @param data The input data frame.
#' @param strGroupLevel A string specifying the group type.
#' @param strGroupCols A string specifying the group columns.
#'
#' @return A long format data frame.
#'
#' @examples
#' df <- data.frame(GroupID = c(1, 2, 3), Param1 = c(10, 20, 30), Param2 = c(100, 200, 300))
#' MakeLongMeta(df, "GroupID")
#'
#' @export

MakeCharts <- function(dfSummary, dfBounds, dfGroups, dfMetrics){
    metrics<- unique(dfMetrics$MetricID)
    charts <- metrics %>% map(~Visualize_Metric(
        dfSummary = dfSummary_long,
        dfBounds = dfBounds,
        dfGroups = dfGroups,
        dfMetrics = dfMetrics,
        strMetricID = .x
    )) %>% setNames(metrics)

    return(charts)
}
