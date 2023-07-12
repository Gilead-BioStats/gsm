#' `r lifecycle::badge("stable")`
#'
#' Make Snapshot - create and export data model.
#'
#' @description
#' `Make_Snapshot()` ingests data from a variety of sources, and runs KRIs and/or QTLs based on the `list` provided in `lAssessments`.
#'
#' For more context about the inputs and outputs of `Make_Snapshot()`, refer to the [GSM Data Pipeline Vignette](https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html), specifically
#' Appendix 2 - Data Model Specifications
#'
#' @param lMeta `list` a named list of data frames containing metadata, configuration, and workflow parameters for a given study.
#' See the Data Model Vignette - Appendix 2 - Data Model Specifications for detailed specifications.
#' @param lData `list` a named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column. Default: package-defined mapping for raw+.
#' @param lAssessments `list` a named list of metadata defining how each assessment should be run. By default, `MakeWorkflowList()` imports YAML specifications from `inst/workflow`.
#' @param strAnalysisDate `character` date that the data was pulled/wrangled/snapshot. Note: date should be provided in format: `YYYY-MM-DD`.
#' @param bUpdateParams `logical` if `TRUE`, configurable parameters found in `lMeta$config_param` will overwrite the default values in `lMeta$meta_params`. Default: `FALSE`.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`.
#'
#' @includeRmd ./man/md/Make_Snapshot.md
#'
#' @return `list` `lSnapshot`, a named list with a data.frame for each component of the {gsm} data model.
#' - `status_study`
#' - `status_site`
#' - `status_workflow`
#' - `status_param`
#' - `results_summary`
#' - `results_analysis`
#' - `results_bounds`
#' - `meta_workflow`
#' - `meta_param`
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
  lAssessments = NULL,
  strAnalysisDate = NULL,
  bUpdateParams = FALSE,
  bQuiet = TRUE
) {

# rename GILDA to expected gsm variable names -----------------------------
  # ctms_study / meta_study:
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

  # run Study_Assess() ------------------------------------------------------
  # Make a list of assessments
  # Need to update this to use the relevant items from lMeta (meta_workflow, meta_params, config_workflow and config_params)
  if (is.null(lAssessments)) {
    # if assessment list is not passed in, derive workflow from `lMeta$config_workflow`
    lAssessments <- gsm::MakeWorkflowList(strNames = c(unique(lMeta$config_workflow$workflowid)))
  }

  # update parameters
  if (bUpdateParams) {
    # TODO: Add vignette about updating values
    lAssessments <- UpdateParams(lAssessments, lMeta$config_param, lMeta$meta_params)
  }

  # Run Study Assessment
  lResults <- gsm::Study_Assess(
    lData = lData,
    lMapping = lMapping,
    lAssessments = lAssessments,
    bQuiet = bQuiet
  ) %>%
    UpdateLabels(lMeta$meta_workflow)

  # results_analysis ---------------------------------------------------------

  hasQTL <- grep("qtl", names(lResults))

  if (length(hasQTL) > 0) {
    results_analysis <- MakeResultsAnalysis(lResults)
  } else {
    results_analysis <- NULL
  }


  # results_bounds ----------------------------------------------------------
  results_bounds <- lResults %>%
    purrr::map(~ .x$lResults$lData$dfBounds) %>%
    purrr::discard(is.null)

  if (length(results_bounds) > 0) {
    results_bounds <- results_bounds %>%
      purrr::imap_dfr(~ .x %>% mutate(workflowid = .y)) %>%
      mutate(studyid = unique(lMeta$config_workflow$studyid)) %>% # not sure if this is a correct assumption
      select(
        "studyid",
        "workflowid",
        "threshold" = "Threshold",
        "numerator" = "Numerator",
        "denominator" = "Denominator",
        "log_denominator" = "LogDenominator"
      )
  } else {
    results_bounds <- results_bounds %>%
      as_tibble()
  }


  # create analysis date ----------------------------------------------------
  gsm_analysis_date <- MakeAnalysisDate(
    strAnalysisDate = strAnalysisDate,
    bQuiet = bQuiet
  )

  # create lSnapshot --------------------------------------------------------
  lSnapshot <- list(
    status_study = status_study,
    status_site = status_site,
    status_workflow = MakeStatusWorkflow(lResults = lResults, dfConfigWorkflow = lMeta$config_workflow),
    status_param = lMeta$config_param,
    results_summary = MakeResultsSummary(lResults = lResults, dfConfigWorkflow = lMeta$config_workflow),
    results_analysis = results_analysis,
    results_bounds = results_bounds,
    meta_workflow = lMeta$meta_workflow,
    meta_param = lMeta$meta_params
  ) %>%
    purrr::keep(~ !is.null(.x)) %>%
    purrr::map(~ .x %>% mutate(gsm_analysis_date = gsm_analysis_date))


  return(
    list(
      lSnapshotDate = gsm_analysis_date,
      lSnapshot = lSnapshot,
      lStudyAssessResults = lResults
    )
  )
}
