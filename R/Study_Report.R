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
#' @param strReportType `character` The type of report to be generated. Valid values:
#'   - `"site"` for site-level KRI summary (default)
#'   - `"country"` for country-level KRI summary
#'
#' @return HTML report of study data.
#'
#' @examples
#' \dontrun{
#' # Using `Study_Assess()`
#' study <- Study_Assess()
#' Study_Report(study)
#' Study_Report(study, strReportType = "country")
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
  strOutpath = NULL,
  strReportType = "site"
) {
  # input check
  stopifnot(
    "strReportType is not 'site' or 'country'" = strReportType %in% c("site", "country"),
    "strReportType must be length 1" = length(strReportType) == 1
  )

  # set output path
  if (is.null(strOutpath) & strReportType == "site") {
    strOutpath <- paste0(getwd(), "/gsm_site_report.html")
  } else if (is.null(strOutpath) & strReportType == "country") {
    strOutpath <- paste0(getwd(), "/gsm_country_report.html")
  }

  # set Rmd template
  if (strReportType == "site") {
    projectTemplate <- system.file("report", "KRIReportBySite.Rmd", package = "gsm")
  } else if (strReportType == "country") {
    projectTemplate <- system.file("report", "KRIReportByCountry.Rmd", package = "gsm")
  }

  # render
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
