test_that("Empty data frames return default message", {
  dfResults_empty <- sampleResults[-c(1:nrow(sampleResults)),]
  dfGroups_empty <- sampleGroups[-c(1:nrow(sampleGroups)),]
  expect_equal(Report_MetricTable(dfResults_empty, dfGroups_empty), "Nothing flagged for this KRI.")
})

test_that("Correct data structure when proper dataframe is passed", {
  result <- Report_MetricTable(sampleResults, sampleGroups)
  expect_s3_class(result, "kableExtra")
  expect_true(grepl("<table", result))
  expect_true(grepl("100", result))
  expect_true(grepl("Lamping", result))
  expect_true(grepl("US", result))
  expect_true(grepl("Japan", result))
})

test_that("Flag filtering works correctly", {
  result <- Report_MetricTable(sampleResults, sampleGroups)
  expect_s3_class(result, "kableExtra")
  expect_false(grepl("Gonzalez", result))
})

test_that("Score rounding works correctly", {
  result <- Report_MetricTable(sampleResults, sampleGroups)
  expect_true(grepl("2.673", result))
})

