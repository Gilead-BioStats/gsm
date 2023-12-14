#' Update archived snapshot logs pre v1.9.0 to the data model of post v1.9.0
#'
#' @param lPrevSnapshot `list` snapshot.rds file of archived snapshot
#' @param lMeta `list` lMeta data used in previous snapshot defaults to `Make_Snapshot()` lMeta default arguments if NULL
#' @param lData `list` lData argument of previous snapshot defaults to `Make_Snapshot()` lData default arguments if NULL
#' @param lMapping `list` lMapping argument of previous snapshot. defaults to `Read_Mapping()` output if NULL
#'
#' @return `list` list of corrected lSnapshot logs and lStackedSnapshots logs if available
#' @export
#'
#' @examples
#' lPrevSnapshot <- readRDS(system.file("data-longitudinal", "AA-AA-000-0000", "2019-12-01", "snapshot.rds", package = "clindata"))
#' updated_lPrevSnapshot <- UpdateDataLogs(lPrevSnapshot)
#'
#' @keywords internal
UpdateSnapshotLogs <- function(lPrevSnapshot, lMeta = NULL, lData = NULL, lMapping = NULL) {
  current_tables <- c("rpt_site_details", "rpt_study_details", "rpt_qtl_details",
                      "rpt_kri_details", "rpt_site_kri_details", "rpt_kri_bounds_details",
                      "rpt_qtl_threshold_param", "rpt_kri_threshold_param", "rpt_qtl_analysis")

  if(all(names(lPrevSnapshot$lSnapshot) == current_tables)) {
    cli::cli_abort("`lPrevSnapshot` already up to date")
  }

  # Defining Meta Parameters
  if (!"lInputs" %in% names(lPrevSnapshot) & is.null(lMeta)) {
    lMeta <- list(
      config_param = gsm::config_param,
      config_workflow = gsm::config_workflow,
      meta_params = gsm::meta_param,
      meta_site = clindata::ctms_site,
      meta_study = clindata::ctms_study,
      meta_workflow = gsm::meta_workflow
    )
  } else if("lInputs" %in% names(lPrevSnapshot) & is.null(lMeta)) {
    lMeta <- lPrevSnapshot$lInputs$lMeta
  }

  # Defining Data Parameters
  if (!"lInputs" %in% names(lPrevSnapshot) & is.null(lData)) {
    lData$dfSUBJ <- clindata::rawplus_dm
  } else if("lInputs" %in% names(lPrevSnapshot) & is.null(lData)) {
    lData$dfSUBJ <- lPrevSnapshot$lInputs$lData$dfSUBJ
  }

  # Defining Mapping Parameters
  if (!"lInputs" %in% names(lPrevSnapshot) & is.null(lMapping)) {
    lMapping <- Read_Mapping()
  } else if("lInputs" %in% names(lPrevSnapshot) & is.null(lMapping)) {
    lMapping <- lPrevSnapshot$lInputs$lMapping
  }

  # Create status_study
  status_study <- Study_Map_Raw(
    dfs = list(
      dfSTUDY = lMeta$meta_study,
      dfSUBJ = lData$dfSUBJ
    ),
    lMapping = lMapping,
    dfConfig = lMeta$config_param
  )

  # Create status_site
  status_site <- Site_Map_Raw(
    dfs = list(
      dfSITE = lMeta$meta_site,
      dfSUBJ = lData$dfSUBJ
    ),
    lMapping = lMapping,
    dfConfig = lMeta$config_param
  )

  # determine analysis date
  if ("lSnapshotDate" %in% names(lPrevSnapshot)) {
    gsm_analysis_date <- lPrevSnapshot$lSnapshotDate
  } else if(exists("gsm_analysis_date", where = lPrevSnapshot$lSnapshot[[1]])) {
    gsm_analysis_date <- lPrevSnapshot$lSnapshot[[1]]$gsm_analysis_date
  } else if(exists("snapshot_date", where = lPrevSnapshot$lSnapshot[[1]])) {
    gsm_analysis_date <- lPrevSnapshot$lSnapshot[[1]]$snapshot_date
  }

  # Previous Results
  StackedlResults <- lPrevSnapshot$lStackedSnapshots
  lResults <- lPrevSnapshot$lStudyAssessResults

  # create status_workflow
  status_workflow <- MakeStatusWorkflow(lResults = lResults,
                                        dfConfigWorkflow = lMeta$config_workflow)

  # define output
  output <- lPrevSnapshot

  # augment past lSnapshot data
  output$lSnapshot <- list(
    rpt_site_details = MakeRptSiteDetails(lResults, status_site, gsm_analysis_date),
    rpt_study_details = MakeRptStudyDetails(lResults, status_study, gsm_analysis_date),
    rpt_qtl_details = MakeRptQtlDetails(lResults, lMeta$meta_workflow, lMeta$config_param, gsm_analysis_date),
    rpt_kri_details = MakeRptKriDetails(lResults, status_site, lMeta$meta_workflow, status_workflow, gsm_analysis_date),
    rpt_site_kri_details = MakeRptSiteKriDetails(lResults, status_site, lMeta$meta_workflow, lMeta$meta_params, gsm_analysis_date),
    rpt_kri_bounds_details = MakeRptKriBoundsDetails(lResults, lMeta$config_param, gsm_analysis_date),
    rpt_qtl_threshold_param = MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, gsm_analysis_date, type = "qtl"),
    rpt_kri_threshold_param = MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, gsm_analysis_date, type = "kri"),
    rpt_qtl_analysis = MakeRptQtlAnalysis(lResults, gsm_analysis_date)
  )

  # augment past lStackedSnapshots data if available
  if ("lStackedSnapshots" %in% names(lPrevSnapshot)) {
    output$lStackedSnapshots <- list(
      rpt_site_details = MakeRptSiteDetails(StackedlResults, status_site),
      rpt_study_details = MakeRptStudyDetails(StackedlResults, status_study),
      rpt_qtl_details = MakeRptQtlDetails(StackedlResults, lMeta$meta_workflow, lMeta$config_param),
      rpt_kri_details = MakeRptKriDetails(StackedlResults, status_site, lMeta$meta_workflow, status_workflow),
      rpt_site_kri_details = MakeRptSiteKriDetails(StackedlResults, status_site, lMeta$meta_workflow, lMeta$meta_params),
      rpt_kri_bounds_details = MakeRptKriBoundsDetails(StackedlResults, lMeta$config_param),
      rpt_qtl_threshold_param = MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, type = "qtl"),
      rpt_kri_threshold_param = MakeRptThresholdParam(lMeta$meta_params, lMeta$config_param, type = "kri"),
      rpt_qtl_analysis = MakeRptQtlAnalysis(StackedlResults)
    )
  }

  return(output)
}






















