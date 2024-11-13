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
#' @return File path of the saved report html is returned invisibly. Save to object to view absolute output path.
#' @examples
#' \dontrun{
#' # Run site-level KRI report.
#' lChartsSite <- MakeCharts(
#'   dfResults = reportingResults,
#'   dfGroups = reportingGroups,
#'   dfMetrics = reportingMetrics,
#'   dfBounds = reportingBounds
#' )
#'
#' strOutputFile <- "StandardSiteReport.html"
#' kri_report_path <- Report_KRI(
#'   lCharts = lChartsSite,
#'   dfResults = reportingResults,
#'   dfGroups = reportingGroups,
#'   dfMetrics = reportingMetrics,
#'   strOutputFile = strOutputFile
#' )
#'
#' # Run country-level KRI report.
#' lChartsCountry <- MakeCharts(
#'   dfResults = reportingResults_country,
#'   dfGroups = reportingGroups_country,
#'   dfMetrics = reportingMetrics_country,
#'   dfBounds = reportingBounds_country
#' )
#'
#' strOutputFile <- "StandardCountryReport.html"
#' kri_report_path <- Report_KRI(
#'   lCharts = lChartsCountry,
#'   dfResults = reportingResults_country,
#'   dfGroups = reportingGroups_country,
#'   dfMetrics = reportingMetrics_country,
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
  strOutputDir = getwd(),
  strOutputFile = NULL
) {
  rlang::check_installed("rmarkdown", reason = "to run `Report_KRI()`")
  rlang::check_installed("knitr", reason = "to run `Report_KRI()`")

  # set output path
  if (is.null(strOutputFile)) {
    GroupLevel <- unique(dfMetrics$GroupLevel)
    StudyID <- unique(dfResults$StudyID)
    SnapshotDate <- max(unique(dfResults$SnapshotDate))
    path <- file.path("reports", StudyID, paste0("kri-", tolower(GroupLevel)), SnapshotDate)

    if (!dir.exists(path)) {
      dir.create(path, recursive = TRUE)
    }

    new_entry <- list(
      studyId = StudyID,
      moduleSlug = paste0("kri-", tolower(GroupLevel)),
      snapshotDate = SnapshotDate
    )

    # Check if the file "snapshot.json" exists
    json_file <- "json/snapshot.json"
    if (file.exists(json_file)) {
      # Read existing JSON file and append new entry
      existing_data <- fromJSON(json_file, simplifyDataFrame = FALSE)
      updated_data <- c(existing_data, list(new_entry))
    } else {
      # If file doesn't exist, start with the new entry
      updated_data <- list(new_entry)
    }

    write(toJSON(updated_data, pretty = TRUE, auto_unbox = TRUE), file = json_file)

    if (length(GroupLevel == 1) & length(StudyID) == 1) {
      # remove non alpha-numeric characters from StudyID, GroupLevel and SnapshotDate
      StudyID <- gsub("[^[:alnum:]]", "", StudyID)
      GroupLevel <- gsub("[^[:alnum:]]", "", GroupLevel)
      SnapshotDate <- gsub("[^[:alnum:]]", "", as.character(SnapshotDate))

      strOutputFile <- paste0("kri_report_", StudyID, "_", GroupLevel, "_", SnapshotDate, ".html")
    } else {
      strOutputFile <- "kri_report.html"
    }
  }

  RenderRmd(
    strInputPath = system.file("report", "Report_KRI.Rmd", package = "gsm"),
    strOutputFile = "index.html",
    strOutputDir = file.path(getwd(),path),
    lParams = list(
      lCharts = lCharts,
      dfResults = dfResults,
      dfGroups = dfGroups,
      dfMetrics = dfMetrics
    )
  )
}
