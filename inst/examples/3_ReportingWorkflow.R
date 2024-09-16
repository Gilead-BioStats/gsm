#### 3.1 - Create a KRI Report using 12 standard metrics with multiple workflows

# Step 1 - Ingest Raw Data - select needed columns and rename them if needed
lData <- list(
    Source_SUBJ = clindata::rawplus_dm,
    Source_AE = clindata::rawplus_ae,
    Source_PD = clindata::ctms_protdev,
    Source_LB = clindata::rawplus_lb,
    Source_STUDCOMP = clindata::rawplus_studcomp,
    Source_SDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    Source_DATACHG = clindata::edc_data_points,
    Source_DATAENT = clindata::edc_data_pages,
    Source_QUERY = clindata::edc_queries,
    Source_ENROLL = clindata::rawplus_enroll,
    Source_SITE = clindata::ctms_site,
    Source_STUDY = clindata::ctms_study
)
ingest_wf <- MakeWorkflowList(strNames = "1_ingest")
raw <- RunWorkflows(ingest_wf, lData)

# Step 2 - Create Mapped Data - filter, aggregate and join raw data to create mapped data layer
map_wf <- MakeWorkflowList(strNames = "2_map")
mapped <- RunWorkflows(map_wf, raw$lRaw)

# Step 3 - Create Analysis Data - Generate 12 KRIs
kri_wf <- MakeWorkflowList(strPath = "workflow/metrics")
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

reporting_wf <- MakeWorkflowList(strNames = "reporting")
reporting <- RunWorkflows(reporting_wf, lReporting_Input)

# Step 5 - Generate Site KRI Report - Create Charts + Report
wf_report <- MakeWorkflowList(strPath = "workflow/modules")
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
