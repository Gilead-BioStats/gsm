#' MakeQTLCharts
#'
#' @description
#' Make cross-sectional timeseries charts in `[gsm::Make_Snapshot()]`.
#'
#'
#' @param strQtlName `character` Name of QTL workflow, e.g., "qtl0004".
#' @param lStackedSnapshots `list` List of stacked snapshot data - cross-sectional / longitudinal data.
#'
#'
#' @return `list` of HTML widgets.
#' @export
MakeQTLCharts <- function(strQtlName, lStackedSnapshots) {

  stopifnot(
    "[ `lStackedSnapshots` ] must contain the dataset [ `rpt_site_kri_details` ]" = "rpt_site_kri_details" %in% names(lStackedSnapshots),
    "[ `lStackedSnapshots` ] must contain the dataset [ `rpt_kri_details` ]" = "rpt_kri_details" %in% names(lStackedSnapshots),
    "[ `lStackedSnapshots` ] must contain the dataset [ `rpt_kri_threshold_param` ]" = "rpt_kri_threshold_param" %in% names(lStackedSnapshots),
    "[ `lStackedSnapshots` ] must contain the dataset [ `rpt_qtl_analysis` ]" = "rpt_qtl_analysis" %in% names(lStackedSnapshots)
  )

  # this will be a function eventually
  qtl_charts <- list(
    timeseriesQtl = Widget_TimeSeriesQTL(qtl = strQtlName,
                                         raw_results = lStackedSnapshots$rpt_site_kri_details,
                                         raw_workflow = lStackedSnapshots$rpt_kri_details,
                                         raw_param = lStackedSnapshots$rpt_kri_threshold_param,
                                         raw_analysis = lStackedSnapshots$rpt_qtl_analysis)
  )

  return(qtl_charts)

}
