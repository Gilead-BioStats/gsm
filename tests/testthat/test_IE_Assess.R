assess_function <- gsm::IE_Assess

dfInput <- IE_Map_Raw() %>%
  slice(1:50)

output_spec <- yaml::read_yaml(system.file("specs", "IE_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "IE_Assess.yaml", package = "gsm"))

test_that("valid output is returned", {
  test_valid_output_assess_identity(
    assess_function,
    dfInput,
    output_spec,
    output_mapping
  )
})

test_that("grouping works as expected", {
  dfInput$StudyID[26:50] <- "AA-AA-000-0001" ## Fisher doesn't support single input

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
  test_invalid_data_assess_identity(
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

test_that("bQuiet works as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})
