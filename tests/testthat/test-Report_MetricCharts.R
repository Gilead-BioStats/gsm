dummy_chart <- htmltools::tags$div("dummy chart content")

test_that("Handles all supported chart types", {
  lCharts <- list(
    scatterPlot = dummy_chart,
    barChart = dummy_chart,
    timeSeries = dummy_chart
  )

  expect_output(Report_MetricCharts(lCharts), "#### Summary Charts \\{.tabset\\}")
  expect_output(Report_MetricCharts(lCharts), "Scatter Plot")
  expect_output(Report_MetricCharts(lCharts), "Bar Chart")
  expect_output(Report_MetricCharts(lCharts), "Time Series")
})

test_that("Handles some missing chart types", {
  lCharts <- list(
    scatterPlot = dummy_chart,
    timeSeries = dummy_chart
  )

  expect_output(Report_MetricCharts(lCharts), "#### Summary Charts \\{.tabset\\}")
  expect_output(Report_MetricCharts(lCharts), "Scatter Plot")
  expect_output(Report_MetricCharts(lCharts), "Time Series")
})

test_that("Ignores unsupported chart types", {
  lCharts <- list(
    unsupportedChart1 = dummy_chart,
    unsupportedChart2 = dummy_chart
  )

  expect_output(Report_MetricCharts(lCharts), "#### Summary Charts \\{.tabset\\}")
  expect_output(Report_MetricCharts(lCharts), "#### {-}")
})

test_that("Handles empty input", {
  lCharts <- list()

  expect_output(Report_MetricCharts(lCharts), "#### Summary Charts \\{.tabset\\}")
  expect_output(Report_MetricCharts(lCharts), "#### {-}")
})

test_that("Output formatting and no errors", {
  lCharts <- list(
    scatterPlot = dummy_chart,
    barChart = dummy_chart
  )

  output <- capture.output(Report_MetricCharts(lCharts))
  expect_true(any(grepl("Scatter Plot", output)))
  expect_true(any(grepl("Bar Chart", output)))
  expect_true(any(grepl("<div class", output)))
  expect_true(any(grepl("</div>", output)))
})
