#' Study Report
#'
#' Create HTML summary report using the results of `Study_Assess`, including tables, charts, and error checking.
#'
#' @param lAssessments `list` The results of multiple assessments run using `Study_Assess`.
#' @param lMeta `list` Metadata related to study.
#' @param strOutpath `character` File path; location where the report will be saved.
#'
#' @return HTML report of study data.
#'
#' @examples
#' \dontrun{
#' lAssessment <- Study_Assess()
#' Study_Report(lAssessment, lMeta = list(study = "my study name"))
#' }
#'
#' @importFrom rmarkdown render
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
    envir = new.env(parent = globalenv())
  )
}
