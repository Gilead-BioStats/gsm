#### Example 1.1 - Generate an Adverse Event Metric using the standard {gsm} workflow

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
dfAnalyzed <- Analyze_NormalApprox(dfTransformed, strType = "rate")
dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-3,-2,2,3))
dfSummarized <- Summarize(dfFlagged)

table(dfSummarized$Flag)

#### Example 1.2 - Make an SAE Metric by adding a filter.  Also works with pipes.

SAE_KRI <- Input_Rate(
  dfSubjects= clindata::rawplus_dm,
  dfNumerator= clindata::rawplus_ae %>% filter(aeser=="Y"),
  dfDenominator = clindata::rawplus_dm,
  strSubjectCol = "subjid",
  strGroupCol = "siteid",
  strNumeratorMethod= "Count",
  strDenominatorMethod= "Sum",
  strDenominatorCol= "timeonstudy"
) %>%
  Transform_Rate %>%
  Analyze_NormalApprox(strType = "rate") %>%
  Flag_NormalApprox(vThreshold = c(-3,-2,2,3)) %>%
  Summarize

table(SAE_KRI$Flag)

### Example 1.3 - Visualize Metric distribution using Bar Charts using provided htmlwidgets
labels <- list(  
  Metric= "Serious Adverse Event Rate",
  Numerator= "Serious Adverse Events",
  Denominator= "Days on Study"
)

Widget_BarChart(dfResults = SAE_KRI, lMetric=labels, strOutcome="Metric")
Widget_BarChart(dfResults = SAE_KRI, lMetric=labels, strOutcome="Score")
Widget_BarChart(dfResults = SAE_KRI, lMetric=labels, strOutcome="Numerator")

### Example 1.4 - Create Scatter plot with confidence bounds
dfBounds <- Analyze_NormalApprox_PredictBounds(SAE_KRI, vThreshold = c(-3,-2,2,3))
Widget_ScatterPlot(SAE_KRI, lMetric = labels, dfBounds = dfBounds)
