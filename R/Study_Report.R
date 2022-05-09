#' Study Report
#'
#' Pulls needed study data and runs one or more assessments
#'
#' @param assessments character vector listing assessments
#' @param meta list of metadata related to study
#' @param outpath path to safe the report
#'
#' @export
#'
Study_Report <- function(assessments, meta, outpath = NULL) {
  if (is.null(outpath)) outpath <- paste0(getwd(), "/gsm_report.html")
  projectTemplate <- system.file("report", "studySummary.rmd", package = "gsm")
  rmarkdown::render(
    projectTemplate,
    output_file = outpath,
    params = list(
      assessments = assessments,
      meta = meta
    ),
    envir = new.env(parent = globalenv()) ## eval in child of global env
  )
}
