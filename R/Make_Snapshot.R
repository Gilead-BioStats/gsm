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
#' @param bFlowchart `logical` Create flowchart to show data pipeline? Default: `FALSE`.
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
Make_Snapshot <- function(lMeta = list(
  config_param = clindata::config_param,
  config_workflow = clindata::config_workflow,
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
  dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$phase == "Blinded Study Drug Completion"),
  dfDATACHG = clindata::edc_data_points,
  dfDATAENT = clindata::edc_data_pages,
  dfQUERY = clindata::edc_queries,
  dfENROLL = clindata::rawplus_enroll
),
lMapping = c(
  yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))
),
lAssessments = NULL,
strAnalysisDate = NULL,
bUpdateParams = FALSE,
bQuiet = TRUE,
bFlowchart = FALSE
) {
  # add gsm_analysis_date to all outputs except meta_
  # -- if date is provided, it should be the date that the data was pulled/wrangled.
  # -- if date is NOT provided, it will default to the date that the analysis was run.



  if (!is.null(strAnalysisDate)) {
    # date validation check
    date_is_valid <- try(as.Date(strAnalysisDate))

    if (!"try-error" %in% class(date_is_valid) && !is.na(date_is_valid)) {
      gsm_analysis_date <- as.Date(strAnalysisDate)
    } else {
      if (!bQuiet) cli::cli_alert_warning("strAnalysisDate does not seem to be in format YYYY-MM-DD. Defaulting to current date of {Sys.Date()}")
      gsm_analysis_date <- Sys.Date()
    }
  } else {
    gsm_analysis_date <- Sys.Date()
  }


  # rename GILDA to expected gsm variable names -----------------------------

  # ctms_study / meta_study:
  status_study <- lMeta$meta_study %>%
    select(
      # study name/ID
      "studyid" = "PROTOCOL_NUMBER",
      "title" = "PROTOCOL_TITLE",
      "nickname" = "NICKNAME",

      # enrollment
      "planned_sites" = "NUM_PLAN_SITE",
      "enrolled_sites_ctms" = "NUM_SITE_ACTL",
      "planned_participants" = "NUM_PLAN_SUBJ",
      "enrolled_participants_ctms" = "NUM_ENROLLED_SUBJ_M",

      # milestones
      "fpfv" = "ACT_FPFV",
      "lpfv" = "ACT_LPFV",
      "lplv" = "ACT_LPLV",

      # study characteristics
      "ta" = "THERAPEUTIC_AREA",
      "indication" = "PROTOCOL_INDICATION",
      "phase" = "PHASE",
      "status" = "STATUS",
      "rbm_flag" = "X_RBM_FLG",

      # miscellany
      "product" = "PRODUCT",
      "protocol_type" = "PROTOCOL_TYPE",
      "protocol_row_id" = "PROTOCOL_ROW_ID",
      "est_fpfv" = "EST_FPFV",
      "est_lpfv" = "EST_LPFV",
      "est_lplv" = "EST_LPLV",
      "protocol_product_number" = "PROTOCOL_PRODUCT_NUMBER",
      everything()
    ) %>%
    rename_with(tolower)

  # ctms_site / meta_site:
  status_site <- lMeta$meta_site %>%
    mutate(
      siteid = as.character(.data$SITE_NUM),
      invname = paste0(.data$PI_LAST_NAME, ", ", .data$PI_FIRST_NAME)
    ) %>%
    select(
      "studyid" = "PROTOCOL",
      "siteid",
      "institution" = "ACCOUNT",
      "status" = "SITE_STATUS",
      "start_date" = "SITE_ACTIVE_DT",
      "city" = "CITY",
      "state" = "STATE",
      "country" = "COUNTRY",
      "invname",
      everything()
    ) %>%
    rename_with(tolower)

  # status_study ------------------------------------------------------------
  if (!("enrolled_participants" %in% colnames(status_study))) {
    status_study$enrolled_participants <- gsm::Get_Enrolled(
      dfSUBJ = lData$dfSUBJ,
      dfConfig = lMeta$config_param,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "study"
    )
  }

  if (!("enrolled_sites" %in% colnames(status_study))) {
    status_study$enrolled_sites <- gsm::Get_Enrolled(
      dfSUBJ = lData$dfSUBJ,
      dfConfig = lMeta$config_param,
      lMapping = lMapping,
      strUnit = "site",
      strBy = "study"
    )
  }

  # status_site -------------------------------------------------------------
  if (!("enrolled_participants" %in% colnames(status_site))) {
    status_site_count <- gsm::Get_Enrolled(
      dfSUBJ = lData$dfSUBJ,
      dfConfig = lMeta$config_param,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "site"
    )

    status_site <- left_join(status_site, status_site_count, by = c("siteid" = "SiteID"))
  }

  # reorder columns
  status_study <- status_study %>%
    select(
      "studyid",
      "enrolled_sites",
      "enrolled_participants",
      "planned_sites",
      "planned_participants",
      everything()
    )

  status_site <- status_site %>%
    relocate("enrolled_participants", .after = "status")


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

  # grab boolean status of each workflow
  parseStatus <- purrr::imap(lResults, function(x, y) tibble(workflowid = y, status = x$bStatus)) %>%
    bind_rows()

  # join boolean status column to status_workflow
  # `lMeta$config_workflow` represents intended workflow to be run
  # `parseStatus` represents the actual results - workflowid + `x$bStatus`
  # if `workflowid` is not found in the results, that means it was not run.
  status_workflow <- lMeta$config_workflow %>%
    full_join(parseStatus, by = "workflowid") %>%
    mutate(status = ifelse(is.na(.data$status), FALSE, .data$status))

  # parse warnings from is_mapping_valid to create an informative "notes" column
  warnings <- ParseWarnings(lResults)

  status_workflow <- status_workflow %>%
    left_join(warnings, by = c("workflowid", "status"))


  # status_param ------------------------------------------------------------
  status_param <- lMeta$config_param

  # meta_workflow -----------------------------------------------------------
  meta_workflow <- lMeta$meta_workflow

  # meta_param --------------------------------------------------------------
  meta_param <- lMeta$meta_params


  # results_summary ---------------------------------------------------------
  results_summary <- purrr::map(lResults, ~ .x[["lResults"]]) %>%
    purrr::discard(is.null) %>%
    purrr::imap_dfr(~ .x$lData$dfSummary %>%
      mutate(
        KRIID = .y,
        StudyID = unique(lMeta$config_workflow$studyid)
      )) %>%
    select(
      studyid = "StudyID",
      workflowid = "KRIID",
      groupid = "GroupID",
      numerator = "Numerator",
      denominator = "Denominator",
      metric = "Metric",
      score = "Score",
      flag = "Flag"
    )

  # results_analysis ---------------------------------------------------------

  hasQTL <- grep("qtl", names(lResults))
  results_analysis <- NULL

  if (length(hasQTL) > 0) {
    results_analysis <-
      purrr::imap_dfr(lResults[hasQTL], function(qtl, qtl_name) {
        if (qtl$bStatus) {
          qtl$lResults$lData$dfAnalyzed %>%
            select(
              "GroupID",
              "LowCI",
              "Estimate",
              "UpCI",
              "Score"
            ) %>%
            mutate(workflowid = qtl_name) %>%
            tidyr::pivot_longer(-c("GroupID", "workflowid")) %>%
            rename(
              param = "name",
              studyid = "GroupID"
            )
        }
      })
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


  # create lSnapshot --------------------------------------------------------

  lSnapshot <- list(
    status_study = status_study,
    status_site = status_site,
    status_workflow = status_workflow,
    status_param = status_param,
    results_summary = results_summary,
    results_analysis = results_analysis,
    results_bounds = results_bounds,
    meta_workflow = meta_workflow,
    meta_param = meta_param
  ) %>%
    purrr::keep(~ !is.null(.x)) %>%
    purrr::map(~ .x %>% mutate(gsm_analysis_date = gsm_analysis_date))

  return(
    list(
      lSnapshot = lSnapshot,
      lStudyAssessResults = lResults
    )
  )
}
