#' Report_KRI function
#'
#' `r lifecycle::badge("stable")`
#'
#' This function generates a KRI report based on the provided inputs.
#'
#' @inheritParams shared-params
#' @param lCharts A list of charts to include in the report.
#' @param strOutpath The output path for the generated report. If not provided, the report will be saved in the current working directory with the name "kri_report.html".
#'
#' @return None
#' @examples
#'  \dontrun{
#' # Run reports
#' lCharts <- MakeCharts(
#'   dfResults = reportingResults,
#'   dfGroups = reportingGroups,
#'   dfMetrics = reportingMetrics,
#'   dfBounds = reportingBounds
#' )
#'
#' strOutpath <- "StandardSiteReport.html"
#' Report_KRI(
#'   lCharts = lCharts,
#'   dfResults =  reportingResults,
#'   dfGroups =  reportingGroups,
#'   dfMetrics = reportingMetrics
#'   strOutpath = strOutpath
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
  strOutpath = NULL
) {
  rlang::check_installed("rmarkdown", reason = "to run `Report_KRI()`")
  rlang::check_installed("knitr", reason = "to run `Report_KRI()`")
  rlang::check_installed("kableExtra", reason = "to run `Report_KRI()`")

  # set output path
  if (is.null(strOutpath)) {
    GroupLevel <- unique(dfMetrics$GroupLevel)
    StudyID <- unique(dfResults$StudyID)
    SnapshotDate <- max(unique(dfResults$SnapshotDate))
    if(length(GroupLevel==1) & length(StudyID)==1){
      #remove non alpha-numeric characters from StudyID, GroupLevel and SnapshotDate
      StudyID <- gsub("[^[:alnum:]]", "", StudyID)
      GroupLevel <- gsub("[^[:alnum:]]", "", GroupLevel)
      SnapshotDate <- gsub("[^[:alnum:]]", "", as.character(SnapshotDate))

      strOutpath <- paste0(getwd(), "/kri_report_", StudyID, "_", GroupLevel, "_", SnapshotDate, ".html")
    }else{
      strOutpath <- paste0(getwd(), "/kri_report.html")
    }
  }

  rmarkdown::render(
    system.file("report", "Report_KRI.Rmd", package = "gsm"),
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
