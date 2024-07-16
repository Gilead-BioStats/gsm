devtools::load_all()
# Load raw data and workflows
lRaw <- list(
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

wf_mapping <- MakeWorkflowList(strNames = "mapping")[[1]]
wf_kri <- MakeWorkflowList(strNames="kri")
wf_reporting <- MakeWorkflowList(strNames = "reporting")[[1]]

# Generate Mapped Data
lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lRaw)

# Generate Analysis Results Data
lAnalysis <- RunWorkflows(lWorkflow = wf_kri, lData = lMapped)

# Generate Reporting Data
lReporting_Input <- list(
    ctms_site = clindata::ctms_site,
    ctms_study = clindata::ctms_study,
    dfEnrolled =lMapped$dfEnrolled,
    lWorkflows = wf_kri,
    lAnalysis = lAnalysis,
    dSnapshotDate = Sys.Date(),
    strStudyID = "ABC-123"
)

# Check Reporting outputs
lReporting <- RunWorkflow(lWorkflow = wf_reporting, lData = lReporting_Input)

dfGroups <- lReporting$dfGroups
head(dfGroups)
table(paste(dfGroups$GroupLevel, dfGroups$Param))

dfMetrics <- lReporting$dfMetrics
head(dfMetrics)

dfSummary <- lReporting$dfSummary
head(dfSummary)
table(dfSummary$MetricID, dfSummary$Flag)

dfBounds <- lReporting$dfBounds
head(dfBounds)
