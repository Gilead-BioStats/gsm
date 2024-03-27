#' Update archived snapshot logs pre v1.9.0 to the data model of post v1.9.0
#'
#' @param lSnapshot `list` snapshot.rds file of archived snapshot
#' @param lMeta `list` lMeta data used in previous snapshot defaults to `Make_Snapshot()` lMeta default arguments if NULL
#' @param lData `list` lData argument of previous snapshot defaults to `Make_Snapshot()` lData default arguments if NULL
#' @param lMapping `list` lMapping argument of previous snapshot. defaults to `Read_Mapping()` output if NULL
#' @param version `string` specifies the conversion direction '1.8' for old data model '1.9' for new data model
#'
#' @return `list` list of corrected lSnapshot logs and lStackedSnapshots logs if available
#' @export
#'
#' @keywords internal
UpdateSnapshotLogs <- function(lSnapshot, lMeta = NULL, lData = NULL, lMapping = NULL, version = "1.9") {
  if (!version %in% c("1.8", "1.9")) {
    stop("version argument must be either '1.8' for previous data model or '1.9' for current data model")
  }

  old_tables <- c(
    "status_study", "status_site", "status_workflow", "status_param", "results_summary",
    "results_analysis", "results_bounds", "meta_workflow", "meta_param"
  )

  current_tables <- c(
    "rpt_site_details", "rpt_study_details", "rpt_qtl_details",
    "rpt_kri_details", "rpt_site_kri_details", "rpt_kri_bounds_details",
    "rpt_qtl_threshold_param", "rpt_kri_threshold_param", "rpt_qtl_analysis"
  )

  if (version == "1.9" & all(names(lSnapshot$lSnapshot) == current_tables)) {
    cli::cli_abort("`lSnapshot` already up to date")
  }

  if (version == "1.8" & all(names(lSnapshot$lSnapshot) == old_tables)) {
    cli::cli_abort("`lSnapshot` already up to date")
  }

  # Defining Meta Parameters
  if (!"lInputs" %in% names(lSnapshot)) {
    # If inputs are not provided, use default lMeta
    if (is.null(lMeta)) {
      lMeta <- list(
        config_param = gsm::config_param,
        config_workflow = gsm::config_workflow,
        meta_params = gsm::meta_param,
        meta_site = clindata::ctms_site,
        meta_study = clindata::ctms_study,
        meta_workflow = gsm::meta_workflow
      )
    }

    # If inputs are not provided, use default demographic lData
    if (is.null(lData)) {
      lData$dfSUBJ <- clindata::rawplus_dm
    }

    # If mapping is not provided, use default mapping
    if (is.null(lMapping)) {
      lMapping <- Read_Mapping()
    }
  } else {
    if (is.null(lMeta)) {
      lMeta <- lSnapshot$lInputs$lMeta
    }

    if (is.null(lData)) {
      lData$dfSUBJ <- lSnapshot$lInputs$lData$dfSUBJ
    }

    if (is.null(lMapping)) {
      lMapping <- lSnapshot$lInputs$lMapping
    }
  }

  if (version == "1.9") {
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
    if ("lSnapshotDate" %in% names(lSnapshot)) {
      gsm_analysis_date <- lSnapshot$lSnapshotDate
    } else if (exists("gsm_analysis_date", where = lSnapshot$lSnapshot[[1]])) {
      gsm_analysis_date <- lSnapshot$lSnapshot[[1]]$gsm_analysis_date
    } else if (exists("snapshot_date", where = lSnapshot$lSnapshot[[1]])) {
      gsm_analysis_date <- lSnapshot$lSnapshot[[1]]$snapshot_date
    }

    # Previous Results
    lResults <- lSnapshot$lStudyAssessResults

    # create status_workflow
    status_workflow <- MakeStatusWorkflow(
      lResults = lResults,
      dfConfigWorkflow = lMeta$config_workflow
    )

    # define output
    output <- lSnapshot

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
  } else if (version == "1.8") {
    output <- RevertSnapshotLogs(lSnapshot, lMeta, lData)
  }


# Extract lCharts ---------------------------------------------------------
  output$lCharts <- ExtractCharts(
    lResults = lResults
  )


  browser()


# Reconfigure stacked snapshots -------------------------------------------
output$lStackedSnapshots <- ReformatStackedSnapshots(lSnapshot$lStackedSnapshots)

  return(output)
}
