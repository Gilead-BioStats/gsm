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
#' lRaw <- gsm::UseClindata(
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
#' lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lRaw)$mapping$lResults
#'
#' # Run Metrics
#' lResults <-RunWorkflow(lWorkflow = wf_metrics, lData = lMapped)
#'
#' dfBounds <- lResults %>%
#'   purrr::imap_dfr(~.x$lResults$dfBounds %>%
#'   dplyr::mutate(MetricID = .y)) %>%
#'   dplyr::mutate(StudyID = "ABC-123",
#'     SnapshotDate = Sys.Date())
#'
#' dfSummary <- lResults %>%
#'   purrr::imap_dfr(~.x$lResults$dfSummary %>%
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
