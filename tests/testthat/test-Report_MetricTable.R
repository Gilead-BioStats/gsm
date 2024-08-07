test_that("Empty data frames return default message", {
  dfResults_empty <- reportingResults[-c(1:nrow(reportingResults)), ]
  dfGroups_empty <- reportingGroups[-c(1:nrow(reportingGroups)), ]
  expect_equal(Report_MetricTable(dfResults_empty, dfGroups_empty), "Nothing flagged for this KRI.")
})

test_that("Correct data structure when proper dataframe is passed", {
  result <- Report_MetricTable(reportingResults, reportingGroups)
  expect_s3_class(result, "kableExtra")
  expect_true(grepl("<table", result))
  expect_true(grepl("162", result))
  expect_true(grepl("Kimler", result))
  expect_true(grepl("US", result))
  expect_true(grepl("Japan", result))
})

test_that("Flag filtering works correctly", {
  result <- Report_MetricTable(reportingResults, reportingGroups)
  expect_s3_class(result, "kableExtra")
  expect_false(grepl("Nkaujiaong", result))
})

test_that("Score rounding works correctly", {
  result <- Report_MetricTable(reportingResults, reportingGroups)
  expect_true(grepl("2.292", result))
})
