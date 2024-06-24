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
  File = "kri0001.yaml",
  Group = "site",
  Abbreviation = "AE",
  Metric = "Adverse Event Rate",
  Numerator = "Adverse Events",
  Denominator = "Days on Study",
  Model = "Normal Approximation",
  Score = "Adjusted Z-Score",
  strThreshold = '-2,-1,2,3'
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

dfSite <- clindata::ctms_site %>% 
rename(SiteID = site_num) %>% 
mutate(status="active") %>% 
mutate(enrolled_participants=10)  %>% 
mutate(invname = "bob jones")

dfStudy<-clindata::ctms_study %>% rename(StudyID = protocol_number)

# create Visualizations
devtools::load_all()
lCharts <- Visualize_Metric(
  dfSummary = dfSummary,
  dfBounds = dfBounds,
  dfSite = dfSite,
  dfMetrics = dfMetrics,
  strMetricID = dfMetrics$MetricID
)
lCharts$barMetricJS


# Run reports
strOutpath <- "~/gsm_site_report_kri0001.html"
Report_KRI(lCharts = lCharts,
           dfSummary = dfSummary,
           dfSite = dfSite,
           dfStudy = dfStudy,
           dfMetrics =dfMetrics,
           strOutpath = strOutpath)

                                                                                                
options(vsc.viewer = FALSE)                                                  