#' Make Snapshot - create and export data model.
#'
#' `r lifecycle::badge("stable")`
#'
#' @description
#' `Make_Snapshot()` ingests data from a variety of sources, and runs KRIs and/or QTLs based on the `list` provided in `lAssessments`.
#'
#' For more context about the inputs and outputs of `Make_Snapshot()`, refer to the [GSM Data Pipeline Vignette](https://gilead-biostats.github.io/gsm/articles/DataPipeline.html), specifically
#' Appendix 2 - Data Model Specifications
#'
#' @param lMeta `list` a named list of data frames containing metadata, configuration, and workflow parameters for a given study.
#' See the Data Model Vignette - Appendix 2 - Data Model Specifications for detailed specifications.
#' @param lData `list` a named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column. Default: package-defined mapping for raw+.
#' @param lAssessments `list` a named list of metadata defining how each assessment should be run. By default, `MakeWorkflowList()` imports YAML specifications from `inst/workflow`.
#' @param lPrevSnapshot `list` optional argument for the previous snapshot run to track longitudinal data,
#' @param append_files `vector` a vector or log files to append, defaults to all log files from `lPrevSnapshot` argument
#' @param strAnalysisDate `character` date that the data was pulled/wrangled/snapshot. Note: date should be provided in format: `YYYY-MM-DD`.
#' @param bMakeCharts `logical` Boolean value indicating whether to create charts.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`.
#'
#' @includeRmd ./man/md/Make_Snapshot.md
#'
#' @return `list` `lSnapshot`, a named list with a data.frame for each component of the {gsm} data model.
#' - `status_workflow`
#' - `rpt_site_details`
#' - `rpt_study_details`
#' - `rpt_kri_details`
#' - `rpt_qtl_details`
#' - `rpt_site_kri_details`
#' - `rpt_kri_bounds_details`
#' - `rpt_qtl_threshold_param`
#' - `rpt_kri_threshold_param`
#' - `rpt_qtl_analysis`
#'
#' @examples
#' # run with default testing data
#' \dontrun{
#' snapshot <- Make_Snapshot()
#' }
#'
#' @import purrr
#' @importFrom cli cli_alert_warning
#' @importFrom tidyr pivot_longer
#' @importFrom utils write.csv
#' @importFrom yaml read_yaml
#'
#' @export
Make_Snapshot <- function(
    lMeta = list(
      config_param = gsm::config_param,
      config_workflow = gsm::config_workflow,
      meta_params = gsm::meta_param,
      meta_site = clindata::ctms_site,
      meta_study = clindata::ctms_study,
      meta_workflow = gsm::meta_workflow
    ),
    lData = list(
      dfSUBJ = clindata::rawplus_dm,
      dfAE = clindata::rawplus_ae,
      dfPD = clindata::ctms_protdev,
      dfCONSENT = clindata::rawplus_consent,
      dfIE = clindata::rawplus_ie,
      dfLB = clindata::rawplus_lb,
      dfSTUDCOMP = clindata::rawplus_studcomp,
      dfSDRGCOMP = clindata::rawplus_sdrgcomp %>%
        filter(.data$phase == "Blinded Study Drug Completion"),
      dfDATACHG = clindata::edc_data_points,
      dfDATAENT = clindata::edc_data_pages,
      dfQUERY = clindata::edc_queries,
      dfENROLL = clindata::rawplus_enroll
    ),
    lMapping = Read_Mapping(),
    lAssessments = MakeWorkflowList(lMeta = lMeta),
    lPrevSnapshot = NULL,
    append_files = names(lPrevSnapshot$lSnapshot),
    strAnalysisDate = NULL,
    bMakeCharts = TRUE,
    bQuiet = TRUE
) {
  # run Study_Assess() ------------------------------------------------------
  lResults <- gsm::Study_Assess(
    lData = lData,
    lMapping = lMapping,
    lAssessments = lAssessments,
    bQuiet = bQuiet
  ) %>%
    UpdateLabels(lMeta$meta_workflow)

  # map ctms data -----------------------------------------------------------
  status_study <- Study_Map_Raw(
    dfs = list(
      dfSTUDY = lMeta$meta_study,
      dfSUBJ = lData$dfSUBJ
    ),
    lMapping = lMapping,
    dfConfig = lMeta$config_param
  )

  # ctms_site / meta_site:
  status_site <- Site_Map_Raw(
    dfs = list(
      dfSITE = lMeta$meta_site,
      dfSUBJ = lData$dfSUBJ
    ),
    lMapping = lMapping,
    dfConfig = lMeta$config_param
  )

  # create `gsm_analysis_date` ----------------------------------------------
  gsm_analysis_date <- MakeAnalysisDate(
    strAnalysisDate = strAnalysisDate,
    bQuiet = bQuiet
  )

  # create lSnapshot --------------------------------------------------------
  lSnapshot <- list(
    rpt_site_details = MakeRptSiteDetails(lResults, status_site, gsm_analysis_date),
    rpt_study_details = MakeRptStudyDetails(lResults, status_study, gsm_analysis_date),
    rpt_qtl_details = MakeRptQtlDetails(lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date),
    rpt_kri_details = MakeRptKriDetails(lResults, status_site, lMeta$meta_workflow, gsm_analysis_date),
    rpt_site_kri_details = MakeRptSiteKriDetails(lResults, status_site, lMeta$meta_workflow, lMeta$meta_params, gsm_analysis_date),
    rpt_kri_bounds_details = MakeRptKriBoundsDetails(lResults, lMeta$config_param, gsm_analysis_date),
    rpt_qtl_threshold_param = MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, gsm_analysis_date, type = "qtl"),
    rpt_kri_threshold_param = MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, gsm_analysis_date, type = "kri"),
    rpt_qtl_analysis = MakeRptQtlAnalysis(lResults, lMeta$config_param, gsm_analysis_date)
  ) %>%
    purrr::keep(~ !is.null(.x)) %>%
    purrr::map(~ .x %>% mutate(gsm_analysis_date = gsm_analysis_date))

  # create `status_workflow` ------------------------------------------------
  lSnapshot[["status_workflow"]] <- MakeStatusWorkflow(lResults = lResults, dfConfigWorkflow = lMeta$config_workflow) %>%
    left_join(ExtractFlags(AppendDroppedWorkflows(lPrevSnapshot, lResults), group = "kri"), by = c("workflowid" = "kri_id")) %>%
    rename("amber_flags" = "num_of_sites_at_risk",
           "red_flags" = "num_of_sites_flagged") %>%
    mutate(snapshot_date = gsm_analysis_date,
           gsm_analysis_date = gsm_analysis_date) %>%
    replace_na(replace = list("amber_flags" = 0, "red_flags" = 0))

  # create `lStackedSnapshots` ----------------------------------------------
  lStackedSnapshots <- AppendLogs(lPrevSnapshot, lSnapshot, append_files)


  # create lCharts ----------------------------------------------------------



  if (bMakeCharts) {
    lCharts <- purrr::map(lResults, function(x) {

      if (!grepl("qtl", x$name)) {
        MakeKRICharts(lData = x$lResults$lData)
      } else {

        browser()

        # this will be a function eventually
        list(
          timeseriesQtl = Widget_TimeSeriesQTL(qtl = x$name,
                                               raw_results = lStackedSnapshots$rpt_site_kri_details,
                                               raw_workflow = lStackedSnapshots$rpt_kri_details,
                                               raw_param = lStackedSnapshots$rpt_kri_threshold_param,
                                               raw_analysis = lStackedSnapshots$rpt_qtl_analysis)
        )

      }

    }) %>%
      purrr::discard(is.null)
  }

  # build output ---------------------------------------------------------------

  # create `status_workflow` ------------------------------------------------
  workflow_history <- MakeWorkflowHistory(lStackedSnapshots)
  if(is.data.frame(workflow_history)){
    lSnapshot[["status_workflow"]] <- lSnapshot[["status_workflow"]] %>%
      full_join(MakeWorkflowHistory(lStackedSnapshots), by = c("workflowid" = "kri_id"))
  }

  # build output ------------------------------------------------------------

  snapshot <- list(
    lSnapshotDate = gsm_analysis_date,
    lSnapshot = lSnapshot,
    lStudyAssessResults = AppendDroppedWorkflows(lPrevSnapshot, lResults),
    lCharts = lCharts,
    lInputs = list(
      lMeta = lMeta,
      lData = lData,
      lMapping = lMapping,
      lAssessments = lAssessments
    ),
    lStackedSnapshots = lStackedSnapshots
  )

  # return snapshot ------------------------------------------------------------

  return(snapshot)
}
