library(tidyr)
set.seed(1234)

# Step 0 - Simulate PK data for clindata participants
mapped_pk <- tidyr::crossing(
    subjid = unique(clindata::rawplus_dm$subjid),
    pktpt = c( 
        "Cycle 1 Day 1",
        "Cycle 1 Day 1",
        "Cycle 1 Day 1",
        "Cycle 1 Day 15",
        "Cycle 1 Day 2",
        "Cycle 1 Day 4",
        "Cycle 1 Day 8"
    )
)
mapped_pk$pkperf <- sample(c("Yes","No"), prob=c(0.95,0.05),nrow(mapped_pk), replace = TRUE)

pk_data <-list(
  Mapped_SUBJ= clindata::rawplus_dm,
  Mapped_PK= mapped_pk
)

# Example 1 - Standard KRI with normal approximation
pk_kri <- gsm::RunWorkflows(
  lWorkflow = MakeWorkflowList(strName = "kri0013.yaml"), 
  lData = pk_data
)
Widget_BarChart(dfResults = pk_kri$Analysis_kri0013$Analysis_Summary)

# Example 2 - KRI with custom flagging based on 90% threshold

pk_kri_alt <- gsm::RunWorkflows(
  lWorkflow = MakeWorkflowList(strName = "kri0013a.yaml"), 
  lData = pk_data
)
Widget_BarChart(dfResults = pk_kri_alt$Analysis_kri0013a$Analysis_Summary)


# Example 3 - Run Reports with other KRIs
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
    Source_STUDY = clindata::ctms_study,
    Source_PK = pk_data$Mapped_PK # only new line
)

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
reporting <- RunWorkflows(reporting_wf, c(mapped, list(lAnalyzed = analyzed, lWorkflows = metrics_wf)))

# Step 4 - Create KRI Report - create KRI report using reporting data
module_wf <- MakeWorkflowList(strPath = "workflow/4_modules")
lReports <- RunWorkflows(module_wf, reporting)
