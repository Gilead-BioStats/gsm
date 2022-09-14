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
  lSnapshot$study_status <- tibble("abc") # placeholder

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
  lSnapshot$site_status <- list()
  lSnapshot$site_status$enrolled_participants <- Get_Enrolled(
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

  browser()

  # imap(lResults, \(x, y) tibble(x$bStatus) %>% set_names(y))

  lWorkflowStatus <- parseWorkflowStatus(lResults)
  lSnapshot$status_workflow <- meta$config_workflow
  lSnapshot$status_workflow$Status <- lWorkflowStatus$Status
  lSnapshot$status_workflow$Notes<- lWorkflowStatus$Notes

  lSnapshot$status_param <- meta$config_param

  lSnapshot$status_schedule <- meta$config_schedule

  lSnapshot$meta_workflow<-gsm::meta_workflow

  lSnapshot$meta_param <- gsm::meta_param

  lSnapshot$results_summary <- lResults %>% map(~.x$data$dfSummary) %<% bind_rows
  lSnapshot$results_summary$StudyID <- meta$study_status[1,'StudyID']
  #Also need to make sure we're capturing WorkflowID here ...

  lSnapshot$results_bounds <- lResults %>% map(~.x$data$dfBounds) %<% bind_rows
  lSnapshot$results_bounds$StudyID <- meta$study_status[1,'StudyID']
  #Also need to make sure we're capturing WorkflowID here ...

  if(path){
    #write each snapshot item to location
  }

  return(lSnapshot)
}
