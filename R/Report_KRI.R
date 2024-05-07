#' Report_KRI function
#'
#' This function generates a KRI report based on the provided inputs.
#'
#' @param lCharts A list of charts to include in the report.
#' @param dfSummary A data frame containing summary information.
#' @param dfStudy A data frame containing study metadata (e.g., from CTMS).
#' @param dfSite A data frame containing site metadata (e.g., from CTMS).
#' @param dfMetrics A data frame containing metric metadata (e.g., from workflows).
#' @param strOutpath The output path for the generated report. If not provided, the report will be saved in the current working directory with the name "kri_report.html".
#'
#' @return None

#' @keywords KRI report
#' @export
#'

Report_KRI <- function(
  lCharts = NULL,
  dfSummary = NULL,
  dfStudy = NULL,
  dfSite = NULL,
  dfMetrics = NULL,
  strOutpath = NULL
) {
  rlang::check_installed("rmarkdown", reason = "to run `Report_KRI()`")
  rlang::check_installed("knitr", reason = "to run `Report_KRI()`")
  rlang::check_installed("kableExtra", reason = "to run `Report_KRI()`")

  # set output path
  if (is.null(strOutpath)) { strOutpath <- paste0(getwd(), "/kri_report.html") }


  rmarkdown::render(
    system.file("report", "Report_KRI.Rmd", package = "gsm"),
    output_file = strOutpath,
    params = list(
      lCharts = lCharts,
      dfSummary = dfSummary,
      dfSite = dfSite,
      dfStudy = dfStudy,
      dfMetrics = dfMetrics,
      lCharts = lCharts
    ),
    envir = new.env(parent = globalenv())
  )
}
