test_that("Visualize_Metric processes data correctly", {
  expect_message(
    {
      charts <- Visualize_Metric(
        reportingResults,
        reportingBounds,
        reportingGroups,
        reportingMetrics,
        strMetricID = "Analysis_kri0001"
      )
    },
    "Parsed"
  )

  # Test if the function returns a list of charts
  expect_true(is.list(charts))

  # Test if the list contains expected chart names
  expect_true("scatterPlot" %in% names(charts))
  expect_true("barChart" %in% names(charts))
  expect_true("timeSeries" %in% names(charts))
  expect_true("metricTable" %in% names(charts))
})

test_that("Visualize_Metric handles missing MetricID", {
  expect_message(
    {
      charts <- Visualize_Metric(
        reportingResults,
        reportingBounds,
        reportingGroups,
        reportingMetrics,
        strMetricID = "Analysis_kri1000"
      )
    },
    "MetricID not found"
  )

  # Test if the function returns NULL when MetricID is not found
  expect_null(charts)
})

test_that("Visualize_Metric handles multiple snapshots", {
  expect_message(
    {
      charts <- Visualize_Metric(
        reportingResults,
        reportingBounds,
        reportingGroups,
        reportingMetrics,
        strMetricID = "Analysis_kri0001"
      )
    },
    "Parsed"
  )

  # Test if time series charts are generated when there are multiple snapshots
  expect_true("timeSeries" %in% names(charts))
})

test_that("Visualize_Metric can run on just results", {
  charts <- Visualize_Metric(filter(reportingResults, MetricID == "Analysis_kri0001"))

  # Test if the list contains expected chart names
  expect_true("scatterPlot" %in% names(charts))
  expect_true("barChart" %in% names(charts))
  expect_true("timeSeries" %in% names(charts))
  expect_true("metricTable" %in% names(charts))
})

test_that("Visualize_Metric can run on just results and MetricID", {
  expect_message(
    {
      expect_message(
        {
          charts <- Visualize_Metric(reportingResults, strMetricID = "Analysis_kri0001")
        },
        "MetricID not found in dfBounds"
      )
    },
    "MetricID not found in dfMetrics"
  )

  # Test if the list contains expected chart names
  expect_true("scatterPlot" %in% names(charts))
  expect_true("barChart" %in% names(charts))
  expect_true("timeSeries" %in% names(charts))
  expect_true("metricTable" %in% names(charts))
})

test_that("Visualize_Metric works with bad dfBounds", {
  expect_message(
    {
      expect_message(
        {
          charts <- Visualize_Metric(
            reportingResults,
            strMetricID = "Analysis_kri0001",
            dfMetrics = reportingMetrics,
            dfBounds = dplyr::filter(reportingBounds, MetricID != "Analysis_kri0001")
          )
        },
        "MetricID not found in dfBounds"
      )
    },
    "Parsed -2,-1,2,3 to numeric vector"
  )
})
