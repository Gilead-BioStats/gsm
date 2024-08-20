#' Visualize_Metric Function
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' The function creates all available charts for a metric using the data provided
#'
#' @inheritParams shared-params
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
#' - metricTable: A table containing all
#'
#' @examples
#' charts <- Visualize_Metric(
#'   dfResults = reportingResults,
#'   dfBounds = reportingBounds,
#'   dfGroups = reportingGroups,
#'   dfMetrics = reportingMetrics,
#'   strMetricID = "kri0001"
#' )
#'
#' @export

Visualize_Metric <- function(
  dfResults = dfResults,
  dfBounds = NULL,
  dfGroups = NULL,
  dfMetrics = NULL,
  strMetricID = NULL,
  strSnapshotDate = NULL,
  bDebug = FALSE
) {
  # Check for multiple snapshots --------------------------------------------
  # if SnapshotDate is missing set it to today for all records
  if (!"SnapshotDate" %in% colnames(dfResults)) {
    dfResults$SnapshotDate <- as.Date(Sys.Date())
  }

  if (!"SnapshotDate" %in% colnames(dfBounds)) {
    dfBounds$SnapshotDate <- as.Date(Sys.Date())
  }

  # get number of snapshots
  number_of_snapshots <- length(unique(dfResults$SnapshotDate))

  # use most recent snapshot date if strSnapshotDate is missing
  if (is.null(strSnapshotDate)) {
    strSnapshotDate <- max(dfResults$SnapshotDate)
  }

  # Filter to selected MetricID ----------------------------------------------
  if (!is.null(strMetricID)) {
    if (!(strMetricID %in% unique(dfResults$MetricID))) {
      cli::cli_alert_danger("MetricID not found in dfResults. No charts will be generated.")
      return(NULL)
    } else {
      dfResults <- dfResults %>% filter(.data$MetricID == strMetricID)
      dfBounds <- dfBounds %>% filter(.data$MetricID == strMetricID)
      dfMetrics <- dfMetrics %>% filter(.data$MetricID == strMetricID)
    }
  }

  if (
    length(unique(dfResults$MetricID)) > 1 |
      length(unique(dfBounds$MetricID)) > 1 |
      length(unique(dfMetrics$MetricID)) > 1
  ) {
    cli::cli_abort("Multiple MetricIDs found in dfResults, dfBounds or dfMetrics. Specify `MetricID` to subset. No charts will be generated.")
    return(NULL)
  }

  # Prep chart inputs ---------------------------------------------------------
  lMetric <- as.list(dfMetrics)
  vThreshold <- ParseThreshold(lMetric$Threshold)

  # Cross-sectional Charts using most recent snapshot ------------------------
  lCharts <- list()
  dfResults_latest <- filter_by_latest_SnapshotDate(dfResults, strSnapshotDate)
  dfBounds_latest <- filter_by_latest_SnapshotDate(dfBounds, strSnapshotDate)

  if (nrow(dfResults_latest) == 0) {
    cli::cli_alert_warning("No data found for specified snapshot date: {strSnapshotDate}. No charts will be generated.")
  } else {
    lCharts$scatterJS <- Widget_ScatterPlot(
      dfResults = dfResults_latest,
      lMetric = lMetric,
      dfGroups = dfGroups,
      dfBounds = dfBounds_latest,
      bDebug = bDebug
    )

    lCharts$scatter <- Visualize_Scatter(
      dfResults = dfResults_latest,
      dfBounds = dfBounds_latest,
      strGroupLabel = lMetric$GroupLevel
    )

    lCharts$barMetricJS <- Widget_BarChart(
      dfResults = dfResults_latest,
      lMetric = lMetric,
      dfGroups = dfGroups,
      strOutcome = "Metric",
      bDebug = bDebug
    )

    lCharts$barScoreJS <- Widget_BarChart(
      dfResults = dfResults_latest,
      lMetric = lMetric,
      dfGroups = dfGroups,
      strOutcome = "Score",
      bDebug = bDebug
    )

    lCharts$barMetric <- Visualize_Score(
      dfResults = dfResults_latest,
      strType = "Metric"
    )

    lCharts$barScore <- Visualize_Score(
      dfResults = dfResults_latest,
      strType = "Score",
      vThreshold = vThreshold
    )

    lCharts$metricTable <- Report_MetricTable(
      dfResults = dfResults_latest,
      dfGroups = dfGroups,
      strGroupLevel = lMetric$GroupLevel
    )
  }
  # Continuous Charts -------------------------------------------------------
  if (number_of_snapshots <= 1) {
    cli::cli_alert_info("Only one snapshot found. Time series charts will not be generated.")
  } else {
    lCharts$timeSeriesContinuousScoreJS <- Widget_TimeSeries(
      dfResults = dfResults,
      lMetric = lMetric,
      dfGroups = dfGroups,
      vThreshold = vThreshold,
      strOutcome = "Score",
      bDebug = bDebug
    )

    lCharts$timeSeriesContinuousMetricJS <- Widget_TimeSeries(
      dfResults = dfResults,
      lMetric = lMetric,
      dfGroups = dfGroups,
      strOutcome = "Metric",
      bDebug = bDebug
    )

    lCharts$timeSeriesContinuousNumeratorJS <- Widget_TimeSeries(
      dfResults = dfResults,
      lMetric = lMetric,
      dfGroups = dfGroups,
      strOutcome = "Numerator",
      bDebug = bDebug
    )
  }

  return(lCharts)
}
