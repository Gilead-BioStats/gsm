#' Make Time Series Trend Data
#'
#' @param lStudyAssess `list` The output of [gsm::Study_Assess()].
#' @param cDirectory `character` Path to longitudinal snapshots, returned by [gsm::Make_Snapshot()].
#'
#'
#' @examples
#'
#' @return `list` The output of [gsm::Study_Assess()] with longitudinal data appended.
#'
#' @export
MakeTrendData <- function(lStudyAssess, cDirectory) {

  longitudinal <- MakeTimeSeriesLongitudinal(cDirectory)

  lStudyAssess[["longitudinal"]] <- longitudinal %>%
    map(function(x) {
      x %>% mutate(gsm_analysis_date = as.Date(gsm_analysis_date, "%Y-%d-%m"))
    })

  return(lStudyAssess)

}
