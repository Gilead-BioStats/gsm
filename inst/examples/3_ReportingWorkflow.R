#### 3.1 - Create a KRI Report using 12 standard metrics in a step-by-step workflow

# Source Data
lSource <- list(
    Source_SUBJ = clindata::rawplus_dm,
    Source_AE = clindata::rawplus_ae,
    Source_PD = clindata::ctms_protdev,
    Source_LB = clindata::rawplus_lb,
    Source_STUDCOMP = clindata::rawplus_studcomp,
    Source_SDRGCOMP = clindata::rawplus_sdrgcomp %>%
      dplyr::filter(.data$phase == 'Blinded Study Drug Completion'),
    Source_DATACHG = clindata::edc_data_points,
    Source_DATAENT = clindata::edc_data_pages,
    Source_QUERY = clindata::edc_queries,
    Source_ENROLL = clindata::rawplus_enroll,
    Source_SITE = clindata::ctms_site,
    Source_STUDY = clindata::ctms_study
)

# Step 0 - Data Ingestion - standardize tables/columns names
lRaw <- list(
    Raw_SUBJ = lSource$Source_SUBJ,
    Raw_AE = lSource$Source_AE,
    Raw_PD = lSource$Source_PD %>%
      rename(subjid = subjectenrollmentnumber),
    Raw_LB = lSource$Source_LB,
    Raw_STUDCOMP = lSource$Source_STUDCOMP %>%
      select(subjid, compyn),
    Raw_SDRGCOMP = lSource$Source_SDRGCOMP,
    Raw_DATACHG = lSource$Source_DATACHG %>%
      rename(subject_nsv = subjectname),
    Raw_DATAENT = lSource$Source_DATAENT %>%
      rename(subject_nsv = subjectname),
    Raw_QUERY = lSource$Source_QUERY %>%
      rename(subject_nsv = subjectname),
    Raw_ENROLL = lSource$Source_ENROLL,
    Raw_SITE = lSource$Source_SITE %>%
      rename(studyid = protocol) %>%
      rename(invid = pi_number) %>%
      rename(InvestigatorFirstName = pi_first_name) %>%
      rename(InvestigatorLastName = pi_last_name) %>%
      rename(City = city) %>%
      rename(State = state) %>%
      rename(Country = country) %>%
      rename(Status = site_status),
    Raw_STUDY = lSource$Source_STUDY %>%
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
reporting <- RunWorkflows(reporting_wf, c(mapped, list(lAnalyzed = analyzed,
                                                       lWorkflows = metrics_wf)))

# Step 4 - Create KRI Reports - create KRI report using reporting data
module_wf <- MakeWorkflowList(strPath = "workflow/4_modules")
lReports <- RunWorkflows(module_wf, reporting)

#### 3.2 - Automate data ingestion using Ingest() and CombineSpecs()
# Step 0 - Data Ingestion - standardize tables/columns names
mappings_wf <- MakeWorkflowList(strPath = "workflow/1_mappings")
mappings_spec <- CombineSpecs(mappings_wf)
lRaw <- Ingest(lSource, mappings_spec)

# Step 1 - Create Mapped Data Layer - filter, aggregate and join raw data to create mapped data layer
mapped <- RunWorkflows(mappings_wf, lRaw)

# Step 2 - Create Metrics - calculate metrics using mapped data
metrics_wf <- MakeWorkflowList(strPath = "workflow/2_metrics")
analyzed <- RunWorkflows(metrics_wf, mapped)

# Step 3 - Create Reporting Layer - create reports using metrics data
reporting_wf <- MakeWorkflowList(strPath = "workflow/3_reporting")
reporting <- RunWorkflows(reporting_wf, c(mapped, list(lAnalyzed = analyzed,
                                                       lWorkflows = metrics_wf)))

# Step 4 - Create KRI Report - create KRI report using reporting data
module_wf <- MakeWorkflowList(strPath = "workflow/4_modules")
lReports <- RunWorkflows(module_wf, reporting)

#### 3.4 - Combine steps in to a single workflow
#ss_wf <- MakeWorkflowList(strNames = "Snapshot")
#lReports <- RunWorkflows(ss_wf, lSource)

#### 3.4 - Use Study configuration to specify data sources
# StudyConfig <- Read_yaml("inst/workflow/config.yaml")
# mapped <- RunWorkflows(mappings_wf, lConfig=StudyConfig)
# analyzed <- RunWorkflows(metrics_wf,  lConfig=StudyConfig)
# reporting <- RunWorkflows(reporting_wf,  lConfig=StudyConfig)
# lReports <- RunWorkflows(module_wf,  lConfig=StudyConfig)

#### 3.3 Site-Level KRI Report with multiple SnapshotDate
lCharts <- MakeCharts(
  dfResults = gsm::reportingResults,
  dfGroups = gsm::reportingGroups,
  dfMetrics = gsm::reportingMetrics,
  dfBounds = gsm::reportingBounds
)

kri_report_path <- Report_KRI(
  lCharts = lCharts,
  dfResults =  FilterByLatestSnapshotDate(reportingResults),
  dfGroups =  gsm::reportingGroups,
  dfMetrics = gsm::reportingMetrics
)
