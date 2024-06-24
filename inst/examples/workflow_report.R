# AE KRI Workflow with Charts and Report

dfInput <- Input_Rate(
  dfSubjects= clindata::rawplus_dm,
  dfNumerator= clindata::rawplus_ae,
  dfDenominator = clindata::rawplus_dm,
  strSubjectCol = "subjid",
  strGroupCol = "siteid",
  strNumeratorMethod= "Count",
  strDenominatorMethod= "Sum",
  strDenominatorCol= "timeonstudy"
)

dfTransformed <- Transform_Rate(dfInput)
dfAnalyzed <- Analyze_NormalApprox(dfTransformed,
                                   strType = "rate")
dfFlagged <- Flag_NormalApprox(dfAnalyzed,
                               vThreshold = c(-3,-2,2,3))
dfSummary <- Summarize(dfFlagged)
dfBounds <- Analyze_NormalApprox_PredictBounds(dfTransformed = dfTransformed,
                                               vThreshold = c(-3,-2,2,3))

##create dfMetrics meta object for charts
dfMetrics <- data.frame(
  MetricID =  "kri0001",
  file = "kri0001.yaml",
  group = "site",
  abbreviation = "AE",
  metric = "Adverse Event Rate",
  numerator = "Adverse Events",
  denominator = "Days on Study",
  model = "Normal Approximation",
  score = "Adjusted Z-Score"
)

#add Study and Snapshot information to dfBounds and dfSummarized
dfBounds <- dfBounds %>%
  mutate(StudyID = "ABC-123") %>%
  mutate(SnapshotDate = Sys.Date()) %>%
  mutate(MetricID = dfMetrics$MetricID)

dfSummary <- dfSummary %>%
  mutate(StudyID = "ABC-123") %>%
  mutate(SnapshotDate = Sys.Date()) %>%
  mutate(MetricID = dfMetrics$MetricID)


# create Visualizations
lCharts <- Visualize_Metric(
  dfSummary = dfSummary,
  dfBounds = dfBounds,
  dfSite = clindata::ctms_site %>% rename(SiteID = site_num),
  dfMetrics = dfMetrics,
  strMetricID = dfMetrics$MetricID
)

# Run reports
strOutpath <- "~/gsm_site_report_kri0001.html"
Report_KRI(lCharts = lCharts,
           dfSummary = dfSummarized,
           dfSite = dfSite,
           dfStudy = dfStudy,
           dfMetrics =dfMetrics,
           strOutpath = strOutpath)
