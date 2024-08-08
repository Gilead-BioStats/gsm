#' Report_KRI function
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' This function generates a KRI report based on the provided inputs.
#'
#' @inheritParams shared-params
#' @param lCharts A list of charts to include in the report.
#' @param strOutputDir The output directory path for the generated report. If not provided,
#'  the report will be saved in the current working directory.
#' @param strOutputFile The output file name for the generated report. If not provided,
#'  the report will be named based on the study ID, Group Level and Date.
#'
#' @return None
#' @examples
#' \dontrun{
#' # Run reports
#' lCharts <- MakeCharts(
#'   dfResults = reportingResults,
#'   dfGroups = reportingGroups,
#'   dfMetrics = reportingMetrics,
#'   dfBounds = reportingBounds
#' )
#'
#' strOutputFile <- "StandardSiteReport.html"
#' Report_KRI(
#'   lCharts = lCharts,
#'   dfResults = reportingResults,
#'   dfGroups = reportingGroups,
#'   dfMetrics = reportingMetrics,
#'   strOutputFile = strOutputFile
#' )
#' }
#'
#' @keywords KRI report
#' @export
#'

Report_KRI <- function(
  lCharts = NULL,
  dfResults = NULL,
  dfGroups = NULL,
  dfMetrics = NULL,
  strOutputDir = fs::path_abs("."), ## or just use getwd() to remove a dependency...
  strOutputFile = NULL
) {
  rlang::check_installed("rmarkdown", reason = "to run `Report_KRI()`")
  rlang::check_installed("knitr", reason = "to run `Report_KRI()`")
  rlang::check_installed("kableExtra", reason = "to run `Report_KRI()`")

  # set output path
  if (is.null(strOutputFile)) {
    GroupLevel <- unique(dfMetrics$GroupLevel)
    StudyID <- unique(dfResults$StudyID)
    SnapshotDate <- max(unique(dfResults$SnapshotDate))
    if (length(GroupLevel == 1) & length(StudyID) == 1) {
      # remove non alpha-numeric characters from StudyID, GroupLevel and SnapshotDate
      StudyID <- gsub("[^[:alnum:]]", "", StudyID)
      GroupLevel <- gsub("[^[:alnum:]]", "", GroupLevel)
      SnapshotDate <- gsub("[^[:alnum:]]", "", as.character(SnapshotDate))

      strOutpath <- file.path(strOutputDir, paste0("kri_report_", StudyID, "_", GroupLevel, "_", SnapshotDate, ".html"))
    } else {
      strOutpath <- file.path(strOutputDir, "kri_report.html")
    }
  } else {
    strOutpath <- file.path(strOutputDir, strOutputFile)
  }

  #specify report path, depending on write access to strOutputDir
  if (file.access(strOutputDir, mode = 2)) {
    tpath <- fs::path_temp()
    report_path <- file.path(tpath, "Report_KRI.Rmd")
    fs::file_copy(system.file("report", "Report_KRI.Rmd", package = "gsm"), report_path)
    # currently report_kri also needs a styles.css dep
    fs::file_copy(system.file("report", "styles.css", package = "gsm"), file.path(tpath, "styles.css"))
  }
  else {
    report_path <- system.file("report", "Report_KRI.Rmd", package = "gsm")
  }

  rmarkdown::render(
    report_path,
    output_file = strOutpath,
    params = list(
      lCharts = lCharts,
      dfResults = dfResults,
      dfGroups = dfGroups,
      dfMetrics = dfMetrics
    ),
    envir = new.env(parent = globalenv())
  )
}
