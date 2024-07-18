#' Report_KRI function
#'
#' This function generates a KRI report based on the provided inputs.
#'
#' @inheritParams shared-params
#' @param lCharts A list of charts to include in the report.
#' @param dfResults A data frame containing result information.
#' @param dfGroups A data frame containing study/site metadata (e.g., from CTMS).
#' @param strOutpath The output path for the generated report. If not provided, the report will be saved in the current working directory with the name "kri_report.html".
#'
#' @return None
#' @examples
#'  \dontrun{
#' wf_mapping <- MakeWorkflowList(strNames="mapping")
#' wf_metrics <- MakeWorkflowList(strNames=paste0("kri",sprintf("%04d", 1:12)))
#' dfMetrics <- wf_metrics %>% purrr::map_df(~.x$meta)
#'
#' # Import Site+Study Metadata
#' dfStudy<-clindata::ctms_study %>% dplyr::rename(StudyID = protocol_number)
#' dfSite<- clindata::ctms_site %>% dplyr::rename(SiteID = site_num)
#'
#' # Pull Raw Data - this will overwrite the previous data pull
#' lRaw <- UseClindata(
#'   list(
#'     "dfSUBJ" = "clindata::rawplus_dm",
#'     "dfAE" = "clindata::rawplus_ae",
#'     "dfPD" = "clindata::ctms_protdev",
#'     "dfLB" = "clindata::rawplus_lb",
#'     "dfSTUDCOMP" = "clindata::rawplus_studcomp",
#'     "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp",
#'     "dfDATACHG" = "clindata::edc_data_points",
#'     "dfDATAENT" = "clindata::edc_data_pages",
#'     "dfQUERY" = "clindata::edc_queries",
#'     "dfENROLL" = "clindata::rawplus_enroll"
#'   )
#' )
#'
#' # Create Mapped Data
#' lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lRaw)$lData
#'
#' # Run Metrics
#' lResults <-map(wf_metrics, ~RunWorkflow(lWorkflow = ., lData = lMapped))
#'
#' dfBounds <- lResults %>%
#'   purrr::imap_dfr(~.x$lData$dfBounds %>%
#'   dplyr::mutate(MetricID = .y)) %>%
#'   dplyr::mutate(StudyID = "ABC-123",
#'     SnapshotDate = Sys.Date())
#'
#' dfSummary <- lResults %>%
#'   purrr::imap_dfr(~.x$lData$dfSummary %>%
#'   dplyr::mutate(MetricID = .y)) %>%
#'   dplyr::mutate(StudyID = "ABC-123",
#'     SnapshotDate = Sys.Date())
#'
#' # Create charts
#' lCharts <- unique(dfSummary$MetricID) %>% purrr::map(~Visualize_Metric(
#'   dfSummary = dfSummary,
#'   dfBounds = dfBounds,
#'   dfSite = dfSite,
#'   dfMetrics = dfMetrics,
#'   strMetricID = .x
#' )
#' ) %>% stats::setNames(unique(dfSummary$MetricID))
#'
#' # Run reports
#' strOutpath <- "StandardSiteReport.html"
#' Report_KRI(
#'   lCharts = lCharts,
#'   dfSummary = dfSummary,
#'   dfSite = dfSite,
#'   dfStudy = dfStudy,
#'   dfMetrics =dfMetrics,
#'   strOutpath = strOutpath
#'   )
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
  if (is.null(strOutpath)) { strOutpath <- paste0(getwd(), "/kri_report.html") }


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
