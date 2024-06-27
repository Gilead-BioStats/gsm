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
lMapped <- RunWorkflow(lWorkflow = wf_mapping, lData = lRaw)$lData

# Generate Analysis Results Data
lAnalysis <- wf_kri %>% map(~RunWorkflow(lWorkflow = .x, lData = lMapped))

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

lReporting <- RunWorkflow(lWorkflow = wf_reporting, lData = lReporting_Input)

# Convience Mappings
dfGroups <- lReporting$lData$dfGroups
dfMetrics <- lReporting$lData$dfMetrics
dfSummary <- lReporting$lData$dfSummary
dfBounds <- lReporting$lData$dfBounds

# Create dfSites and dfStudy pending rbm-viz update to use dfGroups
dfSite <- dfSites <- dfGroups %>% 
  filter(GroupLevel == "Site") %>% 
  pivot_wider(names_from=Param, values_from=Value) %>%
  rename(
    SiteID = GroupID, 
    status = Status,
    enrolled_participants = ParticipantCount
  ) 

dfStudy <- dfStudies <- dfGroups %>% filter(GroupLevel == "Study") %>% pivot_wider(names_from=Param, values_from=Value)  

# Lazy longitudinal data
dfSummary_long <- bind_rows(
  dfSummary %>% mutate(SnapshotDate = Sys.Date()),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 1),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 14)
)

#Create Charts for all metrics
options(vsc.viewer = FALSE)
metrics <- dfMetrics %>% pull(MetricID)
charts <- metrics %>% map(~Visualize_Metric(
  dfSummary = dfSummary_long,
  dfBounds = dfBounds,
  dfSite = dfSite,
  dfMetrics = dfMetrics,
  strMetricID = .x
)
) %>% setNames(metrics)

# Just one metric 
charts <- Visualize_Metric(
  dfSummary = dfSummary_long,
  dfBounds = dfBounds,
  dfSite = dfSite,
  dfMetrics = dfMetrics,
  strMetricID = "kri0001"
)

## Individual Cross sectional charts (for testing)
lMetrics <- as.list(dfMetrics)
 gsm::Widget_ScatterPlot(
  dfSummary = dfSummary,
  lLabels = lMetrics,
  dfSite = dfSites,
  dfBounds = dfBounds
)

gsm::Visualize_Scatter(
  dfSummary = dfSummary,
  dfBounds = dfBounds,
  strGroupLabel = lMetrics$Group
)

 gsm::Widget_BarChart(
  dfSummary = dfSummary,
  lLabels = lMetrics,
  dfSite = dfSites,
  strYAxisType = "Metric"
)

gsm::Widget_BarChart(
  dfSummary = dfSummary,
  lLabels = lMetrics,
  dfSite = dfSites,
  strYAxisType = "Score"
)

gsm::Visualize_Score(
  dfSummary = dfSummary,
  strType = "Metric"
)

gsm::Visualize_Score(
  dfSummary = dfSummary,
  strType = "Score",
  vThreshold = gsm::ParseThreshold(lMetrics$strThreshold)
)

# Longitudinal charts
dfSummary_long <- bind_rows(
  dfSummary %>% mutate(SnapshotDate = Sys.Date()),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 1),
  dfSummary %>% mutate(SnapshotDate = Sys.Date() - 14)
)

Widget_TimeSeries(
      dfSummary = dfSummary_long,
      lLabels = dfMetrics,
      dfSite = dfSite,
      vThresholds = ParseThreshold(lMetrics$strThreshold),
      yAxis = "Score"
    )

Widget_TimeSeries(
      dfSummary = dfSummary_long,
      lLabels = dfMetrics,
      dfSite = dfSite,
      yAxis = "Metric"
    )

Widget_TimeSeries(
      dfSummary = dfSummary_long,
      lLabels = dfMetrics,
      dfSite = dfSite,
      yAxis = "Numerator"
    )



# Check Reporting outputs (for testing)
dfGroups <- lReporting$lData$dfGroups
head(dfGroups)
table(paste(dfGroups$GroupLevel, dfGroups$Param))

dfMetrics <- lReporting$lData$dfMetrics
head(dfMetrics)

dfSummary <- lReporting$lData$dfSummary
head(dfSummary)
table(dfSummary$MetricID, dfSummary$Flag)

dfBounds <- lReporting$lData$dfBounds
head(dfBounds)
