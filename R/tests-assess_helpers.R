test_valid_output_assess <- function(
    assess_function,
    dfInput,
    spec,
    mapping,
    vThreshold
) {
  output <- assess_function(dfInput = dfInput)

  testthat::expect_true(is.list(output))
  testthat::expect_equal(names(output), c("lData", "lCharts", "lChecks"))
  testthat::expect_equal(names(output$lData), c("dfTransformed", "dfAnalyzed", "dfBounds", "dfFlagged", "dfSummary"))
  testthat::expect_equal(names(output$lCharts), c("scatter", "barMetric", "barScore"))
  testthat::expect_true("data.frame" %in% class(output$lData$dfTransformed))
  testthat::expect_true("data.frame" %in% class(output$lData$dfAnalyzed))
  testthat::expect_true("data.frame" %in% class(output$lData$dfBounds))
  testthat::expect_true("data.frame" %in% class(output$lData$dfFlagged))
  testthat::expect_true("data.frame" %in% class(output$lData$dfSummary))
  testthat::expect_true(output$lChecks$status)

}

################################################################

test_grouping_assess <- function(
    assess_function,
    dfInput,
    spec,
    mapping
) {
  subsetGroupCols <- function(assessOutput) {
    assessOutput[["lData"]][["dfSummary"]] %>% select("GroupID")
  }

  site <- assess_function(dfInput)
  study <- assess_function(dfInput, strGroup = "Study")
  country <- assess_function(dfInput, strGroup = "Country")
  customGroup <- assess_function(dfInput, strGroup = "CustomGroup")

  expect_snapshot(subsetGroupCols(site))
  expect_snapshot(subsetGroupCols(study))
  expect_snapshot(subsetGroupCols(country))
  expect_snapshot(subsetGroupCols(customGroup))
  expect_false(all(map_lgl(list(site, study, country, customGroup), ~ all(map_lgl(., ~ is_grouped_df(.))))))
}

################################################################

test_invalid_data_assess <- function(
    assess_function,
    dfInput,
    spec,
    mapping
) {
  expect_null(assess_function("Hi")[["lData"]])
  expect_snapshot_error(assess_function(dfInput, strMethod = 123))
  expect_snapshot_error(assess_function(dfInput, strMethod = "abacus"))
  expect_snapshot_error(assess_function(dfInput, strMethod = c("identity", "poisson")))
  expect_snapshot_error(assess_function(dfInput, vThreshold = "A"))
  expect_snapshot_error(assess_function(dfInput, vThreshold = 1))
  expect_error(assess_function(dfInput, strGroup = "something"))
}

################################################################

test_missing_column_assess <- function(
    assess_function,
    dfInput,
    spec,
    mapping
) {
  dfInput_test <- dfInput %>% select(-c(SiteID))
  missing_req_col <- assess_function(dfInput = dfInput_test)
  expect_silent(missing_req_col)
  expect_null(missing_req_col$lData)
  expect_null(missing_req_col$lCharts)
}

################################################################

test_invalid_mapping_assess <- function(
    assess_function,
    dfInput,
    spec,
    mapping
) {
  mapping_edited <- mapping
  mapping_edited$dfInput$strSiteCol <- "cupcakes"
  invalid_map <- dfInput %>% assess_function(lMapping = mapping_edited)
  expect_null(invalid_map$lData)
  expect_null(invalid_map$lCharts)
  expect_equal(invalid_map[["lChecks"]][["dfInput"]][["tests_if"]][["has_expected_columns"]][["warning"]],
               "the following columns not found in df: cupcakes")
}

################################################################

test_identity <- function(
    assess_function,
    dfInput,
    spec,
    mapping
) {
  identity <- assess_function(dfInput, strMethod = "identity")
  expect_error(assess_function(dfInput, strMethod = "identity"), NA)
  expect_equal(names(identity$lCharts), c("barMetric", "barScore"))
  expect_null(identity$lCharts$scatter)
  expect_null(identity$lData$dfBounds)
}

################################################################

test_NA_count <- function(
    assess_function,
    dfInput,
    spec,
    mapping
) {
  dfInputNA <- dfInput
  dfInputNA[1, "Count"] <- NA
  count_check <- assess_function(dfInput = dfInputNA)
  expect_silent(count_check)
  expect_null(count_check$lData)
  expect_null(count_check$lCharts)
}

################################################################

test_logical_assess_parameters <- function(
    assess_function,
    dfInput
) {
  testthat::expect_snapshot(
    assessOutput <- assess_function(dfInput = dfInput, bQuiet = FALSE)
  )
}
