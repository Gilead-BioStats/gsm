#' Title
#'
#' @param dfResults a data.frame
#' @param dfMetrics a data.frame
#' @param dfGroups  a data.frame
#' @param strGroupLevel a character
#' @param strGroupSubset a character
#' @param strGroupLabelKey a character
#' @param bDebug a logical
#'
#' @return a list of visualizations
#' @export
Visualize_StudyOverview <- function(
    dfResults,
    dfMetrics,
    dfGroups,
    strGroupLevel = NULL,
    strGroupSubset = "red",
    strGroupLabelKey = "InvestigatorLastName",
    bDebug = FALSE
) {

  lCharts <- list()
  lCharts$studyOverviewJS <- Widget_GroupOverview(
    dfResults = dfResults,
    dfMetrics = dfMetrics,
    dfGroups = dfGroups,
    strGroupLevel = strGroupLevel,
    strGroupSubset = strGroupSubset,
    strGroupLabelKey = strGroupLabelKey
  )

  lCharts$flagOverTimeJS <- Widget_FlagOverTime(
    dfResults = dfResults,
    dfMetrics = dfMetrics,
    strGroupLevel = strGroupLevel
  )

  return(lCharts)
}
