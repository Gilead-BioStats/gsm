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

  GroupLevel <- paste0("kri-", tolower(unique(dfMetrics$GroupLevel)))
  StudyID <- unique(dfResults$StudyID)
  SnapshotDate <- max(unique(dfResults$SnapshotDate))

  report_path <- file.path("reports", StudyID, GroupLevel, SnapshotDate)
  if (!dir.exists(report_path)) {
    dir.create(report_path, recursive = TRUE)
  }

  json_path <- "json"
  if (!dir.exists(json_path)) {
    dir.create(json_path, recursive = TRUE)
  }

  # Convert study-level data to JSON
  pivoted_groups <- dfGroups %>%
    pivot_wider(names_from = Param, values_from = Value) %>%
    filter(GroupLevel == "Study")

  json_list <- pivoted_groups %>%
    mutate(
      id = pivoted_groups[["StudyID"]] %||% NA,
      name = pivoted_groups[["nickname"]] %||% NA,
      title = pivoted_groups[["protocol_title"]] %||% NA,
      characteristics = list(list(
        status = pivoted_groups[["Status"]] %||% NA,
        siteActivation = if_else("num_site_actl" %in% names(pivoted_groups) & "num_plan_site" %in% names(pivoted_groups),
                                 paste0(round(100 * (as.numeric(pivoted_groups$num_site_actl) / as.numeric(pivoted_groups$num_plan_site))), "%"), NA),
        enrollment = if_else("num_enrolled_subj_m" %in% names(pivoted_groups) & "num_plan_subj" %in% names(pivoted_groups),
                             paste0(pivoted_groups$num_enrolled_subj_m, "/", pivoted_groups$num_plan_subj), NA),
        fpfv = pivoted_groups[["act_fpfv"]] %||% NA,
        therapeuticArea = pivoted_groups[["therapeutic_area"]] %||% NA,
        indication = pivoted_groups[["protocol_indication"]] %||% NA,
        product = pivoted_groups[["product"]] %||% NA,
        phase = pivoted_groups[["phase"]] %||% NA,
        lpfv = pivoted_groups[["act_lpfv"]] %||% NA,
        lplv = pivoted_groups[["act_lplv"]] %||% NA
      ))
    ) %>%
    select(id, name, title, characteristics)

  write_json(json_list, path = file.path(json_path, "study.json"), pretty = TRUE, auto_unbox = TRUE)

  #risk signals
  reporting <- dfResults %>%
    mutate(
      studyId = .[["StudyID"]] %||% NA,
      snapshotDate = .[["SnapshotDate"]] %||% NA,
      metricId = .[["MetricID"]] %||% NA,
      groupId = .[["GroupID"]] %||% NA,
      flag = .[["Flag"]] %||% NA,
      adoUrl = "tbd",
      status = "tbd",
      summary = "tbd",
      recommendedAction = "tbd"
    ) %>%
    select(studyId, snapshotDate, metricId, groupId, flag, adoUrl, status, summary, recommendedAction)

  write_json(reporting, path = file.path(json_path, "risk-signal.json"), pretty = TRUE, auto_unbox = TRUE)

  # Write module and snapshot JSON files
  study <- pivoted_groups$StudyID[1]
  modules <- list(
    list(studyId = study, slug = "kri-country", title = "KRI (by country)"),
    list(studyId = study, slug = "kri-site", title = "KRI (by site)")
  )
  write_json(modules, path = file.path(json_path, "module.json"), pretty = TRUE, auto_unbox = TRUE)

  new_entry <- list(
    studyId = StudyID,
    moduleSlug = GroupLevel,
    snapshotDate = SnapshotDate
  )

  snapshot_file <- file.path(json_path, "snapshot.json")
  if (file.exists(snapshot_file)) {
    existing_data <- fromJSON(snapshot_file, simplifyDataFrame = FALSE)
    write_json(c(existing_data, list(new_entry)), path = snapshot_file, pretty = TRUE, auto_unbox = TRUE)
  } else {
    write_json(list(new_entry), path = snapshot_file, pretty = TRUE, auto_unbox = TRUE)
  }

  # set output path
  if (is.null(strOutputFile)) {
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
    strOutputDir = file.path(strOutputDir, report_path),
    lParams = list(
      lCharts = lCharts,
      dfResults = dfResults,
      dfGroups = dfGroups,
      dfMetrics = dfMetrics
    )
  )
}
