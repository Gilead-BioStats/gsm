# Generate an SAE KRI from raw data using pipes

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
