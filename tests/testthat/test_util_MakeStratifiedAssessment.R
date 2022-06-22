# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  lData <- list(
    dfSUBJ = clindata::rawplus_subj,
    dfPD = clindata::rawplus_pd
  )
  StrataWorkflow<- MakeAssessmentList()$pdCategory

  strat <- MakeStratifiedAssessment(
    lData=lData, 
    lMapping=clindata::mapping_rawplus,
    lAssessment=StrataWorkflow
  )
})
