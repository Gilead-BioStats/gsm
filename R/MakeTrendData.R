#' Make Time Series Trend Data
#'
#' @param lStudyAssess `list` The output of [gsm::Study_Assess()].
#' @param cDirectory `character` Path to longitudinal snapshots, returned by [gsm::Make_Snapshot()].
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
MakeTrendData <- function(lStudyAssess, cDirectory, bAppendTimeSeriesCharts = TRUE) {

  longitudinal <- MakeTimeSeriesLongitudinal(cDirectory)

  if (bAppendTimeSeriesCharts) {
    lStudyAssess <- lStudyAssess %>%
      purrr::map(function(kri) {
        kri$lResults$lCharts[['timeSeriesContinuousJS']] <- timeSeriesContinuous(kri = kri$name,
                                                                                 raw_results = longitudinal$results_summary,
                                                                                 raw_param = longitudinal$params,
                                                                                 raw_workflow = longitudinal$meta_workflow)
        return(kri)
      })
  }

  lStudyAssess[["longitudinal"]] <- longitudinal %>%
    purrr::map(function(x) {
      x %>%
        mutate(
          gsm_analysis_date = as.Date(.data$gsm_analysis_date, "%Y-%d-%m")
          )
    })



  return(lStudyAssess)

}
