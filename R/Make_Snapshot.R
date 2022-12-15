#' Make Snapshot - create and export Gizmo data model.
#'
#' @description
#' `Make_Snapshot()` ingests data from a variety of sources, and runs KRIs and/or QTLs based on the `list` provided in `lAssessments`. The output of `Make_Snapshot()` is used as the input data model
#' for the Gismo web application.
#'
#' For more context about the inputs and outputs of `Make_Snapshot()`, refer to the [GSM Data Pipeline Vignette](https://silver-potato-cfe8c2fb.pages.github.io/articles/DataPipeline.html), specifically
#' Appendix 2 - Data Model Specifications
#'
#' @param lMeta `list` a named list of data frames containing metadata, configuration, and workflow parameters for a given study.
#' See the Data Model Vignette - Appendix 2 - Data Model Specifications for detailed specifications.
#' @param lData `list` a named list of domain-level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` Column metadata with structure `domain$key`, where `key` contains the name of the column. Default: package-defined mapping for raw+.
#' @param lAssessments `list` a named list of metadata defining how each assessment should be run. By default, `MakeWorkflowList()` imports YAML specifications from `inst/workflow`.
#' @param bUpdateParams `logical` if `TRUE`, configurable parameters found in `lMeta$config_param` will overwrite the default values in `lMeta$meta_params`. Default: `FALSE`.
#' @param cPath `character` a character string indicating a working directory to save .csv files; the output of the snapshot.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @includeRmd ./man/md/Make_Snapshot.md
#'
#' @return `list` `lSnapshot`, a named list with a data.frame for each component of the {gsm} data model.
#' - `status_study`
#' - `status_site`
#' - `status_workflow`
#' - `status_param`
#' - `results_summary`
#' - `results_bounds`
#' - `meta_workflow`
#' - `meta_param`
#'
#' @examples
#' # run with default testing data
#' snapshot <- Make_Snapshot()
#'
#' @import purrr
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
  dfPD = clindata::rawplus_protdev,
  dfCONSENT = clindata::rawplus_consent,
  dfIE = clindata::rawplus_ie,
  dfLB = clindata::rawplus_lb,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$datapagename == "Blinded Study Drug Completion"),
  dfDATACHG = clindata::edc_data_change_rate,
  dfDATAENT = clindata::edc_data_entry_lag,
  dfQUERY = clindata::edc_queries,
  dfENROLL = clindata::rawplus_enroll
),
lMapping = c(
  yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm")),
  yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))
),
lAssessments = NULL,
bUpdateParams = FALSE,
cPath = NULL,
bQuiet = TRUE

) {

  # add to all outputs except meta_
  gsm_analysis_date <- Sys.Date()



  # rename GILDA to expected gsm variable names -----------------------------

  # ctms_study / meta_study:
  status_study <- lMeta$meta_study %>%
    select(
      "studyid" = "PROTOCOL_TITLE",
      "enrolled_sites_ctms" = "NUM_SITE_ACTL",
      "enrolled_participants_ctms" = "NUM_ENROLLED_SUBJ_M",
      "planned_sites" = "NUM_PLAN_SITE",
      "planned_participants" = "NUM_PLAN_SUBJ",
      "title" = "PROTOCOL_TITLE",
      "nickname" = "NICKNAME",
      "indication" = "PROTOCOL_INDICATION",
      "ta" = "THERAPEUTIC_AREA",
      "phase" = "PHASE",
      "status" = "STATUS",
      "fpfv" = "ACT_FPFV",
      "lpfv" = "ACT_LPFV",
      "lplv" = "ACT_LPLV",
      "rbm_flag" = "X_RBM_FLG",
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
  # Need to update this to use the relevant items from lMeta (meta_workflow, meta_params, config_workfow and config_params)

  if (is.null(lAssessments)) {
    lAssessments <- gsm::MakeWorkflowList(strNames = c(unique(lMeta$meta_workflow$workflowid)))
  }

  # update parameters
  if (bUpdateParams) {
    lAssessments <- UpdateParams(lAssessments, lMeta$config_param, lMeta$meta_params)
  }

  # Run Study Assessment
  lResults <- gsm::Study_Assess(
    lData = lData,
    lMapping = lMapping,
    lAssessments = lAssessments,
    bQuiet = bQuiet
  )

  # grab boolean status of each workflow
  parseStatus <- purrr::imap(lResults, function(x, y) tibble(workflowid = y, status = x$bStatus)) %>%
    bind_rows()

  # join boolean status column to status_workflow
  status_workflow <- lMeta$config_workflow %>%
    left_join(parseStatus, by = "workflowid")

  # parse warnings from is_mapping_valid to create an informative "notes" column
  warnings <- ParseWarnings(lResults)

  if (nrow(warnings > 0)) {
    status_workflow <- status_workflow %>%
      left_join(warnings, by = "workflowid")
  } else {
    status_workflow$notes <- NA_character_
  }

  # status_param ------------------------------------------------------------
  status_param <- lMeta$config_param

  # meta_workflow -----------------------------------------------------------
  meta_workflow <- lMeta$meta_workflow

  # meta_param --------------------------------------------------------------
  meta_param <- lMeta$meta_params


  # results_summary ---------------------------------------------------------
  results_summary <- purrr::map(lResults, ~ .x[["lResults"]]) %>%
    purrr::discard(is.null) %>%
    purrr::imap_dfr(~ .x$lData$dfFlagged %>%
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
              "UpCI",
              "Score"
            ) %>%
            mutate(workflowid = qtl_name) %>%
            pivot_longer(-c("GroupID", "workflowid")) %>%
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
    keep(~ !is.null(.x)) %>%
    purrr::map(~ .x %>% mutate(gsm_analysis_date = gsm_analysis_date))


  # save lSnapshot ----------------------------------------------------------

  if (!is.null(cPath)) {
    # write each snapshot item to location
    purrr::iwalk(lSnapshot, ~ write.csv(.x, file = paste0(cPath, "/", .y, ".csv"), row.names = FALSE))
  }

  return(lSnapshot)
}
