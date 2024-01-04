#' MakeQTLCharts
#'
#' @description
#' Make cross-sectional timeseries charts in `[gsm::Make_Snapshot()]`.
#'
#'
#' @param strQtlName `character` Name of QTL workflow, e.g., "qtl0004".
#' @param dfSummary `data.frame` Longitudinal data, typically `rpt_site_kri_details` from [gsm::Make_Snapshot()].
#' @param dfParams `data.frame` Longitudinal parameter/configuration data, typically `rpt_kri_threshold_param` from [gsm::Make_Snapshot()].
#' @param dfAnalysis `data.frame` Longitudinal QTL analysis results, typically `rpt_qtl_analysis` from  [gsm::Make_Snapshot()].
#' @param lLabels `list` Longitudinal workflow/metadata, typically `rpt_kri_details` from [gsm::Make_Snapshot()].
#'
#' @return `list` of HTML widgets.
#' @export
MakeQTLCharts <- function(strQtlName, dfSummary, dfParams, dfAnalysis, lLabels) {
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
