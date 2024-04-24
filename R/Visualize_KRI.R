#' Visualize_KRI Function
#'
#' The function Visualize_KRI creates three different types of charts (scatter plot and two bar charts) using the gsm package.
#'
#' @param dfSummary `data.frame` A data.frame returned by [gsm::Summarize()].
#' @param lLabels `list` Workflow metadata. See [gsm::meta_workflow].
#' @param dfSite `data.frame` Site metadata returned by [gsm::Site_Map_Raw()].
#' @param dfBounds `data.frame`, A data.frame returned by [gsm::Analyze_NormalApprox_PredictBounds()] or [gsm::Analyze_Poisson_PredictBounds()]
#' @param lStackedSnapshots `list` A list returned by [gsm::Make_Snapshot()] containing flat files for snapshot/assessment data.
#'
#' @return A list (lCharts) containing three charts - scatterJS, barMetricJS, and barScoreJS.
#'
#' @export

Visualize_KRI <- function(
    dfSummary,
    lLabels = NULL,
    dfSite = NULL,
    dfBounds = NULL,
    lStackedSnapshots = NULL
) {
  lCharts <- list()

  if (tolower(lLabels$model) != "identity") {
    lCharts$scatterJS <- gsm::Widget_ScatterPlot(
      dfSummary = dfSummary,
      lLabels = lLabels,
      dfSite = dfSite,
      dfBounds = dfBounds,
      elementId = paste0(tolower(lLabels$abbreviation), "AssessScatter")
    )

    lCharts$scatter <- gsm::Visualize_Scatter(
      dfSummary = dfSummary,
      dfBounds = dfBounds,
      strGroupLabel = lLabels$group
    )
  }

  lCharts$barMetricJS <- gsm::Widget_BarChart(
    dfSummary = dfSummary,
    lLabels = lLabels,
    dfSite = dfSite,
    strYAxisType = "metric",
    elementId = paste0(tolower(lLabels$abbreviation), "AssessMetric")
  )

  lCharts$barScoreJS <- gsm::Widget_BarChart(
    dfSummary = dfSummary,
    lLabels = lLabels,
    dfSite = dfSite,
    strYAxisType = "score",
    elementId = paste0(tolower(lLabels$abbreviation), "AssessScore")
  )

  lCharts$barMetric <- gsm::Visualize_Score(
    dfSummary = dfSummary,
    strType = "metric"
  )

  lCharts$barScore <- gsm::Visualize_Score(
    dfSummary = dfSummary,
    strType = "score",
    vThreshold = unlist(lLabels$thresholds)
  )

  # Continuous Charts -------------------------------------------------------
  if (!is.null(lStackedSnapshots)) {
    number_of_snapshots <- length(unique(lStackedSnapshots$rpt_site_kri_details$snapshot_date))

    if (number_of_snapshots > 1) {

      lCharts$timeSeriesContinuousScoreJS <- Widget_TimeSeries(
        dfSummary = lStackedSnapshots$rpt_site_kri_details,
        lLabels = lStackedSnapshots$rpt_kri_details,
        dfSite = dfSite,
        dfParams = lStackedSnapshots$rpt_kri_threshold_param,
        yAxis = "score"
      )

      lCharts$timeSeriesContinuousMetricJS <- Widget_TimeSeries(
        dfSummary = lStackedSnapshots$rpt_site_kri_details,
        lLabels = lStackedSnapshots$rpt_kri_details,
        dfSite = dfSite,
        dfParams = lStackedSnapshots$rpt_kri_threshold_param,
        yAxis = "metric"
      )

      lCharts$timeSeriesContinuousNumeratorJS <- Widget_TimeSeries(
        dfSummary = lStackedSnapshots$rpt_site_kri_details,
        lLabels = lStackedSnapshots$rpt_kri_details,
        dfSite = dfSite,
        dfParams = lStackedSnapshots$rpt_kri_threshold_param,
        yAxis = "numerator"
      )
    }
  }

  return(lCharts)
}

