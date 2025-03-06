library(gsm)
library(gsm.mapping)
library(gsm.kri)
library(gsm.reporting)

#### 3.1 - Create a KRI Report using 12 standard metrics in a step-by-step workflow

core_mappings <- c("AE", "COUNTRY", "DATACHG", "DATAENT", "ENROLL", "LB",
                   "PD", "QUERY", "STUDY", "STUDCOMP", "SDRGCOMP", "SITE", "SUBJ")

# Step 0 - Create Raw Data from Source Data
lRaw <- list(
  Raw_SUBJ = gsm::lSource$Raw_SUBJ,
  Raw_AE = gsm::lSource$Raw_AE,
  Raw_PD = gsm::lSource$Raw_PD %>%
    rename(subjid = subjectenrollmentnumber),
  Raw_LB = gsm::lSource$Raw_LB,
  Raw_STUDCOMP = gsm::lSource$Raw_STUDCOMP %>%
    select(subjid, compyn),
  Raw_SDRGCOMP = gsm::lSource$Raw_SDRGCOMP,
  Raw_DATACHG = gsm::lSource$Raw_DATACHG %>%
    rename(subject_nsv = subjectname),
  Raw_DATAENT = gsm::lSource$Raw_DATAENT %>%
    rename(subject_nsv = subjectname),
  Raw_QUERY = gsm::lSource$Raw_QUERY %>%
    rename(subject_nsv = subjectname),
  Raw_ENROLL = gsm::lSource$Raw_ENROLL,
  Raw_SITE = gsm::lSource$Raw_SITE %>%
    rename(studyid = protocol) %>%
    rename(invid = pi_number) %>%
    rename(InvestigatorFirstName = pi_first_name) %>%
    rename(InvestigatorLastName = pi_last_name) %>%
    rename(City = city) %>%
    rename(State = state) %>%
    rename(Country = country) %>%
    rename(Status = site_status),
  Raw_STUDY = gsm::lSource$Raw_STUDY %>%
    rename(studyid = protocol_number) %>%
    rename(Status = status)
)

# Step 1 - Create Mapped Data Layer - filter, aggregate and join raw data to create mapped data layer
mappings_wf <- MakeWorkflowList(strNames = core_mappings, strPath = "workflow/1_mappings", strPackage = "gsm.mapping")
mapped <- RunWorkflows(mappings_wf, lRaw)

# Step 2 - Create Metrics - calculate metrics using mapped data
metrics_wf <- MakeWorkflowList(strPath = "workflow/2_metrics", strPackage = "gsm.kri")
analyzed <- RunWorkflows(metrics_wf, mapped)

# Step 3 - Create Reporting Layer - create reports using metrics data
reporting_wf <- MakeWorkflowList(strPath = "workflow/3_reporting", strPackage = "gsm.reporting")
reporting <- RunWorkflows(reporting_wf, c(mapped, list(lAnalyzed = analyzed,
                                                       lWorkflows = metrics_wf)))

# Step 4 - Create KRI Reports - create KRI report using reporting data
module_wf <- MakeWorkflowList(strPath = "workflow/4_modules", strPackage = "gsm.kri")
lReports <- RunWorkflows(module_wf, reporting)

#### 3.2 - Automate data ingestion using Ingest() and CombineSpecs()
# Step 0 - Data Ingestion - standardize tables/columns names
mappings_wf <- MakeWorkflowList(strNames = core_mappings, strPath = "workflow/1_mappings", strPackage = "gsm.mapping")
mappings_spec <- CombineSpecs(mappings_wf)
lRaw <- Ingest(gsm::lSource, mappings_spec)

# Step 1 - Create Mapped Data Layer - filter, aggregate and join raw data to create mapped data layer
mapped <- RunWorkflows(mappings_wf, lRaw)

# Step 2 - Create Metrics - calculate metrics using mapped data
metrics_wf <- MakeWorkflowList(strPath = "workflow/2_metrics", strPackage = "gsm.kri")
analyzed <- RunWorkflows(metrics_wf, mapped)

# Step 3 - Create Reporting Layer - create reports using metrics data
reporting_wf <- MakeWorkflowList(strPath = "workflow/3_reporting", strPackage = "gsm.reporting")
reporting <- RunWorkflows(reporting_wf, c(mapped, list(lAnalyzed = analyzed,
                                                       lWorkflows = metrics_wf)))

# Step 4 - Create KRI Report - create KRI report using reporting data
module_wf <- MakeWorkflowList(strPath = "workflow/4_modules", strPackage = "gsm.kri")
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
# Below relies on the clindata stuff, do we need to rerun/rewrite reporting datasets?
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
