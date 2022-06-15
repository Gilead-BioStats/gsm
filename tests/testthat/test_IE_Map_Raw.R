source(testthat::test_path("testdata/data.R"))

map_function <- gsm::IE_Map_Raw

dfs <- list(
    dfIE = dfIE,
    dfSUBJ = dfSUBJ
)

input_spec <- yaml::read_yaml(paste0(here::here(), '/inst/specs/IE_Map_Raw.yaml'))
input_mapping <- yaml::read_yaml(paste0(here::here(), '/inst/mappings/IE_Map_Raw.yaml'))

output_spec <- yaml::read_yaml(paste0(here::here(), '/inst/specs/IE_Assess.yaml'))
output_mapping <- yaml::read_yaml(paste0(here::here(), '/inst/mappings/IE_Assess.yaml'))

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

test_that('duplicate subject ID is detected', {
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
