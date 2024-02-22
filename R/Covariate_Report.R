#' Create and output Covariate Report
#'
#' @param snapshot `list` snapshot object output from `Make_Snapshot()`
#'
#' @export
#' @keywords Internal
Covariate_Report <- function(lSnapshot, lStudyCompCharts, lTreatmentCompCharts, dfStudyComp, dfTreatmentComp){
  projectTemplate <- system.file("report", "CovariateReport.Rmd", package = "gsm")
  strOutpath <- paste0(getwd(), "/gsm_covariate_report.html")

  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      lSnapshot = lSnapshot,
      dfStudyComp = dfStudyComp,
      dfTreatmentComp = dfTreatmentComp,
      lStudyCompCharts = lStudyCompCharts,
      lTreatmentCompCharts = lTreatmentCompCharts
    ),
    envir = new.env(parent = globalenv())
  )
}
