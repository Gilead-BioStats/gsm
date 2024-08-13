dummy_chart <- htmltools::tags$div("dummy chart content")

test_that("Handles all supported chart types", {
  lCharts <- list(
    scatterJS = dummy_chart,
    barMetricJS = dummy_chart,
    barScoreJS = dummy_chart,
    timeSeriesContinuousScoreJS = dummy_chart,
    timeSeriesContinuousMetricJS = dummy_chart,
    timeSeriesContinuousNumeratorJS = dummy_chart,
    timeseriesQtl = dummy_chart
  )

  expect_output(Report_MetricCharts(lCharts), "#### Summary Charts \\{.tabset\\}")
  expect_output(Report_MetricCharts(lCharts), "Summary")
  expect_output(Report_MetricCharts(lCharts), "KRI Score")
  expect_output(Report_MetricCharts(lCharts), "KRI Metric")
  expect_output(Report_MetricCharts(lCharts), "Numerator")
})

test_that("Handles some missing chart types", {
  lCharts <- list(
    scatterJS = dummy_chart,
    barMetricJS = dummy_chart,
    timeSeriesContinuousMetricJS = dummy_chart
  )

  expect_output(Report_MetricCharts(lCharts), "Summary")
  expect_output(Report_MetricCharts(lCharts), "KRI Metric")
  expect_output(Report_MetricCharts(lCharts), "#### Summary Charts \\{.tabset\\}")
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
    scatterJS = dummy_chart,
    barScoreJS = dummy_chart
  )

  output <- capture.output(Report_MetricCharts(lCharts))
  expect_true(any(grepl("Summary", output)))
  expect_true(any(grepl("KRI Score", output)))
  expect_true(any(grepl("<div class", output)))
  expect_true(any(grepl("</div>", output)))
})
