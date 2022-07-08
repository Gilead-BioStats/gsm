lData <- list(
  dfSUBJ = clindata::rawplus_subj,
  dfAE = clindata::rawplus_ae
)
StrataWorkflow<- MakeAssessmentList()$aeGrade

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  strat <- MakeStratifiedAssessment(
    lData=lData,
    lMapping=clindata::mapping_rawplus,
    lAssessment=StrataWorkflow
  )

  # New workflow created for each stratification level
  expect_equal(length(strat),length(unique(clindata::rawplus_ae$AE_GRADE)))

  # MakeStrata added as first step in each workflow
  expect_true(all(strat %>% map_lgl(~.x$workflow[[1]]$name == "MakeStrata")))
})

# output is created as expected -------------------------------------------
test_that("errors thrown for invalid groupings", {
  expect_error( MakeStratifiedAssessment(
    lData=list(),
    lMapping=clindata::mapping_rawplus,
    lAssessment=StrataWorkflow
  ))

  expect_error( MakeStratifiedAssessment(
    lData=lData,
    lMapping=list(),
    lAssessment=StrataWorkflow
  ))

  expect_error( MakeStratifiedAssessment(
    lData=lData,
    lMapping=clindata::mapping_rawplus,
    lAssessment=list()
  ))

  badWorkflow1 <- StrataWorkflow
  badWorkflow1$group$domain <- 'dfOther'
  expect_error(MakeStratifiedAssessment(
    lData=lData,
    lMapping=clindata::mapping_rawplus,
    lAssessment=BadWorkflow1
  ))

  badWorkflow2 <- StrataWorkflow
  badWorkflow2$group$columnParam <- 'NotACol'
  expect_error(MakeStratifiedAssessment(
    lData=lData,
    lMapping=clindata::mapping_rawplus,
    lAssessment=BadWorkflow2
  ))
})
