# Start testing
test_that("Visualize_Metric processes data correctly", {
  charts <- Visualize_Metric(reportingResults, reportingBounds, reportingGroups, reportingMetrics, strMetricID = "Analysis_kri0001")

  # Test if the function returns a list of charts
  expect_true(is.list(charts))

  # Test if the list contains expected chart names
  expect_true("scatterJS" %in% names(charts))
  expect_true("scatter" %in% names(charts))
  expect_true("barMetricJS" %in% names(charts))
  expect_true("barScoreJS" %in% names(charts))
  expect_true("barMetric" %in% names(charts))
  expect_true("barScore" %in% names(charts))
  expect_true("timeSeriesContinuousScoreJS" %in% names(charts))
  expect_true("timeSeriesContinuousMetricJS" %in% names(charts))
  expect_true("timeSeriesContinuousNumeratorJS" %in% names(charts))
  expect_true("metricTable" %in% names(charts))
})

test_that("Visualize_Metric handles missing MetricID", {
  charts <- Visualize_Metric(reportingResults, reportingBounds, reportingGroups, reportingMetrics, strMetricID = "Analysis_kri1000")

  # Test if the function returns NULL when MetricID is not found
  expect_null(charts)
})

test_that("Visualize_Metric handles multiple snapshots", {
  charts <- Visualize_Metric(reportingResults, reportingBounds, reportingGroups, reportingMetrics, strMetricID = "Analysis_kri0001")

  # Test if time series charts are generated when there are multiple snapshots
  expect_true("timeSeriesContinuousScoreJS" %in% names(charts))
  expect_true("timeSeriesContinuousMetricJS" %in% names(charts))
  expect_true("timeSeriesContinuousNumeratorJS" %in% names(charts))
})

test_that("Visualize_Metric can run on just results", {
  charts <- Visualize_Metric(filter(reportingResults, MetricID == "Analysis_kri0001"))

  # Test if the list contains expected chart names
  expect_true("scatterJS" %in% names(charts))
  expect_true("scatter" %in% names(charts))
  expect_true("barMetricJS" %in% names(charts))
  expect_true("barScoreJS" %in% names(charts))
  expect_true("barMetric" %in% names(charts))
  expect_true("barScore" %in% names(charts))
  expect_true("timeSeriesContinuousScoreJS" %in% names(charts))
  expect_true("timeSeriesContinuousMetricJS" %in% names(charts))
  expect_true("timeSeriesContinuousNumeratorJS" %in% names(charts))
  expect_true("metricTable" %in% names(charts))
})

test_that("Visualize_Metric can run on just results and MetricID", {
  charts <- Visualize_Metric(reportingResults, strMetricID = "Analysis_kri0001")

  # Test if the list contains expected chart names
  expect_true("scatterJS" %in% names(charts))
  expect_true("scatter" %in% names(charts))
  expect_true("barMetricJS" %in% names(charts))
  expect_true("barScoreJS" %in% names(charts))
  expect_true("barMetric" %in% names(charts))
  expect_true("barScore" %in% names(charts))
  expect_true("timeSeriesContinuousScoreJS" %in% names(charts))
  expect_true("timeSeriesContinuousMetricJS" %in% names(charts))
  expect_true("timeSeriesContinuousNumeratorJS" %in% names(charts))
  expect_true("metricTable" %in% names(charts))
})
