test_that("Empty dfs return empty dfs", {
  dfResults_empty <- head(reportingResults, 0)
  dfGroups_empty <- head(reportingGroups, 0)
  expect_equal(
    MakeMetricTable(dfResults_empty, dfGroups_empty),
    data.frame(
      Group = character(),  Enrolled = character(), Numerator = double(),
      Denominator = double(), Metric = double(), Score = double(),
      Flag = character()
    )
  )
})

test_that("Correct data structure when proper dataframe is passed", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[[1]])
  result <- MakeMetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "data.frame")
  expect_setequal(
    colnames(result),
    c("Group", "Enrolled", "Numerator", "Denominator", "Metric", "Score", "Flag")
  )
})

test_that("Flag filtering works correctly", {
  # Verify that our test user is still in sample data.
  expect_gt(
    length(grep("Nkaujiaong", reportingGroups$Value)),
    0
  )
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[[1]])
  result <- MakeMetricTable(reportingResults_filt, reportingGroups)
  expect_s3_class(result, "data.frame")
  expect_length(
    grep("Nkaujiaong", result$Group),
    0
  )
})

test_that("Score rounding works correctly", {
  reportingResults_filt <- reportingResults %>%
    dplyr::filter(MetricID == unique(reportingResults$MetricID)[[1]])
  result <- MakeMetricTable(reportingResults_filt, reportingGroups)
  expect_true(any(grepl("3.02", as.character(result$Score))))
})

test_that("Errors informatively when multiple MetricIDs passed in", {
  expect_error(
    MakeMetricTable(reportingResults, reportingGroups),
    class = "gsm_error-multiple_values"
  )
})
