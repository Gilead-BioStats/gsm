source(testthat::test_path("testdata/data.R"))

map_function <- gsm::DataEntry_Map_Raw

dfs <- list(
  dfDATAENT = clindata::edc_data_pages,
  dfSUBJ = dfSUBJ
)

input_spec <- yaml::read_yaml(system.file("specs", "DataEntry_Map_Raw.yaml", package = "gsm"))
input_mapping <- subset_input_mapping(input_spec = input_spec, mapping_domain = "mapping_edc.yaml")

output_spec <- yaml::read_yaml(system.file("specs", "DataEntry_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "DataEntry_Assess.yaml", package = "gsm"))

test_that("metadata have not changed", {
  expect_snapshot_value(input_spec, "json2")
  expect_snapshot_value(input_mapping, "json2")

  expect_snapshot_value(output_spec, "json2")
  expect_snapshot_value(output_mapping, "json2")
})

test_that("valid output is returned", {
  test_valid_output(
    map_function,
    dfs,
    output_spec,
    output_mapping
  )
})

test_that("invalid data throw errors", {
  test_invalid_data(
    map_function,
    dfs,
    input_spec,
    input_mapping
  )
})

test_that("missing column throws errors", {
  test_missing_column(
    map_function,
    dfs,
    input_spec,
    input_mapping
  )
})

test_that("missing value throws errors", {
  test_missing_value(
    map_function,
    dfs,
    input_spec,
    input_mapping
  )
})

test_that("duplicate subject ID is detected", {
  test_duplicate_subject_id(map_function, dfs)
})

test_that("invalid mapping throws errors", {
  test_invalid_mapping(
    map_function,
    dfs,
    input_spec,
    input_mapping
  )
})

test_that("bQuiet and bReturnChecks work as intended", {
  test_logical_parameters(map_function, dfs)
})
