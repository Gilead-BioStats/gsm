source(testthat::test_path("testdata/data.R"))

assess_function <- gsm::LB_Assess
dfInput <- LB_Map_Raw(dfs = list(dfLB = dfLB, dfSUBJ = dfSUBJ))
output_spec <- yaml::read_yaml(system.file("specs", "LB_Assess.yaml", package = "gsm"))
output_mapping <- yaml::read_yaml(system.file("mappings", "LB_Assess.yaml", package = "gsm"))

# output is created as expected -------------------------------------------
test_that("output is created as expected", {
  assessment <- assess_function(dfInput)
  expect_true(is.list(assessment))
  expect_equal(names(assessment), c("lData", "lCharts", "lChecks"))
  expect_equal(names(assessment$lData), c("dfTransformed", "dfAnalyzed", "dfBounds", "dfFlagged", "dfSummary"))
  expect_true("data.frame" %in% class(assessment$lData$dfTransformed))
  expect_true("data.frame" %in% class(assessment$lData$dfAnalyzed))
  expect_true("data.frame" %in% class(assessment$lData$dfFlagged))
  expect_true("data.frame" %in% class(assessment$lData$dfSummary))
  expect_equal(names(assessment$lCharts), c("scatter", "barMetric", "barScore"))
  expect_true(assessment$lChecks$status)
})

# incorrect inputs throw errors -------------------------------------------
test_that("incorrect inputs throw errors", {
  expect_null(assess_function("Hi")[["lData"]])
  expect_snapshot_error(assess_function(dfInput, strMethod = 123))
  expect_snapshot_error(assess_function(dfInput, strMethod = "abacus"))
  expect_snapshot_error(assess_function(dfInput, strMethod = c("identity", "fisher")))
  expect_snapshot_error(assess_function(dfInput, vThreshold = "A"))
  expect_snapshot_error(assess_function(dfInput, vThreshold = 1))
  expect_error(assess_function(dfInput, strGroup = "something"))
})

# grouping works as expected ----------------------------------------------
test_that("grouping works as expected", {
  subsetGroupCols <- function(assessOutput) {
    assessOutput[["lData"]][["dfSummary"]] %>% select("GroupID")
  }

  site <- assess_function(dfInput)
  # this does not work because it creates a single group, causing stats model to error out.
  # TODO: should be addressed with new stats models in v1.3.0
  # study <- assess_function(dfInput, strGroup = "Study")
  country <- assess_function(dfInput, strGroup = "Country")
  customGroup <- assess_function(dfInput, strGroup = "CustomGroup")

  expect_snapshot(subsetGroupCols(site))
  expect_snapshot(subsetGroupCols(country))
  expect_snapshot(subsetGroupCols(customGroup))
  expect_false(all(map_lgl(list(site, country, customGroup), ~ all(map_lgl(., ~ is_grouped_df(.))))))
})

# custom tests ------------------------------------------------------------
test_that("strMethod = 'identity' works as expected", {
  identity <- assess_function(dfInput, strMethod = "identity")
  expect_error(assess_function(dfInput, strMethod = "identity"), NA)
  expect_equal(names(identity$lCharts), c("barMetric", "barScore"))
  expect_null(identity$lCharts$scatter)
  expect_null(identity$lData$dfBounds)
})

test_that("bQuiet works as intended", {
  test_logical_assess_parameters(assess_function, dfInput)
})
