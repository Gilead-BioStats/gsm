#' Study Report
#'
#' Pulls needed study data and runs one or more assessments
#'
#' @param lAssessments character vector listing assessments
#' @param lMeta list of metadata related to study
#' @param strOutpath path to safe the report
#'
#' @return HTML report of study data.
#'
#' @examples
#' \dontrun{
#' assessment <- Study_Assess()
#' Study_Report(assessment, lMeta = list(study = "my study name"))
#' }
#'
#' @export

Study_Report <- function(lAssessments, lMeta = list(Project = "My Project"), strOutpath = NULL) {
  if (is.null(strOutpath)) strOutpath <- paste0(getwd(), "/gsm_report.html")
  if (!hasName(lMeta, "Project")) lMeta$Project <- "My Project"
  projectTemplate <- system.file("report", "studySummary.rmd", package = "gsm")
  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      assessments = lAssessments,
      meta = lMeta
    ),
    envir = new.env(parent = globalenv()) ## eval in child of global env
  )
}
