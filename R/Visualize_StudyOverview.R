#' Visualize_StudyOverview Function
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' The function creates the tabular outputs like study overview and flag over time using the data provided
#' @inheritParams shared-params
#' @param strGroupLevel `character` Value for the group level. Default: NULL and taken from `dfMetrics$GroupLevel` if available.
#' @param strGroupSubset `character` Subset of groups to include in the table. Default: 'red'. Options:
#' - 'all': All groups.
#' - 'red': Groups with 1+ red flags.
#' - 'red/amber': Groups with 1+ red/amber flag.
#' - 'amber': Groups with 1+ amber flag.
#' @param strGroupLabelKey `character` Value for the group label key. Default: 'InvestigatorLastName'.
#'
#' @return A list containing the following charts:
#' - studyOverviewJS: Study Overview table using Javascript
#' - flagOverTimeJS: Flag Over Time Table using Javascript
#'
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
