snapshot <- Make_Snapshot()

study_comp <- Covariate_Map(dfCovariate = snapshot$lStudyAssessResults$kri0006$lData$dfSTUDCOMP,
              strCovariateColName = "compreas",
              strWorkflowId = "kri0006"
              )

treat_comp <- Covariate_Map(dfCovariate = snapshot$lStudyAssessResults$kri0007$lData$dfSDRGCOMP,
              strCovariateColName = "sdrgreas",
              strWorkflowId = "kri0007"
              )

testthat::test_that("output is generated as expected", {
  expect_snapshot(study_comp)
  expect_snapshot(treat_comp)
  expect_error(Covariate_Map(dfCovariate = snapshot$lStudyAssessResults$kri0007$lData$dfSDRGCOMP,
                             strCovariateColName = "sdrgreas",
                             strWorkflowId = "kri007"
  ))
  expect_error(Covariate_Map(dfCovariate = snapshot$lStudyAssessResults$kri0007$lData$dfSDRGCOMP,
                             strCovariateColName = "sdrgrea",
                             strWorkflowId = "kri0007"
  ))
  expect_error(Covariate_Map(dfCovariate = list(snapshot$lStudyAssessResults$kri0007$lData$dfSDRGCOMP),
                             strCovariateColName = "sdrgreas",
                             strWorkflowId = "kri0007"
  ))
})


