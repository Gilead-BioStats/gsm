#' Function to revert to 1.8 data model
#'
#' @param lSnapshot `list` the snapshot object to revert
#' @param lMeta `list` the meta data to use for reversion
#' @param lData `list` the data to use for reversion
#' @param lMapping `list` the mapping to use for reversion
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @keywords internal
#' @export
#'
#'
RevertSnapshotLogs <- function(lSnapshot, lMeta = NULL, lData = NULL, lMapping = NULL, bQuiet = TRUE){
  # Define StudyAssessResults
  lStudyAssessResults <- lSnapshot$lStudyAssessResults

  # Define lMeta if NULL
  if(is.null(lMeta) & "lInputs" %in% names(lSnapshot)){
    lMeta <- lSnapshot$lInputs$lMeta

  } else if(is.null(lMeta) & !"lInputs" %in% names(lSnapshot)){
    lMeta <- gsm::UseClindata(
      list(
        "config_param" = "gsm::config_param",
        "config_workflow" = "gsm::config_workflow",
        "meta_params" = "gsm::meta_param",
        "meta_site" = "clindata::ctms_site",
        "meta_study" = "clindata::ctms_study",
        "meta_workflow" = "gsm::meta_workflow"
      )
    )
  }

  # Define lMeta if NULL
  if(is.null(lMapping) & "lInputs" %in% names(lSnapshot)){
    lMapping <- lSnapshot$lInputs$lMapping

  } else if(is.null(lMeta) & !"lInputs" %in% names(lSnapshot)){
    lMapping <- Read_Mapping()
  }

  # Define lData if NULL
  if(is.null(lData) & "lInputs" %in% names(lSnapshot)){
    lData <- lSnapshot$lInputs$lData
  } else if(is.null(lData) & !"lInputs" %in% names(lSnapshot)){
    lData <- gsm::UseClindata(
      list(
        "dfSUBJ" = "clindata::rawplus_dm",
        "dfAE" = "clindata::rawplus_ae",
        "dfPD" = "clindata::ctms_protdev",
        "dfCONSENT" = "clindata::rawplus_consent",
        "dfIE" = "clindata::rawplus_ie",
        "dfLB" = "clindata::rawplus_lb",
        "dfSTUDCOMP" = "clindata::rawplus_studcomp",
        "dfSDRGCOMP" = "clindata::rawplus_sdrgcomp %>%
      filter(.data$phase == 'Blinded Study Drug Completion')",
      "dfDATACHG" = "clindata::edc_data_points",
      "dfDATAENT" = "clindata::edc_data_pages",
      "dfQUERY" = "clindata::edc_queries",
      "dfENROLL" = "clindata::rawplus_enroll"
      )
    )
  }

  # results_analysis --------------------------------------------------------
  # -- check if any workflows in `lStudyAssessResults` start with "qtl"
  if (length(grep("qtl", names(lStudyAssessResults))) > 0) {
    results_analysis <- MakeResultsAnalysis(lStudyAssessResults)

  } else {
    results_analysis <- data.frame(
      studyid = NA,
      workflowid = NA,
      param = NA,
      value = NA,
      gsm_analysis_date = NA
    )
  }

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
    strAnalysisDate = lSnapshot$lSnapshotDate,
    bQuiet = bQuiet
  )

  # create lSnapshot --------------------------------------------------------
  old_lSnapshot <- list(
    status_study = status_study,
    status_site = status_site,
    status_workflow = MakeStatusWorkflow(lResults = lStudyAssessResults, dfConfigWorkflow = lMeta$config_workflow),
    status_param = lMeta$config_param,
    results_summary = MakeResultsSummary(lResults = lStudyAssessResults, dfConfigWorkflow = lMeta$config_workflow),
    results_analysis = results_analysis,
    results_bounds = MakeResultsBounds(lResults = lStudyAssessResults, dfConfigWorkflow = lMeta$config_workflow),
    meta_workflow = lMeta$meta_workflow,
    meta_param = lMeta$meta_params
  ) %>%
    purrr::keep(~ !is.null(.x)) %>%
    purrr::map(~ .x %>% mutate(gsm_analysis_date = lSnapshot$lSnapshotDate))

  lSnapshot$lSnapshot <- old_lSnapshot

  return(lSnapshot)
}
















