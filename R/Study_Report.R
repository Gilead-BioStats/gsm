#' {experimental} Study Report
#'
#' `r lifecycle::badge("experimental")`
#'
#' Create HTML summary report using the results of `Study_Assess`, including tables, charts, and error checking.
#'
#' @param lAssessments `list` The results of multiple assessments run using `Study_Assess`.
#' @param strOutpath `character` File path; location where the report will be saved.
#'
#' @return HTML report of study data.
#'
#' @examples
#' \dontrun{
#' lWorkflow <- Study_Assess()
#' Study_Report(lWorkflow, lMeta = list(study = "my study name"))
#' }
#'
#' @importFrom rmarkdown render
#'
#' @export

Study_Report <- function(lAssessments,
                         strOutpath = NULL,
                         strReportType = "kri"
                         ) {
  report_type <- switch(strReportType,
                        kri = "KRIReport.Rmd",
                        study = "studySummary.rmd")

  if (is.null(strOutpath)) {
    strOutpath <- paste0(getwd(), "/gsm_report.html")
  }


  projectTemplate <- system.file("report", report_type, package = "gsm")
  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      study = lAssessments
    ),
    envir = new.env(parent = globalenv())
  )
}
