#' Visualize_KRI Function
#'
#' The function Visualize_KRI creates three different types of charts (scatter plot and two bar charts) using the gsm package.
#'
#' @param dfSummary `data.frame` A data.frame returned by [gsm::Summarize()].
#' @param dfSite `data.frame` Site metadata returned by [gsm::Site_Map_Raw()].
#' @param dfBounds `data.frame`, A data.frame returned by [gsm::Analyze_NormalApprox_PredictBounds()] or [gsm::Analyze_Poisson_PredictBounds()]
#' @param lLabels `list` Workflow metadata. See [gsm::meta_workflow].
#'
#' @return A list (lCharts) containing three charts - scatterJS, barMetricJS, and barScoreJS.
#'
#' @export

Visualize_KRI <- function(
    dfSummary,
    dfSite = NULL,
    dfBounds = NULL,
    dfParams = NULL,
    lLabels = NULL,
    strSnapshotDate = NULL
) {

  # Check for multiple snapshots --------------------------------------------
  # if snapshot_date is missing set it to today for all records
  if (!"snapshot_date" %in% colnames(dfSummary)) {
    dfSummary$snapshot_date <- as.Date(Sys.Date())
  }

  # get number of snapshots
  number_of_snapshots <- length(unique(dfSummary$snapshot_date))

  # use most recent snapshot date if strSnapshotDate is missing
  if(is.null(strSnapshotDate)){
    strSnapshotDate <- max(dfSummary$snapshot_date)
  }

  # Cross-sectional Charts using most recent snapshot ------------------------
  lCharts <- list()
  dfSummary_current <- dfSummary %>% filter(snapshot_date == strSnapshotDate)

  if(nrow(dfSummary_current) == 0){
    cli::cli_alert_warning("No data found for specified snapshot date: {strSnapshotDate}. No charts will be generated.")
  } else {
    lCharts$scatterJS <- gsm::Widget_ScatterPlot(
      dfSummary = dfSummary_current,
      lLabels = lLabels,
      dfSite = NULL,
      #dfSite = dfSite,
      dfBounds = dfBounds,
      elementId = paste0(tolower(lLabels$abbreviation), "AssessScatter")
    )

    lCharts$scatter <- gsm::Visualize_Scatter(
      dfSummary = dfSummary_current,
      dfBounds = dfBounds,
      strGroupLabel = lLabels$group
    )

    lCharts$barMetricJS <- gsm::Widget_BarChart(
      dfSummary = dfSummary_current,
      lLabels = lLabels,
      dfSite = dfSite,
      strYAxisType = "metric",
      elementId = paste0(tolower(lLabels$abbreviation), "AssessMetric")
    )

    lCharts$barScoreJS <- gsm::Widget_BarChart(
      dfSummary = dfSummary_current,
      lLabels = lLabels,
      dfSite = dfSite,
      strYAxisType = "score",
      elementId = paste0(tolower(lLabels$abbreviation), "AssessScore")
    )

    lCharts$barMetric <- gsm::Visualize_Score(
      dfSummary = dfSummary_current,
      strType = "metric"
    )

    lCharts$barScore <- gsm::Visualize_Score(
      dfSummary = dfSummary_current,
      strType = "score",
      vThreshold = unlist(lLabels$thresholds)
    )
  } 
  # Continuous Charts -------------------------------------------------------
  if ( number_of_snapshots <= 1 ) {
    cli::cli_alert_info("Only one snapshot found. Time series charts will not be generated.")
  } else {
    lCharts$timeSeriesContinuousScoreJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lLabels = lLabels %>% map_dfr(~.x),
      #dfSite = dfSite,
      dfParams = dfParams,
      yAxis = "score"
    )

    lCharts$timeSeriesContinuousMetricJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lLabels = lLabels %>% map_dfr(~.x),
      #dfSite = dfSite,
      dfParams = dfParams,
      yAxis = "metric"
    )

    lCharts$timeSeriesContinuousNumeratorJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lLabels = lLabels %>% map_dfr(~.x),
      #dfSite = dfSite,
      dfParams = dfParams,
      yAxis = "numerator"
    )
  }

  return(lCharts)
}

