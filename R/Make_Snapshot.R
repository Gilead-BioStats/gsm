#' Make Snapshot - create and export Gizmo data model.
#'
#' @param lMeta `list` a named list of data frames containing metadata, configuration, and workflow parameters for a given study. TODO: add details about expected lMeta input.
#' @param lData `list` a named list of domain level data frames. Names should match the values specified in `lMapping` and `lAssessments`, which are generally based on the expected inputs from `X_Map_Raw`.
#' @param lMapping `list` a named list identifying the columns needed in each data domain.
#' @param lAssessments a named list of metadata defining how each assessment should be run. By default, `MakeWorkflowList()` imports YAML specifications from `inst/workflow`.
#' @param cPath `character` a character string indicating a working directory to save .csv files; the output of the snapshot.
#' @param bQuiet `logical` Suppress warning messages? Default: `TRUE`
#'
#' @includeRmd ./man/md/Make_Snapshot.md
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
  config_schedule = clindata::config_schedule,
  config_workflow = clindata::config_workflow,
  meta_params = gsm::meta_param,
  meta_site = clindata::ctms_site,
  meta_study = clindata::ctms_study,
  meta_workflow = gsm::meta_workflow
),
lData = list(
  dfSUBJ = clindata::rawplus_dm,
  dfAE = clindata::rawplus_ae,
  dfLB = clindata::rawplus_lb,
  dfPD = clindata::rawplus_protdev,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$datapagename == "Blinded Study Drug Completion")
),
lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
lAssessments = NULL,
cPath = NULL,
bQuiet = TRUE

) {

  # add to all outputs except meta_
  gsm_analysis_date <- Sys.Date()


  # lSnapshot$status_study<-meta$meta_study
  status_study <- lMeta$meta_study

  # status_study ------------------------------------------------------------
  if (!("enrolled_participants" %in% colnames(status_study))) {
    status_study$enrolled_participants <- Get_Enrolled(
      dfSUBJ = lData$dfSUBJ,
      dfConfig = lMeta$config_param,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "study"
    )
  }

  if (!("enrolled_sites" %in% colnames(status_study))) {
    status_study$enrolled_sites <- Get_Enrolled(
      dfSUBJ = lData$dfSUBJ,
      dfConfig = lMeta$config_param,
      lMapping = lMapping,
      strUnit = "site",
      strBy = "study"
    )
  }


  # select in same order as spec - can remove this if not needed, but helps with comparison
  status_study <- status_study %>%
    select(
      "studyid",
      "enrolled_sites",
      "enrolled_participants",
      "planned_sites",
      "planned_participants",
      "title",
      "nickname",
      "indication",
      "ta",
      "phase",
      "status",
      "fpfv",
      "lplv",
      "rbm_flag"
    )

  # status_site -------------------------------------------------------------
  status_site <- lMeta$meta_site %>%
    mutate(siteid = as.character(.data$siteid))
  if (!("enrolled_participants" %in% colnames(status_site))) {
    status_site_count <- Get_Enrolled(
      dfSUBJ = lData$dfSUBJ,
      dfConfig = lMeta$config_param,
      lMapping = lMapping,
      strUnit = "participant",
      strBy = "site"
    )
  }
  status_site <- left_join(status_site, status_site_count, by = c("siteid" = "SiteID")) %>%
    select(
      "studyid",
      "siteid",
      "institution",
      "status",
      "enrolled_participants",
      "start_date",
      "city",
      "state",
      "country",
      "invname"
    )


  # run Study_Assess() ------------------------------------------------------
  # Make a list of assessments
  # Need to update this to use the relevant items from lMeta (meta_workflow, meta_params, config_workfow and config_params)

  if (is.null(lAssessments)) {
    lAssessments <- MakeWorkflowList(strNames = c(unique(lMeta$meta_workflow$workflowid)))
  }

  # update parameters
  lAssessments <- UpdateParams(lAssessments, lMeta$config_param, lMeta$meta_params)

  # Run Study Assessment
  lResults <- Study_Assess(
    lData = lData,
    lMapping = lMapping,
    lAssessments = lAssessments,
    bQuiet = bQuiet
  )

  # add line below to parseWorkflowStatus function
  parseStatus <- purrr::imap(lResults, function(x, y) tibble(workflowid = y, status = x$bStatus)) %>%
    bind_rows()

  # lWorkflowStatus <- parseWorkflowStatus(lResults)
  status_workflow <- lMeta$config_workflow %>%
    left_join(parseStatus, by = "workflowid")

  warnings <- ParseWarnings(lResults)

  if (nrow(warnings > 0)) {
    status_workflow <- status_workflow %>%
      left_join(warnings, by = "workflowid")
  } else {
    status_workflow$notes <- NA_character_
  }

  # status_param ------------------------------------------------------------
  status_param <- lMeta$config_param

  # status_schedule ---------------------------------------------------------
  status_schedule <- lMeta$config_schedule

  # meta_workflow -----------------------------------------------------------
  meta_workflow <- gsm::meta_workflow

  # meta_param --------------------------------------------------------------
  meta_param <- gsm::meta_param

  # results_summary ---------------------------------------------------------
  results_summary <- purrr::map(lResults, ~ .x[["lResults"]]) %>%
    discard(is.null) %>%
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


  # lSnapshot$results_summary$StudyID <- meta$status_study[1,'StudyID']
  # Also need to make sure we're capturing WorkflowID here ...

  # results_bounds ----------------------------------------------------------
  results_bounds <- lResults %>%
    purrr::map(~ .x$lResults$lData$dfBounds) %>%
    purrr::discard(is.null) %>%
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



  # create lSnapshot --------------------------------------------------------

  lSnapshot <- list(
    status_study = status_study,
    status_site = status_site,
    status_workflow = status_workflow,
    status_param = status_param,
    status_schedule = status_schedule,
    results_summary = results_summary,
    results_bounds = results_bounds,
    meta_workflow = meta_workflow,
    meta_param = meta_param
  ) %>%
    purrr::map(~.x %>% mutate(gsm_analysis_date = gsm_analysis_date))

  if (!is.null(cPath)) {
    # write each snapshot item to location
    purrr::iwalk(lSnapshot, ~ write.csv(.x, file = paste0(cPath, "/", .y, ".csv"), row.names = FALSE))
  }

  return(lSnapshot)
}
