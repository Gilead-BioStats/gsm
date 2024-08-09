test_that("Empty data frames return default message", {
  dfResults_empty <- reportingResults[-c(1:nrow(reportingResults)), ]
  dfGroups_empty <- reportingGroups[-c(1:nrow(reportingGroups)), ]
  expect_equal(Report_MetricTable(dfResults_empty, dfGroups_empty), "Nothing flagged for this KRI.")
})

test_that("Correct data structure when proper dataframe is passed", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "kableExtra")
  expect_true(grepl("<table", result))
  expect_true(grepl("162", result))
  expect_true(grepl("Kimler", result))
})

test_that("Flag filtering works correctly", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "kableExtra")
  expect_false(grepl("Nkaujiaong", result))
})

test_that("Score rounding works correctly", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_true(grepl("0.05", result))
})

test_that("Errors out when multiple MetricIDs passed in", {
  expect_error(Report_MetricTable(reportingResults, reportingGroups))
})
