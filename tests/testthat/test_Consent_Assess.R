source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::Consent_Assess
dfInput <- Consent_Map_Raw(dfs = list(dfCONSENT = dfCONSENT, dfSUBJ = dfSUBJ))
output_spec <- yaml::read_yaml(system.file("specs", "Consent_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "Consent_Assess.yaml", package = "gsm"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment <- assess_function(dfInput)
  expect_true(is.list(assessment))
  expect_equal(names(assessment), c("lData", "lCharts", "lChecks"))
  expect_equal(names(assessment$lData), c("dfTransformed", "dfAnalyzed", "dfFlagged", "dfSummary"))
  expect_true("data.frame" %in% class(assessment$lData$dfTransformed))
  expect_true("data.frame" %in% class(assessment$lData$dfAnalyzed))
  expect_true("data.frame" %in% class(assessment$lData$dfFlagged))
  expect_true("data.frame" %in% class(assessment$lData$dfSummary))
  expect_equal(names(assessment$lCharts), c("barMetric", "barScore"))
  expect_true(assessment$lChecks$status)
})


# grouping works as expected ----------------------------------------------
test_that("grouping works as expected", {
  subsetGroupCols <- function(assessOutput) {
    assessOutput[["lData"]][["dfSummary"]] %>% select("GroupID")
  }

  site <- assess_function(dfInput)
  study <- assess_function(dfInput, strGroup = "Study")
  customGroup <- assess_function(dfInput, strGroup = "CustomGroup")

  expect_snapshot(subsetGroupCols(site))
  expect_snapshot(subsetGroupCols(study))
  expect_snapshot(subsetGroupCols(customGroup))
  expect_false(all(map_lgl(list(site, study, customGroup), ~ all(map_lgl(., ~ is_grouped_df(.))))))
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_null(assess_function("Hi")[["lData"]])
  expect_error(assess_function(dfInput, nThreshold = "A"), "nThreshold must be numeric")
  expect_error(assess_function(dfInput, nThreshold = c(1, 1)), "nThreshold must be length 1")
  expect_error(assess_function(dfInput, strGroup = "something"), "strGroup must be one of: Site, Study, or CustomGroup")
})


# custom tests ------------------------------------------------------------
test_that("bQuiet works as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})
