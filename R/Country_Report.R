#' `r lifecycle::badge("experimental")`
#'
#' Country Report
#'
#' Create country-level HTML summary report using the results of `Study_Assess`, including tables, charts, and error checking.
#'
#' @param lAssessments `list` The results of multiple assessments run using `Study_Assess`.
#' @param strOutpath `character` File path; location where the report will be saved.
#'
#' @return HTML report of study data.
#'
#' @examples
#' \dontrun{
#' # Using `Study_Assess()`
#' study <- Study_Assess()
#' Country_Report(study)
#' }
#'
#' @importFrom rmarkdown render
#'
#' @export

Country_Report <- function(
    lAssessments,
    strOutpath = NULL
) {
  if (is.null(strOutpath)) {
    strOutpath <- paste0(getwd(), "/gsm_country_report.html")
  }

  projectTemplate <- system.file("report", "CountryReport.Rmd", package = "gsm")
  rmarkdown::render(
    projectTemplate,
    output_file = strOutpath,
    params = list(
      assessment = lAssessments
    ),
    envir = new.env(parent = globalenv())
  )
}
