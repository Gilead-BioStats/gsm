#### 3.1 - Create a KRI Report using 12 standard metrics with multiple workflows

lRaw <- list(
    Raw_SUBJ = clindata::rawplus_dm,
    Raw_AE = clindata::rawplus_ae,
    Raw_PD = clindata::ctms_protdev %>% rename(subjid = subjectenrollmentnumber),
    Raw_LB = clindata::rawplus_lb,
    Raw_STUDCOMP = clindata::rawplus_studcomp,
    Raw_SDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    Raw_DATACHG = clindata::edc_data_points %>%
      rename(subject_nsv = subjectname),
    Raw_DATAENT = clindata::edc_data_pages %>%
      rename(subject_nsv = subjectname),
    Raw_QUERY = clindata::edc_queries %>%
      rename(subject_nsv = subjectname),
    Raw_ENROLL = clindata::rawplus_enroll,
    Raw_SITE = clindata::ctms_site %>% 
      rename(studyid = protocol) %>% 
      rename(invid = pi_number) %>%
      rename(InvestigatorFirstName = pi_first_name) %>%
      rename(InvestigatorLastName = pi_last_name) %>%
      rename(City = city) %>%
      rename(State = state) %>%
      rename(Country = country),
    Raw_STUDY = clindata::ctms_study %>% 
      rename(studyid = protocol_number) %>%
      rename(Status = status)
)
# Step 1 - Create Mapped Data - filter, aggregate and join raw data to create mapped data layer
devtools::load_all()
mappings_wf <- MakeWorkflowList(strPath = "workflow/1_mappings")
mapped <- RunWorkflows(mappings_wf, lRaw)

metrics_wf <- MakeWorkflowList(strPath = "workflow/2_metrics")
analyzed <- RunWorkflows(metrics_wf, mapped)

reporting_wf <- MakeWorkflowList(strPath = "3_reporting")
module_wf <- MakeWorkflowList(strPath = "4_modules")




# Step 3 - Create Analysis Data - Generate 12 KRIs

kris <- RunWorkflows(kri_wf, mapped)

# Step 4 - Create Reporting Data - Import Metadata and stack KRI Results
lReporting_Input <- list(
    Mapped_SITE = mapped$Mapped_SITE,
    Mapped_COUNTRY = mapped$Mapped_COUNTRY,
    Mapped_STUDY = mapped$Mapped_STUDY,
    lWorkflows = kri_wf,
    lAnalysis = kris,
    dSnapshotDate = Sys.Date(),
    strStudyID = "ABC-123"
)


reporting <- RunWorkflows(reporting_wf, lReporting_Input)

# Step 5 - Generate Site KRI Report - Create Charts + Report

lReports <- RunWorkflows(wf_report, reporting)

#### 3.2 - Create site- and country- level KRI Reports using 12 standard metrics with a single composite workflow
lData <- list(
    # Raw Data
    Raw_SUBJ = clindata::rawplus_dm,
    Raw_AE = clindata::rawplus_ae,
    Raw_PD = clindata::ctms_protdev,
    Raw_LB = clindata::rawplus_lb,
    Raw_STUDCOMP = clindata::rawplus_studcomp,
    Raw_SDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    Raw_DATACHG = clindata::edc_data_points,
    Raw_DATAENT = clindata::edc_data_pages,
    Raw_QUERY = clindata::edc_queries,
    Raw_ENROLL = clindata::rawplus_enroll,
    # CTMS data
    Raw_ctms_site = clindata::ctms_site,
    Raw_ctms_study = clindata::ctms_study,
    # SnapshotDate and StudyID
    dSnapshotDate = Sys.Date(),
    strStudyID = "ABC-123"
)

ss_wf <- MakeWorkflowList(strNames = "snapshot")
snapshot <- RunWorkflows(ss_wf, lData, bKeepInputData = TRUE)

#### 3.2 - Generate reports using dbConfig


#### 3.3 Site-Level KRI Report with multiple SnapshotDate
lCharts <- MakeCharts(
  dfResults = gsm::reportingResults,
  dfGroups = gsm::reportingGroups,
  dfMetrics = gsm::reportingMetrics,
  dfBounds = gsm::reportingBounds
)

kri_report_path <- Report_KRI(
  lCharts = lCharts,
  dfResults =  gsm::reportingResults,
  dfGroups =  gsm::reportingGroups,
  dfMetrics = gsm::reportingMetrics
)
