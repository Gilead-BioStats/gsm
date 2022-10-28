source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::LB_Assess

dfInput <- dfInputLB

output_spec <- yaml::read_yaml(system.file("specs", "LB_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "LB_Assess.yaml", package = "gsm"))

<<<<<<< HEAD
test_that("valid output is returned", {
  test_valid_output_assess_fisher(
    assess_function,
    dfInput
  )
=======
# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment <- assess_function(dfInput)
  expect_true(is.list(assessment))
  expect_equal(names(assessment), c("lData", "lCharts", "lChecks"))
  expect_equal(names(assessment$lData), c("dfTransformed", "dfAnalyzed", "dfBounds", "dfFlagged", "dfSummary"))
  expect_true("data.frame" %in% class(assessment$lData$dfTransformed))
  expect_true("data.frame" %in% class(assessment$lData$dfAnalyzed))
  expect_true("data.frame" %in% class(assessment$lData$dfFlagged))
  expect_true("data.frame" %in% class(assessment$lData$dfSummary))
  expect_equal(names(assessment$lCharts), c("scatter", "barMetric", "barScore"))
  expect_true(assessment$lChecks$status)
>>>>>>> dev
})

test_that("grouping works as expected", {
  dfInput$StudyID[101:199] <- "AA-AA-000-0001" ## Fisher doesn't support single input
  dfInput$CountryID[101:199] <- "Bora Bora"

  test_grouping_assess(
    assess_function,
    dfInput
  )
})

test_that("invalid data throw errors", {
  test_invalid_data_assess(
    assess_function,
    dfInput
  )
})

test_that("missing column throws errors", {
  test_missing_column_assess(
    assess_function,
    dfInput
  )
})

test_that("invalid mapping throws errors", {
  test_invalid_mapping_assess(
    assess_function,
    dfInput,
    output_spec
  )
})

test_that("strMethod = 'identity' works as expected", {
  test_identity(
    assess_function,
    dfInput
  )
})

test_that("bQuiet works as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})
