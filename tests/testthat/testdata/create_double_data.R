# yaml workflow
test_wf <- MakeWorkflowList(
  strNames = "kri0001", strPath = "workflow/2_metrics"
)
test_mapping <- MakeWorkflowList(
  strPath = test_path("testdata/mappings"),
  strPackage = NULL
)
lRaw <- UseClindata(
  list(
    "Raw_SUBJ" = "clindata::rawplus_dm",
    "Raw_AE" = "clindata::rawplus_ae"
  )
)
lMapped <- quiet_RunWorkflows(lWorkflows = test_mapping, lData = lRaw)
lResults <- quiet_RunWorkflows(lWorkflows = test_wf, lData = lMapped)

# functional workflow
Mapped_SUBJ <- clindata::rawplus_dm %>%
  filter(enrollyn == "Y")
dfInput <- Input_Rate(
  dfSubjects = Mapped_SUBJ,
  dfNumerator = clindata::rawplus_ae,
  dfDenominator = Mapped_SUBJ,
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
