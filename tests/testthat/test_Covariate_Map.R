snapshot <- Make_Snapshot()

treat_comp <- Covariate_Map(dfCovariate = snapshot$lStudyAssessResults$kri0007$lData$dfSDRGCOMP,
              strCovariateColName = "sdrgreas",
              strWorkflowId = "kri0007"
              )

testthat::test_that("output is generated as expected", {
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


