source(testthat::test_path("testdata/data.R"))

map_function <- gsm::Disp_Map_Raw

dfs <- list(
  dfDISP = dfDISP
)

input_spec <- yaml::read_yaml(system.file("specs", "Disp_Map_Raw.yaml", package = "gsm"))
input_mapping <- yaml::read_yaml(system.file("mappings", "Disp_Map_Raw.yaml", package = "gsm"))


output_spec <- yaml::read_yaml(system.file("specs", "Disp_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "Disp_Assess.yaml", package = "gsm"))

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



# custom tests ------------------------------------------------------------
test_that("strReason = 'any' works as expected", {
  output <- Disp_Map_Raw(dfs = list(dfDISP = dfDISP),
    strReason = "any"
  )

  expect_equal(c("SubjectID", "SiteID", "Reason", "Count"), names(output))

  expect_true(
    nrow(output %>%
      group_by(SubjectID) %>%
      filter(n() > 1)) == 0
  )

  expect_equal(0, output %>%
    filter(Reason == "Completed") %>%
    summarize(total = sum(Count)) %>%
    pull(total))
})


test_that("strReason works when set to specific reason", {
  output <- Disp_Map_Raw(dfs = list(dfDISP = dfDISP),
    strReason = "adverse event"
  )

  expect_equal(
    names(output),
    c("SubjectID", "SiteID", "Reason", "Count")
  )

  expect_true(
    nrow(output %>%
      group_by(SubjectID) %>%
      filter(n() > 1)) == 0
  )
})


test_that("strReason can't also be in vReasonIgnore", {

  strReason <- "adverse event"
  lMapping <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  lMapping$dfDISP$strIgnoreVal <- c(" ", "", "adverse event")

  expect_error(
    Disp_Map_Raw(
      dfs = list(dfDISP = dfDISP),
      strReason = strReason,
      lMapping = lMapping
      )
  )
})


test_that("strIgnoreVal works as intended", {

  dfDISP <- dplyr::tibble(
    SUBJID = c(1:4),
    SITEID = c(1:4),
    DCREASCD = c("", " ", "completed", NA)
  )

  dfInput <- Disp_Map_Raw(dfs = list(dfDISP = dfDISP))

  expect_equal(dfInput %>%
                 summarize(total = sum(Count)) %>%
                 pull(total), 0)
})
