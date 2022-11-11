source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::LB_Assess

dfInput <- dfInputLB

output_spec <- yaml::read_yaml(system.file("specs", "LB_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "LB_Assess.yaml", package = "gsm"))

test_that("valid output is returned", {
  test_valid_output_assess(
    assess_function,
    dfInput
  )
})

test_that("grouping works as expected", {
  dfInput$StudyID[501:1000] <- "AA-AA-000-0001" ## Fisher doesn't support single input
  dfInput$CountryID[501:1000] <- "Bora Bora"

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
