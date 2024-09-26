load_all()

# ----
# Run process from the study directory.

setwd(
    system.file(
        'examples',
        'AA-AA-000-0000',
        package = 'gsm'
    )
)

# Create snapshot sub-directories and inject snapshot date into the configuration.
strSnapshotDate <- 1:(as.integer(Sys.Date() - as.Date(0))) %>%
  sample(1) %>%
  as.Date()

source('R/UpdateConfig.R')
lConfig <- UpdateConfig(
    strSnapshotDate = strSnapshotDate
)

# ----
# mapped data

mapped_data <- './workflows/1_mappings' %>%
    gsm::MakeWorkflowList(strPath = ., strPackage = NULL) %>%
    gsm::RunWorkflows(lConfig = lConfig)

# ----
# analysis data

analysis_data <- './workflows/2_metrics' %>%
    gsm::MakeWorkflowList(strPath = ., strPackage = NULL) %>%
    gsm::RunWorkflows(lConfig = lConfig)

# ----
# reporting data

reporting_data <- './workflows/3_reporting' %>%
    gsm::MakeWorkflowList(strPath = ., strPackage = NULL) %>%
    gsm::RunWorkflows(lConfig = lConfig)

# ----
# generate reports

report_kri_site <- './workflows/4_modules/report_kri_site.yaml' %>%
    yaml::read_yaml() %>%
    gsm::RunWorkflow(lConfig = lConfig)

report_kri_country <- './workflows/4_modules/report_kri_country.yaml' %>%
    yaml::read_yaml() %>%
    gsm::RunWorkflow(lConfig = lConfig)
