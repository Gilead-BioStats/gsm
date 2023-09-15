#' Make Snapshot
#'
#' @param lAssessment `list`
#' @param lSnapshotPrevious `list`
#' @param lMeta `list`
#' @param lData `list`
#'
#' @return `list`
#'
#' @examples
#' \dontrun{
#' lSnapshot <- Make_Snapshot()
#' }
#'
#' @export
Make_Snapshot <- function(
    lAssessment,
    lSnapshotPrevious = NULL,
    strAnalysisDate = NULL,
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
    lAssessments = MakeWorkflowList(lMeta = lMeta)
) {


# create `gsm_analysis_date` ----------------------------------------------
# -- validates that date is in correct format: yyyy-mm-dd
  gsm_analysis_date <- MakeAnalysisDate(
    strAnalysisDate = strAnalysisDate
  )


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

# update data viz labels/metadata -----------------------------------------
  lAssessment <- UpdateLabels(lAssessment, lMeta$meta_workflow)

  # save all figures in the snapshot
  lFigures <- purrr::map(lAssessment, ~ .x$lResults$lCharts)

# add result logs ---------------------------------------------------------
# -- results_summary_log stacks all result_summary files from all snapshots.
# -- basically just row_bind lSnapshot_prev$results_summary_log and new results_summary
# -- probably also need a results_analysis_log
# -- honestly, I guess we could create {domain}_log for all of the files in the snapshot model.
# -- Seems a little bit like overkill, but wouldn't be hard and would make us quite future proof ...
log <- dplyr::lst(
  results_summary_log = MakeResultsSummaryLog(lAssessment),
  results_analysis_log = MakeResultsAnalysisLog(lAssessment),
  results_bounds_log = MakeResultsBoundsLog(lAssessment),
  meta_workflow = lMeta$meta_workflow,
  meta_params = lMeta$meta_params,
  status_param = lMeta$config_param
) %>%
    purrr::map(~.x %>% mutate(
      gsm_analysis_date = gsm_analysis_date
    ))

# augment snapshot --------------------------------------------------------
# incorporate augment_snapshot functionality in to make_snapshot then delete that function.
if (!is.null(lSnapshotPrevious)) {
  log <- purrr::map2(lSnapshotPrevious$log, log, bind_rows)
}


# add n_enrolled ----------------------------------------------------------
# -- add n_enrolled to snapshot$results_summary
# -- think through whether other columns are needed ...


# add flag history --------------------------------------------------------
# -- add flag_history either as new domain (results_flag_history) or merged on to results_summary

  snapshot <- dplyr::lst(
    lAssessment,
    log,
    lFigures,
    lInputs = dplyr::lst(
      lMeta,
      lData,
      lMapping,
      lAssessments
    )
  )

  return(snapshot)

}
