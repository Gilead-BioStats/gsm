test_valid_output_assess_poisson <- function(
    assess_function,
    dfInput
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

test_valid_output_assess_identity <- function(
    assess_function,
    dfInput
) {
  output <- assess_function(dfInput = dfInput)

  testthat::expect_true(is.list(output))
  testthat::expect_equal(names(output), c("lData", "lCharts", "lChecks"))
  testthat::expect_equal(names(output$lData), c("dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
  testthat::expect_equal(names(output$lCharts), c("barMetric", "barScore"))
  testthat::expect_true("data.frame" %in% class(output$lData$dfTransformed))
  testthat::expect_true("data.frame" %in% class(output$lData$dfAnalyzed))
  testthat::expect_true("data.frame" %in% class(output$lData$dfFlagged))
  testthat::expect_true("data.frame" %in% class(output$lData$dfSummary))
  testthat::expect_true(output$lChecks$status)

}

################################################################

test_valid_output_assess_fisher <- function(
    assess_function,
    dfInput
) {
  output <- assess_function(dfInput = dfInput)

  testthat::expect_true(is.list(output))
  testthat::expect_equal(names(output), c("lData", "lCharts", "lChecks"))
  testthat::expect_equal(names(output$lData), c("dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
  testthat::expect_equal(names(output$lCharts), c("scatter", "barMetric", "barScore"))
  testthat::expect_true("data.frame" %in% class(output$lData$dfTransformed))
  testthat::expect_true("data.frame" %in% class(output$lData$dfAnalyzed))
  testthat::expect_true("data.frame" %in% class(output$lData$dfFlagged))
  testthat::expect_true("data.frame" %in% class(output$lData$dfSummary))
  testthat::expect_true(output$lChecks$status)

}

################################################################

test_grouping_assess <- function(
    assess_function,
    dfInput
) {
  subsetGroupCols <- function(assessOutput) {
    assessOutput[["lData"]][["dfSummary"]] %>% select("GroupID")
  }
  site <- assess_function(dfInput)
  study <- assess_function(dfInput, strGroup = "Study")
  country <- assess_function(dfInput, strGroup = "Country")
  customGroup <- assess_function(dfInput, strGroup = "CustomGroup")

  testthat::expect_snapshot(subsetGroupCols(site))
  testthat::expect_snapshot(subsetGroupCols(study))
  testthat::expect_snapshot(subsetGroupCols(country))
  testthat::expect_snapshot(subsetGroupCols(customGroup))
  testthat::expect_false(all(map_lgl(list(site, study, country, customGroup), ~ all(map_lgl(., ~ is_grouped_df(.))))))
}

################################################################

test_invalid_data_assess <- function(
    assess_function,
    dfInput
) {
  testthat::expect_null(assess_function("Hi")[["lData"]])
  testthat::expect_snapshot_error(assess_function(dfInput, strMethod = 123))
  testthat::expect_snapshot_error(assess_function(dfInput, strMethod = "abacus"))
  testthat::expect_snapshot_error(assess_function(dfInput, strMethod = c("identity", "poisson")))
  testthat::expect_snapshot_error(assess_function(dfInput, vThreshold = "A"))
  testthat::expect_snapshot_error(assess_function(dfInput, vThreshold = 1))
  testthat::expect_error(assess_function(dfInput, strGroup = "something"))
}

################################################################

test_invalid_data_assess_identity <- function(
    assess_function,
    dfInput
) {
  testthat::expect_null(assess_function("Hi")[["lData"]])
  testthat::expect_error(assess_function(dfInput, nThreshold = FALSE), "nThreshold must be numeric")
  testthat::expect_error(assess_function(dfInput, nThreshold = "A"), "nThreshold must be numeric")
  testthat::expect_error(assess_function(dfInput, nThreshold = c(1, 1)), "nThreshold must be length 1")
  testthat::expect_error(assess_function(dfInput, strGroup = "something"), "strGroup must be one of: Site, Study, Country, or CustomGroup")
}

################################################################

test_missing_column_assess <- function(
    assess_function,
    dfInput
) {
  dfInput_test <- dfInput %>% select(-c(SiteID))
  missing_req_col <- assess_function(dfInput = dfInput_test)

  testthat::expect_silent(missing_req_col)
  testthat::expect_null(missing_req_col$lData)
  testthat::expect_null(missing_req_col$lCharts)
}

################################################################

test_invalid_mapping_assess <- function(
    assess_function,
    dfInput,
    mapping
) {
  mapping_edited <- mapping
  mapping_edited$dfInput$strSiteCol <- "cupcakes"
  invalid_map <- dfInput %>% assess_function(lMapping = mapping_edited)

  testthat::expect_null(invalid_map$lData)
  testthat::expect_null(invalid_map$lCharts)
  testthat::expect_equal(invalid_map[["lChecks"]][["dfInput"]][["tests_if"]][["has_expected_columns"]][["warning"]],
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

  testthat::expect_error(assess_function(dfInput, strMethod = "identity"), NA)
  testthat::expect_equal(names(identity$lCharts), c("barMetric", "barScore"))
  testthat::expect_null(identity$lCharts$scatter)
  testthat::expect_null(identity$lData$dfBounds)
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

  testthat::expect_silent(count_check)
  testthat::expect_null(count_check$lData)
  testthat::expect_null(count_check$lCharts)
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
