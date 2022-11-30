source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::QueryRate_Assess

dfInput <- gsm::QueryRate_Map_Raw(dfs = list(dfSUBJ = dfSUBJ, dfQUERY = dfQUERY, dfDATACHG = dfDATACHG))

output_spec <- yaml::read_yaml(system.file("specs", "QueryRate_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "QueryRate_Assess.yaml", package = "gsm"))

test_that("valid output is returned", {
  test_valid_output_assess(
    assess_function,
    dfInput
  )
})

test_that("grouping works as expected", {
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

test_that("NA in dfInput$Count throws errors", {
  test_NA_count(
    assess_function,
    dfInput
  )
})

test_that("bQuiet works as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})
