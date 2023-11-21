#' MakeKRICharts Function
#'
#' The function MakeKRICharts creates three different types of charts (scatter plot and two bar charts) using the gsm package. It takes two inputs: lData and dfConfig, and returns a list of the created charts.
#'
#' @param lData A list containing two data frames - dfSummary and dfBounds.
#' @param dfConfig A data frame containing configuration information for the charts.
#'
#' @return A list (lCharts) containing three charts - scatterJS, barMetricJS, and barScoreJS.
#'
#'
#' @import gsm
#'
#' @export
MakeKRICharts <- function(lData = NULL, dfConfig = NULL) {
    lCharts <- list()

    lCharts$scatterJS <- gsm::Widget_ScatterPlot(
        results = lData$dfSummary,
        workflow = dfConfig,
        bounds = lData$dfBounds,
        elementId = paste0(tolower(dfConfig$abbreviation), "AssessScatter"),
        siteSelectLabelValue = dfConfig$group
    )

    lCharts$barMetricJS <- gsm::Widget_BarChart(
        results = lData$dfSummary,
        workflow = dfConfig,
        yaxis = "metric",
        elementId = paste0(tolower(dfConfig$abbreviation), "AssessMetric"),
        siteSelectLabel = dfConfig$group
    )

    lCharts$barScoreJS <- gsm::Widget_BarChart(
        results = lData$dfSummary,
        workflow = dfConfig,
        yaxis = "score",
        elementId = paste0(tolower(dfConfig$abbreviation), "AssessScore"),
        siteSelectLabelValue = dfConfig$group
    )

    return(lCharts)
}
