#### 3.1 - Create a KRI Report using 12 standard metrics with multiple workflows

# Step 1 - Create Mapped Data - filter/map raw data
lData <- list(
    dfSUBJ = clindata::rawplus_dm,
    dfAE = clindata::rawplus_ae,
    dfPD = clindata::ctms_protdev,
    dfLB = clindata::rawplus_lb,
    dfSTUDCOMP = clindata::rawplus_studcomp,
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    dfDATACHG = clindata::edc_data_points,
    dfDATAENT = clindata::edc_data_pages,
    dfQUERY = clindata::edc_queries,
    dfENROLL = clindata::rawplus_enroll
)
mapping_wf <- MakeWorkflowList(strNames = "data_mapping")
mapped <- RunWorkflows(mapping_wf, lData, bKeepInputData=TRUE)

# Step 2 - Create Analysis Data - Generate 12 KRIs
kri_wf <- MakeWorkflowList(strNames = "kri")
kris <- RunWorkflows(kri_wf, mapped)

# Step 3 - Create Reporting Data - Import Metadata and stack KRI Results
lReporting_Input <- list(
    ctms_site = clindata::ctms_site,
    ctms_study = clindata::ctms_study,
    dfEnrolled = mapped$dfEnrolled,
    lWorkflows = kri_wf,
    lAnalysis = kris,
    dSnapshotDate = Sys.Date(),
    strStudyID = "ABC-123"
)
reporting_wf <- MakeWorkflowList(strNames = "reporting")
reporting <- RunWorkflows(reporting_wf, lReporting_Input)

# Step 4 - Generate Reports - Create Charts + Report
wf_reports <- MakeWorkflowList(strNames = "reports")
lReports <- RunWorkflows(wf_reports, reporting)

#### 3.2 - Create a KRI Report using 12 standard metrics with a single composite workflow
lData <- list(
    # Raw Data
    dfSUBJ = clindata::rawplus_dm,
    dfAE = clindata::rawplus_ae,
    dfPD = clindata::ctms_protdev,
    dfLB = clindata::rawplus_lb,
    dfSTUDCOMP = clindata::rawplus_studcomp,
    dfSDRGCOMP = clindata::rawplus_sdrgcomp %>% dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    dfDATACHG = clindata::edc_data_points,
    dfDATAENT = clindata::edc_data_pages,
    dfQUERY = clindata::edc_queries,
    dfENROLL = clindata::rawplus_enroll,
    # CTMS data
    ctms_site = clindata::ctms_site,
    ctms_study = clindata::ctms_study,
    # SnapshotDate and StudyID
    dSnapshotDate = Sys.Date(),
    strStudyID = "ABC-123",
    # Metrics
    Metrics = 'kri'
)

ss_wf <- MakeWorkflowList(strNames = "snapshot")
snapshot <- RunWorkflows(ss_wf, lData, bKeepInputData = TRUE)

#### 3.3 - Create a country-level KRI Report
lData$Metrics <- 'cou'
country_snapshot <- RunWorkflows(ss_wf, lData, bKeepInputData = TRUE)

#### 3.4 Site-Level KRI Report with multiple SnapshotDate
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
