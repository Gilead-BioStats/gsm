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

wf_mapping <- MakeWorkflowList(strNames = "mapping")
wf_kri <- MakeWorkflowList(strNames="kri")
wf_reporting <- MakeWorkflowList(strNames = "reporting")
wf_reports <- MakeWorkflowList(strNames = "reports")

# Generate Mapped Data
lMapped <- RunWorkflows(lWorkflow = wf_mapping, lData = lRaw)

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

lReporting <- RunWorkflows(lWorkflow = wf_reporting, lData = lReporting_Input)

# Generate Report
devtools::load_all()
wf_reports <- MakeWorkflowList(strNames = "reports")
lReports <- RunWorkflows(lWorkflow = wf_reports, lData = lReporting)

# Lazy longitudinal data
dfSummary <- lReporting$dfSummary
dfSummary_long <- bind_rows(
  dfSummary %>% mutate(SnapshotDate = Sys.Date()),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 1),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 14)
)

#Create Charts for all metrics
options(vsc.viewer = FALSE)
metrics<- unique(lReporting$dfMetrics$MetricID)
charts <- metrics %>% map(~Visualize_Metric(
  dfSummary = dfSummary_long,
  dfBounds = lReporting$dfBounds,
  dfGroups = lReporting$dfGroups,
  dfMetrics = lReporting$dfMetrics %>% mutate(GroupLevel = "Site"),
  strMetricID = .x
)
) %>% setNames(metrics)


devtools::load_all()
Report_KRI(
  lCharts = charts,
  dfSummary = dfSummary_long,
  dfStudy = dfStudy,
  dfSite = dfSite,
  dfMetrics = dfMetrics,
  strOutpath = "test.html"
)

# Overview Table
  Widget_SiteOverview(
    dfSummary= dfSummary_long,
    dfGroups= dfSite,
    dfMetrics= dfMetrics,
    bDebug=TRUE
  )
# Just one metric

dfSummary <- lReporting$dfSummary %>% filter(MetricID == "kri0001")
dfBounds <- lReporting$dfBounds %>% filter(MetricID == "kri0001")
dfGroups <- lReporting$dfGroups
dfMetrics <- lReporting$dfMetrics %>% filter(MetricID == "kri0001")
lMetric <- as.list(dfMetrics %>% filter(MetricID == "kri0001"))
lMetric$GroupLevel <- "Site"
vThreshold <- gsm::ParseThreshold(lMetric$strThreshold)

lCharts <- Visualize_Metric(
  dfSummary = dfSummary_long,
  dfBounds = dfBounds,
  dfGroups = dfGroups,
  dfMetrics = dfMetrics,
  strMetricID = "kri0001",
  bDebug = TRUE
)

## Individual Cross sectional charts (for testing)


 devtools::load_all()
 gsm::Widget_ScatterPlot(
  dfSummary = dfSummary ,
  lMetric = lMetric,
  dfGroups = dfGroups,
  dfBounds = dfBounds,
  bDebug=TRUE
)

gsm::Visualize_Scatter(
  dfSummary = dfSummary,
  dfBounds = dfBounds,
  strGroupLabel = lMetric$Group
)

 gsm::Widget_BarChart(
  dfResults = dfResults,
  lMetrics = lMetric,
  dfGroups = dfSites,
  strOutcome = "Metric"
)

gsm::Widget_BarChart(
  dfSummary = dfSummary,
  lMetric = lMetric,
  dfGroups = dfSites,
  vThreshold = vThreshold,
  strOutcome = "Score"
)

gsm::Visualize_Score(
  dfSummary = dfSummary,
  strType = "Metric"
)

gsm::Visualize_Score(
  dfSummary = dfSummary,
  strType = "Score",
  vThreshold = gsm::ParseThreshold(lMetric$strThreshold)
)

# Longitudinal charts
dfSummary_long <- bind_rows(
  dfSummary %>% mutate(SnapshotDate = Sys.Date()),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 1),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 14)
)

Widget_TimeSeries(
  dfSummary = dfSummary_long,
  lMetric = lMetric,
  dfGroups = dfSites,
  vThreshold = vThreshold,
  strOutcome = "Score"
)

Widget_TimeSeries(
  dfSummary = dfSummary_long,
  lMetric = lMetric,
  dfGroups = dfSites,
  strOutcome = "Metric",
  bDebug = TRUE
)

Widget_TimeSeries(
  dfSummary = dfSummary_long,
  lMetric = lMetric,
  dfGroups = dfSite,
  strOutcome = "Numerator"
)



# Check Reporting outputs (for testing)
dfGroups <- lReporting$dfGroups
head(dfGroups)
table(paste(dfGroups$GroupLevel, dfGroups$Param))

dfMetrics <- lReporting$dfMetrics
head(dfMetrics)

dfSummary <- lReporting$dfSummary
head(dfSummary)
table(dfSummary$MetricID, dfSummary$Flag)

dfBounds <- lReporting$lData$dfBounds
head(dfBounds)
