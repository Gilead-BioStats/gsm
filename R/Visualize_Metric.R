#' Visualize_Metric Function
#'
#' The function creates all available charts for a metric using the data provided
#'
#' @param dfSummary `data.frame` A data.frame returned by [gsm::Summarize()].
#' @param dfBounds `data.frame`, A data.frame returned by [gsm::Analyze_NormalApprox_PredictBounds()] or [gsm::Analyze_Poisson_PredictBounds()]
#' @param dfMetrics `data.frame` Metrics metadata.
#' @param dfSite `data.frame` Site metadata.
#' @param dfParams `data.frame` Parameters metadata.
#' @param strMetricID `character` MetricID to subset the data.
#' @param strSnapshotDate `character` Snapshot date to subset the data.
#'
#' @return A list containing the following charts:
#' - scatterJS: A scatter plot using JavaScript.
#' - scatter: A scatter plot using ggplot2.
#' - barMetricJS: A bar chart using JavaScript with metric on the y-axis.
#' - barScoreJS: A bar chart using JavaScript with score on the y-axis.
#' - barMetric: A bar chart using ggplot2 with metric on the y-axis.
#' - barScore: A bar chart using ggplot2 with score on the y-axis.
#' - timeSeriesContinuousScoreJS: A time series chart using JavaScript with score on the y-axis.
#' - timeSeriesContinuousMetricJS: A time series chart using JavaScript with metric on the y-axis.
#' - timeSeriesContinuousNumeratorJS: A time series chart using JavaScript with numerator on the y-axis.
#'
#' @export

Visualize_Metric <- function(
    dfSummary,
    dfBounds = NULL,
    dfSite = NULL,
    dfMetrics = NULL,
    dfParams = NULL,
    strMetricID = NULL,
    strSnapshotDate = NULL
) {

  # Check for multiple snapshots --------------------------------------------
  # if SnapshotDate is missing set it to today for all records
  if (!"SnapshotDate" %in% colnames(dfSummary)) {
    dfSummary$SnapshotDate <- as.Date(Sys.Date())
  }

  # get number of snapshots
  number_of_snapshots <- length(unique(dfSummary$SnapshotDate))

  # use most recent snapshot date if strSnapshotDate is missing
  if(is.null(strSnapshotDate)){
    strSnapshotDate <- max(dfSummary$SnapshotDate)
  }

  # Check MetricID input and filter data to only include selected metric  ----------------------------------------------
  if(is.null(strMetricID)){
      # check for multiple metrics in the data
      if(length(unique(dfSummary$MetricID)) > 1 | length(unique(dfBounds$MetricID)) > 1 | length(unique(dfMetrics$MetricID)) > 1){
        #if multiple metrics are found (with no strMetricID specified) abort
        cli_abort("Multiple MetricIDs found in dfSummary, dfBounds or dfMetrics. Specify `MetricID` to subset. No charts will be generated.")
        return(NULL)
      } else {
        # if only 1 metric is found, set strMetricID to that value
          strMetricID <- unique(dfSummary$MetricID)
    }
  }

  if(!(strMetricID %in% unique(dfSummary$MetricID))){
    cli::cli_alert_danger("MetricID not found in dfSummary. No charts will be generated.")
    return(NULL)
  }
    
  dfSummary <- dfSummary %>% filter(.data$MetricID == strMetricID)
  dfBounds <- dfBounds %>% filter(.data$MetricID == strMetricID)
  dfMetrics <- dfMetrics %>% filter(.data$MetricID == strMetricID)

  # Cross-sectional Charts using most recent snapshot ------------------------
  lCharts <- list()
  dfSummary_current <- dfSummary %>% filter(.data$SnapshotDate == strSnapshotDate)

  if(nrow(dfSummary_current) == 0){
    cli::cli_alert_warning("No data found for specified snapshot date: {strSnapshotDate}. No charts will be generated.")
  } else {

    lCharts$scatterJS <- gsm::Widget_ScatterPlot(
      dfSummary = dfSummary_current,
      dfMetrics = dfMetrics,
      dfSite = dfSite,
      dfBounds = dfBounds,
      elementId = paste0(tolower(dfMetrics$Abbreviation), "AssessScatter")
    )

    lCharts$scatter <- gsm::Visualize_Scatter(
      dfSummary = dfSummary_current,
      dfBounds = dfBounds,
      strGroupLabel = dfMetrics$Group
    )

    lCharts$barMetricJS <- gsm::Widget_BarChart(
      dfSummary = dfSummary_current,
      dfMetrics = dfMetrics,
      dfSite = dfSite,
      strYAxisType = "Metric",
      elementId = paste0(tolower(dfMetrics$Abbreviation), "AssessMetric")
    )

    lCharts$barScoreJS <- gsm::Widget_BarChart(
      dfSummary = dfSummary_current,
      dfMetrics = dfMetrics,      
      dfSite = dfSite,
      strYAxisType = "Score",
      elementId = paste0(tolower(dfMetrics$Abbreviation), "AssessScore")
    )

    lCharts$barMetric <- gsm::Visualize_Score(
      dfSummary = dfSummary_current,
      strType = "Metric"
    )

    lCharts$barScore <- gsm::Visualize_Score(
      dfSummary = dfSummary_current,
      strType = "Score",
      vThreshold = ParseThreshold(dfMetrics$strThreshold)
    )
  }
  # Continuous Charts -------------------------------------------------------
  if ( number_of_snapshots <= 1 ) {
    cli::cli_alert_info("Only one snapshot found. Time series charts will not be generated.")
  } else {
    lCharts$timeSeriesContinuousScoreJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lLabels = dfMetrics,
      #dfSite = dfSite,
      dfParams = dfParams,
      yAxis = "Score"
    )

    lCharts$timeSeriesContinuousMetricJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lLabels = dfMetrics,
      #dfSite = dfSite,
      dfParams = dfParams,
      yAxis = "Metric"
    )

    lCharts$timeSeriesContinuousNumeratorJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lLabels = dfMetrics,
      #dfSite = dfSite,
      dfParams = dfParams,
      yAxis = "Numerator"
    )
  }

  return(lCharts)
}

