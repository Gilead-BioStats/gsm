# yaml workflow
test_wf <- MakeWorkflowList(
  strNames = "kri0001"
)
test_mapping <- MakeWorkflowList(
  strPath = test_path("testdata"),
  strNames = "mapping",
  strPackage = NULL
)
lRaw <- UseClindata(
  list(
    "Raw_SUBJ" = "clindata::rawplus_dm",
    "Raw_AE" = "clindata::rawplus_ae"
  )
)
lMapped <- quiet_RunWorkflow(lWorkflow = test_mapping[[1]], lData = lRaw)
lResults <- quiet_RunWorkflow(lWorkflow = test_wf[[1]], lData = lMapped)

# functional workflow
dfAE <- clindata::rawplus_ae %>%
  dplyr::filter(aeser == "Y")
dfInput <- Input_Rate(
  dfSubjects = clindata::rawplus_dm,
  dfNumerator = dfAE,
  dfDenominator = clindata::rawplus_dm,
  strSubjectCol = "subjid",
  strGroupCol = "invid",
  strNumeratorMethod = "Count",
  strDenominatorMethod = "Sum",
  strDenominatorCol = "timeonstudy"
)
dfTransformed <- Transform_Rate(dfInput)
dfAnalyzed <- quiet_Analyze_NormalApprox(dfTransformed, strType = "rate")
dfFlagged <- Flag_NormalApprox(dfAnalyzed, vThreshold = c(-2, -1, 2, 3))
dfSummarized <- Summarize(dfFlagged)
#
