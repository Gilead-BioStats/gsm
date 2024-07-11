# This example demonstrates how to calculate a Key Risk Indicator (KRI) for
# missing visits.

# ----- Simulate a data set with participant-level visit status ----#
set.seed(123)
Visit <- c("V1", "V2", "V3", "V4", "V5")
sites <- seq(1,20)
n <- 1000

dfSubjects <- data.frame(
  SubjID = 1:n,
  SiteID = sample(sites, n, replace = TRUE)
)
dfVisits <- tidyr::crossing(dfSubjects, Visit)
dfVisits$Status <- sample(
  c("Attended", "Missed"),
  nrow(dfVisits),
  prob = c(0.5,0.5),
  replace = TRUE
)
dfVisits$Status[dfVisits$SiteID == 1] <- sample(
  c("Attended", "Missed"),
  length(dfVisits$Status[dfVisits$SiteID == 1]),
  prob = c(0.9,0.1),
  replace = TRUE
)
dfVisits$Status[dfVisits$SiteID == 2] <- sample(
  c("Attended", "Missed"),
  length(dfVisits$Status[dfVisits$SiteID == 2]),
  prob = c(0.8,0.2),
  replace = TRUE
)
dfVisits$Status[dfVisits$SiteID == 3] <- sample(
  c("Attended", "Missed"),
  length(dfVisits$Status[dfVisits$SiteID == 3]),
  prob = c(0,1),
  replace = TRUE
)

dfVisits$VisitOccurred <- ifelse(dfVisits$Status == "Attended", 1, 0)

# ----- Generate a KRI for missing visits -----
dfInput <- Input_Rate(
  dfSubjects = dfSubjects,
  dfNumerator = dfVisits,
  dfDenominator = dfVisits,
  strSubjectCol = "SubjID",
  strGroupCol = "SiteID",
  strNumeratorCol = "VisitOccurred",
  strNumeratorMethod = "Sum",
  strDenominatorMethod = "Count"
)

dfTransformed <- Transform_Rate(dfInput)
dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
dfBounds <- Analyze_NormalApprox_PredictBounds(
  dfTransformed = dfTransformed,
  vThreshold = c(-2,-1,1,2)
)
dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-2,-1,1,2))
dfSummary <- Summarize(dfFlagged)

table(dfSummary$Flag)

# ----- Generate a scatter plot for the KRI -----
lMetric <- list(
    MetricID = "kri0001",
    Metric = "Missing Visits",
    MetricType = "Rate",
    Numerator = "Visits Occurred",
    Denominator = "Visits Expected",
    Score = "Adjusted Z-Score",
    Group = "Site",
    Description = "KRI for missing visits",
    BoundsType = "NormalApprox",
    strThreshold = "-2,-1,1,2"
)

Widget_ScatterPlot(
  dfSummary = dfSummary,
  lMetric = lMetric,
  dfBounds = dfBounds
)

# ----- Run KRI via a workflow ----
workflow <- read_yaml(text='meta:
    MetricID: kri0013
    Metric: Missing Visits
    MetricType: Rate
    Numerator: Visits Occurred
    Denominator: Visits Expected
    Score: Adjusted Z-Score
    Group: Site
    Description: KRI for missing visits
    BoundsType: NormalApprox
    strThreshold: -2,-1,1,2
    nMinDenominator: 30
steps:
  - name: ParseThreshold
    output: vThreshold
    params:
      strThreshold: strThreshold
  - name: Input_Rate
    output: dfInput
    params:
      dfSubjects: dfSubjects
      dfNumerator: dfVisits
      dfDenominator: dfVisits
      strSubjectCol: SubjID
      strGroupCol: SiteID
      strNumeratorCol: VisitOccurred
      strNumeratorMethod: Sum
      strDenominatorMethod: Count
  - name: Transform_Rate
    output: dfTransformed
    params:
      dfInput: dfInput
  - name: Analyze_NormalApprox
    output: dfAnalyzed
    params:
      dfTransformed: dfTransformed
      strType: rate
  - name: Analyze_NormalApprox_PredictBounds
    output: dfBounds
    params:
      dfTransformed: dfTransformed
      strType: rate
      vThreshold: vThreshold
  - name: Flag_NormalApprox
    output: dfFlagged
    params:
      dfAnalyzed: dfAnalyzed
      vThreshold: vThreshold
  - name: Summarize
    output: dfSummary
    params:
      dfFlagged: dfFlagged
      nMinDenominator: nMinDenominator

')
result <- RunWorkflows(
  lWorkflows = workflow,
  lData = list(dfSubjects = dfSubjects,dfVisits = dfVisits)
)
Widget_ScatterPlot(
  dfSummary = result$dfSummary,
  dfBounds = result$dfBounds,
  lMetric = workflow$MissingVisitsKRI$meta
)
