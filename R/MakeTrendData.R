#' Make Time Series Trend Data
#'
#' @param lSnapshot `list` The output of [gsm::Make_Snapshot()] where `bReturnStudyObject = TRUE`.
#' @param cDirectory `character` Path to longitudinal snapshots, returned by [gsm::Make_Snapshot()].
#' @param bAppendSnapshot `logical` The output of [gsm::Make_Snapshot()], to be appended to historical snapshots.
#' @param bAppendTimeSeriesCharts `logical` Append time series charts to KRIs? Default: `TRUE`.
#'
#' @examples
#' \dontrun{
#' study <- Study_Assess()
#' directory_location <- here::here("snapshots")
#'
#' trend_data <- MakeTrendData(lStudyAssess = study, cDirectory = directory_location)
#'
#' }
#'
#' @return `list` The output of [gsm::Study_Assess()] with longitudinal data appended.
#'
#' @export
MakeTrendData <- function(lSnapshot, cDirectory, bAppendSnapshot = TRUE, bAppendTimeSeriesCharts = TRUE) {

  longitudinal <- MakeTimeSeriesLongitudinal(cDirectory, lSnapshot)

  if (bAppendTimeSeriesCharts) {
    lSnapshot$lStudyAssessResults <- lSnapshot$lStudyAssessResults %>%
      purrr::map(function(kri) {

        kri$lResults$lCharts[['timeSeriesContinuousJS']] <- Widget_TimeSeries(
          kri = kri$name,
          raw_results = longitudinal$results_summary,
          raw_param = longitudinal$params, raw_workflow =
            longitudinal$meta_workflow
          )

        kri$lResults$lLongitudinal <- #append data

        return(kri)
      })
  }


  lSnapshot$lStudyAssessResults[["longitudinal"]] <- longitudinal %>%
    purrr::map(function(x) {
      x %>%
        mutate(
          gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%d-%m")
          )
    })


  return(lSnapshot)

}
