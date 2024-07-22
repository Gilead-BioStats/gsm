test_that("Widget_ScatterPlot handles dfResults correctly", {
  widget <- Widget_ScatterPlot(reportingResults,
                               reportingMetrics %>% as.list())

  expect_true(inherits(widget, "htmlwidget"))
  expect_true("Widget_ScatterPlot" %in% class(widget))

  widget_data <- widget$x$dfResults
  dfSummary_json <- jsonlite::toJSON(reportingResults, na = "string")

  expect_equal(widget_data, dfSummary_json)
})

test_that("Widget_ScatterPlot processes dfBounds correctly", {
  widget <- Widget_ScatterPlot(reportingResults,
                               reportingMetrics %>% as.list(),
                               dfBounds = reportingBounds)

  dfBounds_json <- jsonlite::toJSON(reportingBounds)
  expect_equal(widget$x$dfBounds, dfBounds_json)
})

test_that("Widget_ScatterPlot processes dfGroups correctly", {
  widget <- Widget_ScatterPlot(dfResults = reportingResults,
                               lMetric = reportingMetrics %>% as.list(),
                               dfGroups = reportingGroups)

  dfGroups_json <- jsonlite::toJSON(reportingGroups, na = "string")
  expect_equal(widget$x$dfGroups, dfGroups_json)
})



