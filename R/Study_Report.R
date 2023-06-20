#' `r lifecycle::badge("experimental")`
#'
#' Study Report
#'
#'
#' Create HTML summary report using the results of `Study_Assess`, including tables, charts, and error checking.
#'
#' @param lAssessments `list` The results of multiple assessments run using `Study_Assess`.
#' @param dfStudy `data.frame` A data.frame containing study status metadata. Typically output from `Make_Snapshot()$lSnapshot$status_study`
#' @param dfSite `data.frame` A data.frame containing site status metadata. Typically output from `Make_Snapshot()$lSnapshot$status_site`
#' @param strOutpath `character` File path; location where the report will be saved.
#'
#' @return HTML report of study data.
#'
#' @examples
#' \dontrun{
#' # Using `Study_Assess()`
#' study <- Study_Assess()
#' Study_Report(study)
#'
#' # Adding metadata for a single snapshot
#' one_snapshot <- Make_Snapshot()
#' Study_Report(
#'   lAssessments = one_snapshot$lStudyAssessResults,
#'   dfStudy = one_snapshot$lSnapshot$status_study
#' )
#'
#' # Longitudinal Data
#' snapshot <- Make_Snapshot()
#'
#' longitudinal <- Augment_Snapshot(
#'   snapshot,
#'   system.file("snapshots", "AA-AA-000-0000", package = "gsm")
#' )
#'
#' Study_Report(
#'   lAssessments = longitudinal$lStudyAssessResults,
#'   dfStudy = longitudinal$lSnapshot$status_study
#' )
#' }
#'
#' @importFrom rmarkdown render
#'
#' @export

Study_Report <- function(
  lAssessments,
  dfStudy = NULL,
  dfSite = NULL,
  strOutpath = NULL
) {
  if (is.null(strOutpath)) {
    strOutpath <- paste0(getwd(), "/gsm_report.html")
  }

  projectTemplate <- system.file("report", "KRIReport.Rmd", package = "gsm")
  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      assessment = lAssessments,
      status_study = dfStudy,
      status_site = dfSite
    ),
    envir = new.env(parent = globalenv())
  )
}
