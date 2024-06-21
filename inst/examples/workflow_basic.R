# AE KRI Workflow
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

