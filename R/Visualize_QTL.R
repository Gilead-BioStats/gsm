#' Visualize_QTL
#'
#' `r lifecycle::badge("experimental")`
#'
#' @description
#' Make cross-sectional timeseries charts.
#'
#'
#' @param strQtlName `character` Name of QTL workflow, e.g., "qtl0004".
#' @param dfSummary `data.frame` Longitudinal data.
#' @param dfParams `data.frame` Longitudinal parameter/configuration data.
#' @param dfAnalysis `data.frame` Longitudinal QTL analysis results.
#' @param lLabels `list` Longitudinal workflow/metadata.
#'
#' @return `list` of HTML widgets.
#' @export
Visualize_QTL <- function(strQtlName, dfSummary, dfParams, dfAnalysis, lLabels) {
  stopifnot(
    "[ `dfSummary` ] must be a `data.frame`." = is.data.frame(dfSummary),
    "[ `lLabels` ] must be a `list`." = is.list(lLabels),
    "[ `dfParam` ] must be a `data.frame`." = is.data.frame(dfParams),
    "[ `dfAnalysis` ] must be a `data.frame`." = is.data.frame(dfAnalysis)
  )

  # this will be a function eventually
  qtl_charts <- list(
    timeseriesQtl = Widget_TimeSeriesQTL(
      qtl = strQtlName,
      dfSummary = dfSummary,
      lLabels = lLabels,
      dfParams = dfParams,
      dfAnalysis = dfAnalysis
    )
  )

  return(qtl_charts)
}
