assess_function <- gsm::AE_Assess

dfInput <- AE_Map_Raw() %>%
  slice(1:50)

output_spec <- yaml::read_yaml(system.file("specs", "AE_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "AE_Assess.yaml", package = "gsm"))

test_that("valid output is returned", {
  test_valid_output_assess_poisson(
    assess_function,
    dfInput,
    output_spec,
    output_mapping,
    vThreshold = c(-7.1, -5.1, 5.1, 7.1)
  )
})

test_that("grouping works as expected", {
  test_grouping_assess(
    assess_function,
    dfInput,
    output_spec,
    output_mapping
  )
})

test_that("invalid data throw errors", {
  test_invalid_data_assess(
    assess_function,
    dfInput,
    output_spec,
    output_mapping
  )
})

test_that("missing column throws errors", {
  test_missing_column_assess(
    assess_function,
    dfInput,
    output_spec,
    output_mapping
  )
})

test_that("invalid mapping throws errors", {
  test_invalid_mapping_assess(
    assess_function,
    dfInput,
    output_spec,
    output_mapping
  )
})

test_that("strMethod = 'identity' works as expected", {
  test_identity(
    assess_function,
    dfInput,
    output_spec,
    output_mapping
  )
})

test_that("NA in dfInput$Count throws errors", {
  test_NA_count(
    assess_function,
    dfInput,
    output_spec,
    output_mapping
  )
})

test_that("bQuiet works as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})
