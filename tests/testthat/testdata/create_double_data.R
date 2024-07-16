# yaml workflow
test_wf <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "test_workflow")
test_mapping <- MakeWorkflowList(strPath = test_path("testdata"), strNames = "mapping")
lRaw <- UseClindata(
  list(
    "dfSUBJ" = "clindata::rawplus_dm",
    "dfAE" = "clindata::rawplus_ae"
  )
)
lMapped <- quiet_RunWorkflow(lWorkflow = test_mapping[[1]], lData = lRaw)
lResults <- quiet_RunWorkflow(lWorkflow = test_wf[[1]], lData = lMapped)

# functional workflow
dfSeriousAE <- clindata::rawplus_ae %>%
  dplyr::filter(aeser == "Y")
dfInput <- Input_Rate(
  dfSubjects = clindata::rawplus_dm,
  dfNumerator = dfSeriousAE,
  dfDenominator = clindata::rawplus_dm,
  strSubjectCol = "subjid",
  strGroupCol = "siteid",
  strNumeratorMethod = "Count",
  strDenominatorMethod = "Sum",
  strDenominatorCol = "timeonstudy"
)
dfTransformed <- Transform_Rate(dfInput)
dfAnalyzed <- quiet_Analyze_NormalApprox(dfTransformed, strType = "rate")
dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-2,-1,2,3))
dfSummarized <- Summarize(dfFlagged)
