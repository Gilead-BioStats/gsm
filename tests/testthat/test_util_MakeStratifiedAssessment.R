lData <- list(
  dfSUBJ = clindata::rawplus_subj,
  dfAE = clindata::rawplus_ae
)
StrataWorkflow<- MakeAssessmentList()$aeGrade

lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  strat <- MakeStratifiedAssessment(
    StrataWorkflow,
    lData,
    lMapping
  )

  # New workflow created for each stratification level
  expect_equal(
    length(strat),
    length(unique(clindata::rawplus_ae$AE_GRADE))
  )

  # FilterData added as first step in each workflow
  expect_true(
    all(strat %>% map_lgl(~.x$workflow[[1]]$name == "FilterData"))
  )
})

# output is created as expected -------------------------------------------
test_that("errors thrown for invalid groupings", {
  expect_error(
    MakeStratifiedAssessment(
      list(),
      lData,
      lMapping
    )
  )

  expect_error(
    MakeStratifiedAssessment(
      StrataWorkflow,
      list(),
      lMapping
    )
  )

  expect_error(
    MakeStratifiedAssessment(
      StrataWorkflow,
      lData,
      list()
    )
  )

  badWorkflow1 <- StrataWorkflow
  badWorkflow1$group$domain <- 'dfOther'
  expect_error(
    MakeStratifiedAssessment(
      badWorkflow1,
      lData,
      lMapping
    )
  )

  badWorkflow2 <- StrataWorkflow
  badWorkflow2$group$columnParam <- 'NotACol'
  expect_error(
    MakeStratifiedAssessment(
      badWorkflow2,
      lData,
      lMapping
    )
  )
})
