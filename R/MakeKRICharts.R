#' MakeKRICharts Function
#'
#' The function MakeKRICharts creates three different types of charts (scatter plot and two bar charts) using the gsm package. It takes two inputs: lData and dfConfig, and returns a list of the created charts.
#'
#' @param lData A list containing two data frames - dfSummary and dfBounds.
#'
#' @return A list (lCharts) containing three charts - scatterJS, barMetricJS, and barScoreJS.
#'
#'
#' @export
MakeKRICharts <- function(lData = NULL) {
    lCharts <- list()

    if (tolower(lData$dfConfig$model) != "identity") {
        lCharts$scatterJS <- gsm::Widget_ScatterPlot(
            results = lData$dfSummary,
            workflow = lData$dfConfig,
            bounds = lData$dfBounds,
            elementId = paste0(tolower(lData$dfConfig$abbreviation), "AssessScatter"),
            siteSelectLabelValue = lData$dfConfig$group
        )

        lCharts$scatter <- gsm::Visualize_Scatter(
            dfSummary = lData$dfSummary,
            dfBounds = lData$dfBounds,
            strGroupLabel = lData$dfConfig$group
        )
    }

    lCharts$barMetricJS <- gsm::Widget_BarChart(
        results = lData$dfSummary,
        workflow = lData$dfConfig,
        yaxis = "metric",
        elementId = paste0(tolower(lData$dfConfig$abbreviation), "AssessMetric"),
        siteSelectLabel = lData$dfConfig$group
    )

    lCharts$barScoreJS <- gsm::Widget_BarChart(
        results = lData$dfSummary,
        workflow = lData$dfConfig,
        yaxis = "score",
        elementId = paste0(tolower(lData$dfConfig$abbreviation), "AssessScore"),
        siteSelectLabelValue = lData$dfConfig$group
    )

    lCharts$barMetric <- gsm::Visualize_Score(
        dfSummary = lData$dfSummary,
        strType = "metric"
    )

    lCharts$barScore <- gsm::Visualize_Score(
        dfSummary = lData$dfSummary,
        strType = "score",
        vThreshold = unlist(lData$dfConfig$thresholds)
    )


    return(lCharts)
}
