#' Make Snapshot - say cheese
#'
#' @param lMeta
#' @param lData
#' @param lMapping
#' @param cPath
#' @param bQuiet
#'
#' @return
#'
#' @import purrr
#' @importFrom yaml read_yaml
#'
#'
#' @examples
#'
#' # run with default testing data
#' snapshot <- Make_Snapshot()
#'
#'
#' @export
Make_Snapshot <- function(
lMeta = list(
  meta_study = NULL,
  #from CTMS
  meta_site = NULL,
  #from CTMS
  config_schedule = NULL,
  config_workflow = gsm::config_workflow,
  config_params = gsm::config_param,
  meta_workflow = gsm::meta_workflow,
  meta_params = gsm::meta_param
),
lData = list(
  dfSUBJ = clindata::rawplus_dm %>% filter(!is.na(timeontreatment)),
  dfAE = clindata::rawplus_ae,
  dfPD = clindata::rawplus_protdev,
  dfCONSENT = clindata::rawplus_consent,
  dfIE = clindata::rawplus_ie,
  dfLB = clindata::rawplus_lb,
  dfSTUDCOMP = clindata::rawplus_studcomp,
  dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% filter(.data$datapagename == "Blinded Study Drug Completion")
),
lMapping = yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
cPath = NULL,
bQuiet = TRUE
){

  # Create Snapshot
  lSnapshot <- list()

  # lSnapshot$study_status<-meta$meta_study
  lSnapshot$study_status <- tibble(StudyID = unique(lMeta$config_workflow$studyid)) # placeholder

  lSnapshot$study_status$enrolled_participants <- Get_Enrolled(
    dfSUBJ = lData$dfSUBJ,
    dfConfig = lMeta$config_param,
    lMapping = lMapping,
    strUnit = "participant",
    strBy = "study"
    )

  lSnapshot$study_status$enrolled_sites <- Get_Enrolled(
    dfSUBJ = lData$dfSUBJ,
    dfConfig = lMeta$config_param,
    lMapping = lMapping,
    strUnit = "site",
    strBy = "study"
  )


  # lSnapshot$site_status <- meta$meta_site
  lSnapshot$site_status <- Get_Enrolled(
    dfSUBJ = lData$dfSUBJ,
    dfConfig = lMeta$config_param,
    lMapping = lMapping,
    strUnit = "participant",
    strBy = "site"
  )


  # Make a list of assessments
  # Need to update this to use the relevant items from lMeta (meta_workflow, meta_params, config_workfow and config_params)
  lAssessments <- MakeAssessmentList()

  # Run Study Assessment
  lResults <- Study_Assess(
    lData = lData,
    lMapping = lMapping,
    lAssessments = lAssessments,
    bQuiet = bQuiet
  )


  # imap(lResults, \(x, y) tibble(x$bStatus) %>% set_names(y))


  # add line below to parseWorkflowStatus function
  parseStatus <- purrr::imap(lResults, \(x, y) tibble(workflowid = y, status = x$bStatus)) %>%
    bind_rows()

  # lWorkflowStatus <- parseWorkflowStatus(lResults)
  lSnapshot$status_workflow <- lMeta$config_workflow %>%
    left_join(parseStatus, by = "workflowid")



  #lSnapshot$status_workflow$Status <- lWorkflowStatus$Status
  #lSnapshot$status_workflow$Notes<- lWorkflowStatus$Notes

  lSnapshot$status_param <- lMeta$config_param

  lSnapshot$status_schedule <- lMeta$config_schedule

  lSnapshot$meta_workflow <- gsm::meta_workflow

  lSnapshot$meta_param <- gsm::meta_param


  lSnapshot$results_summary <- lResults %>%
    purrr::imap_dfr(~.x$lResults$lData$dfSummary %>%
               mutate(KRIID = .y,
                      StudyID = unique(lMeta$config_workflow$studyid)))


  # lSnapshot$results_summary$StudyID <- meta$study_status[1,'StudyID']
  #Also need to make sure we're capturing WorkflowID here ...




  lSnapshot$results_bounds <- lResults %>%
    purrr::map(~.x$lResults$lData$dfBounds) %>%
    purrr::discard(is.null) %>%
    purrr::imap_dfr(~.x %>% mutate(KRIID = .y)) %>%
    mutate(StudyID = unique(lMeta$config_workflow$studyid),
           WorkflowID = KRIID) # not sure if this is a correct assumption

  #Also need to make sure we're capturing WorkflowID here ...

  if (!is.null(cPath)) {
    #write each snapshot item to location
    purrr::iwalk(lSnapshot, ~ write.csv(.x, file = paste0(cPath, "/", .y, ".csv"), row.names = FALSE))
  }

  return(lSnapshot)
}
