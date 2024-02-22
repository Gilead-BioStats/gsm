#' Create and output Covariate Report
#'
#' @param snapshot `list` snapshot object output from `Make_Snapshot()`
#'
#' @export
#' @keywords Internal
Covariate_Report <- function(lSnapshot){
  projectTemplate <- system.file("report", "CovariateReport.Rmd", package = "gsm")
  strOutpath <- paste0(getwd(), "/gsm_covariate_report.html")

  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      snapshot = lSnapshot
    ),
    envir = new.env(parent = globalenv())
  )
}
