source(testthat::test_path("testdata/data.R"))

dfAE <- dfAE %>%
  mutate(subjid = NA)
dfSUBJ <- dfSUBJ

lData <- list(
  dfAE = dfAE,
  dfSUBJ = dfSUBJ
)

lResults <- Study_Assess(lData = lData)
warnings <- ParseWarnings(lResults)

test_that("output is generated as expected", {
  expect_true("data.frame" %in% class(warnings))
  expect_equal(names(warnings), c("workflowid", "status", "notes"))
})

test_that("invalid data throw errors", {
  expect_true(is.list(lResults))
  expect_null(warnings("Hi")[["lData"]])
  expect_error(ParseWarnings(dfSUBJ))
})


test_that("invalid workflows are caught", {

  workflow <- MakeWorkflowList(strNames = c("kri0001", "kri0003", "kri0005"))
  workflow$kri0001$steps <- NULL

  workflow$kri0003$steps[[2]]$name <- 'not_a_gsm_function'

  lData <- list(
    dfAE = dfAE,
    dfSUBJ = dfSUBJ,
    dfPD = dfPD,
    dfLB = dfLB
  )

  study <- Study_Assess(lData = lData, lAssessments = workflow)

  warnings <- ParseWarnings(study)

  expect_snapshot(warnings)

})
