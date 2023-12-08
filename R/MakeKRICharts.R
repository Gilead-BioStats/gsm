#' MakeKRICharts Function
#'
#' The function MakeKRICharts creates three different types of charts (scatter plot and two bar charts) using the gsm package. It takes two inputs: lData and dfConfig, and returns a list of the created charts.
#'
#' @param strWorkflowId `character` Name of workflow ID, e.g., 'kri0001'.
#' @param lData `list` A list containing two data frames - dfSummary and dfBounds.
#' @param lStackedSnapshots `list` A list returned by [gsm::Make_Snapshot()] containing flat files for snapshot/assessment data.
#' @param dfWorkflow `data.frame` Workflow metadata. See [gsm::meta_workflow].
#'
#' @return A list (lCharts) containing three charts - scatterJS, barMetricJS, and barScoreJS.
#'
#'
#' @export
MakeKRICharts <- function(strWorkflowId = NULL, lData = NULL, dfWorkflow = NULL, lStackedSnapshots = NULL) {

    lCharts <- list()

    if (tolower(dfWorkflow$model) != "identity") {
        lCharts$scatterJS <- gsm::Widget_ScatterPlot(
            results = lData$dfSummary,
            workflow = dfWorkflow,
            bounds = lData$dfBounds,
            elementId = paste0(tolower(dfWorkflow$abbreviation), "AssessScatter"),
            siteSelectLabelValue = dfWorkflow$group
        )

        lCharts$scatter <- gsm::Visualize_Scatter(
            dfSummary = lData$dfSummary,
            dfBounds = lData$dfBounds,
            strGroupLabel = dfWorkflow$group
        )
    }

    lCharts$barMetricJS <- gsm::Widget_BarChart(
        results = lData$dfSummary,
        workflow = dfWorkflow,
        yaxis = "metric",
        elementId = paste0(tolower(dfWorkflow$abbreviation), "AssessMetric"),
        siteSelectLabel = dfWorkflow$group
    )

    lCharts$barScoreJS <- gsm::Widget_BarChart(
        results = lData$dfSummary,
        workflow = dfWorkflow,
        yaxis = "score",
        elementId = paste0(tolower(dfWorkflow$abbreviation), "AssessScore"),
        siteSelectLabelValue = dfWorkflow$group
    )

    lCharts$barMetric <- gsm::Visualize_Score(
        dfSummary = lData$dfSummary,
        strType = "metric"
    )

    lCharts$barScore <- gsm::Visualize_Score(
        dfSummary = lData$dfSummary,
        strType = "score",
        vThreshold = unlist(dfWorkflow$thresholds)
    )


  # Continuous Charts -------------------------------------------------------
    if (!is.null(lStackedSnapshots)) {

      number_of_snapshots <- length(unique(lStackedSnapshots$rpt_site_kri_details$snapshot_date))

      if (number_of_snapshots > 1) {
        lCharts$timeSeriesContinuousJS <- Widget_TimeSeries(
          results = lStackedSnapshots$rpt_site_kri_details,
          workflow = lStackedSnapshots$rpt_kri_details,
          parameters = lStackedSnapshots$rpt_kri_threshold_param
        )
      }

    }

    return(lCharts)
}
