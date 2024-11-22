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

  report_path <- file.path("..", "reports", StudyID, GroupLevel, SnapshotDate)
  if (!dir.exists(report_path)) {
    dir.create(report_path, recursive = TRUE)
  }

  json_path <- file.path("..", "json")
  if (!dir.exists(json_path)) {
    dir.create(json_path, recursive = TRUE)
  }

  #metrics json
  metrics_info <- dfMetrics %>%
    mutate(
      id = .[["MetricID"]] %||% NA,
      abbreviation = .[["Abbreviation"]] %||% NA,
      label = .[["Metric"]] %||% NA
    ) %>%
    select(id, abbreviation, label) %>%
    split(., seq(nrow(.)))

  metrics_file <- file.path(json_path, "risk-signal-metrics.json")
  if (file.exists(metrics_file)) {
    existing_data <- fromJSON(metrics_file, simplifyVector = FALSE, simplifyDataFrame = FALSE)
    write_json(c(existing_data, metrics_info), path = metrics_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  } else {
    write_json(metrics_info, path = metrics_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  }

  # Convert study-level and groups-level data to JSON
  pivoted_groups <- dfGroups %>%
    pivot_wider(names_from = Param, values_from = Value)

  pivoted_groups_site <-  pivoted_groups %>%
    filter(GroupLevel == "Site")

  groups_info <- pivoted_groups_site %>%
    mutate(
      id = .[["invid"]] %||% NA,
      inv_first_name = .[["InvestigatorFirstName"]] %||% NA,
      inv_last_name = .[["InvestigatorLastName"]] %||% NA
    ) %>%
    select(id, inv_first_name, inv_last_name) %>%
    split(., seq(nrow(.)))

  groups_file <- file.path(json_path, "risk-signal-groups.json")
  if (file.exists(groups_file)) {
    existing_data <- fromJSON(groups_file, simplifyVector = FALSE, simplifyDataFrame = FALSE)
    write_json(c(existing_data, groups_info), path = groups_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  } else {
    write_json(groups_info, path = groups_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  }

  pivoted_groups_study <- pivoted_groups %>%
    filter(GroupLevel == "Study")

  study_info <- pivoted_groups_study %>%
    mutate(
      id = .[["StudyID"]] %||% NA,
      name = .[["nickname"]] %||% NA,
      title = .[["protocol_title"]] %||% NA,
      characteristics = list(list(
        status = .[["status"]] %||% NA, # datasim is lowercase; clindata is uppercase
        siteActivation = .[["SiteActivation"]] %||% NA,
        enrollment = .[["ParticipantEnrollment"]] %||% NA,
        fpfv = .[["act_fpfv"]] %||% NA,
        therapeuticArea = .[["therapeutic_area"]] %||% NA,
        indication = .[["protocol_indication"]] %||% NA,
        product = .[["product"]] %||% NA,
        phase = .[["phase"]] %||% NA,
        lpfv = .[["est_lpfv"]] %||% NA,
        lplv = .[["est_lplv"]] %||% NA
      ))
    ) %>%
    select(id, name, title, characteristics)

  study_file <- file.path(json_path, "study.json")
  if (file.exists(study_file)) {
    existing_data <- fromJSON(study_file, simplifyVector = FALSE, simplifyDataFrame = FALSE)
    write_json(c(existing_data, list(study_info)), path = study_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  } else {
    write_json(list(study_info), path = study_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  }
  #risk signals
  risk_signal_info <- dfResults %>%
    mutate(
      study_id = .[["StudyID"]] %||% NA,
      snapshot_date = .[["SnapshotDate"]] %||% NA,
      metric_id = .[["MetricID"]] %||% NA,
      group_id = .[["GroupID"]] %||% NA,
      flag = .[["Flag"]] %||% NA,
      ado_url = "tbd",
      status = "tbd",
      summary = "tbd",
      recommended_action = "tbd"
    ) %>%
    select(study_id, snapshot_date, metric_id, group_id, flag, ado_url, status, summary, recommended_action) %>%
    split(., seq(nrow(.)))

  risk_signal_file <- file.path(json_path, "risk-signal.json")
  if (file.exists(risk_signal_file)) {
    existing_data <- fromJSON(risk_signal_file, simplifyVector = FALSE, simplifyDataFrame = FALSE)
    write_json(c(existing_data, risk_signal_info), path = risk_signal_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  } else {
    write_json(risk_signal_info, path = risk_signal_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  }

  snapshot_info <- list(
    study_id = StudyID,
    module_slug = GroupLevel,
    snapshot_date = SnapshotDate
  )

  snapshot_file <- file.path(json_path, "snapshot.json")
  if (file.exists(snapshot_file)) {
    existing_data <- fromJSON(snapshot_file, simplifyVector = FALSE, simplifyDataFrame = FALSE)
    write_json(c(existing_data, list(snapshot_info)), path = snapshot_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
  } else {
    write_json(list(snapshot_info), path = snapshot_file, na = "null", pretty = TRUE, auto_unbox = TRUE)
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
    strOutputDir = normalizePath(report_path, mustWork = FALSE),
    lParams = list(
      lCharts = lCharts,
      dfResults = dfResults,
      dfGroups = dfGroups,
      dfMetrics = dfMetrics
    )
  )
}
