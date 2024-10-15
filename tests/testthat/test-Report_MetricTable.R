test_that("Empty data frames return default message", {
  dfResults_empty <- reportingResults[-c(1:nrow(reportingResults)), ]
  dfGroups_empty <- reportingGroups[-c(1:nrow(reportingGroups)), ]
  expect_equal(
    Report_MetricTable(dfResults_empty, dfGroups_empty),
    "Nothing flagged for this KRI."
  )
})

test_that("Default message when nothing flagged", {
  dfResults <- dplyr::filter(
    reportingResults,
    MetricID == "kri0001",
    Flag == 0
  )
  dfGroups <- reportingGroups
  expect_equal(
    Report_MetricTable(dfResults, dfGroups),
    "Nothing flagged for this KRI."
  )
})

test_that("Correct data structure when proper dataframe is passed", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "gt_tbl")
  expect_true(any(grepl("162", result)))
  expect_true(any(grepl("Kimler", result)))
})

test_that("Flag filtering works correctly", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "gt_tbl")
  expect_false(any(grepl("Nkaujiaong", result)))
})

test_that("Score rounding works correctly", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt, reportingGroups)
  expect_true(any(grepl("0.05", result)))
})

test_that("Errors out when multiple MetricIDs passed in", {
  expect_error(Report_MetricTable(reportingResults, reportingGroups))
})

test_that("Runs with just results with NULL group argument", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[1])
  result <- Report_MetricTable(reportingResults_filt)
  expect_s3_class(result, "gt_tbl")
})
