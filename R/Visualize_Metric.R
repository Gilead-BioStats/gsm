#' Visualize_Metric Function
#'
#' The function creates all available charts for a metric using the data provided
#'
#' @param dfSummary `data.frame` A data.frame returned by [gsm::Summarize()].
#' @param dfBounds `data.frame`, A data.frame returned by [gsm::Analyze_NormalApprox_PredictBounds()] or [gsm::Analyze_Poisson_PredictBounds()]
#' @param dfMetrics `data.frame` Metrics metadata.
#' @param dfGroups `data.frame` Site metadata.
#' @param strMetricID `character` MetricID to subset the data.
#' @param strSnapshotDate `character` Snapshot date to subset the data.
#' @param bDebug `logical` Display console in html viewer for debugging. Default is `FALSE`.
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
    dfGroups = NULL,
    dfMetrics = NULL,
    strMetricID = NULL,
    strSnapshotDate = NULL,
    bDebug = FALSE
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

  # Filter to selected MetricID ----------------------------------------------
  if(!is.null(strMetricID)){

    if(!(strMetricID %in% unique(dfSummary$MetricID))){
      cli::cli_alert_danger("MetricID not found in dfSummary. No charts will be generated.")
      return(NULL)
    }else{
      dfSummary <- dfSummary %>% filter(.data$MetricID == strMetricID)
      dfBounds <- dfBounds %>% filter(.data$MetricID == strMetricID)
      dfMetrics <- dfMetrics %>% filter(.data$MetricID == strMetricID)
    }
  }

  if(length(unique(dfSummary$MetricID)) > 1 | length(unique(dfBounds$MetricID)) > 1 | length(unique(dfMetrics$MetricID)) > 1){
    cli_abort("Multiple MetricIDs found in dfSummary, dfBounds or dfMetrics. Specify `MetricID` to subset. No charts will be generated.")
    return(NULL)
  }

  # Prep chart inputs ---------------------------------------------------------
  lMetric <- dfMetrics %>% as.list()
  vThreshold <- ParseThreshold(lMetric$strThreshold)


  # Stopgap Long to Wide Conversion for dfGroups -----------------------------
  # TODO remove this and just use the long version of dfGroups? Only working for Sites for the moment

  lMetric$Group <- lMetric$GroupLevel
  dfGroups_Wide <- dfGroups %>%
    filter(tolower(GroupLevel) == tolower(lMetric$GroupLevel)) %>%
    pivot_wider(names_from = Param, values_from = Value)

  # TODO update expected names in rbmviz
  if(tolower(lMetric$GroupLevel) == "site"){
    dfGroups_Wide <- dfGroups_Wide %>%
      rename(
        SiteID = GroupID,
        status = Status,
        enrolled_participants = ParticipantCount
      )
  }

  # Cross-sectional Charts using most recent snapshot ------------------------
  lCharts <- list()
  dfSummary_current <- dfSummary %>% filter(.data$SnapshotDate == strSnapshotDate)

  if(nrow(dfSummary_current) == 0){
    cli::cli_alert_warning("No data found for specified snapshot date: {strSnapshotDate}. No charts will be generated.")
  } else {

    lCharts$scatterJS <- gsm::Widget_ScatterPlot(
      dfSummary = dfSummary_current,
      lMetric = lMetric,
      dfGroups = dfGroups_Wide,
      dfBounds = dfBounds,
      bDebug = bDebug
    )

    lCharts$scatter <- gsm::Visualize_Scatter(
      dfSummary = dfSummary_current,
      dfBounds = dfBounds,
      strGroupLabel = lMetric$GroupLevel
    )

    lCharts$barMetricJS <- gsm::Widget_BarChart(
      dfSummary = dfSummary_current,
      lMetric = lMetric,
      dfGroups = dfGroups_Wide,
      strOutcome = "Metric",
      bDebug = bDebug
    )

    lCharts$barScoreJS <- gsm::Widget_BarChart(
      dfSummary = dfSummary_current,
      lMetric = lMetric,
      dfGroups = dfGroups_Wide,
      strOutcome = "Score",
      bDebug = bDebug
    )

    lCharts$barMetric <- gsm::Visualize_Score(
      dfSummary = dfSummary_current,
      strType = "Metric"
    )

    lCharts$barScore <- gsm::Visualize_Score(
      dfSummary = dfSummary_current,
      strType = "Score",
      vThreshold = vThreshold
    )
  }
  # Continuous Charts -------------------------------------------------------
  if ( number_of_snapshots <= 1 ) {
    cli::cli_alert_info("Only one snapshot found. Time series charts will not be generated.")
  } else {
    lCharts$timeSeriesContinuousScoreJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lMetric = lMetric,
      dfGroups = dfGroups_Wide,
      vThreshold =vThreshold,
      strOutcome = "Score",
      bDebug = bDebug
    )

    lCharts$timeSeriesContinuousMetricJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lMetric = lMetric,
      dfGroups = dfGroups_Wide,
      strOutcome = "Metric",
      bDebug = bDebug
    )

    lCharts$timeSeriesContinuousNumeratorJS <- Widget_TimeSeries(
      dfSummary = dfSummary,
      lMetric = lMetric,
      dfGroups = dfGroups_Wide,
      strOutcome = "Numerator",
      bDebug = bDebug
    )
  }

  return(lCharts)
}

