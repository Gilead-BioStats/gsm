#### 3.1 - Create a KRI Report using 12 standard metrics in a step-by-step workflow

# Source Data
lSource <- list(
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

# Step 0 - Data Ingestion - standardize tables/columns names 
lRaw <- list(
    Raw_SUBJ = Source_SUBJ,
    Raw_AE = Source_AE,
    Raw_PD = Source_PD %>% 
      rename(subjid = subjectenrollmentnumber),
    Raw_LB = Source_LB,
    Raw_STUDCOMP = Source_STUDCOMP,
    Raw_SDRGCOMP = Source_SDRGCOMP,
    Raw_DATACHG = Source_DATACHG %>%
      rename(subject_nsv = subjectname),
    Raw_DATAENT = Source_DATAENT %>%
      rename(subject_nsv = subjectname),
    Raw_QUERY = SOURCE_QUERY %>%
      rename(subject_nsv = subjectname),
    Raw_ENROLL = SOURCE_ENROLL,
    Raw_SITE = SOURCE_SITE %>% 
      rename(studyid = protocol) %>% 
      rename(invid = pi_number) %>%
      rename(InvestigatorFirstName = pi_first_name) %>%
      rename(InvestigatorLastName = pi_last_name) %>%
      rename(City = city) %>%
      rename(State = state) %>%
      rename(Country = country),
    Raw_STUDY = SOURCE_STUDY %>% 
      rename(studyid = protocol_number) %>%
      rename(Status = status)
)

# Step 1 - Create Mapped Data Layer - filter, aggregate and join raw data to create mapped data layer
mappings_wf <- MakeWorkflowList(strPath = "workflow/1_mappings")
mapped <- RunWorkflows(mappings_wf, lRaw)

# Step 2 - Create Metrics - calculate metrics using mapped data 
metrics_wf <- MakeWorkflowList(strPath = "workflow/2_metrics")
analyzed <- RunWorkflows(metrics_wf, mapped)

# Step 3 - Create Reporting Layer - create reports using metrics data
reporting_wf <- MakeWorkflowList(strPath = "workflow/3_reporting")
reporting <- RunWorkflows(reporting_wf, c(mapped, list(lAnalyzed = analyzed, lWorkflows = metrics_wf)))

# Step 4 - Create KRI Reports - create KRI report using reporting data
module_wf <- MakeWorkflowList(strPath = "workflow/4_modules")
lReports <- RunWorkflows(module_wf, reporting)

#### 3.2 - Automate data ingestion using Ingest() and CombineSpecs()
# Step 0 - Data Ingestion - standardize tables/columns names 
mappings_wf <- MakeWorkflowList(strPath = "workflow/1_mappings")
mapping_spec <- mapping_wf %>%  map(~.x$spec) %>% CombineSpecs
lRaw <- Ingest(lSource, mapping_spec)

# Step 1 - Create Mapped Data Layer - filter, aggregate and join raw data to create mapped data layer
mapped <- RunWorkflows(mappings_wf, lRaw)

# Step 2 - Create Metrics - calculate metrics using mapped data 
metrics_wf <- MakeWorkflowList(strPath = "workflow/2_metrics")
analyzed <- RunWorkflows(metrics_wf, mapped)

# Step 3 - Create Reporting Layer - create reports using metrics data
reporting_wf <- MakeWorkflowList(strPath = "workflow/3_reporting")
reporting <- RunWorkflows(reporting_wf, c(mapped, list(lAnalyzed = analyzed, lWorkflows = metrics_wf)))

# Step 4 - Create KRI Report - create KRI report using reporting data
module_wf <- MakeWorkflowList(strPath = "workflow/4_modules")
lReports <- RunWorkflows(module_wf, reporting)


#### 3.4 - Use Study configuration to specify data sources


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
